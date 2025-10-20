return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	event = "VeryLazy",
	config = function()
		local registry = require("mason-registry")

		local function install(name)
			local success, package = pcall(registry.get_package, name)
			if success and not package:is_installed() then
				package:install()
			elseif not success then
				print("something wrong in none-ls")
			end
		end

		install("stylua")
		install("clang-format")
		install("pyink")
		install("rustfmt")
		install("asmfmt")

		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.pyink,
				null_ls.builtins.formatting.clang_format.with({
					extra_args = { "--style=file" },
				}),
				null_ls.builtins.formatting.asmfmt,
				-- null_ls.builtins.formatting.rustfmt.with({
				-- 	extra_args = function(params)
				--     local Path = require("plenary.path")
				--     local cargo_toml = Path:new(params.root .. "/" .. "Cargo.toml")
				--
				--     if cargo_toml:exists() and cargo_toml:is_file() then
				--         for _, line in ipairs(cargo_toml:readlines()) do
				--             local edition = line:match([[^edition%s*=%s*%"(%d+)%"]])
				--             if edition then
				--                 return { "--edition=" .. edition }
				--             end
				--         end
				--     end
				--     -- default edition when we don't find `Cargo.toml` or the `edition` in it.
				--     return { "--edition=2021" }
				-- end
				-- }),
			},
		})
	end,
	keys = {
		{
			"<leader>lf",
			vim.lsp.buf.format,
			desc = "Formatting code",
		},
	},
}
