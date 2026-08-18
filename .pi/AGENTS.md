# PI CONFIG

Everything tracked lives in `~/dotfiles/.pi/` and is symlinked into `~/.pi/`. `~/.pi/agent/` is otherwise
runtime state (sessions, caches, auth, installed packages) and is not tracked.

## WHERE TO LOOK

| Task                                       | Location                                                                            |
| ------------------------------------------ | ----------------------------------------------------------------------------------- |
| Change default model / provider / thinking | `agent/settings.json` → `defaultProvider`, `defaultModel`, `defaultThinkingLevel`   |
| Change a subagent role's model             | `agent/settings.json` → `subagents.agentOverrides`                                  |
| Add or remove a pi package                 | `pi install npm:<name>` / `pi remove` — writes `agent/settings.json` → `packages[]` |
| Add an MCP server                          | `agent/mcp.json` (schema is `pi-mcp-adapter`'s `mcpServers`, not pi core)           |
| Global instructions for every session      | `agent/AGENTS.md`                                                                   |
| Write an extension                         | `agent/extensions/<name>.ts`, then symlink into `~/.pi/agent/extensions/`           |
| Configure subagent runtime limits          | `agent/extensions/subagent/config.json`                                             |
| Write an opt-in prompt command             | `agent/prompts/<name>.md`, then symlink into `~/.pi/agent/prompts/`                 |
| Write a skill                              | `~/dotfiles/.agents/skills/<name>/SKILL.md`, then symlink into `~/.agents/skills/`  |
| Keybindings                                | `agent/keybindings.json`                                                            |
| Validate this setup                        | `npm install`, then `npm run verify` from this directory                            |

## CONVENTIONS

- Author in `~/dotfiles`, symlink into place. Never create a real file under `~/.pi/agent/` that you want to keep.
- Extensions are single `.ts` files unless they need their own dependencies (then `<name>/index.ts` + `package.json`).
- Extension API: `@earendil-works/pi-coding-agent` — `pi.on("<event>", handler)`. Events and payloads are documented in
  `~/.npm-global/lib/node_modules/@earendil-works/pi-coding-agent/docs/extensions.md`.
- `/reload` hot-reloads extensions in `~/.pi/agent/extensions/`. No restart needed.

## SKILL DISCOVERY — DO NOT DUPLICATE

Pi discovers skills from **both** `~/.pi/agent/skills/` and `~/.agents/skills/`. A skill in `~/.agents/skills/`
is already visible to pi; symlinking it again into `~/.pi/agent/skills/` registers it twice for no gain.
Canonical location is `~/dotfiles/.agents/skills/<name>/` → `~/.agents/skills/<name>`. Reserve
`~/.pi/agent/skills/` for pi-only skills.

## REMOVED, AND HOW TO GET IT BACK

- Compound Engineering (`ce-*` skills/agents, `lfg`) — removed 2026-08-17, unused. Upstream is
  `github.com/EveryInc/compound-engineering-plugin`; reinstall with
  `pi install git:github.com/EveryInc/compound-engineering-plugin`. Note it is skills-only since June 2026;
  the standalone `ce-*` agents no longer exist upstream.

## ANTI-PATTERNS

- Editing `~/.pi/agent/settings.json` etc. as if they were real files — they are symlinks into `~/dotfiles`; the
  edit lands in the repo, so commit it.
- Leaving `settings.json.*.bak` files behind. Git is the backup.
- Adding a package for something a 30-line extension does.

## COMMANDS

```bash
pi list                # installed packages and their paths
pi update              # update pi and all packages
pi config              # TUI to enable/disable package resources
pi -p "..." --no-session --provider openai-codex --model gpt-5.4-mini --thinking low   # cheap headless check
npm run verify         # JSON policy, typecheck, tests, and formatting
```
