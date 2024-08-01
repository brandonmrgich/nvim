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
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(
	{ { import = "bmrgich.plugins" }, { import = "bmrgich.plugins.lsp" }, { import = "bmrgich.plugins.theme" } },
	{
		-- Use lualine to show pending plugin updates through lazy.nvim
		checker = {
			enabled = true,
			notify = false,
		},
		-- Ignore the change detection notification
		change_detection = {
			notify = false,
		},
	}
)
