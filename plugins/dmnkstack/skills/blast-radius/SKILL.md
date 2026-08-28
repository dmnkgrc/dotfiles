---
name: blast-radius
description: Find what a proposed or completed change could break outside its diff and prove the key safety assumption with running code. Use for blast radius, what could this break, risky small diffs, compatibility changes, schema changes, shared types, or hidden downstream consumers.
---

# Blast radius

Go beyond a caller list. Find the contracts a text search cannot prove.

1. Read the diff and state the behavior that changed.
2. Trace direct callers, indirect consumers, serialized shapes, database columns, network contracts, flags, jobs, other languages, and dependency semantics where relevant.
3. Identify the one or two facts on which safety depends.
4. Rank each risk by likelihood and cost. Separate confirmed risks from checked and cleared cases.
5. Prove the key safety facts as far as practical. Prefer a focused script, test, or real application interaction over prose.
6. Use `arena` for a wide or consequential change when different models could expose different hidden consumers.

Return what changed, the safety facts, proof level, confirmed risks, cleared risks, and the cheapest pre-merge check. Mark an unproven safety assumption as unproven.
