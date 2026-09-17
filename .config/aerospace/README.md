# AeroSpace setup

Config: `~/.config/aerospace/aerospace.toml`

## Current status

AeroSpace 0.21.3-Beta and the adaptive watcher are running. Login startup and automatic display switching are enabled. All shortcuts below are loaded; Option+Tab is released.

Verified on the Dell U3425WE at 3440×1440: both Helium windows have x=0 and width=1720; Conductor and Kitty both have x=1720 and width=1720. Each column uses a vertical accordion stack. The laptop terminal was previously measured at the full usable width, 1512 points. Eleven file-only tests, Python compilation, and the config dry-run pass. ChatGPT's routing is covered by those tests; its window was no longer open at the final live check. No Python linter or formatter was available. Physical two-monitor placement and unplug/replug transitions still need testing.

Earlier simulated layout tests interrupted Pi while resizing its terminal. The cause of those crashes has not been established. Avoid simulated ultrawide layouts on the laptop.

## Intended automatic behavior

- Laptop or one ordinary display: browser windows use B, terminal/editor/Conductor/ChatGPT/T3 Code use T, other normal windows use W. Each stack shows one full-size window at a time.
- Ultrawide: B contains two equal-width columns. Helium windows stack on the left. Kitty, Ghostty, Terminal, iTerm2, Zed, Conductor, ChatGPT, ChatGPT Classic, and T3 Code stack on the right. Extra windows do not add columns. Other apps use full-size W.
- Two external monitors: B goes to the leftmost external display, T to the rightmost. Each window fills its display. An open laptop is not counted as one of these two external displays.
- One ordinary external monitor plus the laptop: B and T use the leftmost and rightmost displays according to macOS display arrangement.
- One ultrawide plus the laptop: the two columns use the ultrawide.

Slack floats on the terminal/Conductor workspace: B on the ultrawide, T on the laptop or dual displays. Its size is preserved, and moving it does not rebuild the tiled stacks. On the ultrawide it belongs to the shared workspace, not a particular column; position it wherever useful. Its current floating size was verified unchanged at 1312×977.

System Settings and Activity Monitor float by default without forced workspace assignment or size rules. Finder, Deezer, Telegram, and WhatsApp float and follow the focused workspace, so focusing them does not switch away from B or T. AeroSpace may restore a previously remembered floating size when an existing tiled window is converted. Dialogs and other windows AeroSpace classifies as floating also stay floating. Full-size means maximized within the usable desktop, not native macOS fullscreen Spaces. If only one column has windows, it fills the screen until the other group has a window.

The helper checks every two seconds. Newly opened windows can briefly appear on B or T before regrouping. Ultrawide detection uses an aspect ratio of at least 2.2. Change `ULTRAWIDE_RATIO` in `adaptive.py` if needed. A resolution-only change on the same display requires a reset.

## Shortcuts

`Alt` means the Mac Option key. Command shortcuts inside apps are unchanged. Option+Tab is not bound by AeroSpace.

| Shortcut | Action |
| --- | --- |
| Option+h / l | Focus left / right, including another display |
| Option+j / k | Next / previous window in a vertical stack |
| Option+b | Focus Helium, or launch it |
| Option+t | Focus a terminal, or launch Kitty |
| Option+c | Focus Conductor, or launch it |
| Option+m | Summon Deezer onto the current workspace, or launch it |
| Option+w | Summon Telegram onto the current workspace, or launch it |
| Option+0 | Other apps on W |
| Option+1 / 2 / 3 | Scratch workspaces |
| Option+Shift+1 / 2 / 3 / w | Move the window there and follow it |
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

The helper starts automatically with AeroSpace. If it has stopped, restart it from a separate terminal when ready for windows to move:

```sh
/usr/bin/python3 ~/.config/aerospace/adaptive.py --watch
```

A file lock prevents duplicate watchers. Stop a foreground helper with Control+C. To stop the existing background watcher:

```sh
pkill -f '[a]daptive.py --watch'
```

The watcher also exits when AeroSpace quits, or if a layout command fails, rather than repeatedly resizing windows after an error. Startup output goes to `~/Library/Logs/aerospace-adaptive.log`. The last successfully applied display profile is in `~/.local/state/aerospace/profile.json`.

For remaining hardware checks, leave Pi first, then disconnect/reconnect displays and test the two-monitor setup. Confirm the expected placement, stack switching, and full-size unrelated apps. Reloading the config alone does not run the startup callback.

## Undo

Quit AeroSpace from its menu before restoring the old file:

```sh
cp ~/.local/state/aerospace/backup-20260908-112624/aerospace.toml ~/.config/aerospace/aerospace.toml
```

The same backup folder contains the original window-to-workspace listing. Restoring the config does not restore window placements that were already changed. No apps or windows were intentionally closed during setup.
