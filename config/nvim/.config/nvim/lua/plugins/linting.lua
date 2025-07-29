-- =====================================================
-- CODE LINTING WITH NVIM-LINT
-- =====================================================
-- nvim-lint: Provides real-time code linting and error detection
-- Shows code quality issues, potential bugs, and style violations as you type

return {
  "mfussenegger/nvim-lint", -- Asynchronous linting plugin
  event = { "BufReadPre", "BufNewFile" }, -- Load when opening files
  config = function()
    local lint = require("lint")

    -- LINTER CONFIGURATION BY FILE TYPE
    -- Maps file types to their respective linting tools
    lint.linters_by_ft = {
      javascript = { "eslint" },      -- JavaScript linting with ESLint
      typescript = { "eslint" },      -- TypeScript linting with ESLint
      typescriptreact = { "eslint" }, -- React TypeScript linting
      javascriptreact = { "eslint" }, -- React JavaScript linting
    }

    -- AUTOMATIC LINTING TRIGGERS
    -- Set up autocommands to run linting automatically
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint() -- Run linting when entering buffer, saving, or leaving insert mode
      end,
    })

    -- MANUAL LINTING TRIGGER
    -- Keybinding to manually trigger linting for current file
    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = 'Trigger [L]inting for current file' })
  end
}
