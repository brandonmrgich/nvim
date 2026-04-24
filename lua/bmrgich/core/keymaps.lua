local keymap = vim.keymap

-------------------------------------------------------------------------------
-- General Keymaps
-------------------------------------------------------------------------------

-- Exit insert mode with jk
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- Clear search highlights
keymap.set("n", "<leader>cs", ":nohl<CR>", { desc = "Clear search highlights" })

-- Delete single character without copying into register
keymap.set("n", "x", '"_x')

-- Increment/Decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- Diagnostics UX: visible, readable, non-intrusive
vim.diagnostic.config({
	virtual_text = {
		spacing = 2,
		prefix = "●",
		format = function(diagnostic)
			return diagnostic.message:sub(1, 80)
		end,
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "always",
		focusable = false,
		style = "minimal",
	},
})

keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

-------------------------------------------------------------------------------
-- Buffer Management
-------------------------------------------------------------------------------

-- Change buffers
keymap.set("n", "<Leader>j", ":bp<CR>", { noremap = true, silent = true, desc = "Previous buffer" })
keymap.set("n", "<Leader>k", ":bn<CR>", { noremap = true, silent = true, desc = "Next buffer" })
keymap.set("n", "<leader>bd", ":bd<CR>", { noremap = true, silent = true, desc = "Delete buffer" })
keymap.set("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })
keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-------------------------------------------------------------------------------
-- Window Management
-------------------------------------------------------------------------------

-- Split windows
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Resize windows
keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Move to window using Ctrl + hjkl
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Move Lines
--keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
--keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
--keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
--keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
--keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
--keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-------------------------------------------------------------------------------
-- Tab Management
-------------------------------------------------------------------------------

-- Open, close, and navigate tabs
keymap.set("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>td", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>t", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>T", "<cmd>tabp<CR>", { desc = "Go to previous tab" })

-------------------------------------------------------------------------------
-- Terminal Management
-------------------------------------------------------------------------------

-- Terminal mappings
keymap.set("t", "jk", "<c-\\><c-n>", { desc = "Enter Normal Mode wth jk " })
keymap.set("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
keymap.set("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })

-------------------------------------------------------------------------------
-- Netrw and Other Plugins
-------------------------------------------------------------------------------

-- Open Netrw Explorer
keymap.set("n", "<leader>e", "<cmd>Exp<CR>", { desc = "Open Netrw Explorer" })

-- Claude Code
keymap.set("n", "<leader>ac", "<cmd>ClaudeCode<CR>", { desc = "Open Claude Code" })

-- Zathura (Latex display)
keymap.set("n", "<leader>za", ':lua require("zathura").OpenPdf()<CR>', { noremap = true, silent = true })

-------------------------------------------------------------------------------
-- Keymap Remapping
-------------------------------------------------------------------------------

-- Better up/down
keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Save file
keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Escape and Clear hlsearch
keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- Clear search, diff update, and redraw
keymap.set("n", "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", { desc = "Redraw Screen" })

-- Play an audio file currently under the cursor
vim.keymap.set("n", "<leader>p", function()
	local line = vim.fn.getline(".") -- Get the full line under the cursor
	local file = line:match(".*| (.+)$") -- Match everything after the final "| "
	if not file then
		vim.notify("No valid file found on the current line", vim.log.levels.ERROR)
		return
	end
	local escaped_file = vim.fn.shellescape(file)
	vim.cmd("!play " .. escaped_file)
end, { desc = "Play audio file after '| ' on the current line" })
