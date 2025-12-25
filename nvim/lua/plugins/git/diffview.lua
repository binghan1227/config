return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git: Diffview open" },
		{ "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Git: Diffview close" },
		{ "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Git: File history (repo)" },
		{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Git: File history (file)" },
	},
	opts = {
		enhanced_diff_hl = true,
		file_panel = {
			listing_style = "tree",
			win_config = { position = "left", width = 35 },
		},
		view = {
			merge_tool = {
				layout = "diff3_mixed",
				disable_diagnostics = true,
			},
		},
	},
}
