---
name: deliver
description: Prepare and publish a completed software change through the user's requested git workflow. Use when the user explicitly asks to commit, push, open or update a pull request, address delivery checks, or hand off a branch. This skill does not authorize merging, deploying, or publishing when those actions were not requested.
---

# Deliver

Publish only the actions the user authorized.

1. Confirm the repository, branch, base branch, remote, and working tree.
2. Separate task changes from unrelated user edits.
3. Run the verification required by the changed artifact. Use `verify` when the completion claim needs a realistic behavior check. For pull requests, capture visual evidence as described below.
4. Review the final diff for scope, generated artifacts, secrets, attribution, comment volume, and accidental project-specific content. Remove comments that restate the code or a test name; keep only those that record a non-obvious constraint or a deliberate workaround, at one or two lines each.
5. Commit without bypassing hooks or adding an agent co-author.
6. Push the intended branch without rewriting shared history.
7. Create or update the pull request against the requested base. State the behavior change and exact checks run. Use `before-and-after` to attach captured evidence.
8. Read the created remote object back and report its URL and state. For visual evidence, open the rendered PR and confirm images load, videos play, and no local attachment paths remain.

## Visual evidence for pull requests

For changes to visible UI or user interactions, load the bundled [`before-and-after`](../before-and-after/SKILL.md) skill and follow its capture, formatting, and GitHub attachment workflow. Keep that workflow in the specialist skill rather than duplicating its commands here.

- Use before/after screenshots for static visual changes. Capture the same viewport and state against the base and changed versions. For new UI, use an after-only Preview. If the baseline cannot run, label the evidence as a preview and disclose the missing comparison.
- Include a short screen recording when behavior depends on motion, timing, gestures, or a multi-step interaction that screenshots cannot demonstrate. Show the changed behavior, not just navigation to the screen. Reuse suitable evidence from verification instead of capturing it twice.
- Put evidence near the top of the PR, before implementation details. Preserve unrelated PR prose and replace only the skill's marked block when updating it.
- Check captures for secrets and private data before uploading. Do not commit capture files unless requested.
- Skip media for changes with no meaningful visible behavior. If capture or upload prerequisites are missing, follow the bundled skill's setup steps first. If setup or uploads still fail, report the missing evidence and blocker in the PR and handoff. Do not claim visual verification succeeded.

Preserve global authentication and git configuration. Use an account-scoped command when several credentials exist. Do not merge, deploy, delete branches, or close work unless the user requested that action.
