# Homebrew to Nix Migration Notes

Complete record of the migration from Homebrew to Nix Home Manager.

## Current Setup

### What's in Homebrew (~/dotfiles/Brewfile)

**Minimal GUI Applications:**
- `ghostty` - Terminal emulator
- `leader-key` - Keyboard utility

### What's in Nix (~/dotfiles/nix/home.nix)

All CLI tools, development packages, and most GUI applications are now managed by Nix Home Manager.

#### Development Tools
- **Editors & Tools:** neovim, ast-grep
- **Shell utilities:** bat, fd, ripgrep, fzf, eza, lsd, yazi, zoxide, starship, atuin, sesh
- **File tools:** unar, w3m, wget, tree-sitter
- **Build tools:** gcc, llvm, autoconf, automake, cmake, fontforge
- **Data tools:** jq, yq-go, csvkit, pgcli

#### Version Control
- git, gh, lazygit, git-absorb, git-lfs, delta, gnupg, gnused

#### Language Runtimes & Tools
- **Python:** pyenv (manage all versions)
- **Node.js:** fnm (version manager), bun, pnpm
- **Go:** go
- **Lua:** luajit (provides lua binary), lua-language-server, luarocks
- **Other:** bash

#### Specialized Tools
- **Terminal:** tmux, ghostscript, ffmpeg, ffmpegthumbnailer, imagemagick
- **Infrastructure:** terraform, stow
- **Development:** efm-langserver, lazysql, kanata
- **System:** uv, avrdude, pigz, pinentry_mac, lf, ncdu

#### GUI Applications (in Nix)
- 1password-cli
- keycastr
- orbstack
- ice-bar (jordanbaird-ice)

## Migration Decisions

### Packages Kept in Homebrew

**GUI Applications:**
- `ghostty` - Works better via Homebrew cask
- `leader-key` - macOS-specific GUI tool

### Packages Removed or Handled Differently

#### Removed from Both (Not Needed)
- `bitwarden` - Not being used
- `github` (GitHub Desktop) - Not being used
- `qmk-toolbox` - Not being used
- `redis-stack` and related - Not being used
- Various custom tap packages (av, crush, graphite, sketchybar, skhd, idb-companion, qmk)
- Facebook libraries (folly, fizz, wangle, fbthrift, fb303, edencommon, mvfst)
- `openvino` - Intel OpenVINO toolkit (not needed)
- `rbenv` - Using pyenv instead

#### Removed Due to Build Issues
- `fish` shell - Test failures on macOS; install via Homebrew if needed: `brew install fish`
- `direnv` - Depends on fish; install via Homebrew if needed: `brew install direnv`

#### Supporting Libraries (Auto-Dependencies)
These were removed because Nix handles them automatically:
- `aom`, `jpeg`, `xz`, `zstd` - Video/image codecs
- `glib`, `gnutls`, `harfbuzz`, `leptonica` - System libraries
- `gdk-pixbuf`, `librsvg`, `gobject-introspection` - Graphics libraries
- `gpgme`, `guile` - Encryption/scripting libraries
- `libass`, `libffi`, `libheif`, `libidn2`, `libmicrohttpd` - Various libraries
- `librsvg`, `libyaml` - Data format libraries
- `pango`, `poppler`, `tesseract`, `unbound` - Text/PDF libraries

**Why removed:** In Nix, you only list the tools you directly use. Dependencies are automatically included by packages like ffmpeg, imagemagick, gnupg, etc.

#### Version Manager Changes
- **Python:** Removed `python310`, `python311`, `python39` - using `pyenv` exclusively
- **Ruby:** Removed `rbenv` - not needed (keeping pyenv and fnm)
- **Node.js:** Kept `fnm` for version management
- **Lua:** Removed standalone `lua`, kept `luajit` (backwards compatible and faster)

### Package Name Changes (Homebrew → Nix)

- `exa` → `eza` (exa was deprecated)
- `gnu-sed` → `gnused`
- `yq` → `yq-go`
- `1password-cli` → `_1password-cli`
- `jordanbaird-ice` → `ice-bar`

### Configuration Notes

#### Unfree Packages
Configuration allows unfree packages (`nixpkgs.config.allowUnfree = true`) for:
- Terraform (BSL 1.1 license)
- Potentially other tools like VS Code, Chrome if added later

#### Fonts
Nerd fonts removed from Homebrew (previously managed via `homebrew/cask-fonts` tap):
- `font-commit-mono-nerd-font`
- `font-fira-code-nerd-font`

These can be added to Nix if needed:
```nix
home.packages = with pkgs; [
  (nerdfonts.override { fonts = [ "CommitMono" "FiraCode" ]; })
];
```

## Migration Process

### Phase 1: Setup (Completed)
1. ✅ Generated Brewfile baseline
2. ✅ Created Nix flake configuration
3. ✅ Created Home Manager configuration
4. ✅ Updated Fish shell configuration
5. ✅ Documented all decisions

### Phase 2: Installation (Current)
1. Install Nix with flakes
2. Activate Home Manager
3. Verify all packages work

### Phase 3: Cleanup (After Verification)
Run the cleanup script to remove old Homebrew packages:

```bash
~/dotfiles/nix/scripts/cleanup-homebrew.sh
```

This will:
- Remove all CLI formulas (now in Nix)
- Remove unused GUI apps
- Remove all custom taps
- Keep only ghostty and leader-key in Homebrew

### Phase 4: Maintenance (Ongoing)
- Update packages: `nix flake update && home-manager switch --flake ~/dotfiles/nix#dominikgarciabertapelle`
- Add new packages as needed to `home.nix`
- Keep Homebrew minimal (just ghostty and leader-key)

## Package Count Summary

**Before Migration (Homebrew):**
- 275 formulas (CLI tools)
- 15 casks (GUI apps)
- 30+ custom taps

**After Migration:**
- **Nix:** ~70 packages (all CLI tools + some GUI apps)
- **Homebrew:** 2 casks (ghostty, leader-key)
- **Taps:** 0 (all removed)

## Known Issues & Workarounds

### 1. Fish Shell Build Failure
**Issue:** Fish tests fail on macOS in Nix
**Workaround:** Install via Homebrew: `brew install fish`
**Note:** Keep Homebrew fish for now; Nix team is working on macOS test fixes

### 2. Direnv Dependency
**Issue:** Direnv depends on fish, which has build issues
**Workaround:** Install via Homebrew: `brew install direnv`
**Alternative:** Wait for fish to be fixed in Nix

### 3. Library Conflicts
**Issue:** Explicitly listing libraries (gdk-pixbuf, librsvg) causes conflicts
**Solution:** Remove all library packages; they're auto-included as dependencies
**Lesson:** Only list tools you directly use in Nix

### 4. Lua/LuaJIT Conflict
**Issue:** Both `lua` and `luajit` provide the `lua` binary
**Solution:** Keep only `luajit` (faster and backwards compatible)
**Note:** LuaJIT works with neovim and other Lua tools

## Troubleshooting Reference

### Build Errors
If a package fails to build:
1. Check if it's a library (remove it if so)
2. Search if others have the issue: https://github.com/NixOS/nixpkgs/issues
3. Try a workaround (e.g., `doCheck = false` for test failures)
4. Fall back to Homebrew if needed

### Package Not Found
If `nix search` doesn't find a package:
1. Try different search terms
2. Check online: https://search.nixos.org/packages
3. Package might have a different name in Nix
4. Consider installing via Homebrew if not available

### PATH Issues
If packages aren't being found:
1. Restart shell: `exec fish`
2. Check Home Manager is active: `ls -la ~/.nix-profile`
3. Verify PATH: `echo $PATH | tr ':' '\n'`

## Quick Command Reference

```bash
# Apply configuration changes
home-manager switch --flake ~/dotfiles/nix#dominikgarciabertapelle

# Update all packages
nix flake update
home-manager switch --flake ~/dotfiles/nix#dominikgarciabertapelle

# Search for packages
nix search nixpkgs <name>

# Test a package without installing
nix shell nixpkgs#<package-name>

# Rollback if something breaks
home-manager switch --rollback

# Garbage collect old generations
nix-collect-garbage -d

# List what's installed
nix-env -q

# Check generations
home-manager generations
```

## Future Improvements

Potential enhancements:
1. Add nix-darwin for system-level configuration
2. Re-enable fish and direnv when Nix fixes are available
3. Consider moving all GUI apps to Nix when stable
4. Add Nix fonts when needed
5. Create development shells for projects
6. Use direnv for per-project environments

## Resources

- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Package Search](https://search.nixos.org/packages)
- [Nixpkgs GitHub Issues](https://github.com/NixOS/nixpkgs/issues)
- [Home Manager Issues](https://github.com/nix-community/home-manager/issues)
- [Zero to Nix](https://zero-to-nix.com/)
