---
name: pr-review
description: Review a pull request against its research plan for concrete bugs, unjustified complexity, dead code, and comment bloat, then save the evidence-backed review beside the plan. Read-only on GitHub.
---

# Plan-grounded PR Review

Review the requested PR through bugs, overengineering, dead code, and comment quality. The plan explains intent; it is not a checklist.

## Resolve and load

- Resolve a URL or number. For a bare number, resolve the repository from the current working directory.
- Resolve the plan from an explicit path/slug or a clear title/branch match under `~/dev/research`. If there is no single credible match, ask rather than inventing intent.
- Read the plan's goal, scope/non-goals, decisions, and contracts. Skip chronological status noise.
- Load PR metadata, full diff, checks, and head SHA. State red CI up front and do not duplicate findings already caught by CI.
- For diffs above roughly 1,500 lines, prioritize source over generated output and logic over configuration, then disclose what was skipped.

## Review actual code

Open every non-trivial changed file plus relevant callers, neighbors, contracts, and tests. A finding not grounded in code actually inspected is a guess and should be dropped.

### Bugs

Require a concrete failing input or sequence. Check boundaries, error paths, async behavior, state/lifecycle cleanup, data coercion and time handling, pagination/unbounded work, contract drift, trust boundaries, authorization, and plausible test gaps.

### Overengineering and dead code

Flag complexity only when a smaller concrete implementation serves the same requirement: one-caller abstractions, unused configurability, redundant indirection, unnecessary dependencies, impossible defensive states, or genuine scope creep.

Check both added dead code and old code orphaned by the new path. Search the repository before reporting zero references and rule out exports, dynamic imports, registries, dependency injection, configuration, templates, generated code, tests, and cross-workspace consumers. Mark uncertainty rather than asserting what cannot be proven.

### Comments

Group comment bloat by file: narration, restated code, obvious private-helper JSDoc, decorative banners, commented-out code, ownerless TODOs, and comments likely to rot. Keep rationale, tradeoffs, gotchas, tickets, and upstream workarounds.

## Verify and report

Delete lint/type/format findings, style preferences, unsupported speculation, and vague “might” claims. Prefer a few real findings.

Use severity: must fix, should fix, consider. Lead with findings ordered by severity and file/line; state the concrete failure and smallest fix. Give one line for an empty review lens and a concise verdict.

Save the same review to `<plan-folder>/pr-<number>-review.md` with PR URL, head SHA, and date. If it exists, inspect it and ask before overwriting. Return the absolute path and disclose skipped material or genuine uncertainty. Do not post to GitHub.
