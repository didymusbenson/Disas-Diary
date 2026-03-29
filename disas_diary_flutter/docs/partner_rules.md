# Partner Rules Reference

Extracted from the Comprehensive Rules via the french-vanilla codebase.

---

## Glossary

**Partner, "Partner—[text]," "Partner with [name]"**
A keyword ability that lets two legendary cards be your commander in the Commander variant rather than one. "Partner with [name]" is a specialized version of the ability that works even outside of the Commander variant to help two cards reach the battlefield together. See rule 702.124, "Partner," and rule 903, "Commander."

---

## Rule 702.124 — Partner

702.124a Partner abilities are keyword abilities that modify the rules for deck construction in the Commander variant (see rule 903), and they function before the game begins. Each partner ability allows you to designate two legendary cards as your commander rather than one. Each partner ability has its own requirements for those two commanders. The partner abilities are: partner, partner—[text], partner with [name], choose a Background, and Doctor's companion.

702.124b Your deck must contain exactly 100 cards, including its two commanders. Both commanders begin the game in the command zone.

702.124c A rule or effect that refers to your commander's color identity refers to the combined color identities of your two commanders. See rule 903.4.

702.124d Except for determining the color identity of your commander, the two commanders function independently. When casting a commander with partner, ignore how many times your other commander has been cast (see rule 903.8). When determining whether a player has been dealt 21 or more combat damage by the same commander, consider damage from each of your two commanders separately (see rule 903.10a).

702.124e If an effect refers to your commander while you have two commanders, it refers to either one. If an effect causes you to perform an action on your commander and it could affect both, you choose which it refers to at the time the effect is applied.

702.124f Different partner abilities are distinct from one another and cannot be combined. For example, you cannot designate two cards as your commander if one of them has "partner" and the other has "partner with [name]."

702.124g If a legendary card has more than one partner ability, you may choose which one to use when designating your commander, but you can't use both. Notably, no partner ability or combination of partner abilities can ever let a player have more than two commanders.

702.124h "Partner" means "You may designate two legendary cards as your commander rather than one if each of them has partner."

702.124i "Partner—[text]" means "You may designate two legendary cards as your commander rather than one if each of them has the same 'partner—[text]' ability." The "partner—[text]" abilities are "partner—Character select," "partner—Father & son," "partner—Friends forever," and "partner—Survivors."

702.124j "Partner with [name]" represents two abilities. It means "You may designate two legendary cards as your commander rather than one if each has a 'partner with [name]' ability with the other's name" and "When this permanent enters, target player may search their library for a card named [name], reveal it, put it into their hand, then shuffle."

702.124k "Choose a Background" means "You may designate two cards as your commander rather than one if one of them is this card and the other is a legendary Background enchantment card." You can't designate two cards as your commander if one has a "choose a Background" ability and the other is not a legendary Background enchantment card, and legendary Background enchantment cards can't be your commander unless you have also designated a commander with "choose a Background."

702.124m "Doctor's companion" means "You may designate two legendary creature cards as your commander rather than one if one of them is this card and the other is a legendary Time Lord Doctor creature card that has no other creature types."

702.124n If an effect refers to a partner ability by name, it means only that partner ability and not any others. If an effect refers to the partner ability or cards with partner and doesn't mention a specific variant of the partner ability by name, it is referring only to partner, partner—[text], partner with [name], or cards with any of those abilities, and it does not refer to any other partner variant.

---

## Relevant Rule 903 — Commander

903.4. The Commander variant uses color identity to determine what cards can be in a deck with a certain commander. The color identity of a card is the color or colors of any mana symbols in that card's mana cost or rules text, plus any colors defined by its characteristic-defining abilities (see rule 604.3) or color indicator (see rule 204).

903.5. Each Commander deck is subject to the following deck construction rules.

903.6. At the start of the game, each player puts their commander from their deck face up into the command zone. Then each player shuffles the remaining cards of their deck so that the cards are in a random order. Those cards become the player's library.

903.8. A player may cast a commander they own from the command zone. A commander cast from the command zone costs an additional {2} for each previous time the player casting it has cast it from the command zone that game. This additional cost is informally known as the "commander tax."

903.10. The Commander variant includes the following specification for winning and losing the game. All other rules for ending the game also apply. (See rule 104.)

903.10a A player who's been dealt 21 or more combat damage by the same commander over the course of the game loses the game. (This is a state-based action. See rule 704.)

---

## Key Takeaways for Implementation

- **Two commanders**: Partner allows exactly 2 commanders. No more, ever (702.124g).
- **Independent tax tracking**: Each partner commander has its own tax counter (702.124d, 903.8).
- **Independent damage tracking**: Combat damage from each commander is tracked separately against the 21-damage threshold (702.124d, 903.10a).
- **Combined color identity**: The deck's color identity is the union of both commanders' identities (702.124c, 903.4).
- **Partner variants are distinct**: partner, partner—[text], partner with [name], choose a Background, and Doctor's companion cannot mix (702.124f).
