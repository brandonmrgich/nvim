return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				svelte = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "yamlfmt" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				liquid = { "prettier" },
				lua = { "stylua" },
				python = { "pyright" }, --, "black", "isort", "pyright", "ruff"
				cpp = { "astyle" },
				c = { "astyle" },
				java = { "astyle" },
				objectivec = { "astyle" },
				csharp = { "astyle" },
				sh = { "shfmt" },
				zsh = { "shfmt" },
				-- rust = { "rust_analyzer", "bacon_ls" },
			},
			format_on_save = {
				lsp_fallback = true, -- Use LSP if available for formatting
				async = false, -- Use asynchronous formatting
				timeout_ms = 1000, -- Formatting timeout in milliseconds
			},
			-- Config per formatter

			formatters = {
				-- TODO: Make quotes persist
				prettier = {
					args = {
						"--stdin-filepath",
						"$FILENAME",
						"--single-quote",
						"--tab-width",
						"4",
						"--trailing-comma",
						"es5",
						"--print-width",
						"100",
						"--quote-props",
						"consistent",
					},
				},
				black = {
					args = { "--line-length", "100" },
				},
				astyle = {
					args = { "--max-code-length", "100" },
				},
				shfmt = {
					args = { "-i", "100" },
				},
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false, -- Use asynchronous formatting to avoid blocking
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
