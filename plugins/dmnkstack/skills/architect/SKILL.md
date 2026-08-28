---
name: architect
description: Settle caller usage, types, interfaces, state ownership, and module boundaries before implementation. Use for architect this, design this, cross-cutting changes, concurrency, migrations, new APIs, or work where coding first could lock in the wrong shape.
---

# Architect

Design the caller-facing shape before filling in implementation details.

## Ground

1. Run `how` over every existing boundary the design touches.
2. Run `why` when historical constraints may still matter.
3. State the user-visible behavior, invariants, data ownership, failure boundaries, and concurrency model.

## Compare shapes

1. Write the caller's usage first.
2. Derive types, signatures, state transitions, and a small module map.
3. Produce at least two structurally different candidates for a consequential design. Use `arena` and the `architect runners` model role when independent judgment is useful.
4. Compare candidates on correctness, hidden complexity, reader load, migration cost, and verification.
5. Choose one coherent design. Do not average incompatible candidates.

Proceed to implementation unless the user asked for a design-only answer or checkpoint. Treat repeated implementation escape hatches, duplicated special cases, or leaking internal rules as evidence that the design is wrong. Re-ground and redesign instead of stacking workarounds.

Return the caller usage, types and signatures, ownership map, rejected alternatives, chosen rationale, migration sequence, and proof plan.
