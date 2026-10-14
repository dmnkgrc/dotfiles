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
- the evidence or artifacts required for acceptance;
- the targeted checks the child runs before reporting: the touched tests, the specs beside the changed code, wiring specs when wiring changed, and the linters. Full suites belong to CI;
- the result artifact path, where the child records `completion_state`, `revision` (the commit it reports), and the protocol sections below;
- the code hygiene rules the child must follow: a comment is allowed only for a non-obvious constraint or a deliberate workaround, stays at one or two lines, and never restates the code, the test name, or the change description;
- explicit workspace, sender session, recipient session, task, and revision IDs;
- assigned phase, next owner, completion state, and each owned background job;
- delivery mode from [the delivery contract](../dmnkstack/references/delivery.md).

Keep the contract short. Put the repository facts every child needs (environment setup, shared locks, known local-only failures, how to reach evidence sources) in `.context/dmnkstack/orientation.md` once, link it from each contract, and add to it when a child discovers a new fact. Repeat only what this task changes.

Require the child's final response, and its result artifact, to use this compact protocol:

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
5. Prepare the child's worktree with its dependencies installed before launch, and reuse prepared worktrees for later rounds of the same task. Create the session and retain the returned session ID:

```sh
conductor --json session create \
  --workspace "$CONDUCTOR_WORKSPACE_ID" \
  --agent <claude|codex> \
  --model <model> \
  --effort <effort> \
  --name <short-task-name> \
  --message-file <prompt-file>
```

When `CONDUCTOR_WORKSPACE_ID` is set, Sol, Luna, and Astra launch through Conductor's `codex` agent, using a model listed for that agent. Sol is `gpt-6.1-sol`. Outside Conductor, OpenAI models use Pi only. Grok always uses Pi (`grok-4.7@256k`), never `--agent cursor`. A missing Conductor model requires a role fallback or stop, not substitution of Pi. Do not start the Codex CLI or Cursor CLI.

If local auth is absent, ask the user to run `conductor auth login`. If session creation reports that no credential is available, stop and report the missing prerequisite. Do not retry, expose a credential, store it in Dmnkstack config, or fall back to Herdr while inside Conductor.

6. Wait in the background with this skill's `scripts/wait_child.py`. It returns only when the result artifact has a terminal `completion_state`, the session is idle, the worktree HEAD matches the artifact's `revision`, and the worktree has been quiet, since an idle child can still have subagents writing. Exit `0` is done, `3` is blocked, `4` is not done when the timeout passed. Completion comes from the artifact, never from transcript keywords or idle status alone. Report transitions and findings while meeting runtime commentary requirements.

```sh
python3 <this-skill-dir>/scripts/wait_child.py \
  --artifact <result-artifact> --session <session-id> --worktree <child-worktree>
```

7. When new evidence or a changed requirement arrives while the child runs (a recording, a user correction, a new constraint), send it to the running child. Relaunch only when the scope changed enough to void its work so far.

```sh
conductor --json message create --session <session-id> --message-file <follow-up-file>
```

8. Read the result artifact, then `conductor --json session message <session-id> --limit 100` for context. Follow pagination or `--after` when needed.
9. Inspect any claimed files, diff, commands, or external evidence yourself. Treat the child transcript as evidence to verify, not as an automatically trusted answer. Read the diff for comment volume as well as behavior: count the added comment lines and send back any comment that restates the code, the test name, or the change description before accepting the revision.
10. Report the child agent, model, session ID, result, evidence, changes, and gaps in the parent session. Summarize the useful result instead of dumping the raw transcript. Append the attempt's model-route record through `reflect-dmnkstack`, with its actual effort and elapsed time.

Parent collection is the default. User-requested callbacks use the same delivery contract and event identity. The parent verifies the authoritative artifact and reports the result once. Preserve the child session so the user can inspect it unless the user asks to close it.

## Control writes

Use the same workspace for read-only specialists and for one delegated writer. Before a child writes, the parent must stop editing and make the child the only writer in that worktree. Verify its diff before continuing.

Parallel read-only sessions may share the workspace. Independent writers need separate worktrees or Conductor workspaces. A panel never edits.

## Delegate outside Conductor

When `HERDR_ENV=1`, use the current host's Herdr CLI according to [Dmnkstack's launcher reference](../dmnkstack/references/launchers.md), including inside a VM. Create a sibling pane for closely related work or a new tab for an independent task. Preserve the inherited VM/session context, assigned directory and user focus. Resolve models and authentication on that host. Start the selected agent in the returned new pane, collect its result, verify it, and report it through the same protocol. Do not silently substitute a hidden subagent runner or launch on the laptop.

When neither manager is active, reuse the current session only if its actual model matches the selected target or an explicit `fallback ROLE` target. Otherwise stop and report the unavailable executor. Follow Dmnkstack's ordered fallback chains and disclose substitutions. Never substitute the author's session for an independent reviewer or count duplicate fallback models as cross-model coverage. Do not start a terminal or session manager without the user's knowledge.
