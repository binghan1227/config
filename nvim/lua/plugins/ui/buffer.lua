return {
	"akinsho/bufferline.nvim",
	version = "*",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons", "folke/snacks.nvim" },
	opts = {
		options = {
			mode = "buffers",
			numbers = "none",

			diagnostics = "nvim_lsp",
			diagnostics_indicator = function(count, level)
				local icon = level:match("error") and " " or " "
				return " " .. icon .. count
			end,

			separator_style = "thin",
			show_close_icon = false,
			show_buffer_close_icons = true,
			always_show_bufferline = true,

			-- Snacks integration for buffer deletion
			close_command = function(n)
				Snacks.bufdelete(n)
			end,
			right_mouse_command = function(n)
				Snacks.bufdelete(n)
			end,

			hover = {
				enabled = true,
				delay = 200,
				reveal = { "close" },
			},

			-- Neo-tree offset (safe even if neo-tree isn't always open)
			offsets = {
				{
					filetype = "neo-tree",
					text = "Neo-tree",
					highlight = "Directory",
					text_align = "left",
					separator = true,
				},
				-- Snacks explorer offset
				{
					filetype = "snacks_layout_box",
					text = "󰙅 File Explorer",
					highlight = "Directory",
					text_align = "left",
					separator = true,
				},
			},
		},
	},
	config = function(_, opts)
		require("bufferline").setup(opts)

		-- Keymaps (with which-key friendly descriptions)
		local wk_ok, wk = pcall(require, "which-key")
		if wk_ok then
			wk.add({
				{ "<leader>b", group = "Buffers" },
			})
		end

		local map = vim.keymap.set
		map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Buffer: previous" })
		map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Buffer: next" })

		map("n", "<leader>bp", "<cmd>BufferLinePick<cr>", { desc = "Buffer: pick" })
		map("n", "<leader>bP", "<cmd>BufferLinePickClose<cr>", { desc = "Buffer: pick to close" })

		map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Buffer: delete" })
		map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", { desc = "Buffer: close others" })
		map("n", "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", { desc = "Buffer: close left" })
		map("n", "<leader>br", "<cmd>BufferLineCloseRight<cr>", { desc = "Buffer: close right" })

		map("n", "<leader>b<", "<cmd>BufferLineMovePrev<cr>", { desc = "Buffer: move left" })
		map("n", "<leader>b>", "<cmd>BufferLineMoveNext<cr>", { desc = "Buffer: move right" })
	end,
}
