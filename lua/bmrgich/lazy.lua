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

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
	{ import = "bmrgich.plugins" },
	{ import = "bmrgich.plugins.lsp" },
	{ import = "bmrgich.plugins.ui" },
	{ import = "bmrgich.plugins.util" },
}, {

	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },

	-- Use lualine to show pending plugin updates through lazy.nvim
	-- Import Lazy.nvim
	checker = {
		enabled = true,
		notify = true,
	},
	-- Ignore the change detection notification
	change_detection = {
		notify = true,
	},
	performance = {
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				"gzip",
				-- "matchit",
				-- "matchparen",
				-- "netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
