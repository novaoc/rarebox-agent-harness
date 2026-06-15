#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 /absolute/path/to/rarebox" >&2
  exit 2
fi
RAREBOX_REPO="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

if [ ! -d "$RAREBOX_REPO" ]; then
  echo "Rarebox repo not found: $RAREBOX_REPO" >&2
  exit 1
fi

cp "$RAREBOX_REPO/AGENTS.md" "$ROOT_DIR/repo/AGENTS.md"
mkdir -p "$ROOT_DIR/evals" "$ROOT_DIR/smoke" "$ROOT_DIR/templates"
cp -R "$RAREBOX_REPO/scripts/evals/." "$ROOT_DIR/evals/"
cp -R "$RAREBOX_REPO/scripts/smoke/." "$ROOT_DIR/smoke/"
cp -R "$RAREBOX_REPO/docs/harness/templates/." "$ROOT_DIR/templates/"

echo "Synced AGENTS.md, evals, smoke tests, and templates from $RAREBOX_REPO into rebuild kit."
