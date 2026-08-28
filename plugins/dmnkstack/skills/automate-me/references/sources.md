# History sources

The analyzer checks these local sources when they exist:

- Codex: `~/.codex/history.jsonl`
- Claude: `~/.claude/history.jsonl`
- Pi conversations: `~/.pi/agent/sessions/**/*.jsonl`
- Pi routing health: `~/.pi/agent/run-history.jsonl`
- Cursor: `~/.cursor/prompt_history.json` and `~/.cursor/projects/*/agent-transcripts/*/*.jsonl`

Formats are runtime-owned and may change. Treat an unreadable source as missing evidence. Do not modify, migrate, or delete source history.

The default report includes aggregate counts and a few redacted user-prompt examples. Use `--examples-per-signal 0` for counts only. Do not redirect a report with examples into a tracked repository.
