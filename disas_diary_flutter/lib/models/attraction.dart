import 'dart:convert';
import 'package:flutter/services.dart';

/// Model class representing a Magic: The Gathering Attraction card
class Attraction {
  final String name;
  final String oracleText;
  final List<int> attractionLights;
  final String collectorNumber;
  final String securityStamp;
  final bool commanderLegal;

  Attraction({
    required this.name,
    required this.oracleText,
    required this.attractionLights,
    required this.collectorNumber,
    required this.securityStamp,
    required this.commanderLegal,
  });

  /// Whether this attraction has a prize to claim
  bool get hasPrize =>
      oracleText.toLowerCase().contains('claim the prize');

  /// Convert to JSON for persistence
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'oracle_text': oracleText,
      'attraction_lights': attractionLights,
      'collector_number': collectorNumber,
      'security_stamp': securityStamp,
      'commander_legal': commanderLegal,
    };
  }

  /// Create from JSON
  factory Attraction.fromJson(Map<String, dynamic> json) {
    return Attraction(
      name: json['name'] as String,
      oracleText: json['oracle_text'] as String,
      attractionLights: (json['attraction_lights'] as List).cast<int>(),
      collectorNumber: json['collector_number'] as String,
      securityStamp: json['security_stamp'] as String,
      commanderLegal: json['commander_legal'] as bool,
    );
  }

  /// Load all attractions from the bundled asset
  static Future<List<Attraction>> loadAll() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/attractions_data.json',
    );
    final list = jsonDecode(jsonString) as List;
    return list
        .map((item) => Attraction.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Group attractions by name for deck builder display
  static Map<String, List<Attraction>> groupByName(
    List<Attraction> attractions,
  ) {
    final grouped = <String, List<Attraction>>{};
    for (final attraction in attractions) {
      grouped.putIfAbsent(attraction.name, () => []).add(attraction);
    }
    return grouped;
  }
}
