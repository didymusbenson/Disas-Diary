# Disas Diary (Flutter)

A Magic: The Gathering companion app for tracking Tarmogoyf's power/toughness and graveyard card types. Built with Flutter for iOS, Android, and Web.

## Features

- **Tarmogoyf P/T Calculator**: Automatically calculates Tarmogoyf's power and toughness based on card types in graveyards
- **Token Management**: Track token counts with tap/untap functionality
- **Graveyard Counters**: Eight customizable stepper counters for tracking various graveyard categories
- **Persistent State**: All state is saved between sessions
- **Always Awake**: Screen stays on during gameplay
- **Material Design 3**: Themed with Disa's Jund color identity (Green/Red/Black)

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- For iOS: Xcode and CocoaPods
- For Android: Android Studio and Android SDK
- For Web: Chrome or other modern browser

### Installation

1. Clone the repository
2. Navigate to the `disas_diary_flutter` directory
3. Install dependencies:
   ```bash
   flutter pub get
   ```

### Running the App

```bash
# Run on connected device/emulator
flutter run

# Run on specific platform
flutter run -d chrome        # Web
flutter run -d ios           # iOS
flutter run -d android       # Android
```

### Building for Release

```bash
# Android APK
flutter build apk

# iOS
flutter build ios

# Web
flutter build web
```

## Architecture

This app uses:
- **Provider** for state management
- **SharedPreferences** for persistence
- **WakelockPlus** for keeping the screen awake
- **Material Design 3** for UI components

## Migration from Swift

This Flutter app is a cross-platform port of the original iOS SwiftUI application, maintaining full feature parity while adding support for Android and Web platforms.
