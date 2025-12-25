-- lua/plugins/utils/treesitter.lua
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false, -- main branch does not support lazy-loading
	build = ":TSUpdate",
	config = function()
		local ts = require("nvim-treesitter")

		ts.setup({
			-- keep default, or uncomment if you want a dedicated install dir:
			-- install_dir = vim.fn.stdpath("data") .. "/site",
		})

		-- Install parsers you use (no-op if already installed)
		ts.install({
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

		-- Enable treesitter highlighting (required for IBL scope to work)
		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})
	end,
}
