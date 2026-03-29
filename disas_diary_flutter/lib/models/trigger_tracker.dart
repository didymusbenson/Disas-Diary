/// Model for a trigger tracker (per-turn counter)
class TriggerTracker {
  final String id;
  final String label;
  final bool isDefault;
  final bool isEnabled;
  final int value;

  static const String stormId = 'storm';
  static const String landsId = 'lands';
  static const String cardsDrawnId = 'cards_drawn';

  const TriggerTracker({
    required this.id,
    required this.label,
    required this.isDefault,
    this.isEnabled = true,
    this.value = 0,
  });

  static List<TriggerTracker> defaults() => const [
    TriggerTracker(id: stormId, label: 'Storm', isDefault: true),
    TriggerTracker(id: landsId, label: 'Lands', isDefault: true),
    TriggerTracker(id: cardsDrawnId, label: 'Cards Drawn', isDefault: true),
  ];

  TriggerTracker copyWith({String? label, bool? isEnabled, int? value}) {
    return TriggerTracker(
      id: id,
      label: label ?? this.label,
      isDefault: isDefault,
      isEnabled: isEnabled ?? this.isEnabled,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'is_default': isDefault,
    'is_enabled': isEnabled,
    'value': value,
  };

  factory TriggerTracker.fromJson(Map<String, dynamic> json) {
    return TriggerTracker(
      id: json['id'] as String,
      label: json['label'] as String,
      isDefault: json['is_default'] as bool,
      isEnabled: json['is_enabled'] as bool? ?? true,
      value: json['value'] as int? ?? 0,
    );
  }
}
