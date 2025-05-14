return {
	"nvimdev/lspsaga.nvim",
	cmd = "Lspsaga",
	opts = {
		finder = {
			keys = {
				toggle_or_open = "<CR>",
			},
		},
	},
	keys = {
		{ "<leader>lr", ":Lspsaga rename<CR>", desc = "Rename this", silent = true },
		{ "<leader>lc", ":Lspsaga code_action<CR>", desc = "Code action", silent = true },
		{ "<leader>ld", ":Lspsaga goto_definition<CR>", desc = "Definition", silent = true },
		{ "<leader>lh", ":Lspsaga hover_doc<CR>", desc = "Document", silent = true },
		{ "<leader>lR", ":Lspsaga finder<CR>", desc = "Finder", silent = true },
		{ "<leader>ln", ":Lspsaga diagnostic_jump_next<CR>", desc = "Next diagnostic", silent = true },
		{ "<leader>lp", ":Lspsaga diagnostic_jump_prev<CR>", desc = "Previous diagnostic", silent = true },
	},
}
