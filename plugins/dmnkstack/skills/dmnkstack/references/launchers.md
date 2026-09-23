# Launchers

Select the model first. Read `${XDG_CONFIG_HOME:-$HOME/.config}/dmnkstack/launchers.toml`, then choose an executor that can run the model.

Reuse the current session only when its actual model matches the selection, or the documented phase-retention rule applies. An executor supporting a model does not mean the current session is running it. Resolve `fallback ROLE` targets in order; stop when none satisfy the task. Never fall back to an unnamed current model. OpenAI Codex and Grok models launch only through Pi. Do not start the Codex CLI or Cursor CLI. Do not maintain separate Pi model routes.

## Conductor

Use Conductor when `CONDUCTOR_WORKSPACE_ID` is set. Load `delegate` and use a new session in the current workspace whenever another agent or model is selected. Do not use Herdr inside Conductor.

Check `CONDUCTOR_IS_LOCAL` before assuming the host has macOS applications or local-only tools. If it is absent, use actual host evidence and explicit user context instead of treating the workspace as cloud. Check the installed model catalog with:

```sh
conductor --json model
```

Session creation also requires Conductor authentication. On a local Mac, check `conductor auth status` and use `conductor auth login` to store the token in the macOS Keychain. In other environments, use a workspace token or `CONDUCTOR_API_KEY`. Never store the credential in Dmnkstack config or a committed prompt.

Create a session in the current workspace with the resolved agent, model, effort, and a complete task prompt:

```sh
conductor --json session create \
  --workspace "$CONDUCTOR_WORKSPACE_ID" \
  --agent <claude|codex|cursor> \
  --model <model> \
  --effort <effort> \
  --name <short-name> \
  --message-file <prompt-file>
```

`--model` is the executor alias from `launchers.toml`. Grok, Sol, and Luna launch through Pi (`grok-4.7@256k` for Grok). Do not pass `--agent cursor` or `--agent codex`.

The parent owns the whole round trip:

1. Give the child a complete contract with scope, repository instructions, selected project skills, write authority, and expected evidence.
2. Read and retain the session ID returned by `session create`.
3. Poll status and collect the completion artifact using [the delivery contract](delivery.md). An idle session can still own background work.
4. Fetch the transcript with `conductor --json session message <session-id> --limit 100`, following pagination when required.
5. Extract the child's final `RESULT`, `EVIDENCE`, `CHANGES`, `GAPS`, and `NEXT` sections.
6. Verify claimed artifacts and evidence, then report the useful result in the parent session with the agent, model, and session ID.

Parent collection is the default; user-requested callbacks follow [the delivery contract](delivery.md). The parent verifies and reports each task/revision/event once. Preserve the child session for inspection.

If local Keychain auth is absent or `session create` reports a missing credential, stop and report that prerequisite without retrying or switching managers.

Do not create a new workspace for a read-only specialist. One delegated writer may use the current workspace while the parent stops editing. Use separate workspaces only for independent writers.

## Herdr on the current host

Use Herdr when `HERDR_ENV=1` and Conductor is not active. This includes native agent panes inside VMs, regardless of which terminal hosts the laptop client. Before controlling panes, run `herdr --skill` and follow the installed instructions because its CLI is the authority.

Inside a VM, launch children with that VM's `herdr` CLI and inherited session/socket context. Discover executables on the VM, not the laptop. A Pi model is present when its id is in that VM's `~/.pi/agent/settings.json`. Do not run `pi --list-models`, `pi` auth checks, or provider login to decide presence. Do not substitute a hidden subagent runner, background agent process, laptop terminal or new SSH connection for a requested Herdr child. Missing prerequisites require an explicit fallback from the model routes or a reported blocker, not a silent change of host or runner.

### Choose a pane or tab by task relationship

- Closely related work, such as reviewing the current diff or investigating the same failure: create a sibling pane in the current tab. Inspect layout first; split wide panes right and tall or narrow panes down.
- Independent deliverable, longer parallel investigation or separate task stream: create a new tab in the current workspace. Label it with the task.
- A second concurrent writer: use a separate worktree before choosing its pane or tab. A new terminal does not isolate files. Do not create another VM or server session just to separate tasks.

Preserve the current directory unless the user assigned another location. Keep focus unchanged. Inspect the installed command help before creation:

```sh
herdr pane layout --pane "$HERDR_PANE_ID"
herdr pane split --current --direction right --cwd "$PWD" --no-focus
```

For an independent task, use a tab instead of that split:

```sh
herdr tab create --workspace "$HERDR_WORKSPACE_ID" --cwd "$PWD" --label <task-label> --no-focus
```

Read the returned pane ID from `.result.pane.pane_id` for a split or `.result.root_pane.pane_id` for a new tab. Then start the selected agent in that new pane:

```sh
herdr agent start <name> --kind <kind> --pane <returned-pane-id> -- <native-agent-args>
herdr agent prompt <name> <task> --wait --timeout 120000
herdr agent read <name> --source recent-unwrapped --lines 120
```

Do not launch a child in the parent's pane or type into an existing agent. Discover IDs from the same server; IDs and agent names can collide across VMs. Selecting another machine in the laptop sidebar does not change the caller's domain.

The parent collects the child's artifact and output, verifies the evidence and reports the result. A stalled wait is not proof that the prompt was never delivered; inspect the agent before retrying. For shared app/browser validation, name one stack and browser owner. Other agents must not race service restarts or close that owner's browser.

Native model arguments:

- Pi: `--provider <catalog-provider> --model <model> --thinking <effort>`. Preserve the provider from discovery; do not assume every model uses OpenAI Codex.
- Claude: `--model <model> --effort <effort>`

Rewrite the logical name from `models.md` through `[aliases.<name>.<executor>]` in `launchers.toml` before those flags. Pi for `grok-4.7` is `grok-4.7@256k`. `claude` for `fable-5.1` is `fable`. Missing key: pass the logical name. Current-session reuse matches the logical name or that executor's alias.

Drop Pi for an Anthropic model unless discovery reports remaining Cursor included API usage (`api_remaining`, from `planUsage.apiPercentUsed` below 100). Auto or Composer remaining does not count. Solo `fable-5.1` uses Claude `fable`. Solo `opus-5.5` uses Claude `claude-opus-5-5` and Pi `opus-5.5@300k`. If usage cannot be read, treat Pi as catalog-compatible only.

Use a Herdr worktree for a second writer. Do not close panes, tabs, workspaces, or sessions that Dmnkstack did not create.

## No manager

If neither environment is active, reuse the current session only when it runs the selected model or an explicit role fallback. Otherwise stop and report the missing executor. Disclose every substitution, and never let the author's session replace an independent reviewer. Do not launch a terminal manager behind the user's back.
