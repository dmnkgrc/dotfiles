---
name: deliver
description: Prepare and publish a completed software change through the user's requested git workflow. Use when the user explicitly asks to commit, push, open or update a pull request, babysit or watch a PR, address delivery checks or review findings, rebase a PR, says "full stop", or hands off a branch. This skill does not authorize merging, deploying, or publishing when those actions were not requested.
---

# Deliver

Publish only the actions the user authorized.

1. Confirm the repository, branch, base branch, remote, and working tree.
2. Separate task changes from unrelated user edits.
3. Run the verification required by the changed artifact. Use `verify` when the completion claim needs a realistic behavior check. For pull requests, capture visual evidence as described below.
4. Review the final diff for scope, generated artifacts, secrets, attribution, comment volume, and accidental project-specific content. Remove comments that restate the code or a test name; keep only those that record a non-obvious constraint or a deliberate workaround, at one or two lines each.
5. Commit without bypassing hooks or adding an agent co-author.
6. Push the intended branch without rewriting shared history. To bring a long-lived branch up to date (many commits, or a deployed preview built from it), merge the base: a rebase replays the same conflicts at every commit that touches a generated or list file. Rebase short branches, or when the user asks.
7. Create or update the pull request against the requested base. State the behavior change and exact checks run. For visual changes, run `before-and-after` Publish in the same turn. `gh pr create` or `gh pr edit` must get `--body-file` and `--attach`. Pasting the comparison into the chat does not update the PR.
8. Watch the PR with [references/babysit.md](references/babysit.md): checks on the pushed head, review comments, and base-branch drift. Before fixing a failed check, check whether the base branch fails the same check; report a base-branch failure instead of patching it into this change.
9. Read the created remote object back and report its URL and state. For visual evidence, the fetched body must contain `https://github.com/user-attachments/assets/` URLs inside `<!-- before-and-after:start/end -->`. Open the rendered PR and confirm images load, videos play, and no local attachment paths remain.

## Visual evidence for pull requests

For changes to visible UI or user interactions, load the bundled [`before-and-after`](../before-and-after/SKILL.md) skill and finish its Publish step. Keep that workflow in the specialist skill rather than duplicating its commands here. Showing the formatted block in chat is not delivery.

- Use before/after screenshots for static visual changes. Capture the same viewport and state against the base and changed versions. For new UI, use an after-only Preview. If the baseline cannot run, label the evidence as a preview and disclose the missing comparison.
- Include a short screen recording when behavior depends on motion, timing, gestures, or a multi-step interaction that screenshots cannot demonstrate. Show the changed behavior, not just navigation to the screen. Reuse suitable evidence from verification instead of capturing it twice.
- Put evidence near the top of the PR, before implementation details. Preserve unrelated PR prose and replace only the skill's marked block when updating it. The handoff is the PR URL after the fetched body contains GitHub attachment URLs. Do not paste the block into the chat.
- Check captures for secrets and private data before uploading. Do not commit capture files unless requested.
- Skip media for changes with no meaningful visible behavior. If capture or upload prerequisites are missing, follow the bundled skill's setup steps first. If setup or uploads still fail, report the missing evidence and blocker in the PR and handoff. Do not claim visual verification succeeded.

## Full stop

When the user says "full stop", or a delegation contract grants it, own the change from its current state to a PR that is ready for the user to merge. The user is not watching, so do not stop at each step to ask.

The request authorizes, for this task's branch and PR only:

- commit, push, and open or update the PR;
- request review from the repository's review bots (for example Greptile) on every new head, following the repository's PR skill for how to trigger them;
- rebase or merge the base, resolve conflicts, and push with `--force-with-lease`;
- fix failed checks and real review findings, and reply to and resolve findings you decline;
- the test methods needed to prove the change, including running the app and browser automation.

It never authorizes merging, enabling auto-merge, entering a merge queue, requesting human reviewers, pushing to the default branch, closing a PR, or changing anything outside the repository.

Run steps 1–9, then babysit until the ready gate passes on the latest head:

- Proof from this session covers every change in the diff.
- Required checks are green.
- The review bots reviewed the latest head, and each finding is fixed or declined with a written reason.
- No human review still requests changes.
- The branch is not `BEHIND` or `DIRTY`, and no base commits that landed after the last green run touch this PR's files.

Ask only when you cannot continue alone: the change cannot be proven, the gate cannot pass and you cannot fix it, the goal is ambiguous in a way that changes the result, another PR makes this one obsolete, or the next step is outside the grant. Put the PR link, blocker, and options in the question. Decide everything else and list those decisions in the report.

Report the PR link, final head, verdict (ready, waiting on human approval, or blocked), proof, review outcome, declined findings, and remaining risks. State that the PR is open and unmerged.

Preserve global authentication and git configuration. Use an account-scoped command when several credentials exist. Do not merge, deploy, delete branches, or close work unless the user requested that action.
