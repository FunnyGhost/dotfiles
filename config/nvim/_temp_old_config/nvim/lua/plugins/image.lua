-- =====================================================
-- IMAGE.NVIM - TERMINAL IMAGE DISPLAY
-- =====================================================
-- Image.nvim: Display images directly in terminal Neovim
-- Supports viewing images in markdown files, neorg documents, and standalone image files
-- Requires a compatible terminal (like Kitty) that supports image protocols

return {
	"3rd/image.nvim", -- Terminal image display plugin
	dependencies = { "luarocks.nvim" }, -- Required for image processing libraries
	config = function()
		require("image").setup({
			-- BACKEND CONFIGURATION
			backend = "kitty", -- Use Kitty terminal's image protocol (most reliable)
			
			-- INTEGRATION WITH MARKUP LANGUAGES
			integrations = {
				-- MARKDOWN SUPPORT
				markdown = {
					enabled = true,                    -- Enable image display in markdown
					clear_in_insert_mode = false,     -- Keep images visible while editing
					download_remote_images = true,    -- Download and display images from URLs
					only_render_image_at_cursor = false, -- Show all images, not just at cursor
					filetypes = { "markdown", "vimwiki" }, -- File types to enable markdown integration
				},
				-- NEORG SUPPORT (if using neorg for note-taking)
				neorg = {
					enabled = true,                    -- Enable image display in neorg
					clear_in_insert_mode = false,     -- Keep images visible while editing
					download_remote_images = true,    -- Download and display images from URLs
					only_render_image_at_cursor = false, -- Show all images, not just at cursor
					filetypes = { "norg" },           -- Neorg file extension
				},
			},
			
			-- IMAGE DISPLAY CONSTRAINTS
			max_width = nil,                      -- No maximum width limit
			max_height = nil,                     -- No maximum height limit
			max_width_window_percentage = nil,    -- No width percentage limit
			max_height_window_percentage = 50,    -- Limit images to 50% of window height
			
			-- WINDOW MANAGEMENT
			window_overlap_clear_enabled = false, -- Don't hide images when windows overlap
			window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" }, -- File types to ignore for overlap clearing
			
			-- FOCUS BEHAVIOR
			editor_only_render_when_focused = false, -- Always show images, regardless of focus
			
			-- TMUX INTEGRATION
			tmux_show_only_in_active_window = false, -- Show images in all tmux windows
			
			-- FILE TYPE HIJACKING
			-- Automatically display these image files as images when opened
			hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
		})
	end,
}
