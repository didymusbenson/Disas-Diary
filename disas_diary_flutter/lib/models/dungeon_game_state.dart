/// Model class representing mid-game dungeon venture state
class DungeonGameState {
  final String? activeDungeonId;
  final String? currentRoomId;
  final bool hasInitiative;
  final int globalCompletionCount;
  final Map<String, int> perDungeonCompletionCounts;

  DungeonGameState({
    required this.activeDungeonId,
    required this.currentRoomId,
    required this.hasInitiative,
    required this.globalCompletionCount,
    required this.perDungeonCompletionCounts,
  });

  /// Create initial state with no active dungeon
  factory DungeonGameState.initial() {
    return DungeonGameState(
      activeDungeonId: null,
      currentRoomId: null,
      hasInitiative: false,
      globalCompletionCount: 0,
      perDungeonCompletionCounts: {},
    );
  }

  /// Convert to JSON for persistence
  Map<String, dynamic> toJson() {
    return {
      'active_dungeon_id': activeDungeonId,
      'current_room_id': currentRoomId,
      'has_initiative': hasInitiative,
      'global_completion_count': globalCompletionCount,
      'per_dungeon_completion_counts': perDungeonCompletionCounts,
    };
  }

  /// Create from JSON
  factory DungeonGameState.fromJson(Map<String, dynamic> json) {
    return DungeonGameState(
      activeDungeonId: json['active_dungeon_id'] as String?,
      currentRoomId: json['current_room_id'] as String?,
      hasInitiative: json['has_initiative'] as bool,
      globalCompletionCount: json['global_completion_count'] as int,
      perDungeonCompletionCounts:
          (json['per_dungeon_completion_counts'] as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value as int)),
    );
  }

  /// Create a copy with updated fields
  DungeonGameState copyWith({
    String? Function()? activeDungeonId,
    String? Function()? currentRoomId,
    bool? hasInitiative,
    int? globalCompletionCount,
    Map<String, int>? perDungeonCompletionCounts,
  }) {
    return DungeonGameState(
      activeDungeonId:
          activeDungeonId != null ? activeDungeonId() : this.activeDungeonId,
      currentRoomId:
          currentRoomId != null ? currentRoomId() : this.currentRoomId,
      hasInitiative: hasInitiative ?? this.hasInitiative,
      globalCompletionCount:
          globalCompletionCount ?? this.globalCompletionCount,
      perDungeonCompletionCounts:
          perDungeonCompletionCounts ?? this.perDungeonCompletionCounts,
    );
  }
}
