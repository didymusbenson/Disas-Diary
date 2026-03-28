# Command Zone

A single-player advanced life tracker with detailed tracking features for Magic: The Gathering.

## Overview

The Command Zone is a comprehensive life tracking tool for a single player, offering granular tracking of all player-specific state beyond a simple life total. Designed primarily for Commander but applicable to any format.

## Requirements

### Core Counters
- **Life total** — starting value configurable by format (20, 40, custom)
- **Poison counters** — 10 = loss
- **Energy counters** — Kaladesh block and newer
- **Experience counters** — Commander-specific
- **Tickets** — Unfinity mechanic

### Additional Counters
- **Rad counters** — Fallout Commander; mill + life loss trigger
- **Ring temptation level** — Lord of the Rings; 4-stage progression tracker

### Status Indicators (toggles)
- **Day/Night** — Innistrad daybound/nightbound tracking
- **Monarch** — card draw trigger reminder
- **City's Blessing** — ascend (10+ permanents) designation
- **Initiative** — independent toggle, not connected to the Dungeons utility

### Per-Turn Trackers
- **Storm count** — spells cast this turn
- **Land drops** — lands played this turn (track against allowed count)
- **Cards drawn this turn** — relevant for many "second card drawn" triggers

### Commander-Specific
- **Commander damage** — tracked per opponent
- **Variable opponent count** — quick way to set number of opponents (1-5+)
- **Commander tax** — additional {2} per cast from command zone, tracked per commander
- **Partner commander support** — two commander damage tracks per opponent if applicable

## Open Questions

- Input method for life total changes? (tap ±1, swipe, hold for bulk?)
- History/log of life changes?
- Starting life presets by format? (Standard 20, Commander 40, etc.)
- How to handle partner commanders for tax tracking?
- Should day/night show the current side or just be a toggle?
- Reset per-turn trackers automatically, or manual?
- Layout: single scrollable view, or tabbed sections?

## Status

Spec in progress — gathering requirements. Research pending for additional player-specific mechanics.
