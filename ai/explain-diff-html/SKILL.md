---
name: explain-diff-html
description: Use when the user asks for a rich explanation of a code change, diff, branch, or PR. Produces a self-contained interactive HTML guide with background, intuition, a code walkthrough, and a quiz.
disable-model-invocation: true
---

# Explain Diff

Create a rich, interactive explanation of the specified code change. Teach the reader how the change works and why its pieces fit together, rather than merely summarizing the diff.

## Establish the evidence

- Resolve the requested scope and record the base and head commits. Use the conversation to infer the intended change; ask only if materially different scopes remain plausible.
- Inspect the diff and broadly explore the surrounding code: entry points, callers, data models, rendering or execution flow, persistence, and relevant checks. Explain unchanged infrastructure as background, not as new work.
- Ground claims and important excerpts in actual code. Include source links, preferably pinned to the compared commits, and label toy data, simplified examples, and inferred intent.
- Respect repository instructions and privacy boundaries. Do not read or embed secret files. Do not modify the target codebase merely to explain it.

## Required sections

Use these four top-level sections in one long page, with section headers and a table of contents. Do not use tabs for the top-level structure.

### Background

First offer deep background for beginners: explain the relevant architecture, terminology, and the path a concrete request or piece of data takes through the system. Make this explicitly skippable for familiar readers, using a skip link or a disclosure section. Then give the narrower background that directly motivates this change. Avoid unrelated tutorials.

### Intuition

Explain the essence of the change before its implementation details. Use concrete examples with small, explicitly labelled toy data. Show how the old and new behavior differ. Use figures and diagrams liberally when they clarify the mechanism.

Reuse a small number of diagram families throughout, such as:

- Simplified HTML mockups of the UI, when the change affects what a person sees.
- Data-flow or component diagrams containing example inputs, intermediate values, and outputs.

Use simple HTML/CSS designs or inline SVG, never ASCII diagrams. Use semantic HTML lists for lists. Interactive examples should teach a real behavior, not merely decorate the page.

### Code

Walk through the changes at a high level, grouped and ordered by responsibility or causal flow rather than alphabetically by filename. Connect each group to the intuition and explain the important boundaries, edge cases, and tradeoffs. Use selective excerpts and collapsible detail where useful; do not dump the entire diff. Distinguish checks actually performed from suggested checks and remaining limitations.

### Quiz

Provide exactly five medium-difficulty multiple-choice questions. Each should test understanding of the substance of the change, not trivia or gotchas. Use plausible distractors and one correct answer per question. When an answer is selected, show whether it is correct and explain why; incorrect answers should receive specific feedback. Use native keyboard-accessible controls, an announced feedback region, and a way to reset answers. Keep all question and feedback data inside the file.

## Writing and presentation

Write with the clarity and flow requested by the user: the concrete, carefully developed technical explanation exemplified by Martin Kleppmann, in engaging classic prose. Introduce the problem before the mechanism, define unfamiliar terms when needed, and make transitions between sections smooth. Do not invent quotes or imply authorship by another writer.

Use callouts for key definitions, surprising implications, and important edge cases. Favor readable paragraph widths, generous spacing, clear hierarchy, visible focus indicators, and responsive layouts. Honor reduced-motion preferences. Color must not be the sole carrier of meaning.

## Artifact requirements

- Produce a single self-contained HTML file with embedded CSS and JavaScript. It must work offline: no CDN libraries, external stylesheets/fonts, remote images, or runtime API requests. Inline any required assets. Ordinary source links may point to external pages.
- Save outside the code repo in a global location. Unless the user specifies another directory, use `/tmp/YYYY-MM-DD-explanation-<slug>.html`, with today's local date obtained from the system. The filename must always begin with the `YYYY-MM-DD-` prefix.
- Use `<pre><code>` for code blocks. If a custom styled container is necessary, it must have `white-space: pre-wrap`. Before saving, inspect every code block and confirm that its effective CSS explicitly sets `white-space: pre` or `pre-wrap`. Escape code and source-derived text as HTML.
- Give diagrams captions and accessible descriptions. Preserve the main explanation when JavaScript is unavailable; disclose which exercises require JavaScript.

## Verify and deliver

Check the saved HTML for valid section links, unique IDs, offline dependencies, code whitespace, and exactly five complete quiz questions. Exercise correct and incorrect quiz choices, feedback, reset, and other interactive examples. Inspect desktop and narrow-screen rendering when browser tooling is available; report any unverified visual behavior honestly. Validate substantive examples against the implementation, not just their appearance.

Return the clickable absolute path to the HTML. If the user's workflow uses an annotation viewer such as Plannotator, open the file there as an informational explanation; do not introduce a new approval gate unless requested. Creating an explanation does not authorize commits, pushes, PR comments, or other publication.
