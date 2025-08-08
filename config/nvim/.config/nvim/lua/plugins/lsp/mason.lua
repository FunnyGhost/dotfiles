-- =====================================================
-- MASON: Package Manager for LSP Servers
-- =====================================================
-- Portable package manager for LSP servers, DAP servers, linters, and formatters

return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "[C]ore [M]ason" } },
  build = ":MasonUpdate",
  opts = {
    ensure_installed = {
      -- LSP
      "lua-language-server", -- Lua
      "vtsls",              -- TypeScript (optimized for large codebases)
    },
    ui = {
      border = "rounded",
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  },
  config = function(_, opts)
    require("mason").setup(opts)
    
    -- Auto-install configured servers
    local mr = require("mason-registry")
    for _, tool in ipairs(opts.ensure_installed) do
      local p = mr.get_package(tool)
      if not p:is_installed() then
        p:install()
      end
    end
  end,
}
