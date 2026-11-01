# Frozen Passage — Acceptance Criteria

## Phase 1: Requirements and project foundation

| ID | Requirement | Verification | Status |
|---|---|---|---|
| P1-01 | The Godot project opens without parse or import errors. | Open in editor; inspect debugger/output. | Passed — editor import succeeded; MCP scene inspection succeeded. Godot reported host certificate/user-data warnings only. |
| P1-02 | The main scene launches locally. | Launch via Godot CLI/editor; observe runtime output. | Passed — headless smoke run and MCP game start/runtime log check succeeded. |
| P1-03 | The browser export starts in the selected supported browser. | Export Web build, serve it locally over HTTP, and load it in a browser. | Passed — Chrome headless with SwiftShader loaded WebAssembly from localhost and rendered the main scene canvas. |
| P1-04 | The configured game-testing MCP can inspect the project, launch the game, and report runtime status. | MCP read-only probe followed by a controlled playtest. | Passed — bridge authenticated, inspected/launched the scene, captured screenshots, and read logs without game errors. |
| P1-05 | Project instructions document exact commands for import, test, run, and web export. | Follow commands from the project root. | Passed — commands documented and used for import, GUT, smoke launch, Web export, and local serving. |

## Phase 2: First playable traversal slice

| ID | Requirement | Verification | Status |
|---|---|---|---|
| FP-01 | Player can move left and right on a flat test floor using arrows or A/D. | Automated control test and live keyboard playtest. | Passed — GUT verified left and right velocity; Godot MCP action input moved the player from spawn x=80 to x≈206. Browser CDP keyboard playthrough reached the exit. |
| FP-02 | Player can jump using Space, Up, or W while grounded. | Unit/integration test and live playtest. | Passed — GUT verified upward launch from the floor and no jump reset while airborne; live Godot and browser keyboard playthroughs included jump input. |
| FP-03 | Player collides with platforms and cannot pass through the floor. | Physics integration test and live playtest. | Passed — after 45 physics frames player remained grounded at y≈431 on the y=450 platform; browser keyboard playthrough crossed the platform gaps. |
| FP-04 | Falling below the level restarts the player at the start. | Trigger fall in test and live playtest; assert spawn position/state. | Passed — GUT moved the player below y=650 and confirmed return to (80,430) with velocity cleared. Godot MCP repeated the live fall trigger and read back (80,431) after the next physics step. |
| FP-05 | Reaching the exit produces an unambiguous completion state. | Trigger goal in test and live playtest; inspect completion UI/state. | Passed — GUT confirmed the exit Area2D emitted completion and showed the HUD; browser keyboard playthrough displayed “Passage complete!”. |
| FP-06 | The same loop is usable in the web export. | Play through the export in browser with keyboard input. | Passed — exported no-threads Web build served over HTTP; Chrome headless DevTools sent D/Space keyboard events through the platform route to the visible completion state. Screenshot: [`phase2-web-playtest.png`](qa/phase2-web-playtest.png). |

## Phase 3: Gameplay systems scope review

| ID | Requirement | Verification | Status |
|---|---|---|---|
| P3-01 | Add gameplay systems only when required by the confirmed brief. | Review `docs/game_design.md`, Phase 2 acceptance criteria, and current gameplay implementation. | Passed — the confirmed loop is complete with movement, jump, platform traversal, fall reset, and exit completion. No additional gameplay system is required. |
| P3-02 | Keep optional mechanics out of the build unless confirmed. | Inspect current scenes/scripts and the confirmed design exclusions. | Passed — no health, hazards, enemies, combat, checkpoints, collectibles, multiple-map transitions, or online systems were added. Their omission is intentional. |
| P3-03 | Reconfirm the previous phase gate before closing Phase 3. | Run the documented project import, GUT suite, and main-scene smoke command. | Passed — import exited 0; GUT 9/9 tests and 16/16 assertions passed; smoke run exited 0. Existing Phase 2 browser/MCP evidence is retained in `docs/qa_report.md`; it was not repeated in this Phase 3 session. |

## Phase 4: Winter level presentation and assets

| ID | Requirement | Verification | Status |
|---|---|---|---|
| P4-01 | Present a coherent winter level while preserving the traversal loop. | Inspect the live Godot scene and run the existing traversal suite. | Passed — layered snowy ridges, ice platforms, warm goal beacon, and matching mountaineer illustration are visible in [`phase4-winter-presentation.png`](qa/phase4-winter-presentation.png); GUT remains 9/9 tests and 16/16 assertions. |
| P4-02 | Every adopted asset is local and has verified creator, source, per-asset license, attribution, checksum, dimensions, and preview evidence. | Review `docs/asset_manifest.md`. | Passed — no external assets were adopted; presentation is drawn by local GDScript. SpriteFetch winter searches did not return a suitable candidate. Kenney's source page confirms its winter pack is CC0, but no file was adopted because its preview, dimensions, and checksum were not available to verify in-session. |
| P4-03 | The project imports, runs, and exports without traversal regressions. | Import, GUT, headless launch, and Web export commands. | Passed — import, launch, and Web export exited 0; GUT 9/9 tests and 16/16 assertions passed. Current browser playthrough could not be repeated because the environment denied binding the local HTTP server (`PermissionError: Operation not permitted`). Prior Phase 2 browser evidence remains valid for the unchanged gameplay loop. |

## Phase 5: UI, accessibility, and polish

| ID | Requirement | Verification | Status |
|---|---|---|---|
| P5-01 | Existing control instructions and completion feedback have readable, high-contrast text against a distinct backing; text remains at least 16 px at 640×360. | HUD test checks contrast and effective text size at 640×360; inspect Godot MCP at base size and browser at supported sizes. | Passed — automated checks and Godot MCP captures confirm 24 px base instructions and 32 px completion text with 14.64:1 contrast. At 640×360, effective sizes are 16 px and 21.3 px. The user confirmed the text is legible in Chrome at 640×360 and 960×540. Captures: [HUD](qa/phase5-godot-hud-current.png), [completion](qa/phase5-godot-completion-current.png). |
| P5-02 | Existing HUD information and the full traversal route remain visible at representative browser sizes while preserving the scene aspect ratio. | Automated test requires canvas item scaling with kept aspect; user verifies exported browser at 960×540 and 640×360. | Passed — automated stretch/aspect regression passes; the user confirmed the full route and HUD work at both browser sizes. |

## Phase 6: Release and deployment

| ID | Requirement | Verification | Status |
|---|---|---|---|
| P6-01 | Render can reproducibly build and publish the Godot Web export as a static site. | Validate `render.yaml`; run `bash scripts/build_web.sh`; confirm required published files in a Render build. | Passed — the corrected Godot 4.7.2 Linux build and Web export completed on Render; deploy `dep-dbj7qj49v7es739bjaag` is live and all four required assets are served. |
| P6-02 | A clean checkout builds from the selected pushed GitHub branch and Render publishes the expected files. | Build from a clean clone; inspect the Render build and published files. | Passed — pushed commit `22f10ba` built successfully on Render; HTML, JS, WASM, and PCK assets return HTTP 200. |
| P6-03 | The deployed Web export starts, displays the route/HUD at supported sizes, and supports a complete keyboard traversal. | User verifies the deployed HTTPS URL at 960×540 and 640×360 and completes the route. | Partially verified — the user reports that the live game works at https://frozen-passage.onrender.com. The user did not specify tested viewport sizes or explicitly report a complete keyboard traversal, so the full matrix remains unverified. Browser operation remains user-performed. |

## Speedrun expansion acceptance criteria (planned)

The user requested a speedrun expansion with more passages, moving platforms, a later dash unlock, and music. These criteria are planned, not implemented; each row must follow the documented red/green/playtest/record loop.

| ID | Requirement | Verification | Status |
|---|---|---|---|
| SR-01 | A run clock starts at the defined run start, advances while playing, freezes at final completion, and resets for a new attempt. | GUT clock/lifecycle tests plus in-game timer observation. | Planned — proposed start is first movement input; confirm in Phase 7 before implementation. |
| SR-02 | Falling returns the player to the spawn without erasing elapsed run time; explicit restart resets the run. | GUT fall/restart integration tests and in-game fall/restart playtest. | Planned — proposed behavior; confirm during Phase 7. |
| SR-03 | Finish results show the run time and a locally stored personal best; no network leaderboard or account is required. | GUT result/best-time tests, persistence test, and in-game completion check. | Planned — local `user://` storage only. |
| SR-04 | Passage 2 is reachable after the introductory passage and includes moving platforms with predictable, readable motion. | GUT platform-cycle and passage-transition tests; repeatable in-game route playtest. | Planned — Phase 8. |
| SR-05 | The player can stand on and be carried by moving platforms, jump off, collide correctly, and recover from falls. | GUT physics integration cases plus Godot MCP playtest. | Planned — Phase 8. |
| SR-06 | Dash input has no effect while locked and enables only after the user-selected unlock event. | GUT locked/unlocked state tests and in-game unlock cue check. | Planned — unlock event needs user selection before Phase 9. |
| SR-07 | Dash movement has defined direction, duration, collision behavior, and recharge rules and cannot bypass course completion. | Focused GUT movement/collision tests, regression suite, and course playtest. | Planned — Phase 9; exact behavior to be detailed before implementation. |
| SR-08 | Music is human-composed, appropriately licensed, locally packaged, and plays without runtime network access. | Review asset manifest and checksum; Web export playback verification. | Planned — Phase 10; AI-generated music is not allowed by project decisions. |
| SR-09 | Music controls and playback lifecycle behave consistently through run, restart, and completion. | Automated audio state/config tests and in-game listening check. | Planned — Phase 10. |
| SR-10 | Integrated speedrun flow survives full playthroughs in the Web build at supported viewport sizes. | Full GUT suite, Web export/Render checks, and user playthrough of both passages. | Planned — Phase 11. |
