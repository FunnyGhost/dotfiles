---
name: verify
description: "Run repo-aware verification for the current change: typecheck, lint, format checks, and affected tests, scoped to relevant changed files. Use when the user asks to verify or when code is ready for pre-push validation. Do not commit or silently apply fixes."
---

# Verify

Verify the current change with the narrowest correct checks. An optional user scope such as `all`, a path, or a workspace overrides automatic scoping.

## Establish the change

- Resolve the repository root and default branch.
- Combine committed branch changes, staged changes, unstaged changes, and untracked files into a deduplicated changed-file set.
- If no meaningful change is present, say so and stop.
- Classify files so irrelevant checks are skipped: TypeScript changes need typechecking; source and test changes need tests; formattable files need formatting checks; docs-only changes usually need none of those.

## Use the repository's toolchain

- Read lockfiles, workspace files, nearby package manifests, and scripts before choosing commands.
- Prefer repository scripts and affected/since modes over raw binaries and full-suite runs.
- Detect the package manager and orchestrator rather than assuming npm, Yarn, pnpm, Nx, Backstage, Turbo, Jest, Vitest, ESLint, or Prettier.
- In a repository with a Node version declaration, wrap package-manager, build, typecheck, lint, test, and format commands in `n exec auto --`. Never change the global Node version.

Choose the narrowest reliable form:

- Typecheck: affected workspace/package, repository typecheck script, or nearest applicable tsconfig.
- Lint: affected/since mode, changed workspace, or changed source files.
- Tests: Nx affected, Backstage `--since`, Jest related tests, Vitest related, or changed package tests. If an affected mode cannot be determined confidently, fall back to workspace scope and disclose that choice.
- Format: repository check script or changed-file check. Do not apply write mode without asking.

## Report

Give one compact result block with typecheck, lint, tests, and format. For each, show pass/fail/skip, exact scope, and command. On failure, include the actionable output and propose the smallest fix; do not commit.
