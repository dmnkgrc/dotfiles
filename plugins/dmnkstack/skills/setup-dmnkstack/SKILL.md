---
name: setup-dmnkstack
description: Configure or repair Dmnkstack model routes, compatible agents, and Conductor or Herdr launchers. Use when installing Dmnkstack, changing model assignments, adding an agent runtime, validating model availability, or troubleshooting why a routed model cannot start.
---

# Setup Dmnkstack

Build one model map for every agent. Keep runtime capabilities in a separate launcher file.
Resolve script paths from the directory containing this `SKILL.md`.

## Discover

Run `python3 scripts/discover.py --pretty`. It performs read-only checks for installed agents, Conductor models, Pi's OpenAI Codex models, and the current manager environment.

For Conductor, distinguish model-catalog access from session-creation readiness. On a local Mac, check `conductor auth status`; `conductor auth login` stores the token in the macOS Keychain. Other environments can use a workspace token or `CONDUCTOR_API_KEY`. Report only whether a credential source exists. Never print or persist the credential.

Read any existing files before proposing changes:

- `${XDG_CONFIG_HOME:-$HOME/.config}/dmnkstack/models.md`
- `${XDG_CONFIG_HOME:-$HOME/.config}/dmnkstack/launchers.toml`
- `${XDG_CONFIG_HOME:-$HOME/.config}/dmnkstack/working-style.md`

Preserve custom roles and unknown settings unless the user asks to replace them.

## Configure

1. Present the full role-to-model map in the Pstack-style `role: model @ effort` format.
2. Resolve each distinct model against the discovered catalog.
3. Map model families to compatible executors. Map OpenAI Codex models to both Codex and Pi.
4. Prefer the compatible current agent. Otherwise use Conductor when its workspace variable is set, then Herdr when its environment variable equals `1`.
5. Treat Conductor as ready for delegation only when discovery reports `session_create_ready`. On a local Mac, ask the user to run `conductor auth login` when Keychain auth is absent. Otherwise ask for the environment's workspace token or `CONDUCTOR_API_KEY`.
6. Set the fallback explicitly. Never claim a model is available when discovery did not prove it.
7. Write complete files atomically only after the proposed map is clear.

Read [references/default-models.md](references/default-models.md) when creating a map from scratch.

## Validate

Run:

```sh
python3 scripts/validate_config.py "${XDG_CONFIG_HOME:-$HOME/.config}/dmnkstack/models.md" --pretty
```

Report unresolved models, unsupported effort levels, and Conductor session readiness. Smoke-test one read-only prompt per distinct agent and model family when doing so will not create unexpected cost or external changes. If Conductor authentication is missing, do not retry session creation. Otherwise show the exact smoke tests and ask before running them.
