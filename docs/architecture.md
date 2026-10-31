# Frozen Passage — Architecture

## Status

Phase 2 traversal slice is implemented. Keep each component focused as gameplay expands.

## Runtime shape

- Godot 4.7.2 2D project, targeting web export first with the Compatibility renderer.
- Gameplay state and movement stay in gameplay components. UI observes signals and does not own game rules.
- Assets are local; the game has no runtime dependency on SpriteFetch, GitHub, Render, or another external service.

## Implemented scene/component responsibilities

- `Main` (`scenes/main.tscn`): owns the Level and HUD instances.
- `Level` (`scripts/level.gd`): creates the short platform route and exit, detects falls, owns completion state, and emits `level_completed` / `level_restarted`.
- `Player` (`scripts/player.gd`): owns left/right input, grounded jump, gravity, collision movement, and spawn reset.
- `HUD` (`scripts/hud.gd`): listens for level signals and displays instructions or completion feedback.

The winter level presentation is drawn in local GDScript using layered mountain silhouettes, snow caps, ice platform accents, a lantern exit, and a matching player illustration. No third-party art or audio has been added. The existing HUD uses high-contrast local style boxes and remains presentation-only; collision and traversal are owned by their existing gameplay nodes.

## Verification boundary

- GUT tests cover controls, jump eligibility, physics landing, fall reset, and completion feedback.
- Godot MCP verifies launch, runtime input, scene state, screenshot, and logs.
- The Web export is served over HTTP and played through in headless Chrome using keyboard events.

## Engine and test toolchain

- Godot 4.7.2 stable.
- GUT 9.7.1 included under `addons/gut`.
- Godot MCP Toolkit 1.1.2 included under `addons/godot_mcp_toolkit`; local bridge `@npgamedev/godot-mcp-server@1.1.2`.
