import 'package:flutter/material.dart';
import '../models/item.dart';
import '../models/grave_stepper_data.dart';
import '../services/persistence_service.dart';

/// Main application state provider
class AppState extends ChangeNotifier {
  final PersistenceService _persistence;

  Item? _item;
  Map<String, bool> _cardTypes = {};
  List<GraveStepperData> _graveSteppers = [];
  bool _useSystemTheme = true;
  bool _useDarkMode = false;
  Map<String, int> _manaPoolCounts = {};
  Map<String, bool> _manaPoolLocks = {};

  AppState(this._persistence) {
    _loadState();
  }

  // Getters
  Item? get item => _item;
  Map<String, bool> get cardTypes => _cardTypes;
  List<GraveStepperData> get graveSteppers => _graveSteppers;
  bool get useSystemTheme => _useSystemTheme;
  bool get useDarkMode => _useDarkMode;
  Map<String, int> get manaPoolCounts => _manaPoolCounts;
  Map<String, bool> get manaPoolLocks => _manaPoolLocks;

  /// Get the current theme mode based on preferences
  ThemeMode get themeMode {
    if (_useSystemTheme) {
      return ThemeMode.system;
    }
    return _useDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  /// Load state from persistence
  void _loadState() {
    _item = _persistence.loadItem();
    _cardTypes = _persistence.loadCardTypes();
    _graveSteppers = _persistence.loadGraveSteppers();
    _useSystemTheme = _persistence.loadUseSystemTheme();
    _useDarkMode = _persistence.loadUseDarkMode();
    _manaPoolCounts = _persistence.loadManaPoolCounts();
    _manaPoolLocks = _persistence.loadManaPoolLocks();

    // If no item exists, create the default Tarmogoyf
    if (_item == null) {
      _createDefaultTarmogoyf();
    }
  }

  /// Create the default Tarmogoyf item
  void _createDefaultTarmogoyf() {
    _item = Item(
      abilities: "Tarmogoyf's power is equal to the number of card types among cards in all graveyards and its toughness is equal to that number plus 1.",
      name: 'Tarmogoyf',
      pt: '*/*+1',
      colors: 'G',
      amount: 1,
      createTapped: false,
    );
    _persistence.saveItem(_item!);
    notifyListeners();
  }

  /// Update card type toggle
  void setCardType(String type, bool value) {
    _cardTypes[type] = value;
    _updateGoyfPt();
    _persistence.saveCardTypes(_cardTypes);
    notifyListeners();
  }

  /// Update Tarmogoyf P/T based on card types
  void _updateGoyfPt() {
    if (_item == null) return;

    int uniqueCards = 0;
    _cardTypes.forEach((key, value) {
      if (value) uniqueCards++;
    });

    String newPt;
    if (uniqueCards == 0) {
      newPt = '*/*+1';
    } else {
      newPt = '$uniqueCards/${uniqueCards + 1}';
    }

    _item = _item!.copyWith(pt: newPt);
    _persistence.saveItem(_item!);
  }

  /// Update item token count
  void updateTokenAmount(int amount) {
    if (_item == null) return;

    // Ensure tapped count doesn't exceed total amount
    final newTapped = _item!.tapped > amount ? amount : _item!.tapped;

    _item = _item!.copyWith(
      amount: amount,
      tapped: newTapped,
    );

    _persistence.saveItem(_item!);
    notifyListeners();
  }

  /// Update item tapped count
  void updateTokenTapped(int tapped) {
    if (_item == null) return;

    // Ensure tapped count doesn't exceed total amount
    final newTapped = tapped > _item!.amount ? _item!.amount : tapped;

    _item = _item!.copyWith(tapped: newTapped);
    _persistence.saveItem(_item!);
    notifyListeners();
  }

  /// Add tokens (increment amount)
  void addTokens(int count) {
    if (_item == null) return;
    updateTokenAmount(_item!.amount + count);
  }

  /// Remove tokens (decrement amount)
  void removeTokens(int count) {
    if (_item == null) return;
    final newAmount = (_item!.amount - count).clamp(0, double.infinity).toInt();
    updateTokenAmount(newAmount);
  }

  /// Tap tokens (increment tapped)
  void tapTokens(int count) {
    if (_item == null) return;
    final newTapped = (_item!.tapped + count).clamp(0, _item!.amount).toInt();
    updateTokenTapped(newTapped);
  }

  /// Untap tokens (decrement tapped)
  void untapTokens(int count) {
    if (_item == null) return;
    final newTapped = (_item!.tapped - count).clamp(0, _item!.amount).toInt();
    updateTokenTapped(newTapped);
  }

  /// Reset token counts to zero
  void resetTokens() {
    if (_item == null) return;
    _item = _item!.copyWith(amount: 0, tapped: 0);
    _persistence.saveItem(_item!);
    notifyListeners();
  }

  /// Update grave stepper value
  void updateGraveStepperValue(int index, int value) {
    if (index < 0 || index >= _graveSteppers.length) return;

    _graveSteppers[index].value = value.clamp(0, 999);
    _persistence.saveGraveSteppers(_graveSteppers);
    notifyListeners();
  }

  /// Increment grave stepper
  void incrementGraveStepper(int index) {
    if (index < 0 || index >= _graveSteppers.length) return;
    updateGraveStepperValue(index, _graveSteppers[index].value + 1);
  }

  /// Decrement grave stepper
  void decrementGraveStepper(int index) {
    if (index < 0 || index >= _graveSteppers.length) return;
    updateGraveStepperValue(index, _graveSteppers[index].value - 1);
  }

  // --- Mana Pool ---

  /// Increment mana for a color
  void incrementMana(String color, int amount) {
    _manaPoolCounts[color] = (_manaPoolCounts[color] ?? 0) + amount;
    _persistence.saveManaPoolCounts(_manaPoolCounts);
    notifyListeners();
  }

  /// Decrement mana for a color (clamped to 0)
  void decrementMana(String color, int amount) {
    final current = _manaPoolCounts[color] ?? 0;
    _manaPoolCounts[color] = (current - amount).clamp(0, current);
    _persistence.saveManaPoolCounts(_manaPoolCounts);
    notifyListeners();
  }

  /// Toggle lock state for a mana color
  void toggleManaLock(String color) {
    _manaPoolLocks[color] = !(_manaPoolLocks[color] ?? false);
    _persistence.saveManaPoolLocks(_manaPoolLocks);
    notifyListeners();
  }

  /// Empty all unlocked mana pools
  void emptyManaPool() {
    for (final color in _manaPoolCounts.keys) {
      if (_manaPoolLocks[color] != true) {
        _manaPoolCounts[color] = 0;
      }
    }
    _persistence.saveManaPoolCounts(_manaPoolCounts);
    notifyListeners();
  }

  /// Convert all colored mana to colorless
  void convertToColorless() {
    final coloredKeys = ['W', 'U', 'B', 'R', 'G'];
    int sum = 0;
    for (final key in coloredKeys) {
      sum += _manaPoolCounts[key] ?? 0;
      _manaPoolCounts[key] = 0;
    }
    _manaPoolCounts['C'] = (_manaPoolCounts['C'] ?? 0) + sum;
    _persistence.saveManaPoolCounts(_manaPoolCounts);
    notifyListeners();
  }

  /// Convert all mana to a target color
  void convertToColor(String targetColor) {
    int sum = 0;
    for (final key in _manaPoolCounts.keys) {
      if (key != targetColor) {
        sum += _manaPoolCounts[key] ?? 0;
        _manaPoolCounts[key] = 0;
      }
    }
    _manaPoolCounts[targetColor] = (_manaPoolCounts[targetColor] ?? 0) + sum;
    _persistence.saveManaPoolCounts(_manaPoolCounts);
    notifyListeners();
  }

  /// Reset all state to defaults
  Future<void> resetAll() async {
    await _persistence.clearAll();
    _loadState();
    notifyListeners();
  }

  /// Set use system theme preference
  void setUseSystemTheme(bool value) {
    _useSystemTheme = value;
    _persistence.saveUseSystemTheme(value);
    notifyListeners();
  }

  /// Set use dark mode preference
  void setUseDarkMode(bool value) {
    _useDarkMode = value;
    _persistence.saveUseDarkMode(value);
    notifyListeners();
  }
}
