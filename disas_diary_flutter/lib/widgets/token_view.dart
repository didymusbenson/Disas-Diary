import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item.dart';
import '../providers/app_state.dart';

/// Widget for displaying and managing a token/card
class TokenView extends StatelessWidget {
  final Item item;

  const TokenView({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();

    return Card(
      margin: const EdgeInsets.all(2),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row - Name, Tapped/Untapped counts
            Row(
              children: [
                Text(
                  item.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                // Untapped icon and count
                const Icon(Icons.mobile_friendly, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${item.amount - item.tapped}',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(width: 8),
                // Tapped icon and count
                const Icon(Icons.screen_rotation, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${item.tapped}',
                  style: theme.textTheme.titleLarge,
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Middle row - abilities
            Text(
              item.abilities,
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 8),

            // Bottom Row - buttons and P/T
            Row(
              children: [
                // Subtract button
                _TokenButton(
                  icon: Icons.remove,
                  onTap: () {
                    if (item.amount > 0) {
                      appState.removeTokens(1);
                    }
                  },
                  onLongPress: () => _showRemoveDialog(context, appState),
                ),

                const SizedBox(width: 6),

                // Add button
                _TokenButton(
                  icon: Icons.add,
                  onTap: () => appState.addTokens(1),
                  onLongPress: () => _showAddDialog(context, appState),
                ),

                const SizedBox(width: 6),

                // Untap button
                _TokenButton(
                  icon: Icons.mobile_friendly,
                  onTap: () {
                    if (item.tapped > 0) {
                      appState.untapTokens(1);
                    }
                  },
                  onLongPress: () => _showUntapDialog(context, appState),
                ),

                const SizedBox(width: 6),

                // Tap button
                _TokenButton(
                  icon: Icons.screen_rotation,
                  onTap: () {
                    if (item.tapped < item.amount) {
                      appState.tapTokens(1);
                    }
                  },
                  onLongPress: () => _showTapDialog(context, appState),
                ),

                const Spacer(),

                // Power/Toughness
                Text(
                  item.pt,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Show dialog for adding tokens
  void _showAddDialog(BuildContext context, AppState appState) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Tokens'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Value',
            hintText: 'How many tokens?',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(controller.text) ?? 0;
              appState.addTokens(value);
              Navigator.pop(context);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  /// Show dialog for removing tokens
  void _showRemoveDialog(BuildContext context, AppState appState) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Tokens'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Value',
            hintText: 'How many to remove?',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              appState.resetTokens();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Reset'),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(controller.text) ?? 0;
              appState.removeTokens(value);
              Navigator.pop(context);
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  /// Show dialog for tapping tokens
  void _showTapDialog(BuildContext context, AppState appState) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tap Tokens'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Value',
            hintText: 'How many to tap?',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(controller.text) ?? 0;
              appState.tapTokens(value);
              Navigator.pop(context);
            },
            child: const Text('Tap'),
          ),
        ],
      ),
    );
  }

  /// Show dialog for untapping tokens
  void _showUntapDialog(BuildContext context, AppState appState) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Untap Tokens'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Value',
            hintText: 'How many to untap?',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(controller.text) ?? 0;
              appState.untapTokens(value);
              Navigator.pop(context);
            },
            child: const Text('Untap'),
          ),
        ],
      ),
    );
  }
}

/// Button widget for token operations
class _TokenButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _TokenButton({
    required this.icon,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
