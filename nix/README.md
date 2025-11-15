# Nix Configuration

This directory contains Nix Home Manager configuration for managing packages and development tools.

## Quick Start

### First Time Setup

1. **Install Nix** (if not already installed):
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

2. **Install and activate Home Manager**:
   ```bash
   cd ~/dotfiles/nix
   nix run home-manager/master -- switch --flake .#dominikgarciabertapelle
   ```

3. **Restart your shell**:
   ```bash
   exec fish
   ```

### Daily Usage

**Apply configuration changes:**
```bash
home-manager switch --flake ~/dotfiles/nix#dominikgarciabertapelle
```

**Update packages:**
```bash
nix flake update
home-manager switch --flake ~/dotfiles/nix#dominikgarciabertapelle
```

**Search for packages:**
```bash
nix search nixpkgs <package-name>
```

**Rollback if something breaks:**
```bash
home-manager switch --rollback
```

## File Structure

```
nix/
├── README.md              # This file - quick start guide
├── flake.nix             # Nix flake configuration
├── home.nix              # Home Manager package declarations
├── docs/
│   ├── SETUP.md          # Detailed setup instructions
│   └── MIGRATION.md      # Migration notes and troubleshooting
└── scripts/
    └── cleanup-homebrew.sh  # Clean up old Homebrew packages
```

## Adding/Removing Packages

### Add a package

1. Search for it:
   ```bash
   nix search nixpkgs <package-name>
   ```

2. Add to `home.nix`:
   ```nix
   home.packages = with pkgs; [
     # ... existing packages ...
     new-package-name
   ];
   ```

3. Apply changes:
   ```bash
   home-manager switch --flake ~/dotfiles/nix#dominikgarciabertapelle
   ```

### Remove a package

1. Remove from `home.nix`
2. Apply changes with the same command above

## Cleaning Up Homebrew

After Nix is working, clean up old Homebrew packages:

```bash
~/dotfiles/nix/scripts/cleanup-homebrew.sh
```

This will remove all CLI tools now managed by Nix, keeping only essential GUI apps in Homebrew.

## Documentation

- **[SETUP.md](docs/SETUP.md)** - Comprehensive setup guide, troubleshooting, and advanced usage
- **[MIGRATION.md](docs/MIGRATION.md)** - Migration notes from Homebrew, package lists, and decisions

## Helpful Commands

```bash
# List installed packages
nix-env -q

# Garbage collect old generations
nix-collect-garbage -d

# Check Home Manager generations
home-manager generations

# Test a package without installing
nix shell nixpkgs#<package-name>
```

## Resources

- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Package Search](https://search.nixos.org/packages)
- [Zero to Nix](https://zero-to-nix.com/)
