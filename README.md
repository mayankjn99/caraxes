# Frozen Passage

Frozen Passage is a Godot 2D traversal platformer in early development. The target is a browser-playable web build, with GitHub as source control and Render as the planned host.

## Local toolchain

- Godot 4.7.2 stable
- GUT 9.7.1 for GDScript tests
- Godot MCP Toolkit 1.1.2 for editor/runtime inspection and playtests
- Node.js 22 or newer for the Godot MCP bridge

## Commands

Run from the project root:

```sh
godot --headless --editor --path . --import --quit
GODOT_MCP_RUNTIME=0 godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir=res://test/unit -gexit
GODOT_MCP_RUNTIME=0 godot --headless --path . --quit-after 2
mkdir -p build/web
godot --headless --path . --export-release Web build/web/index.html
python3 -m http.server 8000 --directory build/web
```

The first command imports project resources, the second runs unit tests, and the third smoke-launches the main scene. The final commands export and serve a static Web build. Open `http://localhost:8000` for browser testing; opening the HTML file directly is not a valid test. Headless game runs opt out of the MCP runtime listener; use the Godot editor bridge for interactive verification. The no-threads Web preset disables VRAM compression to match the installed template features.

## Project docs

- [Implementation plan](docs/implementationPlan.md)
- [Game design](docs/game_design.md)
- [Architecture](docs/architecture.md)
- [Acceptance criteria](docs/acceptance_criteria.md)
- [QA report](docs/qa_report.md)
- [Asset guide](docs/assetsGuide.md)
- [Asset manifest](docs/asset_manifest.md)
- [Decisions](docs/decisions.md)
