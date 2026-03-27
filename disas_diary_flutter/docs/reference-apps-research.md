# Reference App Research: Doubling Season & French Vanilla

Research conducted 2026-03-26 to document design patterns and decisions from the developer's other MTG Flutter apps, for use as reference when building the Disas Diary toolkit.

---

## Doubling Season (Token Tracker)

### Overview
Cross-platform Flutter app for tracking MTG tokens during gameplay. Manages token stacks with tapped/untapped states, summoning sickness, counters, artwork display, and a searchable database of 913 token types. Version 1.8.0+16.

### State Management: Provider + Hive

**5 ChangeNotifierProviders**, all initialized in parallel at boot:

| Provider | Storage | Purpose |
|----------|---------|---------|
| TokenProvider | Hive box `items` | Live board tokens |
| DeckProvider | Hive box `decks` | Saved decks |
| SettingsProvider | SharedPreferences | User preferences |
| TrackerProvider | Hive box `trackerWidgets` | Tracker utilities |
| ToggleProvider | Hive box `toggleWidgets` | Toggle utilities |

**Critical pattern**: `MultiProvider` wraps `MaterialApp`, not individual screens. This ensures all providers are available to ALL routes pushed via `Navigator.push()`.

```dart
return MultiProvider(
  providers: [...],
  child: MaterialApp(home: ContentScreen()),
)
```

**Reactive updates** use `ListenableBuilder` with `Listenable.merge()` for efficient multi-provider listening. `Selector` is used for targeted rebuilds on specific fields only.

### Data Persistence: Hive

**Resilient boot** (`hive_setup.dart`): Never throws. If a box fails to open, attempts backup restore, then deletes corrupt files and opens empty. User sees a "Data Reset" dialog listing what was lost.

**Type IDs are immutable** (changing them causes data corruption):
```
0: Item, 1: TokenCounter, 2: Deck, 3: TokenTemplate,
4: ArtworkVariant, 5: TokenArtworkPreference,
6: TrackerWidget, 7: ToggleWidget, 8-9: Templates
```

**Auto-save pattern**: All Hive model property setters call `.save()` automatically. For batch updates, dedicated methods like `updateArtwork()` exist.

**New fields must always have `defaultValue`** - without it, Hive can't deserialize old user data. Lesson learned from v1.7→v1.8 migration that lost user decks.

### Navigation

Traditional `Navigator.push(MaterialPageRoute(...))` throughout. No named routes.

**Main flow**: SplashScreen → ContentScreen (main board) → push to detail/search/deck screens.

**Screen architecture**:
- ContentScreen: Main board with ReorderableListView + FAB menu
- ExpandedTokenScreen: Full-screen token editor
- TokenSearchScreen: Database search with tabs (All/Recent/Favorites), dual mode (normal vs selector)
- DecksListScreen/DeckDetailScreen: Deck management

### UI Patterns

**TokenCard is the canonical widget** for all board items:
```
Stack layers: base background → color gradient → artwork → content → border
```

**ArtworkDisplayMixin** shared across TokenCard, TrackerWidgetCard, ToggleWidgetCard for consistent artwork rendering.

**Two artwork modes**: Full View (fills card) and Fadeout (right 50% with gradient fade).

**Theme**: Material 3 with light/dark support. Uses `ColorScheme.fromSeed(seedColor: Colors.grey)`. Dark mode has custom surface colors.

**Order field pattern** for reordering: `double order` on each item, fractional insertion `(a.order + b.order) / 2`.

### Event Bus

`GameEvents` singleton decouples providers. Example: when a creature token enters, TrackerProvider listens and auto-increments Cathar's Crusade counter without importing TokenProvider.

### Key Design Decisions

- **Snackbars removed** due to Flutter framework bugs
- **Summoning sickness applied AFTER Hive insert** (setter calls .save(), needs valid key)
- **Stack splitting: dismiss sheet BEFORE performing split** (avoids state crashes via `addPostFrameCallback`)
- **Search debounced at 300ms**
- **Token database loaded in background isolate** via `compute()`
- **Silent migrations** on boot (no user prompts for schema changes)

### Documentation Workflow

`docs/activeDevelopment/` preserves context between sessions:
- `todo_features/` → planned
- `in_progress_features/` → active work
- `bug_bashing/` → bug investigations
- `new_release/` → completed, awaiting release
- `patterns/` → reusable implementation patterns

---

## French Vanilla (Rules Reference)

### Overview
MTG comprehensive rules reference app. Browse rules by section, search across all content, bookmark rules with multi-list organization. Version 1.2.1+5.

### State Management: Singleton Services (No Provider)

**Key difference from Doubling Season**: French Vanilla does NOT use Provider for state management despite having it in pubspec. Uses singleton services + local StatefulWidget state.

| Service | Pattern | Purpose |
|---------|---------|---------|
| FavoritesService | Singleton + Operation Queue | Bookmark CRUD with race-condition prevention |
| RulesDataService | Singleton + Cache | Rules/glossary data |
| CardDataService | Singleton + Cache | Card rulings |
| JudgeDocsService | Singleton + Cache | MTR/IPG documents |
| IAPService | Singleton + Stream | In-app purchases |
| SearchHistoryService | Singleton | Recent searches (capped at 15) |
| DataPreloader | Singleton | Async preloading at startup |

**Race condition prevention** in FavoritesService: Custom Completer-based operation queue serializes all write operations. Prevents data loss when user rapidly toggles bookmarks.

### Navigation

Bottom Navigation Bar with 4 tabs: Rules, Search, Bookmarks, Credits. Standard `Navigator.push()` for hierarchical drill-down within tabs.

### Data Persistence

**Asset-based data** (bundled in app): Rules JSON files, card rulings, MTR/IPG documents.

**SharedPreferences** for user data: bookmarks, lists, search history.

**Multi-level caching**: Asset → SharedPreferences → In-memory. Fully offline, no remote API calls.

**Preloading**: Parallel `Future.wait()` for card rulings, MTR, IPG on startup (non-blocking).

### UI Patterns

**Mixin-based composition** (6 reusable mixins):
1. RuleLinkMixin — parse rule references into tappable links
2. FormattedContentMixin — render rule content with example callouts
3. PreviewBottomSheetMixin — consistent preview sheets with copy/share/bookmark
4. AggregatingSnackBarMixin — prevent snackbar queue spam (counts rapid triggers)
5. BookmarkListAssignmentMixin — post-bookmark list assignment UI
6. FormattedContentMixin — shared content parsing

**Theme**: Material 3, `ColorScheme.fromSeed(seedColor: Colors.deepPurple)`, light + dark with system mode.

### Key Design Decisions

- **No state management library** for a mostly-read app with limited mutations
- **Alphabetical sorting** for bookmarks (manual reorder deferred to Phase 2)
- **Loading dialogs** shown before slow navigations
- **Search**: Parallel execution across rules + cards, relevance scoring (exact > word boundary > starts with > contains)
- **IAP**: Converted root widget to StatefulWidget for proper stream disposal (fixed memory leak)

---

## Common Patterns Across Both Apps

### Shared Conventions
1. **Material 3** theming with light/dark support
2. **Wakelock** for gameplay apps (Doubling Season, Disas Diary)
3. **Privacy-first**: No analytics, no remote data collection
4. **Manual testing only** — no automated test suites
5. **Python scripts** for data processing pipelines
6. **docs/ directory** for development context preservation
7. **next_feature.md / NextFeature.md** for current development planning

### Architecture Choices By App Type
- **Gameplay apps** (Doubling Season, Disas Diary): Provider + Hive for reactive, persistent state
- **Reference apps** (French Vanilla): Singleton services + local state for read-heavy workflows

### Patterns Relevant to Disas Diary Toolkit

For the toolkit architecture (multi-tool navigation), Doubling Season is the closer reference:

1. **MultiProvider wrapping MaterialApp** — ensures all tools get provider access
2. **Hive for persistent tool state** — tools retain state when navigated away
3. **Resilient Hive boot** — never crash on corrupt data
4. **Order field with fractional insertion** — if tools need reordering
5. **Event bus for decoupled communication** — if tools need to interact
6. **ArtworkDisplayMixin pattern** — shared rendering logic across different widget types
7. **Listenable.merge + Selector** — efficient rebuilds when multiple providers change
8. **docs/activeDevelopment/ workflow** — context preservation between sessions
9. **Silent migrations** — schema changes without user prompts
10. **Auto-save via property setters** — consistent persistence pattern
