# Frozen Passage — Phase 9 Handoff

## Goal

Implement dash progression and platforming against the two-passage course. Read `docs/game_design.md`, `docs/architecture.md`, `docs/implementationPlan.md`, `docs/acceptance_criteria.md`, `docs/decisions.md`, `docs/enginerringPlan.md`, `docs/qa_report.md`, and this handoff before editing.

## Current baseline

- Phase 8 adds Passage 2 with deterministic horizontal and vertical moving platforms. Passage 1 exit transitions without resetting the run; Passage 2 final completion records the full run. Falls in Passage 2 return to its spawn and preserve elapsed time.
- Moving-platform travel, platform carry/jump-off momentum, passage transition/final completion, and fall recovery are covered by GUT. Passage HUD accessibility includes contrast and 640×360 effective size checks.
- Phase 8 verification: focused GUT 5/5 tests, 27 assertions; focused HUD 1/1 test, 15 assertions; focused timer/results 4/4 tests, 22 assertions; full GUT 20/20 tests, 82 assertions; main-scene smoke launch and Web export passed. See `docs/qa_report.md` for commands and warnings.
- The Phase 8 Web export is in `build/web`. The user waived interactive browser/in-game testing and will review the game link. Do not perform or wait for interactive testing.
- Dash unlock choice is settled: unlock at a clearly marked course point. Proposed input is Shift, from `docs/game_design.md`.
- Do not push to GitHub; the user handles pushes. Preserve the existing uncommitted Phase 7/8 changes and unrelated edits.

## Phase 9 scope

1. Test locked dash input and a one-time unlock at a clearly marked course point.
2. Define dash direction, duration, collision behavior, and recharge/cooldown through focused red/green GUT tests.
3. Integrate dash with moving-platform gaps, falls, run restart, and final completion without bypassing course progression.

Do not add music or online services in this phase. Follow red/green TDD per subfeature, then run focused and full GUT suites, main-scene smoke, Web export, and update acceptance criteria/QA with actual evidence. Interactive game testing remains waived.

## Commands

```sh
GODOT_MCP_RUNTIME=0 godot --headless --editor --path . --import --quit
GODOT_MCP_RUNTIME=0 godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir=res://test/unit -gexit
GODOT_MCP_RUNTIME=0 godot --headless --path . --quit-after 2
GODOT_MCP_RUNTIME=0 bash scripts/build_web.sh
```
