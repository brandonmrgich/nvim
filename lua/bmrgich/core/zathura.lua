-- TODO: place this in the correct location

local Zathura = {}

-- Function to open PDF with Zathura
function Zathura.OpenPdf()
	-- Get the full path of the current file
	local fullPath = vim.fn.expand("%:p")

	-- Replace the .tex extension with .pdf
	local pdfFile = fullPath:gsub("%.tex$", ".pdf")

	-- Execute the command to open the PDF with Zathura
	os.execute("silent !zathura '" .. pdfFile .. "' &")
end

return Zathura
