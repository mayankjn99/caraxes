# Frozen Passage Implementation Plan

## Goal

Build a small, polished Godot game that runs in a browser, can be deployed from GitHub through Render, and is verified through automated tests and in-game playtests. Keep the game self-contained at runtime: assets are stored locally and the game does not call asset or other external services.

## Inputs and current baseline

- `docs/enginerringPlan.md` defines code quality, milestone gates, required tests, the QA scorecard, and documentation to maintain.
- `docs/assetsGuide.md` defines curated asset sourcing, licensing checks, local asset storage, and the prohibition on generative art and music.
- `docs/decisions.md` records the browser target, GitHub/Render workflow, planned Godot MCP verification, and SpriteFetch as the first asset discovery option.
- The workspace has a verified traversal slice: keyboard movement and jump, collision-backed platforms, fall reset, exit completion, GUT tests, and a browser-verified Web export. Phase 3 scope review confirmed no additional gameplay systems are required. Phase 4 added a coherent code-drawn winter presentation; no external game assets or audio were adopted.
- The user confirmed 2D platformer traversal and the short winter level loop: move and jump, restart after falling, and finish at the exit.

## Phases

### Phase 1 — Requirements and project foundation

**Status:** Complete. The user selected 2D platformer traversal and confirmed the first playable loop: move and jump through a short winter level, restart at the start after falling, and finish at the exit. The project imports and launches, MCP inspects and starts the runtime, and the Web export loads in headless Chrome. See `docs/acceptance_criteria.md` and `docs/qa_report.md` for evidence.

**Deliverables**

- Record the confirmed game brief: core loop, player goal, default controls, fail/success conditions, first playable level, and minimum release scope.
- Create or update `docs/game_design.md`, `docs/architecture.md`, and `docs/acceptance_criteria.md` from confirmed requirements.
- Use Godot 4.7.2 stable, GUT 9.7.1, and the Godot MCP Toolkit 1.1.2 as the initial local toolchain. The editor listener, MCP bridge, game start, and runtime inspection are verified against the open editor.
- Confirm the web export approach and local run commands.
- Create the minimum Godot project scaffold and a smoke-test path. Add a reproducible browser export check before gameplay features depend on deployment.

**Exit gate**

- Requirements and acceptance criteria are explicit, and no core gameplay behavior is being guessed.
- The project opens and launches locally; the web build exports and boots in a browser-capable test path.
- The MCP connection can run the game and return runtime status (and a screenshot when display access is available).
- Test commands and known environment limitations are written down.

### Phase 2 — First playable loop

Implement the smallest complete player-to-goal loop defined in Phase 1. Likely subfeatures are player input/movement, collision with a simple test level, reaching the goal, and a clear success result. Include failure/retry only if required by the approved design.

**Status:** Complete — the confirmed move/jump/platform/fall-reset/exit loop is covered by GUT and was played through in the Web export. Phase 3 subsequently confirmed that no extra gameplay systems are needed. See `docs/acceptance_criteria.md` and `docs/qa_report.md` for criterion-level evidence.

**Deliverables completed**

- Player movement and grounded jump with arrow/A-D and Space/Up/W input bindings.
- Collision-backed four-platform traversal route, fall reset to spawn, and exit completion feedback.
- GUT coverage, Godot MCP runtime verification, and a Chrome headless Web playthrough.
- Updated design, architecture, acceptance, and QA records. No licensed assets or audio have been selected; geometric placeholders remain.

**Exit gate:** Acceptance tests cover the loop, the game is playable end-to-end, and the web build passes the same smoke path.

### Phase 3 — Gameplay systems

Implement only the systems required by the approved design, such as health, hazards, enemies, combat, checkpoints, and map transitions. Each system remains responsible for one job and communicates across components with signals where appropriate.

**Status:** Complete — review of the confirmed brief and Phase 2 implementation found no additional gameplay system requirement. Optional health, hazards, enemies, combat, checkpoints, collectibles, and map transitions remain omitted. See `docs/acceptance_criteria.md` and `docs/qa_report.md` for the decision and Phase 2 gate verification performed in the Phase 3 session.

**Exit gate:** Each shipped system has automated coverage, an in-game verification scenario, and recorded results. Unneeded systems are omitted.

### Phase 4 — Levels, art, and audio

Build the first level(s) and add selected local assets. Review previews, style fit, dimensions, license evidence, and checksums before use. Record creator/source/license/attribution in `docs/asset_manifest.md`. Add human-composed/licensed audio only; no generative artwork or music.

**Status:** Complete — the first level has a coherent code-drawn winter presentation. SpriteFetch discovery and the documented Kenney source were reviewed; no external assets were adopted without file-level preview and checksum evidence. Import, tests, headless launch, Godot runtime inspection, and Web export pass. Browser review of the new presentation remains open because the environment denied localhost server binding. See `docs/acceptance_criteria.md`, `docs/asset_manifest.md`, and `docs/qa_report.md`.

**Exit gate:** The game has a coherent visual/audio style, assets are locally available, and the manifest is complete for every shipped asset.

### Phase 5 — UI, accessibility, and polish

Add the required menus, instructions, settings, feedback, and presentation polish. Keep controls and text usable at the supported browser sizes and input devices established in Phase 1.

**Status:** Complete — the existing HUD uses high-contrast backings, readable instruction text, and the project scales canvas items while preserving the 16:9 scene. Automated checks pass; Godot MCP inspected the updated HUD and completion state; the user confirmed the Web export at 960×540 and 640×360. See the Phase 5 acceptance criteria and QA report.

**Exit gate:** UI acceptance criteria pass and representative browser playtests have no unresolved blocking usability or presentation issues.

### Phase 6 — Release and deployment

Prepare the GitHub repository and Render static-site configuration for the chosen web export. Verify clean-checkout build, published files, browser startup, and a full playthrough on the deployed URL. Update `docs/deployment.md` and the QA scorecard.

**Status:** Render deployment is live for commit `22f10ba`; the page and required export assets return HTTP 200. The user reports that the deployed game works. Exact viewport sizes and completion-route details were not included in that report, so see P6-03 for the remaining evidence limit.

**Exit gate:** Deployment is reproducible from the documented steps; mandatory gameplay and deployment checks pass; failures and remaining limitations are recorded.

## Speedrun expansion phases

The user requested a speedrun-focused expansion after confirming the deployed game works: more than one passage, moving platforms, dash becoming available after an initial period, and music. This scope supersedes Phase 3's earlier conclusion that the single traversal loop needed no further gameplay systems. Retain the TDD loop below for every subfeature. Do not implement online features or use AI-generated music.

### Phase 7 — Speedrun clock and run records

Add the timer and run feedback first, before changing the level physics.

**Subfeatures and red/green gates**

1. Run clock: add a focused test proving the clock is inactive before the run starts, advances deterministically, freezes on completion, and resets for a new run; implement the smallest clock component and verify it in the HUD.
2. Fall and restart semantics: test that falling returns the player to spawn while preserving elapsed time, and that explicit restart resets the run. Keep this as the proposed default unless the user changes it.
3. Finish and personal best: test the displayed finish time and best-time comparison, then verify persistence locally only (`user://`, no server or leaderboard).
4. Runtime verification is waived by the user (2026-11-01); automated acceptance tests and Web export checks remain required.

**Exit gate:** P7 automated acceptance criteria and regression tests pass, and a Web build succeeds. The user will open the game link and provide feedback; agent interactive testing is waived.

### Phase 8 — Moving platforms and Passage 2

**Status:** Complete (2026-11-01) — both passages are implemented with deterministic moving platforms, platform carry/jump-off behavior, timer-preserving transitions, and Passage 2 fall recovery. GUT passed 20/20 tests and 82/82 assertions; the Web export produced all required files. The user waived interactive product testing and will review the game link.

Keep Passage 1 as the introductory route and add a second passage with readable, deterministic moving-platform timing.

**Subfeatures and red/green gates**

1. **Passed:** Moving-platform motion test covered fixed endpoints, travel duration, and repeat behavior before adding course art/layout.
2. **Passed:** Physics tests covered landing, carrying, jumping with platform momentum, and Passage 2 fall recovery with preserved time.
3. **Passed:** Passage flow tests covered transition without resetting the run clock and final completion/personal-best recording.
4. Runtime playtesting is waived by the user (2026-11-01); use automated physics/route tests and Web export checks.

**Exit gate:** Automated tests cover both passages, moving-platform behavior, and progression without softlocks; Web export succeeds. User will review and provide feedback.

### Phase 9 — Dash progression and platforming

**Status:** Complete (2026-11-01) — Shift unlocks at a marked Passage 1 pickup; dash is horizontal in facing direction at 900 px/s for 0.18 seconds, with gravity suppressed and collision preserved. The 0.65-second cooldown is shown in the HUD, survives falls and passage transitions, and resets when a new run relocks dash. GUT verifies the air dash across Passage 2's gap, wall collision, exit progression, fall/restart behavior, and final completion. The Phase 7–9 regression and full current GUT suite passed; smoke launch and Web export passed. Interactive playtesting was waived by the user.

Add dash only after the moving-platform course exists, so its value and edge cases are tested against the actual route.

**Subfeatures and red/green gates**

1. **Passed:** Locked Shift input leaves velocity unchanged; touching the marked Passage 1 pickup unlocks dash once and updates the HUD. **User selected (2026-11-01):** unlock at a clearly marked course point.
2. **Passed:** Dash moves in facing direction at 900 px/s for 0.18 seconds, suppresses gravity during its burst, respects solid collision, and recharges after 0.65 seconds. HUD reports active/recharging/ready state.
3. **Passed:** Air dash crosses Passage 2's moving-platform gap; falls preserve unlock and cooldown; explicit restart relocks; Passage 1 exit transitions to Passage 2 and cannot skip the final passage; final completion stops movement.
4. Interactive verification waived by the user (2026-11-01); GUT physics/route tests, smoke launch, and Web export were used for the automated gate. The user will review the game link.

**Exit gate:** Automated unlock, movement, collision, recharge, course progression, and full regression criteria pass; Web export succeeds. Interactive playtesting is waived; the user will review the game link.

### Phase 10 — Licensed music

**Status:** Implemented with interactive review waived (2026-11-01). The first Emma_MA candidate was rejected when its file could not be retrieved. Cleyton Kauffman's “Through the Snow” was downloaded from its OpenGameArt page; the included readme and source listing confirm CC0/public-domain terms and creator, and the shipped OGG's SHA-256 is recorded in `docs/asset_manifest.md`. AudioManager starts the local track with the run, preserves it through fall recovery, stops on restart/completion, loops at end, and stores mute/volume settings. HUD controls are enabled and keyboard accessible. Focused Phase 10 GUT, full suite, headless launch, and Web export pass. The user waived interactive testing; no listening claim is made.

Select human-composed music under a license that permits the intended distribution. Verify the actual audio file's creator, source, license, attribution, and checksum before adding it.

**Subfeatures and red/green gates**

1. Asset provenance: document candidate preview, creator, source, license, attribution, and checksum; reject the asset if any required provenance is missing.
2. Playback lifecycle: test music starts at run start, loops or ends as specified, and stops/changes cleanly on completion/restart.
3. Music control: test a user-accessible mute/volume setting persists as intended. Keep audio local and offline.
4. Interactive listening review: waived by the user; automated resource-assignment/playback-state and export-packaging checks are used instead. Do not claim subjective audio review.

**Exit gate:** Every shipped audio file is documented in the asset manifest; automated tests confirm the local stream assignment and run lifecycle; the Web PCK contains the local audio resource; controls work. Interactive listening review is waived by the user.

### Phase 11 — Integrated speedrun release

**Status:** Phase implementation and automated local release gate complete (2026-11-01). A cross-system GUT regression covers Passage 1 start and music, fall persistence, Passage 2 transition/movers/HUD, final result and personal best, completion audio stop, then a full restart and fresh run. Full GUT passed 33/33 tests and 197/197 assertions; editor import, headless smoke, and Web export passed. A later Passage 2 stuck-state report was fixed with stale-exit generation and overlap guards; the red/green regression and full suite passed 36/36 tests and 208/208 assertions. Fix commit `8dcd792` is pushed and live on Render as deploy `dep-dbjh7fgu01pc73ff7png`. The user waived agent browser/gameplay and listening review; live browser traversal and listening feedback remain for user review.

Integrate the clock, Passage 1, Passage 2, dash progression, and music. Tune timing and feedback without adding unrequested services.

**Subfeatures and red/green gates**

1. Full-run regression: test transitions, timer continuity, fall recovery, final completion, and personal-best updates end to end.
2. Usability/polish: test control instructions, unlock cue, moving-platform readability, finish results, and restart at supported aspect ratios.
3. Web/release readiness: run full GUT, headless smoke, and Web export; confirm required assets are packaged. The user pushed the reviewed code to GitHub and authorized Render deployment; because auto-deploy did not start, the current commit was deployed through Render. Record browser playthrough and listening checks as pending until the user reports them.

**Exit gate:** Both passages and speedrun features work together in the local Web export; automated integration and packaging checks pass; final acceptance/QA docs contain evidence and limitations. The deployment is live; interactive playthrough and listening review remain user-owned follow-up checks.

### Handoff/session rule for the expansion

Create a fresh Codex session for Phase 7 after this plan and handoff are reviewable. At each later phase boundary, complete the phase gate and write the next concise handoff before creating another fresh session. The dash unlock choice is settled: Phase 9 uses a clearly marked course point.

## TDD loop for every subfeature

1. Select one small behavior from the current phase's acceptance criteria. Do not start unrelated work.
2. Write the smallest test that expresses the expected behavior and run it to confirm it fails for the intended reason (red).
3. Implement the smallest readable change that makes the test pass (green).
4. Run the focused test, then the relevant existing test suite and static checks. Fix regressions before adding scope.
5. Launch the game and exercise the behavior through Godot MCP when available. Inspect runtime errors and capture visual evidence for visual changes. Use a manual check only when automation cannot observe the behavior, and record why.
6. Check edge cases and affected neighboring behavior; run the relevant tests again after fixes.
7. Record the command, result, and evidence in `docs/qa_report.md`; update acceptance criteria and the QA scorecard. Never mark unverified work complete.
8. Review component responsibilities, duplicated rules, configurable values, error handling, and asset licensing before closing the subfeature.

If an expected test cannot be run, stop that subfeature at **blocked/unverified**, record the missing dependency and evidence, and do not treat it as passing.

## Phase completion and fresh-session handoff

At a phase boundary, do not start the next phase in the same long-running session. First:

1. Finish the exit gate and report pass/fail evidence for every item.
2. Update the design/architecture/acceptance/QA/deployment docs that changed, list unresolved issues, and leave the working tree in a reviewable state.
3. Write a short handoff with the goal, completed phase, exact next phase, relevant file paths, test commands/results, blockers, and constraints. Do not copy the whole conversation.
4. Start a fresh Codex session for the next phase using that handoff. The new session must read the project instructions and handoff, inspect current files/status, and verify the previous phase's recorded gate before changing code.

The fresh session preserves continuity through repository files while keeping the active context focused. Do not move phases just because work is mostly done; all exit-gate checks need recorded evidence.

## QA and reporting

Maintain `docs/qa_report.md` using the score weights in `docs/enginerringPlan.md` (gameplay 30, level design 20, code quality 20, visuals/audio 10, UI 10, deployment 10). Mandatory gameplay and deployment gates remain pass/fail requirements regardless of aggregate score.

**Historical handoffs:** `docs/phase3_handoff.md` records Phase 3 entry scope; `docs/phase6_handoff.md` records deployment status. The first traversal game's Phase 3 review intentionally omitted extra mechanics; the user's later speedrun-expansion request now authorizes Phases 7–11. Read `docs/phase7_handoff.md` in a fresh session before beginning Phase 7.
