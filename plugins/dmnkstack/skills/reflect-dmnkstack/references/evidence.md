# Reflection evidence

Use one JSON object per line:

```json
{"date":"2026-01-15","kind":"working-style","task":"bug-fix","signal":"prefers narrow verification before broad checks","result":"positive"}
```

Allowed `kind` values are `working-style` and `model-route`. Keep `task` to a generic route name. Keep `signal` behavioral and under 160 characters. Use `positive`, `negative`, or `correction` for `result`.

Do not store prompts, responses, paths, identifiers, people, company names, or repository names.
