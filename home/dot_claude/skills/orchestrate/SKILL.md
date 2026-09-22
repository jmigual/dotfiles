---
name: orchestrate
description: Run a task as an orchestrator that plans, delegates, and verifies through subagents instead of doing the work itself. Use when the user says "/orchestrate", "orchestrate this", "use agents for this", or when a task spans several files, steps, or concerns and would bloat the main context.
argument-hint: [task]
model: opus
effort: high
---

Orchestrate: $ARGUMENTS

You plan, delegate, verify, merge, and report. Agents do the work; they start with no context, so
each prompt is self-contained. Parallel is the default: before every message, list what could
start now and launch all of it; a single agent running alone is the exception, and it needs a
dependency to justify it. Serializing independent work is a bug.

## Do yourself
- Read `CLAUDE.md`, a plan, a diff, or one file under ~200 lines to make a routing decision.
- `git status`, `git log`, `git diff --stat`, `git merge`, `git worktree remove`, one test.
- Keep the todo list; write the final report.
Everything else — searching, reading to understand, editing, suites, reviewing — is an agent's.

## Agents
| Agent | Tier | Use |
|---|---|---|
| `architect` | Opus/high | Non-trivial scope, boundary crossing, or two viable approaches |
| `coder` | Sonnet/high | Default implementation from a concrete spec |
| `coder-deep` | Opus/xhigh | Complex, ambiguous, algorithmic, cross-cutting, high-risk; or `coder` failed review twice |
| `reviewer` | Opus/high | Every change before it counts as done |
| `reviewer-deep` | Opus/xhigh | Invariants, security, concurrency, data-loss paths |
| `tester` | Sonnet/high | Run suites; write tests the reviewer found missing |
| `Explore` + `model: haiku` | Haiku | Mechanical lookups |

Pick the cheapest tier likely to finish reliably. xhigh is an escalation, never the default.

## Loop
1. **Triage.** One-line restatement. Obvious one-file change → straight to `coder`. Unrelated
   lookups → one batch of `Explore` agents.
2. **Plan.** `architect` gets the verbatim request and constraints; it returns steps marked
   independent/dependent with the files each touches. Ask the user only at a real fork.
3. **Implement.** One `coder` per step, every one with `isolation: "worktree"` on the Agent
   call — a coder without it builds against a tree another agent is editing. Launch every
   ready step at once; a step that depends only on another's *interface* starts now against
   the plan's contract and integrates later. When a step finishes, launch what it unblocked
   without waiting for the rest of the wave.
   Every prompt: the user's request verbatim; files to touch and not touch; the acceptance
   check; what to report (files, checks run, deviations, worktree path and branch).
4. **Verify.** The moment a step's branch exists, `reviewer` and `tester` on it in the same
   message, while other steps keep running. Findings and failures go back verbatim to the
   same coder via `SendMessage` (it keeps its worktree and branch). Two failed rounds →
   `coder-deep`, told to start with `git reset --hard worktree-<name>` in its own worktree;
   three → stop and report. `blocks on design` → `architect`.
5. **Merge.** Worktree branches into the current branch, dependency order, then `tester` on
   the combined tree.
6. **Report.** Files changed, what verified it (agent + command), anything left out and why.
   Push only when asked.

## Worktrees
- Branch `worktree-<name>` under `.claude/worktrees/<name>`, from HEAD. Fresh checkout: no
  build artifacts or gitignored files (`.worktreeinclude` copies `.env`-style files).
- The coder commits there per `CLAUDE.md` (one logical unit each, signed; if pinentry blocks,
  retry once and report). Review the branch: `git log <base>..worktree-<name>`.
- Merge: `git merge worktree-<name>` from the main checkout. Conflict → `git merge --abort`,
  `SendMessage` the coder the conflicting files, have it rebase onto the current branch and
  re-run checks, merge again.
- After merging: `git worktree remove <wt>`, `git branch -d worktree-<name>`.

## Rules
- No agent's "done" counts until a different agent verified it.
- One agent per logical unit; parallelism comes from independent units, not thinner slices.
- When in doubt whether two steps are independent, run them in parallel and let the merge
  decide — a conflict costs one rebase, serialization costs the whole step's duration.
- Pass the user's constraints through; extra work an agent did is a finding, not a keep.
- An agent's question is answered from what you have or passed to the user, never guessed.
