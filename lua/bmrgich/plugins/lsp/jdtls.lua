return {
	"mfussenegger/nvim-jdtls",
	ft = "java",
	config = function()
		local jdtls = require("jdtls")

		local function get_jdtls_paths()
			local ok, registry = pcall(require, "mason-registry")
			if not ok then
				return nil
			end

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
			local config_dir = nil
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

			local project_name = vim.fn.fnamemodify(root_dir, ":t")
			local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

			local paths = get_jdtls_paths()
			if not paths then
				vim.notify(
					"jdtls not found via Mason. Install it with :Mason, or adjust jdtls paths.",
					vim.log.levels.WARN
				)
				return
			end

			local sysname = (vim.uv or vim.loop).os_uname().sysname
			local java_exec = sysname == "Windows_NT" and "java.exe" or "java"

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
				paths.launcher_jar,
				"-configuration",
				paths.config_dir,
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
