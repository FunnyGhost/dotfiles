-- =====================================================
-- CODE FORMATTING WITH CONFORM.NVIM
-- =====================================================
-- Conform: Modern formatter plugin that provides consistent code formatting
-- Automatically formats code using language-specific tools like Prettier and Stylua

return {
	"stevearc/conform.nvim", -- Modern formatting plugin
	event = { "BufReadPre", "BufNewFile" }, -- Load when opening files
	config = function()
		local conform = require("conform")

		conform.setup({
			-- FORMATTER CONFIGURATION BY FILE TYPE
			-- Maps file types to their respective formatting tools
			formatters_by_ft = {
				-- WEB DEVELOPMENT (using Prettier for consistency)
				javascript = { "prettier" },     -- JavaScript files
				typescript = { "prettier" },     -- TypeScript files
				javascriptreact = { "prettier" }, -- JSX files
				typescriptreact = { "prettier" }, -- TSX files (React with TypeScript)
				css = { "prettier" },            -- CSS stylesheets
				html = { "prettier" },           -- HTML markup
				json = { "prettier" },           -- JSON data files
				yaml = { "prettier" },           -- YAML configuration files
				markdown = { "prettier" },       -- Markdown documentation
				
				-- LUA (using Stylua for Neovim/Lua development)
				lua = { "stylua" }, -- Lua files (including Neovim config)
			},
		})

		-- FORMAT KEYBINDING
		-- Manual formatting trigger (works in normal and visual mode)
		vim.keymap.set({ "n", "v" }, "<leader>gf", function()
			conform.format({
				lsp_fallback = true,  -- Use LSP formatting if no formatter is configured
				async = false,        -- Format synchronously to ensure completion
				timeout_ms = 1000,    -- Maximum time to wait for formatting
			})
		end, { desc = "[G]o [F]ormat file/selection" })
	end,
}
