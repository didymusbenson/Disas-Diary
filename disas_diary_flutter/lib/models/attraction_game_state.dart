import 'attraction_deck.dart';

/// An attraction that is currently open on the battlefield
class OpenAttraction {
  final AttractionDeckEntry entry;
  bool prizeClaimed;

  OpenAttraction({
    required this.entry,
    this.prizeClaimed = false,
  });

  /// Convert to JSON for persistence
  Map<String, dynamic> toJson() {
    return {
      'entry': entry.toJson(),
      'prize_claimed': prizeClaimed,
    };
  }

  /// Create from JSON
  factory OpenAttraction.fromJson(Map<String, dynamic> json) {
    return OpenAttraction(
      entry: AttractionDeckEntry.fromJson(
        json['entry'] as Map<String, dynamic>,
      ),
      prizeClaimed: json['prize_claimed'] as bool,
    );
  }
}

/// Model class representing mid-game attraction state
class AttractionGameState {
  final String deckId;
  final String deckName;
  List<AttractionDeckEntry> drawPile;
  List<OpenAttraction> battlefield;
  List<AttractionDeckEntry> junkyard;
  List<AttractionDeckEntry> exile;
  int? lastRoll;

  AttractionGameState({
    required this.deckId,
    required this.deckName,
    required this.drawPile,
    required this.battlefield,
    required this.junkyard,
    required this.exile,
    this.lastRoll,
  });

  /// Create a new game state from a deck, shuffling entries into the draw pile
  factory AttractionGameState.fromDeck(AttractionDeck deck) {
    final shuffled = List<AttractionDeckEntry>.from(deck.entries)..shuffle();
    return AttractionGameState(
      deckId: deck.id,
      deckName: deck.name,
      drawPile: shuffled,
      battlefield: [],
      junkyard: [],
      exile: [],
    );
  }

  /// Convert to JSON for persistence
  Map<String, dynamic> toJson() {
    return {
      'deck_id': deckId,
      'deck_name': deckName,
      'draw_pile': drawPile.map((e) => e.toJson()).toList(),
      'battlefield': battlefield.map((e) => e.toJson()).toList(),
      'junkyard': junkyard.map((e) => e.toJson()).toList(),
      'exile': exile.map((e) => e.toJson()).toList(),
      'last_roll': lastRoll,
    };
  }

  /// Create from JSON
  factory AttractionGameState.fromJson(Map<String, dynamic> json) {
    return AttractionGameState(
      deckId: json['deck_id'] as String,
      deckName: json['deck_name'] as String,
      drawPile: (json['draw_pile'] as List)
          .map((e) => AttractionDeckEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      battlefield: (json['battlefield'] as List)
          .map((e) => OpenAttraction.fromJson(e as Map<String, dynamic>))
          .toList(),
      junkyard: (json['junkyard'] as List)
          .map((e) => AttractionDeckEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      exile: (json['exile'] as List)
          .map((e) => AttractionDeckEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastRoll: json['last_roll'] as int?,
    );
  }
}
