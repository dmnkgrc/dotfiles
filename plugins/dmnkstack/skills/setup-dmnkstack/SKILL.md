---
name: setup-dmnkstack
description: Configure or repair Dmnkstack model routes, compatible agents, and Conductor or Herdr launchers. Use when installing Dmnkstack, changing model assignments, adding an agent runtime, validating model availability, or troubleshooting why a routed model cannot start.
---

# Setup Dmnkstack

Build one model map for every agent. Keep runtime capabilities in a separate launcher file.
Resolve script paths from the directory containing this `SKILL.md`.

## Discover

Use Python 3.11+ for the setup scripts. Run `python3.12 scripts/discover.py --pretty`, or use another installed Python 3.11+ interpreter. It performs read-only checks for installed agents, Conductor models, all available Pi models with their providers, and the current manager environment. A catalog entry proves listing, not a successful inference or model-specific reasoning support.

For Conductor, distinguish model-catalog access from session-creation readiness. On a local Mac, check `conductor auth status`; `conductor auth login` stores the token in the macOS Keychain. Other environments can use a workspace token or `CONDUCTOR_API_KEY`. Report only whether a credential source exists. Never print or persist the credential.

Read any existing files before proposing changes:

- `${XDG_CONFIG_HOME:-$HOME/.config}/dmnkstack/models.md`
- `${XDG_CONFIG_HOME:-$HOME/.config}/dmnkstack/launchers.toml`
- `${XDG_CONFIG_HOME:-$HOME/.config}/dmnkstack/working-style.md`

Check whether the config directory is a broken symlink before reading it. For a dotfiles installation, resolve its target and verify that `models.md`, `launchers.toml`, and `working-style.md` are readable. Repair only with user authorization; never replace a real directory or unrelated link.

Preserve custom roles and unknown settings unless the user asks to replace them. The validator requires `custom/` for custom roles; propose renaming legacy custom roles rather than discarding them.

## Configure

1. Present the full role-to-model map in the Pstack-style `role: model @ effort` format.
2. Resolve each distinct model against the discovered catalog.
3. Map model families to compatible executors. Map OpenAI Codex models to both Codex and Pi.
4. Prefer the current session only when its actual model matches the selected target. Otherwise use Conductor when its workspace variable is set, then Herdr when its environment variable equals `1`.
5. Treat Conductor as ready for delegation only when discovery reports `session_create_ready`. On a local Mac, ask the user to run `conductor auth login` when Keychain auth is absent. Otherwise ask for the environment's workspace token or `CONDUCTOR_API_KEY`.
6. Set ordered `fallback ROLE` targets for every role and set launcher `selection.fallback` to `role-chain-or-stop`. Lists on primary roles are candidate pools. Validate model, effort, executor, and Pi provider together, without combining capabilities from different executors. Preserve independence when selecting reviewer fallbacks. Never claim a model is available when discovery did not prove it.
7. Write complete files atomically only after the proposed map is clear.

Read [references/default-models.md](references/default-models.md) when creating a map from scratch.

## Validate

Run:

```sh
python3.12 scripts/validate_config.py "${XDG_CONFIG_HOME:-$HOME/.config}/dmnkstack/models.md" --pretty
```

The validator reads `launchers.toml` beside the model map. Use `--catalog <saved-discovery.json>` to validate without rediscovery. It rejects unknown, duplicate, or missing roles and missing fallback chains. Unverified targets remain unresolved even when a fallback is available. Report unresolved targets, roles without any candidate, and Conductor session readiness. Smoke-test one read-only prompt per distinct agent and model family when doing so will not create unexpected cost or external changes. If Conductor authentication is missing, do not retry session creation. Otherwise show the exact smoke tests and ask before running them.
