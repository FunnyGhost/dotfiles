-- Used to print a nice welcome screen when opening NeoVim without a directory parameter
return {

  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                     ]],
      [[       ████ ██████           █████      ██                     ]],
      [[      ███████████             █████                             ]],
      [[      █████████ ███████████████████ ███   ███████████   ]],
      [[     █████████  ███    █████████████ █████ ██████████████   ]],
      [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
      [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
      [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
      [[                                                                       ]],
      [[                                                                       ]],
      [[                                                                       ]],
    }

    _Gopts = {
      position = "center",
      hl = "Type",
      -- wrap = "overflow";
    }

    dashboard.section.buttons.val = {
      dashboard.button("i", "    new file", ":ene <BAR> startinsert<CR>"),
      dashboard.button("o", "    old files", ":Telescope oldfiles<CR>"),
      dashboard.button("f", "󰥨    find file", ":Telescope find_files<CR>"),
      dashboard.button("g", "󰱼    find text", ":Telescope live_grep<CR>"),
      dashboard.button("l", "󰒲    lazy", ":Lazy<CR>"),
      dashboard.button("m", "󱌣    mason", ":Mason<CR>"),
      dashboard.button("p", "󰄉    profile", ":Lazy profile<CR>"),
      dashboard.button("q", "󰭿    quit", ":qa<CR>"),
    }

    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = "Normal"
      button.opts.hl_shortcut = "Function"
    end

    local function footer()
      return "Haskell can suck mo' nads"
    end

    dashboard.section.footer.val = footer()

    dashboard.opts.opts.noautocmd = true
    alpha.setup(dashboard.opts)
  end,
}
