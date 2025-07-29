-- =====================================================
-- COLORSCHEME CONFIGURATION
-- =====================================================
-- Eldritch theme: A dark, modern colorscheme with vibrant colors
-- Provides good contrast and readability for long coding sessions

return {
  "eldritch-theme/eldritch-nvim", -- Modern dark theme with excellent syntax highlighting
  opts = {}, -- Using default theme options (can be customized here)
  priority = 1000, -- Load theme early to prevent UI flashing
  config = function(opts)
    local eldritch = require("eldritch")
    eldritch.setup(opts)
    vim.cmd("colorscheme eldritch") -- Apply the colorscheme immediately
  end,
}
