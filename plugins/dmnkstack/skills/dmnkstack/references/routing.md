# Routing

## Optional TypeSafe routing

Run `scripts/route.py` for every Dmnkstack task from whatever shell is current (bash, zsh, or fish). It loads `TYPESAFE_API_KEY` from the process env, then `${XDG_CONFIG_HOME:-$HOME/.config}/dmnkstack/typesafe.env` when present, then a login shell (fish, bash, zsh); never print the expanded key. When a key is configured, TypeSafe Jev selects only the semantic task route, matching installed skill, and best model from the deterministically eligible configured candidates. The router may rerank close skill candidates using their detailed installed instructions. It sends the task, conversation routing context, and installed skill metadata to TypeSafe, but its structured output and logs must not retain that content.

If no key is configured, the script returns `status: local` with zero TypeSafe calls and exits successfully before skill discovery or provider queries. The current agent selects the route from the table below and the skill from installed frontmatter, then applies the same difficulty, model-pool, effort, availability, and quota rules. State that routing was local. Do not request a key or stop solely because TypeSafe is unconfigured. A local handoff is not a completed model selection or proof of availability.

TypeSafe never decides conversation correction precedence, authority, commits, pushes, external actions, completion claims, difficulty, effort, model availability, or quota eligibility. Those remain deterministic. Explicitly invoked and mandatory skills still take precedence over semantic suggestions. With a configured key, a TypeSafe or API failure is a stop condition and must be reported as such; never claim a local fallback was TypeSafe-routed.

The model profiles are:

- Grok 4.7: broad features, refactors, repository exploration, mechanics, history, and swarm work.
- GPT-5.6 Sol: unknown bugs, performance regressions, incidents, environment failures, and iterative evidence-driven repair.
- Opus 5: bounded implementation and architecture across APIs, types, ownership, and module boundaries.
- GPT-5.6 Luna: deterministic mechanical edits with a known check and routine pull request descriptions assembled from verified facts.
- Fable 5.1: judgment, complex or high-stakes prose, synthesis, tradeoffs, and unusual hardest tasks. A migration interface supporting old and new callers may route here; routine pull request descriptions should prefer Luna.

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
| Review a diff or pull request | review | Dmnkstack review playbook; `interrogate` for adversarial review | interrogate reviewers |
| Fix local tools, config, or environment | environment | `debug` | bug-fix |
| Compare independent solutions | arena | `arena` | arena runners |
| Split independent slices | swarm | `swarm` | swarm workers |
| Design a workflow for unusual work | custom | `figure-it-out` | hardest tasks |
| Resume prior work | resume | `recall` | how explorer and how explainer |
| Keep an audit trail | state | `show-me-your-work` | current |
| Run work through another model or agent | delegation | `delegate` | selected task role |
| Publish an authorized change | delivery | `deliver` | current |

Use the narrow role when several match. A small mechanical edit does not need a feature model. An unknown failure stays in diagnosis until evidence identifies a change.

## Difficulty and effort

Choose the role from scope and uncertainty, not just the task label:

- Mechanical: deterministic edits with a known check, such as formatting or a proven rename. Use `fast mechanical work` at its configured low effort.
- Bounded: clear acceptance criteria, established patterns, and a local verification path. Use `general implementation`, including small features, refactors, and fixes whose cause is already proven.
- Uncertain: an unknown cause, competing designs, or changes across ownership boundaries. Use the task's specialist role at its configured starting effort.
- Consequential: security, money, concurrency, durable state, or hard-to-reverse migrations. Keep the specialist model and raise effort to the highest supported level. Never trade away validation or independent review to save cost.

Separate model choice from effort. Start at the configured effort; raise it one supported level when a hypothesis fails or verification exposes a reasoning gap. Do not escalate for a missing dependency, credential, or other environment prerequisite. After two failed reasoning attempts at the same problem, select the next capable model from the role's fallback chain and carry forward the evidence. If none is available, report the blocker. Do not loop through the chain indefinitely.

## Phase routing

Reassess after diagnosis, design, and implementation. A proven cause with a bounded fix can move from `bug-fix` to `general implementation`; running a known check can use `fast mechanical work`. Failing checks return to diagnosis rather than repeated mechanical retries.

A phase change does not require a new agent. Keep small tasks in one session when transferring context would cost more than the remaining work. Record that retention instead of claiming the preferred model ran. Independent review always uses a fresh read-only agent, never the author's own session.

## Candidate pools and fallback

Before selecting a model in either mode, collect and normalize live provider usage. Cursor models such as Grok use DashboardService Auto usage; Pi-hosted Anthropic models use its API usage. Claude uses the CLI `/usage` structured-output path, and Codex uses `codex app-server` JSON-RPC `account/rateLimits/read`. Do not scrape Codex terminal or ANSI output. Preserve explicit launcher and catalog availability checks. Unknown usage does not mean exhausted.

Preserve the configured pool order. Remove unavailable and exhausted primary candidates, then rank the healthy primary pool using TypeSafe when configured or local judgment otherwise. If no healthy primary remains, do the same for the fallback pool. Retain scarce primary or fallback candidates only when no healthy candidate exists in either pool. A candidate with unknown usage remains eligible rather than being falsely marked exhausted. Report normalized usage and any scarcity substitution without prompts, repository content, credentials, or raw provider output.

Lists in `models.md` are candidate pools. TypeSafe or the current agent ranks eligible models within the active pool using the capability profiles above; file order is not a semantic ranking. For ordinary review, use one fresh reviewer. For consequential work or a material disputed finding, add a second reviewer from a different model family when available. Explicit multi-model review uses at least two models. Reserve all four for an explicit full-panel request or an unresolved consequential disagreement. Apply the same sizing to `how critics` and design comparisons; an explicit arena still needs at least two attempts.

Try the primary pool, then the `fallback ROLE` pool. Check the model, effort, executor, provider when required, manager, and authentication before launch. Never interpret `current` as a model fallback. Reuse the current session only if its actual model meets the selection or the phase-retention rule applies.

Fallback must preserve authority, required tools, and independence. Exclude the author's session from review and its model from cross-model review. Deduplicate models after substitution; duplicate fallbacks do not count as independent models. Stop and report reduced coverage if the requested panel cannot be filled. Disclose the requested target, actual model/executor/effort, and reason for any substitution. Missing Conductor authentication remains a stop condition, not permission to switch managers.

## Execution shape

Use a single agent by default. Briefly state the role, difficulty, actual model/effort, and any substitution before execution. At task completion, append model-route evidence using `reflect-dmnkstack/references/evidence.md`, including failed or blocked attempts. Do not change model defaults automatically. Use several agents only when their work is independent or read-only. A panel returns opinions to the parent and does not edit. If several implementations are useful, give each a separate worktree.

Every delegated prompt must contain the task, scope, active constraints, selected project skills, whether edits are allowed, and the expected evidence. Use `delegate` to create the child session, collect its result, and report it back. Do not give a child more authority than the parent has.
