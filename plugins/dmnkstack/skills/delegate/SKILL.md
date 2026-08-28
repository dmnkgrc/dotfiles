---
name: delegate
description: Run work through another model or agent and collect its result into the parent session. Use when Dmnkstack selects a model unavailable to the current agent, the user asks for another agent or model, a panel needs independent judgments, or work inside Conductor should happen in a new same-workspace session and report back.
---

# Delegate

Choose the model for the task before choosing its executor. The parent owns the request, authority, result collection, verification, and final report.

## Define the child contract

Before starting another agent, write a complete prompt containing:

- the objective and exact scope;
- active repository instructions and the matching project skills;
- the selected model role and why it was selected;
- whether the child is read-only or is the sole writer;
- authority limits inherited from the user;
- the evidence or artifacts required for acceptance.

Require the child's final response to use this compact protocol:

```text
RESULT
<answer or outcome>

EVIDENCE
<commands, observations, paths, or links>

CHANGES
<files or external state changed, or none>

GAPS
<unknowns, failures, or none>

NEXT
<recommended parent action, or none>
```

Do not give the child authority the parent does not have. Do not ask it to commit, push, publish, message people, or change external state unless the user authorized that action.

## Delegate inside Conductor

When `CONDUCTOR_WORKSPACE_ID` is set, create a new session in that same workspace. This is the required path when the current agent cannot run the selected model or the user asks for another agent. Do not use Herdr inside Conductor.

1. Check `CONDUCTOR_IS_LOCAL` before making assumptions about the host OS or available apps. If the variable is absent, use actual host evidence and explicit user context. Do not interpret absence as cloud execution.
2. On a local Mac, run `conductor auth status` and use the macOS Keychain credential configured by `conductor auth login`. In other environments, use the workspace token or `CONDUCTOR_API_KEY`. Never read or print the credential.
3. Run `conductor --json model` and resolve a valid agent, model, and effort combination.
4. Save the child contract under `.context/dmnkstack/delegations/` when `.context` is available and ignored. Otherwise use a private temporary or XDG state location. Never commit the prompt.
5. Create the session and retain the returned session ID:

```sh
conductor --json session create \
  --workspace "$CONDUCTOR_WORKSPACE_ID" \
  --agent <claude|codex|cursor> \
  --model <model> \
  --effort <effort> \
  --name <short-task-name> \
  --message-file <prompt-file>
```

If local auth is absent, ask the user to run `conductor auth login`. If session creation reports that no credential is available, stop and report the missing prerequisite. Do not retry, expose a credential, store it in Dmnkstack config, or fall back to Herdr while inside Conductor.

6. Poll `conductor --json session status <session-id>` at reasonable intervals until it reports a terminal state. Keep the user informed during a long wait.
7. Read `conductor --json session message <session-id> --limit 100`. Follow pagination or `--after` when needed and extract the latest complete assistant result.
8. Inspect any claimed files, diff, commands, or external evidence yourself. Treat the child transcript as evidence to verify, not as an automatically trusted answer.
9. Report the child agent, model, session ID, result, evidence, changes, and gaps in the parent session. Summarize the useful result instead of dumping the raw transcript.

The child does not call back into the parent. The parent always waits, pulls the transcript, verifies it, and reports it back. Preserve the child session so the user can inspect it unless the user asks to close it.

## Control writes

Use the same workspace for read-only specialists and for one delegated writer. Before a child writes, the parent must stop editing and make the child the only writer in that worktree. Verify its diff before continuing.

Parallel read-only sessions may share the workspace. Independent writers need separate worktrees or Conductor workspaces. A panel never edits.

## Delegate outside Conductor

When `HERDR_ENV=1`, use Herdr in Kitty according to Dmnkstack's launcher reference. Start the selected agent, wait for a settled result, read its output, verify it, and report it through the same protocol.

When neither manager is active, reuse a compatible current agent. If the selected model is unavailable, use the configured fallback and disclose the substitution. Do not start a terminal or session manager without the user's knowledge.
