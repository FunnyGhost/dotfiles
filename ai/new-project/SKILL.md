---
name: new-project
description: Use when starting, scaffolding, or building a personal side project or quick idea (not work repos). Holds the default stack (Bun, Hono, Zod, Drizzle, SQLite via Shibumi Stack), frontend and deploy decisions, and the plan for evolving them.
---

# Side-project stack

The default for personal side projects. Decided on 2026-11-06 after evaluating
[Shibumi Stack](https://shibumistack.dev/). Goal: one small, reusable stack for
every idea, instead of heavy libraries for small projects. Not for work repos —
those follow their own team's stack.

## Stack

- **Runtime:** Bun (runs TS directly, built-in test runner, bundler, SQLite).
- **Server:** Hono. Render HTML with `hono/jsx` (typed templates, no React shipped).
- **Validation:** Zod at every boundary (forms, request bodies, env).
- **Data:** SQLite (one file) + Drizzle (typed SQL, migrations).
- **Front door:** Caddy (automatic HTTPS, routes domains to local ports).

## Frontend: escalate only when needed

1. No JS. HTML forms + server routes. Native `<details>`, `<dialog>`, `popover`.
2. htmx, when full page reloads feel clunky.
3. Alpine or a few lines of vanilla TS, for one specific widget.
4. Nanostores, only when several widgets share browser-side state.
5. React/Preact, only for a project that is mostly rich client UI (editor,
   canvas, game) — and only on that page. Server side stays the same.

Shibumi's template ships Alpine + Nanostores; don't use them by default.

## Scaffolding

```bash
bun create shibumi@latest <name>     # templates: full-stack, blog, static
bun run shibumi add <extension>      # copies source into the repo; no network
bun run shibumi remove <extension>
```

Extensions are code the project then owns (bundled in `scripts/shibumi.ts`).
They never receive upstream fixes — re-check upstream for security patches.

- **auth** — password + login-link, hashed cookie sessions, CSRF, rate limiting.
  JSON endpoints only: build the forms yourself. Rate limiter is in-memory,
  single process. Login links throw in production until wired to email.
- **email** — Resend only (`RESEND_API_KEY`, `EMAIL_FROM`).
- **uploads** — needs auth; stored on the server's disk, owner-scoped.
- **admin** — needs auth; list/delete users, gated by `ADMIN_EMAILS`.

## Deploy

- `bun ship` builds locally, uploads over SSH to shibumi-server on a VPS
  (rootless Podman + Caddy + systemd), health-checks, keeps a rollback.
- shibumi-server is experimental (0.10.x, single maintainer). Treat it as
  replaceable: the app is a plain Docker image, so Fly.io, Railway, or a
  hand-managed VPS run it unchanged.

## Agent rules per project

- Keep the scaffolded `agents.md` as the project's rules file; extensions add
  marked sections pointing at `agents/<name>.md`.
- Codex looks for `AGENTS.md`; Shibumi writes lowercase `agents.md`. That's
  the same file on macOS's case-insensitive disk, but not on Linux — rename
  it to `AGENTS.md` if the project is worked on there. For Claude Code, add a
  `CLAUDE.md` containing `@AGENTS.md`.

## Evolving the stack

The plan: use Shibumi as-is for the first 2–3 projects, then extract a personal
template repo (not a fork). To feed that:

- When something in the stack gets replaced, worked around, or repeatedly
  added by hand, append one line to
  `~/dev/research/side-project-stack/friction.md`: date, project, what, why.
- After 2–3 projects, or when asked, review that file and propose the template.
