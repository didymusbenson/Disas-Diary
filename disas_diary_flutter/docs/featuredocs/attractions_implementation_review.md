# Attractions Feature - Implementation Review

## Files Created
- `lib/models/attraction.dart` - Attraction card model with JSON serialization and asset loading
- `lib/models/attraction_deck.dart` - AttractionDeck and AttractionDeckEntry models for saved decks
- `lib/models/attraction_game_state.dart` - AttractionGameState and OpenAttraction models for mid-game state
- `lib/providers/attractions_state.dart` - ChangeNotifier state provider for all attraction operations
- `lib/widgets/attraction_card.dart` - AttractionCard widget, AttractionLightsRow, and light indicator widgets
- `lib/screens/attraction_deck_selector_screen.dart` - Deck list/management screen
- `lib/screens/attraction_deck_builder_screen.dart` - Deck creation/editing screen with variant picker

## Files Modified
- `lib/screens/attractions_screen.dart` - Full game play UI (battlefield, roll-to-visit, junkyard sheet)
- `lib/services/persistence_service.dart` - Added attraction deck and game state persistence methods
- `lib/main.dart` - Added AttractionsState provider initialization via MultiProvider
- `pubspec.yaml` - Added `docs/featuredocs/attractions_data.json` as a bundled asset

## Issues Found and Fixed

### 1. Property name mismatch: `e.name` vs `e.attractionName` (attractions_state.dart)
`AttractionDeckEntry` uses `attractionName`, but `createDeck()` and `updateDeck()` referenced `e.name` for the unique-name validation check.
- **Fixed**: Changed `entries.map((e) => e.name)` to `entries.map((e) => e.attractionName)` in both methods (lines 72 and 99).

### 2. Missing required `deckName` parameter in `loadDeck()` (attractions_state.dart)
`AttractionGameState` requires a `deckName` parameter, but `loadDeck()` constructed the state without it.
- **Fixed**: Added `deckName: deck.name` to the `AttractionGameState` constructor call in `loadDeck()`.

### 3. Missing required `deckName` parameter in `rollToVisit()` (attractions_state.dart)
`rollToVisit()` recreates the `AttractionGameState` to update `lastRoll`, but omitted the required `deckName`.
- **Fixed**: Added `deckName: _gameState!.deckName` to the constructor call.

### 4. Property name mismatch: `oa.entry.lights` vs `oa.entry.attractionLights` (attractions_state.dart)
`getVisitedAttractions()` referenced `oa.entry.lights`, but `AttractionDeckEntry` uses `attractionLights`.
- **Fixed**: Changed to `oa.entry.attractionLights.contains(roll)`.

## Build Status
**Clean** - `flutter analyze` passes with 0 errors. 3 info-level lint suggestions remain (curly braces style in flow control), which are non-blocking.

## Architecture Notes
- State follows the existing Provider/ChangeNotifier pattern used by AppState and ManaPoolState
- Persistence uses the existing SharedPreferences-based PersistenceService
- All 76 attraction card variants are loaded from a bundled JSON asset (`attractions_data.json`)
- Deck builder enforces the MTG rule of minimum 10 unique attraction names
- Game state (draw pile, battlefield, junkyard, exile, last roll) persists between sessions
- UI uses dialogs (not snackbars) for user feedback, consistent with app conventions

## Remaining Warnings (Non-blocking)
- 3 info-level lint suggestions about adding curly braces to single-statement `if` blocks in `attractions_state.dart` (lines 194, 207, 220 - the `junkyardAttraction`, `exileAttraction`, and `togglePrizeClaimed` methods)
