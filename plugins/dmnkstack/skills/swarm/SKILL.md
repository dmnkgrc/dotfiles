---
name: swarm
description: Fan out independent slices of a task or race several approaches, then return one aggregate report. Use for swarm this, parallel coverage, package sweeps, independent research, test matrices, migrations with clean seams, or a requested model race.
---

# Swarm

Parallelize only where the work has real seams.

1. State the done predicate and expected aggregate artifact.
2. Choose coverage, race, or mixed mode. Define the selection rule before starting a race.
3. Partition coverage so every required slice has one clear owner.
4. Select workers from `swarm workers` or name each model in a model race.
5. Give every worker a complete brief with scope, constraints, output, and proof.
6. Keep writable work isolated. Use one worktree or output path per worker.
7. Wait for results, record dropouts, and verify coverage.
8. Return one compact report. Do not paste raw worker transcripts.

Use `PASS`, `ISSUES`, or `BLOCKED` for each slice. A swarm does not expand the user's authority and does not let several writers share one worktree.
