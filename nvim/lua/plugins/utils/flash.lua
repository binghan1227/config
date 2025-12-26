return {
	"folke/flash.nvim",
	event = "VeryLazy",

	---@type Flash.Config
	opts = {
		modes = {
			-- Keep normal / and ? search untouched (no Flash labels)
			search = { enabled = false },

			-- Disable enhanced f/t/F/T
			char = { enabled = false },
		},
	},

	keys = {
		{
			"s",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = "Flash: Jump",
		},
		{
			"S",
			mode = { "n", "x", "o" },
			function()
				require("flash").treesitter()
			end,
			desc = "Flash: Treesitter",
		},

		-- Optional extras (handy in operator-pending)
		{
			"r",
			mode = "o",
			function()
				require("flash").remote()
			end,
			desc = "Flash: Remote",
		},
		{
			"R",
			mode = { "o", "x" },
			function()
				require("flash").treesitter_search()
			end,
			desc = "Flash: TS Search",
		},
	},
}
