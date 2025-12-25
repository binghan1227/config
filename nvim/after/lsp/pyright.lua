local lsp = require("config.lsp")

return {
	capabilities = lsp.capabilities(),
	settings = {
		python = {
			analysis = {
				typeCheckingMode = "basic",
				autoImportCompletions = true,
			},
		},
	},
}
