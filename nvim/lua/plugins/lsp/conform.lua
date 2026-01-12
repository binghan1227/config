return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		dependencies = { "folke/which-key.nvim" },
		config = function()
			local conform = require("conform")

			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "isort", "ruff_format" },
					c = { "clang_format" },
					cpp = { "clang_format" },
					rust = { "rustfmt" }, -- rustfmt via rustup (recommended)
					java = { "google_java_format" },
					haskell = { "fourmolu" },
				},

				formatters = {
					ruff_format = {
						append_args = {
							"--config",
							"format.quote-style='single'",
							"--config",
							"format.skip-magic-trailing-comma=false",
						},
					},
				},

				format_on_save = function(bufnr)
					-- Keep it predictable and fast
					return {
						bufnr = bufnr,
						timeout_ms = 2000,
						lsp_fallback = true,
					}
				end,
			})

			-- which-key group label (global)
			local wk_ok, wk = pcall(require, "which-key")
			if wk_ok then
				wk.add({ { "<leader>l", group = "LSP" } })
			end

			-- Manual format mapping (requested)
			vim.keymap.set({ "n", "v" }, "<leader>lf", function()
				conform.format({ lsp_fallback = true, timeout_ms = 2000 })
			end, { desc = "Format (Conform)" })
		end,
	},
}
