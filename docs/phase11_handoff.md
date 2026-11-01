# Frozen Passage — Phase 11 Handoff

## Goal

Integrate the timer, two-passage moving-platform route, dash unlock, local music, HUD, and finish/restart behavior into one release-ready Web build. Read `docs/implementationPlan.md`, `docs/acceptance_criteria.md`, `docs/architecture.md`, `docs/game_design.md`, `docs/decisions.md`, `docs/enginerringPlan.md`, `docs/asset_manifest.md`, `docs/qa_report.md`, and this handoff before editing.

## Verified baseline entering Phase 11

- Phase 7: timer, local personal best, and run results. Phase 8: deterministic moving platforms, Passage 2, carry/jump-off, falls, and full-run timer. Phase 9: marked dash unlock, Shift dash, collision, cooldown, and lifecycle. Phase 10: Cleyton Kauffman's locally packaged CC0 “Through the Snow”, playback lifecycle, and keyboard-accessible mute/volume controls.
- Acceptance criteria SR-01 through SR-09 are documented as automated-pass; current rows and test evidence are in `docs/acceptance_criteria.md` and `docs/qa_report.md`.
- Phase 10 focus: 4/4 tests and 34 assertions. Full suite: 32/32 tests, 171 assertions. Headless scene launch and Web export pass; PCK inspection confirms the OGG resource is bundled. See QA report for commands and environment warnings.
- The user waived interactive browser/in-game testing, including listening review. Do not open/control a browser or perform interactive game testing. Do not claim subjective playback/listening verification. Use automated tests, static inspection, headless smoke launch, and Web export only. The user will review the game link.
- Do not push to GitHub or deploy to Render. User handles pushes and will discuss deployment.
- Preserve all existing uncommitted work. The current repository tree contains the implementation for Phases 7–10; do not discard or reset it.

## Phase 11 subfeatures

1. Full-run integration: extend/add acceptance tests for run start, Passage 1-to-2 transition, timer continuity, fall recovery, dash unlock/cooldown, final completion, best-time persistence, and restart resetting the complete run/audio state.
2. Route and HUD consistency: verify player spawn/exit/marker placements, controls and dash status, timer/results, and music controls together across both passages. Preserve prior accessibility sizing/contrast tests.
3. Browser build readiness: run import if needed, focused and full GUT, headless scene smoke, and Web export. Confirm required assets and local music are packaged; do not access the deployed page or run browser tests.
4. Update SR-10, QA scorecard, design/implementation docs, and final release notes with actual evidence and explicit user-waived checks. Do not claim deployment or user traversal before the user does it.

## Required workflow and constraints

- Use red/green TDD for each subfeature. Preserve a failing assertion demonstrating the missing integration, implement the smallest change, rerun focused checks, then full regression and export.
- Keep runtime offline; do not add networking, leaderboards, or accounts.
- No interactive product testing, push, or deployment. Preserve existing changes and unrelated edits.
- After this final planned phase, audit all acceptance criteria against current files and recorded output. Keep the project state and handoff reviewable for the user; do not claim a public deploy is current until the user pushes/deploys and reviews it.
