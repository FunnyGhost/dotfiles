-- Tool to navigate file system
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        hide_dotfiles = true,
        hide_gitignored = false,
      },
    },
    window = {
      position = "right",
    },
  },
  config = function()
    vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal right toggle<CR>", { desc = "Toggle File System" })
  end,
}
