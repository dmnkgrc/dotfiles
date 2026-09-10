# Dmnkstack model routes

# Format: role[, role]: model @ effort[, model @ effort].
# Logical names only. Executor slugs are [aliases] in launchers.toml.
# Multiple targets are an ordered candidate pool, not an automatic fan-out.
# Efforts are starting points; routing.md defines escalation.
# fallback ROLE[, ROLE]: ordered replacement targets. Exhaustion means stop.
# Custom roles must use the prefix custom/.

feature, refactoring: grok-4.6 @ high
bug-fix, perf-issue, hillclimb: gpt-5.6-sol @ high
general implementation: opus-5-1m @ medium
fast mechanical work: gpt-5.6-luna @ low
judgment, prose: fable-5.1 @ high
hardest tasks: fable-5.1 @ max

how explorer: grok-4.6 @ high
how explainer: grok-4.6 @ high
how critics: opus-5-1m @ high, grok-4.6 @ high, gpt-5.6-sol @ high, fable-5.1 @ high
why investigators: grok-4.6 @ high
why synthesizer: grok-4.6 @ high

reflect tooling: gpt-5.6-sol @ high
reflect judgment, divergent, synthesizer: gpt-5.6-sol @ high

arena runners: gpt-5.6-sol @ high, grok-4.6 @ high, opus-5-1m @ high, fable-5.1 @ high
arena cross-judge pool: opus-5-1m @ high, grok-4.6 @ high, gpt-5.6-sol @ high, fable-5.1 @ high
swarm workers: grok-4.6 @ high
architect runners: opus-5-1m @ high, grok-4.6 @ high, gpt-5.6-sol @ high, fable-5.1 @ high
interrogate reviewers: opus-5-1m @ high, grok-4.6 @ high, gpt-5.6-sol @ high, fable-5.1 @ high

fallback feature, refactoring, swarm workers: opus-5-1m @ high
fallback how explorer, how explainer, why investigators, why synthesizer: gpt-5.6-luna @ max, opus-5-1m @ high
fallback bug-fix, perf-issue, hillclimb, reflect tooling, reflect judgment, divergent, synthesizer: opus-5-1m @ high, fable-5.1 @ high
fallback general implementation: grok-4.6 @ high
fallback fast mechanical work: grok-4.6 @ low
fallback judgment, prose: opus-5-1m @ high, gpt-5.6-sol @ high
fallback hardest tasks: opus-5-1m @ high, gpt-5.6-sol @ max
fallback how critics, arena runners, arena cross-judge pool, architect runners, interrogate reviewers: grok-4.6 @ high
