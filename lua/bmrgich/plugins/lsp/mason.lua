-- mason.lua
return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			--
			ensure_installed = {
				"tsserver",
				"html",
				"cssls",
				"tailwindcss",
				"svelte",
				"lua_ls",
				"graphql",
				"emmet_ls",
				"prismals",
				"pyright",
				"jdtls",
				"dockerls",
				-- "rust_analyzer",
				--"basedpyright",
				--"pylyzer",
			},
			automatic_installation = true,
		})

		mason_tool_installer.setup({
			ensure_installed = {
				-- Formatters
				"prettier",
				"stylua",
				"isort",
				--"basedpyright",
				"beautysh",
				"clang-format",
				-- "rust_analyzer",
				-- Linters
				"eslint_d",
				"ruff",
				"pyright",
				"cpplint",
				"htmlhint",
				"jsonlint",
				"luacheck",
				"markdownlint",
				"shellcheck",
				"bacon",
				"ast_grep",
			},
			auto_update = true,
			run_on_start = true,
			automatic_installation = true,
		})
	end,
}
