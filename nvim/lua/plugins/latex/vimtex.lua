return {
	{
		"lervag/vimtex",
		ft = { "tex", "bib" },

		-- Lazy.nvim-style keymaps
		keys = {
			{ "<leader>xl", "<cmd>VimtexCompile<cr>", desc = "LaTeX: Compile (latexmk)" },
			{ "<leader>xL", "<cmd>VimtexCompileSS<cr>", desc = "LaTeX: Compile toggle" },
			{ "<leader>xv", "<cmd>VimtexView<cr>", desc = "LaTeX: View PDF (Skim)" },
			{ "<leader>xf", "<cmd>VimtexView<cr>", desc = "LaTeX: Forward search (SyncTeX)" },
			{ "<leader>xe", "<cmd>VimtexErrors<cr>", desc = "LaTeX: Show errors" },
			{ "<leader>xt", "<cmd>VimtexTocToggle<cr>", desc = "LaTeX: TOC toggle" },
			{ "<leader>xc", "<cmd>VimtexClean<cr>", desc = "LaTeX: Clean build files" },
			{ "<leader>xC", "<cmd>VimtexClean!<cr>", desc = "LaTeX: Clean all (force)" },
			{ "<leader>xi", "<cmd>VimtexInfo<cr>", desc = "LaTeX: Project info" },
			{ "<leader>xs", "<cmd>VimtexStatus<cr>", desc = "LaTeX: Status" },
		},

		init = function()
			-- latexmk + auto (continuous) compile
			vim.g.vimtex_compiler_method = "latexmk"
			vim.g.vimtex_compiler_latexmk = {
				continuous = 1,
				callback = 1,
				build_dir = "build",
				options = {
					"-shell-escape",
					"-synctex=1",
					"-interaction=nonstopmode",
					"-file-line-error",
				},
			}

			-- macOS + Skim + SyncTeX
			vim.g.vimtex_view_method = "skim"
			vim.g.vimtex_view_skim_sync = 1
			vim.g.vimtex_view_skim_activate = 1

			-- QoL
			vim.g.vimtex_quickfix_mode = 1
			vim.g.vimtex_quickfix_open_on_warning = 0
			vim.g.vimtex_log_ignore = {
				"Underfull",
				"Overfull",
				"specifier changed to",
				"Token not allowed in a PDF string",
			}
		end,

		config = function()
			-- which-key group name (so <leader>l shows as "LaTeX")
			local wk = require("which-key")
			wk.add({
				{ "<leader>x", group = "LaTeX" },
			})

			-- TeX buffer-local defaults
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "tex", "plaintex", "bib" },
				callback = function()
					vim.opt_local.wrap = true
					vim.opt_local.linebreak = true
					vim.opt_local.conceallevel = 2
					vim.opt_local.spell = true
				end,
			})
		end,
	},
}
