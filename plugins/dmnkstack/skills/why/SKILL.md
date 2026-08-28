---
name: why
description: Recover why code, architecture, thresholds, flags, or product behavior has its current shape. Use for design rationale, code archaeology, regressions, incidents, rejected alternatives, historical tradeoffs, and questions whose answer requires source control or organizational evidence. Use how for mechanics.
---

# Why

Investigate intent without turning code shape into invented history.

## Anchor the question

1. Identify the relevant files, symbols, lines, and current behavior.
2. Inspect blame, file history, commits, pull requests, and linked issues.
3. List available evidence sources by capability. Consider source control, tickets, long-form documents, team chat, observability, error tracking, and analytics.
4. Use the most specific available project skills or connectors for each source.

For a consequential or unclear question, run independent read-only investigators on the `why investigators` role. Give each one source category, the same code anchor, and the user's question. Do not ask several agents to repeat the same git search. Use `why synthesizer` to reconcile results when several sources are involved.

## Judge evidence

- Put direct statements and cited records under facts.
- Put conclusions assembled from indirect evidence under inferences.
- Show competing explanations when the record supports more than one.
- Report contradictions and searched sources that returned nothing.
- Do not claim an author's intent from code alone.

Return the question, code anchor, direct evidence, reasonable inferences, competing explanations, unknowns, and sources consulted. If the user plans to change the code, finish with constraints to preserve, change, avoid, and verify.
