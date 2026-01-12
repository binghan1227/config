return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	keys = function()
		local dap = require("dap")

		return {
			{ "<leader>d", nil, desc = "+debug" },

			{
				"<leader>dc",
				function()
					dap.continue()
				end,
				desc = "Continue",
			},
			{
				"<leader>dx",
				function()
					dap.terminate()
				end,
				desc = "Terminate",
			},
			{
				"<leader>dr",
				function()
					dap.restart()
				end,
				desc = "Restart",
			},
			{
				"<leader>dl",
				function()
					dap.run_last()
				end,
				desc = "Run last",
			},

			{
				"<leader>db",
				function()
					dap.toggle_breakpoint()
				end,
				desc = "Toggle breakpoint",
			},
			{
				"<leader>dB",
				function()
					vim.ui.input({ prompt = "Breakpoint condition: " }, function(cond)
						if cond and cond ~= "" then
							dap.set_breakpoint(cond)
						end
					end)
				end,
				desc = "Conditional breakpoint",
			},

			{
				"<leader>dn",
				function()
					dap.step_over()
				end,
				desc = "Step over",
			},
			{
				"<leader>di",
				function()
					dap.step_into()
				end,
				desc = "Step into",
			},
			{
				"<leader>do",
				function()
					dap.step_out()
				end,
				desc = "Step out",
			},

			{
				"<leader>dR",
				function()
					dap.repl.open()
				end,
				desc = "Open REPL",
			},
		}
	end,
	config = function()
		local dap = require("dap")

		vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
		vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticWarn", linehl = "Visual" })

		local function mason_package_path(pkg)
			local mason_path = vim.fn.stdpath("data") .. "/mason/packages/" .. pkg
			if vim.fn.isdirectory(mason_path) == 1 then
				return mason_path
			end
			return nil
		end

		-- -----------------------
		-- Python (debugpy): launch-only
		-- -----------------------
		do
			local debugpy = mason_package_path("debugpy")
			if debugpy then
				local python = debugpy .. "/venv/bin/python"

				dap.adapters.python = {
					type = "executable",
					command = python,
					args = { "-m", "debugpy.adapter" },
				}

				dap.configurations.python = {
					{
						type = "python",
						request = "launch",
						name = "Launch file",
						program = "${file}",
						console = "integratedTerminal",
						justMyCode = true,
					},
				}
			end
		end

		-- -----------------------
		-- C++ / Rust (codelldb): launch-only
		-- -----------------------
		do
			local codelldb = mason_package_path("codelldb")
			if codelldb then
				local adapter = codelldb .. "/extension/adapter/codelldb"

				dap.adapters.codelldb = {
					type = "server",
					port = "${port}",
					executable = {
						command = adapter,
						args = { "--port", "${port}" },
					},
				}

				local function program_path()
					return coroutine.create(function(coro)
						vim.ui.input(
							{ prompt = "Path to executable: ", default = vim.fn.getcwd() .. "/" },
							function(input)
								coroutine.resume(coro, input)
							end
						)
					end)
				end

				local function args_prompt()
					local a = vim.fn.input("Args: ")
					if a == "" then
						return {}
					end
					return vim.split(a, " ", { trimempty = true })
				end

				local launch = {
					{
						name = "Launch executable",
						type = "codelldb",
						request = "launch",
						program = program_path(),
						cwd = "${workspaceFolder}",
						stopOnEntry = false,
						args = args_prompt,
					},
				}

				dap.configurations.cpp = launch
				dap.configurations.c = launch
				dap.configurations.rust = launch
			end
		end

		pcall(function()
			require("which-key").add({ { "<leader>d", group = "debug" } })
		end)
	end,
}
