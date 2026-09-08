import unittest

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
                for number, workspace in [(1, "B"), (2, "B"), (3, "T"), (4, "T")]:
                    self.assertIn(f"move-node-to-workspace --window-id {number} {workspace}",
                                  commands)
                self.assertIn(f"move-workspace-to-monitor --workspace T {right}", commands)
                self.assertEqual(commands[-1], "focus --window-id 4")

    def test_empty_and_one_sided_workspaces(self):
        for current in [[], [window(1, "net.imput.helium", "B")],
                        [window(2, "com.conductor.app", "T")]]:
            commands = adaptive.layout_commands("wide", 1, 1, current, None)
            self.assertFalse(any("None" in c for c in commands))
            self.assertEqual(sum(c.startswith("split") for c in commands), len(current))


if __name__ == "__main__":
    unittest.main()
