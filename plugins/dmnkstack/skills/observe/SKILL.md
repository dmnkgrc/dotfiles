---
name: observe
description: Investigate runtime behavior through installed observability and data skills or connectors. Use for Datadog logs, APM traces, metrics, Braintrust spans or evals, Temporal executions, Sentry events, BigQuery or Metabase evidence, production incidents, request IDs, workflow IDs, run IDs, and questions that need live or historical runtime facts.
---

# Observe

Collect runtime facts before choosing a story.

## Select sources

- Use Datadog for logs, APM traces, service metrics, monitors, and time-correlated runtime behavior.
- Use Braintrust for LLM spans, model inputs and outputs, eval results, and pipeline-level behavior.
- Use Temporal for workflow event history, activity attempts, retries, timeouts, and execution state.
- Use Sentry for exceptions, stack traces, releases, and error frequency.
- Use BigQuery or Metabase for persisted product or pipeline facts when runtime telemetry cannot answer the question.

Discover installed skills and connectors by capability. Prefer the repository's specialist skill. Do not encode project queries or schemas in Dmnkstack.

## Investigate

1. State the question, environment, time range, and strongest available identifier.
2. Start with the narrow identifier such as a trace, request, workflow, run, user, or release ID.
3. Expand the time range or query only when the first result creates a specific next question.
4. Preserve source provenance and units. Do not merge logs, spans, metrics, and warehouse rows into one unsupported claim.
5. Separate direct observations, correlations, hypotheses, and missing evidence.
6. Route the result into `debug`, `why`, or `verify` according to the user's requested outcome.

Keep the investigation read-only unless the user explicitly asks to modify monitors, dashboards, datasets, or other external state. Return identifiers, time bounds, source-specific findings, correlations, confidence, and gaps.
