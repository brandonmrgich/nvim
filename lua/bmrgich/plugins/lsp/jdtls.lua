-- This file should be placed in lua/bmrgich/plugins/lsp/jdtls.lua

return {
	"mfussenegger/nvim-jdtls",
	ft = "java",
	config = function()
		local jdtls = require("jdtls")

		local function find_root_dir()
			local root_files = { ".git", "mvnw", "gradlew" }
			local root_dir = require("jdtls.setup").find_root(root_files)
			if root_dir == "" then
				return nil
			end
			return root_dir
		end

		local jdtls_setup = function()
			local root_dir = find_root_dir()
			if not root_dir then
				print("No .git, mvnw, or gradlew found. JDTLS will not be started.")
				return
			end

			local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
			local workspace_dir = vim.fn.expand("~/.cache/jdtls-workspace/") .. project_name

			-- Determine OS-specific separator and java executable
			local sep = vim.loop.os_uname().sysname == "Windows_NT" and "\\" or "/"
			local java_exec = vim.loop.os_uname().sysname == "Windows_NT" and "java.exe" or "java"

			-- Find java executable
			local java_path = vim.fn.exepath(java_exec)
			if java_path == "" then
				print("Java executable not found. Please make sure Java is installed and in your PATH.")
				return
			end

			-- Construct JDTLS command
			local cmd = {
				java_path,
				"-Declipse.application=org.eclipse.jdt.ls.core.id1",
				"-Dosgi.bundles.defaultStartLevel=4",
				"-Declipse.product=org.eclipse.jdt.ls.core.product",
				"-Dlog.protocol=true",
				"-Dlog.level=ALL",
				"-Xmx1g",
				"--add-modules=ALL-SYSTEM",
				"--add-opens",
				"java.base/java.util=ALL-UNNAMED",
				"--add-opens",
				"java.base/java.lang=ALL-UNNAMED",
				"-jar",
				vim.fn.glob("/opt/homebrew/Cellar/jdtls/*/libexec/plugins/org.eclipse.equinox.launcher_*.jar"),
				"-configuration",
				"/opt/homebrew/Cellar/jdtls/*/libexec/config_mac",
				"-data",
				workspace_dir,
			}

			local config = {
				cmd = cmd,
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
				init_options = {
					bundles = {},
				},
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			}

			-- Existing file detection
			config.on_init = function(client, _)
				if client.config.settings then
					client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
				end
			end

			-- Start or attach to the JDTLS
			jdtls.start_or_attach(config)
		end

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			callback = function()
				-- Defer the setup to ensure it runs after Neovim has fully loaded the buffer
				vim.defer_fn(jdtls_setup, 0)
			end,
		})
	end,
}
