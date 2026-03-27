import 'package:flutter/material.dart';
import '../models/dungeon.dart';
import '../models/dungeon_game_state.dart';
import '../services/persistence_service.dart';

/// State provider for the Dungeons feature
class DungeonsState extends ChangeNotifier {
  final PersistenceService _persistence;

  List<Dungeon> _dungeons = [];
  DungeonGameState _gameState = DungeonGameState.initial();
  bool _isLoaded = false;

  DungeonsState(this._persistence);

  // --- Getters ---

  bool get isLoaded => _isLoaded;

  List<Dungeon> get dungeons => _dungeons;

  /// Dungeons the player can choose. Undercity requires initiative.
  List<Dungeon> get availableDungeons {
    if (_gameState.hasInitiative) {
      return _dungeons;
    }
    return _dungeons.where((d) => d.id != 'undercity').toList();
  }

  /// The currently active dungeon, or null if none
  Dungeon? get activeDungeon {
    final id = _gameState.activeDungeonId;
    if (id == null) return null;
    try {
      return _dungeons.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  /// The current room within the active dungeon, or null
  DungeonRoom? get currentRoom {
    final dungeon = activeDungeon;
    final roomId = _gameState.currentRoomId;
    if (dungeon == null || roomId == null) return null;
    try {
      return dungeon.rooms.firstWhere((r) => r.id == roomId);
    } catch (_) {
      return null;
    }
  }

  bool get hasActiveDungeon => _gameState.activeDungeonId != null;

  /// True if the current room is a bottom room of the active dungeon
  bool get isOnBottomRoom {
    final dungeon = activeDungeon;
    final room = currentRoom;
    if (dungeon == null || room == null) return false;
    return dungeon.isBottomRoom(room.id);
  }

  /// Available rooms to venture to from the current position
  List<DungeonRoom> get nextRooms {
    final dungeon = activeDungeon;
    final room = currentRoom;
    if (dungeon == null || room == null) return [];
    return dungeon.getNextRooms(room.id);
  }

  bool get hasInitiative => _gameState.hasInitiative;

  int get globalCompletionCount => _gameState.globalCompletionCount;

  Map<String, int> get perDungeonCompletionCounts =>
      _gameState.perDungeonCompletionCounts;

  int completionCountFor(String dungeonId) =>
      _gameState.perDungeonCompletionCounts[dungeonId] ?? 0;

  // --- Initialization ---

  /// Load all dungeons from asset, load game state from persistence
  Future<void> initialize() async {
    _dungeons = Dungeon.loadAll();
    _gameState =
        _persistence.loadDungeonGameState() ?? DungeonGameState.initial();
    _isLoaded = true;
    notifyListeners();
  }

  // --- Dungeon Selection ---

  /// Set the active dungeon and move to its start room
  void selectDungeon(String dungeonId) {
    final dungeon = _dungeons.firstWhere((d) => d.id == dungeonId);
    final startRoom = dungeon.roomsByTier.entries
        .reduce((a, b) => a.key < b.key ? a : b)
        .value
        .first;

    _gameState = DungeonGameState(
      activeDungeonId: dungeonId,
      currentRoomId: startRoom.id,
      hasInitiative: _gameState.hasInitiative,
      globalCompletionCount: _gameState.globalCompletionCount,
      perDungeonCompletionCounts: _gameState.perDungeonCompletionCounts,
    );

    _persistence.saveDungeonGameState(_gameState);
    notifyListeners();
  }

  // --- Gameplay ---

  /// Move to the specified room. Validates it is a valid next room.
  void venture(String nextRoomId) {
    final dungeon = activeDungeon;
    if (dungeon == null) return;

    final validNextRooms = nextRooms;
    final isValid = validNextRooms.any((r) => r.id == nextRoomId);
    if (!isValid) return;

    _gameState = DungeonGameState(
      activeDungeonId: _gameState.activeDungeonId,
      currentRoomId: nextRoomId,
      hasInitiative: _gameState.hasInitiative,
      globalCompletionCount: _gameState.globalCompletionCount,
      perDungeonCompletionCounts: _gameState.perDungeonCompletionCounts,
    );

    _persistence.saveDungeonGameState(_gameState);
    notifyListeners();
  }

  /// Increment completion counts and clear the active dungeon
  void completeDungeon() {
    final dungeonId = _gameState.activeDungeonId;
    if (dungeonId == null) return;

    final updatedCounts =
        Map<String, int>.from(_gameState.perDungeonCompletionCounts);
    updatedCounts[dungeonId] = (updatedCounts[dungeonId] ?? 0) + 1;

    _gameState = DungeonGameState(
      activeDungeonId: null,
      currentRoomId: null,
      hasInitiative: _gameState.hasInitiative,
      globalCompletionCount: _gameState.globalCompletionCount + 1,
      perDungeonCompletionCounts: updatedCounts,
    );

    _persistence.saveDungeonGameState(_gameState);
    notifyListeners();
  }

  /// Clear active dungeon without incrementing counts
  void abandonDungeon() {
    _gameState = DungeonGameState(
      activeDungeonId: null,
      currentRoomId: null,
      hasInitiative: _gameState.hasInitiative,
      globalCompletionCount: _gameState.globalCompletionCount,
      perDungeonCompletionCounts: _gameState.perDungeonCompletionCounts,
    );

    _persistence.saveDungeonGameState(_gameState);
    notifyListeners();
  }

  // --- Initiative ---

  /// Toggle initiative. If turning on with no active dungeon, auto-select Undercity.
  void toggleInitiative() {
    final newInitiative = !_gameState.hasInitiative;

    _gameState = DungeonGameState(
      activeDungeonId: _gameState.activeDungeonId,
      currentRoomId: _gameState.currentRoomId,
      hasInitiative: newInitiative,
      globalCompletionCount: _gameState.globalCompletionCount,
      perDungeonCompletionCounts: _gameState.perDungeonCompletionCounts,
    );

    _persistence.saveDungeonGameState(_gameState);
    notifyListeners();

    // Auto-select Undercity when initiative is turned on with no active dungeon
    if (newInitiative && !hasActiveDungeon) {
      selectDungeon('undercity');
    }
  }

  // --- Reset ---

  /// Reset all dungeon state to initial
  void resetAll() {
    _gameState = DungeonGameState.initial();
    _persistence.clearDungeonGameState();
    notifyListeners();
  }
}
