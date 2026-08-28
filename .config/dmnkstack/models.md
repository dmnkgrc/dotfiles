# Dmnkstack model routes

# Format: `role: model @ effort`. A role may list several models for a panel. The launcher chooses an agent that can run the selected model.

feature, refactoring: grok-4.6 @ xhigh
bug-fix, perf-issue, hillclimb: gpt-5.6-sol @ max
general implementation: gpt-5.6-terra @ high
fast mechanical work: gpt-5.6-luna @ low
judgment, prose, hardest tasks: fable-5 @ max

how explorer: grok-4.6 @ xhigh
how explainer: fable-5 @ max
how critics: fable-5 @ max, gpt-5.6-sol @ max, grok-4.6 @ xhigh, opus-5-1m @ xhigh

why investigators: grok-4.6 @ xhigh
why synthesizer: fable-5 @ max

reflect tooling: gpt-5.6-sol @ max
reflect judgment, divergent, synthesizer: fable-5 @ max

arena runners: fable-5 @ max, gpt-5.6-sol @ max, grok-4.6 @ xhigh, opus-5-1m @ xhigh
arena cross-judge pool: fable-5 @ max, gpt-5.6-sol @ max, grok-4.6 @ xhigh, opus-5-1m @ xhigh
swarm workers: grok-4.6 @ xhigh
architect runners: fable-5 @ max, gpt-5.6-sol @ max, grok-4.6 @ xhigh, opus-5-1m @ xhigh
interrogate reviewers: fable-5 @ max, gpt-5.6-sol @ max, grok-4.6 @ xhigh, opus-5-1m @ xhigh

unavailable target fallback: current
