import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item.dart';
import '../models/grave_stepper_data.dart';

/// Service for persisting application state
class PersistenceService {
  static const String _itemKey = 'tarmogoyf_item';
  static const String _cardTypesKey = 'card_types';
  static const String _graveSteppersKey = 'grave_steppers';

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

      // Migrate old "My Types" and "My Creatures" labels to "Your Types" and "Your Creatures"
      return steppers.map((stepper) {
        if (stepper.name == 'My Types') {
          return GraveStepperData(name: 'Your Types', value: stepper.value);
        } else if (stepper.name == 'My Creatures') {
          return GraveStepperData(name: 'Your Creatures', value: stepper.value);
        }
        return stepper;
      }).toList();
    } catch (e) {
      return _defaultGraveSteppers();
    }
  }

  /// Clear all persisted data
  Future<void> clearAll() async {
    await _prefs.remove(_itemKey);
    await _prefs.remove(_cardTypesKey);
    await _prefs.remove(_graveSteppersKey);
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

  /// Default grave steppers
  List<GraveStepperData> _defaultGraveSteppers() {
    return [
      GraveStepperData(name: 'Your Types'),
      GraveStepperData(name: 'Your Creatures'),
      GraveStepperData(name: 'All Creatures'),
      GraveStepperData(name: 'Instants'),
      GraveStepperData(name: 'Sorceriess'), // Keep original typo for consistency
      GraveStepperData(name: 'Lands'),
      GraveStepperData(name: 'Nonbasic lands'),
      GraveStepperData(name: 'Enchantments'),
    ];
  }
}
