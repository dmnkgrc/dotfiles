---
name: recall
description: Rebuild the current state of prior work from local agent history, saved Dmnkstack state, git, and linked work records. Use when resuming a task, taking over a branch, asking what was decided, or recovering context after compaction or a long pause.
---

# Recall

Reconstruct the current state without treating old plans as current truth.

1. Identify the topic, repository, branch, and approximate time range from the request.
2. Read current conversation context and Dmnkstack state first.
3. Inspect the working tree, commits, pull request, and current checks.
4. Search local Codex, Claude, Pi, and Cursor history only for the requested topic when useful.
5. Use linked tickets, documents, or review threads when available.
6. Resolve conflicts in favor of current repository and remote state. Mark older intentions as superseded when later evidence changed them.

Keep raw transcripts local. Do not copy secrets, unrelated project data, or long conversation excerpts into the result.

Return the objective, decisions still in force, completed work, current branch and diff, verification state, blockers, and next concrete action. Cite the local or remote record behind consequential claims.
