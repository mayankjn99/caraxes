# Frozen Passage release notes

## Integrated speedrun release — 2026-11-01

- Combines Passage 1 and Passage 2 into one timed run, including deterministic moving platforms, a marked dash unlock with cooldown, local CC0 winter music, passage/status HUD, and final time/personal-best results.
- Fall recovery preserves the active run. Restart returns to Passage 1, clears the timer and result overlay, relocks dash, and waits for first movement before starting the clock and music again.
- The local Web build passed editor import, focused and full GUT, headless scene smoke, Web export, and PCK resource inspection. GUT result: 33/33 tests and 197/197 assertions.
- Commit `82370a7` was pushed by the user and deployed to Render; the build and deploy succeeded. The user waived agent browser/gameplay and listening review and has not yet reported traversal at 960×540 or 640×360 on this build. Deployment is confirmed, but gameplay behavior in the deployed browser remains for user review.
- Godot emitted existing host certificate, `user://` log, MCP registry/token/port, and editor-settings write warnings during checks. The relevant commands exited successfully.

## Passage 2 stale-exit fix — deployed — 2026-11-01

- Fixed stale exit callbacks incorrectly completing Passage 2 at its spawn. Exit events now carry their course generation and source Area2D; the deferred handler confirms the player still overlaps that same exit before completing the run.
- Added red/green stale-callback, false Passage 2 exit, and real Passage 1 exit regressions. Focused GUT passed 2 tests and 7 assertions; Phase 8 route tests passed 8/8 with 38 assertions; full GUT passed 36/36 tests and 208 assertions. Editor import, headless smoke, and Web export passed.
- The user reported the failure with a screenshot. Commit `8dcd792` was pushed to GitHub and deployed to Render. The agent did not interactively test the game; user playthrough remains pending.
