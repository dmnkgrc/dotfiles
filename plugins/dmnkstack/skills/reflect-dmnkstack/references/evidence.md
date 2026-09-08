# Reflection evidence

Use one JSON object per line:

```json
{"date":"2026-01-15","kind":"working-style","task":"bug-fix","signal":"prefers narrow verification before broad checks","result":"positive"}
```

Allowed `kind` values are `working-style` and `model-route`. Keep `task` to a generic route name. Keep `signal` behavioral and under 160 characters. Use `positive`, `negative`, or `correction` for `result`.

For each routed task, append one `model-route` record per model attempt or retained phase. Record failures and blocked launches as well as successes:

```json
{"date":"2026-01-15","kind":"model-route","task":"bug-fix","phase":"diagnosis","difficulty":"uncertain","role":"bug-fix","requested_model":"gpt-5.6-sol","model":"gpt-5.6-sol","executor":"pi","effort":"high","elapsed_seconds":120,"verification":"passed","corrections":0,"substitution":"none","signal":"reproduction and focused regression passed","result":"positive"}
```

Use actual runtime metadata, not the planned assignment. `verification` is `passed`, `failed`, `blocked`, or `not-run`. Use `null` for unknown elapsed time, model, effort, or correction count; never invent measurements. Measure elapsed time from attempt start through verification. Count user corrections to that attempt, not unrelated requests. `substitution` is `none`, `unavailable`, `escalation`, or `phase-retention`. Do not record token cost unless the runtime reports it.

When revising defaults, compare similar tasks by difficulty and phase. Include failures, verification gaps, correction counts, and elapsed time. Require at least five comparable verified attempts before proposing an evidence-based change; a direct user instruction can override this. Small samples are suggestions, not proof of model superiority. Do not auto-edit the model map.

Do not store prompts, responses, paths, session or task identifiers, people, company names, or repository names. Model and executor names are allowed.
