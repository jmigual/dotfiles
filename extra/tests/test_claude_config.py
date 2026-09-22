"""Validate the Claude agent definitions chezmoi renders from templates."""

import json
from pathlib import Path
import unittest

from test_codex_config import CHEZMOI, SOURCE, render


CLAUDE = SOURCE / "dot_claude"


def split_frontmatter(text):
    """Return (frontmatter dict, body) of a Markdown agent definition."""
    _, meta, body = text.split("---\n", 2)
    fields = dict(line.split(": ", 1) for line in meta.splitlines())
    return fields, body.strip()


@unittest.skipUnless(CHEZMOI, "chezmoi is required")
class ClaudeAgentTests(unittest.TestCase):
    def test_deep_agents_escalate_their_base_agent(self):
        for base in ("coder", "reviewer"):
            with self.subTest(agent=base):
                base_meta, base_body = split_frontmatter(
                    (CLAUDE / "agents" / f"{base}.md").read_text(encoding="utf-8"))
                deep_meta, deep_body = split_frontmatter(
                    render(CLAUDE / "agents" / f"{base}-deep.md.tmpl"))
                self.assertEqual(deep_meta["name"], f"{base}-deep")
                self.assertEqual(deep_meta["model"], "opus")
                self.assertEqual(deep_meta["effort"], "xhigh")
                self.assertEqual(deep_meta["tools"], base_meta["tools"])
                self.assertEqual(deep_meta.get("isolation"), base_meta.get("isolation"))
                self.assertIn(base_meta["description"], deep_meta["description"])
                self.assertEqual(deep_body, base_body)

    def test_settings_merge_keeps_local_state_and_is_idempotent(self):
        original = json.dumps({
            "permissions": {"allow": ["Bash(ls *)"], "defaultMode": "default"},
            "statusLine": {"type": "command", "command": "local-statusline"},
            "worktree": {"baseRef": "fresh"},
            "hooks": {
                "PreToolUse": [
                    {"matcher": "", "hooks": [{"type": "command", "command": "local-hook"}]},
                    {"matcher": "", "hooks": [{"type": "command",
                                               "command": "serena-hooks remind --client=claude-code"}]},
                ],
                "Stop": [{"hooks": [{"type": "command", "command": "local-stop"}]}],
            },
        })
        first = render(CLAUDE / "modify_settings.json", existing=original)
        settings = json.loads(first)
        self.assertEqual(settings["worktree"], {"baseRef": "head"})
        self.assertEqual(settings["permissions"], {"allow": ["Bash(ls *)"], "defaultMode": "auto"})
        self.assertEqual(settings["statusLine"]["command"], "local-statusline")
        pre = [h["command"] for e in settings["hooks"]["PreToolUse"] for h in e["hooks"]]
        self.assertEqual(pre.count("serena-hooks remind --client=claude-code"), 1)
        self.assertIn("local-hook", pre)
        self.assertIn("rtk hook claude", pre)
        self.assertEqual(settings["hooks"]["Stop"][0]["hooks"][0]["command"], "local-stop")
        self.assertIn("SessionStart", settings["hooks"])
        self.assertEqual(first, render(CLAUDE / "modify_settings.json", existing=first))
        fresh = json.loads(render(CLAUDE / "modify_settings.json"))
        self.assertEqual(fresh["worktree"], {"baseRef": "head"})
        self.assertIn("UserPromptSubmit", fresh["hooks"])


if __name__ == "__main__":
    unittest.main()
