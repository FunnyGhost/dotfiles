-- =====================================================
-- MINI.SURROUND - Surround Text Operations
-- =====================================================
-- Fast and feature-rich surround actions
-- Add, delete, replace, find, highlight surroundings

return {
  "echasnovski/mini.surround",
  version = "*", -- Use latest stable version
  config = function()
    require("mini.surround").setup({
      -- Module mappings. Use `''` (empty string) to disable one.
      mappings = {
        add = "ys",            -- Add surrounding in Normal and Visual modes
        delete = "ds",         -- Delete surrounding
        find = "gsf",          -- Find surrounding (to the right)
        find_left = "gsF",     -- Find surrounding (to the left)
        highlight = "gsh",     -- Highlight surrounding
        replace = "cs",        -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`

        -- Add surrounding in Normal and Visual modes using custom text input
        suffix_last = "l",     -- Suffix to search with "prev" method
        suffix_next = "n",     -- Suffix to search with "next" method
      },

      -- Number of lines within which surrounding is searched
      n_lines = 20,

      -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
      highlight_duration = 500,

      -- Pattern to match function name in 'function call' surrounding
      -- By default matches any char except '(' and whitespace
      -- patterns = {
      --   left = "([%{%[%<])",
      --   right = "([%)%}%]%>])",
      -- },
    })
  end,
}
