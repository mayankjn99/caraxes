# Frozen Passage — Phase 10 Handoff

## Goal

Add locally packaged, human-composed, properly licensed music to the speedrun. Read `docs/game_design.md`, `docs/architecture.md`, `docs/implementationPlan.md`, `docs/acceptance_criteria.md`, `docs/decisions.md`, `docs/enginerringPlan.md`, `docs/assetsGuide.md`, `docs/asset_manifest.md`, `docs/qa_report.md`, and this handoff before editing.

## Current baseline

- Phase 9 adds a marked dash unlock, Shift input, directional dash with fixed duration/cooldown, wall collision, and integration with falls, restart, passage progression, and final completion.
- Phase 9 acceptance rows SR-06 and SR-07 pass automated checks. The Phase 9 focused GUT report is 8/8 tests and 50 assertions; the focused HUD accessibility test is 1/1 and 20 assertions. The Phase 7–9 regression suite is 28/28 tests and 137 assertions.
- Headless main-scene launch and `GODOT_MCP_RUNTIME=0 bash scripts/build_web.sh` passed; required Web assets are generated under `build/web`.
- The user waived interactive product testing. Do not open/control a browser or run interactive in-game verification. Use automated tests, static inspection, headless scene launch, and Web export only. The user will review the game link.
- Do not push to GitHub or deploy to Render. User handles pushes and will discuss deployment.
- Preserve the existing uncommitted work. This repository checkout contains the Phase 7–9 code and documentation.

## Phase 10 scope

1. Source human-composed music with a license that permits bundling and web distribution. Verify creator, original source, exact license/attribution terms, and file checksum before adopting it; document all metadata in `docs/asset_manifest.md`. Do not use AI-generated or runtime-generated music. If provenance cannot be verified, do not adopt the track; continue other independent work and report the sourcing limitation.
2. Add the music locally to the project and configure playback so the Web build does not require network access.
3. Add focused red/green GUT coverage for audio configuration and the playback lifecycle. Music should begin when a run starts, handle loop/end behavior deliberately, and stop or transition cleanly on restart and completion. Keep audio responsibilities in the audio manager/component per the architecture.
4. Keep volume/control UX legible and usable at supported viewport sizes; test configuration and HUD state automatically.
5. Update SR-08/SR-09, QA report, asset manifest, and next-phase handoff with actual evidence.

## Constraints and gates

- Follow red/green TDD for each subfeature: write the focused failing acceptance test first, implement the smallest change, rerun focused tests, then the full GUT suite, headless main-scene smoke launch, and Web export.
- Do not perform or request interactive browser/in-game tests. Do not claim audio playback was listened to; the user will review the result.
- Do not push or deploy. Preserve all existing uncommitted edits.
- At phase completion, create a fresh Codex session for Phase 11 using the working tree and this handoff, to prevent context bloat.

## Phase 10 completion record — 2026-11-01

- Adopted and packaged Cleyton Kauffman's “Through the Snow” under CC0 at `assets/audio/through_the_snow.ogg`. The source page and archive readme identify the creator and license; both archive and shipped-file SHA-256 values are in `docs/asset_manifest.md`.
- Audio lifecycle and HUD controls are implemented. The package-specific GUT case confirms the local OGG resource is assigned, exposed in the HUD, and enters the playing state at run start. Other GUT cases cover lifecycle, looping, keyboard access, viewport sizing, and saved settings.
- Final focused audio tests: 4/4 tests, 34 assertions. Full GUT suite: 32/32 tests, 171 assertions. Headless smoke launch and Web export pass. The exported PCK strings include the local source and imported Ogg stream.
- SR-08/SR-09 automated gates pass. Subjective listening and interactive browser/game testing were waived by the user; no listening claim is made. The user will review the game link.
- No push or deployment was performed. User handles GitHub pushes and will discuss deployment.
