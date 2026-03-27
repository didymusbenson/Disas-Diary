/// Entry in an attraction deck representing a specific card variant
class AttractionDeckEntry {
  final String attractionName;
  final List<int> attractionLights;
  final String securityStamp;
  final bool commanderLegal;
  final String oracleText;

  AttractionDeckEntry({
    required this.attractionName,
    required this.attractionLights,
    required this.securityStamp,
    required this.commanderLegal,
    required this.oracleText,
  });

  /// Convert to JSON for persistence
  Map<String, dynamic> toJson() {
    return {
      'attraction_name': attractionName,
      'attraction_lights': attractionLights,
      'security_stamp': securityStamp,
      'commander_legal': commanderLegal,
      'oracle_text': oracleText,
    };
  }

  /// Create from JSON
  factory AttractionDeckEntry.fromJson(Map<String, dynamic> json) {
    return AttractionDeckEntry(
      attractionName: json['attraction_name'] as String,
      attractionLights: (json['attraction_lights'] as List).cast<int>(),
      securityStamp: json['security_stamp'] as String,
      commanderLegal: json['commander_legal'] as bool,
      oracleText: json['oracle_text'] as String,
    );
  }
}

/// Model class representing a saved attraction deck
class AttractionDeck {
  final String id;
  String name;
  List<AttractionDeckEntry> entries;
  final DateTime createdAt;
  DateTime updatedAt;

  AttractionDeck({
    required this.id,
    required this.name,
    required this.entries,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Whether this deck contains any acorn-stamped cards
  bool get containsAcorn =>
      entries.any((entry) => entry.securityStamp == 'acorn');

  /// Convert to JSON for persistence
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'entries': entries.map((e) => e.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create from JSON
  factory AttractionDeck.fromJson(Map<String, dynamic> json) {
    return AttractionDeck(
      id: json['id'] as String,
      name: json['name'] as String,
      entries: (json['entries'] as List)
          .map((e) => AttractionDeckEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
