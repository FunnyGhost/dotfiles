---
name: scoped-pr
description: Commit only the current change's files, preserve unrelated work, push the branch, and open a draft pull request using repository conventions. Use when the user asks to ship, push, commit and open a PR, or explicitly invokes scoped PR. This workflow mutates git and GitHub only when requested.
---

# Scoped PR

Commit only the files involved in the current change and open a draft PR.

1. Inspect status, current branch, remotes, default branch, recent commit subjects, and repository contribution instructions. Identify the exact intended file set from this session and any user-provided scope. If ownership is ambiguous, ask before staging.
2. Keep unrelated dirty or untracked files untouched and list them explicitly. Stage intended paths by name; never use broad staging such as `git add .` or an unscoped `git add -A`.
3. If on the default branch, create a short descriptive feature branch. If the default branch is stale, disclose it and ask before rebasing or pulling. Stay on an existing feature branch unless the user asks otherwise.
4. Run `$verify` before pushing changes to logic, types, styles, or tests unless the user explicitly deferred it.
5. Inspect the staged diff and confirm it contains exactly the intended change. Match commit and PR conventions from `CONTRIBUTING.md`, recent history, and branch ticket prefixes.
6. Commit, push with upstream tracking, and create a draft PR with a concise title and body explaining what changed, why, and verification performed.
7. Return the branch, committed files, commit, draft PR URL, and any unrelated files left unstaged.

Do not post review comments, mark the PR ready, merge it, force-push, or rewrite history unless separately requested.
