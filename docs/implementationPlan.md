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

**Exit gate:** Deployment is reproducible from the documented steps; mandatory gameplay and deployment checks pass; failures and remaining limitations are recorded.

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

**Phase 3 handoff:** `docs/phase3_handoff.md` records the Phase 3 entry scope and is historical. Phase 3 is intentionally complete with no additional gameplay systems. Phases 4 and 5 are complete; read `docs/phase6_handoff.md` in a fresh session before beginning Phase 6. Do not add optional mechanics without a confirmed requirement.
