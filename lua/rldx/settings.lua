local M = {}

M.options = {}

M.defaults = {
	prefix_char = "@",
	filename = os.getenv("HOME") .. "/.rldx/db.json",
	highlight_enabled = true,
	highlight_color = "#00ffff",
	highlight_bold = true,
	encryption = "xor", -- Options: xor, <more to come>
}

function M.resolve_opts(options)
	M.options = vim.tbl_deep_extend(
		"force",
		{}, M.defaults,
		options or {}
	)
end

return M
