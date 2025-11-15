#!/bin/bash
# Homebrew Cleanup Script
# This script removes packages that have been migrated to Nix or are no longer needed

echo "🧹 Homebrew Cleanup Script"
echo "This will uninstall Homebrew packages that are now managed by Nix or no longer needed."
echo ""

read -p "Do you want to proceed? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 1
fi

echo ""
echo "Removing GUI applications (casks) that are no longer needed..."

# GUI apps to remove (now managed by Nix)
casks_to_remove=(
    "1password-cli"
    "bitwarden"
    "font-commit-mono-nerd-font"
    "font-fira-code-nerd-font"
    "github"
    "jordanbaird-ice"
    "keycastr"
    "loop"
    "orbstack"
    "qmk-toolbox"
    "redis-stack"
    "redis-stack-redisinsight"
    "redis-stack-server"
)

for cask in "${casks_to_remove[@]}"; do
    if brew list --cask "$cask" &>/dev/null; then
        echo "  Removing $cask..."
        brew uninstall --cask "$cask" 2>/dev/null || echo "    (already removed or not installed)"
    fi
done

echo ""
echo "Removing CLI tools (formulas) now managed by Nix..."

# All formulas should be removed since they're now in Nix
# Get list of all installed formulas and remove them
all_formulas=$(brew list --formula 2>/dev/null)

if [ -n "$all_formulas" ]; then
    echo "  Found $(echo "$all_formulas" | wc -l | xargs) formulas to remove"
    echo "  This may take a while..."
    echo "$all_formulas" | while read formula; do
        echo "  Removing $formula..."
        brew uninstall "$formula" 2>/dev/null || echo "    (skipped)"
    done
else
    echo "  No formulas found to remove"
fi

echo ""
echo "Removing unused taps..."

# Custom taps to remove
taps_to_remove=(
    "1password/tap"
    "arl/arl"
    "aviator-co/tap"
    "camspiers/taps"
    "charmbracelet/tap"
    "dmnkgrc/siu"
    "ellie/atuin"
    "epk/epk"
    "facebook/fb"
    "felixkratz/formulae"
    "fsouza/prettierd"
    "hashicorp/tap"
    "helix-editor/helix"
    "heroku/brew"
    "homebrew/cask-fonts"
    "homebrew/cask-versions"
    "homebrew/services"
    "jorgerojas26/lazysql"
    "joshmedeski/sesh"
    "koekeishiya/formulae"
    "mobile-dev-inc/tap"
    "mrkai77/cask"
    "nikitabobko/tap"
    "opencode-ai/tap"
    "osx-cross/arm"
    "osx-cross/avr"
    "oven-sh/bun"
    "qmk/qmk"
    "redis-stack/redis-stack"
    "sourcegraph/src-cli"
    "withgraphite/tap"
    "wix/brew"
)

for tap in "${taps_to_remove[@]}"; do
    if brew tap | grep -q "^$tap\$"; then
        echo "  Removing tap $tap..."
        brew untap "$tap" 2>/dev/null || echo "    (already removed)"
    fi
done

echo ""
echo "Running Brew cleanup to free up space..."
brew cleanup -s
brew autoremove

echo ""
echo "✅ Cleanup complete!"
echo ""
echo "Summary:"
echo "  - Removed GUI apps that are now managed by Nix"
echo "  - Removed all CLI formulas (now managed by Nix)"
echo "  - Removed unused taps (including cask-fonts)"
echo ""
echo "Homebrew is still installed and managing only:"
echo "  - ghostty (terminal emulator)"
echo "  - leader-key (keyboard utility)"
echo ""
echo "Everything else (CLI tools, fonts, other GUI apps) is now managed by Nix!"
echo ""
echo "To verify what's still installed:"
echo "  brew list --cask"
