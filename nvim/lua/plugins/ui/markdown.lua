return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = { "markdown" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons", -- icons above code blocks (optional, but nice)
	},
	init = function()
		-- Which-key group name (safe even if which-key isn't installed)
		local ok, wk = pcall(require, "which-key")
		if ok then
			wk.add({
				{ "<leader>m", group = "Markdown" },
			})
		end
	end,
	opts = {
		-- Default behavior is already great:
		-- render_modes = { "n", "c", "t" }  -- rendered in normal/cmd/terminal; raw while inserting :contentReference[oaicite:0]{index=0}

		-- Nice bonus: checkbox + callout completions via LSP (works with blink.cmp too) :contentReference[oaicite:1]{index=1}
		completions = { lsp = { enabled = true } },
	},
	keys = {
		{ "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", desc = "Markdown: Toggle render" }, -- :contentReference[oaicite:2]{index=2}
		{ "<leader>mp", "<cmd>RenderMarkdown preview<cr>", desc = "Markdown: Preview rendered" }, -- :contentReference[oaicite:3]{index=3}
		{ "<leader>mB", "<cmd>RenderMarkdown buf_toggle<cr>", desc = "Markdown: Toggle render (buffer)" }, -- :contentReference[oaicite:4]{index=4}
	},
}
