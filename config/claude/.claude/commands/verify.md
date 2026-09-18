---
description: Repo-aware verify — typecheck, lint, prettier, and affected tests, scoped to what changed
argument-hint: [optional: "all" for full (non-affected) run, or a path/workspace to scope to]
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git rev-parse:*), Bash(git merge-base:*), Bash(cat:*), Bash(ls:*), Bash(n:*), Bash(node:*), Bash(yarn:*), Bash(pnpm:*), Bash(npm:*), Bash(npx:*), Bash(nx:*), Bash(tsc:*), Bash(prettier:*), Bash(jest:*), Bash(vitest:*), Bash(eslint:*), Bash(backstage-cli:*), Read, Glob
---

Verify the change we just made: **typecheck**, **lint**, **prettier/format**, and **affected tests** — using whatever each repo actually uses. Scope to what changed — do not run the whole suite unless the user passed `all`. Optional arg: $ARGUMENTS

## 0. Figure out the change set
- `git rev-parse --show-toplevel` for the repo root; `cd` there.
- Determine changed files: staged + unstaged + untracked vs the base branch
  (`git diff --name-only $(git merge-base HEAD origin/main 2>/dev/null || git merge-base HEAD origin/master) HEAD` plus `git status --porcelain`). Dedupe into one list.
- If `$ARGUMENTS` is a path/workspace, scope to it. If it's `all`, run full (non-affected) checks.
- Classify the changed files: any `.ts/.tsx` (→ typecheck), any source/test files (→ affected tests), any formattable files (→ prettier). **Skip a check entirely if nothing relevant changed** (e.g. docs-only change → skip typecheck and tests).

## 1. Node version — use the repo's, without changing the global default
- If the repo has a node version file (`.nvmrc` / `.node-version` / `.n-node-version` / `package.json` `engines.node`), run every package-manager / typecheck / lint / test command in this verify wrapped as `n exec auto -- <cmd>` (e.g. `n exec auto -- yarn tsc`, `n exec auto -- pnpm test`). This uses the repo's node **for that command only** and does NOT change the global active node. `n exec auto` installs the version first if missing. Do not use `n auto` / `n <version>` here — those flip the global default. Wrong Node version is a common false failure.

## 2. Detect tooling (don't assume) — read `package.json` scripts and lockfiles
- **Package manager:** `pnpm-lock.yaml`→pnpm, `yarn.lock`→yarn, else npm.
- **Monorepo orchestrator:** presence of `nx.json`→Nx, `backstage-cli` in scripts→Backstage, `turbo.json`→Turbo, `pnpm-workspace.yaml`→pnpm workspaces.
- Prefer the repo's **own scripts** over raw binaries. Look for, in order of preference:
  - typecheck: `typecheck` › `tsc` › (per-workspace) `ptypecheck <ws>` › raw `tsc --noEmit -p <nearest tsconfig>`
  - lint: an **affected/since** mode if available (`lint --since origin/main`, `nx affected -t lint`, `plint <ws>`) › `lint` › raw `eslint <changed files>`. Use the repo's linter even if it isn't ESLint (oxlint, stylelint, ast-grep, biome — whatever the scripts reveal).
  - format: `format:check` › `prettier:check` › the repo's formatter (`oxfmt --check`, etc.) › raw `prettier --check <changed files>`
  - tests: an **affected/related** mode (see the tests step) › the package script for the changed workspace › `test`

## 3. Typecheck (only if `.ts/.tsx` changed)
- Run the detected typecheck command. For per-workspace monorepos (no root tsconfig, e.g. an Nx repo), run it scoped to the changed workspace(s) rather than the whole tree.
- Backstage repos: `yarn tsc`. Single-project repos: the `typecheck` script. Report errors verbatim.

## 4. Lint (only if source changed)
- Run the detected lint command, scoped to changed files/workspaces where the linter supports it — don't lint the whole monorepo for a 2-file change.
- Use the repo's own linter (ESLint, oxlint, stylelint, ast-grep, biome…). Report violations verbatim; offer the autofix mode (`--fix`) only after showing what failed, and don't apply it silently.

## 5. Affected tests (only if source/tests changed)
- Use the narrowest correct scope:
  - **Nx:** `nx affected -t test` (or `--files=<changed>`).
  - **Backstage:** `yarn test --since origin/main` (backstage-cli supports `--since`).
  - **Jest:** `jest --findRelatedTests <changed .ts/.tsx files>`.
  - **Vitest:** `vitest related <changed files> --run`.
  - **pnpm workspaces:** run the test script only in the changed package(s) via `--filter`.
- If you can't determine an affected mode confidently, run the changed workspace's `test` script — and say you fell back from affected to workspace scope (no silent full-suite runs).

## 6. Prettier / format (only if formattable files changed)
- Prefer `format:check` / `prettier:check`. If only a few files changed, `prettier --check <changed files>` is faster.
- If it fails, offer to run the write mode (`prettier --write <files>` / the repo's `format` script) — but do not auto-format without saying so.

## 7. Report — one scannable block
- A line per check: ✅/❌ **typecheck**, **lint**, **tests** (with the scope used — affected/workspace/all), **prettier**. Skipped checks marked `— (no relevant changes)`.
- On any ❌: show the failing output and the exact command, then ask whether to fix now (offer prettier `--write` for format fails; propose the typecheck/test fix for the rest). Do not commit anything — this only verifies.
