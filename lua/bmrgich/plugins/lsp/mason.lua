return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",         -- Integration between Mason and nvim-lspconfig
        "WhoIsSethDaniel/mason-tool-installer.nvim", -- Automatic tool installation using Mason
    },
    config = function()
        -- Load required modules
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local mason_tool_installer = require("mason-tool-installer")

        -- Mason setup with UI customization
        mason.setup({
            ui = {
                icons = {
                    package_installed = "✓", -- Icon for installed packages
                    package_pending = "➜", -- Icon for packages being installed
                    package_uninstalled = "✗", -- Icon for uninstalled packages
                },
            },
        })

        -- Mason LSPConfig setup to manage LSP server installation
        mason_lspconfig.setup({
            -- Automatically install missing servers when setting up LSP configurations
            automatic_installation = true,

            -- List of LSP servers to ensure are always installed
            ensure_installed = {
                "tsserver",    -- TypeScript/JavaScript LSP
                "html",        -- HTML LSP
                "cssls",       -- CSS LSP
                "tailwindcss", -- TailwindCSS LSP
                "svelte",      -- Svelte LSP
                "lua_ls",      -- Lua LSP (for Neovim config)
                "graphql",     -- GraphQL LSP
                "emmet_ls",    -- Emmet LSP for HTML/CSS
                "prismals",    -- Prisma LSP
                "pyright",     -- Python LSP
                "jdtls",       -- Java LSP (Eclipse JDT Language Server)
            },
        })

        -- Mason Tool Installer setup for managing non-LSP tools (formatters, linters, etc.)
        mason_tool_installer.setup({
            ensure_installed = {
                -- Formatters
                "prettier",     -- Prettier for formatting JavaScript, TypeScript, etc.
                "stylua",       -- Formatter for Lua files
                "isort",        -- Python import sorter
                "black",        -- Python formatter
                "beautysh",     -- Bash script formatter
                "clang-format", -- Formatter for C/C++/Objective-C code

                -- Linters
                "pylint",   -- Python linter
                "eslint_d", -- JavaScript/TypeScript linter (faster version of ESLint)
            },

            -- Automatic installation of tools not yet installed
            automatic_installation = true,

            -- Run installation in parallel to save time
            run_on_start = true,
            auto_update = false, -- Set to true if you want tools to be auto-updated when Neovim starts
        })

        -- Ensure that Mason, LSPConfig, and the tool installer have been set up correctly
        if not mason or not mason_lspconfig or not mason_tool_installer then
            vim.notify("Mason setup failed", vim.log.levels.ERROR)
        else
            vim.notify("Mason setup completed successfully", vim.log.levels.INFO)
        end
    end,
}
