# Codex

Codex's configuration is managed under [home/dot_codex](../home/dot_codex).
It is portable across Windows, Linux, and macOS.

## Setup

Install Codex, Node.js/npm, Serena (`serena-agent` via uv), RTK, and CodeGraph on
PATH before applying the configuration. Playwright's MCP is launched by npx.

Apply only the Codex configuration with:

```sh
chezmoi apply --exclude=scripts ~/.codex
```

Set `CONTEXT7_API_KEY` in the local environment inherited by Codex. On Windows it
can be a user environment variable; on Linux/macOS export it through your local
secret setup. No key is stored in this repository. Sign in to Codex separately on
each machine, restart it after applying, and review new or changed hooks in `/hooks`.

## Included Configuration

- Global instructions and coding style, rendered into `~/.codex/AGENTS.md` from the
  existing Claude source files. Context7 guidance and no-attribution preferences
  are included. Legacy project `CLAUDE.md` files remain a fallback for `AGENTS.md`.
- Four native Codex agents, rendered from the Claude agents. Opus roles use
  `gpt-6-astra` with xhigh effort; Sonnet roles use `gpt-5.6-terra` with high effort;
  inherit roles keep the parent model. The reviewer requests a read-only sandbox.
  Claude tool allowlists become role instructions, not equivalent Codex tool ACLs.
- The `ship` skill (invoke as `$ship`) and a Codex-specific `setup-serena` skill.
- Serena, Context7, Playwright, and CodeGraph MCP servers. Windows npm commands use
  `cmd`; other systems launch them directly. No executable path is hard-coded.
- Serena lifecycle hooks, CodeGraph's prompt hook, and an RTK adapter that supplies
  the explicit permission decision Codex requires for command rewriting.

## Shared Settings And Local State

[modify_private_config.toml](../home/dot_codex/modify_private_config.toml) merges
shared preferences and the four managed MCP definitions into the current local
config. It preserves the selected main model, other MCP servers, app plugin
registrations, runtime paths, notifications, project trust, and hook trust state
without copying them into Git. A new machine defaults to `gpt-6-astra`.

Shared reasoning, approval, and sandbox settings are managed by
[config.toml.tmpl](../home/.chezmoitemplates/codex/config.toml.tmpl).
Applying twice is idempotent.

Credentials, session history, memories, permission rules, sandbox state, and
`~/.codex/machine.md` remain local. Do not import the entire live `.codex` directory
with `chezmoi add`; edit the managed source templates instead. Machine-specific
Claude notes may be copied locally to `~/.codex/machine.md` when applicable.

## Claude Compatibility

Claude-only plugin registrations (Ponytail, Understand-Anything, frontend-design),
its status-line executable, remote-control/session settings, automatic-update
channel, and its Opus model/context-window setting have no direct config mapping.
They are not installed as Codex plugins. Existing Codex plugins remain intact.

Claude's auto mode maps to Codex's `on-request` plus `auto_review`, with a
`workspace-write` sandbox; the two products' permission policies are not identical.

## Windows Sandbox Troubleshooting

Open Codex in a specific repository. A broad home workspace can produce enough
sandbox capability entries to fail token creation with
`SetTokenInformation(TokenDefaultDacl)` error 1344. Changing the working directory
is preferable to disabling the sandbox or resetting Windows ACLs.
See [the upstream report](https://github.com/openai/codex/issues/36328).

## References

- [Codex configuration](https://learn.chatgpt.com/docs/config-file/config-reference)
- [Custom agents](https://learn.chatgpt.com/docs/agent-configuration/subagents)
- [Hooks](https://learn.chatgpt.com/docs/hooks)
- [chezmoi modify templates](https://www.chezmoi.io/user-guide/manage-different-types-of-file/)
