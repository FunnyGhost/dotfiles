-- =====================================================
-- NVIM-SURROUND - TEXT OBJECT MANIPULATION
-- =====================================================
-- nvim-surround: Add, delete, and change surrounding characters
-- Examples: ds" (delete quotes), cs"' (change quotes), ysw" (add quotes to word)

return {
  "kylechui/nvim-surround", -- Text surrounding manipulation
  version = "*", -- Use stable releases
  event = { "BufReadPre", "BufNewFile" }, -- Load when opening files
  config = function()
    require("nvim-surround").setup({
      -- Using default configuration
      -- Provides intuitive keybindings for surrounding text operations
    })
  end,
}
