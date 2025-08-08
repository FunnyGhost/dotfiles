-- =====================================================
-- WHICH-KEY - KEYBINDING HINTS AND DISCOVERY
-- =====================================================
-- Which-key: Shows available keybindings in a popup when you start typing a command
-- Essential for discovering and remembering complex keybinding combinations

return {
	"folke/which-key.nvim", -- Keybinding hint system
	event = "VeryLazy", -- Load after other plugins to capture all keybindings
	init = function()
		-- TIMEOUT CONFIGURATION
		-- These settings control when the which-key popup appears
		vim.o.timeout = true -- Enable timeout for key sequences
		vim.o.timeoutlen = 300 -- Show which-key popup after 300ms of inactivity
	end,
	opts = {
		-- Using default configuration
		-- which-key will automatically detect and display all registered keybindings
		-- Custom configuration can be added here if needed
	},
}