return {
	"vim-test/vim-test",
	config = function()
		vim.keymap.set(
			{ "n", "v" },
			"<leader>tc",
			":TestNearest -strategy=wezterm<CR>",
			{ desc = "[t]est under [c]ursor" }
		)
		vim.keymap.set({ "n", "v" }, "<leader>tf", ":TestFile -strategy=wezterm<CR>", { desc = "[t]est [f]ile" })
	end,
}
