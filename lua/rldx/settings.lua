local M = {}

M.options = {}

M.session = {
	encryption_key = os.getenv("RLDX_ENCRYPTION_KEY")
}

M.defaults = {
	prefix_char = "@",
	filename = os.getenv("HOME") .. "/.rldx/db.json",
	highlight_enabled = true,
	highlight_color = "#00ffff",
	highlight_bold = true,
	schema_ver = "latest",
	encryption = "plaintext",
	hash_salt_length = 16,
}

function M.resolve_opts(options)
	M.options = vim.tbl_deep_extend(
		"force",
		{}, M.defaults,
		options or {}
	)
end

return M
