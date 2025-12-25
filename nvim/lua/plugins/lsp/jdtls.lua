return {
	{
		"mfussenegger/nvim-jdtls",
		ft = { "java" },
		dependencies = {
			"neovim/nvim-lspconfig", -- provides runtime server configs generally
			"williamboman/mason.nvim",
			"folke/which-key.nvim",
		},
	},
}
