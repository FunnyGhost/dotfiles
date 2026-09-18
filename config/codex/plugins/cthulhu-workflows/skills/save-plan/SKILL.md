---
name: save-plan
description: Persist the current agreed plan as a cold-resume Markdown specification under the research hub. Use for multi-session or multi-PR work when the user asks to save, hand off, or preserve the plan.
---

# Save Plan

Persist the plan agreed in the current conversation to `~/dev/research/<task-slug>/plan.md`.

- Prefer an existing approved plan artifact as the source of truth; otherwise synthesize only agreed decisions from the conversation.
- If the target file exists, inspect it and ask before replacing it. Prefer updating its status and next sections in place.
- Stamp the document with the current date and include: goal/context, key decisions with rationale, ordered plan, status (done versus next), key paths and links, and open questions or risks.
- Keep it scannable and sufficient for a new session to resume cold. Use Markdown, not a polished HTML report.
- Return the absolute path and a one-line resume instruction pointing to the status section.
