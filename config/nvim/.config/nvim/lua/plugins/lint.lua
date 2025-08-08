-- =====================================================
-- NVIM-LINT - ASYNCHRONOUS LINTING
-- =====================================================
-- Provides async linting support with focus on ESLint integration
-- Uses project-local ESLint when available

return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "eslint" },
			typescript = { "eslint" },
			javascriptreact = { "eslint" },
			typescriptreact = { "eslint" },
			svelte = { "eslint" },
			vue = { "eslint" },
		}

		-- Configure eslint to use local installation first
		lint.linters.eslint.args = {
			"--format",
			"json",
			"--stdin",
			"--stdin-filename",
			function()
				return vim.api.nvim_buf_get_name(0)
			end,
		}

		-- Create an autocmd group for linting
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		-- Trigger linting on events
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				-- Only lint if the buffer is modifiable
				if vim.bo.modifiable then
					lint.try_lint()
				end
			end,
		})
	end,
}
