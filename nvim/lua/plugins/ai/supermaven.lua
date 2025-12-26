return {
	"supermaven-inc/supermaven-nvim",
	event = "InsertEnter",

	keys = {
		{ "<leader>a", group = "AI" },

		-- Toggle (default OFF)
		{
			"<leader>as",
			function()
				local api = require("supermaven-nvim.api")
				vim.g.supermaven_enabled = not vim.g.supermaven_enabled

				if vim.g.supermaven_enabled then
					api.start()
					vim.notify("Supermaven: ON", vim.log.levels.INFO)
				else
					api.stop()
					vim.notify("Supermaven: OFF", vim.log.levels.INFO)
				end
			end,
			desc = "Supermaven: toggle",
		},

		-- Optional helpers
		{ "<leader>aS", "<cmd>SupermavenStatus<CR>", desc = "Supermaven: status" },
		{ "<leader>al", "<cmd>SupermavenShowLog<CR>", desc = "Supermaven: show log" },
		{ "<leader>aL", "<cmd>SupermavenClearLog<CR>", desc = "Supermaven: clear log" },

		-- Inline suggestion actions (insert mode)
		{
			"<C-l>",
			function()
				local s = require("supermaven-nvim.completion_preview")
				if s.has_suggestion() then
					s.on_accept_suggestion()
				end
			end,
			mode = "i",
			desc = "Supermaven: accept suggestion",
		},
		{
			"<C-j>",
			function()
				local s = require("supermaven-nvim.completion_preview")
				if s.has_suggestion() then
					s.on_accept_word()
				end
			end,
			mode = "i",
			desc = "Supermaven: accept word",
		},
		{
			"<C-]>",
			function()
				require("supermaven-nvim.completion_preview").on_clear_suggestion()
			end,
			mode = "i",
			desc = "Supermaven: clear suggestion",
		},
	},

	opts = function()
		-- OFF by default
		if vim.g.supermaven_enabled == nil then
			vim.g.supermaven_enabled = false
		end

		return {
			disable_keymaps = true, -- we provide our own mappings :contentReference[oaicite:1]{index=1}
			disable_inline_completion = false, -- keep inline suggestions when enabled :contentReference[oaicite:2]{index=2}
			log_level = "off", -- quieter :contentReference[oaicite:3]{index=3}

			-- Hide suggestions in these filetypes (still "runs" unless condition stops it)
			ignore_filetypes = {
				markdown = true,
				text = true,
				gitcommit = true,
			}, -- :contentReference[oaicite:4]{index=4}

			-- IMPORTANT: in supermaven-nvim, `true` means "stop supermaven" :contentReference[oaicite:5]{index=5}
			condition = function()
				return not vim.g.supermaven_enabled
			end,
		}
	end,

	config = function(_, opts)
		require("supermaven-nvim").setup(opts)

		-- Extra safety: if something starts it later, force it off unless enabled.
		vim.schedule(function()
			local api = require("supermaven-nvim.api")
			if (not vim.g.supermaven_enabled) and api.is_running() then
				api.stop()
			end
		end)
	end,
}
