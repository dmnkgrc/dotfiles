---
name: verify
description: Prove that a software change works against the real artifact. Use when asked to verify, prove it works, test the result, check behavior, validate a fix, establish visual parity, or decide whether work is genuinely complete.
---

# Verify

Verification answers a falsifiable question with evidence.

## Build the proof

1. State the exact claim being verified and what observation would falsify it.
2. Read repository verification skills and commands. Prefer a project-specific skill when one exists.
3. Choose the closest realistic boundary that can observe the claim.
4. Capture a baseline or failing-before result when the change fixes existing behavior.
5. Run the check against the actual changed artifact. Compilation alone does not prove runtime behavior.
6. Inspect the output yourself. Do not trust an agent summary, a green proxy, or a blank artifact.
7. Run the narrow check first, then broader checks justified by the change's blast radius.

Use browser or device automation for user-visible behavior when available. Use real serialization, database, network, workflow, or CLI boundaries when those own the claim. Do not replace a practical real check with mocks.

## Verdict

Return one verdict:

- `VERIFIED`: the evidence directly supports the claim
- `NOT VERIFIED`: the check failed or contradicted the claim
- `INCONCLUSIVE`: the required boundary could not be observed

Name the command or interaction, observed result, artifact inspected, and any gap. Never round `INCONCLUSIVE` up to success.
