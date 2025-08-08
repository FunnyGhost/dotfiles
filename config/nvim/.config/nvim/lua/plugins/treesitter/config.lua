-- =====================================================
-- TREESITTER CONFIGURATION
-- =====================================================
-- Core Treesitter setup for better syntax understanding

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
  keys = {
    { "<leader>ti", "<cmd>TSInstallInfo<cr>", desc = "[T]reesitter [I]nfo" },
  },
  opts = {
    -- A list of parser names, or "all" (parsers with maintainers)
    ensure_installed = {
      -- Web development
      "typescript",
      "javascript",
      "tsx",
      "html",
      "css",
      "json",
      "yaml",
      "toml",
      "graphql",
      
      -- Configuration
      "lua",
      "vim",
      "vimdoc",
      "query",
      "markdown",
      "markdown_inline",
      
      -- General purpose
      "regex",
      "bash",
      "dockerfile",
      "gitignore",
      "git_config",
      "git_rebase",
      "diff",
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    auto_install = false,

    -- List of parsers to ignore installing (or "all")
    ignore_install = {},

    highlight = {
      enable = true,
      
      -- NOTE: these are the names of the parsers and not the filetype
      disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,

      additional_vim_regex_highlighting = false,
    },

    indent = {
      enable = true,
      disable = { "yaml" }, -- Disable for YAML (can be buggy)
    },

    -- Incremental selection disabled (can be enabled later if needed)
    incremental_selection = {
      enable = false,
    },

    -- Treesitter based folding
    fold = {
      enable = true,
    },
  },
  config = function(_, opts)
    -- Defer Treesitter setup until after first render to improve startup time
    vim.defer_fn(function()
      require("nvim-treesitter.configs").setup(opts)
      
      -- Set foldmethod to expr after Treesitter is loaded
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      -- Start with all folds open
      vim.opt.foldenable = false
    end, 0)
  end,
}
