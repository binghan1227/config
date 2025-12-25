-- lua/plugins/ui/indent-blankline.lua
return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		indent = {},
		whitespace = {
			remove_blankline_trail = true,
		},
		scope = {
			show_exact_scope = true,
			enabled = true,
			show_start = true,
			show_end = false,
			injected_languages = false,
			highlight = { "Function", "Label" },
			priority = 500,
		},
		exclude = {
			buftypes = {
				"terminal",
				"nofile",
				"prompt",
				"quickfix",
			},
			filetypes = {
				-- common UI / utility buffers
				"help",
				"man",
				"lspinfo",
				"checkhealth",
				"lazy",
				"mason",
				"TelescopePrompt",
				"TelescopeResults",

				-- dashboards / greeters
				"alpha",
				"dashboard",

				-- file explorers / panels
				"neo-tree",
				"NvimTree",
				"Trouble",
			},
		},
	},
}
