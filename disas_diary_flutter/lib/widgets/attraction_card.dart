import 'package:flutter/material.dart';
import '../models/attraction_game_state.dart';

/// Card widget displaying an open attraction on the battlefield
class AttractionCard extends StatelessWidget {
  final OpenAttraction openAttraction;
  final int index;
  final VoidCallback onJunkyard;
  final VoidCallback onExile;
  final VoidCallback onTogglePrize;

  const AttractionCard({
    super.key,
    required this.openAttraction,
    required this.index,
    required this.onJunkyard,
    required this.onExile,
    required this.onTogglePrize,
  });

  bool get _hasPrize =>
      openAttraction.entry.oracleText.toLowerCase().contains('claim the prize');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entry = openAttraction.entry;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: Dismissible(
          key: ValueKey('attraction_${index}_${entry.attractionName}'),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: theme.colorScheme.error,
            child: Icon(Icons.delete, color: theme.colorScheme.onError),
          ),
          onDismissed: (_) => onJunkyard(),
          child: GestureDetector(
            onLongPress: () => _showZoneDialog(context),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: name + lit-up numbers
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.attractionName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _AttractionLights(lights: entry.attractionLights),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Oracle text
                  Text(
                    entry.oracleText,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  // Prize chip
                  if (_hasPrize) ...[
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: onTogglePrize,
                      child: Chip(
                        label: Text(
                          openAttraction.prizeClaimed
                              ? 'Prize Claimed'
                              : 'Prize',
                        ),
                        avatar: Icon(
                          openAttraction.prizeClaimed
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          size: 18,
                          color: openAttraction.prizeClaimed
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        backgroundColor: openAttraction.prizeClaimed
                            ? theme.colorScheme.primaryContainer
                            : null,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showZoneDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(openAttraction.entry.attractionName),
        content: const Text('Move this attraction to:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onExile();
            },
            child: const Text('Exile'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              onJunkyard();
            },
            child: const Text('Junkyard'),
          ),
        ],
      ),
    );
  }
}

/// Displays the attraction light numbers as small filled/unfilled circles
class _AttractionLights extends StatelessWidget {
  final List<int> lights;

  const _AttractionLights({required this.lights});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 1; i <= 6; i++) ...[
          if (i > 1) const SizedBox(width: 3),
          _LightIndicator(
            number: i,
            isLit: lights.contains(i),
            color: theme.colorScheme.primary,
          ),
        ],
      ],
    );
  }
}

/// Single light indicator circle with number
class _LightIndicator extends StatelessWidget {
  final int number;
  final bool isLit;
  final Color color;

  const _LightIndicator({
    required this.number,
    required this.isLit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isLit ? color : Colors.transparent,
        border: Border.all(
          color: isLit ? color : theme.colorScheme.outlineVariant,
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        '$number',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isLit
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// Reusable light indicators for lists (junkyard, deck builder, etc.)
class AttractionLightsRow extends StatelessWidget {
  final List<int> lights;

  const AttractionLightsRow({super.key, required this.lights});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 1; i <= 6; i++) ...[
          if (i > 1) const SizedBox(width: 3),
          _LightIndicator(
            number: i,
            isLit: lights.contains(i),
            color: theme.colorScheme.primary,
          ),
        ],
      ],
    );
  }
}
