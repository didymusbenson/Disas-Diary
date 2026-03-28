# Dice Bag

Roll X dice — a utility for cards that require rolling large numbers of six-sided dice.

## Overview

Some MTG cards require rolling a variable number of d6s and interpreting the results. Doing this physically with large quantities of dice is slow and error-prone. The Dice Bag provides a fast, clear way to roll X dice and read the outcomes.

## Target Cards

### Luck Bobblehead
- **Cost:** {3} — Artifact — Bobblehead
- **Ability:** {1}, {T}: Roll X six-sided dice, where X is the number of Bobbleheads you control. Create a tapped Treasure token for each even result. If you rolled 6 exactly seven times, you win the game.
- **Needs:** Roll X dice, count even results, count exact 6s (flag if exactly 7)

### Clown Car
- **Cost:** {X} — Artifact — Vehicle
- **Ability:** When this Vehicle enters, roll X six-sided dice. For each odd result, create a 1/1 white Clown Robot artifact creature token. For each even result, put a +1/+1 counter on this Vehicle.
- **Needs:** Roll X dice, count odd results, count even results

### Attempted Murder
- **Cost:** {X}{B}{B} — Sorcery
- **Ability:** Choose target creature. Roll X six-sided dice. For each even result, put two -1/-1 counters on that creature. For each odd result, create a 1/2 blue Bird creature token with flying named Storm Crow.
- **Needs:** Roll X dice, count even results (×2 for -1/-1 counters), count odd results

## Open Questions

- Input method for X? (number picker, keypad, stepper?)
- Results display: individual dice, or just summarized counts?
- Should results break down by category automatically (odd/even, specific values)?
- Reroll support for individual dice? (some cards modify or reroll dice)
- History of recent rolls?
- Should this integrate with the Attractions roll-to-visit, or stay separate?
- Sound/haptic feedback on roll?

## Status

Spec in progress — gathering requirements.
