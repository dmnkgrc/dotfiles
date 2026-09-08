---
name: arena
description: Run several independent attempts at the same non-trivial task, judge them against one rubric, and synthesize one result. Use for arena this, competing designs, difficult prompts, prototypes, or decisions where one attempt could lock in the wrong shape.
---

# Arena

Use independent attempts to explore the design space, then produce one coherent result.

1. State the artifact and three to six concrete grading criteria.
2. Select two distinct models from the ordered `arena runners` pool by default. Use all four only for an explicit full-panel request or an unresolved consequential disagreement. Fallback duplicates do not count as distinct models; report a blocker if two cannot run. Give every runner the same task and no other candidate's work.
3. Keep outputs isolated. Use separate worktrees for writers and separate temporary paths for non-code artifacts.
4. Wait for all viable candidates before judging. Record dropouts.
5. Use a model from `arena cross-judge pool` for a read-only comparison while the parent reads every candidate.
6. Score each candidate criterion by criterion. Pick one base.
7. Bring over only compatible strengths from losing candidates. Rewrite them into the base's design rather than pasting fragments.
8. Verify the synthesized result against the original rubric and real artifact.

Route runners through Dmnkstack so model choice does not depend on the parent agent. Return the rubric, candidates, scores, chosen base, incorporated ideas, rejected ideas, disagreements, and verification result.
