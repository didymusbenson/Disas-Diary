# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Disas Diary is a Magic: The Gathering companion app for tracking Tarmogoyf's power/toughness calculation and graveyard card type tracking.

**Active Development**: All work is now focused on the **Flutter (Cross-platform)** version in `disas_diary_flutter/`.

**Deprecated**: The Swift version (`Disas Diary/` directory) is a deprecated artifact and will eventually be deleted. Do not make changes to the Swift version.

---

# Flutter Version (Cross-Platform) - ACTIVE

## Location
`disas_diary_flutter/`

## Building and Running

### Setup
```bash
cd disas_diary_flutter
flutter pub get
```

### Run Commands
```bash
flutter run                  # Run on connected device
flutter run -d chrome        # Run on web
flutter run -d ios           # Run on iOS
flutter run -d android       # Run on Android
```

### Build for Release
```bash
flutter build apk            # Android APK
flutter build ios            # iOS
flutter build web            # Web
```

## Flutter Architecture

### Dependencies
- **provider ^6.1.1**: State management
- **shared_preferences ^2.2.2**: Persistent storage
- **wakelock_plus ^1.2.0**: Keep screen awake during gameplay

### Project Structure
```
lib/
├── main.dart                    # App entry point with wakelock initialization
├── models/
│   ├── item.dart               # Token/card data model with JSON serialization
│   └── grave_stepper_data.dart # Grave counter data model
├── providers/
│   └── app_state.dart          # Main state provider (ChangeNotifier)
├── services/
│   └── persistence_service.dart # SharedPreferences wrapper
├── screens/
│   └── home_screen.dart        # Main screen with Tarmogoyf tracker
├── widgets/
│   ├── token_view.dart         # Token display and manipulation widget
│   └── grave_stepper.dart      # Counter stepper widget
└── theme/
    └── app_theme.dart          # Material Design 3 theme (Jund colors)
```

### State Management Pattern

**Provider Architecture**:
```dart
// App initialization
ChangeNotifierProvider(
  create: (_) => AppState(persistenceService),
  child: const DisasDiaryApp(),
)

// Widget consumption
final appState = context.watch<AppState>();
appState.setCardType('creature', true);
```

**AppState** (lib/providers/app_state.dart) manages:
- Tarmogoyf item (single token)
- Card type toggles (9 types: artifact, creature, enchantment, instant, sorcery, land, planeswalker, battle, kindred)
- Grave stepper counters (8 informational counters)
- Automatic P/T calculation when card types change
- Persistence via PersistenceService

### Key Features

**Persistent State**: All state persists between sessions via SharedPreferences:
- Token counts (amount, tapped)
- Card type toggles
- Grave stepper values
- Tarmogoyf P/T

**Reset Functionality**: HomeScreen AppBar has reset button that clears all persisted data

**Wakelock**: Screen stays on during gameplay (initialized in main.dart)

**Theme**: Material Design 3 with Disa's Jund color identity (Green/Red/Black)
- Light theme: primaryGreen (#2D5016), accentRed (#D32F2F), accentBlack (#1A1A1A)
- Dark theme support with adjusted color scheme

### Token Management (TokenView)

**Gesture Handling**:
- Tap: Quick operations (±1 token/tap)
- Long-press: Shows dialog for bulk operations

**Four Operations**:
1. Add tokens (+ button)
2. Remove tokens (- button) - long-press offers "Reset" to zero
3. Untap tokens (mobile_friendly icon)
4. Tap tokens (screen_rotation icon)

**State Validation**:
- Tapped count clamped to [0, amount]
- Negative amounts prevented
- Excess values automatically clamped

### Platform-Specific Notes

**Android**:
- Requires WAKE_LOCK permission (AndroidManifest.xml)
- minSdk: 21, targetSdk: 34
- Package: com.disasdiary

**iOS**:
- UIIdleTimerDisabled set in Info.plist
- Supports portrait and landscape orientations

**Web**:
- Manifest configured for standalone PWA
- Theme color: #2D5016 (dark green)
- Viewport locked (no user scaling for game-focused UI)

---

# Swift Version (iOS Only) - DEPRECATED ⚠️

**DO NOT USE OR MODIFY THIS VERSION**

This Swift implementation is deprecated and will eventually be deleted from the repository. All active development has moved to the Flutter version.

## Location
Root directory: `Disas Diary/` and `Disas Diary.xcodeproj/`

## Archived Documentation

## Building and Running

This is an Xcode project. To build and run:

```bash
# Open the project in Xcode
open "Disas Diary.xcodeproj"
```

Build and run from Xcode using Cmd+R. The project targets iOS devices.

## Architecture

### Data Model (SwiftData)
- **Item.swift**: The core `@Model` class representing a Magic card/token
  - Tracks: abilities, name, pt (power/toughness), colors, amount, tapped count
  - Initialized with `createTapped` parameter to set initial tapped state
  - Originally from "Doubling Season" project (see file headers)

### Views
- **Disas_DiaryApp.swift**: App entry point with ModelContainer setup
  - Uses in-memory persistence: `ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)`
  - Single ModelContainer shared across the app

- **ContentView.swift**: Main view with Tarmogoyf calculator
  - Manages 9 card type toggles (artifact, creature, enchantment, instant, sorcery, land, planeswalker, battle, kindred)
  - `updateGoyfPt()`: Calculates Tarmogoyf's P/T as "uniqueTypes/uniqueTypes+1"
  - `setItem()`: Creates/replaces the Tarmogoyf item (deletes all existing items first)
  - Contains 8 GraveStepper instances for tracking various graveyard counts
  - Disables idle timer on appear: `UIApplication.shared.isIdleTimerDisabled = true`

- **TokenView.swift**: Complex view for displaying and managing a single token/card
  - Shows name, P/T, abilities, and tapped/untapped counts
  - Four button interactions (all using simultaneous tap/long-press gestures):
    - Minus: Remove tokens (tap: -1, long-press: shows alert)
    - Plus: Add tokens (tap: +1, long-press: shows alert)
    - Clockwise arrow: Tap tokens (tap: +1 tapped, long-press: shows alert)
    - Counter-clockwise arrow: Untap tokens (tap: -1 tapped, long-press: shows alert)
  - Manages tapped state carefully: ensures tapped count never exceeds total amount
  - Green vertical stripe on left side for visual identification

- **GraveStepper.swift**: Reusable stepper component
  - Name label, current value, increment/decrement chevron buttons
  - Currently stateful but values don't affect Tarmogoyf calculation

- **TileView.swift**: Unused/placeholder view with toggle (contains Xcode template code)

### Key Patterns

**SwiftData Query Pattern**:
```swift
@Environment(\.modelContext) private var modelContext
@Query private var items: [Item]
```

**Token Management**: TokenView implements complex tap/long-press gesture handling:
- Tap gestures for quick +1/-1 operations
- Long-press gestures trigger alerts for bulk operations
- Alert inputs validated (negative values allowed, excess amounts clamped)

**State Management**:
- Card type toggles in ContentView update Tarmogoyf P/T via `onChange` modifiers
- All toggle buttons use `.toggleStyle(.button)` for button-like appearance
- Item changes are persisted automatically via SwiftData

## Important Implementation Details

- The app creates a single Tarmogoyf item on `ContentView.onAppear()`
- Updating Tarmogoyf P/T directly modifies `items.first?.pt`
- The `setItem()` function deletes ALL existing items before inserting a new one: `modelContext.delete(model: Item.self)`
- File headers reference "Doubling Season" - this was the original project name
- GraveStepper counters are currently non-functional (values tracked but not used)
