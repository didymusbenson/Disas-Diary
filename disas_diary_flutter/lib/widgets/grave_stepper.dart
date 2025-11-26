import 'package:flutter/material.dart';

/// A big number tile widget for tracking graveyard counts
class GraveStepper extends StatelessWidget {
  final String name;
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const GraveStepper({
    super.key,
    required this.name,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.5),
            ),
          ),
          child: Stack(
            children: [
              // Left and right tap zones
              Row(
                children: [
                  // Left tap zone (decrement)
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: value > 0 ? onDecrement : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 22),
                        ),
                      ),
                    ),
                  ),
                  // Right tap zone (increment)
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onIncrement,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 22),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            // Visual content (non-interactive overlay)
            Positioned.fill(
              child: IgnorePointer(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    children: [
                      // Minus icon
                      Icon(
                        Icons.remove,
                        size: 16,
                        color: value > 0
                            ? theme.colorScheme.secondary
                            : theme.disabledColor,
                      ),

                      // Center content
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Title
                              Text(
                                name,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),

                              // Big number
                              Text(
                                value.toString(),
                                style: theme.textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Plus icon
                      Icon(
                        Icons.add,
                        size: 16,
                        color: theme.colorScheme.secondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
