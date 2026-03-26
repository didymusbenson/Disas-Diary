# Mana Pool

## Overview

A mana tracking tool that lets players track available mana across all six mana types (White, Blue, Black, Red, Green, Colorless). Each color is represented by a tile with tap-to-adjust controls and large numeric display. Bulk operations allow emptying, converting between colors, and locking individual pools.

## Mana Types

| Mana     | Color Code | Symbol |
|----------|-----------|--------|
| White    | #F9FAF4   | W      |
| Blue     | #0E68AB   | U      |
| Black    | #150B00   | B      |
| Red      | #D3202A   | R      |
| Green    | #00733E   | G      |
| Colorless| #CBC2BF   | C      |

## Tile Layout

**3 rows, 2 tiles per row:**

| Row | Left | Right |
|-----|------|-------|
| 1   | White (W) | Blue (U) |
| 2   | Black (B) | Red (R) |
| 3   | Green (G) | Colorless (C) |

Each tile contains:

- **Color indicator**: Background color or prominent icon/pip matching the mana color
- **Mana count**: Large, prominent number showing current amount
- **Lock highlight**: Custom visual highlight when the pool is locked (visible in both normal and lock modes)

### Tile Interaction — Normal Mode

Each tile is split into two tap zones:

- **Left half tap**: Decrement by 1 (clamped to 0, cannot go negative)
- **Right half tap**: Increment by 1 (no upper clamp)

### Tile Interaction — Long-Press (Hold)

- **Long-press (initial)**: Immediately adjusts by 5 in the corresponding direction (left half = -5, right half = +5), clamped to 0 on decrement
- **Continued hold**: Every second after the initial long-press fires another +5 or -5 adjustment
- Release cancels the repeat

### Tile Interaction — Lock Mode

When the app is in **lock mode** (toggled via toolbar button):

- Each tile displays a **lock or unlock icon** overlaid on the tile (locked = lock icon, unlocked = unlock icon) so the user can see and change each pool's state
- Tapping a tile **toggles its lock state** instead of adjusting the count
- The glow border highlight on locked tiles persists when exiting lock mode so the user can always see which pools are protected

### Number Formatting

- 0–9999: Display as-is (e.g., `42`, `9999`)
- 10,000–999,999: Display as `XXk` (e.g., `10k`, `999k`)
- 1,000,000+: Display as `X.Xm` (e.g., `1.2m`)

## Lock Mechanic

Each mana color has an independent **lock** toggle, set via lock mode.

- **Locked pools are protected** from the "Empty Mana Pool" action only — they retain their value when emptying
- Locks **do not interfere** with normal increment/decrement operations — a locked pool can still be tapped to adjust its value
- Locks **do not protect** from Convert operations — Convert to Colorless and Convert to Color affect all pools regardless of lock state
- Locked tiles have a **custom visual highlight** (e.g., a border glow, overlay icon, or distinct background treatment) visible at all times, not just in lock mode

## Bulk Actions

Three action buttons in the app bar or bottom action area:

### 1. Empty Mana Pool
- Sets all **unlocked** mana pools to 0
- Locked pools are unaffected
- Shows a confirmation dialog: "Empty mana pool?" with Confirm/Cancel buttons
- Tapping outside the dialog cancels (standard barrier dismiss)

### 2. Convert to Colorless
- Sums the counts of all five **colored** mana pools (W + U + B + R + G)
- Adds that sum to the current Colorless count
- Resets all five colored mana pools to 0
- Lock state is ignored — all colored pools are converted

### 3. Convert to Color
- User taps "Convert to Color" button in the toolbar
- The app enters **convert-to-color mode**: all six tiles replace their normal content with the text **"Convert to {Color}"** (e.g., "Convert to White", "Convert to Blue", etc.)
- Tapping a tile performs the conversion:
  - Sums **all other** mana pools (the five non-selected colors + colorless)
  - Adds that sum to the selected color's count
  - Resets all other mana pools to 0
  - Lock state is ignored — all non-target pools are converted
- Tapping the "Convert to Color" button again **cancels** the operation and returns tiles to normal display
- Only one mode can be active at a time (entering convert mode exits lock mode, and vice versa)

## Persistence

Mana pool state **persists between sessions** via SharedPreferences:
- All six mana counts are saved
- All six lock states are saved
- State is restored when the user navigates back to the Mana Pool tool

This ensures that switching to another tool (e.g., Disa's Diary) and back, or accidentally closing the app mid-game, does not lose mana state.

## Resolved Design Decisions

- **Locked tile highlight**: Glowing border around the tile
- **Tap feedback**: InkWell ripple effect for taps (no haptics). Haptic buzz on long-press initial fire and each repeat tick only.
- **Long-press repeat rate**: Fixed 1-second interval, no acceleration

## Open Questions

1. ~~**Lock mode visual indicator**~~: Resolved — lock/unlock icons appear on each tile when in lock mode
2. ~~**Convert to Color — include Colorless?**~~: Resolved — yes, Colorless is included. All non-target pools (including Colorless) are summed and converted.
3. ~~**Empty button styling**~~: Resolved — same style as other action buttons, with a confirmation dialog as the safety net

## State Management

Follows the existing Provider pattern:

- New `ManaPoolState` or extend `AppState` with mana pool fields
- Six integer values (one per mana type)
- Six boolean lock values
- One boolean for lock mode active state
- Persistence via `PersistenceService` (SharedPreferences)

## Screen Structure

```
ManaPoolScreen
├── AppBar
│   ├── Back button (to home)
│   ├── Title: "Mana Pool"
│   └── Actions: [Lock Mode Toggle] [Empty] [Convert to Colorless] [Convert to Color]
├── Body
│   └── 3x2 Grid
│       ├── Row 1: ManaTile(White) | ManaTile(Blue)
│       ├── Row 2: ManaTile(Black) | ManaTile(Red)
│       └── Row 3: ManaTile(Green) | ManaTile(Colorless)
```

## Files to Create

- `lib/models/mana_pool_data.dart` — Data model for mana pool state
- `lib/screens/mana_pool_screen.dart` — Main screen (already stubbed)
- `lib/widgets/mana_tile.dart` — Individual mana tile widget
- Update `lib/providers/app_state.dart` or create `lib/providers/mana_pool_state.dart`
- Update `lib/services/persistence_service.dart` for mana pool persistence
- Update `lib/screens/home_screen.dart` navigation entry
