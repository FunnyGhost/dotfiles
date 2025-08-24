# 🏠 Cthulhu's Dotfiles

A comprehensive macOS development environment configuration using [GNU Stow](https://www.gnu.org/software/stow/) for symlink management.

## 🎯 What's This For?

This repository contains my personal development environment setup that I use daily for software development on macOS. It's designed to:

- **Quickly set up a new machine** with all your favorite tools and configurations
- **Keep configurations in sync** across multiple machines
- **Version control your dotfiles** with proper organization
- **Easy maintenance** with simple stow commands

## 📦 What's Included

### 🛠️ **Development Tools & Editors**
- **Neovim** - Modern Vim-based editor with Lazy.nvim plugin manager
- **Git** - Version control with custom configuration
- **21 Custom Git Commands** - Enhanced git workflow (via submodule)

### 🖥️ **Terminal & Shell**
- **Zsh** - Modern shell configuration
- **Starship** - Cross-shell prompt with custom theming
- **Multiple Terminal Emulators**: Ghostty, WezTerm, Kitty
- **Enhanced CLI Tools**: bat, eza, fzf, zoxide integration

### 🎨 **System & Window Management**
- **Window Management Configs** - Aerospace, yabai, skhd (legacy)
- **JankyBorders** - Beautiful window borders with Eldritch theme colors
- **Karabiner Elements** - Keyboard customization
- **SketchyBar** - Custom status bar (legacy)
- **Bat** - Syntax highlighting with custom themes

### 📋 **Package Management**
- **Homebrew Brewfile** - Manages 194+ packages, apps, fonts, and VS Code extensions
  - Development tools (Node.js, Python, Go, Docker)
  - Productivity apps (Raycast, Cursor, CleanShot)
  - 7 Beautiful fonts including Nerd Fonts for terminal icons
  - VS Code extensions (28 curated extensions)

### 🎨 **Included Fonts**
Perfect for terminals and coding with full icon support:

#### **Hack Nerd Font** ⭐ *Recommended*
- **[📖 View Font Specimen](https://github.com/source-foundry/Hack)** | **[🔗 Nerd Font Version](https://www.nerdfonts.com/font-downloads)**
- Clean, readable monospace designed specifically for source code
- **Best for:** General coding, excellent readability at all sizes
- **Features:** Full Nerd Font icon set, optimized letter spacing

#### **CaskaydiaCove Nerd Font**  
- **[📖 View Font Specimen](https://github.com/microsoft/cascadia-code)** | **[🔗 Download Page](https://github.com/microsoft/cascadia-code/releases)**
- Microsoft's Cascadia Code enhanced with programming ligatures and Nerd Font icons
- **Best for:** Modern development, TypeScript/JavaScript, C#
- **Features:** Beautiful ligatures (!=, =>, <=), cursive italics

#### **Mononoki Nerd Font**
- **[📖 View Font Specimen](https://madmalik.github.io/mononoki/)** | **[🔗 GitHub](https://github.com/madmalik/mononoki)**
- Warm, friendly monospace perfect for long coding sessions
- **Best for:** Comfortable extended coding, reduced eye strain
- **Features:** Rounded characters, excellent readability

#### **Anonymice Nerd Font**
- **[📖 View Font Specimen](https://fonts.google.com/specimen/Anonymous+Pro)** | **[🔗 Original](https://www.marksimonson.com/fonts/view/anonymous-pro)**
- Based on Anonymous Pro - excellent clarity at smaller sizes
- **Best for:** Terminal work, shell scripting, system administration
- **Features:** Sharp, clean letterforms, great for small text

#### **Cascadia Code** (Original)
- **[📖 View Font Specimen](https://github.com/microsoft/cascadia-code)** | **[🔗 Microsoft Docs](https://docs.microsoft.com/en-us/windows/terminal/cascadia-code)**
- Microsoft's flagship coding font with programming ligatures
- **Best for:** Windows development, PowerShell, modern editors
- **Features:** Programming ligatures, cursive italics, multiple weights

#### **Monaspace**
- **[📖 View Font Specimen](https://monaspace.githubnext.com/)** | **[🔗 GitHub](https://github.com/githubnext/monaspace)**
- GitHub's revolutionary font superfamily with 5 distinct styles
- **Variants:** Neon, Argon, Xenon, Radon, Krypton
- **Best for:** Syntax highlighting diversity, modern development
- **Features:** Texture healing, multiple widths, advanced typography

#### **Mononoki** (Original)
- **[📖 View Font Specimen](https://madmalik.github.io/mononoki/)** | **[🔗 GitHub](https://github.com/madmalik/mononoki)**
- The original version without Nerd Font patches
- **Best for:** Minimalist setups, when you don't need icons
- **Features:** Clean design, warm appearance, good contrast

### 💎 **Why These Fonts Are Perfect for Development**

**🔗 Programming Ligatures** (Cascadia Code, CaskaydiaCove):
- Combines character sequences like `!=`, `<=`, `>=`, `=>`, `->` into single symbols
- Makes code more readable and aesthetically pleasing
- **[See Ligatures in Action](https://github.com/microsoft/cascadia-code#programming-ligatures)**

**🎨 Nerd Font Icons** (All Nerd Font variants):
- 3,600+ icons for file types, folders, git status, and development tools
- Shows file extensions as icons in terminal file listings
- Git branch/status symbols in your prompt
- **[Browse All Icons](https://www.nerdfonts.com/cheat-sheet)**

**⚡ Terminal Optimization**:
- All fonts tested for readability at 12-14pt sizes
- Excellent character distinction (0 vs O, 1 vs l vs I)
- Proper spacing for tabular data and code alignment
- UTF-8 and emoji support for modern development

**🎯 Installation Tip:**
Try **Hack Nerd Font** first - it offers the best balance of readability, icon support, and general compatibility. You can always switch later!

## 🚀 Quick Start

### Prerequisites

Before starting, ensure you have:

1. **macOS** (tested on recent versions)
2. **Command Line Tools** installed:
   ```bash
   xcode-select --install
   ```

### Step 1: Clone This Repository

```bash
# Clone to your home directory
cd ~
git clone https://github.com/FunnyGhost/dotfiles.git
cd dotfiles
```

**What this does:** Downloads all the configuration files to `~/dotfiles`

### Step 2: Initialize Git Submodules

```bash
git submodule update --init --recursive
```

**What this does:** Downloads the git-commands repository that contains 21 custom git commands for enhanced workflows

### Step 3: Install Homebrew & Packages

```bash
# Install Homebrew if you don't have it
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install all packages (this will take a while!)
brew bundle install
```

**What this does:** 
- Installs Homebrew package manager if needed
- Installs 194+ packages including development tools, applications, fonts, and VS Code extensions
- Sets up tools like stow, git, neovim, starship, and many others

### Step 4: Install Configurations with Stow

Stow creates symbolic links from your home directory to the configuration files in this repo.

```bash
# Install all main configurations
stow -d config -t ~ aerospace bat borders ghostty git karabiner kitty lazygit nvim sketchybar skhd starship wezterm yabai zsh

# Install git commands
stow -d . -t ~ git-commands
```

**What this does:**
- **Creates symlinks** like `~/.config/nvim → ~/dotfiles/config/nvim/.config/nvim`
- **Links git config** `~/.gitconfig → ~/dotfiles/config/git/.gitconfig`
- **Links shell config** `~/.zshrc → ~/dotfiles/config/zsh/.zshrc`
- **Links git commands** `~/.git-commands → ~/dotfiles/git-commands/.git-commands`
- All changes you make to configs are automatically tracked in the git repo

### Step 5: Configure Terminal Font (Important!)

The terminal setup requires Nerd Fonts for icons to display properly:

```bash
# Fonts are already installed via Brewfile, but you need to:
# 1. Open your terminal app (Ghostty, WezTerm, Kitty, etc.)
# 2. Go to Settings/Preferences → Font
# 3. Choose one of these installed fonts:
#    • "Hack Nerd Font" (recommended)
#    • "CaskaydiaCove Nerd Font" 
#    • "Mononoki Nerd Font"
#    • "Anonymice Nerd Font"
# 4. Enable font ligatures if available
# 5. Set font size to 12-14pt for optimal readability
```

**What this does:** Ensures icons and symbols in your terminal prompt display correctly

### Step 6: Restart Your Shell

```bash
# Start a new terminal session or run:
exec zsh
```

**What this does:** Loads your new shell configuration with Starship prompt and all customizations

## 🎨 What You'll Get

After setup, you'll have:

### ✨ **Beautiful Terminal**
- **Starship prompt** showing git status, directory, and more
- **Enhanced commands**: `ls` becomes `eza` with icons, `cd` becomes `zoxide` smart navigation
- **Fuzzy finding**: `fzf` integration for file/directory search
- **Syntax highlighting**: `bat` for file viewing with themes

### 🔧 **Enhanced Git Workflow**

#### LazyGit Integration
- **Terminal UI** for Git operations with custom configuration
- **Disabled auto-fetch** for better performance in large repos
- **Keyboard-driven interface** with intuitive shortcuts
- **Full integration** with Neovim via `<leader>lg`

#### Custom Git Commands
- **21 custom git commands** for enhanced productivity:

#### Core Workflow Commands
- **`git co`** - Interactive branch checkout with fzf fuzzy finder and preview
- **`git author-stats`** - Analyze author contributions (lines added/removed/modified)
- **`git delete-merged-branches`** - Delete all branches merged into master
- **`git remaster`** - Fetch latest master and rebase current branch on top
- **`git review`** - Interactive commit review with diff preview

#### Search & Discovery
- **`git dig`** - Search for commits containing specific strings in changesets
- **`git find`** - Find files containing search strings in any order
- **`git grep-rank`** - Show authors of files containing string, ranked by frequency
- **`git rank`** - Display author ranking by commits + extra stats

#### Branch & Stash Management
- **`git repush`** - Delete remote branch then push again (works around `-f` restrictions)
- **`git snapshot`** - Create named stash with optional note (safety checkpoints)
- **`git stash-merge`** - Merge stashes even over dirty trees
- **`git list-autostash`** - List auto-stash entries

#### Repository Maintenance
- **`git shower`** - Run GC + prune (optimized for large repositories)
- **`git size`** - Show bytes introduced/removed by specific commit
- **`git sort`** - Sort SHA1 hashes by their ordering in history

#### File Operations
- **`git open`** - Open all changed files in `$EDITOR` according to `git status`

### ⚙️ **Development Environment**
- **Neovim** configured with modern plugins
- **Multiple terminal options** ready to use
- **Git configuration** optimized for development

## 🛠️ Usage

### Managing Configurations

```bash
# Install a specific config
stow -d config -t ~ nvim

# Remove a config (unstow)
stow -d config -t ~ -D nvim

# Reinstall all configs
stow -d config -t ~ --restow aerospace bat borders ghostty git karabiner kitty lazygit nvim sketchybar skhd starship wezterm yabai zsh
```

### Updating Git Commands

```bash
cd ~/dotfiles/git-commands/.git-commands
git pull origin master
```

### Adding New Configurations

1. Create directory: `config/newtool/.config/newtool/`
2. Add your config files inside
3. Run: `stow -d config -t ~ newtool`

## 🚨 Important Notes

### 🔒 Work & Private Configuration
This repository uses a **local override pattern** to securely handle work-specific and private configurations without exposing secrets in version control.

#### **Shell Configuration & Secrets**
The `.zshrc` automatically sources work-specific configuration:

**config/zsh/.zshrc.local** (automatically loaded):
```bash
# Work-specific secrets and configuration
# This file should not be committed to version control

export COMPANY_USERNAME=your-username
export COMPANY_API_TOKEN=your-secret-token
export DATABASE_URL="postgresql://user:pass@host:5432/db"

# Package manager credentials (if needed)
export HOMEBREW_COMPANY_USER=${COMPANY_USERNAME}
export HOMEBREW_COMPANY_TOKEN=${COMPANY_API_TOKEN}

# Add any other work-specific environment variables here
export AWS_PROFILE="work"
export DOCKER_REGISTRY="company.registry.com"
```

**How it works:**
- Main `.zshrc` contains this line: `[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local`
- If the local file exists, it's automatically loaded
- If it doesn't exist, no error occurs
- All secrets stay out of version control

#### **Package Management & Work Tools** 
The Brewfile system supports work-specific packages:

**Brewfile.local** (work packages):
```bash
# Work-specific Homebrew packages
# This file should not be committed to version control

# Work-specific taps (private repositories)
tap "company/internal-tools"
tap "organization/private-tap", "git@github.com:organization/homebrew-private.git"

# Work-specific tools and applications
brew "company/cli-tool"
brew "organization/development-utils"
cask "company-vpn"
cask "internal-app"
```

**Automated Management:**
The `bbd` alias now handles both files automatically:
```bash
# Updates both Brewfiles safely
bbd  # This runs: brew bundle dump for main + local files

# Manual installation (if needed)
brew bundle install                        # Public packages
brew bundle install --file=Brewfile.local  # Work packages (if file exists)
```

**Safety Features:**
- Both `.zshrc.local` and `Brewfile.local` are **gitignored**
- Commands use conditional logic: `[[ -f Brewfile.local ]] && ...`
- No errors if local files don't exist
- Secrets never accidentally committed

### Window Management
This repo contains configurations for multiple window managers (Aerospace, yabai). The current recommendation is to use **Raycast** for window management, which provides a great UI for configuration.

### Customization
All configurations are designed to be customizable:
- **Starship prompt**: Edit `config/starship/.config/starship/starship.toml`
- **Shell aliases**: Edit `config/zsh/.zshrc`
- **Git settings**: Edit `config/git/.gitconfig`
- **Neovim**: See `config/nvim/.config/nvim/`

## 🔧 Troubleshooting

### Symlink Conflicts
If stow reports conflicts:
```bash
# Remove existing config and re-stow
rm ~/.config/problematic-config
stow -d config -t ~ problematic-config
```

### Missing Icons in Terminal
- Ensure you've selected one of the installed Nerd Fonts:
  - "Hack Nerd Font" (recommended)
  - "CaskaydiaCove Nerd Font"
  - "Mononoki Nerd Font" 
  - "Anonymice Nerd Font"
- Enable font ligatures in terminal settings
- Restart your terminal after font changes

### Git Commands Not Working
- Ensure `~/.git-commands` is in your PATH (should be automatic)
- Check: `echo $PATH | grep git-commands`

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Feel free to fork this repository and adapt it for your own use! If you find improvements or fixes, pull requests are welcome.

---

**Happy coding!** 🚀

> *"The best dotfiles are the ones you actually use daily"*
