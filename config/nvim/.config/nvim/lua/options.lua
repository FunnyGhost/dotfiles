-- =====================================================
-- MODERN NEOVIM OPTIONS CONFIGURATION
-- =====================================================
-- Leveraging Neovim's built-in capabilities and modern defaults

-- BASIC EDITOR BEHAVIOR
-- Note: Leader keys are set in init.lua before this module loads
vim.opt.mouse = "a"                    -- Enable mouse support
vim.opt.showmode = false               -- Don't show mode (will be in statusline)
vim.opt.clipboard = "unnamedplus"      -- Use system clipboard
vim.opt.breakindent = true             -- Maintain indent when wrapping lines

-- INDENTATION & SPACING
vim.opt.tabstop = 2                    -- Tab display width
vim.opt.shiftwidth = 2                 -- Indent width
vim.opt.expandtab = true               -- Use spaces instead of tabs
vim.opt.autoindent = true              -- Copy indent from current line
vim.opt.smartindent = true             -- Smart auto-indenting

-- LINE NUMBERS
vim.opt.number = true                  -- Show line numbers
vim.opt.relativenumber = true          -- Show relative line numbers
vim.opt.signcolumn = "yes"             -- Always show sign column

-- SEARCH & REPLACE
vim.opt.ignorecase = true              -- Case insensitive search
vim.opt.smartcase = true               -- Case sensitive if uppercase used
vim.opt.hlsearch = true                -- Highlight search results
vim.opt.incsearch = true               -- Show search matches as typing

-- VISUAL ENHANCEMENTS
vim.opt.cursorline = true              -- Highlight current line
vim.opt.termguicolors = true           -- Enable 24-bit colors
vim.opt.wrap = false                   -- Don't wrap lines
vim.opt.scrolloff = 8                  -- Keep 8 lines above/below cursor
vim.opt.sidescrolloff = 8              -- Keep 8 columns left/right of cursor

-- WINDOW BEHAVIOR
vim.opt.splitright = true              -- Vertical splits to the right
vim.opt.splitbelow = true              -- Horizontal splits below

-- FILE HANDLING
vim.opt.undofile = true                -- Persistent undo
vim.opt.undolevels = 10000             -- Undo levels
vim.opt.backup = false                 -- Don't create backup files
vim.opt.writebackup = false            -- Don't create backup before writing
vim.opt.swapfile = false               -- Don't create swap files

-- PERFORMANCE
vim.opt.updatetime = 250               -- Faster completion (default 4000ms)
vim.opt.timeoutlen = 300               -- Time to wait for mapped sequence

-- COMPLETION (0.11+ has built-in LSP completion!)
vim.opt.completeopt = "menu,menuone,noselect,preview"
vim.opt.pumheight = 10                 -- Max items in completion menu

-- SPELLING & TEXT
vim.opt.spelllang = { "en" }           -- Spell check language
vim.opt.conceallevel = 2               -- Hide markup syntax

-- FILE TYPE DETECTION
vim.filetype.add({
  extension = {
    mdx = "mdx",
  },
})

-- AUTOCOMMANDS
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
local highlight_group = augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- Auto-create directories when saving files
autocmd("BufWritePre", {
  callback = function()
    local dir = vim.fn.expand("<afile>:p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

-- Check if file changed outside of vim
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Resize splits when window is resized
autocmd("VimResized", {
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})
