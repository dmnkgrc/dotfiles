# Playbooks

## Correction

1. Identify the exact claim, assumption, or implementation the user changed.
2. Update the active constraints before doing more work.
3. Recheck any completed step that depended on the old assumption.
4. Continue without defending the discarded approach.

## Investigation

1. Read repository instructions and the nearest relevant code or artifact.
2. Trace the real path before proposing a change.
3. Separate observed facts from inference.
4. Answer with evidence. Do not edit unless the request includes a change.

## Bug fix

1. Reproduce or identify the failing boundary.
2. Find the cause, not only the visible symptom.
3. Make the smallest fix at the owning layer.
4. Add or update a focused regression test when it adds durable value.
5. Run the original reproduction and the narrow relevant checks.

## Feature

1. Find an existing adjacent pattern and the owning boundary.
2. Resolve only decisions that change behavior or architecture.
3. Implement a complete vertical slice with one coding owner.
4. Use project-specific implementation skills when available.
5. Verify behavior at the closest realistic boundary.

## UI

1. Inspect the existing design system and nearby components.
2. Reuse tokens and components before creating new ones.
3. Implement states, responsive behavior, and accessibility required by the request.
4. Verify in a real browser when the runtime makes that possible.

## Check repair

1. Run or inspect the failing check.
2. Fix the source problem. Do not add ignores, baselines, suppressions, or hook bypasses.
3. Rerun the narrow check, then any directly affected broader check.

## Review

1. Read the diff and scoped instructions.
2. Report only actionable findings introduced by the change.
3. Rank findings by impact and cite the exact location.
4. Keep review read-only unless the user also asks for fixes.

## Environment

1. Inspect installed versions, environment variables, and the failing command.
2. Prefer local, reversible fixes.
3. Do not change global authentication or shared configuration as a shortcut.
4. Verify with the command that originally failed.
