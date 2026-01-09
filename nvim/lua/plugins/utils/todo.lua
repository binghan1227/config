return {
	"folke/todo-comments.nvim",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim", -- for :TodoTelescope (project-wide list UI)
	},

	opts = {
		signs = true,

		-- Keep defaults (keywords/colors/highlights), only ensure project-wide search works great
		search = {
			command = "rg",
			args = {
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
				"--hidden",
				"--glob=!.git/",
			},
			pattern = [[\b(KEYWORDS):]], -- default style: KEYWORD:
		},
	},

	keys = {
		-- leader-t group (Which-Key will show these nicely)
		{
			"<leader>tn",
			function()
				require("todo-comments").jump_next()
			end,
			desc = "Todo: next",
		},
		{
			"<leader>tp",
			function()
				require("todo-comments").jump_prev()
			end,
			desc = "Todo: previous",
		},
		{ "<leader>tt", "<cmd>TodoTelescope<cr>", desc = "Todo: list (Telescope)" },

		-- Optional extras (still under the same group)
		{ "<leader>tq", "<cmd>TodoQuickFix<cr>", desc = "Todo: quickfix" },
		{ "<leader>tl", "<cmd>TodoLocList<cr>", desc = "Todo: loclist" },
	},
}
