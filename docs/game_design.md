# Frozen Passage — Game Design

## Status

The original traversal slice and Phase 6 web deployment are complete according to the user's report that the live game works. The user has now requested a speedrun expansion; the following gameplay additions are planned and not implemented yet.

## Product goal

Create a small, polished game that players can run in a web browser. The planned art direction is a consistent winter environment built from curated, licensed resources.

## First playable loop (confirmed and implemented)

1. Start a short side-view level in a frozen landscape.
2. Move and jump across platforms and avoid falling.
3. Reach the exit to complete the level.
4. If the player falls below the level boundary, restart at the start.

The first slice intentionally excluded combat, collectibles, checkpoints, multiple maps, and online services. The new expansion supersedes the one-passage scope by adding a second passage and speedrun mechanics; online services and leaderboards remain out of scope.

## Controls

- Move left/right: arrow keys or A/D.
- Jump: Space, Up, or W while grounded.
- Proposed dash input after unlock: Shift. The exact unlock trigger is awaiting the user's selection; do not implement the dash phase until that decision is recorded.
- Keyboard is the first target. Controller support is not specified.

## Platform and runtime constraints

- Primary delivery target: browser-playable Web export.
- Source control: GitHub; planned hosting: Render. Deployment is deferred.
- Runtime must not fetch assets or call external services. Package chosen resources locally.

## Art and audio rules

- Prefer curated, non-generative artwork and a consistent visual style.
- Inspect preview, source, and per-asset license evidence before adoption.
- Record each shipped asset's creator, source, license, and attribution in `docs/asset_manifest.md`.
- Use human-composed, appropriately licensed audio. Do not use AI-generated music.

The first passage uses a restrained, flat winter illustration style drawn in project code. No third-party art assets are currently shipped; curated asset packs may be added only after preview, provenance, and per-asset license checks.

## Requested speedrun expansion (planned)

- Preserve the original passage as the introductory route and add a second passage built around moving platforms.
- Add a run clock, finish time, restart flow, and a local personal-best time. The proposed timing rule starts on the first movement input, freezes at the finish, continues after a fall reset, and resets on an explicit run restart.
- Introduce dash later in the course. The user asked that dash become available after some time; the exact rule (course marker, elapsed time, or available from the start) is not yet settled. The recommended design is to unlock it at a marked course point so the player can learn the first section before dash is available.
- Add locally packaged human-composed, appropriately licensed music. AI-generated music remains prohibited, and the running game must not fetch audio or call external services.
- Keep the game single-player and offline. Online leaderboards, accounts, and multiplayer are not requested.
- Develop each mechanic in its own phase with a failing acceptance test first, smallest implementation, automated regression suite, in-game playtest, and QA/acceptance documentation update.
