# Routing

## Precedence

Apply constraints in this order:

1. Current user request and explicit corrections
2. Scoped repository instructions
3. Mandatory skill triggers
4. The most specific matching project skill
5. Dmnkstack working style and playbook defaults

Project skills own domain rules. Dmnkstack owns task classification, model choice, agent coordination, and proof. Never copy project-specific rules into Dmnkstack.

## Conversation state

- New task: discard task-specific assumptions from the previous task, then route again.
- Continuation: preserve accepted constraints and current evidence.
- Correction: restate the changed constraint in plain language, discard conflicting assumptions, and continue from the earliest affected step.
- Pause: record only the facts required to resume.
- Resume: verify the repository and branch before trusting saved state.

## Task routes

| Signal | Route | Operational skill | Default model role |
| --- | --- | --- | --- |
| Explain mechanics, trace, or ownership | investigation | `how` | how explorer and how explainer |
| Recover motivation or history | investigation | `why` | why investigators and why synthesizer |
| Learn a subsystem deeply | investigation | `teach` | how and why roles |
| Diagnose or fix a failure | bug-fix | `debug` | bug-fix |
| Triage a Jam or captured bug report | bug-fix | `jam-triage` | bug-fix |
| Investigate logs, traces, metrics, runs, or workflows | investigation | `observe` | bug-fix, perf-issue, or why roles |
| Prove a completion claim | verification | `verify` | bug-fix or fast mechanical work |
| Write the failing regression first | bug-fix | `tdd` | bug-fix |
| Assess hidden downstream risk | review | `blast-radius` | judgment |
| Settle types, interfaces, or ownership | design | `architect` | architect runners |
| Implement a Figma or visual specification | UI | `design-handoff` | feature |
| Build new behavior | feature | Dmnkstack playbook | feature or general implementation |
| Restructure without changing behavior | refactoring | Dmnkstack playbook | refactoring |
| Change layout, interaction, or visual polish | UI | project UI skill or Dmnkstack playbook | feature |
| Repair lint, types, tests, or CI | check-repair | `debug` | bug-fix or fast mechanical work |
| Review a diff or pull request | review | `interrogate` | interrogate reviewers |
| Fix local tools, config, or environment | environment | `debug` | bug-fix |
| Compare independent solutions | arena | `arena` | arena runners |
| Split independent slices | swarm | `swarm` | swarm workers |
| Design a workflow for unusual work | custom | `figure-it-out` | hardest tasks |
| Resume prior work | resume | `recall` | how explorer and how explainer |
| Keep an audit trail | state | `show-me-your-work` | current |
| Run work through another model or agent | delegation | `delegate` | selected task role |
| Publish an authorized change | delivery | `deliver` | current |

Use the narrow role when several match. A small mechanical edit does not need a feature model. An unknown failure stays in diagnosis until evidence identifies a change.

## Execution shape

Use a single agent by default. Use several agents only when their work is independent or read-only. A panel returns opinions to the parent and does not edit. If several implementations are useful, give each a separate worktree.

Every delegated prompt must contain the task, scope, active constraints, selected project skills, whether edits are allowed, and the expected evidence. Use `delegate` to create the child session, collect its result, and report it back. Do not give a child more authority than the parent has.
