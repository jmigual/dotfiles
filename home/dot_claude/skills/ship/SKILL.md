---
name: ship
description: Review, verify, commit, and open a draft MR/PR for the current worktree branch. Use when the user says "ship it", "/ship", or asks to finish and open an MR/PR for the current branch.
---

Works on Windows and Linux, and on GitLab or GitHub. Detect, don't assume.

1. Resolve the base branch: `git symbolic-ref --short refs/remotes/origin/HEAD` (fall back to `main`, then `master`). Read `git log <base>..HEAD` — every commit message and diff — before writing anything.
2. Run the project's own checks, whatever they are: Rust → `cargo test`, `cargo clippy --all-targets`, `cargo fmt --check`; .NET → `dotnet build`, `dotnet test`; otherwise whatever the repo's README/CI config defines. Report failures; prove any failure is pre-existing on the base branch before dismissing it.
3. Run an adversarial self-review of the diff. Only fix issues in scope; escalate anything larger to me.
4. Commit (signed). If the pinentry prompt blocks or times out — a GUI popup on Windows, a tty prompt on Linux (`export GPG_TTY=$(tty)`) — say so immediately and retry once. Never skip the commit silently.
5. Push, then open a draft: GitLab remote → `glab mr create --draft`; GitHub remote → `gh pr create --draft`. Do not set a reviewer unless I named one; if it needs one, ask me who.
6. Description: <=15 lines, sections "What changed", "Why", "Alternatives considered". No filler prose. Do not post extra comments on the MR/PR.
