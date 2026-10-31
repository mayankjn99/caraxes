# Frozen Passage — Asset Manifest

No third-party game assets or audio were selected or shipped in Phase 4. The winter scenery, ice-platform surface details, lantern exit, and mountaineer are drawn by `scripts/level.gd` and `scripts/player.gd`; these are project code, not imported assets, and require no external license metadata. Runtime assets remain local and the game makes no runtime network calls.

For every adopted asset, record:

| Asset | Creator | Source URL | License | Attribution | Version/hash | Local path | Preview/format checks |
|---|---|---|---|---|---|---|---|

Before adding an asset, inspect its preview, source, dimensions, style fit, and license evidence. Keep the asset locally in the project and verify it in a running level. See `docs/assetsGuide.md` for the sourcing workflow.

## Phase 4 discovery record

- SpriteFetch was queried first for winter/ice platform tilesets and a matching character. Returned tilesets were unrelated graveyard/cemetery or top-down art; no suitable candidate was adopted. Search results were not treated as license proof for any asset.
- Kenney's [Platformer Art Winter page](https://kenney.nl/assets/platformer-art-winter) identifies Kenney as source/uploader and states Creative Commons CC0. Its file preview, per-file dimensions, and checksum were not available through the connected tools during this session, so the pack was not downloaded or shipped.
- The table above remains intentionally empty. No asset has incomplete or inferred provenance.
