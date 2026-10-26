# Babysit a pull request

Keep one watcher per PR, owned by the thread or session that owns the PR. Delegated reviewers and children that do not own the PR never watch it.

## Wait

- In Amp, subscribe the thread with `amp.create_github_subscription` (`automatic: true`) to the PR's comments and reviews, and to workflow completions for the exact head commit. Subscribe CI again after every push, because the head changed. End the turn; events wake the thread.
- Elsewhere, run `gh pr checks <pr> --watch --fail-fast` as one long command, then read new comments and reviews.
- Never write a polling or `sleep` loop. When an event needs no action, end the turn without a message. Never post or report "still waiting".

## Handle each event

1. Act only on checks, comments, and reviews newer than the latest push.
2. For a failed check, read the log. Check whether the base branch fails the same check; report a base failure instead of patching it here. Rerun a job once only when the log shows an infrastructure flake, and say so.
3. Verify every bot or human finding against the source before changing code. Fix real bugs in the intended case with the smallest change, and verify each fix before pushing it.
4. Decline the rest in a reply with a written reason, then resolve the thread: unneeded tests, guards for edge cases that do not matter, extra compatibility, small performance costs. List them as follow-ups in the report. Review loops grow a PR one cheap-looking fix at a time; prefer the fix that deletes or narrows code.

## Keep up with the base branch

After each event and before calling the PR ready, `git fetch` and check `gh pr view <pr> --json mergeStateStatus,headRefOid`. When it is `BEHIND` or `DIRTY`, or new base commits touch this PR's files:

1. Update the branch as step 6 of `deliver` describes: rebase a short branch, merge the base into a long-lived one.
2. Regenerate lockfiles, translation catalogues, and other generated files with the repository's commands. Never merge them by hand.
3. Rerun the checks the conflict could affect, including the linters.
4. Compare with `git range-diff`. Request a new bot review only when the patch changed beyond conflict context.
5. Push with `--force-with-lease=<branch>:<observed-head>`. If the lease fails, fetch and reassess.

Force-pushing needs authority: a full stop request grants it for this task's branch. Otherwise report the conflict and ask.

If another PR makes this one obsolete, stop watching and ask before closing it.

## Stop

Stop when the ready gate in `deliver`'s full stop section passes on the latest head, or when a blocker needs the user. Never merge unless the user asked for it.
