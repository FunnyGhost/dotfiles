---
description: Persist the current plan/spec to ~/dev/research/<task>/plan.md so a multi-session task survives a fresh session
argument-hint: [optional task name/slug]
allowed-tools: Read, Write, Bash(mkdir:*), Bash(ls:*), Bash(date:*)
---

Save the plan/spec we've been working on to disk so I can resume it cleanly in a fresh session. Optional task name: $ARGUMENTS

## 1. Gather the plan
- Use the plan/spec we've agreed on in this conversation. If we're in (or were in) plan mode and a plan file exists under `~/.claude/plans/`, read it as the source of truth. Otherwise synthesize from what we've decided so far.

## 2. Pick the location
- Slug: kebab-case from `$ARGUMENTS` if given, else derive a short slug from the task.
- Path: `~/dev/research/<slug>/plan.md`. Create the folder (`mkdir -p`).
- If `plan.md` already exists there, **don't silently overwrite** — show me what's there and ask whether to update it (preferred: update the Status/Next sections in place) or write a dated variant.

## 3. Write it — a cold-resume spec, in Markdown
Stamp it with today's date (`date +%Y-%m-%d`). Include, concisely:
- **Goal / context** — what this task is and why, enough to reload cold.
- **Key decisions** — what we settled and the reasoning (so I don't re-litigate).
- **Plan** — the steps/approach.
- **Status** — what's done vs what's next (the single most important section for resuming).
- **Key paths** — repos, files, PRs, and any `~/dev/research` docs involved.
- **Open questions / risks** — anything unresolved.

Keep it scannable (headings + bullets). Markdown, not HTML — this is a working doc, not a hub report.

## 4. Report
- Print the absolute path.
- One line on how to resume: re-open this `plan.md` (or find the chat with `wwid`) and continue from the Status section.
