# Dungeons

A dungeon progress tracker for the Venture into the Dungeon mechanic from Adventures in the Forgotten Realms and Commander Legends: Battle for Baldur's Gate.

## Supported Dungeons

| Dungeon | Set | Rooms | Tiers |
|---|---|---|---|
| Dungeon of the Mad Mage | AFR | 9 | 7 |
| Lost Mine of Phandelver | AFR | 7 | 4 |
| Tomb of Annihilation | AFR | 5 | 4 |
| Undercity | CLB | 9 | 5 |
| Baldur's Gate Wilderness | CLB | 19 | 8 |

## Dungeon Selection

- All five dungeons available to select (including Undercity)
- Each entry shows dungeon name, room count, and completion count
- Preview button fetches card image from Scryfall (falls back to oracle text on failure)
- Global completion count displayed at top
- Reset all button clears all progress and counts

## Gameplay

### Venture Flow
1. Select a dungeon from the list
2. Marker placed on the topmost room automatically
3. Tap the Venture button or tap a valid next room to advance
4. At branching paths, a bottom sheet presents room choices with effect text
5. Entering the bottommost room completes the dungeon and returns to selection

### Room Display
- Vertical tier-based map layout with rooms as compact tiles
- Room name and truncated effect text visible inline
- Long-press any room to view full effect text in a detail overlay
- Active room indicated by green border glow
- Visited rooms (tiers above current) dimmed at 50% opacity
- Connection arrows between tiers show branching paths

### Initiative Toggle
- Available in the active dungeon view app bar
- Purely informational — indicates whether the player currently has the initiative
- Does not gate dungeon selection (Undercity always available)

### Completion
- Entering the bottommost room completes the dungeon
- Completion count incremented (both global and per-dungeon)
- Player returns to dungeon selection to choose the next dungeon
- "Venture into next dungeon" button on the bottom room

## State & Persistence
- Full state persists between sessions (active dungeon, current room, initiative, completion counts)
- Dungeon data hardcoded in the app (5 fixed dungeons, no external data source)
- `DungeonsState` (ChangeNotifier) manages all dungeon operations
- Persistence via SharedPreferences through PersistenceService
