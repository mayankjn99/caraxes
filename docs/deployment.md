# Web Deployment

Frozen Passage is a Godot Web export served as a Render static site. The game runs entirely in the browser; it does not require a web server process, API, database, runtime asset downloads, or external services.

## Build locally

Use Godot 4.7.2 stable with its matching Web export templates. The build script checks the engine version. If `godot` is on `PATH`, the script uses it. Otherwise, on Linux x86_64 the script downloads the pinned Godot release and matching templates from the official Godot release hosts.

```sh
bash scripts/build_web.sh
```

The script imports project resources, exports the `Web` preset into `build/web`, and checks for non-empty `index.html`, `index.js`, `index.wasm`, and `index.pck`. `build/` is ignored by Git and is generated for each Render build. To serve the result locally over HTTP:

```sh
python3 -m http.server 8000 --directory build/web
```

Open `http://localhost:8000`. Directly opening `index.html` from disk is not a valid Web export check.

## Render Blueprint

The repository root `render.yaml` defines one static site:

- Build command: `bash scripts/build_web.sh`
- Publish directory: `build/web`
- Source branch: Render's linked Blueprint branch, normally `main`
- Auto deploy: each commit to the linked branch

Godot Web builds use the no-threads export preset. The build does not need Node.js, a start command, a service region, or a single page application rewrite. The exported game uses the root `index.html` and asset files; missing paths should remain 404s. Render's current Blueprint reference specifies a static site as `type: web` with `runtime: static`, `buildCommand`, and `staticPublishPath`.

## Render site and deployment

The `frozen-passage` static site has been created in **My Workspace** (`tea-d80bkebrjlhs73a68jgg`) and linked to `https://github.com/mayankjn99/caraxes`, branch `main`. It runs `bash scripts/build_web.sh` and publishes `build/web`. Auto deploy is enabled. The site URL is `https://frozen-passage.onrender.com`.

The first Render build checked out commit `05154666cae9d3b06ce6ba14a5c3ee9bcd92eb64` and failed because the Godot export-template URL returned HTTP 404. The local fix now uses Godot's official `downloads.godotengine.org` endpoint. Its headers return HTTP 200, the local macOS build and URL regression check pass, but the fix still needs to be pushed to `main` so Render can verify the Linux build path.

After the fix is pushed, Render should auto deploy. Check the deploy log/status and verify that `index.html`, `index.js`, `index.wasm`, and `index.pck` load successfully. Then the user should open the site, confirm the route and HUD at 960×540 and 640×360, and complete a keyboard traversal to “Passage complete!”. Record the deployed commit and test evidence in `docs/qa_report.md`.

Render automatically provides an HTTPS `onrender.com` URL and serves static sites over its global CDN. No custom domain, routing rule, or response header is required for this root-level Godot export. See [Render Static Sites](https://render.com/docs/static-sites) and the [Render Blueprint YAML Reference](https://render.com/docs/blueprint-spec).

## Current verification boundary

The initial GitHub push, local GUT/headless/Web export, disposable clean-clone build, and first Render failure are recorded in `docs/qa_report.md`. The template URL fix is local and unpushed. The Render service exists, but no successful deployment or browser playthrough is verified. Browser verification remains user-performed. Do not mark deployment acceptance complete until Render builds the fix, the published files are confirmed, and the user verifies the deployed traversal.
