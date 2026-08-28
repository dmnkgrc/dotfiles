---
name: design-handoff
description: Turn a Figma design, node URL, screenshot, or visual specification into project-native UI code and verify it in the running product. Use for Figma-to-code work, design implementation, visual parity, responsive states, component mapping, or UI changes where the design is the source of truth.
---

# Design handoff

Use the design as evidence and the repository design system as the implementation language.

1. Load the installed Figma skill before calling Figma tools. Fetch the exact node, screenshot, variables, component metadata, and assets required by the request.
2. Read repository UI instructions and the most specific design-system or frontend skill.
3. Inspect adjacent production components before choosing the implementation shape.
4. Map Figma components, variables, spacing, typography, color, assets, states, and responsive behavior to existing project components and tokens.
5. Name any conflict between the design, current product behavior, and project conventions. Do not silently guess missing states.
6. Implement the smallest complete vertical slice. Reuse assets and components before adding new ones.
7. Verify the running UI in a real browser. Compare the rendered state with the source node at relevant viewport sizes and interaction states.
8. Check accessibility, loading, empty, error, focus, hover, and reduced-motion behavior when the component needs them.

Use the feature model role for implementation. Use `arena` only when the design leaves a consequential interaction or layout decision unresolved.

Return the source node, component mapping, deviations and reasons, browser evidence, and remaining visual gaps.
