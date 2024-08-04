return {
	"rshkarin/mason-nvim-lint",
	dependencies = {
		"williamboman/mason.nvim",
		"mfussenegger/nvim-lint",
	},

	ensure_installed = {
		"eslint_d",
		"ruff",
		"ansible-lint",
		"cpplint",
		"htmlhint",
		"jsonlint",
		"luacheck",
		"markdownlint",
		"swiftlint",
		"shellcheck",
	},

	config = function()
		require("mason-nvim-lint").setup()
	end,
}
