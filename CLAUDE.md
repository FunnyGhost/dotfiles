# CLAUDE.md — dotfiles operating manual

This file is the source of truth for setting up and maintaining this repo.
`README.md` is a thin wrapper that points here.

## 0. Maintenance contract (read first)

Any change to this repo must keep documentation in sync, in the same commit:

- Changing setup steps, dependencies, or how stow is invoked → update **this file**.
- Changing the user-facing description or the list of what's included → update **README.md**.
- If a change makes any statement in either file false, fix the statement
  in the same commit. No "I'll update the docs later."

Before committing, ask: would a fresh-laptop run of section 1 still work?
If not, fix section 1.

## 1. Fresh-laptop setup

Prerequisites (you've already done these to land here):

- Homebrew is installed.
- This repo is cloned at `~/dotfiles`.
- You're running Claude Code from inside it.

Idempotent. Don't parallelize — each step depends on the previous.

### 1.1 Initialize submodules

```bash
git submodule update --init --recursive
```

### 1.2 Install Homebrew packages

```bash
export XDG_CONFIG_HOME=~/.config
brew trust eth-p/software felixkratz/formulae funnyghost/tap nikitabobko/tap
brew bundle install
```

Homebrew refuses to load formulae from third-party taps until they're
trusted. It stores that list under `$XDG_CONFIG_HOME/homebrew/`, falling back
to `~/.homebrew/` when the variable is unset. The stowed `~/.zshrc` sets it
to `~/.config`, but only in shells started after step 1.3 — export it now, or
every tap trusted here silently reverts to untrusted later.

Public packages only. `Brewfile.local` comes later, in step 1.4 — its taps
may need credentials that don't exist yet.

### 1.3 Stow every config

```bash
mkdir -p ~/.config/herdr ~/.claude/commands ~/.claude/skills \
  ~/.config/herdr-app/themes ~/.config/herdr-app/mods/my-prefix \
  ~/.config/rex/themes
stow -d config -t ~ $(command ls config)
stow -d . -t ~ git-commands
```

`command ls` bypasses the `eza` alias defined in `.zshrc`. Stowing everything
under `config/` is intentional — see section 2. The `mkdir` prevents stow from
folding those into symlinks pointing at the repo. All are directories the
tools themselves write into — herdr drops a socket and logs beside its config,
Claude Code writes commands and Plannotator installs skills, Herdr.app keeps
all its state and generated files in `~/.config/herdr-app/` — and that output
must not land here (see section 2).

Then the Plannotator skills for Codex. They're third-party, so they're
installed rather than tracked (`config/codex/.agents/skills/` is gitignored):

```bash
curl -fsSL https://plannotator.ai/install.sh | bash
npx skills add https://github.com/backnotprop/plannotator/tree/main/apps/skills/extra \
  -g -a codex -s '*' -y
```

The installer brings the CLI, the Claude plugin, a Codex hook and the core
skills (`plannotator`, `-annotate`, `-last`, `-review`); `npx skills` adds the
extras (`-compound`, `-setup-goal`, `-visual-explainer`). Run both after
stowing — they write into `~/.agents`, which must already be the stow symlink.

Then `visual-explainer`, which `plannotator-visual-explainer` and the tracked
`explain-diff-visual` skill draw with — same installed-not-tracked rule:

```bash
npx skills add nicobailon/visual-explainer -g -a claude-code codex -y
```

### 1.4 Restore local overrides (manual, per machine)

These files are gitignored and must be restored from your previous laptop,
password manager, or 1Password:

- `~/.zshrc.local` — work env vars, tokens, and work-only shell helpers
  (anything naming internal repos or tooling). Sourced by the stowed `~/.zshrc`.
- `~/dotfiles/Brewfile.local` — work-specific casks and taps.
- Raycast settings — in 1Password as the **Raycast Settings Export** document
  (Private vault), plus its export password. Restore via Raycast's
  **Import Settings & Data**.
- Work-specific `~/.claude/commands/learn-*.md` and the Codex `learn-*` skills
  under `config/codex/` — gitignored, so a clone won't bring them. Copy from
  the old machine.

Then install the work packages, which step 1.2 deliberately skipped:

```bash
source ~/.zshrc.local
[[ -f Brewfile.local ]] && brew bundle install --file=Brewfile.local
```

A private tap can refuse to load without credentials exported from
`~/.zshrc.local`, so source it first — `~/.zshrc` won't have run this early.

If either file is absent, shell startup and the `[[ -f ... ]]` guard both
tolerate it.

### 1.5 Terminal font

The font everywhere is **Mononoki**, 16pt, with extra line height. `brew
bundle` installs it, and Ghostty and WezTerm already set it in their tracked
configs. Rex keeps its font in its Settings window — see the Rex section in
section 2.

### 1.6 Start the background apps

```bash
open -a AeroSpace
open -a Karabiner-Elements
defaults write com.apple.dock expose-group-apps -bool true && killall Dock
```

The `defaults` line turns on Mission Control's **Group windows by
application**. AeroSpace hides other workspaces' windows in a screen corner,
and without grouping Mission Control shrinks everything to tiny, scattered
thumbnails.

`brew bundle` already registered sketchybar as a login service
(`start_service: true`). AeroSpace adds itself to login items
(`start-at-login` in `.aerospace.toml`) and, on every startup, launches
borders and reloads sketchybar. Neither does anything until macOS grants
the permissions below — one-time GUI approvals, nothing can automate them.
In System Settings > Privacy & Security:

- **Accessibility** — AeroSpace. Restart it afterwards so its startup
  commands run.
- **Karabiner** — follow its setup window: enable the driver extension under
  Login Items & Extensions, and grant Input Monitoring.

### 1.7 Restart shell

```bash
exec zsh
```

### 1.8 Verification

```bash
command -v stow nvim starship gh fzf eza zoxide bat jq    # all resolve
readlink ~/.zshrc ~/.gitconfig ~/.claude/CLAUDE.md \
  ~/.config/herdr-app/keys.json                           # all point into ~/dotfiles
git -C ~/dotfiles status                                   # clean (or only *.local untracked)
git -C ~/dotfiles submodule status                         # git-commands populated
echo '{}' | ~/.claude/statusline.sh                        # prints a status line
brew services list | command grep sketchybar               # started
pgrep -x borders                                           # running (AeroSpace starts it)
```

If any check fails, fix it before declaring the laptop ready.

### 1.9 Updating a machine that already has this repo

For a machine that was set up earlier and has fallen behind. Safe to rerun.

```bash
cd ~/dotfiles
git pull
git submodule update --init --recursive
brew bundle install

# must exist before stow, or stow folds them into symlinks into the repo
mkdir -p ~/.config/herdr ~/.claude/commands ~/.claude/skills \
  ~/.config/herdr-app/themes ~/.config/herdr-app/mods/my-prefix \
  ~/.config/rex/themes

stow -d config -t ~ --restow $(command ls config)
stow -d . -t ~ --restow git-commands
exec zsh
```

`--restow` is the point: plain `stow` won't reliably pick up files added to a
package that's already stowed. New packages under `config/` are picked up
automatically by the `command ls` expansion.

Not covered by the above, because it's gitignored or manual:

- `~/.zshrc.local` and `Brewfile.local` — copy from the other machine.
- Work-specific `~/.claude/commands/learn-*.md` and the Codex `learn-*`
  skills — gitignored, so `git pull` won't bring them.
- `op signin`, for `rayconfig-backup`.

`brew bundle install` only adds. It won't remove packages dropped from the
Brewfile, which is fine. Don't run `brew bundle cleanup`: it uninstalls
anything not listed, including everything in `Brewfile.local`.

## 2. Working conventions

### Stow auto-discovers everything in `config/`

Every directory under `config/` gets stowed. The list is not hardcoded.
To stop using a tool, just stop using it — leave the config dir alone.
Old configs are kept on purpose, in case the user returns to the tool.
**Do not delete** dirs like `config/yabai/`, `config/skhd/`, etc.

### Local-overrides pattern

Secrets and work-specific config live in two gitignored files **outside the
stow source**:

- `~/.zshrc.local` — sourced by `config/zsh/.zshrc` (the stowed `~/.zshrc`).
- `~/dotfiles/Brewfile.local` — at the repo root, beside `Brewfile`.

**Never** put `.zshrc.local` inside `config/zsh/`. Stow would try to
symlink it over the real one and the stow command would fail.

### Never regenerate the Brewfiles with `brew bundle dump`

Both `Brewfile` and `Brewfile.local` are maintained **by hand**. A dump
enumerates the whole machine, which breaks the split two ways:

- It writes work-specific entries (the private work tap and its
  formulae/casks) into the public `Brewfile`, publishing internal repo and
  package names.
- It **silently omits** formulae from untrusted third-party taps — no warning,
  exit 0. Only taps listed by `brew trust --list` survive, so `bat-extras`,
  `borders`, and `sketchybar` disappear even though they're installed. Run
  `brew trust <tap>` if you ever want a dump to see them.

Dumping into `Brewfile.local` is worse still: it replaces the work-only
overrides with a full copy of the system, destroying the separation.

The `bbd` alias therefore dumps to `/tmp/Brewfile.new` and shows a diff only.
Merge anything you want by hand.

### Raycast settings aren't stowable

Raycast keeps its config in encrypted SQLite, and its plist is machine-local
state that macOS rewrites — stow can't usefully track either. Use Raycast's
**Export / Import Settings & Data** instead.

The exported `.rayconfig` stays out of this repo: it's protected only by its
password and includes extension preferences, where extension API keys live.
Keep it in 1Password — `rayconfig-backup` uploads the newest export and
deletes the local copy (needs `op` signed in).

### Claude statusline

`config/claude/.claude/statusline.sh` is a bash + jq script, stowed to
`~/.claude/statusline.sh`. `settings.json` references it via `~/.claude/…`,
with no absolute path and no external runtime dependency beyond `jq`
(already in Brewfile). To change what the statusline shows, edit the
script — not `settings.json`.

### Submodules

- `git-commands/.git-commands` → `FunnyGhost/git-commands`

### Herdr.app, not the herdr TUI

The agent multiplexer in use is **Herdr.app** (`cask "herdr-app"`).
`config/herdr/` is the old TUI's config, kept per the rule above; the TUI
itself is no longer in the Brewfile.

`config/herdr-app/` tracks only the deliberate overrides — everything else in
`~/.config/herdr-app/` is written by the app:

- `keys.json` — the app's full keymap, plus `ctrl-b` → the `my-prefix` popup
  (tmux-style prefix: `]`/`[` agents, `hjkl` focus, `v`/`-` split, …).
- `mods/my-prefix/` — that popup. Only `main.js` and `mod.json` are ours; the
  app drops `gpui-kit.d.ts` / `jsconfig.json` beside them (gitignored).
- `settings.json`, `themes/eldritch.json` — Eldritch look.

Stay on the shipped `main` layout. Shipped layouts can't be edited (the app
moves edits aside on start), and a cloned layout never receives updates —
that trade wasn't worth it for one shortcut (a last-pane jump).

`~/.config/herdr-app/`, `themes/` and `mods/my-prefix/` must be **real
directories** (the `mkdir -p` in section 1.3); folded, the app's state lands
in the repo. The app writes through the symlinks fine (e.g. zoom updates
`settings.json`). Delete one of those files, though, and the app instantly
recreates it with defaults — replace with `ln -sf`, not `rm` + stow.

### Codex config stows to three places

`config/codex/` is one stow package covering three targets:

| repo path | stows to |
|---|---|
| `.codex/AGENTS.md` | `~/.codex/AGENTS.md` |
| `.agents/plugins/marketplace.json` | `~/.agents/plugins/marketplace.json` |
| `plugins/cthulhu-workflows/` | `~/plugins/cthulhu-workflows/` |

`~/plugins` being outside a dot-directory is **intentional, not a mistake**.
The `personal` marketplace resolves its relative `source.path` against its
root, and that root is `$HOME` — confirm with `codex plugin marketplace list`.
Moving the plugin under `.agents/` would require editing `marketplace.json`
to match, so leave it unless `codex plugin list` says the plugin is missing.

Two consequences worth knowing:

- `~/.agents` itself is a stow-**folded** symlink into this repo, so anything
  tools write there (lock files, plugin state, installed skills) lands inside
  the repo. A `.gitignore` backstop covers the known cases, including the
  third-party skills from section 1.3.
- Work-specific skills that name internal repos or services are gitignored,
  not committed — this repo is public. They still stow and load normally;
  they just never reach GitHub. Keep new work-specific skills out the same way.

### After-stow gotcha for `~/.claude/`

`~/.claude/` is a real directory (Claude Code owns it), not a stow-folded
symlink. Files inside are symlinked individually. **Adding a new file
under `config/claude/.claude/` requires `stow -d config -t ~ --restow claude`**
for the new symlink to appear in `~/.claude/`.

Herdr.app lists a terminal as an agent only once its program reports status
via OSC 7501, which Claude Code doesn't emit. `hooks/herdr-app-status.sh` does
it from the lifecycle hooks in `settings.json` (idle / working / blocked /
done / clear), writing to the claude process's tty since hooks have no
`/dev/tty`. Agents started before the hooks existed stay invisible until
restarted. Don't run the old TUI's `herdr integration install claude` — it
targets the TUI only and rewrites `settings.json` with absolute paths.

The `rex __internal session-start` hook is **Rex's**, not ours — Rex wrote it
into `settings.json` (through the symlink) on setup. It gives Claude context
at startup: that it's in a Rex pane, its session and pane IDs, and how to use
`rex`. We added `--feature-session-naming=false`: without it, Rex also tells
the agent to rename the session on every start and resume, overwriting names
you set. Re-running `rex skill setup` or **Install Rex for Agents** rewrites
the hook without that flag — add it back. Rex itself is installed manually
(not in the Brewfile); without it the hook is a silent no-op (`|| true`).

### Rex: keybindings and theme tracked, Settings window not

`config/rex/` stows `~/.config/rex/init.lua` (keybindings) and
`themes/Eldritch`. Both `~/.config/rex/` and `themes/` must be real
directories (the `mkdir -p` in section 1.3) — Rex writes imported themes there.

Everything set in Rex's Settings window (interface style, fades, tabs, the
selected theme) lives in `~/Library/Preferences/com.superlogical.rex.plist`.
It isn't tracked: it's mixed with machine state and agent activity history,
and the selected theme is an ID generated at import. On a fresh laptop, import
`themes/Eldritch` via **Settings › Themes › Import Theme**, select it, and set
**Interface › Appearance › Interface style** to Classic — the blended style
washes the background out to grey. Then, under **Terminal › Typography**:

- Font **Mononoki Nerd Font** (not "Mono", which shrinks icons; not "Propo"),
  16pt. Plain Mononoki lacks the icons Starship, eza and nvim use.
- **Advanced Font Settings:** line height +15–20%, character spacing +2%,
  font smoothing on — matching Ghostty's `adjust-cell-*`.

`ctrl+h/j/k/l` is smart navigation, split across two files:

- `init.lua` moves between Rex panes, except when the pane's foreground program
  is nvim, vim or fzf — those get the key.
- nvim's `lua/keymaps.lua` moves between splits and, at the edge split, runs
  `rex focus <direction>` to continue into the next pane.

To add a program that should keep ctrl+hjkl, extend `passthrough` in `init.lua`.

`ctrl+b w` opens **Wayfinder**, a Herdr-style tab picker, loaded with
`require("wayfinder")`. It lives in `wayfinder/` as a self-contained module
meant to be shared — its `README.md` is the user-facing doc and setup guide,
so keep it in sync with the code. Keep the module free of anything specific
to this machine: no dotfiles paths, palette colors rather than Eldritch hex,
and the Nerd Font glyphs written as escaped bytes in `picker.sh` (editors and
tools have dropped them as literal characters).

`~/.config/rex/wayfinder` is a stow-folded symlink into the repo; nothing
writes there.

### Sketchybar: Eldritch pills on a transparent bar

Items sit in floating pills (brackets); most open a popup on click. The
palette, font and shared pill/popup styles live in `theme.sh`, sourced by
`sketchybarrc` and the plugins — restyle there, not per item. Nerd Font
glyphs in scripts are written as escaped bytes (`printf '\357\211\200'`),
since tools drop them as literal characters.

- **agents**: coding agents in Rex tabs, from the OSC 7501 status Rex keeps
  per pane. The popup groups them by session and follows Wayfinder's rules
  (tiled panes, most urgent pane wins, unnamed tabs show their title) —
  change one, check the other. Clicking a tab jumps to it with the same
  `rex do session.select` Wayfinder uses (`plugins/rex_jump.sh`).
  `plugins/rex_watch.sh` is a long-running `rex events` listener, so updates
  are pushed, not polled. `rex` isn't on sketchybar's PATH, so
  `plugins/rex_cmd.sh` points into the Rex app bundle, always with
  `--autostart=false`: the bar must never start a Rex server. Without Rex
  the item stays hidden.
- **codex**: 5h and weekly plan use, from the newest
  `~/.codex/sessions/**/rollout-*.jsonl` that recorded `rate_limits`. Codex
  doesn't log them every turn, so the value can lag a little. There's no
  Claude equivalent: on this machine Claude Code bills by usage, so there are
  no windows to show.
- **calendar**, folded into the clock: while an event is on or starts within
  15 minutes, `clock.event` replaces the date; clicking the clock lists the
  rest of today, and a row opens its meeting link (Zoom, Meet, Teams, Webex)
  or the event. Reads Calendar.app, so only calendars added there show.
  `helper/events.swift` reads EventKit; `plugins/calendar.sh` compiles it on
  first use (and whenever it changes) into `~/.cache/sketchybar/events`, with
  `helper/Info.plist` embedded — macOS won't ask for Calendar access without
  its usage description. Needs `swiftc` (Xcode Command Line Tools, which
  Homebrew already requires). To preview without real events,
  `touch ~/.cache/sketchybar/calendar.demo`; delete it to go back.
- **cat**: a calico left of the notch (position `q`), animated faster with
  CPU load by `plugins/cat.sh`, a second background loop beside
  `rex_watch.sh`. The sprite is ASCII in `plugins/cat_frames.py`, drawn into
  `~/.cache/sketchybar/cat/` and redrawn whenever that file changes.
- **battery / volume**: Low Power Mode (`pmset powermode`, so macOS asks for
  your password on each toggle); a volume slider and mute.
- **recover** (invisible): reloads on display changes, and after wake
  restarts sketchybar via launchd if its windows went missing. Logs to
  `~/.cache/sketchybar/recover.log`.

The background loops and the compiled helper live outside the repo
(`~/.cache/sketchybar/`), so nothing the bar writes lands here.

### Claude slash commands are split public/local

`~/.claude/commands/` holds both tracked and local-only commands:

- Tracked in `config/claude/.claude/commands/` and symlinked out: `verify`,
  `scoped-pr`, `pr-review`, `save-plan`, `research-html`.
- Real files that live only in `~/.claude/commands/`: the work-specific ones
  that name internal repos or services. Gitignored as a backstop.

The directory must exist before stowing. Stow folds a subdirectory into a
single symlink only when the target doesn't exist, so `mkdir -p
~/.claude/commands` is enough — an existing directory gets its files linked
individually. If it ever folds, anything Claude Code writes there lands
inside this repo.

Skills work the same way: `config/claude/.claude/skills/explain-diff-html/` is
symlinked into the real `~/.claude/skills/`, beside the installed Plannotator
skills. It's a pinned copy of
[Geoffrey Litt's gist](https://gist.github.com/geoffreylitt/a29df1b5f9865506e8952488eac3d524),
tracked so a fresh laptop gets it, since nothing installs it.

`skills/explain-diff-visual/` is ours: `explain-diff-html`'s depth and quiz,
drawn the way `plannotator-visual-explainer` draws non-plan visuals —
`visual-explainer`'s kit and renderer, themed with Plannotator's
`theme-override.md` (both installed, section 1.3, and read at run time). It
writes to `~/.agent/diagrams/` and opens the page with `plannotator annotate`.
`explain-diff-html` stays until the new one has proven itself.

`skills/new-project/` holds the default side-project stack (Bun, Hono, Zod,
Drizzle, SQLite via Shibumi Stack) and how it should evolve. Its Codex twin
lives in `config/codex/plugins/cthulhu-workflows/skills/new-project/` — when a
decision changes, update both.

The Codex equivalents under `config/codex/` are **separate, diverged files**,
not copies. Changing a workflow means updating both if you want parity.

## 3. What this file does NOT cover

- macOS system preferences (Dock, keyboard repeat, trackpad) — set manually.
- App logins (1Password, Slack, browsers, Cursor, Raycast extensions).
- SSH and GPG keys — restore from secure backup.
- Claude Code MCP servers (`~/.claude.json`) and installed plugins and
  marketplaces — not captured anywhere; re-add by hand.
- Accessibility / Input Monitoring permissions — granted on first launch
  of Karabiner, Aerospace, Sketchybar.
