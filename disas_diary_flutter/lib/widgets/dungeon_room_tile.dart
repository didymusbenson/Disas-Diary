import 'package:flutter/material.dart';
import '../models/dungeon.dart';

/// Compact tile displaying a single dungeon room in the map view.
///
/// Shows room name and truncated effect text. Visual states:
/// - Active: glowing green border
/// - Visited: muted/dimmed
/// - Default: standard card styling
///
/// Long-press opens a full-detail overlay.
class DungeonRoomTile extends StatelessWidget {
  final DungeonRoom room;
  final bool isActive;
  final bool isVisited;
  final VoidCallback? onLongPress;

  const DungeonRoomTile({
    super.key,
    required this.room,
    required this.isActive,
    required this.isVisited,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryGreen = theme.colorScheme.primary;

    return GestureDetector(
      onLongPress: () => _showRoomDetail(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: _backgroundColor(theme),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? primaryGreen : theme.colorScheme.outlineVariant,
            width: isActive ? 2 : 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: primaryGreen.withValues(alpha: 0.5),
                    blurRadius: 6,
                  ),
                ]
              : null,
        ),
        child: Opacity(
          opacity: isVisited ? 0.5 : 1.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                room.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                  fontSize: 11,
                  color: isActive ? theme.colorScheme.onSurface : null,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                room.effect,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  fontSize: 9,
                  color: isActive
                      ? theme.colorScheme.onSurface.withValues(alpha: 0.8)
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _backgroundColor(ThemeData theme) {
    if (isVisited) {
      return theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);
    }
    return theme.colorScheme.surfaceContainerLow;
  }

  void _showRoomDetail(BuildContext context) {
    onLongPress?.call();
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => _RoomDetailDialog(
        room: room,
        isActive: isActive,
      ),
    );
  }
}

/// Full-detail dialog shown on long-press of a room tile.
class _RoomDetailDialog extends StatelessWidget {
  final DungeonRoom room;
  final bool isActive;

  const _RoomDetailDialog({
    required this.room,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryGreen = theme.colorScheme.primary;

    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: GestureDetector(
            onTap: () {}, // absorb taps on the card itself
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: isActive
                    ? Border.all(color: primaryGreen, width: 2)
                    : null,
                boxShadow: [
                  if (isActive)
                    BoxShadow(
                      color: primaryGreen.withValues(alpha: 0.4),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    room.effect,
                    style: theme.textTheme.bodyMedium,
                  ),
                  if (isActive) ...[
                    const SizedBox(height: 12),
                    Chip(
                      label: const Text('Current Room'),
                      avatar: const Icon(Icons.location_on, size: 16),
                      backgroundColor:
                          primaryGreen.withValues(alpha: 0.1),
                      side: BorderSide(color: primaryGreen),
                      visualDensity: VisualDensity.compact,
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
}
