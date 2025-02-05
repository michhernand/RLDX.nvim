local M = {}

function M.autocomplete_handler()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]

	if not line then return end

	local before_cursor = line:sub(1, col)
	local after_cursor = line:sub(col + 1)

	local word_start = before_cursor:match("(%S+)$") or ""
	local word_end = after_cursor:match("^(%S*)") or ""

	local word = word_start .. word_end
	if word:sub(1, 1) == "@" then
		vim.notify("has prefix -> " .. word)
	end
end

return M

