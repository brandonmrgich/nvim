return {
	"linux-cultist/venv-selector.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"mfussenegger/nvim-dap",
		"mfussenegger/nvim-dap-python",
	},
	lazy = false,
	branch = "regexp", -- This is the regexp branch, use this for the new version
	config = function()
		require("venv-selector").setup({
			settings = {
				search = {
					-- cwd = {
					--     command = ""
					-- },
					my_venvs = {
						command = "fd python$ $CWD --full-path --color never -E /proc -I -a -L",
					},
				},
			},
		})
	end,
	keys = {
		{ ",v", "<cmd>VenvSelect<cr>" },
	},
}
