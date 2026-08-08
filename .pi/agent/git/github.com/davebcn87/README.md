# Pi `git:` package checkouts

Pi clones `git:github.com/owner/repo` into `agent/git/github.com/owner/repo/` next to your agent config.

To keep **pi-autoresearch** in this dotfiles tree (so `~/.pi` → `…/dotfiles/.pi` sees it), clone into `pi-autoresearch/` next to this file:

```bash
# This file lives at: …/.pi/agent/git/github.com/davebcn87/README.md
# DEST must be the sibling directory `pi-autoresearch/` (Pi’s expected clone root).
DEST="$(cd "$(dirname "$0")" && pwd)/pi-autoresearch"
rm -rf "$DEST"
git clone https://github.com/davebcn87/pi-autoresearch.git "$DEST"
```

Then apply the **Ctrl+Shift+D** dashboard shortcut (avoids conflict with **pi-themes** on Ctrl+Shift+T). From your dotfiles `.pi` tree:

```bash
./patches/apply-autoresearch-shortcut-fix.sh
```

That script prefers this tree’s `agent/git/.../pi-autoresearch` checkout and falls back to `$HOME/.pi/agent/git/...` if needed.

Restart Pi after patching.
