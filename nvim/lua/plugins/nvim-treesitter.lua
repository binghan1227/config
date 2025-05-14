return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = "VeryLazy",
	opts = {
		ensure_installed = { "lua", "cpp", "python", "latex", "markdown" },
		highlight = { enable = true },
	},
	config = function (_, opts)
		require("nvim-treesitter").setup(opts)
		require('nvim-treesitter.configs').setup({ highlight = { enable = true } })
		
	end
}
