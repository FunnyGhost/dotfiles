return {
"gbprod/substitute.nvim",
event = {"BufReadPre", "BufNewFile"},
  config = function()
    local substitute = require("substitute")
    substitute.setup()

    -- set keymaps
    local keymap = vim.keymap
    keymap.set("n", "s", substitute.operator, {desc = "[s]ubstitute with motion"})
    keymap.set("n", "ss", substitute.line, {desc = "[s]ubstitute line"})
  end
}
