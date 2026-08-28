# Dmnkstack

Dmnkstack is a harness-independent adaptation of [Cursor's Pstack](https://github.com/cursor/plugins/tree/main/pstack). It keeps Pstack's model-first routing approach while adapting the workflow for Codex, Pi, Claude, Cursor, Conductor, and Herdr.

The implementation and personal workflow rules in this plugin are maintained independently for Dominik's dotfiles.

## Skills

Dmnkstack routes everyday work through 23 callable skills for debugging, verification, TDD, code walkthroughs, code archaeology, Figma handoff, Jam triage, observability, architecture, delegation, multi-model review, task recovery, and git delivery.

Use `dmnkstack` as the sticky router, or invoke a workflow directly with `debug`, `how`, `why`, `verify`, `architect`, `arena`, `interrogate`, `swarm`, `figure-it-out`, and the other skills under `skills/`.

Inside Conductor, `delegate` starts the selected agent as a new session in the current workspace. The parent waits for it, collects the final transcript, verifies its evidence, and reports the result back. Outside Conductor, the same workflow runs through Herdr in Kitty.

## Local Conductor setup

Authenticate the Conductor CLI once through the macOS Keychain:

```sh
conductor auth status
conductor auth login
```

`setup-dmnkstack` reports model availability and `session_create_ready` separately. Dmnkstack never writes the Conductor credential to its config or prompts.
