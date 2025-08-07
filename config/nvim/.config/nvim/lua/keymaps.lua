-- =====================================================
-- ESSENTIAL KEYMAPS CONFIGURATION
-- =====================================================
-- Core keybindings that enhance the Neovim experience

local keymap = vim.keymap.set

-- BETTER MOVEMENT
-- Keep cursor centered when scrolling
keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })

-- Keep search centered
keymap("n", "n", "nzzzv", { desc = "Next search result (centered)" })
keymap("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- BETTER INDENTING
-- Stay in visual mode when indenting
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

-- MOVE LINES
-- Move lines up/down in visual mode
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- BETTER PASTE
-- Don't yank when pasting over selection
keymap("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })

-- UTILITY KEYMAPS
-- Clear search highlighting
keymap("n", "<leader>nh", ":nohlsearch<CR>", { desc = "[N]o [H]ighlight" })

-- Copy file path to clipboard
keymap("n", "<leader>cp", ':let @+ = expand("%:p")<CR>', { 
  desc = "[C]opy file [P]ath",
  silent = true 
})

-- Copy relative file path to clipboard
keymap("n", "<leader>cr", ':let @+ = expand("%")<CR>', { 
  desc = "[C]opy [R]elative path",
  silent = true 
})

-- WINDOW MANAGEMENT
-- Better window navigation
keymap("n", "<C-h>", "<C-w><C-h>", { desc = "Move to left window" })
keymap("n", "<C-l>", "<C-w><C-l>", { desc = "Move to right window" })
keymap("n", "<C-j>", "<C-w><C-j>", { desc = "Move to bottom window" })
keymap("n", "<C-k>", "<C-w><C-k>", { desc = "Move to top window" })

-- Resize windows
keymap("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
keymap("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
keymap("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- BUFFER MANAGEMENT
-- Next/previous buffer
keymap("n", "<leader>bn", ":bnext<CR>", { desc = "[B]uffer [N]ext" })
keymap("n", "<leader>bp", ":bprevious<CR>", { desc = "[B]uffer [P]revious" })
keymap("n", "<leader>bd", ":bdelete<CR>", { desc = "[B]uffer [D]elete" })

-- QUICK ACTIONS
-- Save file
keymap("n", "<leader>w", ":w<CR>", { desc = "[W]rite file" })

-- Quit
keymap("n", "<leader>q", ":q<CR>", { desc = "[Q]uit" })

-- Source current file (useful for config editing)
keymap("n", "<leader><leader>x", ":source %<CR>", { desc = "E[x]ecute current file" })

-- TERMINAL
-- Open terminal in split
keymap("n", "<leader>th", ":split | terminal<CR>", { desc = "[T]erminal [H]orizontal" })
keymap("n", "<leader>tv", ":vsplit | terminal<CR>", { desc = "[T]erminal [V]ertical" })

-- Close terminal
keymap("n", "<leader>tc", function()
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].buftype == "terminal" then
    vim.cmd("bdelete!")
  else
    print("Not in a terminal buffer")
  end
end, { desc = "[T]erminal [C]lose" })

-- Terminal mode escape
keymap("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- DIAGNOSTIC KEYMAPS (0.11+ has more built-in mappings!)
-- [d and ]d are now built-in defaults in 0.11+
keymap("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror" })
keymap("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "[D]iagnostic [L]ist" })

-- LSP KEYMAPS (Custom - overriding 0.11+ defaults for better UX)
-- Override the 0.11+ defaults with more intuitive mappings
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end
    
    local opts = { buffer = args.buf, desc = "LSP: " }
    
    -- More intuitive LSP mappings (avoiding conflicts)
    keymap("n", "grn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "LSP: [R]e[n]ame" }))
    keymap("n", "grf", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "LSP: [R]e[f]erences" }))
    keymap("n", "gim", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "LSP: [I]mple[m]entation" }))
    keymap("n", "gs", vim.lsp.buf.document_symbol, vim.tbl_extend("force", opts, { desc = "LSP: Document [S]ymbols" }))
    keymap("n", "gca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "LSP: [C]ode [A]ctions" }))
    
    -- Keep some of the built-ins that are good
    -- K -> vim.lsp.buf.hover() (already built-in)
    -- gd -> vim.lsp.buf.definition() (already built-in)
    -- gD -> vim.lsp.buf.declaration() (already built-in)
  end,
})

-- COMMENTING (using Neovim 0.10+ built-in commenting)
-- gc{motion} and gcc are built-in in Neovim 0.10+
-- Example: gcc (comment line), gc2j (comment 2 lines down), etc.

-- FILE EXPLORER (using built-in netrw for now)
keymap("n", "<leader>fe", ":Explore<CR>", { desc = "[F]ile [E]xplorer" })
keymap("n", "<leader>fv", ":Vexplore<CR>", { desc = "[F]ile explorer [V]ertical" })
keymap("n", "<leader>fs", ":Sexplore<CR>", { desc = "[F]ile explorer [S]plit" })

-- Toggle netrw tree style
keymap("n", "<leader>ft", function()
  vim.g.netrw_liststyle = (vim.g.netrw_liststyle == 3) and 0 or 3
  vim.cmd("Explore")
end, { desc = "[F]ile explorer [T]ree toggle" })
