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

1. Put this project in the GitHub repository and branch you intend to deploy. This workspace has no Git remote or commit. The connected GitHub account has an existing `mayankjn99/caraxes` repository, but its current contents are only a README and LICENSE; verify that this is the intended repository before using it.
2. In the Render dashboard, select the **My Workspace** workspace and create a Blueprint instance from that repository's branch. Review the proposed `frozen-passage` static site and confirm the plan before creating resources.
3. Render reads `render.yaml`, builds the Web export, and publishes `build/web`. Check the build log and deployment status, then open the resulting HTTPS `onrender.com` URL.
4. Verify that `index.html`, `index.js`, `index.wasm`, and `index.pck` load successfully, the game starts, the route and HUD remain visible at 960×540 and 640×360, and a complete keyboard traversal reaches “Passage complete!”. Record the deployed URL and evidence in `docs/qa_report.md`.

Render automatically provides an HTTPS `onrender.com` URL and serves static sites over its global CDN. No custom domain, routing rule, or response header is required for this root-level Godot export. See [Render Static Sites](https://render.com/docs/static-sites) and the [Render Blueprint YAML Reference](https://render.com/docs/blueprint-spec).

## Current verification boundary

Local GUT, headless launch, and Web export checks are recorded in `docs/qa_report.md`. Browser operations are performed by the user. A pushed repository, Render static-site resource, deployed URL, and deployed traversal verification are not yet available; do not mark the deployment acceptance criteria complete until those checks are recorded.
