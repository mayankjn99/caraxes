# Frozen Passage — Phase 7 Handoff

## Goal

Implement the speedrun clock and local run record foundation. Read `docs/game_design.md`, `docs/implementationPlan.md`, `docs/acceptance_criteria.md`, `docs/decisions.md`, `docs/enginerringPlan.md`, `docs/qa_report.md`, and this handoff. Inspect the current checkout and test/import state before editing.

## Completed baseline

- The original one-passage Godot Web game is deployed at `https://frozen-passage.onrender.com`.
- Render built commit `22f10ba` successfully; its page and required Web export assets returned HTTP 200. The user reports the deployed game works, but did not specify exact viewport sizes or traversal details.
- Existing behavior: move/jump, four-platform first passage, fall reset, exit completion, high-contrast HUD, 16:9 scaling.
- Existing GUT baseline: 11/11 tests, 28/28 assertions. Godot 4.7.2 stable, GUT 9.7.1, Godot MCP Toolkit 1.1.2.
- Phase 7 implementation is present in the working tree: timer starts on movement, continues across falls, resets on explicit restart, and freezes at completion; local personal best persists and the HUD includes run/best time.
- Verification: focused tests 4/4 and 21 assertions; full GUT suite 14/14 and 45 assertions; Web export produced all expected files. Godot runtime MCP tools were unavailable in the latest session, so interactive HUD/timer inspection remains open.
- The local branch includes documentation commits that have not yet been pushed. Preserve this plan/handoff and the user's local work; the user handles pushes.

## Phase 7 scope

Only implement Phase 7 in `docs/implementationPlan.md` and the `SR-01` through `SR-03` criteria in `docs/acceptance_criteria.md`:

1. Run clock and finish-time display.
2. Fall preserves elapsed time; explicit run restart resets it.
3. Locally stored personal-best time, with no server or leaderboard.

Confirmed semantics are first movement input starts the clock, completion freezes it, falls keep elapsed time, and explicit restart resets the run. The user also selected dash unlock at a clearly marked course point for Phase 9.

Do not implement moving platforms, Passage 2, dash, or music in Phase 7. Phase 8 proceeds with Passage 2 and moving platforms; Phase 9 uses the marked course point for dash unlock.

## Required workflow and verification

For each Phase 7 subfeature, write a failing test, run it and confirm the intended red result, implement the smallest change, run the focused test and full GUT suite, launch/inspect the game through Godot MCP when available, run the Web build, then record evidence in `docs/qa_report.md` and update acceptance status. Do not claim a browser playthrough; the user has reserved Chrome/browser operation for themselves.

Documented commands:

```sh
GODOT_MCP_RUNTIME=0 godot --headless --editor --path . --import --quit
GODOT_MCP_RUNTIME=0 godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir=res://test/unit -gexit
GODOT_MCP_RUNTIME=0 godot --headless --path . --quit-after 2
GODOT_MCP_RUNTIME=0 bash scripts/build_web.sh
```

## Exit gate

Automated evidence and Web export pass. User waived manual product testing and requested code generation phases continue with automated tests. Proceed to Phase 8; the user will review the game link and provide feedback.
