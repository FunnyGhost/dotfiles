return {
	"stevearc/oil.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("oil").setup({
			view_options = {
				show_hidden = true,
			},
			-- Open the parent directory of the current file
			vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" }),
		})
	end,
}
