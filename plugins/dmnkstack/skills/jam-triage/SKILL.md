---
name: jam-triage
description: Turn a Jam bug report, recording, screenshot, or shared reproduction link into a scoped reproduction and evidence-backed diagnosis. Use when a request contains a jam.dev link, mentions a Jam report, or supplies captured browser events, console logs, network requests, device details, or a user-recorded bug.
---

# Jam triage

Treat the Jam as symptom evidence, not proof of the cause.

1. Open the report with an available browser tool. Use an installed Jam connector or project skill when one exists.
2. Record the reported steps, affected URL, environment, device details, timestamps, visible symptom, user events, console errors, and relevant network requests.
3. Redact tokens, cookies, credentials, personal data, and private response bodies from notes and prompts.
4. Turn the captured sequence into the smallest independent reproduction.
5. Reproduce in the closest available browser environment. Compare observed behavior with the recording instead of assuming they match.
6. Correlate timestamps, request IDs, trace IDs, and user or session identifiers through `observe` when runtime evidence is available.
7. Continue with `debug`. Preserve diagnosis-only scope when the user did not ask for a fix.
8. After a fix, rerun the independent reproduction and use `verify` against the user-visible behavior.

If the report is inaccessible, continue from any visible issue context and state exactly what could not be inspected. Ask for an accessible link or export only when the missing capture blocks the next useful step.

Return the reproduction, evidence extracted from Jam, independently observed result, correlated runtime evidence, diagnosis, and verification state.
