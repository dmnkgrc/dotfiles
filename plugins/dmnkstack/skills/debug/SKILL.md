---
name: debug
description: Reproduce, diagnose, fix, and verify software failures. Use for bugs, regressions, crashes, flaky behavior, incorrect output, runtime anomalies, performance problems, failing tests, or requests to find a root cause. Keep the work read-only when the user asks only for diagnosis.
---

# Debug

Find the first broken boundary, not the last visible symptom.

## Route the work

Read the active repository instructions and matching project skills first. Use `bug-fix`, `perf-issue`, or `hillclimb` from Dmnkstack's model map. Route through Dmnkstack when the selected model is unavailable in the current agent.

## Diagnose

1. State the expected behavior, observed behavior, and smallest known reproduction.
2. Reproduce before editing when a practical reproduction exists. Capture the exact command, input, output, and environment.
3. Trace backward from the failing boundary through real data and control flow. Inspect logs, traces, state transitions, and pinned dependency behavior when relevant.
4. Write competing hypotheses. For each one, name the observation that would confirm or reject it.
5. Run the cheapest discriminating check first. Keep observed facts separate from inference.
6. Identify the owning boundary and explain why it is the root cause.

Do not edit when the request is diagnosis-only. Return the cause, evidence, confidence, and remaining unknowns.

## Fix

1. Create a focused failing regression check first when the path is cheap. Use the `tdd` skill when it applies.
2. Change the owning layer with the smallest complete fix. Do not add guards that only hide the symptom.
3. Rerun the original reproduction.
4. Run the focused regression check and nearby validation.
5. Use `verify` at the closest realistic boundary before declaring success.

Report the reproduction, root cause, changed boundary, failing-before evidence, passing-after evidence, and anything still inconclusive.
