-- =====================================================
-- MASON - LSP SERVER AND TOOL MANAGER
-- =====================================================
-- Mason: Package manager for LSP servers, DAP servers, linters, and formatters
-- Provides easy installation and management of development tools

return {
	"williamboman/mason.nvim", -- Core mason package manager
	dependencies = {
		"williamboman/mason-lspconfig.nvim",   -- Bridge between mason and lspconfig
		"WhoIsSethDaniel/mason-tool-installer.nvim", -- Auto-install tools on startup
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		-- MASON UI CONFIGURATION
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",   -- Show checkmark for installed packages
					package_pending = "➜",     -- Show arrow for pending installations  
					package_uninstalled = "✗", -- Show X for uninstalled packages
				},
			},
		})

		-- LSP SERVERS TO AUTO-INSTALL
		-- These language servers provide intelligent code features
		mason_lspconfig.setup({
			ensure_installed = {
				"html",      -- HTML language server
				"cssls",     -- CSS language server
				"lua_ls",    -- Lua language server (for Neovim config)
				"emmet_ls",  -- Emmet abbreviations for HTML/CSS
				"prismals",  -- Prisma ORM language server
			},
		})

		-- DEVELOPMENT TOOLS TO AUTO-INSTALL
		-- These tools provide formatting and linting capabilities
		mason_tool_installer.setup({
			ensure_installed = {
				"prettier", -- Code formatter for JS/TS/CSS/HTML/JSON/YAML
				"stylua",   -- Lua code formatter
				"eslint_d", -- Fast ESLint daemon for JavaScript/TypeScript linting
			},
		})
	end,
}
