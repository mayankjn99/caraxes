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

## Connect and deploy

1. The selected source is `mayankjn99/caraxes`, branch `main`. The local branch has a project commit and a merge commit preserving GitHub's existing initial commit, README, and MIT license. Push it with `git push origin main`; Render cannot read the local checkout before that push.
2. In the Render dashboard, select **My Workspace** and create a Blueprint instance from `main`. Review the proposed `frozen-passage` static site before creating the resource. The workspace has no Frozen Passage service; existing services are unrelated.
3. Render reads `render.yaml`, builds the Web export, and publishes `build/web`. Check the build log and deployment status, then open the resulting HTTPS `onrender.com` URL.
4. Verify that `index.html`, `index.js`, `index.wasm`, and `index.pck` load successfully, the game starts, the route and HUD remain visible at 960×540 and 640×360, and a complete keyboard traversal reaches “Passage complete!”. Record the deployed URL and evidence in `docs/qa_report.md`.

Render automatically provides an HTTPS `onrender.com` URL and serves static sites over its global CDN. No custom domain, routing rule, or response header is required for this root-level Godot export. See [Render Static Sites](https://render.com/docs/static-sites) and the [Render Blueprint YAML Reference](https://render.com/docs/blueprint-spec).

## Current verification boundary

Local GUT, headless launch, Web export, and disposable clean-clone build are recorded in `docs/qa_report.md`. The selected repository has not been pushed, and no Frozen Passage Render resource or deployed URL exists. Browser verification remains user-performed. Do not mark deployment acceptance complete until the pushed branch, Render build, deployed files, and traversal checks are recorded.
