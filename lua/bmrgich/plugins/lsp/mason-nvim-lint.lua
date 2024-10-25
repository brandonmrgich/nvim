return {
	"rshkarin/mason-nvim-lint",
	dependencies = {
		"williamboman/mason.nvim",
		"mfussenegger/nvim-lint",
	},

	ensure_installed = {
		"eslint_d",
		"ruff",
		"ansible_lint",
		"cpplint",
		"htmlhint",
		"jsonlint",
		"luacheck",
		"markdownlint",
		"swiftlint",
		"shellcheck",
		--"pylint",
		-- "basedpyright",
		-- "rust_analyzer",
		-- "ast_grep",
	},

	config = function()
		require("mason-nvim-lint").setup()
	end,
}
