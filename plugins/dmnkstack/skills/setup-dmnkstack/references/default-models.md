# Default models

Copy the complete map below into `models.md`. Lists are ordered candidate pools, not automatic panels. Efforts are starting points; Dmnkstack's routing policy chooses difficulty and escalation separately. Preserve custom roles with a `custom/` prefix and an explicit fallback. Exhausted chains stop rather than falling back to the current model.

Claude Code aliases are `fable` and `claude-opus-5-5`. Pi uses `fable-5-1@300k`, `opus-5.5@300k`, and `grok-4.7@256k`. Anthropic models use Pi only while Cursor included API usage remains (`planUsage.apiPercentUsed` below 100). OpenAI Codex models (Sol, Luna, Astra) and Grok use Pi only. Auto or Composer remaining does not count.

```md
feature, refactoring: opus-5.5 @ high
UI: gpt-6-astra @ high, opus-5.5 @ high
bug-fix: fable-5.1 @ high, opus-5.5 @ high
perf-issue, hillclimb: opus-5.5 @ high
general implementation: gpt-6-sol @ medium
fast mechanical work: gpt-6-luna @ low
judgment: fable-5.1 @ high
prose: gpt-6-luna @ low, opus-5.5 @ medium
hardest tasks: opus-5.5 @ max

how explorer: opus-5.5 @ medium
how explainer: opus-5.5 @ medium
how critics: opus-5.5 @ high, fable-5.1 @ high, gpt-6-astra @ high, gpt-6-sol @ high
why investigators: opus-5.5 @ medium
why synthesizer: opus-5.5 @ medium

reflect tooling: gpt-6-sol @ high
reflect judgment, divergent, synthesizer: gpt-6-sol @ high

arena runners: opus-5.5 @ high, fable-5.1 @ high, gpt-6-astra @ high, gpt-6-sol @ high
arena cross-judge pool: opus-5.5 @ high, fable-5.1 @ high, gpt-6-astra @ high, gpt-6-sol @ high
swarm workers: gpt-6-sol @ high
architect runners: fable-5.1 @ high, gpt-6-astra @ high, opus-5.5 @ high, gpt-6-sol @ high
interrogate reviewers: fable-5.1 @ high, opus-5.5 @ high, gpt-6-astra @ high, gpt-6-sol @ high

fallback feature, refactoring, perf-issue, hillclimb: gpt-6-astra @ high, fable-5.1 @ high, gpt-6-sol @ high, grok-4.7 @ high
fallback UI: fable-5.1 @ high, gpt-6-sol @ high, grok-4.7 @ high
fallback bug-fix: gpt-6-astra @ high, gpt-6-sol @ high, grok-4.7 @ high
fallback general implementation, swarm workers: opus-5.5 @ medium, grok-4.7 @ high, gpt-6-luna @ max
fallback fast mechanical work: gpt-6-sol @ low, grok-4.7 @ low, opus-5.5 @ low
fallback judgment: gpt-6-astra @ high, opus-5.5 @ high, gpt-6-sol @ high
fallback prose: gpt-6-sol @ medium, fable-5.1 @ high, gpt-6-astra @ high
fallback hardest tasks: gpt-6-astra @ max, fable-5.1 @ max, gpt-6-sol @ max
fallback how explorer, how explainer, why investigators, why synthesizer: gpt-6-sol @ high, fable-5.1 @ high, gpt-6-astra @ high, grok-4.7 @ high
fallback reflect tooling, reflect judgment, divergent, synthesizer: opus-5.5 @ high, fable-5.1 @ high, grok-4.7 @ high
fallback how critics, arena runners, arena cross-judge pool, architect runners, interrogate reviewers: grok-4.7 @ high, gpt-6-luna @ max
```

These defaults match the live map in `.config/dmnkstack/models.md`. Change assignments after comparable recorded outcomes or a direct user instruction.
