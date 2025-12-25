local lsp = require("config.lsp")

return {
	capabilities = lsp.capabilities(),
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim" } },
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					-- If you want, you can add your config/runtime paths here
				},
			},
			telemetry = { enable = false },
		},
	},
}
