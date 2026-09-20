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
brew bundle install
[[ -f Brewfile.local ]] && brew bundle install --file=Brewfile.local
```

### 1.3 Stow every config

```bash
mkdir -p ~/.config/herdr
stow -d config -t ~ $(command ls config)
stow -d . -t ~ git-commands
```

`command ls` bypasses the `eza` alias defined in `.zshrc`. Stowing everything
under `config/` is intentional — see section 2. The `mkdir` prevents stow from
folding `~/.config/herdr` into a symlink — herdr writes runtime files (socket,
logs) next to its config, and those must not land in the repo (see section 2).

### 1.4 Restore local overrides (manual, per machine)

These files are gitignored and must be restored from your previous laptop,
password manager, or 1Password:

- `~/.zshrc.local` — work env vars, tokens, and work-only shell helpers
  (anything naming internal repos or tooling). Sourced by the stowed `~/.zshrc`.
- `~/dotfiles/Brewfile.local` — work-specific casks and taps.
- `Raycast-<date>.rayconfig` — Raycast settings. Restore via Raycast's
  **Import Settings & Data**.

If absent, shell startup tolerates it. Brewfile.local is also tolerated by
step 1.2 (the `[[ -f ... ]]` guard).

### 1.5 Terminal font

Set your terminal app's font to **Hack Nerd Font**, 12–14pt. The font is
installed by `brew bundle`, but each terminal stores its font preference
in its own GUI settings (Ghostty, WezTerm, Kitty).

### 1.6 Restart shell

```bash
exec zsh
```

### 1.7 Verification

```bash
command -v stow nvim starship gh fzf eza zoxide bat jq    # all resolve
readlink ~/.zshrc ~/.gitconfig ~/.claude/CLAUDE.md         # all point into ~/dotfiles
git -C ~/dotfiles status                                   # clean (or only *.local untracked)
git -C ~/dotfiles submodule status                         # git-commands populated
echo '{}' | ~/.claude/statusline.sh                        # prints a status line
```

If any check fails, fix it before declaring the laptop ready.

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
Keep it in 1Password.

### Claude statusline

`config/claude/.claude/statusline.sh` is a bash + jq script, stowed to
`~/.claude/statusline.sh`. `settings.json` references it via `~/.claude/…`,
with no absolute path and no external runtime dependency beyond `jq`
(already in Brewfile). To change what the statusline shows, edit the
script — not `settings.json`.

### Submodules

- `git-commands/.git-commands` → `FunnyGhost/git-commands`

### herdr runtime files live next to its config

`~/.config/herdr/` must stay a **real directory** with only `config.toml`
symlinked into the repo (that's what the `mkdir -p` in section 1.3 ensures).
The herdr server writes its socket and logs into that same directory; if stow
folds it into a symlink, those runtime files land inside the repo. A
`.gitignore` backstop covers `*.sock` / `*.log` under `config/herdr/` in case
that ever happens.

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

- `~/.agents/plugins` is a stow-**folded** symlink into this repo, so anything
  Codex writes there (lock files, plugin state) lands inside the repo. A
  `.gitignore` backstop covers the known cases.
- Work-specific skills that name internal repos or services are gitignored,
  not committed — this repo is public. They still stow and load normally;
  they just never reach GitHub. Keep new work-specific skills out the same way.

### After-stow gotcha for `~/.claude/`

`~/.claude/` is a real directory (Claude Code owns it), not a stow-folded
symlink. Files inside are symlinked individually. **Adding a new file
under `config/claude/.claude/` requires `stow -d config -t ~ --restow claude`**
for the new symlink to appear in `~/.claude/`.

herdr's Claude integration (hook script + `SessionStart` entry in
`settings.json`) is tracked and stowed — don't rerun
`herdr integration install claude`; it rewrites `settings.json` with absolute
paths and reordered keys.

### Claude slash commands are split public/local

`~/.claude/commands/` holds both tracked and local-only commands:

- Tracked in `config/claude/.claude/commands/` and symlinked out: `verify`,
  `scoped-pr`, `pr-review`, `save-plan`, `research-html`.
- Real files that live only in `~/.claude/commands/`: the work-specific ones
  that name internal repos or services. Gitignored as a backstop.

Keep at least one local-only real file in that directory. It's what stops stow
from folding `~/.claude/commands` into a symlink into this repo — if it folds,
anything Claude Code writes there lands inside the repo.

The Codex equivalents under `config/codex/` are **separate, diverged files**,
not copies. Changing a workflow means updating both if you want parity.

## 3. What this file does NOT cover

- macOS system preferences (Dock, keyboard repeat, trackpad) — set manually.
- App logins (1Password, Slack, browsers, Cursor, Raycast extensions).
- SSH and GPG keys — restore from secure backup.
- Accessibility / Input Monitoring permissions — granted on first launch
  of Karabiner, Aerospace, Sketchybar.
