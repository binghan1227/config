return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		keys = {
			{
				"<leader>lf",
				function()
					require("conform").format({ async = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		init = function()
			-- If you want the formatexpr, here is the place to set it
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
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
					return
					-- {
					-- 	bufnr = bufnr,
					-- 	timeout_ms = 2000,
					-- 	lsp_fallback = true,
					-- }
				end,
			})
		end,
	},
}
