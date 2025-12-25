local lsp = require("config.lsp")

return {
	capabilities = lsp.capabilities(),
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--completion-style=detailed",
		"--header-insertion=iwyu",
		"--pch-storage=memory",
	},
	-- Usually you want clangd to prefer compile_commands.json if present
	init_options = {
		clangdFileStatus = true,
	},
}
