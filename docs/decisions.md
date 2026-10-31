# Project Decisions

## Web deployment and game verification

**Status:** Accepted; project and local toolchain scaffolded; live MCP/playtest verification pending.

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
