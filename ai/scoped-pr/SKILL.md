---
name: scoped-pr
description: Commit only the current change's files and open a draft PR (scoped staging, branch hygiene, repo-aware commit convention)
argument-hint: [optional hint about what this PR is / how to scope it]
disable-model-invocation: true
allowed-tools: Bash(git status:*), Bash(git branch:*), Bash(git switch:*), Bash(git fetch:*), Bash(git rev-parse:*), Bash(git diff:*), Bash(git log:*), Bash(git add:*), Bash(git commit:*), Bash(gh pr create:*), Bash(gh pr view:*)
---

Commit **only the files involved in the change we just made** and open a **draft** PR. The user may add a hint about what this PR is or how to scope it.

Follow these steps. Stop and ask the user if any guardrail trips — do not guess.

## 1. Inventory before touching anything
- Run `git status` and `git branch --show-current`.
- Determine the base branch (`main` or `master` — check which exists).
- Read the repo's contribution instructions (`CONTRIBUTING.md`, PR templates) if present.
- Identify **which files belong to the change we just made** in this session. If unsure, ask. Everything else stays untouched.

## 2. Branch hygiene
- If currently on the base branch (`main`/`master`): create a new branch off it. Derive a short, descriptive branch name from the change (and, for work repos, include the Jira ticket if known).
- If the base branch is behind its remote, say so and ask before rebasing — do not silently reset or pull.
- If already on a feature branch, stay on it.

## 3. Scoped staging — the core guardrail
- Stage **only** the files that are part of this change: `git add <explicit paths>`.
- **NEVER run `git add -A`, `git add .`, or `git add -u`.**
- If there are other dirty or untracked files that are NOT part of this change, **list them explicitly** and leave them unstaged. Mention them to the user so nothing is silently swept in or left behind.
- Run `git diff --cached --stat` and confirm the staged set is exactly the intended change. If it includes anything unrelated, unstage it and re-check.
- If the change touches logic, types, styles, or tests, run `verify` before committing unless the user deferred it.

## 4. Commit — match the repo's convention
- Detect the convention from `CONTRIBUTING.md` and recent history (`git log --no-merges -10 --pretty=%s`):
  - **Conventional Commits** (e.g. `feat(scope): …`, `fix(…)`, `test(…)`, `docs(…)`, `chore(…)`) — the default for personal/OSS repos.
  - **Jira-ticket prefix** (e.g. `ABC-1234: …`) — used in work repos. If the branch name contains a ticket matching `[A-Z]+-[0-9]+`, prefix the subject with it.
- Write a concise, scoped subject describing *only* this change. Add a short body if the change needs context. Do not append a PR number (the merge does that).

## 5. Push + draft PR
- Push the branch with upstream tracking (`git push -u origin <branch>`).
- Open a **draft** PR: `gh pr create --draft --fill` (or supply `--title`/`--body` if `--fill` would be too terse). The body should summarize what changed, why, and how it was verified, in a few bullets.
- Print the PR URL.

## 6. Report
- One-line summary: branch, files committed, PR URL (draft).
- If you left any unrelated files unstaged, restate them so the user knows what's still pending.

Notes:
- This does **not** scan for secrets: check public repos for them yourself.
- Leave the PR as a draft. The user decides when to mark it ready.
- Don't post review comments, merge, force-push, or rewrite history unless asked separately.
