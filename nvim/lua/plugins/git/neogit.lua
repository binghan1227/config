return {
	"NeogitOrg/neogit",
	cmd = { "Neogit" },
	keys = {
		{ "<leader>gg", "<cmd>Neogit kind=floating<cr>", desc = "Git: Neogit" },
		{ "<leader>gC", "<cmd>Neogit commit<cr>", desc = "Git: Commit (Neogit)" },
		{ "<leader>gP", "<cmd>Neogit push<cr>", desc = "Git: Push (Neogit)" },
		{ "<leader>gF", "<cmd>Neogit pull<cr>", desc = "Git: Pull (Neogit)" },
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		kind = "split",
		disable_hint = false,
		disable_context_highlighting = false,
		integrations = {
			diffview = true,
		},
	},
}
