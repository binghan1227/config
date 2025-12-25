return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		signcolumn = true,
		numhl = false,
		linehl = false,
		word_diff = false,

		-- Ensure we do NOT use inline virtual-text blame
		current_line_blame = false,

		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns

			local function map(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
			end

			-- Hunk navigation
			map("n", "]c", function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					gs.next_hunk()
				end)
				return "<Ignore>"
			end, "Git: Next hunk")

			map("n", "[c", function()
				if vim.wo.diff then
					return "[c"
				end
				vim.schedule(function()
					gs.prev_hunk()
				end)
				return "<Ignore>"
			end, "Git: Prev hunk")

			-- Hunks
			map({ "n", "v" }, "<leader>hs", gs.stage_hunk, "Git: Stage hunk")
			map({ "n", "v" }, "<leader>hr", gs.reset_hunk, "Git: Reset hunk")
			map("n", "<leader>hS", gs.stage_buffer, "Git: Stage buffer")
			map("n", "<leader>hu", gs.undo_stage_hunk, "Git: Undo stage")
			map("n", "<leader>hR", gs.reset_buffer, "Git: Reset buffer")
			map("n", "<leader>hp", gs.preview_hunk, "Git: Preview hunk")

			-- Blame (popup)
			map("n", "<leader>gb", function()
				gs.blame_line({ full = true })
			end, "Git: Blame line (popup)")

			-- Diffs
			map("n", "<leader>hd", gs.diffthis, "Git: Diff this")
			map("n", "<leader>hD", function()
				gs.diffthis("~")
			end, "Git: Diff vs ~")

			-- Text object
			map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Git: Select hunk")
		end,
	},

	-- which-key visibility even before a git buffer attaches
	keys = {
		{ "<leader>g", "", desc = "Git" },
		{ "<leader>gb", "", desc = "Git: Blame line (popup)" },

		{ "<leader>h", "", desc = "Git: Hunks" },
		{ "<leader>hs", "", desc = "Git: Stage hunk" },
		{ "<leader>hr", "", desc = "Git: Reset hunk" },
		{ "<leader>hp", "", desc = "Git: Preview hunk" },
		{ "<leader>hd", "", desc = "Git: Diff this" },
		{ "<leader>hD", "", desc = "Git: Diff vs ~" },

		{ "]c", "", desc = "Git: Next hunk" },
		{ "[c", "", desc = "Git: Prev hunk" },
	},
}
