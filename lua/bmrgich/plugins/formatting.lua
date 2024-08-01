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
                yaml = { "prettier" },
                markdown = { "prettier" },
                graphql = { "prettier" },
                liquid = { "prettier" },
                -- lua = { "stylua" },
                python = { "black" }, -- `isort` is typically used for sorting imports, not for formatting
                cpp = { "astyle" },
                c = { "astyle" },
                java = { "astyle" },
                objectivec = { "astyle" },
                csharp = { "astyle" },
                sh = { "shfmt" },
                zsh = { "shfmt" },
            },
            format_on_save = {
                lsp_fallback = true, -- Use LSP if available for formatting
                async = false,       -- Use asynchronous formatting
                timeout_ms = 1000,   -- Formatting timeout in milliseconds
            },
            formatters = {
                prettier = {
                    inherit = false,
                    command = "prettier",
                    args = { "--tab-width", "4", "--use-tabs", "false", "--stdin-filepath", "$FILENAME" },
                },
                -- stylua = {
                -- 	inherit = false,
                -- 	command = "stylua",
                -- 	args = { "--indent-width", "4", "--stdin-filepath",  "$FILENAME" }, -- `--stdin` to read from standard input
                -- },
                black = {
                    inherit = false,
                    command = "black",
                    args = { "--line-length", "79", "-" }, -- `-` for reading from stdin
                },
                -- TODO:
                -- astyle = { inherit = false,
                --     command = "astyle",
                --     -- "--indent=spaces=4",
                --     args = { "--style=allman", "--stdin=$FILENAME" },
                -- },
                shfmt = {
                    inherit = false,
                    command = "shfmt",
                    args = { "-i", "4", "-filename", "$FILENAME" },
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
