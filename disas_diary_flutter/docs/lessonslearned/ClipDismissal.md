# Clip Dismissal: Fixing Rounded Card Corners During Swipe-to-Dismiss

## The Problem

When using Flutter's `Dismissible` widget wrapped around a `Card`, swiping to dismiss reveals visual artifacts in the rounded corners. The card's white background peeks out at the corners as it slides away, because the card's surface layer renders independently from the dismiss background.

## What We Tried (And Why It Didn't Work)

### Attempt 1: Dismissible outside Card, matching border radius on background

```dart
Dismissible(
  background: Container(
    decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: Card(
    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    // ...
  ),
)
```

**Problem**: The dismiss background fills the full Dismissible area while the Card is inset by its margin, so the red background extends beyond the card bounds.

### Attempt 2: Move margin to outer Padding, wrap Dismissible in ClipRRect

```dart
Padding(
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: Dismissible(
      background: Container(color: Colors.red),
      child: Card(
        margin: EdgeInsets.zero,
        // ...
      ),
    ),
  ),
)
```

**Problem**: The Card widget creates its own compositing layer (due to elevation/Material surface). ClipRRect clips at its own layer, but the Card's surface renders on top in a separate composited layer, so the white corners still show through during the swipe animation.

### Attempt 3: Replace Card with plain Container

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: Dismissible(
    background: Container(color: Colors.red),
    child: Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      // ...
    ),
  ),
)
```

**Problem**: Loses all Card styling (elevation, surface tint, Material 3 theming). The items look flat and unstyled.

### Attempt 4: Card with elevation: 0

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: Dismissible(
    child: Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      // ...
    ),
  ),
)
```

**Problem**: Still didn't clip properly. The Material surface of the Card still composites independently even at zero elevation.

## The Fix: Card as the Clipping Window

The solution is to invert the hierarchy. Instead of trying to clip the Card from the outside, use the Card itself as the clipping container by setting `clipBehavior: Clip.antiAlias`, and place the `Dismissible` *inside* the Card.

```dart
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  child: Card(
    margin: EdgeInsets.zero,
    clipBehavior: Clip.antiAlias,
    child: Dismissible(
      key: ValueKey('item_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: theme.colorScheme.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDismiss(),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: // ... card content, no inner Card needed
      ),
    ),
  ),
)
```

## Why This Works

- The **Card** acts as a fixed "window" with rounded corners and `Clip.antiAlias`
- The **Dismissible** lives inside that window, so both the dismiss background (red) and the sliding content are clipped by the Card's shape
- The Card's own Material surface provides the styling (elevation, surface tint, theme)
- When dismissed, the entire Card item is removed from the list
- No extra ClipRRect needed — the Card handles its own clipping

## Key Insight

The root cause is that `Card` (which is a `Material` widget) creates its own compositing layer for rendering its surface. External `ClipRRect` widgets cannot clip across compositing boundaries. By putting the Dismissible *inside* the Card and enabling `clipBehavior`, the Card's own clipping applies to all of its children, including the dismiss animation.
