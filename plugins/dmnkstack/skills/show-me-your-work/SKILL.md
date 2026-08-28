---
name: show-me-your-work
description: Keep a compact, reviewable decision and evidence trail during long or consequential work. Use when the user asks for an audit trail, steps away during an autonomous run, wants decisions recorded, or needs a reviewer to understand why each unit was kept or rejected.
---

# Show me your work

Keep one local trail under `${XDG_STATE_HOME:-$HOME/.local/state}/dmnkstack/<repository>/<branch>/decisions.tsv` unless the user asks to commit it.

Use these columns:

```tsv
time	unit	decision	alternatives	reason	evidence	status
```

Append one row when a decision is made, a unit is accepted or rejected, a hypothesis changes, or verification changes the verdict. Link concise evidence such as a command, test, commit, artifact path, or URL. Do not log routine reads or agent narration.

Keep secrets, raw prompts, customer data, and unrelated source content out of the trail. Do not commit the trail unless the user asked for a tracked record or the task's delivery contract requires one.

At handoff, summarize accepted decisions, rejected paths, current proof, and open items. The trail supports the result; it does not replace verification.
