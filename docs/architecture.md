# Frozen Passage — Architecture

## Status

Phase 11 integrated release checks are complete for the local Web build. AudioManager owns the locally packaged music stream, playback lifecycle, and saved mute/volume preferences. The HUD exposes accessible mute/volume controls. The user waived agent-performed interactive testing; audibility and current browser traversal have not been reviewed.

## Runtime shape

- Godot 4.7.2 2D project, targeting web export first with the Compatibility renderer.
- Gameplay state and movement stay in gameplay components. UI observes signals and does not own game rules.
- Assets are local; the game has no runtime dependency on SpriteFetch, GitHub, Render, or another external service.

## Implemented scene/component responsibilities

- `Main` (`scenes/main.tscn`): owns the Level and HUD instances.
- `Level` (`scripts/level.gd`): builds the active passage, detects falls, transitions from Passage 1 to Passage 2, places the one-time dash unlock marker, completes the full run, owns run clock/best-time state, and emits lifecycle/passage signals. Exit-triggered course rebuilds are deferred until the physics query completes.
- `MovingPlatform` (`scripts/moving_platform.gd`): moves an `AnimatableBody2D` between configured endpoints at a fixed speed and travel duration, then repeats.
- `Player` (`scripts/player.gd`): owns left/right input, grounded jump, gravity, collision movement, spawn reset, a short horizontal platform-momentum carry on takeoff, and the unlocked dash burst/cooldown.
- `HUD` (`scripts/hud.gd`): listens for level signals and displays the active passage, run clock, dash unlock/cooldown state, and final results.
- `AudioManager` (`scripts/audio_manager.gd`): owns local music playback intent, end-of-stream looping, persisted mute/volume settings, and lifecycle responses to run start, explicit restart, and final completion. No gameplay decisions live here.

The winter level presentation is drawn in local GDScript using layered mountain silhouettes, snow caps, ice platform accents, a lantern exit, and a matching player illustration. Both passages reuse this presentation; moving platforms draw their own matching ice surface. No third-party art or audio has been added. The HUD uses high-contrast local style boxes and remains presentation-only; collision and traversal are owned by their gameplay nodes.

## Verification boundary

- GUT tests cover both passages, deterministic platform cycles, platform carry/jump-off, fall recovery, timer continuity, dash unlock/movement/collision/recharge, course progression, and final completion.
- Phase 10 lifecycle/configuration and packaged-stream GUT tests pass. The actual OGG resource is included in the Web PCK and the AudioStreamPlayer enters its playing state on run start. Subjective listening was waived by the user; the user will review the game link.
- Phase 11 integration GUT verifies a complete two-passage state flow and restart across timer, dash, HUD/results, and audio. This is deterministic component integration coverage, not an interactive traversal. Current export/browser review and deployment remain user-owned.

## Engine and test toolchain

- Godot 4.7.2 stable.
- GUT 9.7.1 included under `addons/gut`.
- Godot MCP Toolkit 1.1.2 included under `addons/godot_mcp_toolkit`; local bridge `@npgamedev/godot-mcp-server@1.1.2`.
