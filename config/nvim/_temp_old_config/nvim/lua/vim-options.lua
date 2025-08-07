-- =====================================================
-- VIM OPTIONS AND EDITOR BEHAVIOR CONFIGURATION
-- =====================================================
-- This file configures basic Neovim editor behavior and settings

-- BUILT-IN FILE EXPLORER SETTINGS
-- Change the navigation style of the vim explorer to tree view (style 3)
-- This makes the built-in netrw file explorer show files in a tree structure
vim.cmd("let g:netrw_liststyle = 3")

-- INDENTATION AND SPACING CONFIGURATION
vim.opt.tabstop = 2       -- Display width of tab characters (how many spaces a tab looks like)
vim.opt.expandtab = true  -- Convert tabs to spaces when typing
vim.opt.autoindent = true -- Copy indentation from the current line when starting a new line
vim.opt.shiftwidth = 2    -- Number of spaces for each indentation level (>, <, auto-indent)

-- LINE NUMBER DISPLAY
vim.opt.number = true         -- Show absolute line numbers
vim.opt.relativenumber = true -- Show relative line numbers (great for vim motions like 5j, 3k)

-- CLIPBOARD INTEGRATION
-- Unify Neovim's clipboard with the system clipboard (copy/paste works with OS)
vim.opt.clipboard = "unnamedplus"

-- UNDO HISTORY PERSISTENCE
vim.opt.undofile = true    -- Save undo history to disk (persists between sessions)
vim.opt.undolevels = 10000 -- Maximum number of undo operations to remember

-- COMPLETION BEHAVIOR
-- Configure how completion menus behave for a better experience
vim.opt.completeopt = "menu,menuone,preview,noselect"

-- VISUAL ENHANCEMENTS
vim.opt.cursorline = true -- Highlight the current line where the cursor is

-- WINDOW SPLITTING BEHAVIOR
vim.opt.splitright = true -- New vertical splits open to the right
vim.opt.splitbelow = true  -- New horizontal splits open below

-- MARKDOWN AND TEXT EDITING
vim.opt.spelllang = { "en" }  -- Set spell check language to English
vim.opt.conceallevel = 2      -- Hide markup characters (*, _, etc.) but show substitutions
vim.opt.wrap = false          -- Don't wrap long lines (horizontal scrolling instead)

-- SEARCH CONFIGURATION
vim.opt.ignorecase = true -- Ignore case in search patterns
vim.opt.smartcase = true  -- Override ignorecase if pattern contains uppercase letters

-- EDITOR VISUAL IMPROVEMENTS
vim.opt.signcolumn = "yes"   -- Always show sign column (prevents text shifting when signs appear)
vim.opt.termguicolors = true -- Enable 24-bit RGB color support in terminal

-- AUTOCOMMANDS AND EVENT HANDLERS
-- Utility function to create augroups with consistent naming
local function augroup(name)
	return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Highlight yanked (copied) text briefly to show what was copied
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight on yank",
	group = augroup("highlight_yank"),
	callback = function()
		vim.highlight.on_yank() -- Brief highlight animation when text is yanked
	end,
})
