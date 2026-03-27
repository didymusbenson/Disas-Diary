# Attractions Deck

## Overview

An attraction management tool for the Unfinity set's Attractions mechanic. Players can build and save an attraction deck list, load it up, and "play it" by shuffling the deck, opening attractions, and rolling dice to visit them.

## Status

Investigation phase. Rules extracted, open questions drafted.

---

## Comprehensive Rules Reference

### 717. Attraction Cards

**717.1.** Attraction is an artifact subtype seen only on nontraditional Magic cards. Each Attraction has an "Astrotorium" card back rather than a traditional Magic card back and has a column of circled numbers on the right side of its text box. Numbers in white text on a brightly colored background are said to be "lit up" on those cards. Note that multiple Attraction cards with the same English name may have different numbers lit up. You can see each Attraction card's possible combinations of lights at Gatherer.Wizards.com.

**717.2.** Attraction cards do not begin the game in a player's deck and do not count toward maximum or minimum deck sizes. Rather, a player who chooses to play with Attraction cards begins the game with a supplementary Attraction deck that exists in the command zone. Each Attraction deck is shuffled before the game begins (see rule 103.3a).

**717.2a** In constructed play, an Attraction deck must contain at least ten Attraction cards and each card in an Attraction deck must have a different English name.

**717.2b** In limited play, an Attraction deck must contain at least three Attraction cards from that player's card pool, and may contain multiple Attractions cards with the same English name.

**717.3.** Effects can cause an Attraction card to enter the battlefield from the command zone. See rule 701.51, "Open an Attraction."

**717.4.** As a player's precombat main phase begins, a player who controls one or more Attractions rolls to visit their Attractions. See rules 703.4g and 701.52, "Roll to Visit Your Attractions." This turn-based action doesn't use the stack.

**717.5.** Each Attraction card has an ability that begins with the word "Visit" followed by a long dash in its rules text. This is a visit ability. A visit ability triggers whenever you roll to visit your Attractions and the result matches one of the lit-up numbers. See rule 702.159, "Visit."

**717.6.** If a card with an Astrotorium card back would be put into a zone other than the battlefield, exile, or the command zone from anywhere, instead its owner puts it into the command zone. This replacement effect may apply more than once to the same event. This is an exception to rule 614.5.

**717.6a** Each card owned by the same player that has been put in the command zone this way is kept in a single face-up pile separate from any player's Attraction deck. This pile is informally referred to as that player's "junkyard." The pile is not its own zone.

### 701.51. Open an Attraction

**701.51a** A player may open an Attraction only during a game in which that player is playing with an Attraction deck (see rule 717, "Attraction Cards").

**701.51b** To open an Attraction, move the top card of your Attraction deck off the Attraction deck, turn it face up, and put it onto the battlefield under your control.

**701.51c** An ability which triggers whenever a player opens an Attraction triggers when that player puts an Attraction card onto the battlefield while performing the instruction in the above rule. If an effect prevents that Attraction from entering the battlefield or replaces entering the battlefield with another event, that ability doesn't trigger.

### 701.52. Roll to Visit Your Attractions

**701.52a** To roll to visit your Attractions, roll a six-sided die. Then if you control one or more Attractions with a number lit up that is equal to that result, each of those Attractions has been "visited" and its visit ability triggers. See rule 717, "Attraction Cards," and rule 702.159, "Visit."

### 702.159. Visit

**702.159a** Visit is a keyword ability found on Attraction cards (see rule 717). "Visit — [Effect]" means "Whenever you roll to visit your Attractions, if the result is equal to a number that is lit up on this Attraction, [effect]." See rule 701.52, "Roll to Visit Your Attractions."

**702.159b** Some Attractions instruct a player to "claim the prize," followed by a second paragraph that starts with the word "Prize" and a long dash. This text is part of its visit ability. To claim the prize of an Attraction, perform the actions listed after the long dash.

### 703.4g (Turn-Based Action)

Immediately after the action of placing lore counters has been completed, if the active player controls any Attractions, that player rolls to visit their Attractions. See rule 701.52, "Roll to Visit Your Attractions."

### Glossary

- **Attraction** — An artifact type seen only on nontraditional Magic cards in the Unfinity expansion. See rule 717, rule 701.51, and rule 701.52.
- **Attraction Deck** — An optional deck of at least three (limited) or ten (constructed) Attraction cards that can be used to support play with some cards from the Unfinity expansion. See rule 717.2.
- **Visit** — A keyword ability found on Attraction cards. It provides an effect whenever you roll to visit your attractions and get certain results. See rule 702.159.
- **Junkyard** — (informal) The face-up pile of used Attraction cards in the command zone. See rule 717.6a.

---

## Feature Goals

Players should be able to:
1. **Build a deck**: Select attraction cards by name and save a deck list
2. **Load a deck**: Load a previously saved deck list
3. **Play a deck**: Shuffle the deck and manage the game state:
   - Open attractions (move top card of deck to battlefield)
   - Roll to visit (roll a d6, highlight which open attractions are visited)
   - Close/junkyard attractions (move from battlefield to junkyard pile)
   - See the junkyard pile

---

## Key Mechanics to Model

### Zones
- **Attraction Deck** (command zone, face down, shuffled)
- **Battlefield** (open attractions, face up)
- **Junkyard** (closed attractions, face up pile in command zone)

### Lit-Up Numbers
- Each attraction card has numbers 1-6, with some "lit up"
- Number 6 is ALWAYS lit up on every attraction
- Different printings of the same named card can have different lit-up numbers
- When rolling to visit, ALL open attractions with that number lit up are visited

### Game Flow
1. Deck is shuffled at game start
2. Effects cause attractions to be "opened" (top of deck → battlefield)
3. At precombat main phase, roll d6 to visit
4. Visited attractions trigger their visit abilities
5. Attractions that leave the battlefield go to junkyard (not back to deck)

---

## Card Data (sourced from Scryfall)

Full dataset: `attractions_data.json` (135 entries — 35 unique names × variants)

| Attraction | Variants | Lit-Up Numbers (per variant) |
|---|---|---|
| Balloon Stand | 4 | [2,6] [3,6] [4,6] [5,6] |
| Bounce Chamber | 4 | [2,6] [3,6] [4,6] [5,6] |
| Bumper Cars | 6 | [2,3,6] [2,4,6] [2,5,6] [3,4,6] [3,5,6] [4,5,6] |
| Centrifuge | 2 | [3,6] [4,6] |
| Clown Extruder | 4 | [2,6] [3,6] [4,6] [5,6] |
| Concession Stand | 4 | [2,6] [3,6] [4,6] [5,6] |
| Costume Shop | 6 | [2,3,6] [2,4,6] [2,5,6] [3,4,6] [3,5,6] [4,5,6] |
| Cover the Spot | 4 | [2,3,4,6] [2,3,5,6] [2,4,5,6] [3,4,5,6] |
| Dart Throw | 4 | [2,3,4,6] [2,3,5,6] [2,4,5,6] [3,4,5,6] |
| Drop Tower | 6 | [2,3,6] [2,4,6] [2,5,6] [3,4,6] [3,5,6] [4,5,6] |
| Ferris Wheel | 1 | [4,5,6] |
| Foam Weapons Kiosk | 4 | [2,6] [3,6] [4,6] [5,6] |
| Fortune Teller | 6 | [2,3,6] [2,4,6] [2,5,6] [3,4,6] [3,5,6] [4,5,6] |
| Gallery of Legends | 2 | [3,6] [5,6] |
| Gift Shop | 2 | [2,3,6] [4,5,6] |
| Guess Your Fate | 4 | [2,3,4,6] [2,3,5,6] [2,4,5,6] [3,4,5,6] |
| Hall of Mirrors | 2 | [2,6] [4,6] |
| Haunted House | 2 | [3,6] [4,6] |
| Information Booth | 4 | [2,6] [3,6] [4,6] [5,6] |
| Kiddie Coaster | 6 | [2,3,6] [2,4,6] [2,5,6] [3,4,6] [3,5,6] [4,5,6] |
| Log Flume | 2 | [3,6] [5,6] |
| Memory Test | 2 | [4,6] [5,6] |
| Merry-Go-Round | 2 | [2,6] [5,6] |
| Pick-a-Beeble | 6 | [2,3,6] [2,4,6] [2,5,6] [3,4,6] [3,5,6] [4,5,6] |
| Push Your Luck | 2 | [2,3,6] [4,5,6] |
| Roller Coaster | 4 | [2,6] [3,6] [4,6] [5,6] |
| Scavenger Hunt | 6 | [2,5,6] [4,5,6] [2,3,6] [2,4,6] [3,5,6] [3,4,6] |
| Spinny Ride | 6 | [2,3,6] [2,4,6] [2,5,6] [3,4,6] [3,5,6] [4,5,6] |
| Squirrel Stack | 6 | [2,3,6] [2,4,6] [2,5,6] [3,4,6] [3,5,6] [4,5,6] |
| Storybook Ride | 2 | [2,5,6] [3,4,6] |
| Swinging Ship | 2 | [2,6] [4,6] |
| The Superlatorium | 6 | [3,4,6] [2,4,6] [2,3,6] [3,5,6] [4,5,6] [2,5,6] |
| Trash Bin | 4 | [2,6] [3,6] [4,6] [5,6] |
| Trivia Contest | 6 | [2,5,6] [2,4,6] [4,5,6] [3,5,6] [3,4,6] [2,3,6] |
| Tunnel of Love | 2 | [2,6] [3,6] |

**Key observations:**
- Number 6 is ALWAYS lit on every variant
- Number 1 is NEVER lit (1 is the "whiff" roll)
- Lit counts range from 2 (e.g., Balloon Stand [2,6]) to 4 (e.g., Cover the Spot [2,3,4,6])
- Variant counts range from 1 (Ferris Wheel) to 6 (Bumper Cars, etc.)
- Collector numbers use letter suffixes: 200a, 200b, 200c, etc.

---

## Open Questions

### Data & Card Database
- **Q1**: ~~Where do we source the list of all attraction cards?~~ **RESOLVED** — Sourced from Scryfall, saved as `attractions_data.json` (135 entries, 35 unique names with all variant lit-up numbers).
- **Q2**: Each attraction has multiple printings with different lit-up numbers. Do we need to track which specific printing/variant the user has, or just let them pick lit-up numbers manually?
- **Q3**: Do we bundle the card data as a static asset (small — 35 cards), or fetch from Scryfall at runtime?

### Deck Building
- **Q4**: Constructed requires 10+ cards with unique names. Limited allows 3+ with duplicates. Do we enforce these rules or leave it flexible?
- **Q5**: How do we handle the lit-up number variants? Options:
  - (a) User just picks card names, and we randomly assign a variant when they "play"
  - (b) User picks specific variants (matching their physical cards)
  - (c) User manually sets which numbers are lit for each card
- **Q6**: How many saved decks can a player have? Just one, or multiple named decks?

### Persistence
- **Q7**: Where do we store saved deck lists? SharedPreferences (like existing app state) or something more structured?
- **Q8**: Do we persist game state (mid-game open attractions, junkyard, deck order) between app sessions?

### UI/UX
- **Q9**: What does the deck building screen look like? Search/filter list? Checklist?
- **Q10**: What does the "playing" screen look like? Zones laid out visually? List-based?
- **Q11**: How do we represent the d6 roll? Animated? Just a number? Tap-to-roll button?
- **Q12**: How do we visually show which attractions are "visited" after a roll?
- **Q13**: Do we show the visit ability text for each attraction, or just the name and lit-up numbers? (Showing ability text helps players know what triggers.)
- **Q14**: How does the user "open" an attraction? Button? Is it manual (user decides when an effect tells them to) or automatic?
- **Q15**: How does the user "close" an attraction / send it to the junkyard? Swipe? Button? Long-press?

### Scope
- **Q16**: Do we need to handle the "claim the prize" sub-mechanic (702.159b), or is showing the visit text sufficient?
- **Q17**: Do we track visit ability effects (e.g., "create a token"), or just indicate which attractions were visited and let the player handle the effects?
- **Q18**: The rules mention attractions can go to exile. Do we need an exile zone, or is junkyard sufficient for our tracker?
- **Q19**: Should there be a "reset game" that moves all junkyard + battlefield back into the deck and reshuffles?
