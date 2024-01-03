vim.cmd("set noexpandtab")
vim.cmd("set autoindent")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- Show line numbers
vim.wo.number = true
vim.wo.relativenumber = true
-- Unify clipboard with the system
vim.o.clipboard = "unnamedplus"
-- Keep unde history
vim.o.undofile = true
-- Set a better completion experience
vim.o.completeopt = "menu,menuone,preview,noselect"
-- Highlight current line
vim.cursorline = true
-- split windows
vim.opt.splitright = true -- split vertical window to the right
vim.opt.splitbelow = true -- split horizontal window to the bottom
