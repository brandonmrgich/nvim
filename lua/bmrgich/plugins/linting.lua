local vim = vim
local pattern = "[^:]+:(%d+):(%d+)-(%d+): %((%a)(%d+)%) (.*)"
local groups = { "lnum", "col", "end_col", "severity", "code", "message" }
local severities = {
	W = vim.diagnostic.severity.WARN,
	E = vim.diagnostic.severity.ERROR,
}

return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			svelte = { "eslint_d" },
			python = { "pylint" },
			ansible = { "ansible-lint" },
			cpp = { "cpplint" },
			html = { "hlint" }, --"htmlhint"
			json = { "jsonlint" },
			lua = { "luacheck" },
			markdown = { "markdownlint" },
			ruby = { "ruby" },
			swift = { "swiftlint" },
			zsh = { "zsh" },
		}
		lint.linters = {
			luacheck = {
				name = "luacheck",
				cmd = "luacheck",
				stdin = true,
				args = {
					"--globals",
					"vim",
					"lvim",
					"reload",
					"--",
					"--formatter",
					"plain",
					"--codes",
					"--ranges",
					"-",
				},
				ignore_exitcode = true,
				parser = require("lint.parser").from_pattern(
					pattern,
					groups,
					severities,
					{ ["source"] = "luacheck" },
					{ end_col_offset = 0 }
				),
			},
		}
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
