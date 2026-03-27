# Dungeons

## Overview

A dungeon progress tracker for the Venture into the Dungeon mechanic from Adventures in the Forgotten Realms and related sets. Players can select a dungeon and track their position through its rooms as they venture through them.

## Status

**Implemented.** All open questions resolved. Initial implementation complete and passing `flutter analyze`. See `dungeons_implementation_review.md` for details.

---

## Comprehensive Rules Reference

### 309. Dungeons (Card Type)

**309.1.** Dungeon is a card type seen only on nontraditional Magic cards.

**309.2.** Dungeon cards begin outside the game. Dungeon cards aren't part of a player's deck or sideboard. They are brought into the game using the venture into the dungeon keyword action. See rule 701.49, "Venture into the Dungeon."

**309.2a** If a player ventures into the dungeon while they don't own a dungeon card in the command zone, they choose a dungeon card they own from outside the game and put it into the command zone.

**309.2b** A dungeon card that's brought into the game is put into the command zone until it leaves the game.

**309.2c** Dungeon cards are not permanents. They can't be cast. Dungeon cards can't leave the command zone except as they leave the game.

**309.2d** If an effect other than a venture into the dungeon keyword action would bring a dungeon card into the game from outside the game, it doesn't; that card remains outside the game.

**309.3.** A player can own only one dungeon card in the command zone at a time, and they can't bring a dungeon card into the game if a dungeon card they own is in the command zone.

**309.4.** Each dungeon card has a series of rooms connected to one another with arrows. A player uses a venture marker placed on the dungeon card they own to indicate which room they are currently in.

**309.4a** As a player puts a dungeon they own into the command zone, they put their venture marker on the topmost room.

**309.4b** Each room has a name. These names are considered flavor text and do not affect game play.

**309.4c** Each room has a triggered ability called a room ability whose effect is printed on the card. They all have the same trigger condition not printed on the card. The full text of each room ability is "When you move your venture marker into this room, [effect.]" As long as a dungeon card is in the command zone, its abilities may trigger. Each room ability is controlled by the player who owns the dungeon card that is that ability's source.

**309.5.** The venture into the dungeon keyword action allows players to move their venture marker down the rooms of a dungeon card.

**309.5a** If a player ventures into the dungeon while they own a dungeon card in the command zone and their venture marker isn't on that dungeon's bottommost room, they move their venture marker from the room it is on to the next room, following the direction of an arrow pointing away from the room their venture marker is on. If there are multiple arrows pointing away from the room the player's venture marker is on, they choose one of them to follow.

**309.5b** If a player ventures into the dungeon while they own a dungeon card in the command zone and their venture marker is on that dungeon card's bottommost room, they remove that dungeon card from the game. They then choose a dungeon card they own from outside the game and put it into the command zone. They put their venture marker on the topmost room.

**309.6.** If a player's venture marker is on the bottommost room of a dungeon card, and that dungeon card isn't the source of a room ability that has triggered but not yet left the stack, the dungeon card's owner removes it from the game. (This is a state-based action. See rule 704.)

**309.7.** A player completes a dungeon as that dungeon card is removed from the game.

### 701.49. Venture into the Dungeon

**701.49a** If a player is instructed to venture into the dungeon while they don't own a dungeon card in the command zone, they choose a dungeon card they own from outside the game and put it into the command zone. They put their venture marker on the topmost room. See rule 309, "Dungeons."

**701.49b** If a player is instructed to venture into the dungeon while their venture marker is in any room except a dungeon card's bottommost room, they choose an adjacent room, following the direction of an arrow pointing away from their current room. If there are multiple arrows pointing away from the room the player's venture marker is in, they choose one of them to follow. They move their venture marker to that adjacent room.

**701.49c** If a player is instructed to venture into the dungeon while their venture marker is in the bottommost room of a dungeon card, they remove that dungeon card from the game. Doing so causes the player to complete that dungeon (see rule 309.7). They then choose an appropriate dungeon card they own from outside the game, put it into the command zone, and put their venture marker on the topmost room of that dungeon.

**701.49d** Venture into [quality] is a variant of venture into the dungeon. If a player is instructed to "venture into [quality]" while they don't own a dungeon card in the command zone, they choose a dungeon card they own from outside the game with the indicated quality and put it into the command zone. They put their venture marker on the topmost room of that dungeon. If they already own a dungeon card in the command zone, they follow the normal procedure for venturing into the dungeon outlined in 701.49b–c.

### 725. The Initiative

**725.1.** The initiative is a designation a player can have. There is no initiative in a game until an effect instructs a player to take the initiative. A player who currently has the initiative designation is said to have the initiative.

**725.2.** There are three inherent triggered abilities associated with having the initiative. These triggered abilities have no source and are controlled by the player who had the initiative at the time the abilities triggered. This is an exception to rule 113.8. The full text of these abilities are "At the beginning of the upkeep of the player who has the initiative, that player ventures into Undercity," "Whenever one or more creatures a player controls deal combat damage to the player who has the initiative, the controller of those creatures takes the initiative," and "Whenever a player takes the initiative, that player ventures into Undercity."

**725.3.** Only one player can have the initiative at a time. As a player takes the initiative, the player who currently has the initiative ceases to have it.

**725.4.** If the player who has the initiative leaves the game, the active player takes the initiative at the same time that player leaves the game. If the active player is leaving the game or if there is no active player, the next player in turn order takes the initiative.

**725.5.** If the player who currently has the initiative is instructed to take the initiative, this causes the last triggered ability in 725.2 to trigger but does not create a second initiative designation.

### 704.5t (State-Based Action)

If a player's venture marker is on the bottommost room of a dungeon card, and that dungeon card isn't the source of a room ability that has triggered but not yet left the stack, the dungeon card's owner removes it from the game. See rule 309, "Dungeons."

### Glossary

- **Dungeon** — A card type found on nontraditional Magic cards. A dungeon card is not a permanent. See rule 309, "Dungeons."
- **Venture into the Dungeon** — A keyword action that can bring dungeon cards into the game from outside the game or move a player's venture marker. See rule 701.49.
- **Venture Marker** — A marker used to track which room of a dungeon card a player is currently in. See rule 309.
- **Room** — (1) A subsection of a dungeon card. See rule 309. (2) An enchantment subtype found on some split cards.
- **Room Ability** — A triggered ability that triggers whenever a player moves their venture marker into a room of a dungeon card. See rule 309.
- **Complete a Dungeon** — To remove a dungeon card from the game after reaching that dungeon card's bottommost room. See rule 309.
- **Initiative** — A designation a player can have. The player with the initiative ventures into Undercity whenever they take the initiative and at the beginning of their upkeep. See rule 725.

---

## Dungeons to Support (Oracle Text from Scryfall)

Data sourced from Scryfall API. Oracle text contains the canonical room structure with "Leads to" annotations defining the graph edges.

### 1. Dungeon of the Mad Mage (Adventures in the Forgotten Realms, set: tafr)

**Oracle text:**
> Yawning Portal — You gain 1 life. (Leads to: Dungeon Level)
> Dungeon Level — Scry 1. (Leads to: Goblin Bazaar, Twisted Caverns)
> Goblin Bazaar — Create a Treasure token. (Leads to: Lost Level)
> Twisted Caverns — Target creature can't attack until your next turn. (Leads to: Lost Level)
> Lost Level — Scry 2. (Leads to: Runestone Caverns, Muiral's Graveyard)
> Runestone Caverns — Exile the top two cards of your library. You may play them. (Leads to: Deep Mines)
> Muiral's Graveyard — Create two 1/1 black Skeleton creature tokens. (Leads to: Deep Mines)
> Deep Mines — Scry 3. (Leads to: Mad Wizard's Lair)
> Mad Wizard's Lair — Draw three cards and reveal them. You may cast one of them without paying its mana cost.

**Graph (9 rooms):**
```
            [Yawning Portal]
                  |
            [Dungeon Level]
              /          \
     [Goblin Bazaar]  [Twisted Caverns]
              \          /
            [Lost Level]
              /          \
  [Runestone Caverns]  [Muiral's Graveyard]
              \          /
            [Deep Mines]
                  |
         [Mad Wizard's Lair]
```

### 2. Lost Mine of Phandelver (Adventures in the Forgotten Realms, set: tafr)

**Oracle text:**
> Cave Entrance — Scry 1. (Leads to: Goblin Lair, Mine Tunnels)
> Goblin Lair — Create a 1/1 red Goblin creature token. (Leads to: Storeroom, Dark Pool)
> Mine Tunnels — Create a Treasure token. (Leads to: Dark Pool, Fungi Cavern)
> Storeroom — Put a +1/+1 counter on target creature. (Leads to: Temple of Dumathoin)
> Dark Pool — Each opponent loses 1 life and you gain 1 life. (Leads to: Temple of Dumathoin)
> Fungi Cavern — Target creature gets -4/-0 until your next turn. (Leads to: Temple of Dumathoin)
> Temple of Dumathoin — Draw a card.

**Graph (7 rooms):**
```
           [Cave Entrance]
             /          \
      [Goblin Lair]  [Mine Tunnels]
        /      \       /       \
 [Storeroom] [Dark Pool] [Fungi Cavern]
        \        |        /
       [Temple of Dumathoin]
```

### 3. Tomb of Annihilation (Adventures in the Forgotten Realms, set: tafr)

**Oracle text:**
> Trapped Entry — Each player loses 1 life. (Leads to: Veils of Fear, Oubliette)
> Veils of Fear — Each player loses 2 life unless they discard a card. (Leads to: Sandfall Cell)
> Sandfall Cell — Each player loses 2 life unless they sacrifice a creature, artifact, or land of their choice. (Leads to: Cradle of the Death God)
> Oubliette — Discard a card and sacrifice a creature, an artifact, and a land. (Leads to: Cradle of the Death God)
> Cradle of the Death God — Create The Atropal, a legendary 4/4 black God Horror creature token with deathtouch.

**Graph (5 rooms):**
```
         [Trapped Entry]
           /          \
   [Veils of Fear]  [Oubliette]
         |                |
   [Sandfall Cell]        |
           \          /
   [Cradle of the Death God]
```

### 4. Undercity (Commander Legends: Battle for Baldur's Gate, set: tclb)

**Oracle text (front face):**
> You can't enter this dungeon unless you "venture into Undercity."
> Secret Entrance — Search your library for a basic land card, reveal it, put it into your hand, then shuffle. (Leads to: Forge, Lost Well)
> Forge — Put two +1/+1 counters on target creature. (Leads to: Trap!, Arena)
> Lost Well — Scry 2. (Leads to: Arena, Stash)
> Trap! — Target player loses 5 life. (Leads to: Archives)
> Arena — Goad target creature. (Leads to: Archives, Catacombs)
> Stash — Create a Treasure token. (Leads to: Catacombs)
> Archives — Draw a card. (Leads to: Throne of the Dead Three)
> Catacombs — Create a 4/1 black Skeleton creature token with menace. (Leads to: Throne of the Dead Three)
> Throne of the Dead Three — Reveal the top ten cards of your library. Put a creature card from among them onto the battlefield with three +1/+1 counters on it. It gains hexproof until your next turn. Then shuffle.

**Back face ("The Initiative"):**
> Whenever one or more creatures a player controls deal combat damage to you, that player takes the initiative.
> Whenever you take the initiative and at the beginning of your upkeep, venture into Undercity.

**Graph (10 rooms):**
```
         [Secret Entrance]
            /          \
        [Forge]     [Lost Well]
        /     \      /      \
    [Trap!]  [Arena]     [Stash]
       \      /    \       /
     [Archives]  [Catacombs]
           \       /
    [Throne of the Dead Three]
```

**Note:** Undercity is special — it can only be entered via "venture into Undercity" (the initiative mechanic, rule 725). It cannot be chosen when a regular "venture into the dungeon" effect occurs.

### 5. Baldur's Gate Wilderness (Commander Legends: Battle for Baldur's Gate, set: tclb)

**Oracle text:**
> Crash Landing — Search your library for a basic land card, reveal it, put it into your hand, then shuffle.
> Goblin Camp — Create a Treasure token.
> Emerald Grove — Create a 2/2 white Knight creature token.
> Auntie's Teahouse — Scry 3.
> Defiled Temple — You may sacrifice a permanent. If you do, draw a card.
> Mountain Pass — You may put a land card from your hand onto the battlefield.
> Ebonlake Grotto — Create two 1/1 blue Faerie Dragon creature tokens with flying.
> Grymforge — For each opponent, goad up to one target creature that player controls.
> Githyanki Crèche — Distribute three +1/+1 counters among up to three target creatures you control.
> Last Light Inn — Draw two cards.
> Reithwin Tollhouse — Roll 2d4 and create that many Treasure tokens.
> Moonrise Towers — Instant and sorcery spells you cast this turn cost 3 less to cast.
> Gauntlet of Shar — Each opponent loses 5 life.
> Balthazar's Lab — Return up to two target creature cards from your graveyard to your hand.
> Circus of the Last Days — Create a token that's a copy of one of your commanders, except it's not legendary.
> Undercity Ruins — Create three 4/1 black Skeleton creature tokens with menace.
> Steel Watch Foundry — You get an emblem with "Creatures you control get +2/+2 and have trample."
> Ansur's Sanctum — Reveal the top four cards of your library and put them into your hand. Each opponent loses life equal to those cards' total mana value.
> Temple of Bhaal — Creatures your opponents control get -5/-5 until end of turn.

**Room connections (from card image):**
> Crash Landing leads to: Goblin Camp, Emerald Grove, Auntie's Teahouse
> Goblin Camp leads to: Defiled Temple
> Emerald Grove leads to: Defiled Temple, Mountain Pass
> Auntie's Teahouse leads to: Mountain Pass
> Defiled Temple leads to: Ebonlake Grotto, Grymforge
> Mountain Pass leads to: Grymforge, Githyanki Crèche
> Ebonlake Grotto leads to: Last Light Inn
> Grymforge leads to: Last Light Inn, Reithwin Tollhouse
> Githyanki Crèche leads to: Reithwin Tollhouse
> Last Light Inn leads to: Moonrise Towers, Gauntlet of Shar
> Reithwin Tollhouse leads to: Gauntlet of Shar, Balthazar's Lab
> Moonrise Towers leads to: Circus of the Last Days
> Gauntlet of Shar leads to: Circus of the Last Days, Undercity Ruins
> Balthazar's Lab leads to: Undercity Ruins
> Circus of the Last Days leads to: Steel Watch Foundry, Ansur's Sanctum
> Undercity Ruins leads to: Ansur's Sanctum, Temple of Bhaal
> Steel Watch Foundry — (bottommost)
> Ansur's Sanctum — (bottommost)
> Temple of Bhaal — (bottommost)

**Graph (19 rooms, 3 bottommost exits):**
```
                    [Crash Landing]
                  /       |        \
        [Goblin Camp] [Emerald Grove] [Auntie's Teahouse]
              \        /       \         /
         [Defiled Temple]    [Mountain Pass]
            /        \        /         \
  [Ebonlake Grotto] [Grymforge] [Githyanki Crèche]
            \        /       \         /
         [Last Light Inn]  [Reithwin Tollhouse]
           /        \        /          \
   [Moonrise Towers] [Gauntlet of Shar] [Balthazar's Lab]
            \        /         \          /
    [Circus of the Last Days] [Undercity Ruins]
        /          \            /         \
[Steel Watch   [Ansur's     [Ansur's   [Temple
 Foundry]      Sanctum]     Sanctum]   of Bhaal]
```

**Note:** This is the largest dungeon at 19 rooms with a consistent 3-wide branching pattern and 3 bottommost rooms (exits). It's from the Commander Legends: Battle for Baldur's Gate set (2024 reprint). Unlike Undercity, this can be chosen via regular "venture into the dungeon."

---

## Feature Goals

Players should be able to:
1. **Select a dungeon** from the five supported dungeons
2. **See the full dungeon map** with all rooms, connections, and room ability text
3. **Track their position** with a venture marker on the current room
4. **Advance through rooms** by tapping to venture (choosing a path at branches)
5. **Complete a dungeon** and optionally start a new one
6. **Track completion count** (how many times they've completed dungeons this game)

---

## Key Mechanics to Model

### Dungeon Structure
- Each dungeon is a directed acyclic graph (DAG) of rooms
- Rooms are connected by one-way arrows (top to bottom)
- Some rooms have branching paths (player chooses)
- Each room has a name and an effect text
- There is always exactly one topmost room and one (or two) bottommost rooms

### Venture Flow
1. If no dungeon active → player chooses a dungeon, marker goes to top room
2. If in a room (not bottommost) → move marker to an adjacent room (choose if branching)
3. If in bottommost room → dungeon is complete, removed from game
4. After completing → can start a new dungeon on next venture

### Undercity Special Rules
- Can ONLY be entered via "venture into Undercity" (initiative mechanic)
- Regular "venture into the dungeon" cannot choose Undercity
- In practice for our app: we should let the user select it but maybe note the restriction

### State
- Which dungeon is active (or none)
- Current room position
- Initiative toggle (on/off)
- Global session completion count (total dungeons completed)
- Per-dungeon completion counts (e.g., Tomb of Annihilation: 2, Undercity: 1)

---

## Open Questions

### Data
- **Q0**: ~~Do we bundle dungeon data as a static asset or fetch at runtime?~~ **RESOLVED** — Bundle as a static asset. The dungeon card pool is fixed and updates are extremely rare.

### Scope & Interaction
- **Q1**: ~~Do we support tracking initiative status (who has it), or just dungeon progress?~~ **RESOLVED** — Yes. A toggle for the player to indicate they have the initiative. When initiative is on and no dungeon is active, Undercity is auto-selected.
- **Q2**: ~~Should the tool enforce that Undercity can only be entered via initiative, or just let the user pick any dungeon freely?~~ **RESOLVED** — Enforce it. Undercity only available when initiative toggle is on. Regular "venture into the dungeon" cannot select Undercity.
- **Q3**: ~~Do we track dungeon completion count?~~ **RESOLVED** — Yes, track and display completion count.
- **Q4**: ~~Should we support multiple players tracking dungeons simultaneously, or just one player?~~ **RESOLVED** — Single player only.

### UI/UX
- **Q5**: ~~What does the dungeon map look like?~~ **RESOLVED** — Vertical list layout. Each "tier" of the dungeon is a row (HStack) of rooms, stacked vertically (VStack). Rooms at the same depth sit side by side in their row.
- **Q6**: ~~How does the user advance?~~ **RESOLVED** — Tap a "Venture" button. This presents the available next rooms as a list of options; the player chooses which room to enter. (If only one option, it advances directly.)
- **Q7**: ~~How do we highlight the current room vs. visited rooms vs. unvisited rooms?~~ **RESOLVED** — Active room gets a glowing border. Visited/unvisited distinction left to default styling (no special treatment specified yet).
- **Q8**: ~~Do we show room ability text inline on the map, or in a detail area when a room is selected?~~ **RESOLVED** — Inline but truncated. Long-press on a room expands it as an overlay modal (room visually grows from its current position on top of the UI, background darkens). The modal shows the full ability text and dismisses on tap-away. Nothing underneath repositions or moves.
- **Q9**: ~~What happens visually when a dungeon is completed?~~ **RESOLVED** — When the player ventures into the bottommost room, the room ability displays, completion count increments, and the player returns to dungeon selection (no active dungeon). On the next venture they choose again (can be the same dungeon). Follows rules 309.7 and 701.49c.
- **Q10**: ~~Should we show a "dungeon completed" count somewhere on screen?~~ **RESOLVED** — Yes. Track both a **global session completion count** (total dungeons completed) and **per-dungeon completion counts** (how many times each specific dungeon has been completed). Some cards care about specific dungeon completions.
- **Q11**: ~~How does the user go back to dungeon selection after completing one?~~ **RESOLVED** — Automatic. Completing a dungeon returns to dungeon selection.

### Persistence
- **Q12**: ~~Do we persist dungeon progress between app sessions?~~ **RESOLVED** — Yes. Full state persists (active dungeon, current room, initiative toggle). Player picks up where they left off.
- **Q13**: ~~Do we persist the completion count?~~ **RESOLVED** — Yes, both global and per-dungeon counts persist. Resettable from the tool's home view.

### Design
- **Q14**: ~~Each dungeon has a different visual flavor in the real cards. Do we try to match that aesthetic, or use a consistent app theme?~~ **RESOLVED** — Consistent dungeon-themed aesthetic across all dungeons. No per-dungeon unique styling.
- **Q15**: ~~The dungeon maps vary in complexity. Do we use a single layout approach that works for all, or custom layouts per dungeon?~~ **RESOLVED** — Single consistent layout approach (VStack of HStack tiers). Iterate if needed for larger dungeons.
- **Q16**: ~~Should the dungeon selector show the full map as a preview, or just the name?~~ **RESOLVED** — Show dungeon names with a "Preview" button. Preview fetches the dungeon's card image from Scryfall's CDN and displays it. If the fetch fails, show a modal with "Failed to fetch from Scryfall. Card text:" followed by the dungeon's oracle text.
- **Q17**: ~~Is there a "reset" to restart a dungeon mid-way, or must the player always complete it?~~ **RESOLVED** — Yes, allow reset/abandon from the tool's home view. Per rules (309.3), only one dungeon at a time — player must complete or abandon before starting another.
- **Q18**: ~~Do we support Baldur's Gate Wilderness?~~ **RESOLVED** — Yes, support all 5 dungeons including Baldur's Gate Wilderness.
