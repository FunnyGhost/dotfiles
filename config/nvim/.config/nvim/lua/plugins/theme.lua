-- =====================================================
-- ELDTRITCH THEME - Colorscheme setup
-- =====================================================
-- Loads early with high priority and applies the colorscheme.

return {
  "eldritch-theme/eldritch.nvim",
  lazy = false,          -- Load during startup
  priority = 1000,       -- Ensure it loads before other UI plugins
  opts = {
    -- Keep defaults for now; we can tweak later (e.g., transparent)
    terminal_colors = true,
  },
  config = function(_, opts)
    -- Setup first (allows future customization), then set colorscheme
    require("eldritch").setup(opts)
    pcall(vim.cmd.colorscheme, "eldritch")
  end,
}


