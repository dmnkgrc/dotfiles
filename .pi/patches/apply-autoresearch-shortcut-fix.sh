#!/usr/bin/env bash
# Resolves Pi warning: ctrl+shift+t registered by both pi-themes and pi-autoresearch.
# Keeps pi-themes on Ctrl+Shift+T (cycle themes); moves autoresearch dashboard toggle to Ctrl+Shift+D.

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
# Dotfiles layout: .pi/patches/this.sh → .pi/agent/git/github.com/davebcn87/pi-autoresearch
REPO_DOTFILES="$(cd "$SCRIPT_DIR/.." && pwd)/agent/git/github.com/davebcn87/pi-autoresearch"
REPO_HOME="${HOME}/.pi/agent/git/github.com/davebcn87/pi-autoresearch"
if [[ -f "$REPO_DOTFILES/extensions/pi-autoresearch/index.ts" ]]; then
  REPO="$REPO_DOTFILES"
elif [[ -f "$REPO_HOME/extensions/pi-autoresearch/index.ts" ]]; then
  REPO="$REPO_HOME"
else
  echo "Expected pi-autoresearch at one of:" >&2
  echo "  $REPO_DOTFILES" >&2
  echo "  $REPO_HOME" >&2
  echo "See: $(cd "$SCRIPT_DIR/.." && pwd)/agent/git/github.com/davebcn87/README.md" >&2
  exit 1
fi
IDX="$REPO/extensions/pi-autoresearch/index.ts"

perl -pi -e 's/ctrl\+shift\+t/ctrl+shift+d/g' "$IDX"
perl -pi -e 's/Ctrl\+Shift\+T/Ctrl+Shift+D/g' "$IDX"

if [[ -f "$REPO/README.md" ]]; then
  perl -pi -e 's/Ctrl\+Shift\+T/Ctrl+Shift+D/g' "$REPO/README.md"
fi
if [[ -f "$REPO/skills/autoresearch-create/SKILL.md" ]]; then
  perl -pi -e 's/Dashboard: ctrl\+shift\+t\./Dashboard: ctrl+shift+d./g' "$REPO/skills/autoresearch-create/SKILL.md"
fi

echo "Updated autoresearch shortcuts in $REPO"
echo "Restart Pi. Dashboard toggle: Ctrl+Shift+D  •  Theme cycle (pi-themes): Ctrl+Shift+T"
