# UX Review Recommendations

Compiled from independent UX reviews of the Attractions and Dungeons feature specs. Date: 2026-03-26.

These are recommendations only — no changes have been made to the specs.

---

## Attractions

### Usability Concerns

1. **Swipe-to-junkyard is high-risk during gameplay.** Easy to trigger accidentally when scrolling the open attractions list. No undo mechanism exists. The rest of the app uses tap/long-press patterns (TokenView). Rec: require a confirmation step on swipe (reveal a "Junkyard" button) or consolidate junkyard/exile into long-press only.

2. **Deck building checklist will be cumbersome at 35 items.** Expand/collapse behavior causes the list to jump around. Rec: auto-scroll to keep the expanded item visible, or use a modal bottom sheet for variant selection instead of inline drilldown.

3. **"Roll to Visit" result presentation is underspecified.** Where does the result appear? If it's a modal, the player can't reference the open attractions list while resolving effects. Rec: use a non-modal bottom sheet or overlay card that can coexist with the battlefield view.

4. **Only constructed minimums enforced (10 unique names).** Limited play (3-card minimum, duplicates allowed) is not supported. Rec: explicitly note limited is out of scope, or add a mode toggle.

5. **Variant selection friction.** Distinguishing `[2,3,6]` from `[2,4,6]` across 6 variants requires careful reading. Rec: display variants as visual grids of numbered circles (lit vs unlit) so the player can pattern-match against their physical card.

### Missing Interactions

6. **No deck editing flow described.** The spec says decks are editable but doesn't describe how (add/remove cards, change variants, rename, delete a deck).

7. **No undo for accidental junkyard/exile.** Some MTG effects can return attractions from junkyard to battlefield. The junkyard bottom sheet shows names but offers no actions.

8. **No "shuffle junkyard into deck" action.** This is a real MTG game action (some effects shuffle the junkyard back into the attraction deck). Currently unsupported.

9. **Deck empty state unaddressed.** What happens when "Open an Attraction" is pressed but the deck is empty? The button should be disabled or show feedback.

10. **Exile zone has no viewer.** Junkyard has a button and bottom sheet. Exiled cards have no equivalent — players may need to verify what's been exiled.

11. **Full card text not viewable on play screen.** Some visit abilities reference "claim the prize" with a separate prize paragraph. The prize text should be readable somewhere.

### Accessibility

12. **Lit-up numbers may use color alone.** Rec: use secondary indicators (filled vs outline circles, bold vs faded) for colorblind users.

13. **Swipe gesture has no visible affordance.** New users won't discover it. The rest of the app uses visible buttons.

14. **Small touch targets in variant picker.** Bracket-notation variant options may be too small on phones. Should match the app's existing generous tap zones.

15. **Roll result needs to be readable at a glance.** Die result should be large and prominent, not buried in a list.

### Flow & Navigation

16. **Navigation architecture is unspecified.** Three distinct screens (deck builder, deck selector, play screen) need clear routing. Rec: land on play screen as default (most used during games), with links to deck selection/building from there.

17. **Reset navigates vs clears state?** Unclear whether reset navigates away from the play screen or just clears state in-place and shows the "no deck loaded" empty state.

18. **No way to switch decks without full reset.** Loading the wrong deck requires resetting all game state. Rec: a "switch deck" option with a state-loss warning.

### Visual Hierarchy

19. **Open attraction cards may be too dense.** Name + visit text + lit-up numbers + prize toggle across 3-5 open attractions is a lot. Rec: compact card design with lit-up numbers most prominent (they're the primary info during "Roll to Visit").

20. **Lit-up numbers should be the dominant visual element.** "Did my roll hit?" is the core question. Numbers should be large, scannable, not buried alongside text.

21. **Action buttons must be always visible.** "Open" and "Roll to Visit" should be fixed/sticky, not scrollable with the attractions list.

22. **"No deck loaded" state could be more useful.** Show deck count or "Last used: [name]" with one-tap reload.

### Edge Cases

23. **Persistence is complex.** Shuffled deck order, open cards, junkyard, exile, and prize-claimed states must all serialize and survive app kills.

24. **Duplicate names in junkyard display.** If limited is ever supported, the bottom sheet needs to handle duplicate card names.

25. **Bundled data versioning.** If new attractions are ever printed, consider versioning the data file and displaying the version in settings.

26. **Long attraction names and visit text.** "The Superlatorium" and wordy visit abilities need graceful text overflow handling.

---

## Dungeons

### Usability Concerns

1. **Venture button adds friction at branches.** Two taps (Venture, then choose room) at every branch. In Baldur's Gate Wilderness, nearly every tier branches. Rec: allow tapping directly on an eligible next room to advance, with the Venture button as a fallback.

2. **Long-press for room text is not discoverable.** Reading room abilities is a primary need (players need to read effects before choosing a branch), not a power-user shortcut. Rec: show full text for the current room and its immediate children without requiring long-press. Reserve long-press for non-adjacent rooms.

3. **Initiative toggle interaction is underspecified.** Where does it live? What happens if initiative is turned OFF mid-Undercity? (Per rules, the dungeon stays active — player just loses auto-venture triggers.) Toggle should not alter active dungeon state.

4. **Venture button placement is unspecified.** Most frequently tapped element needs defined positioning for one-handed use.

### Missing Interactions

5. **No undo for misclicked venture.** If a player taps the wrong branch, they're stuck. Rec: single-step undo behind a confirmation dialog.

6. **No visited room indicators.** Q7 left visited/unvisited styling unresolved. Even subtle opacity or checkmarks would help orientation, especially on repeat ventures through the same dungeon.

7. **Scryfall preview has no loading state.** What does the user see while the image fetches? Rec: loading spinner, and cache fetched images for the session.

8. **Completion count display unspecified.** Where does it appear? Badge? Header? Footer? Needs to be glanceable for cards that care about it (e.g., Dungeon Descent).

9. **Abandon/reset flow needs detail.** Does it require confirmation? (It should — it's destructive.) Does abandoning count toward completion? (It should not.) Where is the control?

### Accessibility

10. **Room tap targets on Baldur's Gate Wilderness will be tiny.** 3-wide tiers on a phone screen: ~116pt per room chip. Room names like "Circus of the Last Days" won't fit. Falls below 48x48dp minimum touch targets.

11. **Glowing border relies on color alone.** Rec: add a secondary indicator (filled background, marker icon, bold outline) for colorblind users.

12. **Long-press is inaccessible to some users.** Motor impairments, screen readers. Since reading room text is primary, needs an accessible alternative.

13. **Room expansion modal needs proper focus trapping** and back-button/gesture dismissal, not just tap-away.

### Flow & Navigation

14. **Initiative toggle + active dungeon state transitions need full specification.** Key gap: what happens when initiative is toggled on while a non-Undercity dungeon is in progress? (Per rules: nothing changes, auto-selection only applies when no dungeon is active.)

15. **Completion needs a brief acknowledgment moment.** If it's instant, the player never sees the final room's ability text. Rec: show final room highlighted with "Dungeon Complete" indicator, require a tap before returning to selection.

16. **Cold-start after persistence.** Force-quitting mid-dungeon and returning later drops the player into a dungeon with no context. Rec: show a "You have an active dungeon" summary on return.

### Visual Hierarchy

17. **Baldur's Gate Wilderness will break the VStack/HStack layout.** 8 tiers, 3-wide, long room names. At ~116pt per chip, names truncate to uselessness. Recs: abbreviated names or numbered rooms with a legend; horizontal scroll or pinch-to-zoom; vertical scroll for the tier stack (8 tiers will exceed screen height).

18. **Connection arrows between tiers are not specified.** Without drawn connections, `[Goblin Camp] [Emerald Grove] [Auntie's Teahouse]` above `[Defiled Temple] [Mountain Pass]` has no navigational meaning. The spec must address how edges are rendered (lines, arrows, indentation, etc.).

19. **Information density during active play.** Player needs: dungeon map, current room ability, next room options + abilities, completion count, Venture button — all on one phone screen. Rec: prioritize decision-relevant info (current room, next options, Venture button). Full map can scroll above.

20. **Scryfall preview vs offline.** If offline, every preview tap hangs then falls back. Rec: show oracle text by default with optional "View Card Image" button, and cache successful fetches to disk.

### Edge Cases

21. **Baldur's Gate Wilderness has 3 bottommost rooms.** Data model must support multiple terminal nodes. Venture logic at the tier above must correctly offer choices leading to different exits.

22. **Ansur's Sanctum is reachable from two parents.** Layout must not render it twice. Data model must deduplicate.

23. **Venture on bottommost room should be relabeled.** "Venture" implies continuing; at the bottom room the action completes the dungeon. Rec: relabel to "Complete Dungeon" when on a bottommost room.

24. **Global app reset vs dungeon reset.** The existing app has a reset button in the AppBar. Does it also clear dungeon state? Spec should clarify.

25. **Scryfall image caching.** Repeated preview taps should not re-fetch. Cache to disk.
