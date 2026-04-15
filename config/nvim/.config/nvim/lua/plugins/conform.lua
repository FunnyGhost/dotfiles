-- =====================================================
-- CONFORM.NVIM - CODE FORMATTING
-- =====================================================
-- Provides async formatting with project-local formatters

---Select JS/TS formatter based on project config
---@param bufnr integer
---@return string[]
local function select_js_formatter(bufnr)
	local conform = require("conform")

	-- Get buffer's directory for upward search
	local bufname = vim.api.nvim_buf_get_name(bufnr)
	local dirname = vim.fn.fnamemodify(bufname, ":h")

	-- Priority 1: Check for oxfmt config
	local oxfmt_configs = { ".oxfmtrc.json", ".oxfmtrc.jsonc" }
	local oxfmt_found = vim.fs.find(oxfmt_configs, {
		upward = true,
		path = dirname,
		limit = 1,
	})[1]

	if oxfmt_found then
		-- Verify oxfmt is available before returning
		if conform.get_formatter_info("oxfmt", bufnr).available then
			return { "oxfmt" }
		end
	end

	-- Priority 2: Check for prettier config
	local prettier_configs = {
		".prettierrc",
		".prettierrc.json",
		".prettierrc.yml",
		".prettierrc.yaml",
		".prettierrc.js",
		".prettierrc.cjs",
		".prettierrc.mjs",
		"prettier.config.js",
		"prettier.config.cjs",
	}

	local prettier_found = vim.fs.find(prettier_configs, {
		upward = true,
		path = dirname,
		limit = 1,
	})[1]

	if prettier_found then
		return { "prettierd", "prettier", stop_after_first = true }
	end

	-- Default: use prettier (most common)
	return { "prettier" }
end

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" }, -- Load before saving
	cmd = { "ConformInfo" },
	keys = {
		{
			-- Manual format
			"<leader>cf",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "[C]ode [F]ormat",
		},
	},
	opts = {
		-- Define formatters
		formatters_by_ft = {
			lua = { "stylua" },
			-- Web development - DYNAMIC SELECTION (oxfmt vs prettier)
			javascript = select_js_formatter,
			typescript = select_js_formatter,
			javascriptreact = select_js_formatter,
			typescriptreact = select_js_formatter,
			vue = select_js_formatter,
			css = select_js_formatter,
			scss = select_js_formatter,
			less = select_js_formatter,
			html = select_js_formatter,
			json = select_js_formatter,
			jsonc = select_js_formatter,
			yaml = select_js_formatter,
			markdown = select_js_formatter,
			["markdown.mdx"] = select_js_formatter,
			graphql = select_js_formatter,
			handlebars = select_js_formatter,
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