# Mana Pool — Implemented

## Status: Complete

Implemented in commit `22c2e8e`.

## Summary

Mana tracking tool with 6 color tiles (White, Blue, Black, Red, Green, Colorless) arranged in a 3x2 grid (WU/BR/GC).

## What Was Built

### Core Interaction
- Left-half tap decrements by 1 (clamped to 0), right-half tap increments by 1
- Long-press fires +/-5 immediately, then repeats at 1s, then every 500ms while held
- Haptic buzz on long-press ticks only; InkWell ripple for tap feedback
- Number formatting: as-is up to 9999, then Xk, then X.Xm

### Lock Mode
- Toolbar toggle enters lock mode — lock/unlock icons appear on each tile
- Tapping toggles lock state per tile
- Locked tiles have an amber glow border (visible in all modes)
- Locks only protect from Empty action, not from Convert or normal +/-

### Bulk Actions
- **Empty Mana Pool**: Zeros all unlocked pools with confirmation dialog ("Empty mana pool? Confirm/Cancel", tap-away cancels)
- **Convert to Color**: Enters convert mode — tiles show "Convert to {Color}" text. Tapping a tile sums all other pools into the target and zeros the rest. Tapping the toolbar button again cancels. Includes Colorless as both a source and target.

### Persistence
- Mana counts and lock states saved via SharedPreferences
- State survives navigation away and app restarts

### Visual
- Tiles have colored backgrounds matching MTG mana colors
- Raised feel with drop shadow and border on all tiles
- Luminance-based text color (dark text on White/Colorless, light text on others)

## Files
- `lib/services/persistence_service.dart` — Mana pool save/load methods
- `lib/providers/app_state.dart` — Mana pool state and 6 mutator methods
- `lib/widgets/mana_tile.dart` — ManaTile widget (3 modes, long-press timer)
- `lib/screens/mana_pool_screen.dart` — ManaPoolScreen with app bar actions and 3x2 grid

## Design Decisions
- No separate "Convert to Colorless" button — handled by Convert to Color mode (tap the Colorless tile)
- Long-press repeat accelerates: 1s after initial, then 500ms thereafter
- Lock mode and convert mode are mutually exclusive
- Empty button styled same as other actions (not warning-colored) — confirmation dialog is the safety net
