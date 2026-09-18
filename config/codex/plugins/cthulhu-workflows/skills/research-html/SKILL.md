---
name: research-html
description: Deep-research a focused topic and create a cited, self-contained, house-styled HTML report in the local research hub. Use when the user asks for a durable research report, not for a quick answer.
---

# Research HTML

Create `~/dev/research/<topic-slug>/<topic-slug>.html` for a specific research question.

- If the question is broad enough that the decision, scope, source set, or time horizon would materially change the work, ask two or three focused questions before researching.
- Research from authoritative sources, verify consequential claims adversarially, and cite every non-obvious external claim near where it appears.
- Read `~/dev/research/_shared/style-guide.html` and use an existing hub document such as `orgtype-resourcing/orgtype-primer.html` or `_shared/architecture.html` as the structural reference.
- Produce one self-contained HTML file with inline CSS. Keep local images beside it and reference them relatively. External assets are limited to the Google Fonts link used by the hub.
- Include sticky jump navigation, a hero with title/subtitle and scope/last-verified metadata, a TL;DR card, scannable sections, explicit uncertainty markers, and a sources section.
- Return the absolute path and note anything important that could not be verified.
