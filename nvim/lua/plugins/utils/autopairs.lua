return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	opts = function()
		-- Only enable Treesitter checks if nvim-treesitter is installed
		local has_ts = pcall(require, "nvim-treesitter.parsers")

		return {
			-- keep prompts clean
			disable_filetype = { "TelescopePrompt", "spectre_panel", "snacks_picker_input" },

			disable_in_macro = true,
			disable_in_replace_mode = true,

			-- Treesitter-aware pairing (avoid pairing in strings/comments if TS is available)
			check_ts = has_ts,
			ts_config = has_ts and {
				lua = { "string", "comment" },
				python = { "string", "comment" },
				java = { "string", "comment" },
				c = { "string", "comment" },
				cpp = { "string", "comment" },
				rust = { "string", "comment" },
				go = { "string", "comment" },
				javascript = { "string", "template_string", "comment" },
				typescript = { "string", "template_string", "comment" },
				javascriptreact = { "string", "template_string", "comment" },
				typescriptreact = { "string", "template_string", "comment" },
			} or nil,

			-- defaults (good for most people)
			map_cr = true,
			map_bs = true,
		}
	end,
	config = function(_, opts)
		require("nvim-autopairs").setup(opts)
	end,
}
