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

## Phase 6 current state

- Do not add gameplay systems; the confirmed traversal loop is complete. Keep runtime assets local and offline.
- The user selected `mayankjn99/caraxes`; local `main` is synchronized to pushed commit `22f10ba` and preserves the original README and MIT license.
- Render static site `frozen-passage` exists in **My Workspace** (`tea-d80bkebrjlhs73a68jgg`), at `https://frozen-passage.onrender.com`. Corrected deploy `dep-dbj7qj49v7es739bjaag` is live for commit `22f10ba`; HTTPS HEAD checks returned 200 for the page and all required assets.
- TDD fix: the URL regression check failed on the old TuxFamily URL, then passed using the official Godot download endpoint. Render's Linux import/export completed successfully.
- Still required: user verifies startup, HUD/route visibility at 960×540 and 640×360, and full keyboard traversal. Browser operations are user-performed; do not use Chrome or browser automation.
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
