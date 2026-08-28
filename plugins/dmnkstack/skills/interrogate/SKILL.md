---
name: interrogate
description: Run an adversarial multi-model review of code, a diff, a plan, or a design. Use for interrogate, challenge this, stress test this, find blind spots, tear this apart, or review this change with independent models.
---

# Interrogate

Collect independent criticism. Keep the review read-only.

1. Identify the exact artifact and comparison base.
2. State the intended behavior and active constraints in one paragraph.
3. Build a task-specific rubric covering correctness, security, failure handling, maintainability, scope, and proof.
4. Launch one read-only reviewer for each entry in `interrogate reviewers`. Give every reviewer the same artifact, intent, context, and rubric.
5. Deduplicate findings and check each one against the actual code.
6. Treat independent agreement as stronger evidence, not automatic truth.
7. Apply lead judgment.

Classify findings as `Act on`, `Consider`, `Noted`, or `Dismissed`. For each finding, name the models that raised it, the exact location, impact, and why the category fits. Include disagreements and the verification that would settle them.

Do not change the artifact unless the user also asked for fixes. Do not pass raw reviewer output through as the final answer.
