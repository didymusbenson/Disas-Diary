# Dice Bag

Roll X dice — a utility for cards that require rolling large numbers of six-sided dice.

## Overview

Some MTG cards require rolling a variable number of d6s and interpreting the results. Doing this physically with large quantities of dice is slow and error-prone. The Dice Bag provides a fast, clear way to roll X dice and read the outcomes.

## Screen Layout

Two sections: a general-purpose dice roller at the top, and card-specific shortcut buttons below.

### General Dice Roller

- Dice count input (stepper or number picker) — "Roll X d6"
- Roll button
- Results display: show each individual die result in a grid
- Summary row below results: total even, total odd, count of each face (1-6)

### Results Display

- Individual dice shown as tiles in a Wrap layout
- Each tile shows the face value
- Even results visually distinguished from odd (color or border)
- Summary statistics below the dice grid

## Card Shortcuts

Three card-specific buttons that set the dice count, roll, and interpret results automatically.

### Luck Bobblehead

- **Input:** Number of Bobbleheads controlled (sets X)
- **Roll:** X d6
- **Results:**
  - "Create X tapped Treasure tokens" (count of even results)
  - If exactly 7 sixes were rolled: "You win the game!" prominently displayed
  - Show individual dice results

### Clown Car

- **Input:** X value (the mana spent)
- **Roll:** X d6
- **Results:**
  - "Create X Clown Robot tokens" (count of odd results)
  - "Put X +1/+1 counters on Clown Car" (count of even results)
  - Show individual dice results

### Attempted Murder

- **Input:** X value (the mana in the cost beyond {B}{B})
- **Roll:** X d6
- **Results:**
  - "Put X -1/-1 counters on target creature" (count of even results × 2)
  - "Create X Storm Crow tokens" (count of odd results)
  - Show individual dice results

## Open Questions

- Reroll support for individual dice? (some cards modify or reroll dice)
- History of recent rolls?
- Should this integrate with the Attractions roll-to-visit, or stay separate?
- Sound/haptic feedback on roll?
- Dice roll animation?

## Status

Spec in progress.
