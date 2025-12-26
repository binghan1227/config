vim.g.mapleader = " "

local wk = require("which-key")
wk.add({
	{ "<leader>w", proxy = "<c-w>", group = "windows" },
})

-- Yank whole file to system clipboard without moving the cursor
vim.keymap.set("n", "<leader>y", function()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
	-- Put as *linewise* text into the + register (system clipboard)
	vim.fn.setreg("+", lines, "l")
	-- After snacks loads, vim.notify already points to Snacks.notifier.notify
	vim.notify("Yank entire file to +", vim.log.levels.INFO, { timeout = 50, title = "Yank" })
end, { desc = "Yank entire file to + (clipboard)" })
