-- =====================================================
-- TODO-COMMENTS - HIGHLIGHT AND SEARCH TODO COMMENTS
-- =====================================================
-- Todo-comments: Highlights TODO, FIXME, NOTE, etc. comments with colors
-- Provides search functionality and integration with Telescope and Trouble

return {
  "folke/todo-comments.nvim", -- TODO comment highlighting and search
  event = { "BufReadPre", "BufNewFile" }, -- Load when opening files
  dependencies = { "nvim-lua/plenary.nvim" }, -- Required utilities
  config = function()
    local todo_comments = require("todo-comments")

    -- KEYBINDINGS FOR TODO NAVIGATION
    local keymap = vim.keymap

    -- Navigate to next TODO comment in current buffer
    keymap.set("n", "]t", function()
      todo_comments.jump_next()
    end, { desc = "Next TODO comment" })

    -- Navigate to previous TODO comment in current buffer
    keymap.set("n", "[t", function()
      todo_comments.jump_prev()
    end, { desc = "Previous TODO comment" })

    -- Setup with default configuration
    -- Automatically highlights: TODO, HACK, WARN, PERF, NOTE, TEST, FIXME
    todo_comments.setup()
  end,
}
