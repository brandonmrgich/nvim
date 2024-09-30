return {
	"tiagovla/tokyodark.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd("colorscheme tokyodark")
		--vim.cmd("colorscheme retrobox")
	end,
}
