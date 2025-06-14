-- return {
-- 	"nvim-treesitter/nvim-treesitter",
-- 	branch = "main",
-- 	build = ":TSUpdate",
-- 	event = "VeryLazy",
-- 	opts = {
-- 		ensure_installed = { "lua", "cpp", "python", "latex", "markdown", "rust" },
-- 		highlight = { enable = true },
-- 	},
-- 	config = function (_, opts)
-- 		require("nvim-treesitter").setup(opts)
-- 		require('nvim-treesitter.configs').setup({ highlight = { enable = true } })
--
-- 	end
-- }
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
    config = function()
        local nvim_treesitter = require "nvim-treesitter"
        nvim_treesitter.setup()

        local ensure_installed = { "lua", "cpp", "python", "latex", "markdown", "rust" }

        local pattern = {}
        for _, parser in ipairs(ensure_installed) do
            -- neovim 自己的 api，找不到这个 parser 会报错
            local has_parser, _ = pcall(vim.treesitter.language.inspect, parser)

            if not has_parser then
                -- install 是 nvim-treesitter 的新 api，默认情况下无论是否安装 parser 都会执行，所以这里我们做一个判断
                nvim_treesitter.install(parser)
            else
                -- 新版本需要手动启动高亮，但没有安装相应 parser会导致报错
                pattern = vim.tbl_extend("keep", pattern, vim.treesitter.language.get_filetypes(parser))
            end
        end
        -- vim.api.nvim_create_autocmd("FileType", {
        --     pattern = pattern,
        --     callback = function()
        --         vim.treesitter.start()
        --     end,
        -- })
        -- -- VeryLazy 晚于 FileType，所以需要手动触发一下
        -- vim.api.nvim_exec_autocmds("FileType", {})
    end,
}
