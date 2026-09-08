# Launchers

Select the model first. Read `${XDG_CONFIG_HOME:-$HOME/.config}/dmnkstack/launchers.toml`, then choose an executor that can run the model.

Reuse the current session only when its actual model matches the selection, or the documented phase-retention rule applies. An executor supporting a model does not mean the current session is running it. Resolve `fallback ROLE` targets in order; stop when none satisfy the task. Never fall back to an unnamed current model. Codex and Pi both support the OpenAI Codex model family. Do not maintain separate Pi model routes.

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

The parent owns the whole round trip:

1. Give the child a complete contract with scope, repository instructions, selected project skills, write authority, and expected evidence.
2. Read and retain the session ID returned by `session create`.
3. Poll `conductor --json session status <session-id>` until the session reaches a terminal state.
4. Fetch the transcript with `conductor --json session message <session-id> --limit 100`, following pagination when required.
5. Extract the child's final `RESULT`, `EVIDENCE`, `CHANGES`, `GAPS`, and `NEXT` sections.
6. Verify claimed artifacts and evidence, then report the useful result in the parent session with the agent, model, and session ID.

The child does not push a message into the parent session. The parent must collect and report it. Preserve the child session for inspection.

If local Keychain auth is absent or `session create` reports a missing credential, stop and report that prerequisite without retrying or switching managers.

Do not create a new workspace for a read-only specialist. One delegated writer may use the current workspace while the parent stops editing. Use separate workspaces only for independent writers.

## Herdr in Kitty

Kitty hosts Herdr. It is not an agent launcher itself.

Use Herdr only when `HERDR_ENV=1`. Before controlling panes, run `herdr --skill` and follow the installed instructions because its CLI is the authority.

The normal flow is:

1. Split the current pane without moving focus and preserve the current directory.
2. Read the returned pane ID.
3. Start the resolved agent in that pane.
4. Submit a complete prompt and wait for a settled state.
5. Read the agent output and keep the parent responsible for the final result.

```sh
herdr pane split --current --direction right --cwd "$PWD" --no-focus
herdr agent start <name> --kind <kind> --pane <pane-id> -- <native-agent-args>
herdr agent prompt <name> <task> --wait --timeout 120000
herdr agent read <name> --source recent-unwrapped --lines 120
```

Native model arguments:

- Codex: `-m <model> -c model_reasoning_effort=\"<effort>\"`
- Pi: `--provider <catalog-provider> --model <model> --thinking <effort>`. Preserve the provider from discovery; do not assume every model uses OpenAI Codex.
- Claude: `--model <model> --effort <effort>`
- Cursor: `--model <model>`. Omit effort when the direct CLI does not expose it.

Use a Herdr worktree for a second writer. Do not close panes, tabs, workspaces, or sessions that Dmnkstack did not create.

## No manager

If neither environment is active, reuse the current session only when it runs the selected model or an explicit role fallback. Otherwise stop and report the missing executor. Disclose every substitution, and never let the author's session replace an independent reviewer. Do not launch a terminal manager behind the user's back.
