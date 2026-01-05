local lsp = require("config.lsp")

return {
	capabilities = lsp.capabilities(),
	settings = {
		["rust-analyzer"] = {
			cargo = { allFeatures = true },
			check = {
				command = "clippy",
			},
			procMacro = { enable = true },
		},
	},
}
