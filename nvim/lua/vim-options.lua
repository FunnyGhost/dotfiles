vim.cmd("set noexpandtab")
vim.cmd("set autoindent")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

vim.opt.expandtab = true -- Use spaces instead of tabs
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
-- Other stuff
vim.opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.ignorecase = true -- Ignore case
vim.opt.smartcase = true -- Don't ignore case with capitals
vim.opt.termguicolors = true -- True color support

-- Commands
local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end
-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

