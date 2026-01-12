return {
	"rcarriga/nvim-dap-ui",
	dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
	keys = {
		{
			"<leader>du",
			function()
				require("dapui").toggle()
			end,
			desc = "Toggle UI",
		},
		{
			"<leader>dU",
			function()
				require("dapui").open()
			end,
			desc = "Open UI",
		},
		{
			"<leader>dC",
			function()
				require("dapui").close()
			end,
			desc = "Close UI",
		},
	},
	config = function()
		local dapui = require("dapui")
		dapui.setup({
			controls = { enabled = true },
			floating = { border = "rounded" },
		})

		-- IMPORTANT: no auto-open/close listeners (per your requirement)

		pcall(function()
			require("which-key").add({
				{ "<leader>du", desc = "Toggle debug UI" },
				{ "<leader>dU", desc = "Open debug UI" },
				{ "<leader>dC", desc = "Close debug UI" },
			})
		end)
	end,
}
