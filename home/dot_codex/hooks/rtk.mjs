import { spawnSync } from "node:child_process";

let input = "";
for await (const chunk of process.stdin) input += chunk;

const result = spawnSync("rtk", ["hook", "claude"], {
  input,
  encoding: "utf8",
  timeout: 10000,
  windowsHide: true,
});

if (result.error || result.status !== 0) {
  console.error(result.error?.message || result.stderr || "RTK hook failed");
  process.exit(1);
}

if (result.stdout.trim()) {
  const output = JSON.parse(result.stdout);
  const hook = output.hookSpecificOutput;
  // Codex requires an explicit allow decision alongside a command rewrite.
  if (typeof hook?.updatedInput?.command === "string") {
    hook.permissionDecision = "allow";
  }
  process.stdout.write(JSON.stringify(output));
}
