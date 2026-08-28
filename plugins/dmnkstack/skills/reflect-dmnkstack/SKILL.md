---
name: reflect-dmnkstack
description: Capture a correction or task outcome as evidence for improving Dmnkstack. Use after a routed task, when the user says to remember a workflow preference, when a model route worked poorly or well, or when repeated friction suggests changing the personal working style.
---

# Reflect on Dmnkstack

Capture the lesson without turning one task into a global rule.

## Classify the lesson

Decide whether the observation is:

- global working style
- model-route evidence
- repository-specific and owned by local instructions or skills
- one-off task context

Only the first two belong to Dmnkstack. Leave repository-specific facts in the repository and discard one-off context after the task.

## Record evidence

Read [references/evidence.md](references/evidence.md). Append a concise observation to `${XDG_STATE_HOME:-$HOME/.local/state}/dmnkstack/reflections.jsonl`. Do not include source code, secrets, issue text, repository names, or raw conversation text.

Update `${XDG_CONFIG_HOME:-$HOME/.config}/dmnkstack/working-style.md` when the user explicitly states a lasting preference or the same lesson has enough independent evidence. Update `models.md` only after repeated model-task evidence or a direct instruction.

Show the proposed change before editing a tracked configuration. Do not commit or push unless asked.
