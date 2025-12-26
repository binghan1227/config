-- Shared LSP helpers:
-- - blink.cmp capabilities
-- - LspAttach keymaps (+ which-key groups)
local M = {}

function M.capabilities(extra)
	-- Neovim base capabilities
	local caps = vim.lsp.protocol.make_client_capabilities()

	if extra then
		caps = vim.tbl_deep_extend("force", caps, extra)
	end

	-- Merge blink.cmp capabilities if available
	local ok, blink = pcall(require, "blink.cmp")
	if ok and type(blink.get_lsp_capabilities) == "function" then
		-- blink will include built-in capabilities by default
		return blink.get_lsp_capabilities(caps)
	end

	return caps
end

---@param event {buf: integer, data: {client_id: integer}}
function M.on_attach(event)
	local bufnr = event.buf
	local client = vim.lsp.get_client_by_id(event.data.client_id)

	-- which-key group labels (buffer-local so it’s always relevant)
	local wk_ok, wk = pcall(require, "which-key")
	if wk_ok then
		wk.add({
			{ "<leader>l", group = "LSP" },
			{ "<leader>ld", group = "Diagnostics" },
		}, { buffer = bufnr })
	end

	local function nmap(lhs, rhs, desc)
		vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
	end

	-- Core LSP (using lspsaga for enhanced UI)
	nmap("K", "<cmd>Lspsaga hover_doc<CR>", "Hover")
	nmap("gD", vim.lsp.buf.declaration, "Go to declaration")
	nmap("gd", "<cmd>Lspsaga peek_definition<CR>", "Peek definition")
	nmap("gi", vim.lsp.buf.implementation, "Go to implementation")
	nmap("gr", "<cmd>Lspsaga finder<CR>", "Find references/implementations")
	nmap("gy", vim.lsp.buf.type_definition, "Go to type definition")

	nmap("<leader>lr", "<cmd>Lspsaga rename<CR>", "Rename")
	nmap("<leader>la", "<cmd>Lspsaga code_action<CR>", "Code action")
	nmap("<leader>ls", vim.lsp.buf.signature_help, "Signature help")

	-- Workspace
	nmap("<leader>lW", vim.lsp.buf.workspace_symbol, "Workspace symbols")
	nmap("<leader>lw", "<cmd>Lspsaga outline<CR>", "Document symbols outline")

	-- Diagnostics (using lspsaga for enhanced UI)
	nmap("<leader>ldo", "<cmd>Lspsaga show_line_diagnostics<CR>", "Line diagnostics")
	nmap("<leader>ldn", "<cmd>Lspsaga diagnostic_jump_next<CR>", "Next diagnostic")
	nmap("<leader>ldp", "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Prev diagnostic")
	nmap("<leader>ldl", vim.diagnostic.setloclist, "To loclist")
	nmap("<leader>ldq", vim.diagnostic.setqflist, "To quickfix")

	-- Optional: inlay hints toggle (0.10+)
	if vim.lsp.inlay_hint and client and client.supports_method("textDocument/inlayHint") then
		nmap("<leader>li", function()
			local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
			vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
		end, "Toggle inlay hints")
	end
end

return M
