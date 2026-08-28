---
name: automate-me
description: Learn durable working preferences from local Codex, Claude, Pi, and Cursor history and turn them into a personal Dmnkstack working style. Use when the user says automate me, asks to personalize Dmnkstack from past conversations, wants recurring correction patterns analyzed, or wants the router tuned to actual usage.
---

# Automate me

Mine local history for behavior, not project knowledge. Keep raw conversations local and out of configuration files.
Resolve script paths from the directory containing this `SKILL.md`.

## Collect evidence

Run:

```sh
python3 scripts/analyze_history.py --pretty --examples-per-signal 3
```

The script reads known local history formats, extracts user prompts, removes common path and identity fragments from examples, and reports recurring signals. Read [references/sources.md](references/sources.md) when a source is missing or its format changed.

## Turn evidence into preferences

Cluster findings into response style, autonomy, corrections, implementation, verification, agent use, project-skill use, evidence integrations, and delivery.

Promote a preference only when one of these is true:

- the user stated it as a lasting preference
- it appears in at least three separate sessions
- repeated corrections point to the same rule

Do not promote repository names, business terminology, file paths, issue contents, one-off task constraints, secrets, or model speculation.

Ask one concise question only when an unresolved choice would materially change the resulting workflow.

## Update Dmnkstack

1. Read `${XDG_CONFIG_HOME:-$HOME/.config}/dmnkstack/working-style.md` and preserve intentional rules.
2. Show the proposed additions, changes, and removals with their evidence counts.
3. Update the file only after resolving contradictions.
4. Change `models.md` only when model and task metadata provide repeated evidence or the user directs the change.
5. Update Dmnkstack's integration map when repeated usage proves an evidence source belongs in the normal workflow.
6. Do not commit or push unless the user asks.

End with the rules changed, the evidence used, and any source that could not be read. Never include raw transcript excerpts in the final summary.
