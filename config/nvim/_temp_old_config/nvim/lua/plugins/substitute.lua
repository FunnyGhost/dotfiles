-- =====================================================
-- SUBSTITUTE.NVIM - ENHANCED TEXT REPLACEMENT
-- =====================================================
-- Substitute: Provides better text substitution operations with visual feedback
-- Enhances Vim's substitute functionality with exchange operations and visual previews

return {
  "gbprod/substitute.nvim", -- Enhanced text substitution plugin
  event = { "BufReadPre", "BufNewFile" }, -- Load when opening files
  config = function()
    local substitute = require("substitute")

    substitute.setup()

    -- KEYBINDINGS FOR SUBSTITUTE OPERATIONS
    local keymap = vim.keymap

    -- Substitute text motion/selection
    keymap.set("n", "s", substitute.operator, { desc = "Substitute with motion" })
    keymap.set("n", "ss", substitute.line, { desc = "Substitute line" })
    keymap.set("n", "S", substitute.eol, { desc = "Substitute to end of line" })
    keymap.set("x", "s", substitute.visual, { desc = "Substitute selection" })
  end,
}
