# Frozen Passage — Phase 7 Handoff

## Goal

Implement the speedrun clock and local run record foundation. Read `docs/game_design.md`, `docs/implementationPlan.md`, `docs/acceptance_criteria.md`, `docs/decisions.md`, `docs/enginerringPlan.md`, `docs/qa_report.md`, and this handoff. Inspect the current checkout and test/import state before editing.

## Completed baseline

- The original one-passage Godot Web game is deployed at `https://frozen-passage.onrender.com`.
- Render built commit `22f10ba` successfully; its page and required Web export assets returned HTTP 200. The user reports the deployed game works, but did not specify exact viewport sizes or traversal details.
- Existing behavior: move/jump, four-platform first passage, fall reset, exit completion, high-contrast HUD, 16:9 scaling.
- Existing GUT baseline: 11/11 tests, 28/28 assertions. Godot 4.7.2 stable, GUT 9.7.1, Godot MCP Toolkit 1.1.2.
- The local branch includes documentation commits that have not yet been pushed. Preserve this plan/handoff and the user's local work; the user handles pushes.

## Phase 7 scope

Only implement Phase 7 in `docs/implementationPlan.md` and the `SR-01` through `SR-03` criteria in `docs/acceptance_criteria.md`:

1. Run clock and finish-time display.
2. Fall preserves elapsed time; explicit run restart resets it.
3. Locally stored personal-best time, with no server or leaderboard.

Proposed semantics are first movement input starts the clock, completion freezes it, falls keep elapsed time, and explicit restart resets the run. Confirm these assumptions from the user if they differ; do not guess at materially different run rules.

Do not implement moving platforms, Passage 2, dash, or music in Phase 7. Dash unlock is still an open choice for Phase 9; the parent session asked the user to choose among a marked course point (recommended), fixed elapsed time, or dash from the start. Phase 7 and 8 can proceed without that answer.

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

SR-01 through SR-03 are backed by focused tests and a passing full regression suite; timer, fall, restart, and personal-best states have been inspected in-game; the Web export succeeds; QA/acceptance docs reflect evidence and remaining user browser checks.
