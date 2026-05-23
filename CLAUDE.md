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
stow -d config -t ~ $(command ls config)
stow -d . -t ~ git-commands
```

`command ls` bypasses the `eza` alias defined in `.zshrc`. Stowing everything
under `config/` is intentional — see section 2.

### 1.4 Restore local overrides (manual, per machine)

These files are gitignored and must be restored from your previous laptop,
password manager, or 1Password:

- `~/.zshrc.local` — work env vars, tokens. Sourced by the stowed `~/.zshrc`.
- `~/dotfiles/Brewfile.local` — work-specific casks and taps.

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

### Claude statusline

`config/claude/.claude/statusline.sh` is a bash + jq script, stowed to
`~/.claude/statusline.sh`. `settings.json` references it via `~/.claude/…`,
with no absolute path and no external runtime dependency beyond `jq`
(already in Brewfile). To change what the statusline shows, edit the
script — not `settings.json`.

### Submodules

- `git-commands/.git-commands` → `FunnyGhost/git-commands`

### After-stow gotcha for `~/.claude/`

`~/.claude/` is a real directory (Claude Code owns it), not a stow-folded
symlink. Files inside are symlinked individually. **Adding a new file
under `config/claude/.claude/` requires `stow -d config -t ~ --restow claude`**
for the new symlink to appear in `~/.claude/`.

## 3. What this file does NOT cover

- macOS system preferences (Dock, keyboard repeat, trackpad) — set manually.
- App logins (1Password, Slack, browsers, Cursor, Raycast extensions).
- SSH and GPG keys — restore from secure backup.
- Accessibility / Input Monitoring permissions — granted on first launch
  of Karabiner, Aerospace, Sketchybar.
