vim.cmd("set noexpandtab")
vim.cmd("set autoindent")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- Set <leader> as <space>
vim.g.mapleader = " "
-- Show line numbers
vim.wo.number = true
-- Unify clipboard with the system
vim.o.clipboard = "unnamedplus"
-- Keep unde history
vim.o.undofile = true
-- Set a better completion experience
vim.o.completeopt = "menu,menuone,preview,noselect"
