---
description: Review a PR against its /research plan — real bugs, overengineering, and comment bloat. Saves the review to the research folder.
argument-hint: <PR url or number> [path or slug of the plan in ~/dev/research]
allowed-tools: Bash(gh pr view:*), Bash(gh pr diff:*), Bash(gh pr checks:*), Bash(gh api:*), Bash(git rev-parse:*), Bash(git log:*), Bash(git diff:*), Bash(git show:*), Bash(ls:*), Bash(mkdir:*), Bash(date:*), Read, Glob, Grep, Write
---

Review this PR through three lenses: **real bugs**, **overengineering**, **comment bloat**. Args: $ARGUMENTS

The plan is **context for intent** — it tells you what the change was *supposed* to do so you can judge the code against it. It is **not** a checklist to tick off; do not report "plan item X wasn't implemented" unless the omission is itself a bug.

## 0. Resolve the inputs — ask, don't guess
- **PR:** a URL, or a number (then resolve the repo from the cwd via `gh repo view`). If neither works, stop and ask.
- **Plan:** if given as a path, read it. If given as a slug, look for `~/dev/research/<slug>/plan.md`, then `implementation-plan.md`, then any `*.md` in that folder.
- If no plan arg: `ls ~/dev/research/` and try to match the PR title/branch to a folder. If there's no clear single match, **ask me which plan** — don't review blind and don't invent intent from the diff alone.
- If the plan is long, focus on: TL;DR, scope / non-goals, key decisions, and any contract or schema definitions. Skip status tables and PR logs.

## 1. Load the PR properly
- `gh pr view <ref> --json title,body,url,headRefName,baseRefName,additions,deletions,changedFiles,files`
- `gh pr diff <ref>` for the full diff.
- `gh pr checks <ref>` — if CI is red, say so up front and **don't spend findings on what CI already caught**.
- If the diff is very large (>1500 lines), tell me, then prioritise: source over generated, logic over config, new files over edits. Say explicitly what you skipped.

## 2. Read the code, not just the diff — this is the part that finds real bugs
For every non-trivial changed file, open the **actual file** (and its neighbours) so you can see:
- Callers of changed functions — did a signature/behaviour change break one?
- The existing patterns in that file/module — is the new code inconsistent with how this codebase already solves it?
- Tests that cover the touched paths — what's now untested?

A finding you can't ground in a file you actually read is a guess. Drop it.

## 3. Lens A — Bugs 🐛
Hunt for things that will actually go wrong at runtime:
- Edge cases: null/undefined/empty, zero, off-by-one, empty arrays, first/last item.
- Error paths: unhandled rejections, swallowed errors, `catch` blocks that hide failures, missing retries/timeouts on I/O.
- Async: races, missing `await`, stale closures, unmemoised deps, concurrent writes to shared state.
- State & lifecycle: effects that re-fire, cleanup that never runs, subscriptions that leak.
- Data: type coercions, timezone/date handling, pagination limits, N+1 queries, unbounded loops.
- Contract drift: the code disagrees with the schema/API/plan's stated contract.
- Security-adjacent: unvalidated input crossing a trust boundary, authz check missing on a new path, secrets or PII in logs.
- Test gaps: only where a real, plausible failure is now uncovered — not "add tests" as a reflex.

**Discipline:** for each bug, state a concrete failure — the input or sequence, and what breaks. If you can't, it's not a finding.

## 4. Lens B — Overengineering 🏗️
Flag complexity that isn't paying for itself:
- Abstractions with **one** caller — interfaces, factories, wrapper layers, generic type params, strategy/registry patterns.
- Configurability nobody asked for: options, flags, env vars, injection points not in the plan.
- Defensive code for states that can't occur given the callers you just read.
- Re-implementing something the repo (or a dep already in `package.json`) provides.
- New dependencies for a small amount of code.
- Indirection that costs a reader more hops than the logic is worth.
- Scope creep: real, non-incidental work that the plan didn't ask for.

### Dead code — check for it explicitly, in both directions
1. **Added dead:** something this PR introduces that nothing calls — a helper, export, prop, param, branch, or type with zero references. Cheap to spot: it's in the diff.
2. **Orphaned by this PR** (the valuable one): the PR added a new path but left the old one in place. Functions, components, constants, flags, config keys, or tests whose last caller this diff just removed or rerouted. Also: unreachable branches after an early return/throw, and `if` arms made impossible by a changed condition.

Before reporting either, **grep the repo for the symbol** and confirm zero real references. Then rule out the false positives — do not report it if it's:
- exported from a package entry point / barrel / public API
- reached via dynamic `import()`, a string-keyed registry, DI container, or reflection
- referenced in config, templates, generated code, or by another workspace in the monorepo
- used only by tests (that's a different finding: "tests cover code nothing else calls")

If you can't complete the reference check (symbol too generic to grep, cross-repo consumers), say so and mark it ⚪ with the uncertainty stated — don't assert it.

For each: name the **smaller thing** that would do the same job. "This is complex" without a concrete simplification isn't a finding.

Do **not** flag: existing repo conventions, structure the plan explicitly decided on, or genuine complexity the domain requires. Say so if the plan already justified it.

## 5. Lens C — Comment bloat 💬
I want comments — I want *few, load-bearing* ones. Flag:
- Comments that restate the code (`// increment the counter`).
- JSDoc/docblocks on obvious private helpers, or that just re-type the signature.
- Narration: `// First we X, then we Y` walking through code that already reads that way.
- Section banners and decorative dividers inside a function.
- Commented-out code, and TODOs with no owner or ticket.
- Comments that will silently rot (restating a value, a list, or behaviour defined elsewhere).

**Keep** (don't flag): why-not-the-obvious-thing, tradeoffs, gotchas, non-obvious constraints, links to tickets/issues/RFCs, workarounds for upstream bugs.

Group these — one row per file with a count and the worst example beats twenty separate rows.

## 6. Verify before reporting
Re-read your own findings and delete:
- Anything a linter, formatter, or typechecker already catches.
- Style preferences dressed up as bugs.
- Anything you'd have to hedge with "might" and can't check — or check it now and be sure.

Better to hand me 4 real findings than 20 with 6 real ones.

## 7. Report — in chat and to disk
Severity: 🔴 **Must fix** (bug or breakage) · 🟡 **Should fix** (real cost, not blocking) · ⚪ **Consider** (judgement call, take or leave).

Chat format — scannable, no praise section, no summary of what the PR does beyond one line:

```
## PR #<n> — <title>
<one line: what it does, and whether it matches the plan's intent>
CI: <pass/fail/pending>

### 🐛 Bugs
🔴 `path/file.ts:42` — <finding>. Fails when <concrete input/sequence>. → <fix>

### 🏗️ Overengineering
🟡 `path/file.ts:88` — <what's overbuilt>. → <the smaller thing>

### 💬 Comments
⚪ `path/file.ts` — 6 restating comments (worst: L23 `// set the flag`). → drop them; keep L51 (explains the retry).

**Verdict:** <ship / ship after the 🔴s / needs another pass> — <n> must, <n> should, <n> consider.
```

If a lens turns up nothing, say `✅ nothing found` in one line — don't pad it.

Then **save the same review** as Markdown to `<plan-folder>/pr-<n>-review.md` (same folder as the plan; `mkdir -p` if needed). Stamp it with the PR URL, the head SHA (`gh pr view --json headRefOid`), and today's date (`date +%Y-%m-%d`) so a later re-review can tell what moved. If the file already exists, show me and ask before overwriting.

## 8. Close out
- Print the absolute path to the saved review.
- Note anything you deliberately skipped (large diff, generated files) and any finding you're genuinely unsure about, so I can weight it.
- Do **not** post anything to GitHub. This command is read-only on the PR.
