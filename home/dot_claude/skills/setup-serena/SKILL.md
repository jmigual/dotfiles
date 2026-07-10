---
name: setup-serena
description: Configure Serena's recommended hooks in Claude Code's settings.json — activate the project and read Serena's instructions on session start, nudge toward Serena's symbolic tools when grep/read is overused, auto-approve Serena tools in permissive modes, and clean up session data on exit. Use when setting up a new machine, after installing Serena, or whenever the four Serena hooks are missing from ~/.claude/settings.json.
---

# Setup Serena hooks for Claude Code

Serena recommends four hooks so Claude Code gets the best experience with it
(reference: https://oraios.github.io/serena/02-usage/030_clients.html#claude-code).
This skill merges them **idempotently** into `~/.claude/settings.json`, preserving any
hooks already there (e.g. codegraph, rtk).

## The four hooks

| Event | Matcher | Command | Purpose |
|-------|---------|---------|---------|
| `PreToolUse` | `""` (all tools) | `serena-hooks remind --client=claude-code` | Nudges toward Serena's symbolic tools after ~3 consecutive `grep`/`read` calls |
| `PreToolUse` | `mcp__serena__*` | `serena-hooks auto-approve --client=claude-code` | Auto-approves Serena tool calls when in `acceptEdits`/`auto` mode |
| `SessionStart` | `""` | `serena-hooks activate --client=claude-code` | Prompts activating the project + reading Serena's instructions |
| `SessionEnd` | `""` | `serena-hooks cleanup --client=claude-code` | Clears per-session hook data on exit |

## Procedure

### 1. Verify `serena-hooks` is installed and on PATH

```bash
command -v serena-hooks || echo "MISSING"
```

If missing, Serena isn't installed. Install it (it ships the `serena-hooks`
entrypoint alongside `serena`), then re-check:

```bash
uv tool install --python 3.11 git+https://github.com/oraios/serena
```

Also make sure the Serena MCP server itself is registered (separate from hooks):

```bash
claude mcp list | grep -q serena || \
  claude mcp add --scope user serena -- serena start-mcp-server --context=claude-code --project-from-cwd
```

Do NOT proceed to wire the hooks until `serena-hooks` resolves — a hook pointing at a
missing binary fails on every tool call.

### 2. Merge the hooks idempotently

Run this script. It creates `~/.claude/settings.json` if absent, preserves everything
already there, and skips any hook whose command is already present (safe to re-run):

```bash
python3 - <<'PY'
import json, os

settings = os.path.expanduser("~/.claude/settings.json")

WANTED = {
    "PreToolUse": [
        ("",                "serena-hooks remind --client=claude-code"),
        ("mcp__serena__*",  "serena-hooks auto-approve --client=claude-code"),
    ],
    "SessionStart": [
        ("", "serena-hooks activate --client=claude-code"),
    ],
    "SessionEnd": [
        ("", "serena-hooks cleanup --client=claude-code"),
    ],
}

if os.path.exists(settings):
    with open(settings) as f:
        data = json.load(f)
else:
    os.makedirs(os.path.dirname(settings), exist_ok=True)
    data = {}

hooks = data.setdefault("hooks", {})

def has_command(entries, cmd):
    return any(h.get("command") == cmd
              for e in entries for h in e.get("hooks", []))

added = []
for event, specs in WANTED.items():
    entries = hooks.setdefault(event, [])
    for matcher, cmd in specs:
        if has_command(entries, cmd):
            continue
        entries.append({
            "matcher": matcher,
            "hooks": [{"type": "command", "command": cmd}],
        })
        added.append(f"{event} [{matcher or 'all'}]: {cmd}")

with open(settings, "w") as f:
    json.dump(data, f, indent=2)
    f.write("\n")

if added:
    print("Added:")
    for a in added:
        print("  +", a)
else:
    print("No changes — all four Serena hooks already present.")
PY
```

### 3. Validate and confirm

```bash
python3 -c "import json,os;d=json.load(open(os.path.expanduser('~/.claude/settings.json')));\
print('JSON valid');\
[print(f'{ev}: {h[\"command\"]}') for ev in ('PreToolUse','SessionStart','SessionEnd') for e in d['hooks'].get(ev,[]) for h in e['hooks']]"
```

Optionally smoke-test the entrypoint (should print a SessionStart context JSON):

```bash
echo '{"session_id":"smoketest"}' | serena-hooks activate --client=claude-code
rm -rf ~/.serena/hook_data/smoketest
```

### 4. Activate them

The settings watcher only picks up new hook events for directories that already had a
settings file at session start. Tell the user to **open `/hooks` once** (which reloads
config) or restart Claude Code — then the hooks go live. `/hooks` is also where they can
review or disable any of them later.

## Notes

- Scope: these go in the **global** `~/.claude/settings.json` because Serena's MCP server
  is registered at user scope. For per-project scoping, target `.claude/settings.json` in
  the repo instead.
- The Codex equivalent is managed separately by chezmoi at `~/.codex/hooks.json`.
