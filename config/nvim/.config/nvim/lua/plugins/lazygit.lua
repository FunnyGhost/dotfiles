-- =====================================================
-- LAZYGIT INTEGRATION
-- =====================================================
-- Fast and powerful Git UI for Neovim

return {
	"kdheepak/lazygit.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{
			"<leader>lg",
			"<cmd>LazyGit<CR>",
			desc = "[L]azy[G]it",
		},
	},
}
