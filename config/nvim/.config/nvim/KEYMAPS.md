# Neovim Keymaps Reference

A comprehensive guide to all keybindings in our Neovim setup. Leader key is set to `<Space>`.

## ❓ How to Read This Guide

### Notation
- `<leader>` - The Space key
- `<C-x>` - Hold Ctrl and press x
- `<S-x>` - Hold Shift and press x
- `<CR>` - Press Enter/Return
- `<BS>` - Press Backspace

### Special Keys
- `[x]` in descriptions means "x" is a mnemonic letter
  - Example: `<leader>fm` → [F]ile [M]anager
- `{motion}` means any Vim motion (like `w`, `b`, `2j`, etc.)
  - Example: `gc{motion}` → Comment motion (e.g., `gc2j` comments 2 lines)

## 📂 File Management

### Finding Files
- `<leader>ff` - [F]ind [F]iles in project
- `<leader>fr` - [F]ind [R]ecent files (current project only)
- `<leader>fb` - [F]ind [B]uffers
- `<leader>fm` - [F]ile [M]anager in current directory
- `<leader>fM` - [F]ile [M]anager in project root

### File Manager Navigation
- `h` - Go up one directory level
- `l` - Enter directory or open file
- `L` - Open file in new tab
- `H` - Go up and close current directory
- `q` - Close file manager
- `=` - Save all changes (synchronize)
- `<BS>` - Reset to original directory
- `@` - Reveal current working directory
- `g?` - Show help
- `g~` - Set current directory

### File Operations
- `<leader>w` - [W]rite file
- `<leader>wa` - [W]rite [A]ll files
- `<leader>cp` - [C]opy file [P]ath
- `<leader>cr` - [C]opy [R]elative path

## 📑 Buffer Management

### Buffer Navigation
- `<leader>bn` - [B]uffer [N]ext
- `<leader>bp` - [B]uffer [P]revious
- `<leader>bd` - [B]uffer [D]elete
- `<leader>bD` - [B]uffer [D]elete (force)
- `<leader>ba` - [B]uffer delete [A]ll except current
- `<leader>bl` - [B]uffer [L]ist

## 🔍 Search

### Text Search
- `<leader>fg` - [F]ind selection by [G]rep (visual mode)
- `<leader>fw` - [F]ind current [W]ord
- `<leader>fW` - [F]ind current [W]ORD
- `<leader>f/` - [F]ind search history
- `<leader>f.` - [F]ind resume last search

### Help & Commands
- `<leader>fh` - [F]ind [H]elp tags
- `<leader>fk` - [F]ind [K]eymaps
- `<leader>fc` - [F]ind [C]ommands
- `<leader>fF` - [F]zf builtin commands

## 📝 Code Navigation & Editing

### Symbol Navigation
- `gd` - [G]o to [D]efinition
- `gD` - [G]o to [D]eclaration
- `K` - Show documentation
- `grf` - [R]e[f]erences to symbol
- `gim` - [I]mple[m]entation of symbol
- `gs` - [G]o to [S]ymbols

### LSP with FZF
- `<leader>lr` - [L]sp [R]eferences
- `<leader>ld` - [L]sp [D]efinitions
- `<leader>li` - [L]sp [I]mplementations
- `<leader>ls` - [L]sp document [S]ymbols
- `<leader>lS` - [L]sp workspace [S]ymbols
- `<leader>la` - [L]sp code [A]ctions

### Code Actions
- `grn` - [R]e[n]ame symbol
- `gca` - [C]ode [A]ctions menu
- `<leader>cf` - [C]ode [F]ormat

### Diagnostics
- `[d` / `]d` - Previous/Next diagnostic
- `<leader>e` - Show diagnostic [E]rror
- `<leader>dl` - [D]iagnostic [L]ist

### Trouble.nvim (Enhanced Diagnostics)
- `<leader>xx` - [X] [X] All diagnostics
- `<leader>xw` - [X] diagnostics for current [W]indow/buffer
- `<leader>cs` - [C]ode [S]ymbols
- `<leader>cl` - [C]ode [L]SP definitions/references
- `<leader>xL` - [X] [L]ocation list
- `<leader>xQ` - [X] [Q]uickfix list

### Text Operations
- `<leader>p` - [P]aste without yanking (visual mode)
- `<C-d>` / `<C-u>` - Scroll down/up (centered)
- `<` / `>` - Indent left/right (stays in visual mode)
- `J` / `K` - Move line down/up (visual mode)
- `gcc` - Comment/uncomment line
- `gc{motion}` - Comment motion (e.g., `gc2j` comments 2 lines)

### Surround Operations
- `ys{motion}{char}` - [Y]ou [S]urround motion (e.g., `ysw"` surrounds word with quotes)
- `ys{char}` - [Y]ou [S]urround in visual mode
- `ds{char}` - [D]elete [S]urround
- `cs{target}{replacement}` - [C]hange [S]urround
- `gsf{char}` - [G]o [S]urround [F]ind next
- `gsF{char}` - [G]o [S]urround [F]ind previous
- `gsh{char}` - [G]o [S]urround [H]ighlight

## 📦 Git Operations

### Git Navigation
- `]c` / `[c` - Next/Previous change
- `<leader>gf` - [G]it [F]iles
- `<leader>gs` - [G]it [S]tatus
- `<leader>gc` - [G]it [C]ommits
- `<leader>gC` - [G]it buffer [C]ommits
- `<leader>gb` - [G]it [B]ranches

### Change Management
- `<leader>hs` - [H]unk [S]tage
- `<leader>hr` - [H]unk [R]eset
- `<leader>hu` - [H]unk [U]ndo stage
- `<leader>hp` - [H]unk [P]review
- `<leader>hb` - [H]unk [B]lame line

### LazyGit
- `<leader>lg` - Open [L]azy[G]it

#### Inside LazyGit
- `?` - Show all keybindings
- `<Esc>` - Close/Return
- `q` - Quit LazyGit

#### Files & Status
- `<Space>` - Toggle staged
- `a` - Toggle staged all
- `c` - Commit changes
- `C` - Commit changes with editor
- `A` - Amend last commit
- `e` - Edit file
- `o` - Open file
- `d` - View diff
- `D` - Toggle diff view

#### Branches & Commits
- `b` - View branches
- `n` - New branch
- `f` - Fast-forward branch
- `m` - View remotes
- `p` - Pull
- `P` - Push
- `r` - Rebase options
- `R` - Refresh
- `s` - Stash options
- `t` - Tags
- `<C-r>` - Reset/Revert options

#### Navigation
- `<Tab>` - Next panel
- `h/j/k/l` - Navigation
- `/` - Search
- `[` / `]` - Previous/Next branch
- `{` / `}` - Previous/Next tab

## 🪟 Window Management

### Window Navigation
- `<C-h>` - Move to left window
- `<C-l>` - Move to right window
- `<C-j>` - Move to bottom window
- `<C-k>` - Move to top window

### Window Operations
- `<C-w>v` or `:vsp` - Split vertically
- `<C-w>s` or `:sp` - Split horizontally
- `<C-w>c` or `:q` - Close current window
- `<C-Up>` - Increase height
- `<C-Down>` - Decrease height
- `<C-Left>` - Decrease width
- `<C-Right>` - Increase width

## 💻 Terminal

### Terminal Management
- `<leader>th` - [T]erminal [H]orizontal split
- `<leader>tv` - [T]erminal [V]ertical split
- `<leader>tc` - [T]erminal [C]lose
- `<Esc>` - Exit terminal mode

## ⚡️ Quick Actions
- `<leader>q` - [Q]uit
- `<leader>qa` - [Q]uit [A]ll
- `<leader>Q` - [Q]uit (force)
- `<leader>nh` - [N]o [H]ighlight

## 🎓 Vim Learning Resources

### Advanced Motions
- `;` - Repeat last f/F/t/T motion forward
- `,` - Repeat last f/F/t/T motion backward
- `%` - Jump to matching bracket/parenthesis
- `*` - Search word under cursor forward
- `#` - Search word under cursor backward

### Text Objects
- `is` - Inner sentence
- `as` - A sentence
- `ip` - Inner paragraph
- `ap` - A paragraph

### Visual Mode
- `v` - Character-wise visual mode
- `V` - Line-wise visual mode
- `<C-v>` - Block-wise visual mode
- `o` - Move to other end of selection
- `gv` - Reselect last visual selection
