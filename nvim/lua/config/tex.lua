vim.g.vimtex_view_method = "skim"
vim.g.UltiSnipsExpandTrigger = "<tab>"
vim.g.UltiSnipsJumpForwardTrigger = "<c-tab>"
vim.g.UltiSnipsJumpBackwardTrigger = "<s-tab>"

vim.api.nvim_create_autocmd("FileType", {
	pattern = "tex",
	callback = function()
		vim.opt.spelllang = "en_us"
		vim.opt.spell = true
		-- inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
		vim.keymap.set("i", "<c-s>", "<c-g>u<Esc>[s1z=`]a<c-g>u", { desc = "Fix the previous spelling mistake" })
	end,
})
