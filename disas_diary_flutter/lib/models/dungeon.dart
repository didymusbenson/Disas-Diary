/// Model class representing a room within a Magic: The Gathering Dungeon card
class DungeonRoom {
  final String id;
  final String name;
  final String effect;
  final List<String> leadsTo;
  final int tier;

  DungeonRoom({
    required this.id,
    required this.name,
    required this.effect,
    required this.leadsTo,
    required this.tier,
  });

  /// Convert to JSON for persistence
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'effect': effect,
      'leads_to': leadsTo,
      'tier': tier,
    };
  }

  /// Create from JSON
  factory DungeonRoom.fromJson(Map<String, dynamic> json) {
    return DungeonRoom(
      id: json['id'] as String,
      name: json['name'] as String,
      effect: json['effect'] as String,
      leadsTo: (json['leads_to'] as List).cast<String>(),
      tier: json['tier'] as int,
    );
  }
}

/// Model class representing a Magic: The Gathering Dungeon card
class Dungeon {
  final String id;
  final String name;
  final String set;
  final bool initiativeOnly;
  final String scryfallId;
  final String oracleText;
  final List<DungeonRoom> rooms;

  Dungeon({
    required this.id,
    required this.name,
    required this.set,
    required this.initiativeOnly,
    required this.scryfallId,
    required this.oracleText,
    required this.rooms,
  });

  /// The topmost room (tier 0)
  DungeonRoom get startRoom => rooms.firstWhere((r) => r.tier == 0);

  /// All rooms with no outgoing connections (bottommost rooms)
  List<DungeonRoom> get bottomRooms =>
      rooms.where((r) => r.leadsTo.isEmpty).toList();

  /// Whether the given room is a bottommost room
  bool isBottomRoom(String roomId) => bottomRooms.any((r) => r.id == roomId);

  /// Get the rooms that the given room leads to
  List<DungeonRoom> getNextRooms(String roomId) {
    final room = getRoomById(roomId);
    return room.leadsTo.map((id) => getRoomById(id)).toList();
  }

  /// Get a room by its ID
  DungeonRoom getRoomById(String id) => rooms.firstWhere((r) => r.id == id);

  /// Group rooms by tier for layout (tier -> rooms at that tier, sorted by tier)
  Map<int, List<DungeonRoom>> get roomsByTier {
    final map = <int, List<DungeonRoom>>{};
    for (final room in rooms) {
      map.putIfAbsent(room.tier, () => []).add(room);
    }
    return Map.fromEntries(
      map.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  /// Scryfall image URL for card preview
  String get scryfallImageUrl {
    final a = scryfallId.substring(0, 1);
    final b = scryfallId.substring(1, 2);
    return 'https://cards.scryfall.io/large/front/$a/$b/$scryfallId.jpg';
  }

  /// Convert to JSON for persistence
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'set': set,
      'initiative_only': initiativeOnly,
      'scryfall_id': scryfallId,
      'oracle_text': oracleText,
      'rooms': rooms.map((r) => r.toJson()).toList(),
    };
  }

  /// Create from JSON
  factory Dungeon.fromJson(Map<String, dynamic> json) {
    return Dungeon(
      id: json['id'] as String,
      name: json['name'] as String,
      set: json['set'] as String,
      initiativeOnly: json['initiative_only'] as bool,
      scryfallId: json['scryfall_id'] as String,
      oracleText: json['oracle_text'] as String,
      rooms: (json['rooms'] as List)
          .map((r) => DungeonRoom.fromJson(r as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Load all hardcoded dungeons
  static List<Dungeon> loadAll() {
    return [
      _madMage(),
      _phandelver(),
      _tombOfAnnihilation(),
      _undercity(),
      _baldursGateWilderness(),
    ];
  }

  // ---------------------------------------------------------------------------
  // Hardcoded dungeon data
  // ---------------------------------------------------------------------------

  static Dungeon _madMage() {
    return Dungeon(
      id: 'mad_mage',
      name: "Dungeon of the Mad Mage",
      set: 'tafr',
      initiativeOnly: false,
      // TODO: Verify Scryfall ID against API
      scryfallId: '6f509dbe-6ec7-4438-ab36-e20be46c9922',
      oracleText:
          'Yawning Portal — You gain 1 life. (Leads to: Dungeon Level)\n'
          'Dungeon Level — Scry 1. (Leads to: Goblin Bazaar, Twisted Caverns)\n'
          'Goblin Bazaar — Create a Treasure token. (Leads to: Lost Level)\n'
          'Twisted Caverns — Target creature can\'t attack until your next turn. (Leads to: Lost Level)\n'
          'Lost Level — Scry 2. (Leads to: Runestone Caverns, Muiral\'s Graveyard)\n'
          'Runestone Caverns — Exile the top two cards of your library. You may play them. (Leads to: Deep Mines)\n'
          'Muiral\'s Graveyard — Create two 1/1 black Skeleton creature tokens. (Leads to: Deep Mines)\n'
          'Deep Mines — Scry 3. (Leads to: Mad Wizard\'s Lair)\n'
          'Mad Wizard\'s Lair — Draw three cards and reveal them. You may cast one of them without paying its mana cost.',
      rooms: [
        DungeonRoom(
          id: 'yawning_portal',
          name: 'Yawning Portal',
          effect: 'You gain 1 life.',
          leadsTo: ['dungeon_level'],
          tier: 0,
        ),
        DungeonRoom(
          id: 'dungeon_level',
          name: 'Dungeon Level',
          effect: 'Scry 1.',
          leadsTo: ['goblin_bazaar', 'twisted_caverns'],
          tier: 1,
        ),
        DungeonRoom(
          id: 'goblin_bazaar',
          name: 'Goblin Bazaar',
          effect: 'Create a Treasure token.',
          leadsTo: ['lost_level'],
          tier: 2,
        ),
        DungeonRoom(
          id: 'twisted_caverns',
          name: 'Twisted Caverns',
          effect: "Target creature can't attack until your next turn.",
          leadsTo: ['lost_level'],
          tier: 2,
        ),
        DungeonRoom(
          id: 'lost_level',
          name: 'Lost Level',
          effect: 'Scry 2.',
          leadsTo: ['runestone_caverns', 'muirals_graveyard'],
          tier: 3,
        ),
        DungeonRoom(
          id: 'runestone_caverns',
          name: 'Runestone Caverns',
          effect:
              'Exile the top two cards of your library. You may play them.',
          leadsTo: ['deep_mines'],
          tier: 4,
        ),
        DungeonRoom(
          id: 'muirals_graveyard',
          name: "Muiral's Graveyard",
          effect: 'Create two 1/1 black Skeleton creature tokens.',
          leadsTo: ['deep_mines'],
          tier: 4,
        ),
        DungeonRoom(
          id: 'deep_mines',
          name: 'Deep Mines',
          effect: 'Scry 3.',
          leadsTo: ['mad_wizards_lair'],
          tier: 5,
        ),
        DungeonRoom(
          id: 'mad_wizards_lair',
          name: "Mad Wizard's Lair",
          effect:
              'Draw three cards and reveal them. You may cast one of them without paying its mana cost.',
          leadsTo: [],
          tier: 6,
        ),
      ],
    );
  }

  static Dungeon _phandelver() {
    return Dungeon(
      id: 'phandelver',
      name: 'Lost Mine of Phandelver',
      set: 'tafr',
      initiativeOnly: false,
      // TODO: Verify Scryfall ID against API
      scryfallId: '59b11ff8-f118-4978-87dd-509dc0c8c932',
      oracleText: 'Cave Entrance — Scry 1. (Leads to: Goblin Lair, Mine Tunnels)\n'
          'Goblin Lair — Create a 1/1 red Goblin creature token. (Leads to: Storeroom, Dark Pool)\n'
          'Mine Tunnels — Create a Treasure token. (Leads to: Dark Pool, Fungi Cavern)\n'
          'Storeroom — Put a +1/+1 counter on target creature. (Leads to: Temple of Dumathoin)\n'
          'Dark Pool — Each opponent loses 1 life and you gain 1 life. (Leads to: Temple of Dumathoin)\n'
          'Fungi Cavern — Target creature gets -4/-0 until your next turn. (Leads to: Temple of Dumathoin)\n'
          'Temple of Dumathoin — Draw a card.',
      rooms: [
        DungeonRoom(
          id: 'cave_entrance',
          name: 'Cave Entrance',
          effect: 'Scry 1.',
          leadsTo: ['goblin_lair', 'mine_tunnels'],
          tier: 0,
        ),
        DungeonRoom(
          id: 'goblin_lair',
          name: 'Goblin Lair',
          effect: 'Create a 1/1 red Goblin creature token.',
          leadsTo: ['storeroom', 'dark_pool'],
          tier: 1,
        ),
        DungeonRoom(
          id: 'mine_tunnels',
          name: 'Mine Tunnels',
          effect: 'Create a Treasure token.',
          leadsTo: ['dark_pool', 'fungi_cavern'],
          tier: 1,
        ),
        DungeonRoom(
          id: 'storeroom',
          name: 'Storeroom',
          effect: 'Put a +1/+1 counter on target creature.',
          leadsTo: ['temple_of_dumathoin'],
          tier: 2,
        ),
        DungeonRoom(
          id: 'dark_pool',
          name: 'Dark Pool',
          effect: 'Each opponent loses 1 life and you gain 1 life.',
          leadsTo: ['temple_of_dumathoin'],
          tier: 2,
        ),
        DungeonRoom(
          id: 'fungi_cavern',
          name: 'Fungi Cavern',
          effect: 'Target creature gets -4/-0 until your next turn.',
          leadsTo: ['temple_of_dumathoin'],
          tier: 2,
        ),
        DungeonRoom(
          id: 'temple_of_dumathoin',
          name: 'Temple of Dumathoin',
          effect: 'Draw a card.',
          leadsTo: [],
          tier: 3,
        ),
      ],
    );
  }

  static Dungeon _tombOfAnnihilation() {
    return Dungeon(
      id: 'tomb_of_annihilation',
      name: 'Tomb of Annihilation',
      set: 'tafr',
      initiativeOnly: false,
      // TODO: Verify Scryfall ID against API
      scryfallId: '70b284bd-7a8f-4b60-8238-f746bdc5b236',
      oracleText:
          'Trapped Entry — Each player loses 1 life. (Leads to: Veils of Fear, Oubliette)\n'
          'Veils of Fear — Each player loses 2 life unless they discard a card. (Leads to: Sandfall Cell)\n'
          'Sandfall Cell — Each player loses 2 life unless they sacrifice a creature, artifact, or land of their choice. (Leads to: Cradle of the Death God)\n'
          'Oubliette — Discard a card and sacrifice a creature, an artifact, and a land. (Leads to: Cradle of the Death God)\n'
          'Cradle of the Death God — Create The Atropal, a legendary 4/4 black God Horror creature token with deathtouch.',
      rooms: [
        DungeonRoom(
          id: 'trapped_entry',
          name: 'Trapped Entry',
          effect: 'Each player loses 1 life.',
          leadsTo: ['veils_of_fear', 'oubliette'],
          tier: 0,
        ),
        DungeonRoom(
          id: 'veils_of_fear',
          name: 'Veils of Fear',
          effect:
              'Each player loses 2 life unless they discard a card.',
          leadsTo: ['sandfall_cell'],
          tier: 1,
        ),
        DungeonRoom(
          id: 'oubliette',
          name: 'Oubliette',
          effect:
              'Discard a card and sacrifice a creature, an artifact, and a land.',
          leadsTo: ['cradle_of_the_death_god'],
          tier: 1,
        ),
        DungeonRoom(
          id: 'sandfall_cell',
          name: 'Sandfall Cell',
          effect:
              'Each player loses 2 life unless they sacrifice a creature, artifact, or land of their choice.',
          leadsTo: ['cradle_of_the_death_god'],
          tier: 2,
        ),
        DungeonRoom(
          id: 'cradle_of_the_death_god',
          name: 'Cradle of the Death God',
          effect:
              'Create The Atropal, a legendary 4/4 black God Horror creature token with deathtouch.',
          leadsTo: [],
          tier: 3,
        ),
      ],
    );
  }

  static Dungeon _undercity() {
    return Dungeon(
      id: 'undercity',
      name: 'Undercity',
      set: 'tclb',
      initiativeOnly: true,
      // TODO: Verify Scryfall ID against API
      scryfallId: '2c65185b-6cf0-451d-985e-56aa45d9a57d',
      oracleText:
          'You can\'t enter this dungeon unless you "venture into Undercity."\n'
          'Secret Entrance — Search your library for a basic land card, reveal it, put it into your hand, then shuffle. (Leads to: Forge, Lost Well)\n'
          'Forge — Put two +1/+1 counters on target creature. (Leads to: Trap!, Arena)\n'
          'Lost Well — Scry 2. (Leads to: Arena, Stash)\n'
          'Trap! — Target player loses 5 life. (Leads to: Archives)\n'
          'Arena — Goad target creature. (Leads to: Archives, Catacombs)\n'
          'Stash — Create a Treasure token. (Leads to: Catacombs)\n'
          'Archives — Draw a card. (Leads to: Throne of the Dead Three)\n'
          'Catacombs — Create a 4/1 black Skeleton creature token with menace. (Leads to: Throne of the Dead Three)\n'
          'Throne of the Dead Three — Reveal the top ten cards of your library. Put a creature card from among them onto the battlefield with three +1/+1 counters on it. It gains hexproof until your next turn. Then shuffle.',
      rooms: [
        DungeonRoom(
          id: 'secret_entrance',
          name: 'Secret Entrance',
          effect:
              'Search your library for a basic land card, reveal it, put it into your hand, then shuffle.',
          leadsTo: ['forge', 'lost_well'],
          tier: 0,
        ),
        DungeonRoom(
          id: 'forge',
          name: 'Forge',
          effect: 'Put two +1/+1 counters on target creature.',
          leadsTo: ['trap', 'arena'],
          tier: 1,
        ),
        DungeonRoom(
          id: 'lost_well',
          name: 'Lost Well',
          effect: 'Scry 2.',
          leadsTo: ['arena', 'stash'],
          tier: 1,
        ),
        DungeonRoom(
          id: 'trap',
          name: 'Trap!',
          effect: 'Target player loses 5 life.',
          leadsTo: ['archives'],
          tier: 2,
        ),
        DungeonRoom(
          id: 'arena',
          name: 'Arena',
          effect: 'Goad target creature.',
          leadsTo: ['archives', 'catacombs'],
          tier: 2,
        ),
        DungeonRoom(
          id: 'stash',
          name: 'Stash',
          effect: 'Create a Treasure token.',
          leadsTo: ['catacombs'],
          tier: 2,
        ),
        DungeonRoom(
          id: 'archives',
          name: 'Archives',
          effect: 'Draw a card.',
          leadsTo: ['throne_of_the_dead_three'],
          tier: 3,
        ),
        DungeonRoom(
          id: 'catacombs',
          name: 'Catacombs',
          effect: 'Create a 4/1 black Skeleton creature token with menace.',
          leadsTo: ['throne_of_the_dead_three'],
          tier: 3,
        ),
        DungeonRoom(
          id: 'throne_of_the_dead_three',
          name: 'Throne of the Dead Three',
          effect:
              'Reveal the top ten cards of your library. Put a creature card from among them onto the battlefield with three +1/+1 counters on it. It gains hexproof until your next turn. Then shuffle.',
          leadsTo: [],
          tier: 4,
        ),
      ],
    );
  }

  static Dungeon _baldursGateWilderness() {
    return Dungeon(
      id: 'baldurs_gate_wilderness',
      name: "Baldur's Gate Wilderness",
      set: 'tclb',
      initiativeOnly: false,
      // TODO: Verify Scryfall ID against API
      scryfallId: 'a9d56324-8293-4500-a9ad-fed351ccf966',
      oracleText:
          'Crash Landing — Search your library for a basic land card, reveal it, put it into your hand, then shuffle.\n'
          'Goblin Camp — Create a Treasure token.\n'
          'Emerald Grove — Create a 2/2 white Knight creature token.\n'
          "Auntie's Teahouse — Scry 3.\n"
          'Defiled Temple — You may sacrifice a permanent. If you do, draw a card.\n'
          'Mountain Pass — You may put a land card from your hand onto the battlefield.\n'
          'Ebonlake Grotto — Create two 1/1 blue Faerie Dragon creature tokens with flying.\n'
          'Grymforge — For each opponent, goad up to one target creature that player controls.\n'
          "Githyanki Cr\u00e8che — Distribute three +1/+1 counters among up to three target creatures you control.\n"
          'Last Light Inn — Draw two cards.\n'
          'Reithwin Tollhouse — Roll 2d4 and create that many Treasure tokens.\n'
          'Moonrise Towers — Instant and sorcery spells you cast this turn cost 3 less to cast.\n'
          'Gauntlet of Shar — Each opponent loses 5 life.\n'
          "Balthazar's Lab — Return up to two target creature cards from your graveyard to your hand.\n"
          "Circus of the Last Days — Create a token that's a copy of one of your commanders, except it's not legendary.\n"
          'Undercity Ruins — Create three 4/1 black Skeleton creature tokens with menace.\n'
          'Steel Watch Foundry — You get an emblem with "Creatures you control get +2/+2 and have trample."\n'
          "Ansur's Sanctum — Reveal the top four cards of your library and put them into your hand. Each opponent loses life equal to those cards' total mana value.\n"
          "Temple of Bhaal — Creatures your opponents control get -5/-5 until end of turn.",
      rooms: [
        DungeonRoom(
          id: 'crash_landing',
          name: 'Crash Landing',
          effect:
              'Search your library for a basic land card, reveal it, put it into your hand, then shuffle.',
          leadsTo: ['goblin_camp', 'emerald_grove', 'aunties_teahouse'],
          tier: 0,
        ),
        DungeonRoom(
          id: 'goblin_camp',
          name: 'Goblin Camp',
          effect: 'Create a Treasure token.',
          leadsTo: ['defiled_temple'],
          tier: 1,
        ),
        DungeonRoom(
          id: 'emerald_grove',
          name: 'Emerald Grove',
          effect: 'Create a 2/2 white Knight creature token.',
          leadsTo: ['defiled_temple', 'mountain_pass'],
          tier: 1,
        ),
        DungeonRoom(
          id: 'aunties_teahouse',
          name: "Auntie's Teahouse",
          effect: 'Scry 3.',
          leadsTo: ['mountain_pass'],
          tier: 1,
        ),
        DungeonRoom(
          id: 'defiled_temple',
          name: 'Defiled Temple',
          effect:
              'You may sacrifice a permanent. If you do, draw a card.',
          leadsTo: ['ebonlake_grotto', 'grymforge'],
          tier: 2,
        ),
        DungeonRoom(
          id: 'mountain_pass',
          name: 'Mountain Pass',
          effect:
              'You may put a land card from your hand onto the battlefield.',
          leadsTo: ['grymforge', 'githyanki_creche'],
          tier: 2,
        ),
        DungeonRoom(
          id: 'ebonlake_grotto',
          name: 'Ebonlake Grotto',
          effect:
              'Create two 1/1 blue Faerie Dragon creature tokens with flying.',
          leadsTo: ['last_light_inn'],
          tier: 3,
        ),
        DungeonRoom(
          id: 'grymforge',
          name: 'Grymforge',
          effect:
              'For each opponent, goad up to one target creature that player controls.',
          leadsTo: ['last_light_inn', 'reithwin_tollhouse'],
          tier: 3,
        ),
        DungeonRoom(
          id: 'githyanki_creche',
          name: "Githyanki Cr\u00e8che",
          effect:
              'Distribute three +1/+1 counters among up to three target creatures you control.',
          leadsTo: ['reithwin_tollhouse'],
          tier: 3,
        ),
        DungeonRoom(
          id: 'last_light_inn',
          name: 'Last Light Inn',
          effect: 'Draw two cards.',
          leadsTo: ['moonrise_towers', 'gauntlet_of_shar'],
          tier: 4,
        ),
        DungeonRoom(
          id: 'reithwin_tollhouse',
          name: 'Reithwin Tollhouse',
          effect: 'Roll 2d4 and create that many Treasure tokens.',
          leadsTo: ['gauntlet_of_shar', 'balthazars_lab'],
          tier: 4,
        ),
        DungeonRoom(
          id: 'moonrise_towers',
          name: 'Moonrise Towers',
          effect:
              'Instant and sorcery spells you cast this turn cost 3 less to cast.',
          leadsTo: ['circus_of_the_last_days'],
          tier: 5,
        ),
        DungeonRoom(
          id: 'gauntlet_of_shar',
          name: 'Gauntlet of Shar',
          effect: 'Each opponent loses 5 life.',
          leadsTo: ['circus_of_the_last_days', 'undercity_ruins'],
          tier: 5,
        ),
        DungeonRoom(
          id: 'balthazars_lab',
          name: "Balthazar's Lab",
          effect:
              'Return up to two target creature cards from your graveyard to your hand.',
          leadsTo: ['undercity_ruins'],
          tier: 5,
        ),
        DungeonRoom(
          id: 'circus_of_the_last_days',
          name: 'Circus of the Last Days',
          effect:
              "Create a token that's a copy of one of your commanders, except it's not legendary.",
          leadsTo: ['steel_watch_foundry', 'ansurs_sanctum'],
          tier: 6,
        ),
        DungeonRoom(
          id: 'undercity_ruins',
          name: 'Undercity Ruins',
          effect:
              'Create three 4/1 black Skeleton creature tokens with menace.',
          leadsTo: ['ansurs_sanctum', 'temple_of_bhaal'],
          tier: 6,
        ),
        DungeonRoom(
          id: 'steel_watch_foundry',
          name: 'Steel Watch Foundry',
          effect:
              'You get an emblem with "Creatures you control get +2/+2 and have trample."',
          leadsTo: [],
          tier: 7,
        ),
        DungeonRoom(
          id: 'ansurs_sanctum',
          name: "Ansur's Sanctum",
          effect:
              "Reveal the top four cards of your library and put them into your hand. Each opponent loses life equal to those cards' total mana value.",
          leadsTo: [],
          tier: 7,
        ),
        DungeonRoom(
          id: 'temple_of_bhaal',
          name: 'Temple of Bhaal',
          effect:
              "Creatures your opponents control get -5/-5 until end of turn.",
          leadsTo: [],
          tier: 7,
        ),
      ],
    );
  }
}
