-- =====================================================
-- FZF-LUA - Fuzzy Finder Plugin
-- =====================================================
-- Fast, efficient fuzzy finding for files, grep, and more
-- Using Eldritch theme colors for consistency

return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("fzf-lua").setup({
			-- Use telescope-like UI
			winopts = {
				height = 0.90, -- Window height
				width = 0.90, -- Window width
				row = 0.35, -- Window row position (0=top, 1=bottom)
				col = 0.50, -- Window col position (0=left, 1=right)
				border = "rounded", -- Rounded border
				preview = {
					scrollbar = false, -- Disable scrollbar for cleaner look
					default = "builtin",
					border = "rounded", -- Rounded border for preview
					wrap = "nowrap",
					hidden = "nohidden",
					vertical = "down:65%", -- Larger preview
					horizontal = "right:50%",
					layout = "flex",
					flip_columns = 120,
					title = true, -- Show file names in preview
					title_pos = "left", -- Left-aligned titles
					scrollbar_char = "", -- Hide scrollbar character
					delay = 100, -- Faster preview
				},
			},

			-- Highlight groups
			hls = {
				normal = "Normal", -- Base highlight group
				border = "FloatBorder", -- Border highlight
				help_normal = "Normal", -- Help text
				help_border = "FloatBorder", -- Help border
				preview_normal = "Normal", -- Preview text
				preview_border = "FloatBorder", -- Preview border
				cursorline = "CursorLine", -- Selected line
				cursorlinesel = "CursorLine", -- Selected line in preview
				search = "IncSearch", -- Search matches
			},

			keymap = {
				builtin = {
					["<C-d>"] = "preview-page-down",
					["<C-u>"] = "preview-page-up",
					["<C-j>"] = "next-history",
					["<C-k>"] = "previous-history",
				},
			},

			-- Global fzf styling using Eldritch colors
			fzf_opts = {
				["--ansi"] = "",
				["--info"] = "inline-right", -- Show info on the right
				["--layout"] = "reverse", -- Bottom-up layout
				["--border"] = "none", -- No border (we use the window border)
				["--margin"] = "0,0", -- No margin
				["--padding"] = "1,2", -- Comfortable padding
				["--pointer"] = "●", -- Nice pointer
				["--marker"] = "✓", -- Nice marker
				["--header-first"] = "", -- Header at top
				["--color"] = table.concat({
					"fg:#ebfafa", -- Lighthouse White for text
					"bg:-1",
					"preview-fg:#ebfafa", -- Lighthouse White for preview text
					"preview-bg:-1",
					"hl:#a48cf2", -- Lovecraft Purple for highlights
					"hl+:#a48cf2",
					"gutter:-1",
					"pointer:#37f499", -- Great Old One Green for pointer
					"marker:#f265b5", -- Pustule Pink for marker
					"border:#323449", -- Shallow Depths Grey for borders
					"header:#7081d0", -- The Old One Purple for header
					"info:#f7c67f", -- Dreaming Orange for info
					"spinner:#37f499", -- Great Old One Green for spinner
					"prompt:#a48cf2", -- Lovecraft Purple for prompt
				}, ","),
			},

			-- Files
			files = {
				prompt = " Files ❯ ",
				cmd = "fd --type f --hidden --follow --exclude .git",
				git_icons = true,
				file_icons = true,
				color_icons = true,
				actions = {
					["default"] = require("fzf-lua.actions").file_edit,
				},
			},

			-- Recent files (oldfiles)
			oldfiles = {
				prompt = " History ❯ ",
				cwd_only = true,
				stat_file = true,
				include_current_session = true,
				file_icons = true,
				git_icons = true,
				color_icons = true,
			},

			-- Buffers
			buffers = {
				prompt = " Buffers ❯ ",
				file_icons = true,
				color_icons = true,
				sort_lastused = true,
			},

			-- Live grep
			live_grep = {
				prompt = " Grep ❯ ",
				file_icons = true,
				git_icons = true,
				color_icons = true,
				cmd = "rg --column --line-number --no-heading --color=always --smart-case --max-columns=4096",
			},

			-- Git integration
			git = {
				files = {
					prompt = " Git Files ❯ ",
					cmd = "git ls-files --exclude-standard",
					git_icons = true,
					file_icons = true,
					color_icons = true,
				},
				status = {
					prompt = " Git Status ❯ ",
					cmd = "git status --porcelain=v1",
					git_icons = true,
					file_icons = true,
					color_icons = true,
				},
				commits = {
					prompt = " Git Commits ❯ ",
					cmd = "git log --pretty=oneline --abbrev-commit --color",
					preview = "git show --pretty='%Cred%H%n%Cblue%an%n%Cgreen%s' --color {1}",
				},
			},

			-- LSP
			lsp = {
				prompt_postfix = " ❯ ",
				git_icons = true,
				file_icons = true,
				color_icons = true,
				symbols = {
					symbol_style = 1,
					symbol_hl = "Function", -- Better symbol highlighting
				},
				code_actions = {
					prompt = " Code Actions ❯ ",
					winopts = {
						relative = "cursor", -- Show near the cursor
						row = 1,
						col = 1,
						border = "rounded",
					},
				},
			},
		})
	end,
}