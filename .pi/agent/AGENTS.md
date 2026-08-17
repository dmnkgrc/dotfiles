# Global instructions

Loaded into every pi session. Keep it short — it costs context every turn.

## Code

- No comments unless something is genuinely confusing or is a deliberate hack. Name things well instead.
- Minimal and clean. No abstraction, config knob, or file that the current task does not require. Ask before adding complexity.
- TypeScript: no `any`, no type assertions (`as`), no non-null assertions (`!`). Model the type properly or narrow it. If a cast is genuinely unavoidable, say why and ask.
- Match the surrounding code — its naming, idiom, and comment density — over any personal preference.

## Tools

- Prefer `fff` (`find_files`, `grep`, `multi_grep`) over shell `find`/`rg` for search.
- Never bypass git hooks. `--no-verify` is blocked; fix the hook failure or ask.
- Do not add yourself as a commit co-author. Commit or push only when asked.
