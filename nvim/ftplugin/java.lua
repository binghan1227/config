-- Robust Java LSP: nvim-jdtls
-- Starts even when project root markers aren't found (falls back to file dir).
-- Also notifies you when something is missing.

-- After snacks loads, vim.notify already points to Snacks.notifier.notify

local function notify(msg, level)
	vim.notify(msg, level or vim.log.levels.INFO, { title = "jdtls" })
end

local ok, jdtls = pcall(require, "jdtls")
if not ok then
	notify(
		"nvim-jdtls not found. Did you install mfussenegger/nvim-jdtls and load it for ft=java?",
		vim.log.levels.WARN
	)
	return
end

local lsp = require("config.lsp")

local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle", "settings.gradle" }
local jdtls_setup = require("jdtls.setup")

local root_dir = jdtls_setup.find_root(root_markers)

-- Fallback root if markers not found: use file's directory (or cwd if unnamed buffer)
if not root_dir then
	local fname = vim.api.nvim_buf_get_name(0)
	if fname ~= "" then
		root_dir = vim.fs.dirname(fname)
		notify("No project root markers found; using file directory as root:\n" .. root_dir, vim.log.levels.INFO)
	else
		root_dir = vim.loop.cwd()
		notify("Unnamed buffer; using cwd as root:\n" .. root_dir, vim.log.levels.INFO)
	end
end

local project_name = vim.fs.basename(root_dir)
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

-- Mason-installed jdtls wrapper
local jdtls_cmd = vim.fn.stdpath("data") .. "/mason/bin/jdtls"
if vim.fn.executable(jdtls_cmd) ~= 1 then
	notify(
		"Mason jdtls not found at:\n" .. jdtls_cmd .. "\nInstall it via :Mason (package name: jdtls).",
		vim.log.levels.ERROR
	)
	return
end

-- Bundles for testing/debugging (optional)
local bundles = {}
do
	local mason_share = vim.fn.stdpath("data") .. "/mason/share"
	local java_test = vim.fn.glob(mason_share .. "/java-test/*.jar", true, true)
	local java_debug = vim.fn.glob(mason_share .. "/java-debug-adapter/com.microsoft.java.debug.plugin.jar", true, true)
	vim.list_extend(bundles, java_test)
	vim.list_extend(bundles, java_debug)
end

local config = {
	cmd = { jdtls_cmd, "-data", workspace_dir },
	root_dir = root_dir,
	capabilities = lsp.capabilities(),
	init_options = { bundles = bundles },
	settings = {
		java = {
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" },
			format = { enabled = true },
		},
	},
}

jdtls.start_or_attach(config)

-- which-key groups + Java actions
local wk_ok, wk = pcall(require, "which-key")
if wk_ok then
	wk.add({
		{ "<leader>l", group = "LSP" },
		{ "<leader>lj", group = "Java" },
	}, { buffer = 0 })
end

local function nmap(lhs, rhs, desc)
	vim.keymap.set("n", lhs, rhs, { buffer = 0, silent = true, desc = desc })
end

nmap("<leader>ljo", jdtls.organize_imports, "Organize imports")
nmap("<leader>ljv", jdtls.extract_variable, "Extract variable")
nmap("<leader>ljc", jdtls.extract_constant, "Extract constant")
nmap("<leader>ljm", jdtls.extract_method, "Extract method")

pcall(function()
	jdtls.setup_dap({ hotcodereplace = "auto" })
end)
