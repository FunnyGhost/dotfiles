-- set leader key to space
vim.g.mapleader = " "
local keymap = vim.keymap -- for conciseness

-- always keep the cursor in the middle of the screen
keymap.set('n', '<C-d>', '<C-d>zz', { desc = "Scroll down" })
keymap.set('n', '<C-u>', '<C-u>zz', { desc = "Scroll up" })

-- Gitsigns
keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "[g]it [p]review" })

-- LSP
keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "[g]o to [d]efinition" })
keymap.set("n", "gr", vim.lsp.buf.references, { desc = "[g]o to [r]eferences" })
keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Show [c]ode [a]ctions" })
keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [d]iagnostic" })
keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [d]iagnostic" })
keymap.set("n", "<space>rn", vim.lsp.buf.rename, { desc = "[R]e[n]ame" })
keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "[g]o [f]ormat" })

-- Neotree
keymap.set("n", "<C-n>", ":Neotree filesystem reveal right toggle<CR>", { desc = "Toggle File System" })

-- UndoTree
keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle [u]ndo Tree" })
