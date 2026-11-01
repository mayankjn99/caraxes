# Frozen Passage — Asset Manifest

No third-party game assets or audio were selected or shipped in Phase 4. The winter scenery, ice-platform surface details, lantern exit, and mountaineer are drawn by `scripts/level.gd` and `scripts/player.gd`; these are project code, not imported assets, and require no external license metadata. Phase 10 adds one locally packaged music asset; the game makes no runtime network calls.

For every adopted asset, record:

| Asset | Creator | Source URL | License | Attribution | Version/hash | Local path | Preview/format checks |
|---|---|---|---|---|---|---|---|
| Through the Snow (BGM_Snow_Theme_Loop.ogg) | Cleyton Kauffman (OpenGameArt author CleytonKauffman) | [OpenGameArt — Snow Theme](https://opengameart.org/content/snow-theme) | CC0 / public domain; [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) | Optional; retained as `Music by Cleyton Kauffman` | SHA-256 `3fad0971a8d3c2aca03c6535a7bd89076c36cc006b2a0888c4ab309a98160c87` | `assets/audio/through_the_snow.ogg` | Source listing describes a seamless 24-second winter loop, 16-bit stereo 44.1 kHz, and OGG/WAV/FLAC formats. Archive readme confirms CC0 and creator. Shipped OGG inspected as Vorbis, stereo, 48 kHz; local file hash recorded. Listening was waived; no listening claim. |

Before adding an asset, inspect its preview, source, dimensions, style fit, and license evidence. Keep the asset locally in the project and verify it in a running level. See `docs/assetsGuide.md` for the sourcing workflow.

## Phase 4 discovery record

- SpriteFetch was queried first for winter/ice platform tilesets and a matching character. Returned tilesets were unrelated graveyard/cemetery or top-down art; no suitable candidate was adopted. Search results were not treated as license proof for any asset.
- Kenney's [Platformer Art Winter page](https://kenney.nl/assets/platformer-art-winter) identifies Kenney as source/uploader and states Creative Commons CC0. Its file preview, per-file dimensions, and checksum were not available through the connected tools during this session, so the pack was not downloaded or shipped.
- No visual assets were adopted in Phase 4; the music asset above was separately verified and adopted in Phase 10.

## Phase 10 music sourcing record

- First candidate, [Wintery loop](https://opengameart.org/content/wintery-loop) by Emma_MA, was rejected because the actual file could not be fetched and hashed.
- Adopted: [Snow Theme](https://opengameart.org/content/snow-theme), titled “Through the Snow” and credited to Cleyton Kauffman. The listing identifies the work as a seamless 24-second winter background loop, says the download includes OGG, and marks it CC0 with optional credit. The downloaded archive's included readme names Cleyton Kauffman, states CC0/public domain, and says credit is appreciated but not required.
- The source archive was `snow_theme_1.zip`; its SHA-256 was `10fe7758311e7b7e724abbad56fbee0d86e0131e1fa66512f4188a5ee6a0c05c`. The shipped OGG is `assets/audio/through_the_snow.ogg`, SHA-256 `3fad0971a8d3c2aca03c6535a7bd89076c36cc006b2a0888c4ab309a98160c87`. `file` identifies Ogg Vorbis stereo audio at 48 kHz. The player/export use the local asset; no runtime download is needed.
- No listening was performed, per the user's interactive-testing waiver. The asset's source metadata describes its intended mood/looping, but this project does not claim subjective audio review.
