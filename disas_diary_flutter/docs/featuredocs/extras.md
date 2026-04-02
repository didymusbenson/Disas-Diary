# Extras — Command Zone Additions

Additional game mechanics to track in the Command Zone tool.

## The Ring Tempts You

Track the Ring temptation level (0–4 stages) from Lord of the Rings: Tales of Middle-earth.

### Rules Reference

When "the Ring tempts you," your Ring-bearer gains cumulative abilities based on the current temptation level:

1. **Level 1:** Your Ring-bearer is legendary and can't be blocked by creatures with greater power.
2. **Level 2:** Whenever your Ring-bearer attacks, draw a card, then discard a card.
3. **Level 3:** Whenever your Ring-bearer becomes blocked by a creature, that creature's controller sacrifices it at end of combat.
4. **Level 4:** Whenever your Ring-bearer deals combat damage to a player, each opponent loses 3 life.

Each temptation adds the next ability. The Ring-bearer keeps all abilities from previous levels.

### Existing Infrastructure

Model and state already implemented (not yet in UI):
- `ringTemptationLevel` field (0–4, clamped)
- `temptWithRing()` — increments level
- `setRingTemptationLevel(int)` — direct set with clamping
- Constants: `maxRingLevel = 4`, `minRingLevel = 0`
- JSON persistence included

### UI Scope

- Display as a status indicator or dedicated section in Command Zone
- Show current level and the active abilities at that level
- Tap to tempt (increment), long-press to reset
- Visual progression (e.g. filled stages or step indicator)

## Start Your Engines / Max Speed

Track vehicle speed counters from the Thunder Junction "saddle up" mechanic and related speed/vehicle mechanics.

### Open Questions

- Which specific cards/mechanics require speed tracking?
- Is this a simple counter (like energy) or does it have thresholds?
- Should this be a new counter tile, a status toggle, or its own section?
- Interaction with existing trigger trackers?

## Status

Spec in progress — Ring has backend ready, needs UI. Speed needs further research.
