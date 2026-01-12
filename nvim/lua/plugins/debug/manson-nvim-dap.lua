return {
	"jay-babu/mason-nvim-dap.nvim",
	dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
	opts = {
		automatic_installation = true,
		ensure_installed = {
			"debugpy", -- Python
			"codelldb", -- C++/Rust (LLDB)
		},
	},
}
