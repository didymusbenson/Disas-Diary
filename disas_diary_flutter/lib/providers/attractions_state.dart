import 'dart:math';

import 'package:flutter/material.dart';
import '../models/attraction.dart';
import '../models/attraction_deck.dart';
import '../models/attraction_game_state.dart';
import '../services/persistence_service.dart';

/// State provider for the Attractions feature
class AttractionsState extends ChangeNotifier {
  final PersistenceService _persistence;
  final Random _random = Random();

  List<Attraction> _allAttractions = [];
  Map<String, List<Attraction>> _attractionsByName = {};
  List<AttractionDeck> _decks = [];
  AttractionGameState? _gameState;
  bool _commanderLegalFilter = false;
  bool _isLoaded = false;

  AttractionsState(this._persistence);

  // --- Getters ---

  List<Attraction> get allAttractions => _allAttractions;
  Map<String, List<Attraction>> get attractionsByName => _attractionsByName;
  List<AttractionDeck> get decks => _decks;
  AttractionGameState? get gameState => _gameState;
  bool get commanderLegalFilter => _commanderLegalFilter;
  bool get isLoaded => _isLoaded;
  bool get hasActiveGame => _gameState != null;

  int get deckRemaining => _gameState?.drawPile.length ?? 0;
  bool get canOpenAttraction => (_gameState?.drawPile.isNotEmpty) ?? false;
  List<OpenAttraction> get battlefield => _gameState?.battlefield ?? [];
  List<AttractionDeckEntry> get junkyard => _gameState?.junkyard ?? [];
  List<AttractionDeckEntry> get exile => _gameState?.exile ?? [];

  /// Returns attractions filtered by commander legal toggle
  List<Attraction> get filteredAttractions {
    if (_commanderLegalFilter) {
      return _allAttractions
          .where((a) => a.commanderLegal)
          .toList();
    }
    return _allAttractions;
  }

  // --- Initialization ---

  /// Load all attractions from asset, load decks and game state from persistence
  Future<void> initialize() async {
    _allAttractions = await Attraction.loadAll();
    _attractionsByName = Attraction.groupByName(_allAttractions);
    _decks = _persistence.loadAttractionDecks();
    _gameState = _persistence.loadAttractionGameState();
    _isLoaded = true;
    notifyListeners();
  }

  // --- Deck Builder ---

  /// Set commander legal filter toggle
  void setCommanderLegalFilter(bool value) {
    _commanderLegalFilter = value;
    notifyListeners();
  }

  /// Create a new deck. Validates min 10 unique names.
  Future<AttractionDeck> createDeck(
      String name, List<AttractionDeckEntry> entries) async {
    final uniqueNames = entries.map((e) => e.attractionName).toSet();
    if (uniqueNames.length < 10) {
      throw ArgumentError(
          'Attraction deck must contain at least 10 unique attraction names');
    }

    final deck = AttractionDeck(
      id: _generateId(),
      name: name,
      entries: entries,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _decks.add(deck);
    _persistence.saveAttractionDecks(_decks);
    notifyListeners();
    return deck;
  }

  /// Update an existing deck
  Future<void> updateDeck(String deckId,
      {String? name, List<AttractionDeckEntry>? entries}) async {
    final index = _decks.indexWhere((d) => d.id == deckId);
    if (index == -1) return;

    if (entries != null) {
      final uniqueNames = entries.map((e) => e.attractionName).toSet();
      if (uniqueNames.length < 10) {
        throw ArgumentError(
            'Attraction deck must contain at least 10 unique attraction names');
      }
    }

    final existing = _decks[index];
    _decks[index] = AttractionDeck(
      id: existing.id,
      name: name ?? existing.name,
      entries: entries ?? existing.entries,
      createdAt: existing.createdAt,
      updatedAt: DateTime.now(),
    );

    _persistence.saveAttractionDecks(_decks);
    notifyListeners();
  }

  /// Delete a deck by ID
  Future<void> deleteDeck(String deckId) async {
    _decks.removeWhere((d) => d.id == deckId);
    _persistence.saveAttractionDecks(_decks);
    notifyListeners();
  }

  // --- Game Play ---

  /// Create a new game state from deck, shuffle, persist
  Future<void> loadDeck(String deckId) async {
    final deck = _decks.firstWhere((d) => d.id == deckId);
    final drawPile = List<AttractionDeckEntry>.from(deck.entries);
    drawPile.shuffle(_random);

    _gameState = AttractionGameState(
      deckId: deckId,
      deckName: deck.name,
      drawPile: drawPile,
      battlefield: [],
      junkyard: [],
      exile: [],
      lastRoll: null,
    );

    _persistence.saveAttractionGameState(_gameState!);
    notifyListeners();
  }

  /// Move top of drawPile to battlefield
  void openAttraction() {
    if (_gameState == null || _gameState!.drawPile.isEmpty) return;

    final entry = _gameState!.drawPile.removeAt(0);
    _gameState!.battlefield.add(OpenAttraction(
      entry: entry,
      prizeClaimed: false,
    ));

    _persistence.saveAttractionGameState(_gameState!);
    notifyListeners();
  }

  /// Generate random 1-6, set lastRoll, return the roll
  int rollToVisit() {
    if (_gameState == null) return 0;

    final roll = _random.nextInt(6) + 1;
    _gameState = AttractionGameState(
      deckId: _gameState!.deckId,
      deckName: _gameState!.deckName,
      drawPile: _gameState!.drawPile,
      battlefield: _gameState!.battlefield,
      junkyard: _gameState!.junkyard,
      exile: _gameState!.exile,
      lastRoll: roll,
    );

    _persistence.saveAttractionGameState(_gameState!);
    notifyListeners();
    return roll;
  }

  /// Return battlefield attractions whose lights include the roll
  List<OpenAttraction> getVisitedAttractions(int roll) {
    if (_gameState == null) return [];
    return _gameState!.battlefield
        .where((oa) => oa.entry.attractionLights.contains(roll))
        .toList();
  }

  /// Move from battlefield to junkyard
  void junkyardAttraction(int battlefieldIndex) {
    if (_gameState == null) return;
    if (battlefieldIndex < 0 ||
        battlefieldIndex >= _gameState!.battlefield.length) return;

    final removed = _gameState!.battlefield.removeAt(battlefieldIndex);
    _gameState!.junkyard.add(removed.entry);

    _persistence.saveAttractionGameState(_gameState!);
    notifyListeners();
  }

  /// Move from battlefield to exile
  void exileAttraction(int battlefieldIndex) {
    if (_gameState == null) return;
    if (battlefieldIndex < 0 ||
        battlefieldIndex >= _gameState!.battlefield.length) return;

    final removed = _gameState!.battlefield.removeAt(battlefieldIndex);
    _gameState!.exile.add(removed.entry);

    _persistence.saveAttractionGameState(_gameState!);
    notifyListeners();
  }

  /// Toggle prize claimed on battlefield card
  void togglePrizeClaimed(int battlefieldIndex) {
    if (_gameState == null) return;
    if (battlefieldIndex < 0 ||
        battlefieldIndex >= _gameState!.battlefield.length) return;

    final current = _gameState!.battlefield[battlefieldIndex];
    _gameState!.battlefield[battlefieldIndex] = OpenAttraction(
      entry: current.entry,
      prizeClaimed: !current.prizeClaimed,
    );

    _persistence.saveAttractionGameState(_gameState!);
    notifyListeners();
  }

  /// Clear game state
  Future<void> resetGame() async {
    _gameState = null;
    _persistence.clearAttractionGameState();
    notifyListeners();
  }

  /// Move all junkyard cards back into drawPile, shuffle
  Future<void> shuffleJunkyardIntoDeck() async {
    if (_gameState == null) return;

    _gameState!.drawPile.addAll(_gameState!.junkyard);
    _gameState!.junkyard.clear();
    _gameState!.drawPile.shuffle(_random);

    _persistence.saveAttractionGameState(_gameState!);
    notifyListeners();
  }

  // --- Helpers ---

  String _generateId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(16, (_) => chars[_random.nextInt(chars.length)]).join();
  }
}
