-- set leader key to space
vim.g.mapleader = " "
local keymap = vim.keymap -- for conciseness

-- always keep the cursor in the middle of the screen
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up" })

-- Gitsigns
keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "[g]it [p]review" })

-- Neotree
keymap.set("n", "<C-n>", ":Neotree filesystem reveal right toggle<CR>", { desc = "Toggle File System" })

-- UndoTree
keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle [u]ndo Tree" })

-- Other
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "[N]o [h]ighlight" })
keymap.set("n", "<leader>cp", ':let @+ = expand("%:p")<CR>', { noremap = true, silent = true })
