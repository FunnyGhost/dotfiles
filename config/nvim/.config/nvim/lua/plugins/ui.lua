-- =====================================================
-- UI ENHANCEMENTS
-- =====================================================
-- A collection of plugins to improve the UI experience

return {
  -- Theme: Eldritch
  {
    "eldritch-theme/eldritch.nvim",
    lazy = false, -- Load immediately
    priority = 1000, -- Load before other plugins
    opts = {
      -- Theme customization options
      transparent = false, -- Set to true if you want transparent background
      terminal_colors = true, -- Configure terminal colors
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
      },
      hide_inactive_statusline = false,
      dim_inactive = false,
      lualine_bold = false,
    },
    config = function(_, opts)
      -- Enable 24-bit color
      vim.opt.termguicolors = true
      
      -- Load and configure the theme
      require("eldritch").setup(opts)
      
      -- Set colorscheme
      vim.cmd.colorscheme("eldritch")
    end,
  },

  -- Statusline: Lualine
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "eldritch", -- Match our colorscheme
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            "branch",
            {
              "diff",
              colored = true,
              diff_color = {
                added = { fg = "#98c379" },
                modified = { fg = "#e5c07b" },
                removed = { fg = "#e06c75" },
              },
            },
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              sections = { "error", "warn", "info", "hint" },
              diagnostics_color = {
                error = { fg = "#e06c75" },
                warn = { fg = "#e5c07b" },
                info = { fg = "#61afef" },
                hint = { fg = "#98c379" },
              },
            },
          },
          lualine_c = {
            { "filename", path = 1 }, -- Relative path
            {
              "filesize",
              cond = function() return vim.fn.getfsize(vim.fn.expand("%:p")) > 0 end,
            },
          },
          lualine_x = {
            "encoding",
            { "fileformat", icons_enabled = true },
            "filetype",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = {
          "fzf",
          "lazy",
          "man",
          "quickfix",
        },
      })
    end,
  },



  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
  },
}
