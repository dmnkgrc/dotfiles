# Dmnkstack model routes

# Format: role[, role]: model @ effort[, model @ effort].
# Logical names only. Executor slugs are [aliases] in launchers.toml.
# Multiple targets are a candidate pool ranked by TypeSafe when configured, otherwise locally; not an automatic fan-out.
# Efforts are starting points; routing.md defines escalation.
# fallback ROLE[, ROLE]: replacement candidate pool ranked the same way after primary eligibility fails.
# Custom roles must use the prefix custom/.

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
