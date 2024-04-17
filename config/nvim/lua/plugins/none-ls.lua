return {}
-- -- This allows us to format and check our code. Uses the LSP under the hood
-- return {
-- 	"nvimtools/none-ls.nvim",
-- 	event = { "BufReadPre", "BufNewFile" },
-- 	config = function()
-- 		local null_ls = require("null-ls")

-- 		null_ls.setup({
-- 			sources = {
-- 				null_ls.builtins.formatting.stylua,
-- 				null_ls.builtins.formatting.prettier,
-- 				null_ls.builtins.diagnostics.eslint_d,
-- 			},
-- 		})
-- 	end,
-- }
