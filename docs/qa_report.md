# Frozen Passage — QA Report

## Current deployment — 2026-11-01

- GitHub `main` is at `8dcd79279171601201986825c848cb8dd1fee729` (`Guard Passage 2 against stale exit overlap`).
- Render static site `frozen-passage` (`srv-dbj7lugae00c73deh5cg`) is live on commit `8dcd792` (`dep-dbjh7fgu01pc73ff7png`); the build and deploy completed successfully at 2026-11-01 10:27:14 UTC.
- Public URL: https://frozen-passage.onrender.com. No browser interaction, game playthrough, or audio listening was performed by the agent, per the user's instruction. User review is still needed to confirm the deployed gameplay experience.
- The pending user review steps are in [`user_review_checklist.md`](user_review_checklist.md).

## Passage 2 completion bug fix — deployed — 2026-11-01

- User report and screenshot showed the HUD on Passage 2 with the final “Run complete!” overlay while the player was still at the Passage 2 spawn; the player could not continue.
- Regression TDD: `test_stale_passage_one_exit_cannot_finish_passage_two` failed before the fix because a queued signal from Passage 1's old exit completed the run after a transition. A second regression, `test_passage_two_exit_does_not_complete_from_spawn_on_stale_overlap_signal`, failed when the current Passage 2 exit emitted a delayed event while the player was still at spawn.
- Fix: each rebuilt course advances a generation counter. Exit callbacks capture that generation and the specific exit. The deferred handler ignores callbacks from replaced courses and verifies that the player still overlaps the same exit before completing.
- Both focused regressions pass (2 tests, 7 assertions). Phase 8 route tests, including a real physics-triggered Passage 1 exit, pass 8/8 tests and 38 assertions. Full GUT: 36/36 tests, 208 assertions passed.
- Editor import, headless main-scene smoke, and `GODOT_MCP_RUNTIME=0 bash scripts/build_web.sh` all exited 0. Existing Godot macOS certificate, MCP registry/port, and editor-settings write warnings remain.
- The user pushed the fix, and it is deployed on Render as commit `8dcd792`. No interactive game testing was performed, per the user's instruction; user playthrough remains pending.

## Phase 10 automated results — 2026-11-01

- Asset TDD/provenance: the first OpenGameArt candidate “Wintery loop” by Emma_MA was rejected when its file could not be retrieved and hashed. The second candidate, “Through the Snow” by Cleyton Kauffman, was downloaded from [its OpenGameArt source page](https://opengameart.org/content/snow-theme). The page marks it CC0 and describes a seamless 24-second winter loop with optional attribution. The included readme also confirms creator and CC0/public-domain terms. Shipped OGG hash and source archive hash are in `docs/asset_manifest.md`.
- Packaged-track test TDD: new acceptance assertions initially failed because no local stream was assigned and the HUD reported “No music”. The local OGG is now a preloaded `AudioStreamOggVorbis`; AudioManager assigns it to the player, and the HUD enables controls. The green assertions verify resource type/assignment, control state, and `AudioStreamPlayer.playing` when a run starts.
- Audio lifecycle/settings: AudioManager starts on first movement, keeps music through falls, stops on explicit restart and final completion, restarts after a stream ends, and saves mute/volume preferences. HUD controls are keyboard-accessible and sized for 640×360.
- Focused Phase 10 audio GUT: 4/4 tests and 34 assertions passed. This includes test-only silent fixtures for lifecycle/restart behavior; one test additionally verifies the actual bundled OGG resource is assigned and playback is requested. No subjective listening is claimed.
- Full GUT regression: 32/32 tests and 171 assertions passed.
- Main-scene headless smoke launch: `GODOT_MCP_RUNTIME=0 godot --headless --path . --quit-after 2` exited 0.
- Web export: `GODOT_MCP_RUNTIME=0 bash scripts/build_web.sh` exited 0. Required HTML, JS, WASM, and PCK files are non-empty; PCK strings confirm the `res://assets/audio/through_the_snow.ogg` source and imported Ogg resource are included.
- `git diff --check` passed before the final documentation update. Godot emitted the known macOS certificate, `user://` log-write, and editor/MCP registry/settings warnings.
- The user waived interactive browser/in-game testing. No browser or live game testing was performed and no listening claim is made. No push or deployment was performed; the user handles GitHub pushes.

## Phase 9 automated results — 2026-11-01

- Red/green GUT: initial unlock test failed because Player had no dash action/unlock state or course marker; it passed after adding locked input handling, the Passage 1 marker, one-time unlock signal, and HUD cue (1/1 test, 8 assertions).
- Red/green GUT: the dash-profile test failed because deterministic dash timing/status methods were missing; it passed with facing-direction movement at 900 px/s, a 0.18-second burst, and a 0.65-second cooldown (2/2 focused tests, 19 assertions at that step).
- Red/green GUT: final completion left an active dash moving at 900 px/s; final completion now clears velocity and disables player input (3/3 focused tests, 25 assertions at that step).
- Red/green GUT: fall reset cleared cooldown and explicit restart left a stale “Dash ready” HUD cue. Falls now preserve cooldown; explicit restart relocks dash, and HUD state follows the run (4/4 focused tests, 30 assertions at that step).
- Red/green GUT: a real dash through Passage 1's exit rebuilt collision nodes during physics flushing and could immediately finish the run. Exit completion is now deferred until the physics query completes; the route test passes without physics-server errors. The air-gap traversal, wall-collision, Shift binding, marker contact/one-time signal, and HUD recharge tests also pass.
- Final focused Phase 9 GUT: 8/8 tests, 50 assertions. Focused HUD accessibility: 1/1 test, 20 assertions; dash status retains 14.64:1 text contrast and 16 px effective size at 640×360.
- Editor import: `GODOT_MCP_RUNTIME=0 godot --headless --editor --path . --import --quit` exited 0.
- Phase 7–9 GUT regression suite (explicit list): 28/28 tests, 137 assertions.
- Full current workspace GUT suite at the Phase 10 checkpoint: 31/31 tests, 165 assertions.
- Main-scene smoke launch: exit code 0.
- `GODOT_MCP_RUNTIME=0 bash scripts/build_web.sh`: exit code 0; the Web export produced non-empty `index.html` (5,301 bytes), `index.js` (279,815 bytes), `index.wasm` (39,514,754 bytes), and `index.pck` (1,602,608 bytes).
- `git diff --check`: passed.
- Interactive browser/in-game testing was waived by the user (2026-11-01). No browser or live game testing was performed. No push or deployment was performed; the user handles GitHub pushes.

## Phase 7 automated results — 2026-11-01

- Focused run-clock GUT tests: 3/3 passed, 17 assertions. Covers first movement start, freeze at completion, fall continuity, explicit restart, personal-best comparison, and persistence in a fresh game instance. The test required approved access to Godot's `user://` data directory.
- Full GUT suite: 14/14 passed, 45 assertions (same user-data access).
- Web export: completed with non-empty `build/web/index.html`, `index.js`, `index.wasm`, and `index.pck`.
- Interactive timer/completion HUD inspection waived by user (2026-11-01); user will open the link and provide feedback.

## Phase 6 deployment history

Phase 6 — release and deployment. GitHub `main` includes commit `22f10ba`, which fixes the Linux export-template URL. The first Render build failed on the old TuxFamily URL; the fix passed a red/green URL regression check, the local GUT suite (11/11 tests, 28/28 assertions), smoke launch, and Web export. Render's second deployment built the Linux Web export and is live. HTTPS HEAD checks returned 200 for the root, HTML, JS, WASM, and PCK assets; WASM uses `application/wasm`. The user reports that the live game works, without specifying the tested sizes or full traversal; those details remain unverified. No browser was opened or controlled in this session. Prior phase history and Phase 4 presentation/asset notes follow.

## TDD record

| Subfeature | Red result | Change | Green/verification result |
|---|---|---|---|
| Player movement and jump eligibility | Initial GUT tests failed because the scaffold did not contain `Level/Player`. | Added `Player` physics and input handling with configurable speed, jump speed, and gravity. | GUT assertions pass for rightward velocity, grounded jump, and airborne jump rejection. Live Godot MCP input moved the player from x=80 to x≈206. |
| Fall reset | Initial GUT test failed because `Level/Player` and reset behavior were absent. | Level checks the fall boundary and resets position and velocity. | GUT moved the player below y=650 and confirmed reset to (80,430), velocity zero. A one-frame integration check allows the expected 0.33 px gravity step after reset. |
| Exit completion and HUD | Initial GUT test failed because the Level and completion UI did not exist. | Exit Area2D emits completion; HUD listens to level signals and shows a clear message. | GUT confirms exit activation shows completion. A reset test confirms completion feedback clears. Browser playthrough displayed “Passage complete!”. |
| Platform collision | The physics integration test was added after the first scene implementation; it passed on its first run, so there is no recorded red run for this test. | Added static collision shapes for each platform. | GUT confirmed floor contact after 45 physics frames; browser keyboard playthrough crossed the platform gaps and reached the exit. |
| Existing HUD contrast and text size | New GUT checks failed: instructions were 16 px and neither label had a solid backing with a measurable foreground/background color. | Set instruction text to 18 px; added dark rounded backings and near-white text to both existing HUD labels. | HUD style assertions passed for both labels; measured contrast is 14.64:1. Full regression run passed 10/10 tests and 24/24 assertions. Godot MCP captured instruction and completion states at 958×539. |
| Full-scene viewport scaling | New viewport GUT check failed because stretch mode resolved to `disabled`. | Set `display/window/stretch/mode` to `canvas_items` and `display/window/stretch/aspect` to `keep`. | Focused viewport test and full suite pass. The user confirmed the full route remains visible in Chrome at 960×540 and 640×360. No browser screenshots are included. |
| Small-viewport HUD text size | Added an assertion that each HUD label remains at least 16 px effective at 640×360. It failed on the instructions at 12 px; completion text passed at 21.3 px. | Increased instruction text to 24 px base and widened its existing label bounds to 600 px; 640×360 effective size is 16 px. | Focused HUD test passed 1/1 test and 10/10 assertions. Full suite passed 11/11 tests and 28/28 assertions. The user confirmed legibility at both supported browser sizes. |
| Linux Web export template download | Render's first build failed with `curl: (22) ... 404` when requesting the old TuxFamily template archive URL. A focused URL regression script failed on the old URL before the code change. | Changed the Linux build script to use the official `downloads.godotengine.org` export-template endpoint. | URL regression script and `bash -n` pass; official endpoint HEAD returns HTTP 200; local Godot Web build passes. Render must rebuild from a pushed fix to verify the Linux path. |

The behavior tests were first run together against the empty Phase 1 scaffold and failed at missing scene nodes; the first implementation pass added the player, level, HUD, and input bindings together rather than completing one red/green cycle per subfeature. Platform collision received a green integration check without a separate red run. This did not strictly follow the plan's one-subfeature-at-a-time TDD sequence, so no stronger process claim is made. All final behavior is covered and verified; follow the strict per-subfeature sequence for future gameplay work.

## Phase 2 checks

| Check | Command or evidence | Result |
|---|---|---|
| Engine and test versions | `godot --version`; GUT CLI | Godot `4.7.2.stable.official.ed1daf0bf`; GUT `9.7.1`. |
| GUT suite | `GODOT_MCP_RUNTIME=0 godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir=res://test/unit -gexit` | 9/9 tests passed; 16/16 assertions passed. |
| Main-scene smoke run | `GODOT_MCP_RUNTIME=0 godot --headless --path . --quit-after 2` | Exit code 0. Host emitted macOS certificate and user-log write errors; the game process exited successfully. |
| Godot MCP runtime | `game_start`, `input_simulate` (move_right + jump), `execute_code`, `runtime_screenshot`, `debugger_get_log` | Runtime connected on port 6570; keyboard action moved player from the start; MCP placed the player below y=650 and read back spawn x=80 after reset; screenshot captured; no gameplay errors in the game log. Screenshot was saved to Godot user data at `user://screenshots/phase2-godot-runtime.png`. |
| Collision and route | GUT physics test and Chrome keyboard playthrough | Player settled at y≈431 on the y=450 platform. Browser input crossed the route and reached the exit. |
| Web export | `godot --headless --path . --export-release Web build/web/index.html` | Exit code 0; generated HTML, JS, WASM, PCK, and audio worklet files. Godot printed host certificate, editor-settings, and MCP registry/port write warnings while exporting. |
| Web resource serving | `python3 -m http.server 8765 --directory build/web --bind 127.0.0.1`; `curl --noproxy '*' -sSI` for `/`, `/index.wasm`, `/index.pck` | All returned HTTP 200; WASM content type was `application/wasm`. |
| Web keyboard playthrough | Chrome headless with SwiftShader and DevTools keyboard events: hold D, pulse Space at platform gaps, continue to exit | The exported build rendered a canvas, accepted keyboard input, and displayed “Passage complete!”. Screenshot: [`phase2-web-playtest.png`](qa/phase2-web-playtest.png). |
| Asset and runtime review | `docs/asset_manifest.md`, scene/runtime inspection | No external assets or audio were introduced; runtime remains self-contained. Geometric placeholders are temporary. |

## Phase 3 checks

| Check | Command or evidence | Result |
|---|---|---|
| Confirmed gameplay scope | Reviewed `docs/game_design.md`, `docs/acceptance_criteria.md`, `docs/architecture.md`, and current scenes/scripts | No gameplay system beyond the Phase 2 traversal loop is required. Health, hazards, enemies, combat, checkpoints, collectibles, multiple maps, and online services remain excluded or unspecified. No runtime code changes were needed. |
| Project import | `godot --headless --editor --path . --import --quit` | Exit code 0. macOS certificate, MCP registry/port, and editor-settings write warnings occurred as described under environment limitations. |
| GUT suite | `GODOT_MCP_RUNTIME=0 godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir=res://test/unit -gexit` | Exit code 0; 9/9 tests and 16/16 assertions passed. |
| Main-scene smoke run | `GODOT_MCP_RUNTIME=0 godot --headless --path . --quit-after 2` | Exit code 0. Host certificate and user log write errors occurred; the game process exited successfully. |
| Phase 2 interactive/browser evidence | Existing recorded MCP and Chrome playtests in Phase 2 checks above | Carried forward from Phase 2; not repeated during this Phase 3 session. The prior browser screenshot remains `docs/qa/phase2-web-playtest.png`. |

Phase 3 closed by omission: the brief is satisfied by the verified traversal loop, so no optional gameplay mechanic was invented. Phase 4 addressed first-level presentation and checked the documented asset sources; see the Phase 4 record below.

## Phase 4 checks

| Check | Command or evidence | Result |
|---|---|---|
| Phase 3 gate before editing | Reviewed recorded criterion P3-03 and independently ran import, GUT, and headless launch before visual changes. | Passed — import exited 0; 9/9 tests and 16/16 assertions passed; headless launch exited 0. |
| SpriteFetch asset discovery | SpriteFetch searches for winter/ice side-view tilesets and a matching winter character. | No suitable result. Tilesets returned unrelated graveyard/cemetery and top-down material. No catalog entry was adopted. |
| Curated source/license review | Kenney, [Platformer Art Winter](https://kenney.nl/assets/platformer-art-winter). | Source page identifies Kenney and CC0. The pack file itself could not be inspected for preview, dimensions, and checksum using available tools; it was not adopted. See `docs/asset_manifest.md`. |
| Godot scene inspection | Godot MCP playtest and runtime screenshot [`phase4-winter-presentation.png`](qa/phase4-winter-presentation.png). | Passed — the new snowy ridgelines, snow caps, icy platforms, lantern exit, and player illustration rendered at 958×539. |
| GUT regression suite | `GODOT_MCP_RUNTIME=0 godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir=res://test/unit -gexit` | Exit code 0; 9/9 tests, 16/16 assertions passed. No traversal behavior changed, so no new behavior test was needed. |
| Headless launch | `GODOT_MCP_RUNTIME=0 godot --headless --path . --quit-after 2` | Exit code 0. Existing host certificate and user log write errors remain. |
| Web export | `GODOT_MCP_RUNTIME=0 godot --headless --path . --export-release Web build/web/index.html` | Exit code 0; refreshed Web export produced. Existing host certificate, MCP registry, and editor settings warnings remain. |
| Browser playthrough | Tried `python3 -m http.server 8765 --directory build/web --bind 127.0.0.1`. | Blocked — the sandbox returned `PermissionError: [Errno 1] Operation not permitted` while binding localhost. Current art was therefore not inspected in the browser. Phase 2 browser playthrough remains evidence for the unchanged gameplay loop. |
| Runtime resource review | Project file/dependency inspection and asset manifest. | Passed — no external assets or network dependencies added; visual presentation is code drawn. Audio remains intentionally absent. |

Phase 4 meets its presentation and asset-provenance gate with local code-drawn visuals and no adopted external assets. The Web export passes; current-browser visual inspection remains a recorded limitation because localhost serving is blocked in this environment.

## Phase 5 checks

| Check | Command or evidence | Result |
|---|---|---|
| Phase 4 gate before edits | Repeated editor import, documented GUT suite, headless launch, and Web export before changing UI. | Passed — import exited 0; 9/9 tests and 16/16 assertions passed; headless launch and Web export exited 0. Existing macOS certificate, `user://` log, MCP registry/port, and editor-settings warnings remain. |
| Baseline UI inspection | Godot MCP runtime screenshot before edits. | Found low contrast: white instructions were directly over the pale sky. |
| TDD red/green | Added `test_viewport_scaling.gd` and extended `test_hud_accessibility.gd`. | Red: stretch mode resolved to `disabled`; the 640×360 effective-size assertion failed at 12 px. Green: focused viewport test passed 1/1 test and 2/2 assertions; focused HUD test passed 1/1 test and 10/10 assertions. Full suite passed 11/11 tests and 28/28 assertions. |
| Godot MCP presentation | Runtime screenshots [`phase5-godot-hud-current.png`](qa/phase5-godot-hud-current.png) and [`phase5-godot-completion-current.png`](qa/phase5-godot-completion-current.png). | Passed at the base runtime capture size of 958×538. Instruction text is 24 px; completion text is 32 px. Both use near-white text on dark navy backings with 14.64:1 measured contrast. Completion is centered; the full route remains visible. |
| Browser route and final HUD at 960×540 / 640×360 | User manual check of refreshed local Web export. | Passed — user confirmed that the route and HUD work at both sizes. No browser screenshots are included. |
| Phase 5 exit gate | P5-01 and P5-02 in `docs/acceptance_criteria.md`. | Passed — tests, export, Godot MCP inspection, and user-confirmed browser checks at both supported sizes are complete. Phase 6 handoff is prepared in `docs/phase6_handoff.md`; no deployment or remote setup was started in this session. |

## Phase 6 checks

| Check | Command or evidence | Result |
|---|---|---|
| Phase 5 gate before edits | `GODOT_MCP_RUNTIME=0 godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir=res://test/unit -gexit` | Passed — 11/11 tests and 28/28 assertions. Godot printed the recorded host certificate and `user://` log write errors. |
| Main-scene smoke launch | `GODOT_MCP_RUNTIME=0 godot --headless --path . --quit-after 2` | Passed — exit code 0. The host certificate and `user://` log write errors were printed. |
| Phase 5 Web export gate | `GODOT_MCP_RUNTIME=0 godot --headless --path . --export-release Web build/phase6-verification/index.html` | Passed — exit code 0; generated `index.html`, JavaScript, WebAssembly, PCK, and audio worklet files. Existing host/editor/MCP write warnings were printed. |
| Render configuration | Ruby Psych parsed `render.yaml`; a focused check confirmed `type: web`, `runtime: static`, build command, and `build/web` publish path. `bash -n scripts/build_web.sh` | Passed — YAML parses and configured fields match the intended Godot static export. |
| Documented build script | `GODOT_MCP_RUNTIME=0 bash scripts/build_web.sh`; Render build log and deploy record | Passed locally with installed Godot `4.7.2.stable.official.ed1daf0bf`; script produced non-empty `index.html`, `index.js`, `index.wasm`, and `index.pck`. Render's Linux x86_64 path also passed after the template URL fix. |
| GitHub repository state | GitHub commit search and file fetch; local `git log --oneline --graph` and `git rev-parse HEAD origin/main` | `mayankjn99/caraxes` `main` points to `22f10ba`, matching local `HEAD`; remote includes the fix and regression script. |
| Clean local clone | `git clone --no-hardlinks` from local checkout into disposable `/private/tmp`; Godot import; GUT; `bash scripts/build_web.sh` | Passed after import — GUT 11/11 tests, 28/28 assertions; Web build generated non-empty `index.html`, `index.js`, `index.wasm`, and `index.pck`. This proves the local committed tree builds from a clean clone on macOS. It does not verify GitHub checkout or Render's Linux path. |
| Render site and first deploy | Render MCP service details, deploy record, build logs, and events in **My Workspace** | Static site `frozen-passage` (`srv-dbj7lugae00c73deh5cg`) is linked to `mayankjn99/caraxes` branch `main`, building `bash scripts/build_web.sh` and publishing `build/web`. First deploy `dep-dbj7luoae00c73deh6d0` used commit `0515466` and failed during build with curl HTTP 404. Logs and events confirm failure; site URL is `https://frozen-passage.onrender.com`. |
| Godot template URL fix | `bash test/scripts/test_build_web_template_download_url.sh`; `curl --head` against old and official URLs; local build script | Regression script failed before fix and passes after. Old TuxFamily URL returned HTTP 404; official Godot endpoint redirected and returned HTTP 200. Local build passed, and the successful Render Linux build confirms the fix. |
| Render deployment after fix | Render deploy status and build logs | Deploy `dep-dbj7qj49v7es739bjaag` built commit `22f10ba` and reached `live`; logs end with `Uploading build...` and `Your site is live`. This verifies the corrected Linux download, import, and export steps. |
| Deployed asset serving | HTTPS HEAD requests to `/`, `/index.html`, `/index.js`, `/index.wasm`, `/index.pck` on `https://frozen-passage.onrender.com` | All five returned HTTP 200. Content types were HTML, JavaScript, `application/wasm`, and binary PCK as expected. No browser was opened; game startup and traversal remain unverified. |
| Render deployment guidance | Current [Static Sites](https://render.com/docs/static-sites) and [Blueprint YAML Reference](https://render.com/docs/blueprint-spec) opened and read | Supports the configured static site, build command, and publish path. Static site deployed from the pushed public Git URL; manual deploy was required after the push. |
| Deployed browser traversal | User opens the live URL at 960×540 and 640×360 and completes the route | Partially verified — the user reported that the deployed game works. Tested dimensions and a complete traversal were not specified, so the exact P6-03 criteria remain unverified. See `docs/deployment.md`. |

## Phase 8 checks

| Check | Command or evidence | Result |
|---|---|---|
| Phase 7 gate before edits | Full GUT suite from `docs/phase8_handoff.md` | Passed before Phase 8 changes — 15/15 tests and 49/49 assertions. |
| Moving-platform motion TDD | `test_moving_platform_travels_between_fixed_endpoints_and_repeats` in `test_phase8.gd` | Red — the reusable motion script was missing and endpoint/timing assertions failed. Green — `MovingPlatform` now has deterministic constant-speed travel, fixed endpoints, and a repeat cycle. |
| Player/platform physics TDD | `test_player_rides_moving_platform_and_jumps_off` in `test_phase8.gd` | Landing, carry, and jump-off checks passed. The added takeoff-momentum assertion then failed at zero horizontal velocity; a short configurable carry was added and the focused suite passed. Passage 2 fall recovery verifies its own spawn and preserved run time. |
| Passage progression TDD | Passage transition and final-completion tests in `test_phase8.gd` | Red — Passage 1 completion finished the run immediately and no active passage state existed. Green — its exit rebuilds the course as Passage 2, keeps elapsed time, and the second exit records final results. |
| Focused Phase 8 GUT | `GODOT_MCP_RUNTIME=0 godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir= -gtest=res://test/unit/test_phase8.gd -gexit` | Passed — 5/5 tests and 27/27 assertions. |
| Passage HUD accessibility | `GODOT_MCP_RUNTIME=0 godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir= -gtest=res://test/unit/test_hud_accessibility.gd -gexit` | Passed — 1/1 test and 15/15 assertions, including passage label contrast and 16 px effective size at 640×360. |
| Finish-result panel TDD | `test_hud_displays_run_time_and_personal_best_on_completion` in `test_run_clock.gd` | Red — measured result text plus padding was 712 px against 490 px. Green — widened the centered completion panel to 780 px; focused timer suite passed 4/4 tests and 22/22 assertions. |
| Full GUT regression | `GODOT_MCP_RUNTIME=0 godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir=res://test/unit -gexit` | Passed — 20/20 tests and 82/82 assertions. |
| Editor import | `GODOT_MCP_RUNTIME=0 godot --headless --editor --path . --import --quit` | Exit code 0. Godot emitted existing macOS certificate and MCP registry/token/port/editor-settings write warnings. |
| Main-scene smoke run | `GODOT_MCP_RUNTIME=0 godot --headless --path . --quit-after 2` | Exit code 0. Existing host certificate and `user://` log-write errors remain. |
| Web export | `GODOT_MCP_RUNTIME=0 bash scripts/build_web.sh` | Exit code 0. `build/web/index.html`, `index.js`, `index.wasm`, and `index.pck` were generated and non-empty. Godot printed the existing certificate and editor/MCP write warnings. |
| Interactive product review | User waiver dated 2026-11-01 | Not performed by the agent. User will review the game link; no browser or in-game test is claimed. |

At the Phase 10 boundary, SR-08 and SR-09 automated criteria passed and that phase's Web export included the local CC0 music asset. Phase 11 checks and current export evidence follow below.

## Phase 11 checks

| Check | Command or evidence | Result |
|---|---|---|
| Integrated full-run/restart regression | `test_full_run_and_restart_keep_speedrun_systems_in_sync` in `test_run_clock.gd` | Passed — verifies Passage 1 marker and HUD, clock/music start, fall preserving dash/music, Passage 2 transition and movers with continuous timer, final result and personal best, completion audio stop, then restart to Passage 1 with cleared clock/results, locked dash, restored marker, stopped audio, and fresh-run start. Initial fixture attempted an unwritable `user://` path and GUT failed on the resulting logged error; moved the isolated fixture to `/tmp` and the focused suite passed 5/5 tests, 48 assertions. No product-code fix was required. |
| Editor import | `GODOT_MCP_RUNTIME=0 godot --headless --editor --path . --import --quit` | Passed — exit code 0. Existing host certificate and user-level Godot MCP/editor-settings write warnings were printed. |
| Focused timer/integration suite | `GODOT_MCP_RUNTIME=0 godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir= -gtest=res://test/unit/test_run_clock.gd -gexit` | Passed — 5/5 tests, 48/48 assertions. |
| Full GUT regression | `GODOT_MCP_RUNTIME=0 godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir=res://test/unit -gexit` | Passed — 33/33 tests and 197/197 assertions. Existing macOS certificate and `user://` log write errors remain; process exited 0. |
| Headless main-scene smoke | `GODOT_MCP_RUNTIME=0 godot --headless --path . --quit-after 2` | Passed — exit code 0; existing host certificate and user log write errors printed. |
| Web export | `GODOT_MCP_RUNTIME=0 bash scripts/build_web.sh` | Passed — exit code 0; non-empty `index.html`, `index.js`, `index.wasm`, `index.pck`, and audio worklet generated. Godot reported existing certificate, MCP registry/token/port, and editor-settings write warnings. |
| Export packaging inspection | `strings build/web/index.pck | rg 'through_the_snow|AudioManager|moving_platform'` and file-size inspection | Passed — PCK contains the local `through_the_snow.ogg` resource/import reference, AudioManager, and moving-platform script; required Web output files are non-empty. |
| Interactive product review/listening | User waiver dated 2026-11-01 | Not performed. No browser was opened, no in-game playthrough or listening review is claimed. User traversal at 960×540 and 640×360 and review of deployed behavior remain pending. |

SR-10 automated integration and local Web packaging evidence pass. SR-10's user traversal component remains pending. The Phase 11 build was deployed after this QA record was first written; deployment details are recorded above. The deployed build has not been browser-played by the agent.

## QA scorecard

Current self-assessment after Phase 11, out of each category's listed weight:

| Category | Weight | Score | Notes |
|---|---:|---:|---|
| Gameplay | 30 | 30 | Both passages, moving platforms, dash unlock/progression, collision, recharge, falls, timer continuity, full-run results, and restart integration pass GUT. |
| Level design | 20 | 18 | Passage 2 adds horizontal and vertical movers and a dash-reachable gap to the winter route; user visual review remains pending. |
| Code quality | 20 | 18 | Player, Level, moving-platform motion, and signal-driven HUD have focused responsibilities and automated coverage. |
| Visuals and audio | 10 | 8 | Coherent code-drawn winter palette and a locally packaged CC0 winter music loop; subjective listening was waived. |
| UI | 10 | 8 | Existing HUD labels have readable text size and measured high contrast; user confirmed the route and HUD work at both supported browser sizes. |
| Deployment | 10 | 8 | Fix commit `8dcd792` is live on Render and the deploy/build succeeded. Browser playthrough remains user-performed. |
| **Total** | **100** | **90** | Not a substitute for the mandatory gameplay/deployment gates. |

Phase 11 automated integration, asset provenance, and Web packaging checks pass. The Passage 2 fix commit is deployed on Render. Subjective listening and current browser playthrough remain for user review. P6-03 is partially verified until browser startup, supported viewport sizes, and a complete traversal are confirmed by the user.

Phase 11 acceptance tests and the full current workspace GUT suite pass. SR-10's automation/export checks pass; its user traversal at supported sizes remains pending. P6-03 remains partially verified until the user confirms browser startup, supported viewport sizes, and a complete traversal on the deployed URL.

## Open issues and environment limitations

- Godot CLI emits host-level macOS certificate and `user://` log write errors. Editor/export runs also report MCP registry token/lock and settings write warnings because those paths are outside the writable workspace. The GUT, smoke-launch, and Web export commands still exit/pass as recorded above.
- Current visuals are original code-drawn illustrations rather than imported curated artwork. The music asset is locally packaged and documented. Future external assets still require the documented per-asset preview and provenance checks.
- Phase 4 Web export was refreshed, but in-session browser verification of that art presentation was blocked by localhost binding. Phase 5 browser-size usability was later confirmed by the user; previous Phase 2 traversal evidence remains recorded above.
- The user previously confirmed an earlier export at 640×360 and 960×540 in Chrome. The current two-passage/music export has not received interactive review; the user waived agent testing and will review the game link.
- Historical Phase 2 Web traversal evidence used headless Chrome with SwiftShader. It does not verify this Phase 8 route.
- No Phase 8–10 changes were pushed or deployed. The user handles GitHub pushes; the latest Phase 10 export is available locally at `build/web`.
