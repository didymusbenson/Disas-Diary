# Next Feature: Toolkit Architecture

## Overview

Transform the app from a single-tool experience into a multi-tool MTG toolkit. The current Disa's Diary (Tarmogoyf tracker) becomes one tool among many, accessible from a central home menu.

## Navigation

- **Home Screen**: A list/menu of all available tools
- **Tool Screens**: Each tool opens to its own full screen with a back button to return to the home menu
- **State Retention**: Tools retain their state when the user navigates away, but are otherwise unloaded (not actively running in the background)

## Tools

### Existing
- **Disa's Diary** — Tarmogoyf P/T calculator and graveyard card type tracker

### Planned
- **Mana Pool** — Track available mana across colors
- **Dungeons** — Dungeon progress tracking (Dungeon of the Mad Mage, Lost Mine of Phandelver, Tomb of Annihilation, Undercity)
- **Attractions Deck** — Attraction management for Unfinity mechanics
