# Integration routing

Classify the evidence source before selecting tools. Discover skills and connectors by description at run time. Use the most specific repository skill when one exists.

Prefer Executor MCP when it is connected. Hosts expose it as `executor`, `cortea`, or an executor.sh URL. Use it for Linear, Figma, Notion, Jam, Datadog, and any other service in its catalog. Read that server's execute docs, search the catalog, and call through execute. Do not open a separate host Linear, Figma, or Notion MCP or CLI for the same action unless Executor is missing or cannot do it. This is not the agent executor in launchers.md.

The table is the work route after the source is in hand.

| Source | Treat it as | Route |
| --- | --- | --- |
| Figma | UI source of truth | Fetch through Executor MCP when available, then `design-handoff`. Load any repository Figma skill, then project frontend skills and browser verification |
| Jam | Captured symptom and reproduction evidence | Fetch through Executor MCP when available, then `jam-triage`, then `observe`, `debug`, and `verify` as needed |
| Datadog | Logs, traces, metrics, monitors, and runtime correlation | Fetch through Executor MCP when available, then `observe` |
| Braintrust | LLM spans, evals, model behavior, and pipeline traces | `observe` through the installed Braintrust skill |
| Temporal | Workflow and activity execution history | `observe` through the installed Temporal skill |
| Sentry | Exception events, stack traces, releases, and error frequency | `observe` through an installed Sentry connector |
| BigQuery | Read-only persisted or historical data evidence | `observe` through the installed BigQuery skill |
| Metabase | Saved questions, dashboards, and business-facing data views | Use the installed Metabase skill, then `observe` or `verify` |
| Linear | Request, scope, acceptance criteria, and delivery record | Fetch through Executor MCP when available, then route to `why`, implementation, or `deliver` |
| Notion | Long-form specification, rationale, and decisions | Fetch through Executor MCP when available, then route to `why`, `architect`, or implementation |
| GitHub | Code history, reviews, checks, and delivery state | Use git and GitHub skills, then route to `why`, `interrogate`, `recall`, or `deliver` |
| Browser | User-visible runtime behavior | Use the installed browser skill, then `jam-triage`, `debug`, or `verify` |
| Lokalise | Translation source and synchronization state | Use the installed localization skill before editing generated locale data |
| Slack | Real-time decision or incident record | Use an installed chat connector as evidence for `why` or `observe` |

Do not treat a ticket or design as proof that the product behaves correctly. Do not treat a trace or recording as product intent. Preserve links, identifiers, timestamps, environment, and source provenance in the result.
