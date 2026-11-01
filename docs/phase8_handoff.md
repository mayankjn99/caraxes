# Frozen Passage — Phase 8 Handoff

## Goal

Add a second speedrun passage built around deterministic moving platforms, following `docs/implementationPlan.md` Phase 8 and SR-04/SR-05 in `docs/acceptance_criteria.md`.

## Current state

- Phase 7 clock starts on first movement, continues through falls, resets on explicit restart, and freezes on completion.
- Personal best persists locally and improves only on a faster finish. HUD displays elapsed time and completion run/best times.
- Phase 7 verification: focused GUT 4/4 tests, 21 assertions; full GUT 14/14, 45 assertions; Web export produced `index.html`, `index.js`, `index.wasm`, `index.pck`.
- User explicitly waived interactive product testing on 2026-11-01 and will review the game link and provide feedback. Continue code generation with automated tests and Web export checks; do not wait for interactive verification.
- Dash unlock is selected for Phase 9: unlock at a clearly marked course point.
- Do not push to GitHub; user handles pushes. Work in the existing local checkout and preserve unrelated changes.

## Phase 8 scope

1. Add deterministic moving-platform motion with tested endpoints, travel timing, and repeat behavior.
2. Ensure player rides/collides with moving platforms, jumps off correctly, and falls recover without losing the run timer.
3. Add a passage transition after Passage 1 and a second course that completes the run without resetting the clock or best-time semantics.
4. Keep both passages reachable and controls/HUD readable in the exported Web build.

Do not add dash or music in this phase. Use red/green TDD for every subfeature: focused failing GUT test, smallest implementation, focused and full GUT suites, then Web export. Update acceptance criteria and `docs/qa_report.md` with actual results. Do not add manual browser or interactive product testing to the required gate.

## Commands

```sh
GODOT_MCP_RUNTIME=0 godot --headless --editor --path . --import --quit
GODOT_MCP_RUNTIME=0 godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir=res://test/unit -gexit
GODOT_MCP_RUNTIME=0 bash scripts/build_web.sh
```

Godot `user://` writes may require elevated execution in this environment. The user handles browser review and GitHub pushes.
