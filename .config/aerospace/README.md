# AeroSpace setup

Config: `~/.config/aerospace/aerospace.toml`

## Current status

AeroSpace 0.21.3-Beta is installed. Laptop-sized accordion stacks and the original shortcuts were loaded. The new Deezer, Telegram, and Option+0 shortcuts are saved but need a config reload. The adaptive watcher is not running. The saved config disables startup automation and login startup because live layout tests repeatedly interrupted Pi while resizing its terminal. The cause of the Pi crashes has not been established.

The laptop terminal was measured at the full usable width, 1512 points. Six file-only tests, Python compilation, and whitespace checks pass. No Python linter or formatter was available. The config passed AeroSpace's dry-run validator. Ultrawide geometry and physical monitor hot-plug transitions remain unverified. Do not enable the watcher until you can test without an active Pi session in a managed terminal.

## Intended automatic behavior

- Laptop or one ordinary display: browser windows use B, terminal/editor/Conductor use T, other normal windows use W. Each stack shows one full-size window at a time.
- Ultrawide: B contains two equal-width columns. Helium windows stack on the left. Kitty, Ghostty, Terminal, iTerm2, Zed, and Conductor stack on the right. Extra windows do not add columns. Other apps use full-size W.
- Two external monitors: B goes to the leftmost external display, T to the rightmost. Each window fills its display. An open laptop is not counted as one of these two external displays.
- One ordinary external monitor plus the laptop: B and T use the leftmost and rightmost displays according to macOS display arrangement.
- One ultrawide plus the laptop: the two columns use the ultrawide.

Dialogs and other windows AeroSpace classifies as floating stay floating. Full-size means maximized within the usable desktop, not native macOS fullscreen Spaces. If only one column has windows, it fills the screen until the other group has a window.

The helper checks every two seconds. Newly opened windows can briefly appear on B or T before regrouping. Ultrawide detection uses an aspect ratio of at least 2.2. Change `ULTRAWIDE_RATIO` in `adaptive.py` if needed. A resolution-only change on the same display requires a reset.

## Shortcuts

`Alt` means the Mac Option key. Command shortcuts inside apps are unchanged.

| Shortcut | Action |
| --- | --- |
| Option+h / l | Focus left / right, including another display |
| Option+j / k | Next / previous window in a vertical stack |
| Option+b | Focus Helium, or launch it |
| Option+t | Focus a terminal, or launch Kitty |
| Option+c | Focus Conductor, or launch it |
| Option+m | Activate Deezer, or launch it |
| Option+w | Activate Telegram, or launch it |
| Option+0 | Other apps on W |
| Option+1 / 2 / 3 | Scratch workspaces |
| Option+Shift+1 / 2 / 3 / w | Move the window there and follow it |
| Option+Tab | Previous workspace |
| Option+f | Toggle AeroSpace fullscreen |
| Option+Shift+f | Toggle floating |
| Option+Shift+semicolon, then Escape | Reload config |
| Option+Shift+semicolon, then r | Request a layout rebuild, if the watcher is running |

Moving a browser or development window to a scratch workspace excludes it from automatic regrouping. A newly opened window still follows its app's default rule.

## Test safely

File-only checks do not move windows:

```sh
cd ~/.config/aerospace
/usr/bin/python3 -m unittest -v
/usr/bin/python3 -m py_compile adaptive.py test_adaptive.py
```

After leaving Pi, start the helper from a separate terminal only when ready for windows to move:

```sh
/usr/bin/python3 ~/.config/aerospace/adaptive.py --watch
```

Stop this foreground helper with Control+C. Test the laptop, connect the ultrawide, open an extra browser and terminal window, then test the two-display setup. Confirm 50/50 widths, stack switching, and that unrelated apps stay full-size. A normal app's minimum width can prevent a requested split on a small display, so do not simulate an ultrawide on the laptop.

Once those checks pass, replace the two startup settings in `aerospace.toml` with:

```toml
start-at-login = true
after-startup-command = ['exec-and-forget /usr/bin/python3 ~/.config/aerospace/adaptive.py --watch >> ~/Library/Logs/aerospace-adaptive.log 2>&1']
```

Reload the config and restart AeroSpace outside Pi. Reloading alone does not run the startup callback. A file lock prevents duplicate watchers. The watcher exits if AeroSpace is no longer running.

## Undo

Quit AeroSpace from its menu before restoring the old file:

```sh
cp ~/.local/state/aerospace/backup-20260908-112624/aerospace.toml ~/.config/aerospace/aerospace.toml
```

The same backup folder contains the original window-to-workspace listing. Restoring the config does not restore window placements that were already changed. No apps or windows were intentionally closed during setup.
