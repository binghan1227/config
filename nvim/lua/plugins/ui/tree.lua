return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- icons
		"MunifTanjim/nui.nvim",
	},
	cmd = "Neotree",
	keys = {
		{
			"<leader>e",
			function()
				-- Smart: if Neo-tree is open, reveal current file; else open filesystem
				local ok, manager = pcall(require, "neo-tree.sources.manager")
				if ok then
					-- If any neo-tree window exists, reveal current file in filesystem
					local state = manager.get_state("filesystem")
					if state and state.winid and vim.api.nvim_win_is_valid(state.winid) then
						vim.cmd("Neotree filesystem reveal")
						return
					end
				end
				vim.cmd("Neotree filesystem toggle")
			end,
			desc = "Explorer (toggle / reveal)",
		},
		{ "<leader>E", "<cmd>Neotree filesystem toggle right<cr>", desc = "Explorer (right)" },
		{ "<leader>ge", "<cmd>Neotree git_status toggle<cr>", desc = "Git status (Neo-tree)" },
		{ "<leader>be", "<cmd>Neotree buffers toggle<cr>", desc = "Buffers (Neo-tree)" },
	},
	opts = {
		close_if_last_window = true, -- if Neo-tree is the last window, close it
		popup_border_style = "rounded",
		enable_git_status = true,
		enable_diagnostics = true,

		default_component_configs = {
			indent = {
				padding = 1,
				with_markers = true,
				indent_marker = "│",
				last_indent_marker = "└",
				expander_collapsed = "",
				expander_expanded = "",
			},
			icon = {
				folder_closed = "",
				folder_open = "",
				folder_empty = "",
				default = "",
			},
			modified = { symbol = "●" },
			git_status = {
				symbols = {
					added = "A",
					deleted = "D",
					modified = "M",
					renamed = "R",
					untracked = "U",
					ignored = "I",
					unstaged = "•",
					staged = "✓",
					conflict = "!",
				},
			},
		},

		window = {
			position = "left",
			width = 34,
			mappings = {
				["<space>"] = "toggle_node",
				["<cr>"] = "open",
				["l"] = "open",
				["h"] = "close_node",
				["S"] = "open_split",
				["s"] = "open_vsplit",
				["t"] = "open_tabnew",
				["a"] = { "add", config = { show_path = "relative" } },
				["r"] = "rename",
				["d"] = "delete",
				["y"] = "copy_to_clipboard",
				["x"] = "cut_to_clipboard",
				["p"] = "paste_from_clipboard",
				["c"] = "copy",
				["m"] = "move",
				["q"] = "close_window",
				["R"] = "refresh",
				["."] = "toggle_hidden",
				["?"] = "show_help",
			},
		},

		filesystem = {
			bind_to_cwd = true,
			follow_current_file = { enabled = true },
			hijack_netrw_behavior = "open_default",
			use_libuv_file_watcher = true,
			filtered_items = {
				visible = false, -- when false, hidden items are hidden until you toggle with "."
				hide_dotfiles = false, -- show dotfiles by default
				hide_gitignored = true, -- hide gitignored by default
			},
		},

		buffers = {
			follow_current_file = { enabled = true },
			group_empty_dirs = true,
			show_unloaded = true,
		},

		git_status = {
			window = { position = "float" },
		},
	},
}
