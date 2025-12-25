-- lua/plugins/editor/telescope.lua
return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	version = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-telescope/telescope-ui-select.nvim",
	},

	keys = {
		{ "<leader>f", "", desc = "Find" },

		-- Files
		{
			"<leader>ff",
			function()
				require("telescope.builtin").find_files()
			end,
			desc = "Files",
		},
		{
			"<leader>fF",
			function()
				require("telescope.builtin").find_files({ hidden = true, no_ignore = true })
			end,
			desc = "Files (all)",
		},

		-- Grep
		{
			"<leader>fg",
			function()
				require("telescope.builtin").live_grep()
			end,
			desc = "Grep (live)",
		},
		{
			"<leader>fG",
			function()
				require("telescope.builtin").live_grep({
					additional_args = function()
						return { "--hidden", "--no-ignore" }
					end,
				})
			end,
			desc = "Grep (all)",
		},

		-- Buffers / history
		{
			"<leader>fb",
			function()
				require("telescope.builtin").buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>fo",
			function()
				require("telescope.builtin").oldfiles()
			end,
			desc = "Recent files",
		},
		{
			"<leader>fr",
			function()
				require("telescope.builtin").resume()
			end,
			desc = "Resume",
		},

		-- Quick utilities
		{
			"<leader>fh",
			function()
				require("telescope.builtin").help_tags()
			end,
			desc = "Help",
		},
		{
			"<leader>fk",
			function()
				require("telescope.builtin").keymaps()
			end,
			desc = "Keymaps",
		},
		{
			"<leader>fc",
			function()
				require("telescope.builtin").commands()
			end,
			desc = "Commands",
		},
		{
			"<leader>f:",
			function()
				require("telescope.builtin").command_history()
			end,
			desc = "Command history",
		},
		{
			"<leader>f/",
			function()
				require("telescope.builtin").search_history()
			end,
			desc = "Search history",
		},
		{
			"<leader>fs",
			function()
				require("telescope.builtin").current_buffer_fuzzy_find()
			end,
			desc = "Search in buffer",
		},

		-- LSP
		{ "<leader>fl", "", desc = "LSP" },
		{
			"<leader>fld",
			function()
				require("telescope.builtin").lsp_definitions()
			end,
			desc = "Definition",
		},
		{
			"<leader>flr",
			function()
				require("telescope.builtin").lsp_references()
			end,
			desc = "References",
		},
		{
			"<leader>fli",
			function()
				require("telescope.builtin").lsp_implementations()
			end,
			desc = "Implementation",
		},
		{
			"<leader>fls",
			function()
				require("telescope.builtin").lsp_document_symbols()
			end,
			desc = "Document symbols",
		},
		{
			"<leader>flS",
			function()
				require("telescope.builtin").lsp_workspace_symbols()
			end,
			desc = "Workspace symbols",
		},
		{
			"<leader>fd",
			function()
				require("telescope.builtin").diagnostics()
			end,
			desc = "Diagnostics",
		},

		-- Git (in the Find group so it’s easy to remember)
		{ "<leader>fGg", "", desc = "Git" },
		{
			"<leader>fGgs",
			function()
				require("telescope.builtin").git_status()
			end,
			desc = "Status",
		},
		{
			"<leader>fGgb",
			function()
				require("telescope.builtin").git_branches()
			end,
			desc = "Branches",
		},
		{
			"<leader>fGgc",
			function()
				require("telescope.builtin").git_commits()
			end,
			desc = "Commits",
		},
		{
			"<leader>fGgC",
			function()
				require("telescope.builtin").git_bcommits()
			end,
			desc = "Buffer commits",
		},
		{
			"<leader>fGgt",
			function()
				require("telescope.builtin").git_stash()
			end,
			desc = "Stash",
		},
	},

	opts = function()
		local actions = require("telescope.actions")
		local action_layout = require("telescope.actions.layout")

		return {
			defaults = {
				prompt_prefix = "  ",
				selection_caret = "❯ ",
				path_display = { "smart" },
				sorting_strategy = "ascending",
				layout_strategy = "horizontal",
				layout_config = {
					prompt_position = "top",
					width = 0.95,
					height = 0.90,
					preview_width = 0.55,
				},

				-- Make sure .git never shows up in results
				file_ignore_patterns = {
					"%.git/",
				},

				mappings = {
					i = {
						-- Vim-ish navigation
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<C-n>"] = actions.move_selection_next,
						["<C-p>"] = actions.move_selection_previous,

						["<C-u>"] = actions.preview_scrolling_up,
						["<C-d>"] = actions.preview_scrolling_down,

						["<Esc>"] = actions.close,
						["<C-c>"] = actions.close,

						["<C-h>"] = actions.which_key,
						["<M-p>"] = action_layout.toggle_preview,
					},
					n = {
						["q"] = actions.close,
						["<M-p>"] = action_layout.toggle_preview,
					},
				},
			},

			pickers = {
				find_files = {
					hidden = true,
					find_command = {
						"fd",
						"--type",
						"f",
						"--strip-cwd-prefix",
						"--hidden",
						"--follow",
						"--exclude",
						".git",
					},
				},

				live_grep = {
					-- Make rg search hidden files but still ignore .git folder
					additional_args = function()
						return { "--hidden", "--glob", "!.git/*" }
					end,
				},

				buffers = {
					sort_mru = true,
					ignore_current_buffer = true,
				},
			},

			extensions = {
				["ui-select"] = require("telescope.themes").get_dropdown({}),
			},
		}
	end,

	config = function(_, opts)
		local telescope = require("telescope")
		telescope.setup(opts)
		telescope.load_extension("fzf")
		telescope.load_extension("ui-select")
	end,
}
