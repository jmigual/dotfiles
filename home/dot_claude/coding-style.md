# Coding style guide

My default expectations for any agent working in my repositories, across languages. A repo's
own `CLAUDE.md` overrides anything here; when it's silent, follow this.

These rules bias toward caution over speed. Use judgment on trivial tasks.

## 1. Think before coding
- State assumptions explicitly. If uncertain, ask instead of guessing.
- If multiple interpretations exist, surface them — don't silently pick one.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop and name what's confusing before proceeding.
- Do a comprehensive read of the problem and the code it touches before writing anything.

## 2. Simplicity first
Write the minimum code that solves the problem. Nothing speculative.
- No features beyond what was asked.
- No abstractions for single-use code; no interface with one implementation.
- No configurability or "flexibility" that wasn't requested.
- No error handling for impossible scenarios.
- If 200 lines could be 50, rewrite it.
- Reach for the standard library before a dependency, a native platform feature before a
  library, one line before fifty.
Test: would a senior engineer call this overcomplicated? If yes, simplify.

## 3. Surgical changes
Every changed line must trace directly to the request.
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- Remove imports/variables/functions that *your* changes made unused.
- Don't delete pre-existing dead code — mention it instead.
- Fix bugs at the root cause in the owning layer, not with a patch in every caller. Grep the
  callers before changing a shared function.

## 4. Goal-driven execution
Turn tasks into verifiable goals, then loop until they pass.
- "Add validation" → write tests for invalid inputs, then make them pass.
- "Fix the bug" → write a test that reproduces it, then make it pass.
- "Refactor X" → confirm tests pass before and after.
- For multi-step work, state a brief plan with a verification check per step.
- A task is not done until its checks pass and the code builds clean with no new warnings.

## 5. No incomplete code
- Never commit `TODO`, `FIXME`, `todo!()`, or placeholder stubs. If you hit one, stop, rethink
  the design, and ship the complete solution.
- Don't leave dead code behind a deprecation dance unless asked — remove what's no longer used
  (subject to rule 3: pre-existing dead code you didn't create gets flagged, not deleted).

## 6. Errors and edge cases
- Return typed, meaningful errors; don't swallow them. Propagate with context.
- Reserve `unwrap`/`expect`/`panic`/unchecked casts for genuine internal invariants, never for
  expected bad input. Validate at trust boundaries.
- Never simplify away input validation, error handling that prevents data loss, security
  measures, or accessibility basics.

## 7. Structure and naming
- Split entry point from library logic (`main` stays slim; logic lives in a testable library).
- Keep functions small and focused; extract complex logic into well-named helpers.
- Follow each language's idiomatic naming and formatting; run its formatter and linter.
- Order imports: standard library, then external deps, then local modules.
- Don't let a single file grow unbounded — split into focused modules as an area gets large.

## 8. Tests and docs
- Unit tests live beside the code; integration tests in the language's conventional test dir.
- A test that passes regardless of the change is worthless — a new test should fail against the
  pre-change code.
- Assert on error *type*/variant, not on a specific message string.
- Document public APIs; keep comments about *why* and non-obvious invariants, not restating the
  code.

## 9. Dependencies
- Minimize them; each adds compile time, binary size, and attack surface.
- Prefer a few lines over a new dependency for what's trivial.
- In a workspace, pin shared dependencies centrally rather than per-package.
- Audit a new dependency (maintenance, security, license) before adding it.
