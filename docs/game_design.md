# Frozen Passage — Game Design

## Status

Phase 2 first playable traversal slice is complete. Optional mechanics remain out of scope unless later requested.

## Product goal

Create a small, polished game that players can run in a web browser. The planned art direction is a consistent winter environment built from curated, licensed resources.

## First playable loop (confirmed and implemented)

1. Start a short side-view level in a frozen landscape.
2. Move and jump across platforms and avoid falling.
3. Reach the exit to complete the level.
4. If the player falls below the level boundary, restart at the start.

The slice excludes combat, collectibles, checkpoints, multiple maps, and online services.

## Controls

- Move left/right: arrow keys or A/D.
- Jump: Space, Up, or W while grounded.
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

The first level uses a restrained, flat winter illustration style drawn in project code. Audio is intentionally absent in this short traversal slice. No third-party assets are currently shipped; curated asset packs may be added later only after preview, provenance, and per-asset license checks.
