/// Data model for a grave stepper counter
class GraveStepperData {
  final String name;
  int value;

  GraveStepperData({
    required this.name,
    this.value = 0,
  });

  /// Convert to JSON for persistence
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }

  /// Create from JSON
  factory GraveStepperData.fromJson(Map<String, dynamic> json) {
    return GraveStepperData(
      name: json['name'] as String,
      value: json['value'] as int,
    );
  }
}
