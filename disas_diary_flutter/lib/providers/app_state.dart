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

  AppState(this._persistence) {
    _loadState();
  }

  // Getters
  Item? get item => _item;
  Map<String, bool> get cardTypes => _cardTypes;
  List<GraveStepperData> get graveSteppers => _graveSteppers;
  bool get useSystemTheme => _useSystemTheme;
  bool get useDarkMode => _useDarkMode;

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
