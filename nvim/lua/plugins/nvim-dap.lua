return {
	{
		"mfussenegger/nvim-dap",
		event = "VeryLazy",
		config = function()
			require("plugins.dap.debugger")
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			require("nvim-dap-virtual-text").setup()
			-- require("noice").setup()
			require("plugins.dap.dapui")
		end,
	},
}
