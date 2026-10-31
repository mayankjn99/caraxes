#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_SCRIPT="$SCRIPT_DIR/../../scripts/build_web.sh"

EXPECTED_URL='https://downloads.godotengine.org/?flavor=stable&platform=templates&slug=export_templates.tpz&version=${GODOT_VERSION}'

if ! grep -Fq "$EXPECTED_URL" "$BUILD_SCRIPT"; then
	echo "build_web.sh must download export templates from the official Godot release endpoint." >&2
	exit 1
fi

echo "Official Godot export-template download URL is configured."
