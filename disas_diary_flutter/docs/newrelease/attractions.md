# Attractions Deck

An attraction management tool for the Unfinity set's Attractions mechanic. Players can build and save attraction deck lists, load them, and play through games by shuffling the deck, opening attractions, and rolling dice to visit them.

## Deck Building

- Checklist of all 35 unique attraction names with oracle text
- Tap to expand and select a specific lit-up variant matching your physical card
- Lit-up numbers displayed as visual indicator circles (1-6, filled vs outlined)
- Commander legal filter toggle hides acorn-stamped attractions
- Acorn icon displayed on acorn-stamped attractions
- Minimum 10 unique attraction names per deck (constructed rules)
- Multiple named decks supported, fully editable
- Decks persist between sessions

## Gameplay

### Zones
- **Attraction Deck**: Shuffled face-down pile in command zone
- **Battlefield**: Open (face-up) attractions currently in play
- **Junkyard**: Face-up pile of closed attractions in command zone
- **Exile**: Removed from play entirely

### Actions
- **Open an Attraction**: Draws from the top of the shuffled deck to the battlefield
- **Roll to Visit**: Rolls a d6, shows which open attractions are visited (lit-up number matches the roll), displays their visit ability text for resolution
- **Swipe to Junkyard**: Swipe-to-dismiss sends an attraction to the junkyard
- **Long-press**: Choice of Junkyard or Exile
- **Prize toggle**: Attractions with "claim the prize" show a toggleable prize indicator
- **Reset**: Returns all attractions to the deck and reshuffles (with confirmation)

### Status Bar
- Deck remaining count
- Junkyard viewer (bottom sheet with card names and lit-up numbers, shuffle-back option)
- Exile count

## Legality
- Acorn-stamped attractions marked with acorn icon throughout
- Commander legal filter in deck builder
- Saved decks containing acorn cards show acorn icon in deck list

## Data
- 135 attraction card variants (35 unique names) bundled as `attractions_data.json`
- Sourced from Scryfall API, includes security stamp and commander legality fields

## Architecture
- `AttractionsState` (ChangeNotifier) manages all deck and game operations
- Full game state persists between sessions via SharedPreferences
- Card data loaded from bundled JSON asset at startup
