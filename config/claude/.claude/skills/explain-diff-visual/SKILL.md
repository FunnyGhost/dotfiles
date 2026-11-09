---
name: explain-diff-visual
description: Use when the user asks for a rich, visual explanation of a code change, diff, branch, or PR. Produces one self-contained, animated HTML page (visual-explainer's kit in Plannotator's theme) with background, intuition, a code walkthrough, and an interactive quiz, opened in Plannotator.
---

# Explain Diff, Visually

Make a rich, interactive explanation of the specified code change: the depth
and quiz of `explain-diff-html`, drawn the way `plannotator-visual-explainer`
draws its visual explanations: nicobailon's `visual-explainer` kit (figures,
steppers, replays, the render check) in Plannotator's theme.

Those two skills own the look. This skill owns the content: what the page
must explain, how deep, and the quiz. Where they disagree, this file wins.

## 0. Setup

Find both skills under `~/.claude/skills/` (else `~/.agents/skills/`):

- `visual-explainer`. If missing, tell the user:
  `npx skills add nicobailon/visual-explainer -g -a claude-code codex -y`.
- `plannotator-visual-explainer`. If missing, point to the dotfiles
  `CLAUDE.md`, section 1.3.

Read, in this order:

1. `visual-explainer/SKILL.md`, then its `references/style-guide.md`,
   `kit.md`, `diagrams.md`, and `motion.md`.
2. `plannotator-visual-explainer/references/theme-override.md`.

Follow them for markup, figures, motion, and rendering, except where this
file overrides them.

## 1. Understand the change

- Get the change: `git diff` / `git diff <base>...HEAD` for a branch,
  `gh pr view` + `gh pr diff` for a PR, or what the user points at.
- Explore broadly around it: the callers, the data it touches, the module it
  lives in, related tests. The background section depends on this. Don't
  explain from the diff alone.
- Find the one-sentence answer: what changed, and why it matters.

## 2. Theme: Plannotator over the kit

The page's `<head>`, in this order:

```html
<html lang="en" data-register="blueprint">
<head>
<title>The change's effect, as a sentence</title>
<meta name="plannotator-theme" content="host">
<link rel="stylesheet" href="kit.css" data-ve-kit>
<style>
/* 1. theme-override.md's :root defaults, and its prefers-color-scheme: dark block */
/* 2. the mapping below, so the kit draws in Plannotator's tokens */
html[data-register] {
  --bg: var(--background);
  --surface: var(--card);
  --text: var(--foreground);
  --text-dim: var(--muted-foreground);
  --accent: var(--primary);
  --accent-dim: color-mix(in oklab, var(--primary) 15%, transparent);
  --border-bright: color-mix(in oklab, var(--foreground) 40%, var(--border));
  --ok: var(--success);
  --warn: var(--warning);
  --risk: var(--destructive);
  --info: var(--secondary);
  --font-body: var(--font-sans);
}
/* 3. this page's own CSS, including the quiz CSS below */
</style>
</head>
```

The `plannotator-theme` meta makes the page follow Plannotator's active theme
and light/dark mode. Register: **Blueprint** by default; **Paper** when the
change is mostly a concept rather than a system.

## 3. The page

One long page with the kit's section nav (`.ve-toc`). No tabs for the
top-level structure. Sections, in order:

1. **The answer (first screen).** Headline that states the change's effect,
   a lead sentence, a meta line (files, +/−, branch → base), and one figure:
   the mechanism that changed, before → after. A KPI strip only for real
   numbers.
2. **Background.** The existing system relevant to this change. We don't know
   how much the reader knows, so in two layers:
   - **From the ground up:** a deep background for beginners, in a
     `<details>` with the summary "New to this? Start here", so a familiar
     reader can skip it. Figures here too.
   - **What this change touches:** the narrow background directly relevant to
     the change, always visible, with a system figure that carries example
     data.
3. **Intuition.** The core idea of the change: the essence, not the details.
   Concrete examples with **toy data** (real-looking values, not `foo`). This
   is where motion earns its place: a stepper or replay for anything that
   happens over time, small multiples for cases, the difference drawn side by
   side. Pick two or three diagram families and reuse them.
4. **The code.** A walkthrough grouped and ordered so it's easy to follow (by
   concept or data flow, not file order). For each group: what it does, why
   it's written that way, the key lines in a `<pre>` with the file path
   above it, and `data-ref` links between prose terms and figure parts.
5. **Risks and where to focus.** Edge cases, what a reviewer should check,
   what could break: small multiples or callouts with status chips.
6. **Quiz.** Five questions; see below.
7. **Sources.** The kit's visible sources section: files with line numbers,
   the PR or commit, the base it's compared against.

## 4. How much to write

`visual-explainer` keeps prose to captions. This page teaches, so relax that
— but only that:

- **Figures still lead.** Most sections open with a figure, and every fact
  that fits in one goes there first. Keep its look rules, rhythm, and motion
  exactly.
- **But explain the why.** Each section gets the prose it needs: why the old
  code was a problem, why this approach, what was traded off. A few short
  paragraphs per section, never a wall of text.
- **Style:** the clarity and flow of Martin Kleppmann, in classic style:
  engaging, concrete, with smooth transitions. Keep visual-explainer's
  sentence rules (one idea per sentence, active voice, headings that state
  the takeaway).

## 5. Quiz

Five multiple-choice questions, medium difficulty: you need to understand the
substance of the change to answer them, but no gotchas. The goal is to let
the reader check they've actually understood. Every option, right or wrong,
gets a one-sentence explanation of why.

Use this block as is; only write the questions. Copy the CSS into the page's
`<style>` and the script right before `</body>`. It uses the kit's tokens,
which the mapping turns into Plannotator's.

```html
<section id="quiz">
  <p class="ve-label caps">Quiz</p>
  <h2>Five questions to check you've got it</h2>
  <div class="quiz">
    <div class="q">
      <p class="q-t"><span class="q-n">1</span>Question text?</p>
      <ol class="opts">
        <li><button data-why="Why this is wrong, in one sentence.">Option A</button></li>
        <li><button data-ok data-why="Why this is right, in one sentence.">Option B</button></li>
        <li><button data-why="Why this is wrong, in one sentence.">Option C</button></li>
      </ol>
      <p class="fb" hidden></p>
    </div>
    <!-- four more .q blocks -->
    <p class="quiz-score">0 / 5 answered</p>
  </div>
</section>
```

```css
.quiz .q { padding: var(--s-5) 0; border-top: 1px solid var(--border); }
.quiz .q-t { font-weight: 600; }
.quiz .q-n { font-family: var(--font-mono); color: var(--accent); margin-right: var(--s-3); }
.quiz .opts { list-style: none; padding: 0; margin: var(--s-3) 0 0; display: grid; gap: var(--s-2); }
.quiz .opts button { font: inherit; color: var(--text); text-align: left; width: 100%; padding: var(--s-3) var(--s-4); background: var(--surface); border: 1px solid var(--border-bright); border-radius: var(--r-1); cursor: pointer; transition: transform var(--fast) var(--ease); }
.quiz .opts button:hover:not(:disabled) { border-color: var(--accent); }
.quiz .opts button:disabled { cursor: default; }
.quiz .opts button.is-right { border-color: var(--ok); }
.quiz .opts button.is-wrong { border-color: var(--risk); }
.quiz .opts button.is-right::after { content: "  ✓"; color: var(--ok); }
.quiz .opts button.is-wrong::after { content: "  ✕"; color: var(--risk); }
.quiz .fb { margin-top: var(--s-3); }
.quiz .fb .chip { margin-right: var(--s-2); }
.quiz .quiz-score { margin-top: var(--s-5); font-family: var(--font-mono); color: var(--text-dim); }
```

```html
<script>
document.querySelectorAll('.quiz').forEach(quiz => {
  const qs = [...quiz.querySelectorAll('.q')];
  const score = quiz.querySelector('.quiz-score');
  let answered = 0, right = 0;
  qs.forEach(q => q.querySelectorAll('.opts button').forEach(b => b.addEventListener('click', () => {
    if (q.dataset.done) return;
    q.dataset.done = '1';
    answered++;
    const ok = b.hasAttribute('data-ok');
    if (ok) right++;
    const correct = q.querySelector('.opts button[data-ok]');
    q.querySelectorAll('.opts button').forEach(x => { x.disabled = true; });
    correct.classList.add('is-right');
    if (!ok) b.classList.add('is-wrong');
    const fb = q.querySelector('.fb');
    const chip = document.createElement('span');
    chip.className = 'chip ' + (ok ? 'ok' : 'risk');
    chip.textContent = ok ? 'Correct' : 'Not quite';
    fb.replaceChildren(chip, b.dataset.why + (ok ? '' : ' ' + correct.dataset.why));
    fb.hidden = false;
    score.textContent = answered < qs.length
      ? `${answered} / ${qs.length} answered · ${right} correct`
      : `${right} / ${qs.length} correct`;
  })));
});
</script>
```

## 6. Output

- Source: `~/.agent/diagrams/YYYY-MM-DD-explain-<slug>.src.html`, with
  today's date. Always outside the code repo.
- Render with `node <visual-explainer>/kit/render.mjs <file>.src.html` (no
  `--open`). Fix every `✗`, look at the sheet it writes once, then fix with
  small edits and render again: visual-explainer's loop.
- Deliver the rendered `<file>.html` with `plannotator annotate <file>.html`,
  as Plannotator's explainer does. Don't use `open`.
- Reply with the path and a two-sentence summary of the change.

## Before delivery

```
□ the render shows no ✗; every figure has a caption stating its claim
□ the head has the plannotator-theme meta, the :root defaults, and the mapping
□ the first screen answers "what changed and why" with a picture
□ the beginner background is in a <details>; the narrow background is visible
□ intuition uses toy data and moves where something happens over time
□ the code walkthrough is grouped by concept, with paths; every block is a <pre>
□ five quiz questions, each option with a why; clicking shows feedback and the score
□ filename starts with today's date, in ~/.agent/diagrams/; opened with plannotator annotate
```

Based on Geoffrey Litt's explain-diff prompt (see `explain-diff-html`),
nicobailon/visual-explainer, and Plannotator's visual explainer.
