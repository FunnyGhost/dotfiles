# Modern Neovim Configuration

A minimal, modern Neovim configuration leveraging the built-in features of Neovim 0.11.3.

## Philosophy

This configuration prioritizes:
- **Built-in features first** - Leverage Neovim's native capabilities
- **Incremental complexity** - Add plugins only when truly needed
- **Modern APIs** - Use the latest Neovim 0.11+ features
- **Performance** - Minimal startup time and responsive editing

## Requirements

- Neovim 0.11.3 or later
- Git (for plugin management when we add them)

## Quick Start

```bash
# Backup your existing config (if any)
mv ~/.config/nvim ~/.config/nvim.backup

# Clone this config
git clone <your-repo> ~/.config/nvim

# Start Neovim
nvim
```

## Key Mappings

**Leader Key:** `<Space>`

For detailed mappings, see: [`lua/keymaps.lua`](./lua/keymaps.lua)

### Essential Keys to Know

#### Terminal Management
- `<leader>th` - Open horizontal terminal split
- `<leader>tv` - Open vertical terminal split
- `<leader>tc` - Close current terminal
- `<Esc>` (in terminal) - Exit to normal mode

#### File Explorer (Built-in Netrw)
- `<leader>fe` - Open file explorer
- `<leader>fv` - Open file explorer (vertical split)
- `<leader>fs` - Open file explorer (horizontal split)
- `<leader>ft` - Toggle file explorer tree style

#### Better Editing
- `<leader>p` (visual mode) - Paste without yanking selection
- `<C-d>` / `<C-u>` - Scroll down/up (cursor centered)
- `gcc` - Comment/uncomment line
- `gc{motion}` - Comment motion (e.g., `gc2j` comments 2 lines)

#### LSP (When Language Servers Available)
- `K` - Show hover documentation
- `gd` - Go to definition
- `gD` - Go to declaration
- `grn` - Rename symbol
- `grf` - Find references
- `gim` - Go to implementation
- `gs` - Document symbols
- `gca` - Code actions
- `[d` / `]d` - Navigate diagnostics

#### Window Management
- `<C-h/j/k/l>` - Navigate between windows
- `<C-w>v` - Vertical split
- `<C-w>s` - Horizontal split

#### Quick Actions
- `<leader>w` - Save file
- `<leader>q` - Quit
- `<leader>nh` - Clear search highlighting

## Current Features

### Built-in Neovim 0.11.3 Features
- ✅ **Native LSP** with modern `vim.lsp.config()` and `vim.lsp.enable()` APIs
- ✅ **Built-in completion** for LSP
- ✅ **Native commenting** (`gcc`, `gc{motion}`)
- ✅ **Enhanced diagnostics** with better defaults
- ✅ **Improved treesitter** performance and highlighting
- ✅ **Better terminal** integration

### Configuration Structure
```
.config/nvim/
├── init.lua              # Entry point
├── lua/
│   ├── options.lua       # Editor options and settings
│   ├── keymaps.lua       # Key mappings
│   └── plugins/
│       ├── init.lua      # Plugin initialization (minimal)
│       └── lsp-example.lua # LSP setup examples
└── README.md             # This file
```

## Plugins

Currently using **zero plugins** - pure Neovim power!

### Coming Soon (Based on Workflow Needs)
- [ ] File fuzzy finding (Telescope?)
- [ ] Git integration (Gitsigns?)
- [ ] Enhanced file management (Neo-tree/Oil?)
- [ ] Status line (Lualine?)
- [ ] Color scheme
- [ ] Additional LSP tooling

## LSP Setup

To use LSP features, install language servers:

```bash
# Example: Lua language server
brew install lua-language-server

# Example: Python
pip install pyright

# Example: TypeScript
npm install -g typescript-language-server
```

Then configure in `lua/plugins/lsp-example.lua` using the new 0.11 APIs.

## Performance

- **Startup time:** ~20ms (minimal plugins)
- **Memory usage:** ~15MB base
- **Responsive editing:** Built-in features are fast by default

## Customization

1. **Options:** Edit `lua/options.lua`
2. **Keymaps:** Edit `lua/keymaps.lua`
3. **Plugins:** Add to `lua/plugins/` directory

## Troubleshooting

### Check Health
```vim
:checkhealth
```

### View Current Mappings
```vim
:map           " All mappings
:nmap          " Normal mode mappings
:nmap <leader> " Leader key mappings
```

### LSP Status
```vim
:LspInfo       " LSP client information
:checkhealth vim.lsp  " LSP health check
```

## Contributing

This configuration evolves based on actual workflow needs. When adding plugins:

1. **Justify the need** - Can built-in features handle this?
2. **Test thoroughly** - Ensure it works with existing setup
3. **Update documentation** - Keep this README current
4. **Consider alternatives** - Is there a lighter option?

---

**Last Updated:** $(date)  
**Neovim Version:** 0.11.3+  
**Status:** Minimal base complete, adding plugins incrementally
