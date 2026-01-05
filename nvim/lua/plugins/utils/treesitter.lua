-- lua/plugins/utils/treesitter.lua
return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	lazy = false,
	priority = 900,
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
		-- Ensure the configs module exists before requiring
		local ok, configs = pcall(require, "nvim-treesitter.configs")
		if not ok then
			vim.notify("nvim-treesitter.configs not found. Please run :Lazy sync", vim.log.levels.ERROR)
			return
		end

		configs.setup({
			-- Install parsers you use
			ensure_installed = {
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

			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = false,

			-- Automatically install missing parsers when entering buffer
			auto_install = true,

			-- Enable syntax highlighting
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},

			-- Enable indentation
			indent = {
				enable = true,
			},
		})
	end,
}
