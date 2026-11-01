# Frozen Passage release notes

## Integrated speedrun release — 2026-11-01

- Combines Passage 1 and Passage 2 into one timed run, including deterministic moving platforms, a marked dash unlock with cooldown, local CC0 winter music, passage/status HUD, and final time/personal-best results.
- Fall recovery preserves the active run. Restart returns to Passage 1, clears the timer and result overlay, relocks dash, and waits for first movement before starting the clock and music again.
- The local Web build passed editor import, focused and full GUT, headless scene smoke, Web export, and PCK resource inspection. GUT result: 33/33 tests and 197/197 assertions.
- The user waived agent browser/gameplay and listening review. The user has not yet reported traversal at 960×540 or 640×360 on this build. No push or deployment was performed; deployed behavior is not claimed.
- Godot emitted existing host certificate, `user://` log, MCP registry/token/port, and editor-settings write warnings during checks. The relevant commands exited successfully.
