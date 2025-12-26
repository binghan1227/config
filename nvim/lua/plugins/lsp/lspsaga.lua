return {
	"nvimdev/lspsaga.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	event = "LspAttach",
	opts = {
		ui = {
			border = "rounded",
			code_action = "",
		},
		lightbulb = {
			enable = true,
			sign = true,
			virtual_text = false,
		},
		symbol_in_winbar = {
			enable = false,
		},
		outline = {
			win_width = 40,
			auto_preview = true,
			keys = {
				toggle_or_jump = "<CR>",
				quit = "q",
			},
		},
		finder = {
			max_height = 0.6,
			keys = {
				toggle_or_open = "<CR>",
				vsplit = "v",
				split = "s",
				quit = "q",
			},
		},
		definition = {
			width = 0.8,
			height = 0.6,
			keys = {
				edit = "<CR>",
				vsplit = "v",
				split = "s",
				quit = "q",
			},
		},
		rename = {
			in_select = false,
			keys = {
				quit = "<ESC>",
				exec = "<CR>",
			},
		},
		diagnostic = {
			border_follow = true,
			diagnostic_only_current = false,
		},
		code_action = {
			keys = {
				quit = "q",
				exec = "<CR>",
			},
		},
	},
}