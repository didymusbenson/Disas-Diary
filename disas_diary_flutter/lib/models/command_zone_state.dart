import 'trigger_tracker.dart';

/// Model class representing the full Command Zone tracker state
class CommandZoneGameState {
  // --- Named Constants ---

  /// Maximum poison counters before a player loses
  static const int maxPoisonCounters = 10;

  /// Maximum ring temptation level (4 stages: 0-4)
  static const int maxRingLevel = 4;

  /// Minimum ring temptation level
  static const int minRingLevel = 0;

  /// Maximum number of opponents for commander damage tracking
  static const int maxOpponents = 8;

  /// Minimum number of opponents
  static const int minOpponents = 1;

  /// Default number of opponents (Commander is typically 4-player)
  static const int defaultOpponentCount = 3;

  /// Commander tax increment per cast
  static const int commanderTaxIncrement = 2;

  /// Default starting life for Commander format
  static const int defaultStartingLife = 40;

  /// Alternative starting life for non-Commander formats
  static const int alternativeStartingLife = 20;

  // --- Core Counters ---

  final int lifeTotal;
  final int poisonCounters;
  final int energyCounters;
  final int experienceCounters;
  final int tickets;
  final int radCounters;

  // --- Status Indicators ---

  /// Day/night status: null = neither, true = day, false = night
  final bool? dayNight;
  final bool isMonarch;
  final bool hasCityBlessing;
  final bool hasInitiative;

  // --- Per-Turn Trackers ---

  final List<TriggerTracker> triggerTrackers;

  // --- Ring Temptation ---

  final int ringTemptationLevel;

  // --- Commander-Specific ---

  /// Commander damage per opponent, per commander
  /// Always 2 entries: index 0 = commander, index 1 = partner
  /// Partner damage is per-opponent (each opponent may independently have a partner)
  final List<Map<int, int>> commanderDamage;

  /// Commander tax: always 2 entries [commander, partner]
  /// Partner tax shows when commanderTax[1] > 0
  final List<int> commanderTax;

  /// Number of opponents being tracked
  final int opponentCount;

  // --- Settings ---

  final int startingLife;

  CommandZoneGameState({
    required this.lifeTotal,
    required this.poisonCounters,
    required this.energyCounters,
    required this.experienceCounters,
    required this.tickets,
    required this.radCounters,
    required this.dayNight,
    required this.isMonarch,
    required this.hasCityBlessing,
    required this.hasInitiative,
    required this.triggerTrackers,
    required this.ringTemptationLevel,
    required this.commanderDamage,
    required this.commanderTax,
    required this.opponentCount,
    required this.startingLife,
  });

  /// Create initial state with configurable starting life
  factory CommandZoneGameState.initial({int startingLife = defaultStartingLife}) {
    return CommandZoneGameState(
      lifeTotal: startingLife,
      poisonCounters: 0,
      energyCounters: 0,
      experienceCounters: 0,
      tickets: 0,
      radCounters: 0,
      dayNight: null,
      isMonarch: false,
      hasCityBlessing: false,
      hasInitiative: false,
      triggerTrackers: TriggerTracker.defaults(),
      ringTemptationLevel: minRingLevel,
      commanderDamage: [{}, {}],
      commanderTax: [0, 0],
      opponentCount: defaultOpponentCount,
      startingLife: startingLife,
    );
  }

  /// Convert to JSON for persistence
  Map<String, dynamic> toJson() {
    return {
      'life_total': lifeTotal,
      'poison_counters': poisonCounters,
      'energy_counters': energyCounters,
      'experience_counters': experienceCounters,
      'tickets': tickets,
      'rad_counters': radCounters,
      'day_night': dayNight,
      'is_monarch': isMonarch,
      'has_city_blessing': hasCityBlessing,
      'has_initiative': hasInitiative,
      'trigger_trackers': triggerTrackers.map((t) => t.toJson()).toList(),
      'ring_temptation_level': ringTemptationLevel,
      'commander_damage': commanderDamage
          .map((m) => m.map((key, value) => MapEntry(key.toString(), value)))
          .toList(),
      'commander_tax': commanderTax,
      'opponent_count': opponentCount,
      'starting_life': startingLife,
    };
  }

  /// Create from JSON
  factory CommandZoneGameState.fromJson(Map<String, dynamic> json) {
    // Migration: old format had individual fields
    List<TriggerTracker> trackers;
    if (json.containsKey('trigger_trackers')) {
      trackers = (json['trigger_trackers'] as List)
          .map((t) => TriggerTracker.fromJson(t as Map<String, dynamic>))
          .toList();
    } else {
      trackers = [
        TriggerTracker(
          id: TriggerTracker.stormId,
          label: 'Storm',
          isDefault: true,
          value: json['storm_count'] as int? ?? 0,
        ),
        TriggerTracker(
          id: TriggerTracker.landsId,
          label: 'Lands',
          isDefault: true,
          value: json['land_drops'] as int? ?? 0,
        ),
        TriggerTracker(
          id: TriggerTracker.cardsDrawnId,
          label: 'Cards Drawn',
          isDefault: true,
          value: json['cards_drawn_this_turn'] as int? ?? 0,
        ),
      ];
    }

    return CommandZoneGameState(
      lifeTotal: json['life_total'] as int,
      poisonCounters: json['poison_counters'] as int,
      energyCounters: json['energy_counters'] as int,
      experienceCounters: json['experience_counters'] as int,
      tickets: json['tickets'] as int,
      radCounters: json['rad_counters'] as int,
      dayNight: json['day_night'] as bool?,
      isMonarch: json['is_monarch'] as bool,
      hasCityBlessing: json['has_city_blessing'] as bool,
      hasInitiative: json['has_initiative'] as bool,
      triggerTrackers: trackers,
      ringTemptationLevel: json['ring_temptation_level'] as int,
      commanderDamage: _migrateDamageMaps(json['commander_damage'] as List),
      commanderTax: _migrateTaxList(json['commander_tax'] as List),
      opponentCount: json['opponent_count'] as int,
      startingLife: json['starting_life'] as int,
    );
  }

  /// Create a copy with updated fields
  CommandZoneGameState copyWith({
    int? lifeTotal,
    int? poisonCounters,
    int? energyCounters,
    int? experienceCounters,
    int? tickets,
    int? radCounters,
    bool? Function()? dayNight,
    bool? isMonarch,
    bool? hasCityBlessing,
    bool? hasInitiative,
    List<TriggerTracker>? triggerTrackers,
    int? ringTemptationLevel,
    List<Map<int, int>>? commanderDamage,
    List<int>? commanderTax,
    int? opponentCount,
    int? startingLife,
  }) {
    return CommandZoneGameState(
      lifeTotal: lifeTotal ?? this.lifeTotal,
      poisonCounters: poisonCounters ?? this.poisonCounters,
      energyCounters: energyCounters ?? this.energyCounters,
      experienceCounters: experienceCounters ?? this.experienceCounters,
      tickets: tickets ?? this.tickets,
      radCounters: radCounters ?? this.radCounters,
      dayNight: dayNight != null ? dayNight() : this.dayNight,
      isMonarch: isMonarch ?? this.isMonarch,
      hasCityBlessing: hasCityBlessing ?? this.hasCityBlessing,
      hasInitiative: hasInitiative ?? this.hasInitiative,
      triggerTrackers: triggerTrackers ?? this.triggerTrackers,
      ringTemptationLevel: ringTemptationLevel ?? this.ringTemptationLevel,
      commanderDamage: commanderDamage ?? this.commanderDamage,
      commanderTax: commanderTax ?? this.commanderTax,
      opponentCount: opponentCount ?? this.opponentCount,
      startingLife: startingLife ?? this.startingLife,
    );
  }

  /// Ensure damage maps always have 2 entries (migration from old format)
  static List<Map<int, int>> _migrateDamageMaps(List raw) {
    final maps = raw
        .map((m) => (m as Map<String, dynamic>)
            .map((key, value) => MapEntry(int.parse(key), value as int)))
        .toList();
    while (maps.length < 2) {
      maps.add(<int, int>{});
    }
    return maps;
  }

  /// Ensure tax list always has 2 entries (migration from old format)
  static List<int> _migrateTaxList(List raw) {
    final list = raw.map((e) => e as int).toList();
    while (list.length < 2) {
      list.add(0);
    }
    return list;
  }
}
