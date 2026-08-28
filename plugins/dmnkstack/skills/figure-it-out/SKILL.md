---
name: figure-it-out
description: Design and run a rigorous workflow when no narrower skill fits. Use for figure it out, large migrations, unusual multi-part tasks, ambiguous operational work, or long autonomous work that needs an auditable result when the user returns.
---

# Figure it out

Design the workflow before committing to a long run.

## Frame

1. Define done as a falsifiable predicate.
2. Quantify scope, risky unknowns, and blockers found from inspection.
3. Choose a rigor level based on reversibility, impact, and proof cost.

## Design

1. Split the task into independently verifiable units.
2. Put the riskiest unknown and the verification mechanism early.
3. Use `architect` for consequential shape decisions and `arena` when distinct candidates are useful.
4. Use `swarm` only across clean independent seams.
5. Start `show-me-your-work` when the result needs an audit trail.

## Execute

For each unit, state a hypothesis, make the smallest useful change, observe the real artifact, and keep or revise the result. Verify each unit before starting the next. Use one writer per worktree.

Finish with `verify` against the original done predicate. Return the designed workflow, decisions, evidence, unresolved risks, and current verdict.
