import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/attractions_state.dart';
import '../widgets/mana_icons.dart';
import 'attraction_deck_builder_screen.dart';

/// Screen for selecting, managing, and loading attraction decks
class AttractionDeckSelectorScreen extends StatelessWidget {
  const AttractionDeckSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<AttractionsState>();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Attraction Decks',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 20),
            tooltip: 'New deck',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AttractionDeckBuilderScreen(),
              ),
            ),
          ),
        ],
      ),
      body: state.decks.isEmpty
          ? _EmptyState()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              itemCount: state.decks.length,
              itemBuilder: (context, index) {
                final deck = state.decks[index];
                return Card(
                  child: ListTile(
                    title: Row(
                      children: [
                        Flexible(
                          child: Text(
                            deck.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (deck.containsAcorn)
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Icon(
                              ManaIcons.acorn,
                              size: 14,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                    subtitle: Text('${deck.entries.length} attractions'),
                    trailing: PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      onSelected: (value) {
                        if (value == 'edit') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AttractionDeckBuilderScreen(deck: deck),
                            ),
                          );
                        } else if (value == 'delete') {
                          _showDeleteDialog(context, deck.id, deck.name);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                    onTap: () {
                      context.read<AttractionsState>().loadDeck(deck.id);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, String deckId, String deckName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete deck?'),
        content: Text('Delete "$deckName"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<AttractionsState>().deleteDeck(deckId);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'No saved decks',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AttractionDeckBuilderScreen(),
              ),
            ),
            child: const Text('Create your first deck'),
          ),
        ],
      ),
    );
  }
}
