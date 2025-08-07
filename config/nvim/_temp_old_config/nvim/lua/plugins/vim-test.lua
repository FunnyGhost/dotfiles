-- =====================================================
-- VIM-TEST - TEST RUNNER INTEGRATION
-- =====================================================
-- vim-test: Run tests from within Neovim with support for many testing frameworks
-- Supports Jest, RSpec, pytest, go test, and many more testing frameworks

return {
  "vim-test/vim-test", -- Universal test runner plugin
  dependencies = {
    "preservim/vimux", -- Tmux integration for running tests in tmux panes
  },
  config = function()
    -- KEYBINDINGS FOR TEST OPERATIONS
    local keymap = vim.keymap

    -- Run the nearest test to cursor
    keymap.set("n", "<leader>t", ":TestNearest<CR>", { desc = "Run nearest [T]est" })
    
    -- Run all tests in current file
    keymap.set("n", "<leader>T", ":TestFile<CR>", { desc = "Run [T]est file" })
    
    -- Run all tests in test suite
    keymap.set("n", "<leader>a", ":TestSuite<CR>", { desc = "Run [A]ll tests" })
    
    -- Re-run the last test command
    keymap.set("n", "<leader>l", ":TestLast<CR>", { desc = "Run [L]ast test" })
    
    -- Visit the test file corresponding to the current file
    keymap.set("n", "<leader>g", ":TestVisit<CR>", { desc = "[G]o to test file" })
  end,
}
