---
name: setup-dmnkstack
description: Configure or repair Dmnkstack model routes, compatible agents, and Conductor or Herdr launchers. Use when installing Dmnkstack, changing model assignments, adding an agent runtime, validating model availability, or troubleshooting why a routed model cannot start.
---

# Setup Dmnkstack

Build one model map for every agent. Keep runtime capabilities in a separate launcher file.
Resolve script paths from the directory containing this `SKILL.md`.

## Discover

Run `python3 scripts/discover.py --pretty`. It performs read-only checks for installed agents, Conductor models, Pi's OpenAI Codex models, and the current manager environment.

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
5. Set the fallback explicitly. Never claim a model is available when discovery did not prove it.
6. Write complete files atomically only after the proposed map is clear.

Read [references/default-models.md](references/default-models.md) when creating a map from scratch.

## Validate

Run:

```sh
python3 scripts/validate_config.py "${XDG_CONFIG_HOME:-$HOME/.config}/dmnkstack/models.md" --pretty
```

Report unresolved models and unsupported effort levels. Smoke-test one read-only prompt per distinct agent and model family when doing so will not create unexpected cost or external changes. Otherwise show the exact smoke tests and ask before running them.
