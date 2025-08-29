return {
	"williamboman/mason.nvim",
	event = "VeryLazy",
	dependencies = {
		"neovim/nvim-lspconfig",
		"mason-org/mason-lspconfig.nvim",
	},
	opts = {},
	config = function(_, opts)
		require("mason").setup(opts)
		local registry = require("mason-registry")

		local function setup(name, config)
			local success, package = pcall(registry.get_package, name)
			if success and not package:is_installed() then
				package:install()
			elseif not success then
				print("mason installing failed")
			end

			local nvim_lsp = require("mason-lspconfig").get_mappings().package_to_lspconfig[name]
			-- if nvim_lsp == nil then
			-- 	print(name)
			-- 	return
			-- end
			config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)

			config.on_attach = function(client)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			end
			require("lspconfig")[nvim_lsp].setup(config)
			-- print(require("mason-lspconfig").get_mappings().package_to_lspconfig["codelldb"])
			-- vim.lsp.config(nvim_lsp, config)
			-- vim.lsp.config("pyright", {})
		end

		local servers = {
			["lua-language-server"] = {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			},
			["clangd"] = {
				cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=never" },
			},
			["pyright"] = {},
			["rust-analyzer"] = {
				checkOnSave = {
					command = "clippy",
				},
			},
			-- ["codelldb"] = {},
		}

		for server, config in pairs(servers) do
			setup(server, config)
		end

		vim.cmd("LspStart")

		vim.diagnostic.config({
			virtual_text = true,
			update_in_insert = true,
		})
	end,
}
