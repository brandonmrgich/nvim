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

require("lazy").setup({ { import = "bmrgich.plugins" }, { import = "bmrgich.plugins.lsp" } }, {
	-- Use lualine to show pending plugin updates through lazy.nvim
	checker = {
		enabled = true,
		notify = false,
	},
	-- Ignore the change detection notification
	change_detection = {
		notify = false,
	},
})

-- java decompiler jdtls
local config = {
	cmd = { "/opt/homebrew/bin/jdtls" },
	root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
}
require("jdtls").start_or_attach(config)
