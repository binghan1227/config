vim.g.mapleader = " "

local mode_nv = { "n", "v" }
local mode_v = { "v" }
local mode_i = { "i" }

local wk = require("which-key")
wk.add({
	{ "<leader>w", proxy = "<c-w>", group = "windows" },
	-- { "<leader>w", group = "windows manager"},
	-- { "<leader>wo", "<C-w>o", desc = "Close Others"},
	-- { "<leader>wj", "<C-w>j", desc = "<C-w>j"},
	-- { "<leader>wk", "<C-w>k", desc = "<C-w>k"},
	-- { "<leader>wl", "<C-w>l", desc = "<C-w>l"},
	-- { "<leader>wh", "<C-w>h", desc = "<C-w>h"},
	{ "<leader>b", group = "Buffer" },
	{ "<leader>l", group = "LSP" },
})

-- Yank whole file to system clipboard without moving the cursor
vim.keymap.set("n", "<leader>y", function()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
	-- Put as *linewise* text into the + register (system clipboard)
	vim.fn.setreg("+", lines, "l")
	vim.notify("Yank entire file to +", vim.log.levels.INFO)
end, { desc = "Yank entire file to + (clipboard)" })

-- local nmappings = {
-- 	{ from = "<leader>wo",     to = "<C-w>o", },
-- 	{ from = "<leader>wj",     to = "<C-w>j", },
-- 	{ from = "<leader>wk",     to = "<C-w>k", },
-- 	{ from = "<leader>wl",     to = "<C-w>l", },
-- 	{ from = "<leader>wh",     to = "<C-w>h", },
-- }
-- for _, mapping in ipairs(nmappings) do
-- 	vim.keymap.set(mapping.mode or "n", mapping.from, mapping.to, { noremap = true })
-- end
