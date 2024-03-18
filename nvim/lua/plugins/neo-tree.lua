-- Tool to navigate file system
return {
  "nvim-neo-tree/neo-tree.nvim",
  config = function()
    vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal right toggle<CR>", { desc = "Toggle File System" })
  end,
}
