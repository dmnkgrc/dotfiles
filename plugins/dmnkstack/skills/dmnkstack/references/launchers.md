# Launchers

Select the model first. Read `${XDG_CONFIG_HOME:-$HOME/.config}/dmnkstack/launchers.toml`, then choose an executor that can run the model.

Reuse the current agent when it supports the selected model. Codex and Pi both support the OpenAI Codex model family. Do not maintain separate Pi model routes.

## Conductor

Use Conductor when `CONDUCTOR_WORKSPACE_ID` is set. Check the installed catalog with:

```sh
conductor --json model
```

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

Read the returned session ID. Poll with `conductor --json session status <session-id>` and read the result with `conductor --json session message <session-id>`. Do not create a new workspace for a read-only specialist. Use separate workspaces only for independent writers.

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
- Pi: `--provider openai-codex --model <model> --thinking <effort>`
- Claude: `--model <model> --effort <effort>`
- Cursor: `--model <model>`. Omit effort when the direct CLI does not expose it.

Use a Herdr worktree for a second writer. Do not close panes, tabs, workspaces, or sessions that Dmnkstack did not create.

## No manager

If neither environment is active, stay in the current compatible agent. If it cannot run the selected model, use the configured fallback and disclose it. Do not launch a terminal manager behind the user's back.
