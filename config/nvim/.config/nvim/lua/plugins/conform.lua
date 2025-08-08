return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" }, -- Load before saving
	cmd = { "ConformInfo" },
	keys = {
		{
			-- Manual format
			"<leader>fm",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "[F]ormat [M]anually",
		},
	},
	opts = {
		-- Define formatters
		formatters_by_ft = {
			lua = { "stylua" },
			-- Web development
			javascript = { "prettierd", "prettier" },
			typescript = { "prettierd", "prettier" },
			javascriptreact = { "prettierd", "prettier" },
			typescriptreact = { "prettierd", "prettier" },
			vue = { "prettierd", "prettier" },
			css = { "prettierd", "prettier" },
			scss = { "prettierd", "prettier" },
			less = { "prettierd", "prettier" },
			html = { "prettierd", "prettier" },
			json = { "prettierd", "prettier" },
			jsonc = { "prettierd", "prettier" },
			yaml = { "prettierd", "prettier" },
			markdown = { "prettierd", "prettier" },
			["markdown.mdx"] = { "prettierd", "prettier" },
			graphql = { "prettierd", "prettier" },
			handlebars = { "prettierd", "prettier" },
			-- Rust
			rust = { "rustfmt" },
			-- Shell
			sh = { "shfmt" },
			bash = { "shfmt" },
			zsh = { "shfmt" },
			-- Go
			go = { "gofmt" },
			-- Python
			python = { "black" },
			-- Misc
			toml = { "taplo" },
		},
		-- Set up format-on-save
		format_on_save = {
			-- These options will be passed to conform.format()
			timeout_ms = 500,
			lsp_fallback = true,
			async = false, -- Not recommended to change
			stop_after_first = true, -- Stop after first formatter succeeds
		},
		-- Customize notify behavior
		notify_on_error = true,
	},
	init = function()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}