# Default models

Copy the complete map below into `models.md`. Lists are ordered candidate pools, not automatic panels. Efforts are starting points; Dmnkstack's routing policy chooses difficulty and escalation separately. Preserve custom roles with a `custom/` prefix and an explicit fallback. Exhausted chains stop rather than falling back to the current model.

Claude Code aliases are `fable` and `claude-opus-5-5`. Pi uses `fable-5-1@300k`, `opus-5.5@300k`, and `grok-4.7@256k`. Anthropic models use Pi only while Cursor included API usage remains (`planUsage.apiPercentUsed` below 100). OpenAI Codex and Grok models use Pi only. Auto or Composer remaining does not count.

```md
feature, refactoring: grok-4.7 @ high
bug-fix, perf-issue, hillclimb: gpt-6-sol @ high
general implementation: opus-5.5 @ medium
fast mechanical work: gpt-6-luna @ low
judgment: fable-5.1 @ high
prose: gpt-6-luna @ low, fable-5.1 @ high
hardest tasks: opus-5.5 @ max

how explorer: grok-4.7 @ high
how explainer: grok-4.7 @ high
how critics: opus-5.5 @ high, grok-4.7 @ high, gpt-6-sol @ high, fable-5.1 @ high
why investigators: grok-4.7 @ high
why synthesizer: grok-4.7 @ high

reflect tooling: gpt-6-sol @ high
reflect judgment, divergent, synthesizer: gpt-6-sol @ high

arena runners: gpt-6-sol @ high, grok-4.7 @ high, opus-5.5 @ high, fable-5.1 @ high
arena cross-judge pool: opus-5.5 @ high, grok-4.7 @ high, gpt-6-sol @ high, fable-5.1 @ high
swarm workers: grok-4.7 @ high
architect runners: opus-5.5 @ high, grok-4.7 @ high, gpt-6-sol @ high, fable-5.1 @ high
interrogate reviewers: opus-5.5 @ high, grok-4.7 @ high, gpt-6-sol @ high, fable-5.1 @ high

fallback feature, refactoring, swarm workers: opus-5.5 @ high, gpt-6-sol @ high, fable-5.1 @ high, gpt-6-luna @ max
fallback how explorer, how explainer, why investigators, why synthesizer: gpt-6-luna @ max, opus-5.5 @ high, gpt-6-sol @ high, fable-5.1 @ high
fallback bug-fix, perf-issue, hillclimb, reflect tooling, reflect judgment, divergent, synthesizer: opus-5.5 @ high, fable-5.1 @ high, grok-4.7 @ high, gpt-6-luna @ max
fallback general implementation: grok-4.7 @ high, gpt-6-sol @ high, fable-5.1 @ high, gpt-6-luna @ max
fallback fast mechanical work: grok-4.7 @ low, opus-5.5 @ high, gpt-6-sol @ high, fable-5.1 @ high
fallback judgment: opus-5.5 @ high, gpt-6-sol @ high, grok-4.7 @ high, gpt-6-luna @ max
fallback prose: opus-5.5 @ high, gpt-6-sol @ high, grok-4.7 @ high
fallback hardest tasks: fable-5.1 @ max, gpt-6-sol @ max, grok-4.7 @ high, gpt-6-luna @ max
fallback how critics, arena runners, arena cross-judge pool, architect runners, interrogate reviewers: grok-4.7 @ high, gpt-6-luna @ max
```

These defaults match the live map in `.config/dmnkstack/models.md`. Change assignments after comparable recorded outcomes or a direct user instruction.
