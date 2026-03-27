import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/attraction_game_state.dart';
import '../providers/attractions_state.dart';
import '../widgets/attraction_card.dart';
import 'attraction_deck_selector_screen.dart';

/// Attractions Deck tool screen - Attraction management for Unfinity mechanics
class AttractionsScreen extends StatelessWidget {
  const AttractionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AttractionsState>();

    if (!state.isLoaded) {
      return Scaffold(
        appBar: _buildBaseAppBar(context),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (!state.hasActiveGame) {
      return _NoGameView();
    }

    return _ActiveGameView();
  }

  PreferredSizeWidget _buildBaseAppBar(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      toolbarHeight: 40,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Attractions Deck',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// View shown when no deck is loaded
class _NoGameView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Attractions Deck',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'No deck loaded',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AttractionDeckSelectorScreen(),
                ),
              ),
              child: const Text('Select a deck'),
            ),
          ],
        ),
      ),
    );
  }
}

/// View shown when a deck is loaded and game is active
class _ActiveGameView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<AttractionsState>();
    final gameState = state.gameState!;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          gameState.deckName,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt, size: 20),
            tooltip: 'Reset game',
            onPressed: () => _showResetDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Status bar
            _GameStatusBar(state: state),
            // Battlefield
            Expanded(
              child: state.battlefield.isEmpty
                  ? Center(
                      child: Text(
                        'No attractions on the battlefield',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      itemCount: state.battlefield.length,
                      itemBuilder: (context, index) {
                        return AttractionCard(
                          openAttraction: state.battlefield[index],
                          index: index,
                          onJunkyard: () =>
                              context.read<AttractionsState>().junkyardAttraction(index),
                          onExile: () =>
                              context.read<AttractionsState>().exileAttraction(index),
                          onTogglePrize: () =>
                              context.read<AttractionsState>().togglePrizeClaimed(index),
                        );
                      },
                    ),
            ),
            // Action buttons
            _ActionButtons(state: state),
          ],
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset game?'),
        content: const Text(
          'This will return all attractions to the deck and reshuffle.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<AttractionsState>().resetGame();
              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

/// Status bar showing deck count, junkyard, and exile
class _GameStatusBar extends StatelessWidget {
  final AttractionsState state;

  const _GameStatusBar({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          // Deck remaining
          Chip(
            avatar: const Icon(Icons.layers, size: 16),
            label: Text('Deck: ${state.deckRemaining}'),
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: 8),
          // Junkyard
          TextButton.icon(
            onPressed: state.junkyard.isEmpty
                ? null
                : () => _showJunkyardSheet(context),
            icon: const Icon(Icons.delete_outline, size: 16),
            label: Text('Junkyard (${state.junkyard.length})'),
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
            ),
          ),
          const Spacer(),
          // Exile count
          if (state.exile.isNotEmpty)
            Text(
              'Exile (${state.exile.length})',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }

  void _showJunkyardSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => _JunkyardSheet(state: state),
    );
  }
}

/// Bottom sheet showing junkyard contents
class _JunkyardSheet extends StatelessWidget {
  final AttractionsState state;

  const _JunkyardSheet({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Junkyard (${state.junkyard.length} cards)',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: state.junkyard.length,
              itemBuilder: (context, index) {
                final entry = state.junkyard[index];
                return ListTile(
                  dense: true,
                  title: Text(entry.attractionName),
                  trailing: AttractionLightsRow(
                    lights: entry.attractionLights,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () {
                context.read<AttractionsState>().shuffleJunkyardIntoDeck();
                Navigator.pop(context);
              },
              child: const Text('Shuffle into deck'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Sticky action buttons at the bottom
class _ActionButtons extends StatelessWidget {
  final AttractionsState state;

  const _ActionButtons({required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: FilledButton(
              onPressed: state.canOpenAttraction
                  ? () => context.read<AttractionsState>().openAttraction()
                  : null,
              child: const Text('Open an Attraction'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: state.battlefield.isNotEmpty
                  ? () => _rollToVisit(context)
                  : null,
              child: const Text('Roll to Visit'),
            ),
          ),
        ],
      ),
    );
  }

  void _rollToVisit(BuildContext context) {
    final attractionsState = context.read<AttractionsState>();
    final roll = attractionsState.rollToVisit();
    final visited = attractionsState.getVisitedAttractions(roll);

    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => _RollResultSheet(
        roll: roll,
        visited: visited,
      ),
    );
  }
}

/// Bottom sheet showing roll result
class _RollResultSheet extends StatelessWidget {
  final int roll;
  final List<OpenAttraction> visited;

  const _RollResultSheet({
    required this.roll,
    required this.visited,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$roll',
            style: theme.textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Roll result',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          if (visited.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'No attractions visited',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else
            ...visited.map(
              (oa) => ListTile(
                dense: true,
                title: Text(
                  oa.entry.attractionName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(oa.entry.oracleText),
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
