return {
	"catppuccin/nvim",
	lazy = false,
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			integrations = {
				neotree = true,
			},
		})
		vim.cmd.colorscheme("catppuccin-mocha")
	end,
}
