-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "U", "<c-u>zz", { desc = "Scroll down" })
vim.keymap.set("n", "D", "<c-d>zz", { desc = "Scroll up" })

vim.keymap.set("n", "<leader>fp", "0<c-g>", { desc = "Show full [f]ile [p]ath" })

-- move lines
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- join lines
vim.keymap.set("n", "J", "mzJ`z")

-- chatgpt
vim.keymap.set("n", "<leader>gp", "<cmd>ChatGPT<cr>", { desc = "Launch Chat[G][P]T" })
vim.keymap.set("n", "<leader>gpa", "<cmd>ChatGPTActAs<cr>", { desc = "Chat[G][P]T [A]ct As" })
vim.keymap.set(
  "n",
  "<leader>gpe",
  "<cmd>ChatGPTEditWithInstructions<cr>",
  { desc = "Chat[G][P]T [E]dit With Instructions" }
)
vim.keymap.set("n", "<leader>gpc", "<cmd>ChatGPTCompleteCode<cr>", { desc = "Chat[G][P]T [C]omplete Code" })
vim.keymap.set("n", "<leader>gpf", "<cmd>ChatGPTRun fix_bugs<cr>", { desc = "Chat[G][P]T [F]ix Bugs" })
vim.keymap.set("n", "<leader>gpx", "<cmd>ChatGPTRun explain_code<cr>", { desc = "Chat[G][P]T E[x]plain Code" })

vim.keymap.set("v", "<leader>mb", "di****<esc>hhp", { desc = "[m]ake [b]old" })
vim.keymap.set("v", "<leader>mi", "di**<esc>hp", { desc = "[m]ake [i]talic" })
vim.keymap.set("v", "<leader>ml", "di[]()<esc>hhhpllli", { desc = "[m]ake [l]ink" })
vim.keymap.set("v", "<leader>mc", "di``<esc>hp", { desc = "[m]ake [c]ode" })

vim.keymap.set("n", "<leader>bw", "<cmd>bufdo bwipeout<cr>", { desc = "[b]uffer [w]ipeout" })

-- harpoon
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>ha", mark.add_file, { desc = "Harpoon [a]dd file" })
vim.keymap.set("n", "<leader>h", ui.toggle_quick_menu, { desc = "[h]arpoon toggle" })
vim.keymap.set("n", "<leader>hl", function()
  ui.nav_next()
end)
vim.keymap.set("n", "<leader>hh", function()
  ui.nav_next()
end)

-- undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "[u]ndo tree toggle" })

-- obsidian
vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianBacklinks<cr>", { desc = "Obsidian Backlinks" })
vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<cr>", { desc = "[O]bsidian [N]ew Note" })
vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianToday<cr>", { desc = "[O]bsidian [T]oday" })
vim.keymap.set("n", "<leader>oy", "<cmd>ObsidianYesterday<cr>", { desc = "[O]bsidian [Y]esterday" })
vim.keymap.set("n", "<leader>or", "<cmd>ObsidianTomorrow<cr>", { desc = "[O]bsidian Tomo[r]row" })

-- telescope
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>jl", require("telescope.builtin").jumplist, { desc = "[J]ump [L]ist" })
vim.keymap.set("n", "<leader>km", require("telescope.builtin").keymaps, { desc = "[K]ey[M]aps" })
vim.keymap.set("n", "<leader>rg", require("telescope.builtin").registers, { desc = "[R]egisters" })
vim.keymap.set("n", "<leader>ht", require("telescope.builtin").help_tags, { desc = "[H]elp [T]ags" })

-- window management
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "[S]plit window [v]ertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "[S]plit window [h]orizontally" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make [s]plits [e]qual size" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current [s]plit [X]" })
