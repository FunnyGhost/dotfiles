-- This highlights the whole document
return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  build = ":TSUpdate",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local treesitter = require("nvim-treesitter.configs")

    treesitter.setup({
      -- enable syntax highlighting
      highlight = { enable = true },
      -- enable indentation
      indent = { enable = true },
      -- enable autotagging (with the nvim-ts-autotag plugin)
      autotag = { enable = true },
      auto_install = true,
      ensure_installed = {
        "javascript",
        "typescript",
        "json",
        "html",
        "tsx",
        "css",
        "yaml",
        "prisma",
        "markdown",
        "norg",
        "markdown_inline",
        "dockerfile",
        "gitignore",
        "bash",
        "vim",
        "vimdoc",
        "lua",
        "git_config"
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",
          scope_incremental = "<CR>",
          node_incremental = "<TAB>",
          node_decremental = "<S-TAB>",
        },
      },
    })
  end,
}
