---
description: Summarize the latest completed run and identify the next action
model: openai-codex/gpt-5.4-mini
thinking: low
restore: true
boomerang: true
---

Recap the most recently completed run in this active session branch.

Return at most three compact bullets covering what was investigated or changed, what was validated, and any important caveat. Then add one `Next:` line with the most useful remaining action, or say that no further action is required. Base the recap only on the conversation and tool results already present. Do not perform new work.
