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
				"ts_ls",
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

		local ensure_tools = {
				-- Formatters
				"prettier",
				"stylua",
				"black",
				"isort",
				"shfmt",
				"yamlfmt",
				"google-java-format",
				--"basedpyright",
				"beautysh",
				"clang-format",
				-- "rust_analyzer",
				-- Linters
				"eslint_d",
				"ruff",
				"yamllint",
				"cpplint",
				"htmlhint",
				"jsonlint",
				"luacheck",
				"markdownlint",
				"shellcheck",
				"hadolint",
				"bacon",
				"ast_grep",
		}

		-- csharpier is a dotnet tool; only attempt install if dotnet exists.
		if vim.fn.exepath("dotnet") ~= "" then
			table.insert(ensure_tools, "csharpier")
		end

		mason_tool_installer.setup({
			ensure_installed = ensure_tools,
			auto_update = true,
			run_on_start = true,
			automatic_installation = true,
		})
	end,
}
