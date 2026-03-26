#!/usr/bin/env python3
"""
Extract card type information from cached MTGJSON AtomicCards data.

Reads the locally cached AtomicCards.json (downloaded by fetch_mtgjson.py)
and extracts card type data relevant to Mana Burn's tools:
- All known card supertypes, types, and subtypes
- Cards grouped by type for lookup
- Type frequency counts

Usage:
    python3 scripts/extract_card_types.py
    (Run from disas_diary_flutter/)

    Requires fetch_mtgjson.py to have been run first.
"""

import json
import sys
from collections import defaultdict
from pathlib import Path

SCRIPT_DIR = Path(__file__).parent
DATA_DIR = SCRIPT_DIR / "data"
ATOMIC_FILE = DATA_DIR / "AtomicCards.json"
OUTPUT_FILE = DATA_DIR / "card_types.json"


def load_atomic_cards():
    """Load cached AtomicCards.json."""
    if not ATOMIC_FILE.exists():
        print("AtomicCards.json not found. Run fetch_mtgjson.py first.")
        return None

    print(f"Loading {ATOMIC_FILE.name}...")
    with open(ATOMIC_FILE, "r", encoding="utf-8") as f:
        data = json.load(f)

    cards = data.get("data", {})
    print(f"Loaded {len(cards):,} cards")
    return cards


def extract_types(cards):
    """Extract all supertypes, types, and subtypes with frequency counts."""
    supertypes = defaultdict(int)
    types = defaultdict(int)
    subtypes = defaultdict(int)
    type_lines = defaultdict(int)

    skipped_alchemy = 0

    for card_name, variations in cards.items():
        if card_name.startswith("A-"):
            skipped_alchemy += 1
            continue

        # Use front face for DFCs
        card = None
        for v in variations:
            if v.get("side") == "a":
                card = v
                break
        if not card:
            card = variations[0]

        for st in card.get("supertypes", []):
            supertypes[st] += 1
        for t in card.get("types", []):
            types[t] += 1
        for sub in card.get("subtypes", []):
            subtypes[sub] += 1

        type_line = card.get("type", "")
        if type_line:
            type_lines[type_line] += 1

    if skipped_alchemy:
        print(f"Skipped {skipped_alchemy:,} Alchemy cards")

    return {
        "supertypes": dict(sorted(supertypes.items())),
        "types": dict(sorted(types.items())),
        "subtypes": dict(sorted(subtypes.items(), key=lambda x: -x[1])),
        "type_line_count": len(type_lines),
    }


def main():
    print("=" * 60)
    print("Mana Burn - Card Type Extractor")
    print("=" * 60)

    cards = load_atomic_cards()
    if cards is None:
        return 1

    result = extract_types(cards)

    print(f"\nSupertypes ({len(result['supertypes'])}):")
    for name, count in result["supertypes"].items():
        print(f"  {name}: {count:,}")

    print(f"\nCard types ({len(result['types'])}):")
    for name, count in result["types"].items():
        print(f"  {name}: {count:,}")

    print(f"\nSubtypes: {len(result['subtypes']):,} unique")
    print("Top 20 subtypes:")
    for name, count in list(result["subtypes"].items())[:20]:
        print(f"  {name}: {count:,}")

    print(f"\nUnique type lines: {result['type_line_count']:,}")

    # Save output
    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        json.dump(result, f, indent=2, ensure_ascii=False)

    print(f"\nSaved to {OUTPUT_FILE}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
