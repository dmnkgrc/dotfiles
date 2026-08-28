---
name: how
description: Trace and explain how a subsystem, feature, request path, or module works. Use for code walkthroughs, ownership questions, layering questions, onboarding explanations, runtime flow, or architectural critique. Use why when the question asks for historical motivation.
---

# How

Build a working mental model from real code.

## Explore

1. State the interpreted question and scope. Proceed with the best supported interpretation when it is slightly ambiguous.
2. Read repository instructions and matching domain skills.
3. Find the entry point, important types, state owners, boundaries, and output or effect.
4. Trace the call and data flow end to end. Read implementations, callers, schemas, and configuration rather than inferring from filenames.
5. Note surprising behavior, hidden state, ownership seams, and assumptions a newcomer could miss.

For a narrow question, explore in one pass. For a subsystem spanning several independent areas, use two to four read-only explorers on the `how explorer` model role, then synthesize with `how explainer`. Route those agents through Dmnkstack. Do not fan out when one trace is enough.

## Explain

Lead with a short overview. Then cover the key concepts, step-by-step flow, ownership map, and gotchas. Cite local files and symbols so the reader can verify the explanation. Include a small flow diagram only when it makes several relationships easier to understand.

For critique, explain the current design first. Then challenge it with read-only reviewers and separate current behavior from recommended changes.
