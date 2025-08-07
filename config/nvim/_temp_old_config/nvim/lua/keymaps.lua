-- =====================================================
-- CUSTOM KEYBINDINGS CONFIGURATION
-- =====================================================
-- This file defines custom key mappings for improved workflow and productivity

-- LEADER KEY CONFIGURATION
-- Set leader key to space (easier to reach than default backslash)
vim.g.mapleader = " "
local keymap = vim.keymap -- for conciseness

-- SCROLLING ENHANCEMENTS
-- Keep cursor centered when scrolling up/down half pages
-- This prevents losing track of cursor position during navigation
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })

-- GIT INTEGRATION SHORTCUTS
-- Quick git hunk preview without opening full git interface
keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "[G]it [P]review hunk" })

-- FILE EXPLORER TOGGLE
-- Quick access to file tree - Ctrl+n is fast and easy to remember
keymap.set("n", "<C-n>", ":Neotree filesystem reveal right toggle<CR>", { desc = "Toggle File Explorer" })

-- UNDO HISTORY VISUALIZATION
-- Visual undo tree to see and navigate complex undo history
keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle [U]ndo Tree" })

-- UTILITY SHORTCUTS
-- Clear search highlighting without affecting search history
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "[N]o [H]ighlight" })

-- Copy current file's full path to system clipboard
-- Useful for sharing file locations or debugging
keymap.set("n", "<leader>cp", ':let @+ = expand("%:p")<CR>', { 
  noremap = true, 
  silent = true, 
  desc = "[C]opy file [P]ath" 
})
