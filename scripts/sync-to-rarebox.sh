#!/usr/bin/env bash
set -euo pipefail

RAREBOX_REPO="${1:-/Users/wren/nova/rarebox-main}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

if [ ! -d "$RAREBOX_REPO" ]; then
  echo "Rarebox repo not found: $RAREBOX_REPO" >&2
  exit 1
fi

cp "$ROOT_DIR/repo/AGENTS.md" "$RAREBOX_REPO/AGENTS.md"
mkdir -p "$RAREBOX_REPO/scripts/evals" "$RAREBOX_REPO/scripts/smoke" "$RAREBOX_REPO/docs/harness/templates"
cp -R "$ROOT_DIR/evals/." "$RAREBOX_REPO/scripts/evals/"
cp -R "$ROOT_DIR/smoke/." "$RAREBOX_REPO/scripts/smoke/"
cp -R "$ROOT_DIR/templates/." "$RAREBOX_REPO/docs/harness/templates/"

echo "Synced AGENTS.md, evals, smoke tests, and templates from rebuild kit into $RAREBOX_REPO."
