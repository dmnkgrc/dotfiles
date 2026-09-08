# Default models

Copy the complete map below into `models.md`. Lists are ordered candidate pools, not automatic panels. Efforts are starting points; Dmnkstack's routing policy chooses difficulty and escalation separately. Preserve custom roles with a `custom/` prefix and an explicit fallback. Exhausted chains stop rather than falling back to the current model.

```md
feature, refactoring: grok-4.6 @ high
bug-fix, perf-issue, hillclimb: gpt-5.6-sol @ high
general implementation: gpt-5.6-terra @ medium
fast mechanical work: gpt-5.6-luna @ low
judgment, prose: fable-5 @ high
hardest tasks: fable-5 @ max

how explorer: grok-4.6 @ high
how explainer: fable-5 @ high
how critics: fable-5 @ high, gpt-5.6-sol @ high, grok-4.6 @ high, opus-5-1m @ high
why investigators: grok-4.6 @ high
why synthesizer: fable-5 @ high
reflect tooling: gpt-5.6-sol @ high
reflect judgment, divergent, synthesizer: fable-5 @ high

arena runners: fable-5 @ high, gpt-5.6-sol @ high, grok-4.6 @ high, opus-5-1m @ high
arena cross-judge pool: fable-5 @ high, gpt-5.6-sol @ high, grok-4.6 @ high, opus-5-1m @ high
swarm workers: grok-4.6 @ high
architect runners: fable-5 @ high, gpt-5.6-sol @ high, grok-4.6 @ high, opus-5-1m @ high
interrogate reviewers: fable-5 @ high, gpt-5.6-sol @ high, grok-4.6 @ high, opus-5-1m @ high

fallback feature, refactoring, how explorer, why investigators, swarm workers: gpt-5.6-terra @ high, gpt-5.6-sol @ high
fallback bug-fix, perf-issue, hillclimb, reflect tooling: fable-5 @ high, gpt-5.6-terra @ high
fallback general implementation: gpt-5.6-sol @ medium, grok-4.6 @ high
fallback fast mechanical work: gpt-5.6-terra @ low
fallback judgment, prose, how explainer, why synthesizer, reflect judgment, divergent, synthesizer: gpt-5.6-sol @ high, grok-4.6 @ high
fallback hardest tasks: gpt-5.6-sol @ max, opus-5-1m @ high
fallback how critics, arena runners, arena cross-judge pool, architect runners, interrogate reviewers: gpt-5.6-terra @ high
```

These defaults are a starting point, not measured rankings. Use one fresh reviewer for ordinary review and two models for explicit comparisons or consequential work. Use all four only for a requested full panel or an unresolved consequential disagreement. Change assignments after comparable recorded outcomes or a direct user instruction.
