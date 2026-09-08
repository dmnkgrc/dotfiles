import argparse
import fcntl
import json
import os
from pathlib import Path
import shlex
import subprocess
import time

AEROSPACE = "/opt/homebrew/bin/aerospace"
BROWSER = {"net.imput.helium"}
TERMINAL = {
    "net.kovidgoyal.kitty",
    "com.mitchellh.ghostty",
    "com.apple.Terminal",
    "com.googlecode.iterm2",
}
CONDUCTOR = {"com.conductor.app"}
DEVELOPMENT = TERMINAL | CONDUCTOR | {"dev.zed.Zed"}
OWNED = {"B", "T", "adaptive-staging"}
STATE = Path.home() / ".local/state/aerospace"
ULTRAWIDE_RATIO = 2.2
SCREEN_SCRIPT = """
ObjC.import('AppKit');
var screens = $.NSScreen.screens, result = [];
for (var i = 0; i < screens.count; i++) {
    var s = screens.objectAtIndex(i);
    result.push({name: ObjC.unwrap(s.localizedName),
                 width: s.frame.size.width, height: s.frame.size.height});
}
JSON.stringify(result);
"""


def aerospace(*args):
    env = os.environ.copy()
    env.pop("AEROSPACE_WINDOW_ID", None)
    env.pop("AEROSPACE_WORKSPACE", None)
    return subprocess.run(
        [AEROSPACE, *map(str, args)], env=env, check=True,
        capture_output=True, text=True, timeout=15,
    ).stdout.strip()


def windows():
    return json.loads(aerospace(
        "list-windows", "--all", "--json", "--format",
        "%{window-id} %{app-bundle-id} %{workspace} %{window-layout}",
    ))


def monitors():
    return json.loads(aerospace(
        "list-monitors", "--json", "--format",
        "%{monitor-id} %{monitor-name} %{monitor-appkit-nsscreen-screens-id}",
    ))


def screen_sizes(displays):
    result = subprocess.run(
        ["/usr/bin/osascript", "-l", "JavaScript", "-e", SCREEN_SCRIPT],
        check=True, capture_output=True, text=True, timeout=15,
    )
    screens = json.loads(result.stdout)
    if len(screens) != len(displays):
        raise ValueError("Displays changed during detection; retrying")
    sized = []
    for display in displays:
        screen = screens[display["monitor-appkit-nsscreen-screens-id"] - 1]
        if screen["name"] != display["monitor-name"]:
            raise ValueError("Display order changed during detection; retrying")
        sized.append({**display, **screen})
    return sized


def profile(displays):
    if not displays:
        raise ValueError("No active displays; retrying")
    displays = sorted(displays, key=lambda d: d["monitor-id"])
    external = [d for d in displays if "built-in" not in d["name"].lower()]
    if len(external) >= 2:
        return "dual", external[0]["monitor-id"], external[-1]["monitor-id"]
    wide = [d for d in external if d["width"] / d["height"] >= ULTRAWIDE_RATIO]
    if wide:
        return "wide", wide[0]["monitor-id"], wide[0]["monitor-id"]
    if len(displays) >= 2:
        return "dual", displays[0]["monitor-id"], displays[-1]["monitor-id"]
    return "single", displays[0]["monitor-id"], displays[0]["monitor-id"]


def managed(all_windows):
    return sorted(
        [w for w in all_windows
         if w["workspace"] in OWNED and w["window-layout"] != "floating"],
        key=lambda w: w["window-id"],
    )


def layout_commands(mode, left_monitor, right_monitor, current, focused):
    left = [w["window-id"] for w in current if w["app-bundle-id"] in BROWSER]
    right = [w["window-id"] for w in current if w["app-bundle-id"] in DEVELOPMENT]
    commands = [
        f'move-node-to-workspace --window-id {w["window-id"]} W'
        for w in current if w["window-id"] not in left + right
    ]
    for workspace in ("B", "T"):
        commands.append(f"flatten-workspace-tree --workspace {workspace}")
        commands.append(f"layout --workspace {workspace} --root v_accordion")
    if mode == "wide":
        for window in left + right:
            commands.append(f"move-node-to-workspace --window-id {window} adaptive-staging")
        commands.append("layout --workspace B --root h_tiles")
        for group in (left, right):
            if group:
                commands.append(f"move-node-to-workspace --window-id {group[0]} B")
                commands.append(f"focus --window-id {group[0]}")
        for group in (left, right):
            if not group:
                continue
            anchor = group[0]
            commands.extend([
                f"split --window-id {anchor} vertical",
                f"layout --window-id {anchor} v_accordion",
                f"focus --window-id {anchor}",
            ])
            for window in group[1:]:
                commands.append(f"move-node-to-workspace --window-id {window} B")
        commands.append("balance-sizes --workspace B")
    else:
        for workspace, group in (("B", left), ("T", right)):
            for window in group:
                commands.append(f"move-node-to-workspace --window-id {window} {workspace}")
    commands.extend([
        f"move-workspace-to-monitor --workspace B {left_monitor}",
        f"move-workspace-to-monitor --workspace T {right_monitor}",
        f"move-workspace-to-monitor --workspace W {left_monitor}",
    ])
    if mode == "dual":
        commands.extend(["workspace B", "workspace T"])
    if focused is not None:
        commands.append(f"focus --window-id {focused}")
    return commands


def apply(displays, current):
    workspace = aerospace("list-workspaces", "--focused")
    try:
        focused = json.loads(aerospace("list-windows", "--focused", "--json"))
    except subprocess.CalledProcessError as error:
        if error.stdout.strip() != "[]":
            raise
        focused = []
    focused_id = focused[0]["window-id"] if focused else None
    chosen = profile(displays)
    commands = layout_commands(*chosen, current, focused_id)
    if focused_id is None:
        commands.append(f"workspace {shlex.quote(workspace)}")
    aerospace("eval", " && ".join(commands))
    STATE.mkdir(parents=True, exist_ok=True)
    (STATE / "profile.json").write_text(json.dumps({
        "mode": chosen[0], "left_monitor": chosen[1], "right_monitor": chosen[2],
    }) + "\n")
    print(f"Applied {chosen[0]} layout to {len(current)} windows", flush=True)


def focus_app(kind):
    apps = {"browser": BROWSER, "terminal": TERMINAL, "conductor": CONDUCTOR}[kind]
    candidates = [w for w in windows() if w["app-bundle-id"] in apps]
    if candidates:
        aerospace("focus", "--window-id", candidates[0]["window-id"])
    else:
        app = {"browser": "net.imput.helium", "terminal": "net.kovidgoyal.kitty",
               "conductor": "com.conductor.app"}[kind]
        subprocess.run(["/usr/bin/open", "-b", app], check=True)


def watch():
    STATE.mkdir(parents=True, exist_ok=True)
    with (STATE / "adaptive.lock").open("w") as lock:
        try:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            return
        previous = None
        previous_displays = None
        last_error = None
        while True:
            try:
                displays = monitors()
                current = managed(windows())
                signature = (displays, [(w["window-id"], w["app-bundle-id"]) for w in current])
                reset = STATE / "reset"
                if signature != previous or reset.exists():
                    if displays != previous_displays or reset.exists():
                        sized = screen_sizes(displays)
                    apply(sized, current)
                    previous = signature
                    previous_displays = displays
                    reset.unlink(missing_ok=True)
                last_error = None
            except (subprocess.SubprocessError, ValueError, IndexError, OSError) as error:
                message = getattr(error, "stderr", None) or str(error)
                if message != last_error:
                    print(message, flush=True)
                    last_error = message
            time.sleep(2)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    action = parser.add_mutually_exclusive_group(required=True)
    action.add_argument("--watch", action="store_true")
    action.add_argument("--reset", action="store_true")
    action.add_argument("--focus", choices=["browser", "terminal", "conductor"])
    args = parser.parse_args()
    if args.focus:
        focus_app(args.focus)
    elif args.reset:
        STATE.mkdir(parents=True, exist_ok=True)
        (STATE / "reset").touch()
    else:
        watch()
