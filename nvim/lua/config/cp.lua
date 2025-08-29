-- Create a dedicated augroup for our competitive programming setup
local cp_augroup = vim.api.nvim_create_augroup("CompetitiveProgramming", { clear = true })

-- Autocommand to set up the window layout
vim.api.nvim_create_autocmd("BufEnter", {
	group = cp_augroup,
	-- This pattern triggers for any .cpp file inside the target folder
	pattern = "*/Coding/cpp/*.cpp",
	callback = function(args)
		-- Get the directory of the current C++ file
		local dir = vim.fn.fnamemodify(args.file, ":h")
		local inFile = dir .. "/in"
		local outFile = dir .. "/out"

		-- Create 'in' and 'out' files if they don't exist
		if vim.fn.filereadable(inFile) == 0 then
			vim.fn.writefile({}, inFile) -- Creates an empty file
		end
		if vim.fn.filereadable(outFile) == 0 then
			vim.fn.writefile({}, outFile)
		end

		-- Check if 'in' or 'out' are already in a window to prevent re-splitting
		local is_buf_open = function(buf_name_pattern)
			local bufs = vim.api.nvim_list_bufs()
			for _, buf in ipairs(bufs) do
				if
					vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf):match(buf_name_pattern .. "$")
				then
					return true
				end
			end
			return false
		end

		-- If neither 'in' nor 'out' is open, create the split layout
		if not is_buf_open("in") and not is_buf_open("out") then
			-- MODIFICATION HERE: Create a 40-column wide vertical split.
			vim.cmd("40vsplit " .. vim.fn.fnameescape(inFile))
			vim.cmd("split " .. vim.fn.fnameescape(outFile))
			vim.cmd("wincmd l")
		end
	end,
})

local M = {}

function M.compile_and_run()
	local cpp_file = vim.api.nvim_buf_get_name(0)

	if not cpp_file:match("%.cpp$") then
		vim.notify("Not a C++ file.", vim.log.levels.WARN)
		return
	end

	vim.cmd("wall")

	local filename_no_ext = vim.fn.fnamemodify(cpp_file, ":t:r")
	local dir = vim.fn.fnamemodify(cpp_file, ":h")
	local bin_dir = dir .. "/bin"

	-- OrbStack machine name (change if yours is different)
	local orb_machine = "arch"

	if vim.fn.isdirectory(bin_dir) == 0 then
		vim.fn.mkdir(bin_dir, "p")
	end

	-- CORRECTED COMMAND: Removed 'run' and added the '-m' flag for specifying the machine.
	local command = string.format(
		"orb -m %s bash -c 'cd %s && g++ %s.cpp -o bin/%s && ./bin/%s < in > out && cat out && echo \"\n[Finished]\"' ",
		orb_machine,
		vim.fn.fnameescape(dir),
		filename_no_ext,
		filename_no_ext,
		filename_no_ext
	)

	-- (The rest of the function for opening the terminal remains the same)
	local term_buf = vim.api.nvim_create_buf(false, true)
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	vim.api.nvim_open_win(term_buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
		title = "Compilation Output",
		title_pos = "center",
	})

	vim.fn.termopen(command)
	vim.cmd("startinsert")
	vim.api.nvim_buf_set_keymap(term_buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(term_buf, "t", "<Esc>", "<C-\\><C-n>:close<CR>", { noremap = true, silent = true })
end

-- Map the function to a convenient shortcut
vim.keymap.set("n", "<leader>r", M.compile_and_run, {
	noremap = true,
	silent = true,
	desc = "Compile and Run C++ file via OrbStack",
})

return M
