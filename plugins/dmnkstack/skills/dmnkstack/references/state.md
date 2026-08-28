# State

Conversation context is the primary state. Persist state only for a pause, handoff, compaction, or task that spans sessions.

Store local state under `${XDG_STATE_HOME:-$HOME/.local/state}/dmnkstack/<repository>/<branch>/state.md`. If the active environment supplies a private, ignored context directory, it may be used instead.

Record only:

- objective and current route
- repository, branch, and working tree status
- accepted constraints and corrections
- evidence already collected
- files intentionally changed
- checks run and their results
- the next concrete action

Do not store raw transcripts, secrets, project data unrelated to the task, or speculative conclusions. Verify repository and branch identity before resuming.
