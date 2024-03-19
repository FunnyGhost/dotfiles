return {
  {
    "maxmx03/fluoromachine.nvim",
    config = function()
      local fm = require("fluoromachine")

      fm.setup({
        glow = true,
        theme = "delta",
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "fluoromachine",
    },
  },
  -- add telescope-fzf-native
  {
    "telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },
  {
    "hrsh7th/nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-y>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<CR>"] = cmp.mapping.abort(),
      })
    end,
  },
}
