#!/usr/bin/env bash
set -euo pipefail

RAREBOX_REPO="${1:-/Users/wren/nova/rarebox-main}"
PROFILE_NAME="rarebox"
PROFILE_DIR="$HOME/.hermes/profiles/$PROFILE_NAME"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

if ! command -v hermes >/dev/null 2>&1; then
  echo "hermes command not found. Install Hermes Agent first." >&2
  exit 1
fi

if [ ! -d "$RAREBOX_REPO" ]; then
  echo "Rarebox repo not found: $RAREBOX_REPO" >&2
  echo "Clone it first: git clone https://github.com/novaoc/rarebox.git $RAREBOX_REPO" >&2
  exit 1
fi

if [ ! -f "$RAREBOX_REPO/package.json" ]; then
  echo "Not a Rarebox/Vite repo: $RAREBOX_REPO/package.json missing" >&2
  exit 1
fi

if ! hermes profile list | awk '{print $1}' | grep -qx "$PROFILE_NAME"; then
  hermes profile create "$PROFILE_NAME" --clone --description "Focused Rarebox engineering agent. Maintains harness, specs, tests, review checklists, and development workflows for rarebox.io."
fi

rarebox config set terminal.backend local
rarebox config set terminal.cwd "$RAREBOX_REPO"

mkdir -p "$PROFILE_DIR/skills/rarebox-provider-integration"
cp "$ROOT_DIR/profile/SOUL.md" "$PROFILE_DIR/SOUL.md"
cp "$ROOT_DIR/skills/rarebox-provider-integration/SKILL.md" "$PROFILE_DIR/skills/rarebox-provider-integration/SKILL.md"

cp "$ROOT_DIR/repo/AGENTS.md" "$RAREBOX_REPO/AGENTS.md"
mkdir -p "$RAREBOX_REPO/scripts/evals"
cp -R "$ROOT_DIR/evals/." "$RAREBOX_REPO/scripts/evals/"
mkdir -p "$RAREBOX_REPO/scripts/smoke"
cp -R "$ROOT_DIR/smoke/." "$RAREBOX_REPO/scripts/smoke/"
mkdir -p "$RAREBOX_REPO/docs/harness/templates"
cp -R "$ROOT_DIR/templates/." "$RAREBOX_REPO/docs/harness/templates/"

ENV_FILE="$PROFILE_DIR/.env"
if [ -f "$ENV_FILE" ]; then
  tmp="$(mktemp)"
  awk '
    /^(TELEGRAM_|THREADS_|PARAGRAPH_|MOLTBOOK_)/ {
      split($0, kv, "=");
      print "# " kv[1] "= removed for rarebox engineering profile; configure a separate token if needed";
      next
    }
    { print }
  ' "$ENV_FILE" > "$tmp"
  mv "$tmp" "$ENV_FILE"
fi

node --input-type=module - "$RAREBOX_REPO/package.json" <<'NODE'
import fs from 'node:fs'
const path = process.argv[2]
const pkg = JSON.parse(fs.readFileSync(path, 'utf8'))
pkg.scripts ||= {}
if (!pkg.scripts['eval:harness']) {
  pkg.scripts['eval:harness'] = 'node scripts/evals/run-all.mjs'
  fs.writeFileSync(path, JSON.stringify(pkg, null, 2) + '\n')
  console.log('Added npm script: eval:harness')
} else {
  console.log('npm script already present: eval:harness')
}
if (!pkg.scripts['eval:danger']) {
  pkg.scripts['eval:danger'] = 'node scripts/evals/danger-zone.mjs'
  fs.writeFileSync(path, JSON.stringify(pkg, null, 2) + '\n')
  console.log('Added npm script: eval:danger')
} else {
  console.log('npm script already present: eval:danger')
}
if (!pkg.scripts['smoke:browser']) {
  pkg.scripts['smoke:browser'] = 'node scripts/smoke/browser-smoke.mjs'
  fs.writeFileSync(path, JSON.stringify(pkg, null, 2) + '\n')
  console.log('Added npm script: smoke:browser')
} else {
  console.log('npm script already present: smoke:browser')
}
NODE

echo "Installed Rarebox agent harness."
echo "Profile: $PROFILE_NAME"
echo "Profile dir: $PROFILE_DIR"
echo "Rarebox repo: $RAREBOX_REPO"
echo "Verify with: cd '$RAREBOX_REPO' && npm run eval:harness && npm run build"
echo "Run agent with: rarebox chat"
