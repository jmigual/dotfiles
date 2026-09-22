"""Validate portable rendering and preservation of local Codex state."""

import json
from pathlib import Path
import shutil
import subprocess
import tomllib
import unittest


REPO = Path(__file__).resolve().parents[2]
SOURCE = REPO / "home"
CODEX = SOURCE / "dot_codex"
CHEZMOI = shutil.which("chezmoi")


def render(path, *, os_name="linux", home_dir="/home/test user", work=False,
           existing=""):
    template = (
        '{{- $_ := set .chezmoi "os" ' + json.dumps(os_name) + ' -}}\n'
        '{{- $_ := set .chezmoi "homeDir" ' + json.dumps(home_dir) + ' -}}\n'
        '{{- $_ := set . "work" ' + json.dumps(work) + ' -}}\n'
        + path.read_text(encoding="utf-8")
    )
    result = subprocess.run(
        [CHEZMOI, "--source", str(REPO), "--no-tty", "execute-template",
         "--with-stdin", template],
        input=existing, text=True, encoding="utf-8", capture_output=True,
        timeout=60,
    )
    if result.returncode:
        raise RuntimeError(result.stderr.strip())
    return result.stdout


@unittest.skipUnless(CHEZMOI, "chezmoi is required")
class CodexConfigTests(unittest.TestCase):
    def test_new_machine_for_each_os(self):
        for os_name, home_dir in (
            ("windows", "C:/Users/Test User"),
            ("linux", "/home/test user"),
            ("darwin", "/Users/test user"),
        ):
            with self.subTest(os=os_name):
                text = render(CODEX / "modify_private_config.toml",
                              os_name=os_name, home_dir=home_dir)
                config = tomllib.loads(text)
                self.assertEqual(config["model"], "gpt-5.6-sol")
                self.assertEqual(config["sandbox_mode"], "workspace-write")
                self.assertEqual(set(config["mcp_servers"]),
                                 {"serena", "context7", "playwright", "codegraph"})
                self.assertEqual(config["mcp_servers"]["context7"]["env_http_headers"],
                                 {"CONTEXT7_API_KEY": "CONTEXT7_API_KEY"})
                self.assertNotIn(home_dir, text)
                self.assertEqual("windows" in config, os_name == "windows")
                expected = "cmd" if os_name == "windows" else "npx"
                self.assertEqual(config["mcp_servers"]["playwright"]["command"], expected)
                hooks = json.loads(render(CODEX / "hooks.json.tmpl",
                                          os_name=os_name, home_dir=home_dir))["hooks"]
                command = hooks["PreToolUse"][0]["hooks"][0]["command"]
                self.assertEqual(command, f'node "{home_dir}/.codex/hooks/rtk.mjs"')
                self.assertIn("SessionEnd", hooks)
                self.assertNotIn("Stop", hooks)

    def test_merge_preserves_local_state_and_is_idempotent(self):
        original = '''model = "local-model"
notify = ["/local/runtime/notify", "turn-ended"]
[projects."/work/repo"]
trust_level = "trusted"
[plugins."local@example"]
enabled = true
[hooks.state.example]
trusted_hash = "local-hash"
[mcp_servers.private]
url = "https://private.example/mcp"
[mcp_servers.serena-2]
command = "uvx"
args = ["--from"]
[mcp_servers.contex7-2]
command = "npx"
args = ["old-package", "--api-key", "fixture-secret"]
[mcp_servers.context7]
command = "old-launcher"
args = ["old-argument"]
'''
        first = render(CODEX / "modify_private_config.toml", existing=original)
        config = tomllib.loads(first)
        before = tomllib.loads(original)
        for key in ("model", "notify", "projects", "plugins", "hooks"):
            self.assertEqual(config[key], before[key])
        self.assertEqual(config["mcp_servers"]["private"], before["mcp_servers"]["private"])
        self.assertNotIn("serena-2", config["mcp_servers"])
        self.assertNotIn("contex7-2", config["mcp_servers"])
        self.assertNotIn("command", config["mcp_servers"]["context7"])
        self.assertNotIn("fixture-secret", first)
        self.assertEqual(first, render(CODEX / "modify_private_config.toml", existing=first))

    def test_agents_and_instructions_are_self_contained(self):
        agents = {}
        for path in sorted((CODEX / "agents").glob("*.toml.tmpl")):
            agent = tomllib.loads(render(path))
            agents[agent["name"]] = agent
            self.assertTrue(agent["description"])
            self.assertTrue(agent["developer_instructions"])
            self.assertNotIn(".claude/agents/", agent["developer_instructions"])
            self.assertNotIn("`Task`", agent["developer_instructions"])
        self.assertEqual(len(agents), 4)
        self.assertEqual(agents["reviewer"]["sandbox_mode"], "read-only")
        self.assertEqual(agents["coder"]["model"], "gpt-5.6-terra")
        self.assertEqual(agents["coder"]["model_reasoning_effort"], "high")
        self.assertEqual(agents["architect"]["model"], "gpt-5.6-sol")
        self.assertEqual(agents["architect"]["model_reasoning_effort"], "high")
        instructions = render(CODEX / "AGENTS.md.tmpl")
        self.assertIn("# Coding style guide", instructions)
        self.assertIn("## CodeGraph", instructions)
        self.assertNotIn("@machine.md", instructions)
        self.assertNotIn("@coding-style.md", instructions)
        self.assertIn('"$ship"', render(CODEX / "skills/ship/SKILL.md.tmpl"))

    def test_work_sections_only_render_on_work_machines(self):
        for work, expected in ((False, self.assertNotIn), (True, self.assertIn)):
            with self.subTest(work=work):
                instructions = render(CODEX / "AGENTS.md.tmpl", work=work)
                expected("SaveChangesAsync", instructions)
                self.assertIn("## Scope Discipline", instructions)
                self.assertIn("## Merge / Pull Requests", instructions)
                self.assertIn("## Worktrees", instructions)

    @unittest.skipUnless(shutil.which("node") and shutil.which("rtk"), "node and RTK required")
    def test_rtk_rewrites_and_leaves_already_wrapped_commands_alone(self):
        for command in ("git status", "rtk git status"):
            result = subprocess.run(
                [shutil.which("node"), str(CODEX / "hooks/rtk.mjs")],
                input=json.dumps({"hook_event_name": "PreToolUse", "tool_name": "Bash",
                                  "tool_input": {"command": command}}),
                text=True, encoding="utf-8", capture_output=True, check=True, timeout=15,
            )
            if command == "git status":
                hook = json.loads(result.stdout)["hookSpecificOutput"]
                self.assertEqual(hook["permissionDecision"], "allow")
                self.assertEqual(hook["updatedInput"]["command"], "rtk git status")
            else:
                self.assertFalse(result.stdout.strip())


if __name__ == "__main__":
    unittest.main()
