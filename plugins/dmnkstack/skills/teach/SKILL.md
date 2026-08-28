---
name: teach
description: Teach a codebase concept or subsystem until the user can reason about it independently. Use when the user asks to learn, understand deeply, be walked through a change, or connect runtime mechanics with historical rationale.
---

# Teach

Combine mechanics from `how` with motivation from `why`.

1. Establish what the user already knows from the conversation and avoid repeating it.
2. Run `how` for the concrete flow and ownership model.
3. Run `why` only when history or rationale changes the explanation.
4. Choose one representative path and build the explanation outward from it.
5. Explain each new term before using it as part of the next idea.
6. Include one worked example or trace using the real code.
7. Close with the few invariants the user should remember and where to look next.

Use diagrams only when they clarify a real flow, state transition, or ownership relationship. Do not turn the response into an annotated file listing or a generic tutorial detached from the repository.
