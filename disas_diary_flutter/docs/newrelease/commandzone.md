# Command Zone

A single-player advanced life tracker for Magic: The Gathering with counters, status indicators, trigger trackers, and commander damage tracking. Designed primarily for Commander but applicable to any format.

## Screen Layout

Single scrollable view with six sections: Life Total, Counters, Status Toggles, Commander Damage, and Trigger Trackers.

## Life Total

- Large centered display with left-half/right-half tap zones
- Tap left to decrement (-1), tap right to increment (+1)
- Long-press for rapid repeat adjustment (±10)
- Haptic feedback on interactions
- Starting life configurable via reset dialog (20, 30, 40, or custom)

## Counters

Six square tiles in a single row, each with a faded mana font background icon:

| Counter | Icon | Notes |
|---|---|---|
| Poison | Toxic symbol | Red warning border at 10 (lethal) |
| Energy | Energy symbol | Kaladesh+ mechanic |
| Experience | Sparkle | Commander-specific |
| Tickets | Ticket symbol | Unfinity mechanic |
| Rad | Rad symbol | Fallout Commander mechanic |
| Tax | Scales (balance) | Commander tax, supports partner split |

- Tap any counter to increment (+1, or +2 for tax)
- Long-press any of the first five opens a shared counter modal showing all five with full names, +1/-1 buttons, and reset
- Long-press tax opens a dedicated tax modal with +2/-2 controls and "Add Partner Tax" option
- Small italic labels pinned to bottom of each tile on a separate layer (don't affect number centering)
- Poison counter shows red warning border and "Lethal poison!" in the shared modal at 10

### Partner Tax

- Tax tile shows a single value by default
- Long-press opens tax modal where "Add Partner Tax" enables a second commander
- Once partner tax is active, the tile displays a split view: each commander's tax centered on its half with a `|` divider
- Tax modal then shows both commanders' tax with independent +2/-2/Reset controls

## Status Toggles

Four equally-sized FilterChips in a single row with faded background icons:

| Status | Icon | Behavior |
|---|---|---|
| Day/Night | Sun/Moon/Brightness | Tap: disabled → Day, then Day ↔ Night. Long-press: reset to disabled |
| Monarch | Sparkle | Toggle on/off |
| Ascend | City | Toggle on/off (City's Blessing) |
| Initiative | Flash | Toggle on/off, independent of Dungeons feature |

- No checkmarks — color change indicates selection
- Equal widths via Expanded wrappers with consistent spacing
- Labels use labelSmall text style

## Commander Damage

- Section header "Commander Damage" with edit button for config
- Edit button opens a bottom sheet to set opponent count (1-8)

### Damage Grid

- Opponent tiles arranged in balanced rows: 1-4 in one row, 5+ split evenly (e.g. 5→3+2, 6→3+3, 7→4+3, 8→4+4)
- Tiles have a max height based on 4-per-row sizing (wider when fewer opponents)
- Tap any tile: +1 damage to commander 1
- Long-press: opens damage modal with per-commander +1/-1/+5/-5 and reset controls
- Label "Opp N" pinned at bottom of each tile

### Partner Damage Display

- When commander count is 2 and either commander has dealt damage, tiles show split display
- Each commander's damage centered on its half with `|` divider (full tile width)
- Lethal threshold (21) checked per-commander independently per rule 702.124d / 903.10a
- Red warning border when any single commander reaches lethal

## Trigger Trackers

- Section header "Trigger Trackers" with edit button and "New Turn" button
- Three default trackers: Storm, Lands, Cards Drawn
- Mana-pool-style tiles: left-half tap to decrement, right-half to increment, long-press for rapid repeat
- Value centered with label below

### Custom Trackers

- Edit button opens a bottom sheet for tracker management
- Add custom trackers with any label
- Toggle trackers on/off (show/hide) via switch
- Delete custom trackers (red delete button)
- Default trackers (Storm, Lands, Cards Drawn) can be disabled but never deleted (lock icon shown)
- "New Turn" button resets all tracker values to zero

### Dynamic Layout

- Enabled trackers displayed in a Wrap layout
- 1-4 trackers fill one row evenly, 5+ wrap to additional rows of 4

## Reset Dialog

- Title: "Reset Life Tracker"
- Life total presets: 20, 30, 40, Custom (ChoiceChips in a single row, no checkmarks)
- Custom option shows a number input field
- "Reset trackers to default" checkbox (default checked): enables only Storm/Lands/Cards Drawn, disables custom trackers (doesn't delete them)
- "Reset to commander defaults" checkbox (default checked): resets to no partner, 3 opponents
- Unchecking either checkbox preserves that config and just zeros values

## App Bar

- 40px height, back button, "Command Zone" title
- Reset button opens the reset dialog

## State & Persistence

- `CommandZoneGameState` model with JSON serialization and migration support (old per-turn tracker format auto-converts to new TriggerTracker list)
- `CommandZoneState` (ChangeNotifier) manages all mutations
- `TriggerTracker` model: id, label, isDefault, isEnabled, value — supports custom tracker definitions
- Full state persists between sessions via SharedPreferences through PersistenceService
- Every mutation persists immediately
- All game-rule numbers defined as named constants (no magic numbers)
