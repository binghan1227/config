-- Numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

-- Indent defaults: spaces (4)
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Behavior
vim.opt.autoread = true
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR><Esc>", { noremap = true, silent = true })

-- UI
vim.opt.showmode = false
vim.opt.termguicolors = true

-- Smart per-file: keep tabs if file is mostly tab-indented
local function apply_smart_indent(bufnr)
	local max_lines = 200
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, max_lines, false)

	local tab_indents, space_indents = 0, 0
	for _, line in ipairs(lines) do
		if line:match("^\t+") then
			tab_indents = tab_indents + 1
		elseif line:match("^ +") then
			space_indents = space_indents + 1
		end
	end

	vim.bo[bufnr].tabstop = 4
	vim.bo[bufnr].shiftwidth = 4

	if tab_indents > space_indents and tab_indents > 0 then
		vim.bo[bufnr].expandtab = false
		vim.bo[bufnr].softtabstop = 0
	else
		vim.bo[bufnr].expandtab = true
		vim.bo[bufnr].softtabstop = 4
	end
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	callback = function(args)
		apply_smart_indent(args.buf)
	end,
})
