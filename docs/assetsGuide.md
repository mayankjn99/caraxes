# Frozen Passage — Resource Manifest

## Objective
Use curated, non-generative resources to develop the game. Avoid AI-generated art, AI-generated music and paid external services.

## Primary environment assets

1. Kenney Platformer Art Winter
   https://opengameart.org/content/platformer-art-ice-world
   License: CC0

2. CodeRaurus Snow Tileset
   https://coderaurus.itch.io/snow-tileset
   License: CC0

3. pzUH Winter Platformer Tileset
   https://opengameart.org/content/winter-platformer-game-tileset
   License: CC0

4. Tio Aimar Snow Pack
   https://opengameart.org/content/2d-platformer-snow-pack
   License: CC0

## Character and enemy assets

1. Kenney Pixel Platformer
   https://kenney.nl/assets/pixel-platformer

2. OpenGameArt
   https://opengameart.org/

Search for:
- Small fantasy player characters.
- Flying creatures.
- Enemy attack animations.
- Hit and death animations.

## Audio resources

1. OpenGameArt
   https://opengameart.org/

2. Kenney Audio
   https://kenney.nl/assets?q=audio

3. Freesound
   https://freesound.org/

4. MuseScore Studio
   https://musescore.org/

5. Bfxr
   https://www.bfxr.net/

Use human-composed music and original arrangements only. No AI music generation.

## Development resources

1. Godot documentation
   https://docs.godotengine.org/en/stable/

2. Godot 2D documentation
   https://docs.godotengine.org/en/stable/tutorials/2d/index.html

3. GDScript style guide
   https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html

4. GUT testing framework
   https://github.com/bitwes/Gut

## Asset acquisition instructions

Before using an asset:

1. Open the original source page.
2. Inspect its preview.
3. Confirm the license and commercial usage rights.
4. Download the asset.
5. Record its creator, source URL, license and attribution requirements.
6. Verify its format and dimensions.
7. Import it into Godot.
8. Test its appearance in the actual game.

Do not assume all free assets are CC0.

Do not use assets with unclear licensing.

Do not mix incompatible art styles.

Do not replace missing assets with random AI-generated artwork.

## Asset organization

assets/
  characters/
  enemies/
  environments/
    snow/
    ice_cave/
    backgrounds/
  animations/
  audio/
    music/
    ambience/
    sfx/
  fonts/
  ui/

Maintain docs/asset_manifest.md with the actual assets used and their licenses.

## Important constraint

All assets must be stored locally in the project.

The game must not download assets or call external services at runtime.