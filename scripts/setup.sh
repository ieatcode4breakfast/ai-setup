#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "==> Installing global gitignore..."
mkdir -p ~/.config/git
cp "$REPO_DIR/for-global-gitignore.txt" ~/.config/git/ignore
git config --global core.excludesFile ~/.config/git/ignore

echo "==> Done. Global gitignore installed at ~/.config/git/ignore"
echo "    opencode config is ready at $REPO_DIR/opencode.json"
echo ""
echo "    Next steps:"
echo "      1. Open this repo in opencode"
echo "      2. Default agent is 'plan' — switch with @build or @build-lite"
echo "      3. See AGENTS.md for the full rule set"
