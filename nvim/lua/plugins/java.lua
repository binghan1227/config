return {
	{
		"mfussenegger/nvim-jdtls",
		ft = { "java" },
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
			{ "mfussenegger/nvim-dap", lazy = true },
			{ "rcarriga/nvim-dap-ui", lazy = true },
		},
		config = function()
			local registry_ok, registry = pcall(require, "mason-registry")
			if not registry_ok then
				vim.notify("mason-registry not available; install will be skipped", vim.log.levels.WARN)
			end

			-- ===== Mason compatibility helpers =====
			local mason_pkgs_dir = vim.fn.stdpath("data") .. "/mason/packages"
			local function pkg_path(name)
				-- Prefer Mason's package object path if available
				if registry_ok then
					local ok, pkg = pcall(registry.get_package, name)
					if ok and pkg then
						if type(pkg.get_install_path) == "function" then
							return pkg:get_install_path()
						end
						-- Fallback to standard path layout
					end
				end
				return mason_pkgs_dir .. "/" .. name
			end

			local function ensure_installed(name)
				if not registry_ok then
					return
				end
				local ok, pkg = pcall(registry.get_package, name)
				if ok and pkg and not pkg:is_installed() then
					pkg:install()
				end
			end
			-- =======================================

			-- Make sure these are present
			ensure_installed("jdtls")
			ensure_installed("java-debug-adapter")
			ensure_installed("java-test")

			local jdtls_root = pkg_path("jdtls")
			local java_dbg_root = pkg_path("java-debug-adapter")
			local java_test_root = pkg_path("java-test")

			-- Collect debug/test bundles
			local bundles = {}
			local function add_glob(g)
				for _, f in ipairs(vim.split(vim.fn.glob(g), "\n", { trimempty = true })) do
					if f ~= "" then
						table.insert(bundles, f)
					end
				end
			end
			add_glob(java_dbg_root .. "/extension/server/com.microsoft.java.debug.plugin-*.jar")
			add_glob(java_test_root .. "/extension/server/*.jar")

			-- Per-project workspace
			local project_name = vim.fn.fnamemodify(vim.loop.cwd(), ":p:h:t")
			local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

			-- Root detection
			local root_markers = { "gradlew", "mvnw", "pom.xml", "build.gradle", "build.gradle.kts", ".git" }
			local root_dir = require("lspconfig.util").root_pattern(unpack(root_markers))(vim.loop.cwd())
				or vim.loop.cwd()

			-- Capabilities via blink.cmp
			local capabilities = {}
			local ok_blink, blink = pcall(require, "blink.cmp")
			if ok_blink then
				capabilities = blink.get_lsp_capabilities(capabilities)
			end

			local function on_attach(client, bufnr)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false

				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(
						mode,
						lhs,
						rhs,
						{ buffer = bufnr, silent = true, noremap = true, desc = "java: " .. (desc or "") }
					)
				end

				-- LSP basics
				map("n", "gd", vim.lsp.buf.definition, "goto definition")
				map("n", "gr", vim.lsp.buf.references, "references")
				map("n", "K", vim.lsp.buf.hover, "hover")
				map("n", "<leader>cr", vim.lsp.buf.rename, "rename")
				map("n", "<leader>ca", vim.lsp.buf.code_action, "code action")
				map("n", "<leader>cf", function()
					vim.lsp.buf.format({ async = true })
				end, "format")

				-- jdtls goodies
				local jdtls = require("jdtls")
				map("n", "<leader>jo", jdtls.organize_imports, "organize imports")
				map("n", "<leader>jv", jdtls.extract_variable, "extract variable")
				map({ "n", "v" }, "<leader>jm", jdtls.extract_method, "extract method")
				map("n", "<leader>jc", jdtls.extract_constant, "extract constant")
				map("n", "<leader>jt", jdtls.test_class, "test class")
				map("n", "<leader>jn", jdtls.test_nearest_method, "test nearest test")
			end

			local jdtls_settings = {
				java = {
					signatureHelp = { enabled = true },
					completion = {
						favoriteStaticMembers = {
							"org.hamcrest.MatcherAssert.assertThat",
							"org.hamcrest.Matchers.*",
							"org.junit.jupiter.api.Assertions.*",
							"org.junit.jupiter.api.Assumptions.*",
							"org.junit.jupiter.api.DynamicContainer.*",
							"org.junit.jupiter.api.DynamicTest.*",
						},
					},
					sources = { organizeImports = { starThreshold = 999, staticStarThreshold = 999 } },
					configuration = { updateBuildConfiguration = "interactive" },
					format = { enabled = false }, -- keep formatting external (e.g. conform.nvim)
					eclipse = { downloadSources = true },
					maven = { downloadSources = true },
					implementationsCodeLens = { enabled = true },
					referencesCodeLens = { enabled = true },
					references = { includeDecompiledSources = true },
					inlayHints = { parameterNames = { enabled = "all" } },
				},
			}

			-- jdtls launcher/config dir
			local launcher = vim.fn.glob(jdtls_root .. "/plugins/org.eclipse.equinox.launcher_*.jar")
			local os_cfg = (vim.fn.has("win32") == 1 and "win")
				or ((vim.loop.os_uname().sysname or ""):lower():find("darwin") and "mac")
				or "linux"
			local config_dir = jdtls_root .. "/config_" .. os_cfg

			local cmd = {
				"java",
				"-Declipse.application=org.eclipse.jdt.ls.core.id1",
				"-Dosgi.bundles.defaultStartLevel=4",
				"-Declipse.product=org.eclipse.jdt.ls.core.product",
				"-Dlog.protocol=true",
				"-Dlog.level=ALL",
				"-Xms1g",
				"--add-modules=ALL-SYSTEM",
				"--add-opens",
				"java.base/java.util=ALL-UNNAMED",
				"--add-opens",
				"java.base/java.lang=ALL-UNNAMED",
				"-jar",
				launcher,
				"-configuration",
				config_dir,
				"-data",
				workspace_dir,
			}

			-- Start/attach per Java buffer
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "java" },
				callback = function()
					local jdtls = require("jdtls")
					jdtls.start_or_attach({
						cmd = cmd,
						root_dir = root_dir,
						capabilities = capabilities,
						settings = jdtls_settings,
						flags = { allow_incremental_sync = true },
						init_options = {
							bundles = bundles,
							extendedClientCapabilities = require("jdtls").extendedClientCapabilities,
						},
						on_attach = on_attach,
					})
				end,
			})
		end,
	},

	-- Optional: external formatter (Google Java Format)
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			formatters_by_ft = { java = { "google_java_format" } },
			format_on_save = { lsp_fallback = false, timeout_ms = 2000 },
		},
		config = function(_, opts)
			require("conform").setup(opts)
			-- If `google-java-format` isn't on PATH, set its command path:
			-- require("conform").formatters.google_java_format = { command = "/path/to/google-java-format" }
		end,
	},
}
