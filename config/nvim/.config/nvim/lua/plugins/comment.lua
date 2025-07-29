-- =====================================================
-- COMMENT.NVIM - SMART CODE COMMENTING
-- =====================================================
-- Comment.nvim: Intelligent code commenting with treesitter integration
-- Supports different comment styles for different languages and contexts (JSX, Vue, etc.)

return {
  "numToStr/Comment.nvim", -- Smart commenting plugin
  event = { "BufReadPre", "BufNewFile" }, -- Load when opening files
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring", -- Treesitter-aware comment strings
  },
  config = function()
    local comment = require("Comment")

    -- Import treesitter context commentstring for better language support
    local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

    comment.setup({
      -- TREESITTER INTEGRATION
      -- Use treesitter to determine correct comment syntax for mixed-language files
      pre_hook = ts_context_commentstring.create_pre_hook(),
    })
  end,
}
