local M = {}

function M.detect_prefix(prefix_char, case_sensitive)
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]

	if not line then 
		return false, { "" }
	end

	local before_cursor = line:sub(1, col)
	local after_cursor = line:sub(col + 1)

	local word_start = before_cursor:match("(%S+)$") or ""
	local word_end = after_cursor:match("^(%S*)") or ""

	local word = word_start .. word_end
	local in_prefix_word = (word:sub(1, 1) == prefix_char)

	word = string.sub(word, 2, -1)
	if case_sensitive == false then
		word = word:lower()
	end

	return in_prefix_word, { word }
end

return M
