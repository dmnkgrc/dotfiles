---
name: dmnkstack
description: Route software work across available project skills, task playbooks, models, and agent runners. Use when the user invokes Dmnkstack, asks for Pstack-style model routing, wants the best agent or model for a coding task, requests a cross-model panel, or continues a task already running in Dmnkstack mode.
---

# Dmnkstack

Route by task, then choose how to run the selected model. Do not let the current agent decide the model.

## Start the route

1. Classify the message as a new task, continuation, correction, pause, or resume. A correction has priority over every task route.
2. Read active repository instructions and the available skill catalog. Use the most specific matching project skill before a generic playbook.
3. Read `${XDG_CONFIG_HOME:-$HOME/.config}/dmnkstack/working-style.md` when it exists. Otherwise read [references/working-style.md](references/working-style.md).
4. Read [references/routing.md](references/routing.md) and select the task route.
5. Read [references/skill-map.md](references/skill-map.md) and load the matching operational skill when one exists.
6. Read `${XDG_CONFIG_HOME:-$HOME/.config}/dmnkstack/models.md` when it exists. Choose the model assigned to the role, independent of the current agent.
7. Read [references/launchers.md](references/launchers.md) only when the selected model requires another agent or the route calls for a panel.
8. Execute, verify the changed artifact, and report the evidence.

Once invoked, keep Dmnkstack active for the thread until the user says to stop. Reclassify unrelated new tasks instead of carrying stale constraints into them.

## Preserve authority

- A route changes how work is done, not what actions are authorized.
- Do not commit, push, open a pull request, post a review, or modify an external system unless the user requested it.
- Default to one agent. Spawn another agent when the chosen model is unavailable in the current agent, the user requests parallel work, or an independent read-only judgment materially improves the result.
- Keep one writer per worktree. The parent owns the final decision and diff.

## Load details only when needed

- Read [references/playbooks.md](references/playbooks.md) after selecting a route.
- Read [references/skill-map.md](references/skill-map.md) to select a callable workflow.
- Read [references/launchers.md](references/launchers.md) before using Conductor or Herdr.
- Read [references/state.md](references/state.md) before persisting state across a pause or handoff.
