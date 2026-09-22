"""Validate the Claude agent definitions chezmoi renders from templates."""

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
                self.assertIn(base_meta["description"], deep_meta["description"])
                self.assertEqual(deep_body, base_body)


if __name__ == "__main__":
    unittest.main()
