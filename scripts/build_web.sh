#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GODOT_VERSION="4.7.2"

if [[ -n "${GODOT_BIN:-}" ]]; then
	GODOT_CMD="$GODOT_BIN"
elif command -v godot >/dev/null 2>&1; then
	GODOT_CMD="$(command -v godot)"
else
	if [[ "$(uname -s)" != "Linux" || "$(uname -m)" != "x86_64" ]]; then
		echo "Godot is not installed; automatic download supports Linux x86_64 only." >&2
		exit 1
	fi

	TOOLS_DIR="$(mktemp -d)"
	trap 'rm -rf "$TOOLS_DIR"' EXIT
	GODOT_ARCHIVE="$TOOLS_DIR/godot.zip"
	TEMPLATES_ARCHIVE="$TOOLS_DIR/export_templates.tpz"
	GODOT_CMD="$TOOLS_DIR/Godot_v${GODOT_VERSION}-stable_linux.x86_64"

	curl --fail --location --silent --show-error \
		"https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-stable/Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip" \
		--output "$GODOT_ARCHIVE"
	curl --fail --location --silent --show-error \
		"https://downloads.godotengine.org/?flavor=stable&platform=templates&slug=export_templates.tpz&version=${GODOT_VERSION}" \
		--output "$TEMPLATES_ARCHIVE"
	unzip -q "$GODOT_ARCHIVE" -d "$TOOLS_DIR"
	chmod +x "$GODOT_CMD"
	mkdir -p "$TOOLS_DIR/templates/${GODOT_VERSION}.stable"
	unzip -q "$TEMPLATES_ARCHIVE" -d "$TOOLS_DIR/templates"
	GODOT_TEMPLATE_DIR="$HOME/.local/share/godot/export_templates/${GODOT_VERSION}.stable"
	mkdir -p "$GODOT_TEMPLATE_DIR"
	cp "$TOOLS_DIR/templates/templates"/* "$GODOT_TEMPLATE_DIR/"
fi

ACTUAL_GODOT_VERSION="$("$GODOT_CMD" --version)"
if [[ "$ACTUAL_GODOT_VERSION" != "$GODOT_VERSION"* ]]; then
	echo "Expected Godot ${GODOT_VERSION}; found ${ACTUAL_GODOT_VERSION}." >&2
	exit 1
fi

"$GODOT_CMD" --headless --editor --path "$ROOT_DIR" --import --quit
mkdir -p "$ROOT_DIR/build/web"
"$GODOT_CMD" --headless --path "$ROOT_DIR" --export-release Web "$ROOT_DIR/build/web/index.html"

for required_file in index.html index.js index.wasm index.pck; do
	if [[ ! -s "$ROOT_DIR/build/web/$required_file" ]]; then
		echo "Expected Web export file is missing or empty: build/web/$required_file" >&2
		exit 1
	fi
done
