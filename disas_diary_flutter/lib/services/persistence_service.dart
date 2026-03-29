import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item.dart';
import '../models/grave_stepper_data.dart';
import '../models/attraction_deck.dart';
import '../models/attraction_game_state.dart';
import '../models/dungeon_game_state.dart';
import '../models/command_zone_state.dart';

/// Service for persisting application state
class PersistenceService {
  static const String _itemKey = 'tarmogoyf_item';
  static const String _cardTypesKey = 'card_types';
  static const String _graveSteppersKey = 'grave_steppers';
  static const String _useSystemThemeKey = 'use_system_theme';
  static const String _useDarkModeKey = 'use_dark_mode';
  static const String _manaPoolCountsKey = 'mana_pool_counts';
  static const String _manaPoolLocksKey = 'mana_pool_locks';
  static const String _attractionDecksKey = 'attraction_decks';
  static const String _attractionGameStateKey = 'attraction_game_state';
  static const String _dungeonGameStateKey = 'dungeon_game_state';
  static const String _attractionDiceCountKey = 'attraction_dice_count';
  static const String _commandZoneStateKey = 'command_zone_state';

  final SharedPreferences _prefs;

  PersistenceService(this._prefs);

  /// Save the Tarmogoyf item
  Future<void> saveItem(Item item) async {
    final json = jsonEncode(item.toJson());
    await _prefs.setString(_itemKey, json);
  }

  /// Load the Tarmogoyf item
  Item? loadItem() {
    final json = _prefs.getString(_itemKey);
    if (json == null) return null;

    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return Item.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  /// Save card type toggles
  Future<void> saveCardTypes(Map<String, bool> cardTypes) async {
    final json = jsonEncode(cardTypes);
    await _prefs.setString(_cardTypesKey, json);
  }

  /// Load card type toggles
  Map<String, bool> loadCardTypes() {
    final json = _prefs.getString(_cardTypesKey);
    if (json == null) return _defaultCardTypes();

    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return map.map((key, value) => MapEntry(key, value as bool));
    } catch (e) {
      return _defaultCardTypes();
    }
  }

  /// Save grave stepper data
  Future<void> saveGraveSteppers(List<GraveStepperData> steppers) async {
    final json = jsonEncode(steppers.map((s) => s.toJson()).toList());
    await _prefs.setString(_graveSteppersKey, json);
  }

  /// Load grave stepper data
  List<GraveStepperData> loadGraveSteppers() {
    final json = _prefs.getString(_graveSteppersKey);
    if (json == null) return _defaultGraveSteppers();

    try {
      final list = jsonDecode(json) as List;
      final steppers = list.map((item) => GraveStepperData.fromJson(item as Map<String, dynamic>)).toList();

      // Migrate old labels to current labels
      return steppers.map((stepper) {
        if (stepper.name == 'My Types') {
          return GraveStepperData(name: 'Your Types', value: stepper.value);
        } else if (stepper.name == 'My Creatures') {
          return GraveStepperData(name: 'Your Creatures', value: stepper.value);
        } else if (stepper.name == 'Sorceriess') {
          return GraveStepperData(name: 'Sorceries', value: stepper.value);
        }
        return stepper;
      }).toList();
    } catch (e) {
      return _defaultGraveSteppers();
    }
  }

  /// Save use system theme preference
  Future<void> saveUseSystemTheme(bool value) async {
    await _prefs.setBool(_useSystemThemeKey, value);
  }

  /// Load use system theme preference
  bool loadUseSystemTheme() {
    return _prefs.getBool(_useSystemThemeKey) ?? true; // Default to system theme
  }

  /// Save use dark mode preference
  Future<void> saveUseDarkMode(bool value) async {
    await _prefs.setBool(_useDarkModeKey, value);
  }

  /// Load use dark mode preference
  bool loadUseDarkMode() {
    return _prefs.getBool(_useDarkModeKey) ?? false; // Default to light mode
  }

  /// Save mana pool counts
  Future<void> saveManaPoolCounts(Map<String, int> counts) async {
    final json = jsonEncode(counts);
    await _prefs.setString(_manaPoolCountsKey, json);
  }

  /// Load mana pool counts
  Map<String, int> loadManaPoolCounts() {
    final json = _prefs.getString(_manaPoolCountsKey);
    if (json == null) return _defaultManaPoolCounts();

    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return map.map((key, value) => MapEntry(key, value as int));
    } catch (e) {
      return _defaultManaPoolCounts();
    }
  }

  /// Save mana pool lock states
  Future<void> saveManaPoolLocks(Map<String, bool> locks) async {
    final json = jsonEncode(locks);
    await _prefs.setString(_manaPoolLocksKey, json);
  }

  /// Load mana pool lock states
  Map<String, bool> loadManaPoolLocks() {
    final json = _prefs.getString(_manaPoolLocksKey);
    if (json == null) return _defaultManaPoolLocks();

    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return map.map((key, value) => MapEntry(key, value as bool));
    } catch (e) {
      return _defaultManaPoolLocks();
    }
  }

  /// Save attraction decks
  Future<void> saveAttractionDecks(List<AttractionDeck> decks) async {
    final json = jsonEncode(decks.map((d) => d.toJson()).toList());
    await _prefs.setString(_attractionDecksKey, json);
  }

  /// Load attraction decks
  List<AttractionDeck> loadAttractionDecks() {
    final json = _prefs.getString(_attractionDecksKey);
    if (json == null) return [];

    try {
      final list = jsonDecode(json) as List;
      return list
          .map((item) =>
              AttractionDeck.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Save attraction game state
  Future<void> saveAttractionGameState(AttractionGameState state) async {
    final json = jsonEncode(state.toJson());
    await _prefs.setString(_attractionGameStateKey, json);
  }

  /// Load attraction game state (null means no game in progress)
  AttractionGameState? loadAttractionGameState() {
    final json = _prefs.getString(_attractionGameStateKey);
    if (json == null) return null;

    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return AttractionGameState.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  /// Clear attraction game state
  Future<void> clearAttractionGameState() async {
    await _prefs.remove(_attractionGameStateKey);
  }

  /// Save attraction dice count
  Future<void> saveAttractionDiceCount(int count) async {
    await _prefs.setInt(_attractionDiceCountKey, count);
  }

  /// Load attraction dice count (defaults to 1)
  int loadAttractionDiceCount() {
    return _prefs.getInt(_attractionDiceCountKey) ?? 1;
  }

  /// Save dungeon game state
  Future<void> saveDungeonGameState(DungeonGameState state) async {
    final json = jsonEncode(state.toJson());
    await _prefs.setString(_dungeonGameStateKey, json);
  }

  /// Load dungeon game state (null means no state saved)
  DungeonGameState? loadDungeonGameState() {
    final json = _prefs.getString(_dungeonGameStateKey);
    if (json == null) return null;

    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return DungeonGameState.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  /// Clear dungeon game state
  Future<void> clearDungeonGameState() async {
    await _prefs.remove(_dungeonGameStateKey);
  }

  /// Save command zone state
  Future<void> saveCommandZoneState(CommandZoneGameState state) async {
    final json = jsonEncode(state.toJson());
    await _prefs.setString(_commandZoneStateKey, json);
  }

  /// Load command zone state (null means no state saved)
  CommandZoneGameState? loadCommandZoneState() {
    final json = _prefs.getString(_commandZoneStateKey);
    if (json == null) return null;

    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return CommandZoneGameState.fromJson(map);
    } catch (e) {
      return null;
    }
  }

  /// Clear command zone state
  Future<void> clearCommandZoneState() async {
    await _prefs.remove(_commandZoneStateKey);
  }

  /// Clear all persisted data
  Future<void> clearAll() async {
    await _prefs.remove(_itemKey);
    await _prefs.remove(_cardTypesKey);
    await _prefs.remove(_graveSteppersKey);
    await _prefs.remove(_manaPoolCountsKey);
    await _prefs.remove(_manaPoolLocksKey);
    await _prefs.remove(_attractionGameStateKey);
    await _prefs.remove(_dungeonGameStateKey);
    await _prefs.remove(_commandZoneStateKey);
    // Note: Theme preferences and attraction decks are intentionally NOT cleared on reset
  }

  /// Default card types (all false)
  Map<String, bool> _defaultCardTypes() {
    return {
      'artifact': false,
      'creature': false,
      'enchantment': false,
      'instant': false,
      'sorcery': false,
      'land': false,
      'planeswalker': false,
      'battle': false,
      'kindred': false,
    };
  }

  /// Default mana pool counts (all zero)
  Map<String, int> _defaultManaPoolCounts() {
    return {'W': 0, 'U': 0, 'B': 0, 'R': 0, 'G': 0, 'C': 0};
  }

  /// Default mana pool locks (all unlocked)
  Map<String, bool> _defaultManaPoolLocks() {
    return {'W': false, 'U': false, 'B': false, 'R': false, 'G': false, 'C': false};
  }

  /// Default grave steppers
  List<GraveStepperData> _defaultGraveSteppers() {
    return [
      GraveStepperData(name: 'Your Types'),
      GraveStepperData(name: 'Your Creatures'),
      GraveStepperData(name: 'All Creatures'),
      GraveStepperData(name: 'Instants'),
      GraveStepperData(name: 'Sorceries'),
      GraveStepperData(name: 'Lands'),
      GraveStepperData(name: 'Nonbasic lands'),
      GraveStepperData(name: 'Enchantments'),
    ];
  }
}
