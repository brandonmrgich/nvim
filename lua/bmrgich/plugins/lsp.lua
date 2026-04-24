-- LSP, completion, formatting, and linting
local servers = {
	html = {},
	cssls = {},
	tailwindcss = {},
	svelte = {
		on_attach = function(client, bufnr)
			vim.api.nvim_create_autocmd("BufWritePost", {
				pattern = { "*.js", "*.ts" },
				callback = function(ctx)
					client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
				end,
			})
		end,
	},
	lua_ls = {
		settings = {
			Lua = {
				diagnostics = { globals = { "vim" } },
				completion = { callSnippet = "Replace" },
			},
		},
	},
	graphql = {
		filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
	},
	emmet_ls = {
		filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
	},
	prismals = {},
	pyright = {
		on_attach = function(client, bufnr)
			local venv_path = os.getenv("VIRTUAL_ENV")
			if venv_path and client.config and client.config.settings then
				client.config.settings.python = client.config.settings.python or {}
				client.config.settings.python.pythonPath = venv_path .. "/bin/python"
				client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
			end
		end,
	},
	dockerls = {},
}

return {
	-- Mason: tool installer (install-time only, no runtime coupling)
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},

	-- Mason-lspconfig: bridge between mason and lspconfig
	{
		"williamboman/mason-lspconfig.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = vim.tbl_keys(servers),
			automatic_installation = true,
		},
	},

	-- Mason tool installer: formatters and linters
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			local ensure_tools = {
				-- Formatters
				"prettier",
				"stylua",
				"black",
				"isort",
				"shfmt",
				"yamlfmt",
				"google-java-format",
				"beautysh",
				"clang-format",
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

			if vim.fn.exepath("dotnet") ~= "" then
				table.insert(ensure_tools, "csharpier")
			end

			require("mason-tool-installer").setup({
				ensure_installed = ensure_tools,
				auto_update = true,
				run_on_start = true,
				automatic_installation = true,
			})
		end,
	},

	-- nvim-lspconfig: LSP server configuration
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"williamboman/mason-lspconfig.nvim",
			{ "antosha417/nvim-lsp-file-operations", config = true },
			{ "folke/lazydev.nvim", opts = {} },
		},
		config = function()
			local cmp_nvim_lsp = require("cmp_nvim_lsp")

			local capabilities = cmp_nvim_lsp.default_capabilities()

			-- Diagnostic signs
			local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end

			-- LSP keymaps on attach
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
				callback = function(ev)
					local opts = { buffer = ev.buf, silent = true }

					opts.desc = "Show LSP references"
					vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

					opts.desc = "Go to declaration"
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

					opts.desc = "Show LSP definitions"
					vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

					opts.desc = "Show LSP implementations"
					vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

					opts.desc = "Show LSP type definitions"
					vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

					opts.desc = "See available code actions"
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

					opts.desc = "Smart rename"
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

					opts.desc = "Show buffer diagnostics"
					vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

					opts.desc = "Show line diagnostics"
					vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

					opts.desc = "Yank line diagnostics to clipboard"
					vim.keymap.set("n", "<leader>yd", function()
						local diags = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
						if #diags == 0 then
							vim.notify("No diagnostics on this line", vim.log.levels.INFO)
							return
						end
						local lines = {}
						for _, d in ipairs(diags) do
							table.insert(lines, d.message)
						end
						local text = table.concat(lines, "\n")
						vim.fn.setreg('"', text)
						vim.fn.setreg("+", text)
						vim.notify("Yanked " .. #diags .. " diagnostic(s)", vim.log.levels.INFO)
					end, opts)

					opts.desc = "Go to previous diagnostic"
					vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

					opts.desc = "Go to next diagnostic"
					vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

					opts.desc = "Show documentation for what is under cursor"
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

					opts.desc = "Restart LSP"
					vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
				end,
			})

			-- Configure each server via vim.lsp.config (nvim 0.11+, replaces lspconfig[name].setup)
			for name, server_opts in pairs(servers) do
				vim.lsp.config(name, vim.tbl_deep_extend("force", {
					capabilities = capabilities,
				}, server_opts))
			end
			vim.lsp.enable(vim.tbl_keys(servers))
		end,
	},

	-- nvim-cmp: completion engine
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",
				build = "make install_jsregexp",
			},
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
			"onsails/lspkind.nvim",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				completion = {
					autocomplete = false,
					completeopt = "menu,menuone,preview,noselect",
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-k>"] = cmp.mapping.select_prev_item(),
					["<C-j>"] = cmp.mapping.select_next_item(),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "lazydev" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),
				formatting = {
					format = lspkind.cmp_format({
						maxwidth = 50,
						ellipsis_char = "...",
					}),
				},
			})
		end,
	},

	-- conform.nvim: formatting
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local conform = require("conform")
			local has_csharpier = vim.fn.executable("csharpier") == 1

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
					python = { "isort", "black" },
					cpp = { "clang_format" },
					c = { "clang_format" },
					java = { "google_java_format" },
					objectivec = { "clang_format" },
					csharp = has_csharpier and { "csharpier" } or {},
					sh = { "shfmt" },
					zsh = { "shfmt" },
				},
				format_on_save = {
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				},
				formatters = {
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
					shfmt = {
						args = { "-i", "4" },
					},
				},
			})

			vim.keymap.set({ "n", "v" }, "<leader>mp", function()
				conform.format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				})
			end, { desc = "Format file or range (in visual mode)" })
		end,
	},

	-- nvim-lint: linting
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				css = { "eslint_d" },
				svelte = { "eslint_d" },
				python = { "ruff" },
				cpp = { "cpplint" },
				html = { "htmlhint" },
				json = { "jsonlint" },
				lua = { "luacheck" },
				markdown = { "markdownlint" },
				zsh = { "shellcheck" },
				sh = { "shellcheck" },
				yaml = { "yamllint" },
				dockerfile = { "hadolint" },
			}

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = vim.api.nvim_create_augroup("lint", { clear = true }),
				callback = function()
					lint.try_lint()
				end,
			})

			vim.keymap.set("n", "<leader>l", function()
				lint.try_lint()
			end, { desc = "Trigger linting for current file" })
		end,
	},

	-- mason-nvim-lint bridge
	{
		"rshkarin/mason-nvim-lint",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-lint",
		},
		opts = {},
	},

	-- typescript-tools: better TS performance and monorepo awareness
	{
		"pmizio/typescript-tools.nvim",
		ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
	},

	-- JDTLS: Java-specific LSP
	{
		"mfussenegger/nvim-jdtls",
		ft = "java",
		config = function()
			local jdtls = require("jdtls")

			local function get_jdtls_paths()
				local registry = require("mason-registry")
				if not registry.has_package("jdtls") then
					return nil
				end

				local pkg = registry.get_package("jdtls")
				local install_path = pkg:get_install_path()
				local launcher_jar = vim.fn.glob(install_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
				if launcher_jar == "" then
					return nil
				end

				local sysname = (vim.uv or vim.loop).os_uname().sysname
				local config_dir
				if sysname == "Darwin" then
					config_dir = install_path .. "/config_mac"
				elseif sysname == "Linux" then
					config_dir = install_path .. "/config_linux"
				elseif sysname == "Windows_NT" then
					config_dir = install_path .. "/config_win"
				end

				if not config_dir or vim.fn.isdirectory(config_dir) == 0 then
					return nil
				end

				return {
					install_path = install_path,
					launcher_jar = launcher_jar,
					config_dir = config_dir,
				}
			end

			local function jdtls_setup()
				local root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" })
				if root_dir == "" then
					vim.notify("No .git, mvnw, or gradlew found. JDTLS will not be started.", vim.log.levels.INFO)
					return
				end

				local project_name = vim.fn.fnamemodify(root_dir, ":t")
				local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

				local paths = get_jdtls_paths()
				if not paths then
					vim.notify(
						"jdtls not found via Mason. Install it with :Mason.",
						vim.log.levels.WARN
					)
					return
				end

				local sysname = (vim.uv or vim.loop).os_uname().sysname
				local java_exec = sysname == "Windows_NT" and "java.exe" or "java"
				local java_path = vim.fn.exepath(java_exec)
				if java_path == "" then
					vim.notify("Java executable not found in PATH.", vim.log.levels.ERROR)
					return
				end

				local config = {
					cmd = {
						java_path,
						"-Declipse.application=org.eclipse.jdt.ls.core.id1",
						"-Dosgi.bundles.defaultStartLevel=4",
						"-Declipse.product=org.eclipse.jdt.ls.core.product",
						"-Dlog.protocol=true",
						"-Dlog.level=ALL",
						"-Xmx1g",
						"--add-modules=ALL-SYSTEM",
						"--add-opens", "java.base/java.util=ALL-UNNAMED",
						"--add-opens", "java.base/java.lang=ALL-UNNAMED",
						"-jar", paths.launcher_jar,
						"-configuration", paths.config_dir,
						"-data", workspace_dir,
					},
					root_dir = root_dir,
					settings = {
						java = {
							signatureHelp = { enabled = true },
							contentProvider = { preferred = "fernflower" },
							completion = {
								favoriteStaticMembers = {
									"org.hamcrest.MatcherAssert.assertThat",
									"org.hamcrest.Matchers.*",
									"org.junit.Assert.*",
									"java.util.Objects.requireNonNull",
									"java.util.Objects.requireNonNullElse",
									"org.mockito.Mockito.*",
								},
								filteredTypes = {
									"com.sun.*",
									"io.micrometer.shaded.*",
									"java.awt.*",
									"jdk.*",
									"sun.*",
								},
							},
							sources = {
								organizeImports = {
									starThreshold = 9999,
									staticStarThreshold = 9999,
								},
							},
							codeGeneration = {
								toString = {
									template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
								},
								useBlocks = true,
							},
						},
					},
					init_options = { bundles = {} },
					capabilities = require("cmp_nvim_lsp").default_capabilities(),
					on_init = function(client, _)
						if client.config.settings then
							client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
						end
					end,
				}

				jdtls.start_or_attach(config)
			end

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "java",
				callback = function()
					vim.defer_fn(jdtls_setup, 0)
				end,
			})
		end,
	},
}
