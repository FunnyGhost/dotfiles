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

		-- Find the project's own eslint by walking up from the file, not from
		-- nvim's cwd. Returns the binary and the project root, or nil.
		local function find_eslint(bufnr)
			for dir in vim.fs.parents(vim.api.nvim_buf_get_name(bufnr)) do
				local bin = dir .. "/node_modules/.bin/eslint"
				if vim.uv.fs_stat(bin) then
					return bin, dir
				end
			end
		end

		lint.linters.eslint.cmd = function()
			return find_eslint(0) or "eslint"
		end

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
				if not vim.bo.modifiable then
					return
				end
				-- Projects without eslint installed are skipped, not errored
				local _, root = find_eslint(0)
				if vim.tbl_contains(lint.linters_by_ft[vim.bo.filetype] or {}, "eslint") and not root then
					return
				end
				lint.try_lint(nil, { cwd = root })
			end,
		})
	end,
}
