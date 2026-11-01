# Frozen Passage — Game Design

## Status

The original traversal slice and Phase 6 web deployment are complete according to the user's report that the live game works. Phase 7's timer and local best-time record, Phase 8's second passage with moving platforms, and Phase 9's dash progression are implemented and covered by GUT. Interactive review of the new export is waived for the agent; the user will review the game link.

## Product goal

Create a small, polished game that players can run in a web browser. The planned art direction is a consistent winter environment built from curated, licensed resources.

## First playable loop (confirmed and implemented)

1. Start a short side-view level in a frozen landscape.
2. Move and jump across platforms and avoid falling.
3. Reach Passage 1's exit to open Passage 2; reach its exit to finish the full run.
4. If the player falls below the level boundary, restart at the current passage's start without resetting run time.

The first slice intentionally excluded combat, collectibles, checkpoints, multiple maps, and online services. The new expansion supersedes the one-passage scope by adding a second passage and speedrun mechanics; online services and leaderboards remain out of scope.

## Controls

- Move left/right: arrow keys or A/D.
- Jump: Space, Up, or W while grounded.
- Proposed dash input after unlock: Shift. Dash unlocks at a clearly marked course point (user decision, 2026-11-01).
- Keyboard is the first target. Controller support is not specified.

## Platform and runtime constraints

- Primary delivery target: browser-playable Web export.
- Source control: GitHub; the Phase 6 release is hosted on Render. Phase 8's refreshed export is local until the user pushes and deploys it.
- Runtime must not fetch assets or call external services. Package chosen resources locally.

## Art and audio rules

- Prefer curated, non-generative artwork and a consistent visual style.
- Inspect preview, source, and per-asset license evidence before adoption.
- Record each shipped asset's creator, source, license, and attribution in `docs/asset_manifest.md`.
- Use human-composed, appropriately licensed audio. Do not use AI-generated music.

The first passage uses a restrained, flat winter illustration style drawn in project code. No third-party art assets are currently shipped; curated asset packs may be added only after preview, provenance, and per-asset license checks.

## Speedrun expansion

- Passage 1 is the introductory route; its exit transitions into Passage 2 without resetting the run clock. Passage 2 uses horizontal and vertical platforms that travel between fixed endpoints and repeat at a fixed duration.
- The run clock starts on first movement, continues after fall recovery and passage transitions, and freezes after Passage 2. An explicit restart returns to Passage 1 and clears elapsed time. Finish results show the combined run time and locally stored personal best.
- Dash unlocks once when the player touches the amber, “DASH” marker on Passage 1's second platform. Shift activates a horizontal dash in the player's facing direction, including in the air. It travels at 900 px/s for 0.18 seconds, suppresses gravity during the burst, and uses normal collision movement. A 0.65-second cooldown starts with each dash; falling and passage transitions preserve its remaining recharge, while an explicit restart locks dash again. Final completion stops player movement. The HUD reports locked, active, recharging, and ready states.
- Human-composed, appropriately licensed music is packaged locally: Cleyton Kauffman's CC0 “Through the Snow” loop is documented in `docs/asset_manifest.md`. AI-generated music is prohibited, and the game must not fetch assets or call external services. Music starts with a run; mute and volume controls are available in the HUD and save locally.
- Keep the game single-player and offline. Online leaderboards, accounts, and multiplayer are not requested.
- Develop each mechanic in its own phase with a failing acceptance test first, smallest implementation, automated regression suite, in-game playtest, and QA/acceptance documentation update.

## Phase 11 release state (2026-11-01)

The integrated local Web export passes the automated full-run and restart regression, GUT suite, headless scene launch, and packaging inspection. The player flow joins the clock, two passages, moving platforms, marked dash unlock/cooldown, local music, HUD/results, and restart lifecycle. Agent browser/gameplay and listening review were explicitly waived. The current export has not been deployed or played through by the user; supported-viewport traversal and deployed behavior remain unverified until user evidence is available.
