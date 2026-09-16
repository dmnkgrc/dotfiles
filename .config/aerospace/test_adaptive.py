import subprocess
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import adaptive


def display(number, name, width, height):
    return {"monitor-id": number, "name": name, "width": width, "height": height}


def window(number, app, workspace, layout="v_accordion"):
    return {"window-id": number, "app-bundle-id": app,
            "workspace": workspace, "window-layout": layout}


class AdaptiveTest(unittest.TestCase):
    def test_display_profiles(self):
        laptop = display(1, "Built-in Retina Display", 1512, 982)
        wide = display(2, "DELL U3425WE", 3440, 1440)
        left = display(2, "External A", 2560, 1440)
        right = display(3, "External B", 2560, 1440)
        for displays, expected in [
            ([laptop], ("single", 1, 1)),
            ([wide], ("wide", 2, 2)),
            ([laptop, wide], ("wide", 2, 2)),
            ([left, right], ("dual", 2, 3)),
            ([laptop, left, right], ("dual", 2, 3)),
            ([right, laptop, left], ("dual", 2, 3)),
            ([laptop, left], ("dual", 1, 2)),
            ([left], ("single", 2, 2)),
            ([display(1, "Portrait", 1440, 3440)], ("single", 1, 1)),
        ]:
            with self.subTest(displays=displays):
                self.assertEqual(adaptive.profile(displays), expected)
        with self.assertRaises(ValueError):
            adaptive.profile([])

    def test_floating_apps_bypass_workspace_assignment(self):
        config = Path(__file__).with_name("aerospace.toml").read_text()
        first_rule = config.split("[[on-window-detected]]")[1]
        for app in ["com.apple.finder", "com.tdesktop.Telegram", "net.whatsapp.WhatsApp",
                    "com.apple.systempreferences", "com.apple.ActivityMonitor"]:
            self.assertIn(f"test %{{app-bundle-id}} = {app}", first_rule)
        self.assertIn("run = 'layout floating'", first_rule)
        self.assertNotIn("move-node-to-workspace", first_rule)
        self.assertNotIn("check-further-callbacks = true", first_rule)

    def test_slack_floats_on_the_development_workspace(self):
        config = Path(__file__).with_name("aerospace.toml").read_text()
        rule = next(r for r in config.split("[[on-window-detected]]")
                    if "com.tinyspeck.slackmacgap" in r)
        self.assertIn("run = ['layout floating', 'move-node-to-workspace --focus-follows-window T']", rule)
        for mode, source, target in [("wide", "T", "B"), ("single", "B", "T"), ("dual", "B", "T")]:
            with self.subTest(mode=mode):
                slack = window(6, "com.tinyspeck.slackmacgap", source, "floating")
                self.assertEqual(adaptive.managed([slack]), [])
                command, = adaptive.floating_work_commands(mode, [slack])
                move = f"move-node-to-workspace --window-id 6 {target}"
                self.assertEqual(command, f"test %{{window-id}} = 6 && {move} --focus-follows-window || {move}")
                slack["workspace"] = target
                self.assertEqual(adaptive.floating_work_commands(mode, [slack]), [])
                slack["workspace"] = "1"
                self.assertEqual(adaptive.floating_work_commands(mode, [slack]), [])
                other = window(7, "com.apple.finder", source, "floating")
                self.assertEqual(adaptive.floating_work_commands(mode, [other]), [])

    def test_overlays_follow_the_focused_workspace_without_stealing_focus(self):
        telegram = window(8, "com.tdesktop.Telegram", "T", "floating")
        whatsapp = window(9, "net.whatsapp.WhatsApp", "W", "floating")
        finder = window(10, "com.apple.finder", "T", "floating")
        slack = window(11, "com.tinyspeck.slackmacgap", "T", "floating")
        self.assertEqual(
            adaptive.overlay_follow_commands("B", [telegram, whatsapp, finder, slack]),
            ["move-node-to-workspace --window-id 8 B",
             "move-node-to-workspace --window-id 9 B"])
        telegram["workspace"] = "B"
        self.assertEqual(adaptive.overlay_follow_commands("B", [telegram, finder]), [])
        config = Path(__file__).with_name("aerospace.toml").read_text()
        self.assertIn("--follow-overlays", config)
        self.assertIn("--focus telegram", config)

    def test_only_manage_assigned_tiled_windows(self):
        browser = window(1, "net.imput.helium", "B")
        recovery = window(2, "com.conductor.app", "adaptive-staging")
        scratch = window(3, "net.imput.helium", "1")
        dialog = window(4, "net.imput.helium", "B", "floating")
        self.assertEqual(adaptive.managed([scratch, dialog, recovery, browser]),
                         [browser, recovery])

    def test_layout_transitions(self):
        current = [
            window(1, "net.imput.helium", "B"),
            window(2, "net.imput.helium", "B"),
            window(3, "net.kovidgoyal.kitty", "T"),
            window(4, "com.conductor.app", "T"),
            window(5, "com.openai.codex", "T"),
        ]
        wide = adaptive.layout_commands("wide", 1, 1, current, 4)
        self.assertIn("layout --workspace B --root h_tiles", wide)
        self.assertEqual([c for c in wide if c.startswith("split")], [
            "split --window-id 1 vertical", "split --window-id 3 vertical",
        ])
        self.assertIn("balance-sizes --workspace B", wide)
        self.assertEqual(wide[-1], "focus --window-id 4")
        for mode, left, right in [("single", 1, 1), ("dual", 1, 2)]:
            with self.subTest(mode=mode):
                commands = adaptive.layout_commands(mode, left, right, current, 4)
                self.assertFalse(any("h_tiles" in c or c.startswith("split")
                                     for c in commands))
                for number, workspace in [(1, "B"), (2, "B"), (3, "T"), (4, "T"), (5, "T")]:
                    self.assertIn(f"move-node-to-workspace --window-id {number} {workspace}",
                                  commands)
                self.assertIn(f"move-workspace-to-monitor --workspace T {right}", commands)
                self.assertEqual(commands[-1], "focus --window-id 4")

    def test_extra_windows_enter_their_column_not_the_root(self):
        for browsers, development in [(1, 1), (2, 2), (3, 4), (0, 3), (2, 0)]:
            left = list(range(1, browsers + 1))
            right = list(range(10, 10 + development))
            current = [window(i, "net.imput.helium", "B") for i in left]
            current += [window(i, "com.openai.codex" if i % 2 else "com.conductor.app", "T")
                        for i in right]
            commands = adaptive.layout_commands("wide", 1, 1, current, None)
            root = []
            for command in commands:
                words = command.split()
                if words[0] == "move-node-to-workspace" and words[-1] == "B":
                    root.append(int(words[2]))
                elif words[0] == "split":
                    self.assertGreater(len(root), 1, "A singleton split only changes root orientation")
                    number = int(words[2])
                    root[root.index(number)] = [number]
                elif words[0] == "move":
                    number = int(words[2])
                    index = root.index(number)
                    self.assertGreater(index, 0)
                    self.assertIsInstance(root[index - 1], list)
                    root[index - 1].append(root.pop(index))
            with self.subTest(browsers=browsers, development=development):
                expected = [left, right] if left and right else left + right
                self.assertEqual(root, expected)

    def test_summon_overlay_moves_then_focuses(self):
        telegram = window(8, "com.tdesktop.Telegram", "T", "floating")
        with patch.object(adaptive, "windows", return_value=[telegram]), \
                patch.object(adaptive, "aerospace", side_effect=["B", ""]) as run:
            adaptive.summon_overlay("com.tdesktop.Telegram")
        self.assertEqual(run.call_args_list[0].args, ("list-workspaces", "--focused"))
        self.assertEqual(run.call_args.args, (
            "eval", "move-node-to-workspace --window-id 8 B && focus --window-id 8"))

    def test_summon_overlay_launches_when_missing(self):
        with patch.object(adaptive, "windows", return_value=[]), \
                patch.object(adaptive, "aerospace", return_value="B"), \
                patch.object(adaptive.subprocess, "run") as run:
            adaptive.summon_overlay("com.tdesktop.Telegram")
        self.assertEqual(run.call_args.args[0], ["/usr/bin/open", "-b", "com.tdesktop.Telegram"])

    def test_apply_preserves_an_empty_workspace(self):
        empty = subprocess.CalledProcessError(2, "list-windows", output="", stderr="No window is focused\n")
        with tempfile.TemporaryDirectory() as directory:
            with patch.object(adaptive, "STATE", Path(directory)):
                with patch.object(adaptive, "aerospace", side_effect=["3", empty, ""]) as run:
                    adaptive.apply([display(1, "Built-in Retina Display", 1512, 982)], [])
        self.assertEqual(run.call_args.args[0], "eval")
        self.assertTrue(run.call_args.args[1].endswith("workspace 3"))

    def test_unexpected_focus_errors_still_propagate(self):
        failure = subprocess.CalledProcessError(2, "list-windows", stderr="Connection lost")
        with patch.object(adaptive, "aerospace", side_effect=["3", failure]) as run:
            with self.assertRaises(subprocess.CalledProcessError):
                adaptive.apply([display(1, "Built-in Retina Display", 1512, 982)], [])
        self.assertEqual(run.call_count, 2)

    def test_failed_layout_does_not_repeat_resizing(self):
        error = subprocess.CalledProcessError(1, "eval", stderr="Window closed during layout")
        with tempfile.TemporaryDirectory() as directory:
            with patch.object(adaptive, "STATE", Path(directory)), \
                    patch.object(adaptive, "monitors", return_value=[]), \
                    patch.object(adaptive, "windows", return_value=[]), \
                    patch.object(adaptive, "screen_sizes", return_value=[]), \
                    patch.object(adaptive, "apply", side_effect=error) as apply:
                adaptive.watch()
                apply.assert_called_once()

    def test_stale_window_layout_retries(self):
        error = subprocess.CalledProcessError(
            1, "eval", stderr="Invalid <window-id> 76920 passed to --window-id\n")
        wide = [display(2, "DELL U3425WE", 3440, 1440)]
        with tempfile.TemporaryDirectory() as directory:
            with patch.object(adaptive, "STATE", Path(directory)), \
                    patch.object(adaptive, "monitors", return_value=wide), \
                    patch.object(adaptive, "windows", return_value=[]), \
                    patch.object(adaptive, "screen_sizes", return_value=wide), \
                    patch.object(adaptive, "apply", side_effect=[error, None]) as apply, \
                    patch.object(adaptive.time, "sleep", side_effect=[None, SystemExit]):
                try:
                    adaptive.watch()
                except SystemExit:
                    pass
                self.assertEqual(apply.call_count, 2)

    def test_stranded_staging_windows_trigger_rebuild(self):
        wide = [display(2, "DELL U3425WE", 3440, 1440)]
        placed = [
            window(1, "net.imput.helium", "B"),
            window(2, "net.kovidgoyal.kitty", "B"),
        ]
        stranded = [
            window(1, "net.imput.helium", "adaptive-staging"),
            window(2, "net.kovidgoyal.kitty", "B"),
        ]
        with tempfile.TemporaryDirectory() as directory:
            with patch.object(adaptive, "STATE", Path(directory)), \
                    patch.object(adaptive, "monitors", return_value=wide), \
                    patch.object(adaptive, "windows", side_effect=[placed, stranded]), \
                    patch.object(adaptive, "screen_sizes", return_value=wide), \
                    patch.object(adaptive, "apply") as apply, \
                    patch.object(adaptive.time, "sleep", side_effect=[None, SystemExit]):
                try:
                    adaptive.watch()
                except SystemExit:
                    pass
                self.assertEqual(apply.call_count, 2)
                self.assertEqual(apply.call_args_list[1].args[1], stranded)

    def test_staging_workspace_is_not_reserved(self):
        current = [window(1, "net.imput.helium", "B")]
        commands = adaptive.layout_commands("wide", 1, 1, current, 1)
        destinations = [c.split()[-1] for c in commands if c.startswith("move-node-to-workspace")]
        self.assertIn("adaptive-staging", destinations)
        self.assertFalse(any(name.startswith("_") for name in destinations))

    def test_empty_and_one_sided_workspaces(self):
        for current in [[], [window(1, "net.imput.helium", "B")],
                        [window(2, "com.conductor.app", "T")]]:
            commands = adaptive.layout_commands("wide", 1, 1, current, None)
            self.assertFalse(any("None" in c for c in commands))
            self.assertFalse(any(c.startswith("split") for c in commands))
            self.assertIn("layout --workspace B --root v_accordion", commands)


if __name__ == "__main__":
    unittest.main()
