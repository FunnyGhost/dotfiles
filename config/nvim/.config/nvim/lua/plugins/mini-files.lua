-- =====================================================
-- MINI.FILES - File Management Plugin
-- =====================================================
-- Lightweight, fast directory editing like a buffer

return {
  "echasnovski/mini.files",
  version = "*", -- Use latest stable version
  config = function()
    require("mini.files").setup({
      -- Customization of shown content
      content = {
        -- Predicate for which file system entries to show
        filter = nil,
        -- What prefix to show to the left of file system entry
        prefix = nil,
        -- In which order to show file system entries
        sort = nil,
      },

      -- Module mappings created only inside explorer.
      -- Use `''` (empty string) to not create one.
      mappings = {
        close       = 'q',
        go_in       = 'l',     -- Enter directory or open file
        go_in_plus  = 'L',     -- Enter directory or open file in new tab
        go_out      = 'h',     -- Go to parent directory
        go_out_plus = 'H',     -- Go to parent and close current
        reset       = '<BS>',  -- Reset to original directory
        reveal_cwd  = '@',     -- Reveal current working directory
        show_help   = 'g?',    -- Show help
        synchronize = '=',     -- Synchronize (save changes)
        trim_left   = '<',     -- Trim left (less content)
        trim_right  = '>',     -- Trim right (more content)
      },

      -- General options
      options = {
        -- Whether to delete permanently or move into module-specific trash
        permanent_delete = true,
        -- Whether to use for editing directories
        use_as_default_explorer = false,
      },

      -- Customization of explorer windows
      windows = {
        -- Maximum number of windows to show side by side
        max_number = math.huge,
        -- Whether to show preview of file/directory under cursor
        preview = false,
        -- Width of focused window
        width_focus = 50,
        -- Width of non-focused window
        width_nofocus = 15,
        -- Width of preview window
        width_preview = 25,
      },
    })

    -- Keymaps are configured in lua/keymaps.lua for centralized management

    -- Auto-create directories when creating files
    local files_set_cwd = function()
      -- Works only if cursor is on the valid file system entry
      local cur_entry_path = require("mini.files").get_fs_entry().path
      local cur_directory = vim.fs.dirname(cur_entry_path)
      if cur_directory ~= nil then
        vim.fn.chdir(cur_directory)
      end
    end

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        local buf_id = args.data.buf_id
        -- Tweak left-hand side of mapping to your liking
        vim.keymap.set("n", "g~", files_set_cwd, { buffer = buf_id, desc = "Set cwd" })
      end,
    })
  end,
}
