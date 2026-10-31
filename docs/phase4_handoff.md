# Frozen Passage — Phase 4 Handoff

## Goal

Begin Phase 4 — Levels, art, and audio — in a fresh session. First read `docs/implementationPlan.md`, `docs/acceptance_criteria.md`, `docs/qa_report.md`, `docs/enginerringPlan.md`, `docs/assetsGuide.md`, `docs/game_design.md`, `docs/architecture.md`, `docs/asset_manifest.md`, and this handoff. Inspect the working tree and verify the recorded Phase 3 gate before changing files.

## Completed phases

- Phase 1 established the confirmed brief and Godot/Web project foundation.
- Phase 2 implemented and verified the short traversal loop: move, jump, cross platforms, reset after falling, and finish at the exit. The acceptance criteria and QA report contain GUT, Godot MCP, and browser playthrough evidence.
- Phase 3 is intentionally complete without additional gameplay systems. The confirmed brief requires no health, hazards, enemies, combat, checkpoints, collectibles, multiple maps, or online services. No runtime code was changed in Phase 3.
- In the Phase 3 session, `godot --headless --editor --path . --import --quit` exited 0; the documented GUT command passed 9/9 tests and 16/16 assertions; and `GODOT_MCP_RUNTIME=0 godot --headless --path . --quit-after 2` exited 0. The earlier MCP and browser checks were carried forward, not repeated.

## Phase 4 scope

Develop the winter level presentation and add selected, curated local art/audio assets only as required by the confirmed product goal. Follow `docs/assetsGuide.md` and `docs/enginerringPlan.md`: inspect previews, verify per-asset license and attribution, store assets locally, and update `docs/asset_manifest.md`. Do not use generative artwork or music. Preserve the existing traversal behavior and its component responsibilities. Do not add gameplay mechanics unless the user confirms a requirement.

## Exit gate

The game has a coherent visual/audio style; every shipped asset is local and has source, creator, license, attribution (when required), and checksum recorded in the manifest; the scene is inspected in Godot; relevant tests and runtime checks pass; and outcomes or blockers are recorded in `docs/qa_report.md` and `docs/acceptance_criteria.md`.

## Relevant files

- `scenes/main.tscn`
- `scripts/level.gd`
- `scripts/player.gd`
- `scripts/hud.gd`
- `test/unit/test_traversal.gd`
- `docs/game_design.md`
- `docs/architecture.md`
- `docs/acceptance_criteria.md`
- `docs/qa_report.md`
- `docs/assetsGuide.md`
- `docs/asset_manifest.md`

## Constraints and known limitations

- Godot 4.7.2, GUT 9.7.1, and Godot MCP Toolkit 1.1.2 are the local baseline.
- Keep runtime resources local; do not add external runtime calls.
- Godot CLI may report host macOS certificate and out-of-workspace user-data/MCP registry/editor-settings write warnings. See `docs/qa_report.md`; recorded commands still exited successfully.
- Phase 2 browser evidence used headless Chrome with SwiftShader. Interactive browser testing and additional browser coverage remain open.
- No Git commit or GitHub remote exists; Render deployment remains deferred to Phase 6.

## Phase boundary

Complete and document Phase 4's gate, then prepare a concise Phase 5 handoff. Do not begin Phase 5 in the Phase 4 session.
