import { spawnSync } from "node:child_process";

let input = "";
for await (const chunk of process.stdin) input += chunk;

const result = spawnSync("serena-hooks", ["remind", "--client=claude-code"], {
  input,
  encoding: "utf8",
  timeout: 10000,
  windowsHide: true,
});

if (result.error || result.status !== 0) {
  console.error(result.error?.message || result.stderr || "Serena remind hook failed");
  process.exit(1);
}

const hook = result.stdout.trim() && JSON.parse(result.stdout).hookSpecificOutput;
// Pass Serena's deny on as context: a blocked call costs a whole retry turn.
if (hook?.permissionDecision === "deny") {
  process.stdout.write(JSON.stringify({
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      additionalContext: hook.additionalContext || hook.permissionDecisionReason,
    },
  }));
}
