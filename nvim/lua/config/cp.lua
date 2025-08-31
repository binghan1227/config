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

		local is_term_open = function()
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				if vim.bo[vim.api.nvim_win_get_buf(win)].buftype == "terminal" then
					return true
				end
			end
			return false
		end

		-- If neither 'in' nor 'out' is open, create the split layout
		if not is_buf_open("in") and not is_buf_open("out") and not is_term_open() then
			-- MODIFICATION HERE: Create a 40-column wide vertical split.
			vim.cmd("40vsplit " .. vim.fn.fnameescape(inFile))
			vim.cmd("split " .. vim.fn.fnameescape(outFile))
			vim.cmd("15split | terminal") -- Open a 15-line terminal below 'out'
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

	local command = string.format(
		"orb -m %s bash -c 'cd %s && g++ %s.cpp -o bin/%s && time ./bin/%s < in > out && cat out' ",
		orb_machine,
		vim.fn.fnameescape(dir),
		filename_no_ext,
		filename_no_ext,
		filename_no_ext
	)

	-- Find the open terminal buffer
	local term_buf = nil
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf].buftype == "terminal" then
			term_buf = buf
			break
		end
	end

	-- If a terminal is found, send the command to it
	if term_buf then
		local job_id = vim.b[term_buf].terminal_job_id
		if job_id and job_id > 0 then
			-- Send the command to the terminal's job, adding '\r' to simulate pressing Enter
			vim.fn.chansend(job_id, command .. "\r")
			vim.notify("Command sent to terminal.", vim.log.levels.INFO)
		else
			vim.notify("Terminal found, but no job is running.", vim.log.levels.ERROR)
		end
	else
		vim.notify("No terminal window found.", vim.log.levels.ERROR)
	end
end

-- Map the function to a convenient shortcut
vim.keymap.set("n", "<leader>r", M.compile_and_run, {
	noremap = true,
	silent = true,
	desc = "Compile and Run C++ file via OrbStack",
})

return M
