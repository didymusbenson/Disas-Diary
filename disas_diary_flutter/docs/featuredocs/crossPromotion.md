# Cross Promotion

Promote companion MTG apps from the main tool menu.

## Overview

Display menu items for French Vanilla and Tripling Season at the bottom of the home screen tool list. These are sister apps in the MTG toolkit ecosystem and should be easy for users to discover and open.

## Apps

### French Vanilla
- **Description:** Searchable Magic: The Gathering comprehensive rulebook
- **Function:** Quick keyword search across the full MTG rules document

### Tripling Season
- **Description:** Token and board state manager for Magic: The Gathering
- **Function:** Track tokens, counters, and complex board states

## Menu Placement

- Display both apps at the bottom of the home screen tool menu, visually separated from Disa's Diary's own tools (e.g. divider or "More Tools" section header)
- Each entry shows the app name, a brief description, and an icon/link indicator

## Smart Linking Behavior

Platform-aware linking that picks the best action:

### iOS
1. Attempt to open the app via its custom URL scheme or universal link
2. If the app is not installed, redirect to the App Store product page

### Android
1. Attempt to open the app via its package intent or deep link
2. If the app is not installed, redirect to the Google Play Store listing

### Web
- Link directly to the app's web version URL

## Open Questions

- App Store IDs / bundle identifiers for French Vanilla and Tripling Season
- Custom URL schemes or universal links configured for each app
- Web URLs for each app
- Icon assets — use each app's icon or a generic external link indicator?
- Should we check install status before showing, or always show both?

## Status

Spec in progress — needs app identifiers and link configuration.
