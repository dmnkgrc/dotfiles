---
name: dmnkstack
description: Route software work across available project skills, task playbooks, models, and agent runners. Use when the user invokes Dmnkstack, asks for Pstack-style model routing, wants the best agent or model for a coding task, requests a cross-model panel, or continues a task already running in Dmnkstack mode.
---

# Dmnkstack

Route every task through TypeSafe Jev, then choose how to run the selected model. Do not let the current agent replace the router's semantic choices.

## Start the route

1. Deterministically classify the message as a new task, continuation, correction, pause, or resume. A correction has priority over every task route.
2. Run the always-on router before execution, passing the exact current task and the deterministic conversation state. Use `--prior-task` and `--active-route` for continuations or corrections:
   ```sh
   python3 ~/.agents/skills/dmnkstack/scripts/route.py --conversation-state new 'TASK'
   ```
   Run it directly from the current shell; bash, zsh, and fish all work and no `fish -lc` wrapper is needed. `route.py` loads `TYPESAFE_API_KEY` from the process env, then `${XDG_CONFIG_HOME:-$HOME/.config}/dmnkstack/typesafe.env` when present, then a login shell (fish, bash, zsh). Do not print the command with an expanded key. A nonzero exit or `status: error` means TypeSafe did not route the task: report the explicit failure and stop rather than substituting a local semantic guess.
3. Read active repository instructions, then load the router-selected installed skill when it is not `none`. An explicitly invoked or mandatory skill remains a deterministic constraint and takes precedence over a semantic suggestion. The router discovers installed skills from current `SKILL.md` frontmatter; [references/skill-map.md](references/skill-map.md) is explanatory, not the selection catalog.
4. Read `${XDG_CONFIG_HOME:-$HOME/.config}/dmnkstack/working-style.md` when it exists. Otherwise read [references/working-style.md](references/working-style.md).
5. Read [references/routing.md](references/routing.md) and apply its deterministic authority, difficulty, effort, availability, quota, fallback, and phase rules to the structured route.
6. Read [references/integrations.md](references/integrations.md) when the request contains a design, bug capture, issue, document, trace, run, workflow, dashboard, or other external evidence source. If Executor MCP is connected, fetch those sources through it before a host-only Linear, Figma, or Notion connector.
7. Read `${XDG_CONFIG_HOME:-$HOME/.config}/dmnkstack/models.md`. If missing or a broken symlink, report the configuration problem and use `setup-dmnkstack` rather than silently ignoring the assignments. Verify the routed model and starting effort against current launcher configuration before launch.
8. Load `delegate` when the selected model requires another agent, the user requests another agent, or the route calls for a panel. Then read [references/launchers.md](references/launchers.md).
9. Inside Conductor, use a new same-workspace session for that delegation. The parent must wait for the child, collect its transcript, verify its evidence, and report the result back.
10. Execute, reassess at phase boundaries, verify the changed artifact, and report the evidence. Append a privacy-safe outcome through `reflect-dmnkstack` so future route changes can use measured results.

Once invoked, keep Dmnkstack active for the thread until the user says to stop. Reclassify unrelated new tasks instead of carrying stale constraints into them.

## Preserve authority

- A route changes how work is done, not what actions are authorized.
- Do not commit, push, open a pull request, post a review, or modify an external system unless the user requested it.
- Default to one agent. Delegate when the chosen model is unavailable in the current agent, the user requests another agent or parallel work, or an independent read-only judgment materially improves the result.
- Keep one writer per worktree. The parent owns the final decision and diff.
- Prefer Executor MCP (`executor` or `cortea` from executor.sh) for Linear, Figma, and other catalog tools when that server is connected. That MCP is not the agent executor in launchers.md.

## Load details only when needed

- Read [references/playbooks.md](references/playbooks.md) after selecting a route.
- Read [references/integrations.md](references/integrations.md) to route external evidence through installed specialist skills.
- Read [references/skill-map.md](references/skill-map.md) to select a callable workflow.
- Read [references/launchers.md](references/launchers.md) before using Conductor or Herdr.
- Read [references/state.md](references/state.md) before persisting state across a pause or handoff.
