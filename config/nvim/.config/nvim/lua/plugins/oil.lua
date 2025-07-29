-- =====================================================
-- OIL.NVIM - BUFFER-BASED FILE MANAGER
-- =====================================================
-- Oil: Treats directories like buffers, allowing you to edit file systems like text
-- Alternative to traditional file explorers - you can rename, delete, create files by editing the buffer

return {
	"stevearc/oil.nvim", -- Buffer-based file manager
	dependencies = {
		"nvim-tree/nvim-web-devicons", -- File type icons for visual file recognition
	},
	config = function()
		require("oil").setup({
			view_options = {
				show_hidden = true, -- Show hidden files and directories (dotfiles)
			},
		})
		
		-- KEYBINDING FOR QUICK ACCESS
		-- Open the parent directory of the current file in a buffer
		-- You can then edit the directory like a text file to rename/delete/create files
		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory in Oil" })
	end,
}
