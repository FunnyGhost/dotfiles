-- Theme for the whole NeoVim UI + theme for some integrations
return {
  "eldritch-theme/eldritch-nvim",
  opts = {},
  priority = 1000,
  config = function(opts)
    local eldritch = require("eldritch")
    eldritch.setup(opts)
    vim.cmd("colorscheme eldritch")
  end,
}
