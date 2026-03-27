import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dungeon.dart';
import '../providers/dungeons_state.dart';
import '../widgets/cached_artwork_image.dart';
import '../widgets/dungeon_room_tile.dart';

/// Dungeons tool screen - Dungeon venture tracking for D&D-themed MTG sets.
///
/// Two states:
/// - No active dungeon: shows dungeon selection list with initiative toggle
/// - Active dungeon: shows dungeon map with room tiles and venture button
class DungeonsScreen extends StatelessWidget {
  const DungeonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DungeonsState>();

    if (!state.isLoaded) {
      return Scaffold(
        appBar: _buildBaseAppBar(context),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (!state.hasActiveDungeon) {
      return _DungeonSelectionView();
    }

    return _ActiveDungeonView();
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
        'Dungeons',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Dungeon Selection View
// ---------------------------------------------------------------------------

/// Shown when no dungeon is active. Lists available dungeons with initiative
/// toggle and completion counts.
class _DungeonSelectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<DungeonsState>();
    final available = state.availableDungeons;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Dungeons',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          // Initiative toggle
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Initiative',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white70,
                ),
              ),
              Switch(
                value: state.hasInitiative,
                onChanged: (_) =>
                    context.read<DungeonsState>().toggleInitiative(),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
          // Reset button
          IconButton(
            icon: const Icon(Icons.restart_alt, size: 20),
            tooltip: 'Reset all',
            onPressed: () => _showResetDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Global completion count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                'Dungeons completed: ${state.globalCompletionCount}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const Divider(height: 1),
            // Dungeon list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 4, bottom: 4),
                itemCount: available.length,
                itemBuilder: (context, index) {
                  final dungeon = available[index];
                  return _DungeonListTile(dungeon: dungeon);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset all dungeon data?'),
        content: const Text(
          'This will clear all completion counts, initiative, and active dungeon progress.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<DungeonsState>().resetAll();
              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

/// A single dungeon entry in the selection list.
class _DungeonListTile extends StatelessWidget {
  final Dungeon dungeon;

  const _DungeonListTile({required this.dungeon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<DungeonsState>();
    final completions = state.completionCountFor(dungeon.id);
    final isUndercity = dungeon.id == 'undercity';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.read<DungeonsState>().selectDungeon(dungeon.id),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Dungeon info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            dungeon.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (isUndercity) ...[
                          const SizedBox(width: 6),
                          Text(
                            '(Initiative only)',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${dungeon.rooms.length} rooms'
                      '${completions > 0 ? '  ·  Completed $completions${completions == 1 ? ' time' : ' times'}' : ''}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // Preview button
              IconButton(
                icon: const Icon(Icons.image_outlined, size: 20),
                tooltip: 'Preview card',
                onPressed: () => _showPreview(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPreview(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 560),
          child: CachedArtworkImage(
            imageUrl: dungeon.scryfallImageUrl,
            fit: BoxFit.contain,
            placeholder: const SizedBox(
              height: 400,
              child: Center(child: CircularProgressIndicator()),
            ),
            errorWidget: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Failed to fetch from Scryfall. Card text:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    dungeon.oracleText,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Active Dungeon View (Map)
// ---------------------------------------------------------------------------

/// Shown when a dungeon is active. Displays the room map, current position,
/// and venture/complete controls.
class _ActiveDungeonView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<DungeonsState>();
    final dungeon = state.activeDungeon!;
    final currentRoom = state.currentRoom;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => context.read<DungeonsState>().abandonDungeon(),
        ),
        title: Text(
          dungeon.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          if (state.isOnBottomRoom)
            TextButton(
              onPressed: () => _completeDungeon(context),
              child: Text(
                'Complete',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              tooltip: 'Abandon dungeon',
              onPressed: () => _showAbandonDialog(context),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable dungeon map
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: _DungeonMap(
                  dungeon: dungeon,
                  currentRoom: currentRoom,
                  nextRoomIds: state.nextRooms.map((r) => r.id).toSet(),
                  onVenture: (roomId) =>
                      context.read<DungeonsState>().venture(roomId),
                ),
              ),
            ),
            // Fixed venture/complete button at bottom
            _VentureButton(state: state),
          ],
        ),
      ),
    );
  }

  void _showAbandonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Abandon dungeon?'),
        content: const Text('Progress will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<DungeonsState>().abandonDungeon();
              Navigator.pop(context);
            },
            child: const Text('Abandon'),
          ),
        ],
      ),
    );
  }

  void _completeDungeon(BuildContext context) {
    context.read<DungeonsState>().completeDungeon();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dungeon completed!'),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Dungeon Map
// ---------------------------------------------------------------------------

/// Renders the full dungeon map as a vertical stack of tier rows with
/// connection indicators between tiers.
class _DungeonMap extends StatelessWidget {
  final Dungeon dungeon;
  final DungeonRoom? currentRoom;
  final Set<String> nextRoomIds;
  final ValueChanged<String> onVenture;

  const _DungeonMap({
    required this.dungeon,
    required this.currentRoom,
    required this.nextRoomIds,
    required this.onVenture,
  });

  @override
  Widget build(BuildContext context) {
    final tiers = dungeon.roomsByTier;
    final sortedTierKeys = tiers.keys.toList()..sort();
    final currentTier = currentRoom?.tier;

    final children = <Widget>[];

    for (int i = 0; i < sortedTierKeys.length; i++) {
      final tierKey = sortedTierKeys[i];
      final rooms = tiers[tierKey]!;

      // Room row
      children.add(
        Row(
          children: [
            for (int j = 0; j < rooms.length; j++) ...[
              if (j > 0) const SizedBox(width: 8),
              Expanded(
                child: DungeonRoomTile(
                  room: rooms[j],
                  isActive: rooms[j].id == currentRoom?.id,
                  isVisited: currentTier != null && tierKey < currentTier,
                  onTap: nextRoomIds.contains(rooms[j].id)
                      ? () => onVenture(rooms[j].id)
                      : null,
                ),
              ),
            ],
          ],
        ),
      );

      // Connection indicators between tiers
      if (i < sortedTierKeys.length - 1) {
        children.add(
          _TierConnectors(
            fromRooms: rooms,
            toRooms: tiers[sortedTierKeys[i + 1]]!,
          ),
        );
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

/// Simple arrow indicators between tiers showing which rooms connect.
class _TierConnectors extends StatelessWidget {
  final List<DungeonRoom> fromRooms;
  final List<DungeonRoom> toRooms;

  const _TierConnectors({
    required this.fromRooms,
    required this.toRooms,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final toRoomIds = toRooms.map((r) => r.id).toSet();

    // Check if any room in fromRooms leads to any room in toRooms
    final hasConnections = fromRooms.any(
      (r) => r.leadsTo.any((id) => toRoomIds.contains(id)),
    );

    if (!hasConnections) {
      return const SizedBox(height: 8);
    }

    // For simple layouts, show centered down arrows
    // Count how many distinct connection paths exist
    final connectionCount = fromRooms
        .expand((r) => r.leadsTo)
        .where((id) => toRoomIds.contains(id))
        .toSet()
        .length;

    if (fromRooms.length == 1 && toRooms.length == 1) {
      // Single path: one centered arrow
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Center(
          child: Icon(
            Icons.arrow_downward,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
        ),
      );
    }

    // Multiple rooms: show arrows spread across the row width
    // Position arrows under/above rooms that are connected
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          for (int i = 0; i < fromRooms.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(
              child: Center(
                child: fromRooms[i].leadsTo.any((id) => toRoomIds.contains(id))
                    ? _buildArrows(
                        context, fromRooms[i], toRooms, connectionCount)
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildArrows(BuildContext context, DungeonRoom from,
      List<DungeonRoom> targets, int totalConnections) {
    final theme = Theme.of(context);
    final arrowColor = theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6);
    final targetIds =
        from.leadsTo.where((id) => targets.any((t) => t.id == id)).toList();

    if (targetIds.length == 1) {
      return Icon(
        Icons.arrow_downward,
        size: 16,
        color: arrowColor,
      );
    }

    // Branching: evenly spaced containers with centered arrows
    return Row(
      children: [
        for (int i = 0; i < targetIds.length; i++)
          Expanded(
            child: Center(
              child: Icon(
                Icons.arrow_downward,
                size: 14,
                color: arrowColor,
              ),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Venture Button
// ---------------------------------------------------------------------------

/// Fixed button at the bottom for advancing through the dungeon.
class _VentureButton extends StatelessWidget {
  final DungeonsState state;

  const _VentureButton({required this.state});

  @override
  Widget build(BuildContext context) {
    final isBottom = state.isOnBottomRoom;
    final nextRooms = state.nextRooms;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: isBottom
              ? () => _completeDungeon(context)
              : nextRooms.isNotEmpty
                  ? () => _venture(context, nextRooms)
                  : null,
          child: Text(isBottom ? 'Complete Dungeon' : 'Venture'),
        ),
      ),
    );
  }

  void _completeDungeon(BuildContext context) {
    context.read<DungeonsState>().completeDungeon();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dungeon completed!'),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _venture(BuildContext context, List<DungeonRoom> nextRooms) {
    if (nextRooms.length == 1) {
      // Auto-advance when only one path
      context.read<DungeonsState>().venture(nextRooms.first.id);
      return;
    }

    // Multiple choices: show selection bottom sheet
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => _RoomChoiceSheet(nextRooms: nextRooms),
    );
  }
}

/// Bottom sheet for choosing between multiple next rooms when venturing.
class _RoomChoiceSheet extends StatelessWidget {
  final List<DungeonRoom> nextRooms;

  const _RoomChoiceSheet({required this.nextRooms});

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
            'Choose your path',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...nextRooms.map(
            (room) => ListTile(
              dense: true,
              title: Text(
                room.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                room.effect,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                context.read<DungeonsState>().venture(room.id);
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
