# 🏠 Cthulhu's Dotfiles

A macOS development environment configuration, managed with [GNU Stow](https://www.gnu.org/software/stow/). Everything under `config/` is stowed into `~`. Work secrets and machine-specific overrides live in gitignored `*.local` files.

## 🚀 Setup on a new Mac

```bash
# 1. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# 2. Install Claude Code and clone this repo
brew install --cask claude-code
git clone https://github.com/FunnyGhost/dotfiles.git ~/dotfiles

# 3. From inside the repo, launch Claude Code and follow the operating manual
cd ~/dotfiles
claude
```

Then ask Claude to follow `CLAUDE.md`. That file contains the rest of the runbook (submodules, brew bundle, stow, local overrides, verification).

If you'd rather do it by hand without Claude, just open [CLAUDE.md](CLAUDE.md) and run the commands in section 1 yourself.

## 📦 What's included

- **Editors / dev tools**: Neovim (Lazy.nvim), Git, Claude Code, 21 custom git commands (submodule), `wwid` (find & resume Claude Code chats from anywhere — see `config/wwid`)
- **Terminal / shell**: Zsh, Starship, Ghostty, WezTerm, Kitty, plus `bat`, `eza`, `fzf`, `zoxide`
- **Window management**: Aerospace, JankyBorders, Karabiner Elements. Yabai, skhd, Sketchybar configs are kept around but not active.
- **Packages**: ~194 brews, casks, fonts, and VS Code extensions managed via `Brewfile`

## 🎨 Included Fonts

All installed via Brewfile. Set your terminal's font in its GUI preferences.

### **Hack Nerd Font** ⭐ *Recommended*
- [Font Specimen](https://github.com/source-foundry/Hack) · [Nerd Font Version](https://www.nerdfonts.com/font-downloads)
- Clean monospace designed for source code. Best general-purpose choice.

### **CaskaydiaCove Nerd Font**
- [Specimen](https://github.com/microsoft/cascadia-code) · [Releases](https://github.com/microsoft/cascadia-code/releases)
- Microsoft's Cascadia Code with ligatures and Nerd Font icons.

### **Mononoki Nerd Font**
- [Specimen](https://madmalik.github.io/mononoki/) · [GitHub](https://github.com/madmalik/mononoki)
- Warm, friendly monospace for long sessions.

### **Anonymice Nerd Font**
- [Specimen](https://fonts.google.com/specimen/Anonymous+Pro) · [Original](https://www.marksimonson.com/fonts/view/anonymous-pro)
- Based on Anonymous Pro. Sharp at small sizes.

### **Cascadia Code** (no Nerd Font patches)
- [Specimen](https://github.com/microsoft/cascadia-code)
- Original Microsoft font, ligatures only.

### **Monaspace**
- [Specimen](https://monaspace.githubnext.com/) · [GitHub](https://github.com/githubnext/monaspace)
- GitHub's superfamily with 5 styles (Neon, Argon, Xenon, Radon, Krypton).

### **Mononoki** (no Nerd Font patches)
- [Specimen](https://madmalik.github.io/mononoki/) · [GitHub](https://github.com/madmalik/mononoki)
- Original without icon patches.

## 🔧 Custom Git Commands

Added to PATH via the stowed `~/.git-commands` directory. Sourced from the [git-commands](https://github.com/FunnyGhost/git-commands) submodule.

### Core workflow
- **`git co`** — interactive branch checkout with fzf + preview
- **`git author-stats`** — analyze author contributions
- **`git delete-merged-branches`** — delete all branches merged into master
- **`git remaster`** — fetch latest master and rebase current branch on top
- **`git review`** — interactive commit review with diff preview

### Search & discovery
- **`git dig`** — search for commits containing strings in changesets
- **`git find`** — find files containing search strings in any order
- **`git grep-rank`** — rank authors of files containing a string
- **`git rank`** — author ranking by commits + extra stats

### Branch & stash
- **`git repush`** — delete remote branch then push again (works around `-f` restrictions)
- **`git snapshot`** — create a named stash with optional note
- **`git stash-merge`** — merge stashes over dirty trees
- **`git list-autostash`** — list auto-stash entries

### Repo maintenance
- **`git shower`** — GC + prune, optimized for large repos
- **`git size`** — bytes introduced/removed by a commit
- **`git sort`** — sort SHA1 hashes by their ordering in history

### File ops
- **`git open`** — open all changed files in `$EDITOR`

## 🪟 Aerospace Keybindings

Tiling window manager configured under `config/aerospace`. Key bindings:

### Focus & movement
- `alt + h/j/k/l` — focus left/down/up/right
- `alt + shift + h/j/k/l` — move window left/down/up/right

### Layouts
- `alt + e` — tile (horizontal/vertical)
- `alt + ,` — accordion
- `alt + f` — fullscreen toggle
- `alt + y` — join with window below

### Workspaces
- `alt + 1-5` — switch to workspace 1-5
- `alt + shift + 1-5` — move window to workspace 1-5
- `alt + tab` — switch between last two workspaces
- `alt + shift + tab` — move workspace to next monitor

### Quick app launch
- `alt + b` Brave · `alt + c` Cursor · `alt + g` Ghostty · `alt + w` WezTerm · `alt + s` Slack · `alt + m` Mail

### Service mode (`alt + shift + ;`)
- `r` reset layout · `f` toggle floating/tiling · `backspace` close all but current · `esc` reload + exit

### Monitor layout
Workspaces 1-5 on main monitor, 6-7 on secondary. Mouse follows focus across monitors.

## 📝 License

MIT — see [LICENSE](LICENSE).

## 🤝 Contributing

Fork freely. PRs welcome.

---

> *"The best dotfiles are the ones you actually use daily"*
