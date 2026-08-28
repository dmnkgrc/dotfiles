---
name: tdd
description: Fix a bug by writing the focused failing regression first. Use when the user asks for TDD, failing-before evidence, or a regression test, and when a bug has a cheap local executable test path. Skip when the only possible test would be broad, brittle, or mostly mocked.
---

# TDD

Make the broken behavior executable before changing production code.

1. Identify the intended behavior and the smallest observable reproduction.
2. Choose the nearest existing test level for the owning code.
3. Add the smallest test that describes intended behavior without mirroring implementation details.
4. Run it before the fix. Confirm that it fails for the expected reason.
5. Make the smallest production change that fixes the owning boundary.
6. Rerun the new test and confirm it passes.
7. Run nearby checks justified by the affected path.

If the test passes before the fix, it is not a regression test. Correct it before continuing. If a useful failing test would require extensive fixtures, timing dependence, production state, or unrelated setup, say why and use the closest executable reproduction instead.

Do not weaken assertions to fit the implementation. Report the failing-before and passing-after commands and results.
