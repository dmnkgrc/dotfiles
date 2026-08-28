---
name: deliver
description: Prepare and publish a completed software change through the user's requested git workflow. Use when the user explicitly asks to commit, push, open or update a pull request, address delivery checks, or hand off a branch. This skill does not authorize merging, deploying, or publishing when those actions were not requested.
---

# Deliver

Publish only the actions the user authorized.

1. Confirm the repository, branch, base branch, remote, and working tree.
2. Separate task changes from unrelated user edits.
3. Run the verification required by the changed artifact. Use `verify` when the completion claim needs a realistic behavior check.
4. Review the final diff for scope, generated artifacts, secrets, attribution, and accidental project-specific content.
5. Commit without bypassing hooks or adding an agent co-author.
6. Push the intended branch without rewriting shared history.
7. Create or update the pull request against the requested base. State the behavior change and exact checks run.
8. Read the created remote object back and report its URL and state.

Preserve global authentication and git configuration. Use an account-scoped command when several credentials exist. Do not merge, deploy, delete branches, or close work unless the user requested that action.
