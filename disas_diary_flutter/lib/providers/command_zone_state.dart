import 'package:flutter/material.dart';
import '../models/command_zone_state.dart';
import '../models/trigger_tracker.dart';
import '../services/persistence_service.dart';

/// State provider for the Command Zone feature
class CommandZoneState extends ChangeNotifier {
  final PersistenceService _persistence;

  CommandZoneGameState _state = CommandZoneGameState.initial();
  bool _isLoaded = false;

  CommandZoneState(this._persistence);

  // --- Getters ---

  bool get isLoaded => _isLoaded;

  // Core Counters
  int get lifeTotal => _state.lifeTotal;
  int get poisonCounters => _state.poisonCounters;
  int get energyCounters => _state.energyCounters;
  int get experienceCounters => _state.experienceCounters;
  int get tickets => _state.tickets;
  int get radCounters => _state.radCounters;

  // Status Indicators
  bool? get dayNight => _state.dayNight;
  bool get isMonarch => _state.isMonarch;
  bool get hasCityBlessing => _state.hasCityBlessing;
  bool get hasInitiative => _state.hasInitiative;

  // Per-Turn Trackers
  List<TriggerTracker> get triggerTrackers => _state.triggerTrackers;
  List<TriggerTracker> get enabledTrackers =>
      _state.triggerTrackers.where((t) => t.isEnabled).toList();

  // Ring Temptation
  int get ringTemptationLevel => _state.ringTemptationLevel;

  // Commander-Specific
  List<Map<int, int>> get commanderDamage => _state.commanderDamage;
  List<int> get commanderTax => _state.commanderTax;
  int get opponentCount => _state.opponentCount;
  int get commanderCount => _state.commanderCount;

  // Settings
  int get startingLife => _state.startingLife;

  /// Whether poison counters have reached the lethal threshold
  bool get isPoisonLethal =>
      _state.poisonCounters >= CommandZoneGameState.maxPoisonCounters;

  /// Get commander damage for a specific commander and opponent
  int commanderDamageFor({required int commanderIndex, required int opponentIndex}) {
    if (commanderIndex < 0 || commanderIndex >= _state.commanderDamage.length) {
      return 0;
    }
    return _state.commanderDamage[commanderIndex][opponentIndex] ?? 0;
  }

  /// Get commander tax for a specific commander
  int commanderTaxFor(int commanderIndex) {
    if (commanderIndex < 0 || commanderIndex >= _state.commanderTax.length) {
      return 0;
    }
    return _state.commanderTax[commanderIndex];
  }

  // --- Initialization ---

  /// Load state from persistence
  Future<void> initialize() async {
    _state =
        _persistence.loadCommandZoneState() ?? CommandZoneGameState.initial();
    _isLoaded = true;
    notifyListeners();
  }

  // --- Core Counter Mutations ---

  /// Set life total to a specific value
  void setLifeTotal(int value) {
    _state = _state.copyWith(lifeTotal: value);
    _persistAndNotify();
  }

  /// Increment life total by the given amount (can be negative)
  void adjustLifeTotal(int delta) {
    _state = _state.copyWith(lifeTotal: _state.lifeTotal + delta);
    _persistAndNotify();
  }

  /// Set poison counters, clamped to valid range
  void setPoisonCounters(int value) {
    final clamped = value.clamp(0, CommandZoneGameState.maxPoisonCounters);
    _state = _state.copyWith(poisonCounters: clamped);
    _persistAndNotify();
  }

  /// Increment poison counters by the given amount (can be negative)
  void adjustPoisonCounters(int delta) {
    setPoisonCounters(_state.poisonCounters + delta);
  }

  /// Set energy counters (minimum 0)
  void setEnergyCounters(int value) {
    _state = _state.copyWith(energyCounters: value < 0 ? 0 : value);
    _persistAndNotify();
  }

  /// Increment energy counters by the given amount (can be negative)
  void adjustEnergyCounters(int delta) {
    setEnergyCounters(_state.energyCounters + delta);
  }

  /// Set experience counters (minimum 0)
  void setExperienceCounters(int value) {
    _state = _state.copyWith(experienceCounters: value < 0 ? 0 : value);
    _persistAndNotify();
  }

  /// Increment experience counters by the given amount (can be negative)
  void adjustExperienceCounters(int delta) {
    setExperienceCounters(_state.experienceCounters + delta);
  }

  /// Set tickets (minimum 0)
  void setTickets(int value) {
    _state = _state.copyWith(tickets: value < 0 ? 0 : value);
    _persistAndNotify();
  }

  /// Increment tickets by the given amount (can be negative)
  void adjustTickets(int delta) {
    setTickets(_state.tickets + delta);
  }

  /// Set rad counters (minimum 0)
  void setRadCounters(int value) {
    _state = _state.copyWith(radCounters: value < 0 ? 0 : value);
    _persistAndNotify();
  }

  /// Increment rad counters by the given amount (can be negative)
  void adjustRadCounters(int delta) {
    setRadCounters(_state.radCounters + delta);
  }

  // --- Status Indicator Mutations ---

  /// Toggle day/night: disabled -> day, then day <-> night
  void cycleDayNight() {
    final current = _state.dayNight;
    bool next;
    if (current == null) {
      next = true; // disabled -> day
    } else {
      next = !current; // day <-> night
    }
    _state = _state.copyWith(dayNight: () => next);
    _persistAndNotify();
  }

  /// Reset day/night back to disabled
  void resetDayNight() {
    _state = _state.copyWith(dayNight: () => null);
    _persistAndNotify();
  }

  /// Set day/night to a specific value (null = neither, true = day, false = night)
  void setDayNight(bool? value) {
    _state = _state.copyWith(dayNight: () => value);
    _persistAndNotify();
  }

  /// Toggle monarch status
  void toggleMonarch() {
    _state = _state.copyWith(isMonarch: !_state.isMonarch);
    _persistAndNotify();
  }

  /// Set monarch status
  void setMonarch(bool value) {
    _state = _state.copyWith(isMonarch: value);
    _persistAndNotify();
  }

  /// Toggle city's blessing
  void toggleCityBlessing() {
    _state = _state.copyWith(hasCityBlessing: !_state.hasCityBlessing);
    _persistAndNotify();
  }

  /// Set city's blessing
  void setCityBlessing(bool value) {
    _state = _state.copyWith(hasCityBlessing: value);
    _persistAndNotify();
  }

  /// Toggle initiative
  void toggleInitiative() {
    _state = _state.copyWith(hasInitiative: !_state.hasInitiative);
    _persistAndNotify();
  }

  /// Set initiative
  void setInitiative(bool value) {
    _state = _state.copyWith(hasInitiative: value);
    _persistAndNotify();
  }

  // --- Trigger Tracker Mutations ---

  /// Adjust a tracker's value by delta (minimum 0)
  void adjustTrackerValue(String trackerId, int delta) {
    final updated = _state.triggerTrackers.map((t) {
      if (t.id == trackerId) {
        final newValue = (t.value + delta) < 0 ? 0 : t.value + delta;
        return t.copyWith(value: newValue);
      }
      return t;
    }).toList();
    _state = _state.copyWith(triggerTrackers: updated);
    _persistAndNotify();
  }

  /// Add a custom tracker with a generated ID
  void addCustomTracker(String label) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final newTracker = TriggerTracker(
      id: id,
      label: label,
      isDefault: false,
    );
    final updated = [..._state.triggerTrackers, newTracker];
    _state = _state.copyWith(triggerTrackers: updated);
    _persistAndNotify();
  }

  /// Delete a custom tracker (default trackers cannot be deleted)
  void deleteTracker(String trackerId) {
    final updated = _state.triggerTrackers
        .where((t) => t.id != trackerId || t.isDefault)
        .toList();
    _state = _state.copyWith(triggerTrackers: updated);
    _persistAndNotify();
  }

  /// Toggle a tracker's enabled state
  void toggleTrackerEnabled(String trackerId) {
    final updated = _state.triggerTrackers.map((t) {
      if (t.id == trackerId) return t.copyWith(isEnabled: !t.isEnabled);
      return t;
    }).toList();
    _state = _state.copyWith(triggerTrackers: updated);
    _persistAndNotify();
  }

  /// Reset all per-turn tracker values to zero
  void resetTurnTrackers() {
    final updated = _state.triggerTrackers
        .map((t) => t.copyWith(value: 0))
        .toList();
    _state = _state.copyWith(triggerTrackers: updated);
    _persistAndNotify();
  }

  /// Reset trackers to defaults: re-enable defaults, disable custom, zero all values
  void resetTrackersToDefaults() {
    final updated = _state.triggerTrackers.map((t) {
      if (t.isDefault) return t.copyWith(isEnabled: true, value: 0);
      return t.copyWith(isEnabled: false, value: 0);
    }).toList();
    _state = _state.copyWith(triggerTrackers: updated);
    _persistAndNotify();
  }

  // --- Ring Temptation Mutations ---

  /// Increment ring temptation level (clamped to max)
  void temptWithRing() {
    if (_state.ringTemptationLevel < CommandZoneGameState.maxRingLevel) {
      _state = _state.copyWith(
          ringTemptationLevel: _state.ringTemptationLevel + 1);
      _persistAndNotify();
    }
  }

  /// Set ring temptation level directly (clamped to valid range)
  void setRingTemptationLevel(int level) {
    final clamped = level.clamp(
        CommandZoneGameState.minRingLevel, CommandZoneGameState.maxRingLevel);
    _state = _state.copyWith(ringTemptationLevel: clamped);
    _persistAndNotify();
  }

  // --- Commander Mutations ---

  /// Set commander damage for a specific commander and opponent
  void setCommanderDamage({
    required int commanderIndex,
    required int opponentIndex,
    required int damage,
  }) {
    if (commanderIndex < 0 || commanderIndex >= _state.commanderDamage.length) {
      return;
    }
    final updatedMaps =
        _state.commanderDamage.map((m) => Map<int, int>.from(m)).toList();
    updatedMaps[commanderIndex][opponentIndex] = damage < 0 ? 0 : damage;
    _state = _state.copyWith(commanderDamage: updatedMaps);
    _persistAndNotify();
  }

  /// Adjust commander damage for a specific commander and opponent
  void adjustCommanderDamage({
    required int commanderIndex,
    required int opponentIndex,
    required int delta,
  }) {
    final current = commanderDamageFor(
        commanderIndex: commanderIndex, opponentIndex: opponentIndex);
    setCommanderDamage(
      commanderIndex: commanderIndex,
      opponentIndex: opponentIndex,
      damage: current + delta,
    );
  }

  /// Increment commander tax for a specific commander
  void incrementCommanderTax(int commanderIndex) {
    if (commanderIndex < 0 || commanderIndex >= _state.commanderTax.length) {
      return;
    }
    final updatedTax = List<int>.from(_state.commanderTax);
    updatedTax[commanderIndex] += CommandZoneGameState.commanderTaxIncrement;
    _state = _state.copyWith(commanderTax: updatedTax);
    _persistAndNotify();
  }

  /// Decrement commander tax for a specific commander
  void decrementCommanderTax(int commanderIndex) {
    if (commanderIndex < 0 || commanderIndex >= _state.commanderTax.length) {
      return;
    }
    final updatedTax = List<int>.from(_state.commanderTax);
    final newValue = updatedTax[commanderIndex] - CommandZoneGameState.commanderTaxIncrement;
    updatedTax[commanderIndex] = newValue < 0 ? 0 : newValue;
    _state = _state.copyWith(commanderTax: updatedTax);
    _persistAndNotify();
  }

  /// Reset commander tax for a specific commander
  void resetCommanderTax(int commanderIndex) {
    if (commanderIndex < 0 || commanderIndex >= _state.commanderTax.length) {
      return;
    }
    final updatedTax = List<int>.from(_state.commanderTax);
    updatedTax[commanderIndex] = 0;
    _state = _state.copyWith(commanderTax: updatedTax);
    _persistAndNotify();
  }

  /// Set the number of opponents (adjusts commander damage maps)
  void setOpponentCount(int count) {
    final clamped = count.clamp(
        CommandZoneGameState.minOpponents, CommandZoneGameState.maxOpponents);

    // Trim commander damage maps to remove entries for removed opponents
    final updatedMaps = _state.commanderDamage.map((m) {
      final trimmed = Map<int, int>.from(m);
      trimmed.removeWhere((key, _) => key >= clamped);
      return trimmed;
    }).toList();

    _state = _state.copyWith(
      opponentCount: clamped,
      commanderDamage: updatedMaps,
    );
    _persistAndNotify();
  }

  /// Set the number of commanders (1 or 2 for partner support)
  void setCommanderCount(int count) {
    final clamped = count.clamp(
        CommandZoneGameState.minCommanders, CommandZoneGameState.maxCommanders);

    List<Map<int, int>> updatedDamage;
    List<int> updatedTax;

    if (clamped > _state.commanderDamage.length) {
      // Adding a commander: append empty damage map and zero tax
      updatedDamage = [
        ...List<Map<int, int>>.from(
            _state.commanderDamage.map((m) => Map<int, int>.from(m))),
        {},
      ];
      updatedTax = [..._state.commanderTax, 0];
    } else if (clamped < _state.commanderDamage.length) {
      // Removing a commander: trim to new count
      updatedDamage = _state.commanderDamage
          .take(clamped)
          .map((m) => Map<int, int>.from(m))
          .toList();
      updatedTax = _state.commanderTax.take(clamped).toList();
    } else {
      return; // No change
    }

    _state = _state.copyWith(
      commanderCount: clamped,
      commanderDamage: updatedDamage,
      commanderTax: updatedTax,
    );
    _persistAndNotify();
  }

  // --- Settings ---

  /// Set starting life and reset life total to new starting value
  void setStartingLife(int life) {
    _state = _state.copyWith(
      startingLife: life,
      lifeTotal: life,
    );
    _persistAndNotify();
  }

  // --- Reset ---

  /// Reset all state to initial values
  void resetAll({
    bool resetTrackersToDefault = true,
    bool resetCommanderConfig = true,
  }) {
    final preservedTrackers = resetTrackersToDefault
        ? _state.triggerTrackers.map((t) {
            if (t.isDefault) return t.copyWith(isEnabled: true, value: 0);
            return t.copyWith(isEnabled: false, value: 0);
          }).toList()
        : _state.triggerTrackers.map((t) => t.copyWith(value: 0)).toList();

    var newState = CommandZoneGameState.initial(startingLife: _state.startingLife)
        .copyWith(triggerTrackers: preservedTrackers);

    if (!resetCommanderConfig) {
      newState = newState.copyWith(
        opponentCount: _state.opponentCount,
        commanderCount: _state.commanderCount,
        commanderDamage: List.generate(
          _state.commanderCount, (_) => <int, int>{}),
        commanderTax: List.filled(_state.commanderCount, 0),
      );
    }

    _state = newState;
    _persistence.clearCommandZoneState();
    notifyListeners();
  }

  // --- Private Helpers ---

  void _persistAndNotify() {
    _persistence.saveCommandZoneState(_state);
    notifyListeners();
  }
}
