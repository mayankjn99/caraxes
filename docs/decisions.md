# Project Decisions

## Web deployment and game verification

**Status:** Accepted; project deployed on Render at https://frozen-passage.onrender.com; live MCP/playtest verification remains pending under the user's waiver of agent interactive testing.

### Decision

- Build Frozen Passage as a browser-playable game.
- Keep the source in GitHub and use Render for deployment. The exact Render deployment configuration can be decided when the project is ready to deploy.
- Use Godot MCP Toolkit 1.1.2 with its pinned `@npgamedev/godot-mcp-server` 1.1.2 bridge to launch and interact with the game, inspect runtime errors, and capture screenshots when verifying changes.
- Pair interactive playtesting with automated tests and acceptance criteria. Record test results and unresolved failures in the project QA documentation.

### Rationale

The engineering standards require each feature to have an acceptance test and recorded result. For each milestone, they call for static checks, automated tests, and launching the game to verify functionality before proceeding. A Godot MCP connection can support the interactive portion of that verification loop; the Render integration is for deployment and does not verify gameplay.

### Constraints and follow-up

- Godot 4.7.2 stable is installed; GUT 9.7.1 and the Godot MCP Toolkit 1.1.2 MIT-licensed add-ons are in the project. The project has been headlessly imported and smoke-launched.
- The Codex bridge is registered in user-level MCP configuration and scoped to this project. Verify it from a fresh Codex session while the Godot editor is open before relying on it for milestone acceptance.
- No separate MCP testing guide was present in the workspace. The testing workflow is documented in `docs/enginerringPlan.md` and expanded in `docs/implementationPlan.md`.

## SpriteFetch for asset discovery

**Status:** Accepted; MCP endpoint registered in the user's Codex configuration.

### Decision

- Use SpriteFetch as the first search option when looking for suitable 2D sprites and tilesets.
- Keep selected assets local in the project. Do not make runtime requests to SpriteFetch or any other asset service.
- Before adopting an asset, inspect its preview and source, verify its per-asset license evidence and checksum, check style and dimensions in Godot, and record its provenance and license in `docs/asset_manifest.md`.

### Rationale

SpriteFetch provides asset search and download tools with license, provenance, slicing, and checksum metadata. This supports the project's curated asset and local-only runtime requirements. Its catalog's license filters are a discovery aid, not a replacement for reviewing each asset's license evidence.

### Setup note

The hosted MCP endpoint `https://api.spritefetch.dev/mcp` is registered as `spritefetch` in the user-level Codex configuration. A new Codex session or MCP reload may be needed before its tools are available in a conversation. No SpriteFetch assets have been downloaded or added to the game project.

## Speedrun expansion

**Status:** Phase 11 integration and local Web release checks completed (2026-11-01); commit `82370a795e4f8d619fc569f696659a9ffc32c032` is live on Render. A user-reported Passage 2 stuck-state fix is now covered by red/green tests in the local, unpushed candidate; see `docs/qa_report.md`. Interactive/browser and listening review were waived for the agent and remain for user review.

### Decision

- Expand the one-passage traversal game into a single-player speedrun with a run clock, a second passage featuring moving platforms, a later dash ability, and locally packaged music.
- Keep all gameplay and audio offline. Do not add online leaderboards, accounts, multiplayer, or runtime asset/audio fetches.
- Use human-composed, appropriately licensed music; AI-generated music remains out of scope.
- Follow the established TDD cycle for each subfeature: failing behavior test, smallest implementation, focused and regression tests, in-game verification when available, and recorded results. The user waived agent interactive testing for the current web builds.
- Proposed run semantics: clock begins on first movement input, a fall returns the player to spawn but the clock continues, explicit restart resets the clock, and completion freezes it. Keep best time locally on the device.
- Phase 9 dash behavior: one-time pickup on Passage 1 unlocks Shift; dash travels horizontally in facing direction at 900 px/s for 0.18 seconds, ignores gravity during the burst, keeps solid collision, and recharges for 0.65 seconds. Falls/transitions preserve remaining cooldown; explicit restart relocks dash.
- The first Phase 10 candidate `Wintery loop` by Emma_MA was not adopted because the source file could not be retrieved and verified. Cleyton Kauffman's `Through the Snow` from OpenGameArt was adopted after its included readme and source listing confirmed CC0/public-domain terms; the local OGG checksum is recorded in the asset manifest. No runtime audio sourcing or AI-generated music is used.

### Settled choice

- Dash unlocks when the player touches the amber “DASH” marker on Passage 1's second platform. The HUD reports locked, active, recharging, and ready states.

### Rationale

Separate phases let the timer be validated before physics changes, moving platforms be verified before dash tuning, and music provenance/playback be tested independently. This reduces the chance that multiple new systems mask one another's failures.
