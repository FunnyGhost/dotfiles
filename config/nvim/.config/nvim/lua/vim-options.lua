-- Change the navigation style of the vim explorer
vim.cmd("let g:netrw_liststyle = 3")

-- Spacing stuff
vim.opt.tabstop = 2 -- Number of spaces that a <Tab> in the file counts for
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.autoindent = true -- Copy indent from current line
vim.opt.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent
-- Show line numbers
vim.opt.number = true
vim.opt.relativenumber = true
-- Unify clipboard with the system
vim.opt.clipboard = "unnamedplus"
-- Keep unde history
vim.opt.undofile = true
vim.opt.undolevels = 10000
-- Set a better completion experience
vim.opt.completeopt = "menu,menuone,preview,noselect"
-- Highlight current line
vim.opt.cursorline = true
-- split windows
vim.opt.splitright = true -- split vertical window to the right
vim.opt.splitbelow = true -- split horizontal window to the bottom
-- Markdown
vim.opt.spelllang = { "en" }
vim.opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
vim.opt.wrap = false -- Disable line wrap
-- Search stuff
vim.opt.ignorecase = true -- Ignore case
vim.opt.smartcase = true -- Don't ignore case with capitals
-- Other stuff
vim.opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.termguicolors = true -- True color support

-- Commands
local function augroup(name)
	return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end
-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight on yank",
	group = augroup("highlight_yank"),
	callback = function()
		vim.highlight.on_yank()
	end,
})
