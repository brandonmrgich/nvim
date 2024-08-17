local vim = vim

-- linting.lua
return {
	"mfussenegger/nvim-lint",
	-- dependencies = {
	-- 	"linux-cultist/venv-selector.nvim",
	-- },
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			svelte = { "eslint_d" },
			python = { "ruff" }, -- pylint -- ruff
			cpp = { "cpplint" },
			html = { "htmlhint" },
			json = { "jsonlint" },
			lua = { "luacheck" },
			markdown = { "markdownlint" },
			zsh = { "shellcheck" },
			sh = { "shellcheck" },
			yaml = { "yamllint" },
			dockerfile = { "hadolint" },
			-- rust = { "rust_analyzer", "ast_grep" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				local filetype = vim.bo.filetype
				local linters = lint.linters_by_ft[filetype] or {}
				if #linters > 0 then
					lint.try_lint()
					-- print("Linting " .. filetype .. " with: " .. table.concat(linters, ", "))
				else
					print("No linters configured for filetype: " .. filetype)
				end
			end,
		})

		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
