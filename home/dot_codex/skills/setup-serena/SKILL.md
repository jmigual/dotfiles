---
name: setup-serena
description: Configure or repair Serena's MCP server and lifecycle hooks for Codex after installation or when setting up a machine. Use for Codex's Serena integration, not Claude Code's settings.
---

# Setup Serena for Codex

Check that `serena` and `serena-hooks` resolve on PATH with `Get-Command` in
PowerShell or `command -v` in POSIX shells. If missing, install the official
`serena-agent` package with `uv tool install -p 3.13 serena-agent`.

The chezmoi source manages `~/.codex/config.toml` and `~/.codex/hooks.json`. Find it
with `chezmoi source-path`, inspect its existing templates, and fix those before
applying only the affected Codex targets. Preserve other MCP servers and hooks.
Do not put machine paths, credentials, or hook trust hashes in the source.

The Serena server uses `serena start-mcp-server --context=codex --project-from-cwd
--open-web-dashboard=false`. Allow 60 seconds for startup.

Required hooks:

| Event | Matcher | Command |
| --- | --- | --- |
| PreToolUse | all tools | `serena-hooks remind --client=codex` |
| SessionStart | startup or resume | `serena-hooks activate --client=codex` |
| SessionEnd | all | `serena-hooks cleanup --client=codex` |

Do not translate Claude's automatic approval hook: Codex uses its own approval
reviewer and permission settings. Session cleanup belongs to SessionEnd, not Stop
(which runs when each turn finishes).

Validate the rendered TOML and JSON, run `codex mcp list`, and smoke-test each hook
with synthetic JSON on stdin. Restart Codex to load the server. Review new or changed
hooks through `/hooks`; trust is local to each machine.

Once Serena is available, activate the current project and read its instructions
manual before using the symbolic tools.
