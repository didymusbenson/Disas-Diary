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
1. **Build a deck**: Select attractions by name, then pick a specific lit-up variant for each, and save as a named deck. Multiple saved decks supported. Minimum 10 unique attraction names per deck.
2. **Load a deck**: Load a previously saved deck list
3. **Play a deck**: Load a saved deck, shuffle it automatically, and manage the game state:

#### Play Screen States

**No deck loaded**: Empty screen with centered "No deck loaded" background text and a plaintext link-style button to go to deck selection. This is the default state if no deck has been loaded.

**Deck loaded**: Full play interface. "Reset" action available to unload the deck and return to deck selection (with confirmation dialog).

#### Play Screen Layout (deck loaded)
- **Deck indicator**: Shows remaining card count in the shuffled attraction deck
- **Open attractions list**: Starts empty. Each open attraction is displayed as a card showing:
  - Attraction name
  - Visit ability text (the effect)
  - Lit-up numbers visually indicated (which numbers trigger visits)
- **"Open an Attraction" button**: Takes the next card off the top of the shuffled deck and adds it to the open attractions list as a new card
- **"Roll to Visit" button**: Rolls a d6, displays the result, then shows a list of triggered visit abilities from all open attractions whose lit-up numbers match the roll — giving the player a clear action list of effects to resolve
- **Close/junkyard/exile**: Swipe to junkyard. Long-press gives a choice of "Junkyard" or "Exile" — exile removes the card without adding it to the junkyard
- **Junkyard button**: Opens a bottom sheet listing junked attraction names and their lit-up numbers
- **Reset button**: Moves all open, junked, and exiled attractions back into the deck, reshuffles. Shows a confirmation dialog (confirm/cancel) before executing
- **Prize claimed indicator**: Attractions with a "claim the prize" mechanic show a toggleable "prize claimed" indicator on the card

### Legality & Acorn UX

- The card selection list shows an **acorn indicator** on acorn-stamped attractions
- A **"Commander Legal" filter toggle** hides acorn attractions from the list, showing only the 22 eternal-legal cards
- Saved decks that contain any acorn-stamped attractions are marked with an **acorn icon** in the deck list to indicate they are not legal for sanctioned play
- Decks containing only non-acorn attractions have no special marking (implicitly Commander-legal)

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

Full dataset: `attractions_data.json` (135 entries — 35 unique names × variants, with `security_stamp` and `commander_legal` fields)

### Format Legality

All Attractions are from Unfinity (UNF). Legality is determined by security stamp:

- **No acorn stamp** (security stamp: `none` or `oval`) = legal in **Commander** (the only eternal format that permits Attractions)
- **Acorn stamp** (security stamp: `acorn`) = **not legal** in any sanctioned format; casual/Un-games only
- Attractions are **not legal** in Legacy, Vintage, Modern, Standard, Pioneer, or Pauper regardless of stamp

*Data verified against Scryfall API on 2026-03-26.*

#### Eternal-Legal Attractions (22 cards — Commander-legal)

| Attraction | Stamp | Variants | Lit-Up Numbers (per variant) |
|---|---|---|---|
| Balloon Stand | none | 4 | [2,6] [3,6] [4,6] [5,6] |
| Bounce Chamber | none | 4 | [2,6] [3,6] [4,6] [5,6] |
| Bumper Cars | none | 6 | [2,3,6] [2,4,6] [2,5,6] [3,4,6] [3,5,6] [4,5,6] |
| Clown Extruder | none | 4 | [2,6] [3,6] [4,6] [5,6] |
| Concession Stand | none | 4 | [2,6] [3,6] [4,6] [5,6] |
| Costume Shop | none | 6 | [2,3,6] [2,4,6] [2,5,6] [3,4,6] [3,5,6] [4,5,6] |
| Drop Tower | none | 6 | [2,3,6] [2,4,6] [2,5,6] [3,4,6] [3,5,6] [4,5,6] |
| Ferris Wheel | oval | 1 | [4,5,6] |
| Foam Weapons Kiosk | none | 4 | [2,6] [3,6] [4,6] [5,6] |
| Fortune Teller | none | 6 | [2,3,6] [2,4,6] [2,5,6] [3,4,6] [3,5,6] [4,5,6] |
| Hall of Mirrors | oval | 2 | [2,6] [4,6] |
| Haunted House | oval | 2 | [3,6] [4,6] |
| Information Booth | none | 4 | [2,6] [3,6] [4,6] [5,6] |
| Kiddie Coaster | none | 6 | [2,3,6] [2,4,6] [2,5,6] [3,4,6] [3,5,6] [4,5,6] |
| Merry-Go-Round | oval | 2 | [2,6] [5,6] |
| Pick-a-Beeble | none | 6 | [2,3,6] [2,4,6] [2,5,6] [3,4,6] [3,5,6] [4,5,6] |
| Roller Coaster | none | 4 | [2,6] [3,6] [4,6] [5,6] |
| Spinny Ride | none | 6 | [2,3,6] [2,4,6] [2,5,6] [3,4,6] [3,5,6] [4,5,6] |
| Storybook Ride | oval | 2 | [2,5,6] [3,4,6] |
| Swinging Ship | oval | 2 | [2,6] [4,6] |
| Trash Bin | none | 4 | [2,6] [3,6] [4,6] [5,6] |
| Tunnel of Love | oval | 2 | [2,6] [3,6] |

#### Acorn-Only Attractions (13 cards — not legal in any sanctioned format)

| Attraction | Variants | Lit-Up Numbers (per variant) |
|---|---|---|
| Centrifuge | 2 | [3,6] [4,6] |
| Cover the Spot | 4 | [2,3,4,6] [2,3,5,6] [2,4,5,6] [3,4,5,6] |
| Dart Throw | 4 | [2,3,4,6] [2,3,5,6] [2,4,5,6] [3,4,5,6] |
| Gallery of Legends | 2 | [3,6] [5,6] |
| Gift Shop | 2 | [2,3,6] [4,5,6] |
| Guess Your Fate | 4 | [2,3,4,6] [2,3,5,6] [2,4,5,6] [3,4,5,6] |
| Log Flume | 2 | [3,6] [5,6] |
| Memory Test | 2 | [4,6] [5,6] |
| Push Your Luck | 2 | [2,3,6] [4,5,6] |
| Scavenger Hunt | 6 | [2,5,6] [4,5,6] [2,3,6] [2,4,6] [3,5,6] [3,4,6] |
| Squirrel Stack | 6 | [2,3,6] [2,4,6] [2,5,6] [3,4,6] [3,5,6] [4,5,6] |
| The Superlatorium | 6 | [3,4,6] [2,4,6] [2,3,6] [3,5,6] [4,5,6] [2,5,6] |
| Trivia Contest | 6 | [2,5,6] [2,4,6] [4,5,6] [3,5,6] [3,4,6] [2,3,6] |

### Key observations
- Number 6 is ALWAYS lit on every variant
- Number 1 is NEVER lit (1 is the "whiff" roll)
- Lit counts range from 2 (e.g., Balloon Stand [2,6]) to 4 (e.g., Cover the Spot [2,3,4,6])
- Variant counts range from 1 (Ferris Wheel) to 6 (Bumper Cars, etc.)
- Collector numbers use letter suffixes: 200a, 200b, 200c, etc.
- The 22 Commander-legal attractions are sufficient to build a constructed deck (minimum 10 unique names)

---

## Open Questions

### Data & Card Database
- **Q1**: ~~Where do we source the list of all attraction cards?~~ **RESOLVED** — Sourced from Scryfall, saved as `attractions_data.json` (135 entries, 35 unique names with all variant lit-up numbers).
- **Q2**: ~~Each attraction has multiple printings with different lit-up numbers. Do we need to track which specific printing/variant the user has, or just let them pick lit-up numbers manually?~~ **RESOLVED** — User picks the specific variant (see Q5).
- **Q3**: ~~Do we bundle the card data as a static asset (small — 35 cards), or fetch from Scryfall at runtime?~~ **RESOLVED** — Bundle as a static asset. Updates to the attraction card pool are extremely rare.

### Deck Building
- **Q4**: ~~Constructed requires 10+ cards with unique names. Limited allows 3+ with duplicates. Do we enforce these rules or leave it flexible?~~ **RESOLVED** — Enforce minimum 10 unique attraction names per deck.
- **Q5**: ~~How do we handle the lit-up number variants?~~ **RESOLVED** — Option (b): User selects a card name from the list, then picks the specific lit-up variant they want to add to the deck (matching their physical cards).
- **Q6**: ~~How many saved decks can a player have? Just one, or multiple named decks?~~ **RESOLVED** — Multiple named decks.

### Persistence
- **Q7**: ~~Where do we store saved deck lists? SharedPreferences (like existing app state) or something more structured?~~ **RESOLVED** — Deck lists always persist. Users can have unlimited named decks and edit them.
- **Q8**: ~~Do we persist game state (mid-game open attractions, junkyard, deck order) between app sessions?~~ **RESOLVED** — Yes, persist full game state.

### UI/UX
- **Q9**: ~~What does the deck building screen look like? Search/filter list? Checklist?~~ **RESOLVED** — Checklist of all 35 unique attraction names. Tapping an unchecked item expands an inline drilldown showing all lit-up variants for that attraction (e.g., "[2, 6]", "[3, 6]"). Selecting a variant collapses the drilldown and shows the item as checked with the selected lit-up numbers inline (e.g., "☑ Balloon Stand {2}{6}"). Tapping a checked item allows changing/removing the selection.
- **Q10**: ~~What does the "playing" screen look like? Zones laid out visually? List-based?~~ **RESOLVED** — List-based. Deck indicator at top, open attractions as cards in a list, action buttons for "Open an Attraction" and "Roll to Visit".
- **Q11**: ~~How do we represent the d6 roll? Animated? Just a number? Tap-to-roll button?~~ **RESOLVED** — "Roll to Visit" button. Shows the roll result and a list of triggered visit abilities the player must resolve.
- **Q12**: ~~How do we visually show which attractions are "visited" after a roll?~~ **RESOLVED** — After rolling, display a list of triggered visit actions (attraction name + effect text) for all open attractions matching the roll.
- **Q13**: ~~Do we show the visit ability text for each attraction, or just the name and lit-up numbers?~~ **RESOLVED** — Show both: name, lit-up numbers, and visit ability text on each open attraction card.
- **Q14**: ~~How does the user "open" an attraction? Button? Is it manual (user decides when an effect tells them to) or automatic?~~ **RESOLVED** — Manual "Open an Attraction" button. Player presses it when a game effect tells them to open one.
- **Q15**: ~~How does the user "close" an attraction / send it to the junkyard? Swipe? Button? Long-press?~~ **RESOLVED** — Swipe to dismiss. Junkyard is a button that opens a bottom sheet showing names and lit-up numbers of junked attractions.

### Scope
- **Q16**: ~~Do we need to handle the "claim the prize" sub-mechanic (702.159b), or is showing the visit text sufficient?~~ **RESOLVED** — Show a toggleable "prize claimed" indicator on attraction cards that have the mechanic. Player handles the actual effect.
- **Q17**: ~~Do we track visit ability effects (e.g., "create a token"), or just indicate which attractions were visited and let the player handle the effects?~~ **RESOLVED** — Show the visit ability text so the player knows what to do; the player handles the actual effects themselves.
- **Q18**: ~~The rules mention attractions can go to exile. Do we need an exile zone, or is junkyard sufficient for our tracker?~~ **RESOLVED** — Yes. Long-press gives choice of junkyard or exile. Exiled cards are removed from play and don't go to the junkyard.
- **Q19**: ~~Should there be a "reset game" that moves all junkyard + battlefield back into the deck and reshuffles?~~ **RESOLVED** — Yes, with a confirmation dialog (confirm/cancel).
