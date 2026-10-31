# Frozen Passage — Phase 6 Handoff

## Goal

Begin Phase 6 — release and deployment — in a fresh session. Read `docs/implementationPlan.md`, `docs/acceptance_criteria.md`, `docs/qa_report.md`, `docs/enginerringPlan.md`, `docs/assetsGuide.md`, `docs/game_design.md`, `docs/architecture.md`, `docs/asset_manifest.md`, and this handoff. Inspect the current working tree and verify the Phase 5 gate before changing files.

## Completed phase

Phase 5 is complete. The HUD instructions use 24 px type on a dark backing; completion uses 32 px type on a matching backing. Automated contrast and effective-size checks pass. The project uses `canvas_items` stretch with `keep` aspect so the full 960×540 scene scales to smaller 16:9 browser viewports. The user confirmed the route and HUD work at 960×540 and 640×360. Browser screenshots were not collected; Godot MCP captures for the HUD and completion states are in `docs/qa/phase5-godot-hud-current.png` and `docs/qa/phase5-godot-completion-current.png`.

## Phase 5 verification

- `GODOT_MCP_RUNTIME=0 godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir= -gtest=res://test/unit/test_viewport_scaling.gd -gexit` — 1/1 test, 2/2 assertions passed.
- `GODOT_MCP_RUNTIME=0 godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir= -gtest=res://test/unit/test_hud_accessibility.gd -gexit` — 1/1 test, 10/10 assertions passed.
- `GODOT_MCP_RUNTIME=0 godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir=res://test/unit -gexit` — 11/11 tests, 28/28 assertions passed.
- `GODOT_MCP_RUNTIME=0 godot --headless --path . --quit-after 2` — exit 0.
- `GODOT_MCP_RUNTIME=0 godot --headless --path . --export-release Web build/web/index.html` — exit 0.
- Godot MCP launched the main scene, captured the current HUD and completion states at 958×538, and reported no runtime errors. Screenshots are recorded above.
- The user manually confirmed the exported browser build at 960×540 and 640×360. This is user-reported verification; no browser screenshots are stored.

Godot may still print host macOS certificate, `user://` log, MCP registry/port, and editor-settings write warnings. See `docs/qa_report.md`; tested commands exited successfully.

## Phase 6 scope and constraints

Prepare the GitHub repository and Render static-site deployment for the existing Godot Web export. Verify a clean-checkout build, published files, browser startup, and a full traversal playthrough on the deployed URL. Update `docs/deployment.md` and the QA scorecard with evidence and limitations.

- Do not add gameplay systems; the confirmed loop is complete.
- Keep runtime assets local and offline.
- The workspace has no Git commit or GitHub remote yet. Confirm repository/remote expectations in the fresh Phase 6 session before creating or publishing anything.
- The connected GitHub search did not identify a Frozen Passage repository; this local checkout still has no remote. The intended GitHub owner, repository name, and visibility remain to be confirmed before creating or publishing a repository.
- Render currently has no selected workspace. Workspace discovery returned `My Workspace`; the Render integration requires the user to confirm which workspace to use before any resource operation.
- No deployment or remote setup was started in this Phase 5 session.
- Current toolchain: Godot 4.7.2 stable, GUT 9.7.1, Godot MCP Toolkit 1.1.2.

## Relevant files

- `project.godot`
- `export_presets.cfg`
- `scenes/main.tscn`
- `scripts/hud.gd`, `scripts/level.gd`, `scripts/player.gd`
- `test/unit/test_hud_accessibility.gd`
- `test/unit/test_viewport_scaling.gd`
- `docs/acceptance_criteria.md`
- `docs/qa_report.md`
- `docs/deployment.md` (create during Phase 6)
