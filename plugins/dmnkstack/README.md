# Dmnkstack

Dmnkstack is a harness-independent adaptation of [Cursor's Pstack](https://github.com/cursor/plugins/tree/main/pstack). It keeps Pstack's model-first routing approach while adapting the workflow for Codex, Pi, Claude, Cursor, Conductor, and Herdr.

The implementation and personal workflow rules in this plugin are maintained independently for Dominik's dotfiles.

## Skills

Dmnkstack routes everyday work through 24 callable skills for debugging, verification, TDD, code walkthroughs, code archaeology, Figma handoff, Jam triage, observability, architecture, delegation, multi-model review, task recovery, and git delivery.

Use `dmnkstack` as the sticky router, or invoke a workflow directly with `debug`, `how`, `why`, `verify`, `architect`, `arena`, `interrogate`, `swarm`, `figure-it-out`, and the other skills under `skills/`.

`deliver` uses the bundled [before-and-after](skills/before-and-after/SKILL.md) skill for visual PR evidence, including video when screenshots cannot demonstrate the behavior. The skill and formatter come from [vercel-labs/before-and-after](https://github.com/vercel-labs/before-and-after/tree/8306d34f459b6704e08e6adb5829fcddb0dc3557), revision `8306d34f459b6704e08e6adb5829fcddb0dc3557`, under its included [PolyForm Shield license](skills/before-and-after/LICENSE). Capture requires `agent-browser`; uploads require a `gh` version supporting `--attach`. Run the bundled formatter check with `node --test plugins/dmnkstack/skills/before-and-after/scripts/format.test.mjs`.

Inside Conductor, `delegate` starts the selected agent as a new session in the current workspace. The parent collects the authoritative result artifact and transcript, verifies the evidence, and reports the result back. User-requested callbacks follow the shared [delivery contract](skills/dmnkstack/references/delivery.md). Outside Conductor, the same workflow uses the current host's Herdr session, including inside VMs. Closely related work gets a sibling pane; independent tasks get a new tab. Children stay on the same host and preserve user focus. Concurrent writers still need separate worktrees.

## Routing and checks

Keep `models.md`, `launchers.toml`, and `working-style.md` under `${XDG_CONFIG_HOME:-$HOME/.config}/dmnkstack`, or symlink that directory to the dotfiles copy. Verify that the link resolves before running setup.

TypeSafe routing is optional. `route.py` checks for `TYPESAFE_API_KEY` in the environment, `dmnkstack/typesafe.env` under the config directory, and login shells. Without a key it returns `status: local`; the agent selects the route, skill, and configured model using the same routing rules. No key setup is required. Configured-key API failures remain explicit errors rather than silently falling back.

Routing distinguishes mechanical, bounded, uncertain, and consequential work. Model assignments specify starting effort; failed reasoning can escalate it. Model lists are candidate pools, not automatic panels. Every role has an ordered fallback chain that stops when exhausted. Task outcomes go to the private XDG state reflection log, not this repository.

The validator requires Python 3.11+ for the standard-library TOML parser. Use an installed interpreter of that version or newer, for example:

```sh
python3.12 plugins/dmnkstack/skills/setup-dmnkstack/scripts/test_validate_config.py
python3.12 plugins/dmnkstack/skills/setup-dmnkstack/scripts/validate_config.py ~/.config/dmnkstack/models.md --pretty
```

Exit codes are `0` for compatible catalog targets, `1` for unresolved targets, and `2` for configuration errors. Catalog validation does not prove authentication, model execution, model-specific reasoning support, or sufficient independent models for a panel. Check those before launch.

## Local Conductor setup

Authenticate the Conductor CLI once through the macOS Keychain:

```sh
conductor auth status
conductor auth login
```

`setup-dmnkstack` reports model availability and `session_create_ready` separately. Dmnkstack never writes the Conductor credential to its config or prompts.
