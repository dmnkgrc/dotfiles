# Dmnkstack model routes

# Format: role[, role]: model @ effort[, model @ effort].
# Multiple targets are an ordered candidate pool, not an automatic fan-out.
# Efforts are starting points; routing.md defines escalation.
# fallback ROLE[, ROLE]: ordered replacement targets. Exhaustion means stop.
# Custom roles must use the prefix custom/.

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
