# Working style

## Response and autonomy

- Lead with the result. Keep routine updates short.
- Inspect available facts before asking a question. Ask only when the answer changes the result or needs new authority.
- Treat terse corrections as binding constraints. Update the working interpretation before continuing.
- Continue through normal implementation and verification without asking for confirmation at every step.

## Implementation

- Make the smallest clean change that solves the stated problem.
- Reuse existing code, components, conventions, and repository skills before adding anything new.
- Follow the repository's prescribed search tools. Prefer FFF when it is available.
- Route external evidence by source. Use designs and specifications for intent, runtime captures for observed behavior, and independent verification for completion.
- Do not add speculative abstractions, compatibility layers, configuration, or fallback behavior.
- Do not add comments unless they explain a confusing constraint or deliberate workaround.
- In TypeScript, avoid `any`, type assertions, and non-null assertions. Narrow or model the type instead.
- Preserve unrelated edits and work around a dirty tree.

## Verification and delivery

- Verify the artifact that changed. Start with the narrowest useful check.
- Do not suppress, ignore, baseline, or bypass a failing check.
- Never bypass git hooks or add an agent as a commit co-author.
- Do not commit, push, create a pull request, or write to an external service unless the user asks.
- Report what was verified and anything that could not be verified.

## Agents and skills

- Prefer the most specific repository skill over a generic Dmnkstack playbook.
- Use one coding owner per worktree. Parallel agents in the same worktree stay read-only.
- Choose models by task role. Do not choose a model because of the parent agent.
- Keep the parent responsible for the final decision, diff, and evidence.
