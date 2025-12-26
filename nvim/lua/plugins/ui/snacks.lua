return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		notifier = {
			enabled = true,
			timeout = 2000,
		},

		indent = {
			enabled = true,
			char = "▏",
			scope = {
				enabled = true,
			},
			-- Preserve indent-blankline exclude logic
			filter = function(buf)
				-- Exclude terminal, nofile, prompt, quickfix
				local buftype = vim.bo[buf].buftype
				if vim.tbl_contains({ "terminal", "nofile", "prompt", "quickfix" }, buftype) then
					return false
				end

				-- Exclude specific filetypes
				local filetype = vim.bo[buf].filetype
				local excluded_filetypes = {
					"help",
					"man",
					"lspinfo",
					"checkhealth",
					"lazy",
					"mason",
					"TelescopePrompt",
					"TelescopeResults",
					"alpha",
					"dashboard",
					"snacks_dashboard",
					"neo-tree",
					"NvimTree",
					"Trouble",
				}
				return not vim.tbl_contains(excluded_filetypes, filetype)
			end,
		},

		dashboard = {
			enabled = true,
			preset = {
				pick = "telescope.nvim",
			},
		},

		terminal = {
			enabled = true,
		},

		rename = {
			enabled = true,
		},

		scratch = {
			enabled = true,
		},

		scope = {
			enabled = true,
		},
	},

	keys = {
		-- Terminal
		{
			"<c-/>",
			function()
				Snacks.terminal()
			end,
			desc = "Toggle Terminal",
			mode = { "n", "t" },
		},

		-- Rename file
		{
			"<leader>cR",
			function()
				Snacks.rename.rename_file()
			end,
			desc = "Rename File (snacks)",
		},

		-- Scratch
		{
			"<leader>.",
			function()
				Snacks.scratch()
			end,
			desc = "Toggle Scratch Buffer",
		},
		{
			"<leader>S",
			function()
				Snacks.scratch.select()
			end,
			desc = "Select Scratch Buffer",
		},

		-- Notification history
		{
			"<leader>un",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "Notification History",
		},
		{
			"<leader>uN",
			function()
				Snacks.notifier.hide()
			end,
			desc = "Dismiss All Notifications",
		},
	},

	init = function()
		-- Setup vim.notify to use snacks
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				vim.notify = Snacks.notifier.notify
			end,
		})
	end,
}
