# Frozen Passage — QA Report

## Current milestone

Phase 6 — release and deployment. GitHub `main` now includes commit `22f10ba`, which fixes the Linux export-template URL. The first Render build failed on the old TuxFamily URL; the fix passed a red/green URL regression check, the local GUT suite (11/11 tests, 28/28 assertions), smoke launch, and Web export. Render's second deployment built the Linux Web export and is live. HTTPS HEAD checks returned 200 for the root, HTML, JS, WASM, and PCK assets; WASM uses `application/wasm`. Browser playthrough and viewport verification remain for the user. No browser was opened or controlled in this session. Prior phase history and Phase 4 presentation/asset notes follow.

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
| Deployed browser traversal | User opens the live URL at 960×540 and 640×360 and completes the route | Pending — the deployment and required assets are live, but the user still needs to verify browser startup, viewport layout, and keyboard traversal. P6-03 remains incomplete. See `docs/deployment.md`. |

## QA scorecard

Current self-assessment after Phase 6 deployment preparation, out of each category's listed weight:

| Category | Weight | Score | Notes |
|---|---:|---:|---|
| Gameplay | 30 | 27 | Confirmed move, jump, collision, reset, and exit loop works. |
| Level design | 20 | 16 | Four-platform route now sits in a layered, readable winter landscape. |
| Code quality | 20 | 17 | Player, Level, and signal-driven HUD have separate responsibilities and focused tests. |
| Visuals and audio | 10 | 7 | Coherent code-drawn winter palette and player/goal illustrations; no audio or third-party art. |
| UI | 10 | 8 | Existing HUD labels have readable text size and measured high contrast; user confirmed the route and HUD work at both supported browser sizes. |
| Deployment | 10 | 8 | Local and clean-clone exports, a successful Render Linux build, published assets, and earlier user-confirmed browser sizes pass; deployed browser startup and traversal remain unverified. |
| **Total** | **100** | **83** | Not a substitute for the mandatory gameplay/deployment gates. |

Mandatory gameplay checks pass. Deployment remains incomplete only for P6-03 until the user verifies browser startup, the supported viewport sizes, and a complete traversal on the deployed URL.

## Open issues and environment limitations

- Godot CLI emits host-level macOS certificate and `user://` log write errors. Editor/export runs also report MCP registry token/lock and settings write warnings because those paths are outside the writable workspace. The tested game, GUT, Web export, and browser playthrough still exit/pass as recorded above.
- Current visuals are original code-drawn illustrations rather than imported curated artwork. No audio was selected. Future external assets still require the documented per-asset preview and provenance checks.
- Phase 4 Web export was refreshed, but in-session browser verification of that art presentation was blocked by localhost binding. Phase 5 browser-size usability was later confirmed by the user; previous Phase 2 traversal evidence remains recorded above.
- The user confirmed the refreshed export at 640×360 and 960×540 in Chrome. No browser screenshots are included; the Godot MCP captures are the only visual artifacts in this report.
- The export is verified in headless Chrome with SwiftShader; interactive browser testing and additional browser coverage remain later usability work.
- The remote `mayankjn99/caraxes` still contains only the original README and LICENSE until the user pushes local `main`; local history preserves both.
- No Frozen Passage Render service exists in **My Workspace**. Render build, deployed file serving, deployed browser startup, and full playthrough remain pending. The Linux download path in the build script is not verified yet.
