# Nix Home Manager Setup Guide

Complete guide for setting up and using Nix Home Manager to manage packages and dotfiles.

## Prerequisites

- macOS (Apple Silicon or Intel)
- Admin access to install software

## Installation Steps

### 1. Install Nix with Flakes Support

**Recommended: Determinate Systems installer** (includes flakes by default):

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

**Alternative: Official Nix installer**:

```bash
sh <(curl -L https://nixos.org/nix/install)
```

If using the official installer, enable flakes by creating `~/.config/nix/nix.conf`:
```
experimental-features = nix-command flakes
```

### 2. Restart Your Shell

After installing Nix, restart your shell or source the Nix profile:

```bash
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

Or simply restart your terminal:
```bash
exec fish
```

### 3. Build and Activate Home Manager

From the dotfiles/nix directory:

```bash
cd ~/dotfiles/nix
nix run home-manager/master -- switch --flake .#dominikgarciabertapelle
```

This will:
- Download and build all packages defined in `home.nix`
- Create symlinks in your home directory
- Set up environment variables
- **Note:** First run may take 15-30 minutes

### 4. Update Your Shell

After the first activation, restart your shell for PATH changes to take effect:

```bash
exec fish
```

Home Manager will automatically add its packages to your PATH.

## Verifying the Installation

Check that Nix-installed packages are being used:

```bash
which nvim
# Should show: /nix/store/.../bin/nvim

which git
# Should show: /nix/store/.../bin/git

echo $PATH | tr ':' '\n'
# Nix paths should appear before Homebrew paths
```

## Managing Packages

### Adding a Package

1. Search for the package:
   ```bash
   nix search nixpkgs <package-name>
   ```

2. Edit `home.nix` and add the package to `home.packages`:
   ```nix
   home.packages = with pkgs; [
     # ... existing packages ...
     new-package-name
   ];
   ```

3. Apply the changes:
   ```bash
   home-manager switch --flake ~/dotfiles/nix#dominikgarciabertapelle
   ```

### Removing a Package

1. Remove the package from `home.packages` in `home.nix`
2. Run:
   ```bash
   home-manager switch --flake ~/dotfiles/nix#dominikgarciabertapelle
   ```

### Searching for Packages

**Command line:**
```bash
nix search nixpkgs <package-name>
```

**Online:** https://search.nixos.org/packages

**Note:** Package names in Nix sometimes differ from Homebrew:
- `gnu-sed` → `gnused`
- `yq` → `yq-go`
- `exa` → `eza` (exa was deprecated)

### Updating Packages

Update the flake inputs and rebuild:

```bash
cd ~/dotfiles/nix
nix flake update
home-manager switch --flake .#dominikgarciabertapelle
```

## Configuration Structure

### flake.nix

Defines the Nix flake with Home Manager inputs:
- Tracks nixpkgs and home-manager versions
- Specifies system architecture (aarch64-darwin for Apple Silicon)
- Points to `home.nix` for package configuration

### home.nix

Main configuration file containing:
- User information
- Package list (`home.packages`)
- Home Manager settings
- Session variables
- Allows unfree packages (needed for Terraform, etc.)

## Troubleshooting

### Packages Not Found in PATH

If Nix packages aren't being found:

1. Check that Home Manager is activated:
   ```bash
   ls -la ~/.nix-profile
   ```

2. Restart your shell:
   ```bash
   exec fish
   ```

3. Verify PATH:
   ```bash
   echo $PATH | tr ':' '\n'
   ```

### Package Not Available

If a package isn't available in nixpkgs:

1. Search online: https://search.nixos.org/packages
2. Check if it's under a different name
3. If not available, keep in Homebrew or install manually

### Build Failures

Some packages may fail to build on macOS. Common issues:

- **Tests failing**: Some packages have flaky tests on macOS
- **Solution**: Override with `doCheck = false` (see fish example in migration history)
- **Dependency conflicts**: Remove explicitly listed libraries (Nix handles dependencies automatically)

### Rollback Changes

If something breaks, Home Manager keeps previous generations:

```bash
# List generations
home-manager generations

# Rollback to previous generation
home-manager switch --rollback
```

### Flake Lock Issues

If you see caching issues:

```bash
# Update flake lock
nix flake update

# Force refresh
home-manager switch --flake ~/dotfiles/nix#dominikgarciabertapelle --refresh
```

## Useful Commands

```bash
# Switch to new configuration
home-manager switch --flake ~/dotfiles/nix#dominikgarciabertapelle

# Update all packages
nix flake update && home-manager switch --flake ~/dotfiles/nix#dominikgarciabertapelle

# List installed packages
nix-env -q

# Check generations
home-manager generations

# Rollback
home-manager switch --rollback

# Garbage collect old generations
nix-collect-garbage -d

# Test a package without installing
nix shell nixpkgs#<package-name>

# Search packages
nix search nixpkgs <name>
```

## Advanced Usage

### Per-Project Environments

Use `nix-shell` or `nix develop` for project-specific environments:

```bash
# Create a shell.nix or flake.nix in your project
nix-shell  # or nix develop

# Example shell.nix:
{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    nodejs_20
    python311
  ];
}
```

### Using direnv with Nix

If you reinstall direnv (via Homebrew or later when it works in Nix):

```bash
# In your project:
echo "use nix" > .envrc
direnv allow
```

### Unfree Packages

Some packages have non-free licenses. The configuration already allows unfree packages via:

```nix
nixpkgs.config.allowUnfree = true;
```

This is needed for packages like:
- Terraform
- VS Code (if added)
- Chrome (if added)

## Resources

- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Package Search](https://search.nixos.org/packages)
- [Nix Pills (Tutorial)](https://nixos.org/guides/nix-pills/)
- [Zero to Nix](https://zero-to-nix.com/)
- [Nix Darwin (system-level config)](https://github.com/LnL7/nix-darwin)

## Getting Help

- Check the [troubleshooting section](#troubleshooting) above
- Search the [Nix Discourse](https://discourse.nixos.org/)
- Check [Home Manager issues](https://github.com/nix-community/home-manager/issues)
- Review [MIGRATION.md](MIGRATION.md) for package-specific notes
