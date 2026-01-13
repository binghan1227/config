return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	lazy = false,
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
	},
	config = function()
		local treesitter = require("nvim-treesitter")
		treesitter.setup()
		treesitter.install({
			"lua",
			"vim",
			"vimdoc",
			"query",
			"java",
			"python",
			"rust",
			"c",
			"cpp",
			"bash",
			"json",
			"yaml",
			"toml",
			"markdown",
			"markdown_inline",
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"lua",
				"vim",
				"vimdoc",
				"query",
				"java",
				"python",
				"rust",
				"c",
				"cpp",
				"bash",
				"json",
				"yaml",
				"toml",
				"markdown",
				"markdown_inline",
			},
			callback = function()
				-- syntax highlighting, provided by Neovim
				vim.treesitter.start()
				-- folds, provided by Neovim (I don't like folds)
				-- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
				-- vim.wo.foldmethod = 'expr'
				-- indentation, provided by nvim-treesitter
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
