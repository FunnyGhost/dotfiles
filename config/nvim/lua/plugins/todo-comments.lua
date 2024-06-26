-- Utility to add TODO/BUG/NOTE/etc comments, and to be able to search them
return {
  "folke/todo-comments.nvim",
  event = {"BufReadPre", "BufNewFile"},
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local todo_comments = require("todo-comments")

    -- set keymaps
    local keymap = vim.keymap

    keymap.set("n", "]t", function()
      todo_comments.jump_next()
    end, {desc = "Next [t]odo comment"})

    keymap.set("n", "[t", function()
      todo_comments.jump_prev()
    end, {desc = "Previous [t]odo comment"})

    todo_comments.setup()
  end
}
