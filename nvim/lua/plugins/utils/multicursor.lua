return {
	{
		"jake-stewart/multicursor.nvim",
		branch = "1.0",
		dependencies = { "folke/which-key.nvim" },
		event = "VeryLazy",
		keys = {
			-- Which-key group (since <leader>m is taken)
			{ "<leader>v", desc = "Multi-cursor", mode = { "n", "x" } },

			-- VSCode-like core flow
			{
				"<C-n>",
				function()
					require("multicursor-nvim").matchAddCursor(1)
				end,
				desc = "Add next match",
				mode = { "n", "x" },
			},
			{
				"<C-S-n>",
				function()
					require("multicursor-nvim").matchAddCursor(-1)
				end,
				desc = "Add prev match",
				mode = { "n", "x" },
			},
			{
				"<C-x>",
				function()
					require("multicursor-nvim").matchSkipCursor(1)
				end,
				desc = "Skip next match",
				mode = { "n", "x" },
			},
			{
				"<C-S-x>",
				function()
					require("multicursor-nvim").matchSkipCursor(-1)
				end,
				desc = "Skip prev match",
				mode = { "n", "x" },
			},
			{
				"<C-a>",
				function()
					require("multicursor-nvim").matchAllAddCursors()
				end,
				desc = "Add all matches",
				mode = { "n", "x" },
			},

			-- Optional leader helpers (no <leader>m)
			{
				"<leader>vj",
				function()
					require("multicursor-nvim").lineAddCursor(1)
				end,
				desc = "Add cursor below",
				mode = { "n", "x" },
			},
			{
				"<leader>vk",
				function()
					require("multicursor-nvim").lineAddCursor(-1)
				end,
				desc = "Add cursor above",
				mode = { "n", "x" },
			},
			{
				"<leader>vt",
				function()
					require("multicursor-nvim").toggleCursor()
				end,
				desc = "Toggle cursor at point",
				mode = { "n", "x" },
			},
			{
				"<leader>vC",
				function()
					require("multicursor-nvim").clearCursors()
				end,
				desc = "Clear all cursors",
				mode = { "n", "x" },
			},
		},
		config = function()
			local mc = require("multicursor-nvim")
			mc.setup()

			-- Keymap layer: only active when multicursor is “in play”
			mc.addKeymapLayer(function(layerSet)
				-- Navigate between cursors
				layerSet({ "n", "x" }, "<left>", mc.prevCursor)
				layerSet({ "n", "x" }, "<right>", mc.nextCursor)

				-- Remove current cursor
				layerSet({ "n", "x" }, "<leader>vx", mc.deleteCursor)

				-- Esc: if disabled -> enable; else -> clear all
				layerSet("n", "<esc>", function()
					if not mc.cursorsEnabled() then
						mc.enableCursors()
					else
						mc.clearCursors()
					end
				end)
			end)

			-- Highlight groups (simple + readable)
			local hl = vim.api.nvim_set_hl
			hl(0, "MultiCursorCursor", { reverse = true })
			hl(0, "MultiCursorVisual", { link = "Visual" })
			hl(0, "MultiCursorSign", { link = "SignColumn" })
			hl(0, "MultiCursorMatchPreview", { link = "Search" })
			hl(0, "MultiCursorDisabledCursor", { reverse = true })
			hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
			hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
		end,
	},
}
