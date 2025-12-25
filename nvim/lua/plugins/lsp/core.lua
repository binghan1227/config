return {
	{
		-- Provides server configs on runtimepath (required for vim.lsp.enable('...') to work with common servers)
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Capabilities integration
			"saghen/blink.cmp",

			-- Installer
			{ "williamboman/mason.nvim", opts = {} },
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- which-key for nice grouping (you already use it; this just ensures it's available)
			"folke/which-key.nvim",
		},
		config = function()
			-- Diagnostics UI (Signs ON, Underline ON, Virtual text OFF, rounded floats)
			vim.diagnostic.config({
				signs = true,
				underline = true,
				virtual_text = false,
				severity_sort = true,
				float = {
					border = "rounded",
					source = "if_many",
				},
			})

			-- Also round LSP hover/signature popups
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
			vim.lsp.handlers["textDocument/signatureHelp"] =
				vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

			-- LspAttach -> shared keymaps
			local lsp_helpers = require("config.lsp")
			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP keymaps",
				callback = lsp_helpers.on_attach,
			})

			-- Mason + curated installs ONLY
			require("mason").setup({
				ui = { border = "rounded" },
			})

			require("mason-tool-installer").setup({
				-- Mason package names (curated)
				ensure_installed = {
					-- LSP servers
					"clangd",
					"rust-analyzer",
					"pyright",
					"lua-language-server",
					"jdtls",

					-- Java extras (optional but makes nvim-jdtls much nicer)
					"java-test",
					"java-debug-adapter",

					-- Formatters used by conform.nvim
					"clang-format",
					"stylua",
					"black",
					"isort",
					"google-java-format",
				},
				auto_update = false,
				run_on_start = true,
				start_delay = 3000, -- ms
				debounce_hours = 24,
			})

			-- Enable only the LSP configs you want (Java is handled by nvim-jdtls in ftplugin/java.lua)
			vim.lsp.enable({
				"clangd",
				"rust_analyzer",
				"pyright",
				"lua_ls",
			})
		end,
	},
}
