return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = function()
		-- Show branch/diff only when inside a git repo
		local function in_git_repo()
			local filepath = vim.api.nvim_buf_get_name(0)
			if filepath == "" then
				return false
			end
			local dir = vim.fn.fnamemodify(filepath, ":p:h")
			local gitdir = vim.fn.finddir(".git", dir .. ";")
			return gitdir ~= ""
		end

		-- LSP status icon: shows one icon if attached, another if not
		local function lsp_icon()
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			if clients and #clients > 0 then
				return " " -- LSP attached
			end
			return "󰅚" -- No LSP
		end

		return {
			options = {
				theme = "auto", -- works great with tokyonight
				icons_enabled = true,

				-- "separating by color" feel (powerline blocks)
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },

				globalstatus = true,
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					{ "branch", cond = in_git_repo },
					{ "diff", cond = in_git_repo },
				},
				lualine_c = {
					{ "filename", path = 1 }, -- relative path + filename
				},
				lualine_x = {
					-- { lsp_icon },
					{ "diagnostics", sources = { "nvim_diagnostic" } },
					"filetype",
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			extensions = {},
		}
	end,
}
