# Neovim configuration

A modular Neovim 0.12 configuration using the built-in `vim.pack` package manager.

## Requirements

- Neovim 0.12 or newer
- `git`, `make`, a C compiler, and `unzip`
- `rg` for search
- A Nerd Font (optional, for icons)
- Language runtimes for the projects you edit:
  - Node.js for TypeScript/JavaScript tooling
  - Go for `gofmt`
  - Rust (via `rustup`) for `rustfmt`
  - Ruby for `rubocop`

Mason provisions portable editor tooling: LSP servers plus `stylua`, `shfmt`, `oxfmt`, `goimports`, and `ruff`. It checks at most once per 24 hours; run `:MasonToolsInstall` to install missing tools now or `:MasonToolsUpdate` to update them. Project runtimes own `gofmt`, `rustfmt`, and `rubocop`.

## Layout

- `init.lua` — startup entry point
- `lua/config/` — options, mappings, autocmds, and native package lifecycle
- `lua/plugins/` — isolated plugin configuration
- `nvim-pack-lock.json` — exact package revisions, tracked in Git

## First launch

Start Neovim normally:

```sh
nvim
```

`vim.pack` installs packages recorded in `nvim-pack-lock.json`. Mason then installs its managed tools in the background.

## Updating packages

1. Run `:lua vim.pack.update()`.
2. Review the confirmation buffer.
3. Write it with `:write` to accept, or quit it with `:quit` to discard.
4. Restart Neovim and verify with `:checkhealth vim.pack`.
5. Commit the configuration change and `nvim-pack-lock.json` together.

Do not edit the lockfile manually.

## Synchronizing another machine

After pulling configuration and lockfile changes, restart Neovim and run:

```vim
:lua vim.pack.update(nil, { target = "lockfile" })
```

Review and write the confirmation buffer to install the revisions from the lockfile. Plugins removed from the configuration can be removed explicitly with `vim.pack.del()` after confirming they are not used by another profile.

## Rolling back an update

Restore the desired `nvim-pack-lock.json` revision, restart Neovim, then run:

```vim
:lua vim.pack.update(nil, { offline = true, target = "lockfile" })
```

Review and write the confirmation buffer.

## Herdr integration

Inside a Herdr session (`HERDR_ENV=1`), the configuration uses `herdr-splits.nvim`; outside one it uses `smart-splits.nvim`.

- `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>` move between splits and Herdr panes.
- `<Alt-h>`, `<Alt-j>`, `<Alt-k>`, `<Alt-l>` resize splits and Herdr panes.

The Herdr-side `herdr-splits` plugin must be installed and its matching key actions configured in Herdr. Verify the Neovim half with:

```vim
:checkhealth herdr-splits
```

## Health checks

Use these commands after upgrades or when diagnosing editor tooling:

```vim
:checkhealth vim.pack
:checkhealth mason
:MasonToolsInstall
:checkhealth herdr-splits
```
