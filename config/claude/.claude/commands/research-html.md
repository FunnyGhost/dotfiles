---
description: Deep-research a topic and write a cited, house-styled HTML report into ~/dev/research/<topic>/
argument-hint: <research topic or question>
---

Research this topic and produce a cited HTML report in my research hub: $ARGUMENTS

## 1. Scope it first — ask before researching
- Unless the topic is already specific and unambiguous, ask me **2–3 clarifying questions** before starting: what decision this informs, the depth/breadth I want, which platforms/sources matter, and the time horizon. Wait for my answers — don't start a deep dive on a vague prompt. (The deep-research skill also does this; this is a deliberate reinforcement — I'm annoyed when it's skipped.)

## 2. Run the research
- Use the **deep-research** skill on the refined question: fan-out web search, fetch sources, adversarially verify claims, synthesize. Keep the citations — every non-obvious claim must trace to a source.

## 3. Write it into the research hub — match the house style
- **Location:** `~/dev/research/<topic-slug>/<topic-slug>.html` (kebab-case slug from the topic). Create the folder. Put any images/screenshots in that same folder, referenced relatively. Don't dump into `to-organize/`.
- **Self-contained:** a single HTML file — inline CSS, no external assets except the Google Fonts `<link>` the hub already uses.
- **House style — read it, don't guess:** open `~/dev/research/_shared/style-guide.html` (colors, typography, the doc-card / badge / table / callout components, and its "Using this in a new doc" section) and follow it. Use an existing hub doc as a structural template — `~/dev/research/orgtype-resourcing/orgtype-primer.html` or `~/dev/research/_shared/architecture.html` are good exemplars (sticky nav, hero with eyebrow + meta pills, TL;DR card, sectioned body, tables, callouts).
- **Structure:** sticky top nav with jump links, a hero (title + one-line sub + meta pills incl. a `Last verified: <date>` pill and a scope pill), a TL;DR card, then the body in scannable sections. A **Sources** section at the end with the citations.
- **Honesty markers:** carry a "last verified" date and mark anything point-in-time or uncertain, the way the other hub docs do — so it ages visibly instead of silently rotting.

## 4. Report
- Print the absolute path to the file and offer to `open` it.
- Note anything you couldn't verify or had low confidence on, so I know what to treat with caution.
