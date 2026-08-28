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

| Signal | Route | Default model role |
| --- | --- | --- |
| Explain, trace, compare, or answer | investigation | how explorer and how explainer |
| Diagnose a failure or regression | bug-fix | bug-fix |
| Build new behavior | feature | feature or general implementation |
| Restructure without changing behavior | refactoring | refactoring |
| Change layout, interaction, or visual polish | UI | feature |
| Repair lint, types, tests, or CI | check-repair | bug-fix or fast mechanical work |
| Review a diff or pull request | review | judgment |
| Fix local tools, config, or environment | environment | bug-fix |
| Compare independent solutions | arena | arena runners |
| Challenge a consequential decision | panel | how critics |

Use the narrow role when several match. A small mechanical edit does not need a feature model. An unknown failure stays in investigation until evidence identifies a change.

## Execution shape

Use a single agent by default. Use several agents only when their work is independent or read-only. A panel returns opinions to the parent and does not edit. If several implementations are useful, give each a separate worktree.

Every delegated prompt must contain the task, scope, active constraints, selected project skills, whether edits are allowed, and the expected evidence. Do not give a child more authority than the parent has.
