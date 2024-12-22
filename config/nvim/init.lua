local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
-- This appends the lazypath to the runtimepath
vim.opt.rtp:prepend(lazypath)

vim.filetype.add({
	extension = {
		mdx = "mdx",
		analog = "analog",
	},
})
vim.treesitter.language.register("markdown", "mdx")

require("vim-options")
require("keymaps")
require("lazy").setup({ { import  = "plugins" }, { import  = "plugins.lsp" } }, {
	change_detection = { notify = false },
})
