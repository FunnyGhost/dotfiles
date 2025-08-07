# 🚀 Modern Neovim Configuration

A highly optimized, feature-rich Neovim configuration built for modern development workflows. This setup provides intelligent code completion, advanced syntax highlighting, git integration, file management, and comprehensive development tools.

## ✨ Features

- **🧠 Intelligent LSP Integration** - Language servers for TypeScript, JavaScript, Lua, HTML, CSS, and more
- **🔍 Powerful Fuzzy Finding** - Telescope for files, text, symbols, and project-wide search
- **📁 Multiple File Managers** - Neo-tree sidebar and Oil.nvim buffer-based editing
- **🎨 Modern UI** - Beautiful Eldritch theme with enhanced visual elements
- **🔄 Comprehensive Git Integration** - Visual git signs, lazygit, and hunk management
- **⚡ Smart Autocompletion** - nvim-cmp with multiple sources and snippet support
- **🔧 Code Quality Tools** - Formatting (Prettier/Stylua) and linting (ESLint)
- **🤖 AI Integration** - GitHub Copilot for intelligent code suggestions
- **🖼️ Image Support** - Display images in terminal (Kitty backend)
- **📝 Rich Text Editing** - Surround operations, smart commenting, and text objects

## 📦 Plugin Overview

### Core Language Support
- **`nvim-lspconfig`** - Language Server Protocol integration
- **`mason.nvim`** - LSP server, formatter, and linter installer
- **`nvim-treesitter`** - Advanced syntax highlighting and code understanding
- **`nvim-cmp`** - Intelligent autocompletion engine
- **`LuaSnip`** - Powerful snippet engine with VSCode-style snippets

### File Management & Navigation
- **`telescope.nvim`** - Fuzzy finder for files, text, symbols, and more
- **`neo-tree.nvim`** - Traditional sidebar file explorer
- **`oil.nvim`** - Edit directories like buffers
- **`nvim-web-devicons`** - File type icons throughout the interface

### Git Integration
- **`gitsigns.nvim`** - Git status indicators and hunk operations
- **`lazygit.nvim`** - Beautiful terminal git interface

### Code Quality & Formatting
- **`conform.nvim`** - Code formatting with Prettier and Stylua
- **`nvim-lint`** - Real-time linting with ESLint
- **`todo-comments.nvim`** - Highlight and search TODO/FIXME comments

### Productivity & Utilities
- **`snacks.nvim`** - Comprehensive utility collection (zen mode, terminal, notifications)
- **`which-key.nvim`** - Keybinding hints and discovery
- **`trouble.nvim`** - Diagnostics and error management UI
- **`undotree`** - Visual undo history browser

### Text Editing Enhancements
- **`nvim-surround`** - Add/delete/change surrounding characters
- **`Comment.nvim`** - Smart commenting with treesitter integration
- **`substitute.nvim`** - Enhanced text replacement operations
- **`vim-tmux-navigator`** - Seamless navigation between vim and tmux panes

### AI & Testing
- **`copilot.vim`** - GitHub Copilot AI code completion
- **`vim-test`** - Universal test runner for multiple frameworks

### UI & Visual Enhancements
- **`eldritch-nvim`** - Modern dark theme
- **`dressing.nvim`** - Enhanced UI for input/select dialogs
- **`fidget.nvim`** - LSP progress notifications
- **`image.nvim`** - Display images in terminal

## ⌨️ Key Bindings

### Leader Key
- **Leader**: `<Space>`

### File Operations
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>ff` | Find Files | Search files by name |
| `<leader>fg` | Find Grep | Search text content across files |
| `<leader>fs` | Find Symbol | Search for word under cursor |
| `<leader>fr` | Find Recent | Recently opened files |
| `<leader><space>` | Buffers | Switch between open buffers |
| `<C-n>` | Toggle Neo-tree | Open/close file explorer |
| `-` | Open Oil | Edit parent directory as buffer |

### LSP & Code Navigation
| Key | Action | Description |
|-----|--------|-------------|
| `gd` | Go to Definition | Jump to symbol definition |
| `gD` | Go to Declaration | Jump to symbol declaration |
| `gR` | Go to References | Show all references |
| `gi` | Go to Implementation | Jump to implementation |
| `gt` | Go to Type Definition | Jump to type definition |
| `K` | Hover Documentation | Show documentation for symbol |
| `<C-k>` | Signature Help | Show function signature |
| `<leader>ca` | Code Actions | Show available code actions |
| `<leader>rn` | Rename | Smart rename symbol |
| `<leader>d` | Line Diagnostics | Show diagnostics for current line |
| `<leader>D` | Buffer Diagnostics | Show all buffer diagnostics |
| `[d` / `]d` | Previous/Next Diagnostic | Navigate diagnostics |
| `<leader>ds` | Document Symbols | Browse file symbols |

### Git Operations
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>lg` | LazyGit | Open LazyGit interface |
| `<leader>gp` | Git Preview | Preview git hunk |
| `<leader>gb` | Git Blame | Show git blame for line |
| `<leader>gB` | Git Browse | Open in GitHub |
| `<leader>hs` | Hunk Stage | Stage git hunk |
| `<leader>hr` | Hunk Reset | Reset git hunk |
| `<leader>hp` | Hunk Preview | Preview git hunk |
| `<leader>hb` | Hunk Blame | Detailed blame for line |
| `]h` / `[h` | Next/Previous Hunk | Navigate git hunks |

### Code Quality
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>gf` | Format | Format file/selection |
| `<leader>l` | Lint | Trigger linting |

### Diagnostics & Trouble
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>xx` | Toggle Trouble | Open/close diagnostics panel |
| `<leader>xw` | Workspace Diagnostics | Show workspace diagnostics |
| `<leader>xd` | Document Diagnostics | Show document diagnostics |
| `<leader>xt` | TODO Trouble | Show TODO comments |

### Utilities & Productivity
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>z` | Zen Mode | Toggle distraction-free mode |
| `<leader>.` | Scratch Buffer | Open scratch buffer |
| `<leader>u` | Undo Tree | Visual undo history |
| `<leader>n` | Notifications | Show notification history |
| `<leader>un` | Dismiss Notifications | Hide all notifications |
| `<C-/>` | Terminal | Toggle floating terminal |
| `<leader>cp` | Copy Path | Copy file path to clipboard |
| `<leader>nh` | No Highlight | Clear search highlighting |

### Text Editing
| Key | Action | Description |
|-----|--------|-------------|
| `gcc` | Comment Line | Toggle line comment |
| `gc` | Comment Motion | Comment with motion |
| `s` | Substitute | Substitute with motion |
| `ss` | Substitute Line | Substitute entire line |
| `]]` / `[[` | Next/Previous Reference | Navigate word references |

### Testing
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>t` | Run Test | Run nearest test |
| `<leader>T` | Test File | Run all tests in file |
| `<leader>a` | All Tests | Run entire test suite |
| `<leader>l` | Last Test | Re-run last test |

### TODO Comments
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>ft` | Find TODOs | Search TODO comments |
| `]t` / `[t` | Next/Previous TODO | Navigate TODO comments |

### Scrolling & Navigation
| Key | Action | Description |
|-----|--------|-------------|
| `<C-d>` | Scroll Down | Scroll down (centered) |
| `<C-u>` | Scroll Up | Scroll up (centered) |
| `<C-h/j/k/l>` | Navigate Panes | Navigate vim/tmux panes |

### Toggle Options (Snacks)
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>us` | Toggle Spelling | Enable/disable spell check |
| `<leader>uw` | Toggle Wrap | Enable/disable line wrap |
| `<leader>uL` | Toggle Relative Numbers | Toggle relative line numbers |
| `<leader>ud` | Toggle Diagnostics | Enable/disable diagnostics |
| `<leader>uh` | Toggle Inlay Hints | Show/hide LSP inlay hints |

## 🛠️ Installation

### Prerequisites
- **Neovim 0.9+** - Latest stable version recommended
- **Git** - For plugin management
- **Node.js** - For LSP servers and formatters
- **A Nerd Font** - For icons (recommended: FiraCode Nerd Font)
- **Ripgrep** - For telescope live_grep functionality
- **Kitty Terminal** - For image display support (optional)

### Required Tools
These will be auto-installed by Mason, but you can install them manually:
```bash
# Language Servers
npm install -g typescript-language-server
npm install -g vscode-langservers-extracted  # HTML, CSS, JSON
npm install -g emmet-ls

# Formatters and Linters
npm install -g prettier
npm install -g eslint_d
cargo install stylua  # or install via package manager
```

### Setup
1. **Backup existing config** (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Clone/copy this configuration**:
   ```bash
   # Place the nvim config in ~/.config/nvim/
   ```

3. **First launch**:
   ```bash
   nvim
   ```
   - Lazy.nvim will automatically install all plugins
   - Mason will install LSP servers and tools
   - Treesitter will install language parsers

4. **Post-installation**:
   - Run `:checkhealth` to verify everything is working
   - Install language servers via `:Mason` if needed
   - Configure GitHub Copilot with `:Copilot setup` (if you have access)

## 📁 Configuration Structure

```
.config/nvim/
├── init.lua                 # Entry point and lazy.nvim setup
├── lazy-lock.json          # Plugin version lockfile
├── lua/
│   ├── vim-options.lua     # Core Neovim settings
│   ├── keymaps.lua         # Global keybindings
│   └── plugins/            # Plugin configurations
│       ├── lsp/            # LSP-related plugins
│       │   ├── lspconfig.lua
│       │   └── mason.lua
│       ├── completions.lua
│       ├── telescope.lua
│       ├── treesitter.lua
│       ├── gitsigns.lua
│       ├── formatting.lua
│       ├── linting.lua
│       └── [other plugins...]
└── README.md               # This file
```

## 🎨 Customization

### Adding New Plugins
Create a new file in `lua/plugins/` or add to existing files:
```lua
return {
  "author/plugin-name",
  config = function()
    -- Plugin configuration
  end,
}
```

### Modifying Keybindings
Edit `lua/keymaps.lua` for global bindings or individual plugin files for plugin-specific bindings.

### Changing Theme
Replace the theme in `lua/plugins/theme.lua`:
```lua
return {
  "new-theme/nvim",
  config = function()
    vim.cmd("colorscheme new-theme")
  end,
}
```

### Language Support
Add new language servers in `lua/plugins/lsp/mason.lua` and configure them in `lua/plugins/lsp/lspconfig.lua`.

## 🔧 Troubleshooting

### Common Issues

1. **LSP not working**: Run `:Mason` and ensure language servers are installed
2. **Telescope not finding files**: Install `ripgrep` and `fd`
3. **Icons not showing**: Install a Nerd Font and configure your terminal
4. **Copilot not working**: Run `:Copilot setup` and authenticate
5. **Images not displaying**: Ensure you're using Kitty terminal with image support

### Health Checks
- `:checkhealth` - General Neovim health
- `:checkhealth telescope` - Telescope-specific issues
- `:LspInfo` - LSP server status
- `:Mason` - Installed tools overview

## 📚 Resources

- [Neovim Documentation](https://neovim.io/doc/)
- [Lazy.nvim Plugin Manager](https://github.com/folke/lazy.nvim)
- [LSP Configuration Guide](https://github.com/neovim/nvim-lspconfig)
- [Telescope Usage](https://github.com/nvim-telescope/telescope.nvim)

## 🤝 Contributing

Feel free to customize this configuration to your needs. The modular structure makes it easy to add, remove, or modify plugins without breaking the entire setup.

---

**Happy coding with Neovim! 🎉** 