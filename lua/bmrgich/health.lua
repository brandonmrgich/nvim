local M = {}
local vim = vim

M.check = function()
	vim.health.start("bmrgich config")

	-- Check Python provider
	local python_path = vim.g.python3_host_prog
	if python_path and vim.fn.executable(python_path) == 1 then
		vim.health.ok("Python3 provider: " .. python_path)
	else
		vim.health.warn("Python3 provider not found at: " .. (python_path or "nil"))
	end

	-- Check active LSP clients
	vim.health.start("LSP clients")
	local clients = vim.lsp.get_clients()
	if #clients == 0 then
		vim.health.info("No active LSP clients (open a file to trigger)")
	else
		for _, client in ipairs(clients) do
			vim.health.ok(client.name .. " (id=" .. client.id .. ")")
		end
	end

	-- Check loaded plugins via lazy.nvim
	vim.health.start("Plugins")
	local ok, lazy = pcall(require, "lazy")
	if not ok then
		vim.health.error("lazy.nvim not loaded")
		return
	end

	local stats = lazy.stats()
	vim.health.ok(stats.loaded .. "/" .. stats.count .. " plugins loaded")
	vim.health.info("Startup time: " .. string.format("%.2f", stats.startuptime) .. "ms")

	-- Check treesitter parser status
	vim.health.start("Treesitter")
	local ts_ok, ts_info = pcall(require, "nvim-treesitter.info")
	if ts_ok then
		local installed = ts_info.installed_parsers()
		vim.health.ok(#installed .. " parsers installed")
	else
		vim.health.info("Treesitter not loaded yet (open a file to trigger)")
	end

	-- Check key external tools
	vim.health.start("External tools")
	local tools = { "rg", "fd", "git", "node", "npm", "pnpm", "eslint_d" }
	for _, tool in ipairs(tools) do
		if vim.fn.executable(tool) == 1 then
			vim.health.ok(tool .. " found")
		else
			vim.health.warn(tool .. " not found in PATH")
		end
	end
end

return M
