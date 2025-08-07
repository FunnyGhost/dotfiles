-- =====================================================
-- ESSENTIAL KEYMAPS CONFIGURATION
-- =====================================================
-- Core keybindings that enhance the Neovim experience

local keymap = vim.keymap.set

-- =====================================================
-- GENERIC NEOVIM KEYMAPS (No plugins required)
-- =====================================================

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
keymap("n", "<leader>bn", ":bnext<CR>", { desc = "[B]uffer [N]ext" })
keymap("n", "<leader>bp", ":bprevious<CR>", { desc = "[B]uffer [P]revious" })
keymap("n", "<leader>bd", ":bdelete<CR>", { desc = "[B]uffer [D]elete" })
keymap("n", "<leader>bD", ":bdelete!<CR>", { desc = "[B]uffer [D]elete (force)" })
keymap("n", "<leader>ba", ":%bd|e#|bd#<CR>", { desc = "[B]uffer delete [A]ll except current" })
keymap("n", "<leader>bl", ":buffers<CR>", { desc = "[B]uffer [L]ist" })

-- QUICK ACTIONS
-- Save file
keymap("n", "<leader>w", ":w<CR>", { desc = "[W]rite file" })
keymap("n", "<leader>wa", ":wa<CR>", { desc = "[W]rite [A]ll files" })

-- Quit
keymap("n", "<leader>q", ":q<CR>", { desc = "[Q]uit" })
keymap("n", "<leader>qa", ":qa<CR>", { desc = "[Q]uit [A]ll" })
keymap("n", "<leader>Q", ":q!<CR>", { desc = "[Q]uit (force)" })

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

-- =====================================================
-- PLUGIN KEYMAPS
-- =====================================================

-- MINI.FILES PLUGIN KEYMAPS
keymap("n", "<leader>fm", function() 
  local mini_files = require("mini.files")
  mini_files.open(vim.api.nvim_buf_get_name(0))
end, { desc = "[F]ile [M]anager" })

keymap("n", "<leader>fM", function() 
  local mini_files = require("mini.files")
  mini_files.open(vim.fn.getcwd())
end, { desc = "[F]ile [M]anager (CWD)" })

-- FZF-LUA PLUGIN KEYMAPS
-- File Operations
keymap("n", "<leader>ff", function() require("fzf-lua").files() end, { desc = "[F]ind [F]iles" })
keymap("n", "<leader>fr", function() require("fzf-lua").oldfiles() end, { desc = "[F]ind [R]ecent files" })
keymap("n", "<leader>fb", function() require("fzf-lua").buffers() end, { desc = "[F]ind [B]uffers" })

-- Search Operations
keymap("n", "<leader>fg", function() require("fzf-lua").live_grep() end, { desc = "[F]ind by [G]rep" })
keymap("n", "<leader>fw", function() require("fzf-lua").grep_cword() end, { desc = "[F]ind current [W]ord" })
keymap("n", "<leader>fW", function() require("fzf-lua").grep_cWORD() end, { desc = "[F]ind current [W]ORD" })
keymap("v", "<leader>fg", function() require("fzf-lua").grep_visual() end, { desc = "[F]ind selection by [G]rep" })

-- Git Integration
keymap("n", "<leader>gf", function() require("fzf-lua").git_files() end, { desc = "[G]it [F]iles" })
keymap("n", "<leader>gs", function() require("fzf-lua").git_status() end, { desc = "[G]it [S]tatus" })
keymap("n", "<leader>gc", function() require("fzf-lua").git_commits() end, { desc = "[G]it [C]ommits" })
keymap("n", "<leader>gC", function() require("fzf-lua").git_bcommits() end, { desc = "[G]it buffer [C]ommits" })
keymap("n", "<leader>gb", function() require("fzf-lua").git_branches() end, { desc = "[G]it [B]ranches" })

-- LSP Integration (when LSP available)
keymap("n", "<leader>lr", function() require("fzf-lua").lsp_references() end, { desc = "[L]sp [R]eferences" })
keymap("n", "<leader>ld", function() require("fzf-lua").lsp_definitions() end, { desc = "[L]sp [D]efinitions" })
keymap("n", "<leader>li", function() require("fzf-lua").lsp_implementations() end, { desc = "[L]sp [I]mplementations" })
keymap("n", "<leader>ls", function() require("fzf-lua").lsp_document_symbols() end, { desc = "[L]sp document [S]ymbols" })
keymap("n", "<leader>lS", function() require("fzf-lua").lsp_live_workspace_symbols() end, { desc = "[L]sp workspace [S]ymbols" })
keymap("n", "<leader>la", function() require("fzf-lua").lsp_code_actions() end, { desc = "[L]sp code [A]ctions" })

-- Miscellaneous
keymap("n", "<leader>fh", function() require("fzf-lua").help_tags() end, { desc = "[F]ind [H]elp tags" })
keymap("n", "<leader>fk", function() require("fzf-lua").keymaps() end, { desc = "[F]ind [K]eymaps" })
keymap("n", "<leader>fc", function() require("fzf-lua").commands() end, { desc = "[F]ind [C]ommands" })
keymap("n", "<leader>f:", function() require("fzf-lua").command_history() end, { desc = "[F]ind command history" })
keymap("n", "<leader>f/", function() require("fzf-lua").search_history() end, { desc = "[F]ind search history" })
keymap("n", "<leader>f.", function() require("fzf-lua").resume() end, { desc = "[F]ind resume last search" })
keymap("n", "<leader>fF", function() require("fzf-lua").builtin() end, { desc = "[F]zf builtin commands" })