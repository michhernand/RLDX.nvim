local M = {}

function M.extract_chars(i, line)
        local char = line:sub(i, i)
	local prev_char = " "
	if (i ~= 1) then 
		prev_char = line:sub(i - 1, i - 1)
	end
	return char, prev_char
end

function M.eval_char(i, char, prev_char, prefix, start)
	local finish = nil

	-- Required: char == prefix
	-- Required One of:
	--	- Beginning of line (i == 1)
	--	- New word (prev_char = " ")
	if (char == prefix) and ((i == 1) or (prev_char == " ")) then
		-- Grab the index as the start of the word.
		start = i

	-- Required: start is not nil
	-- Required One of:
	--	- char is space (char == " ")
        elseif (start ~= nil) and (char == " ") then
            finish = i - 1
        end

	return start, finish
end

-- if start == nil and end == nil then prefix not found.
-- if start != nil and end == nil then prefix was found at the last word of the line.
-- if start != nil and end != nil then prefix was found before the last word of the line.
function M.get_word(line, prefix)
	local start = nil
	local finish = nil

	for i = 1, #line do
		char, prev_char = M.extract_chars(i, line)
		if char == nil then
			return start, finish
		end

		start, finish = M.eval_char(i, char, prev_char, prefix, start)
		if (start ~= nil) and (finish ~= nil) then
			return start, finish
		end
	end
	return start, finish
end

function M.autocomplete_handler()
    -- Get the current line and cursor position
    local line = vim.api.nvim_get_current_line()
    local pos = vim.api.nvim_win_get_cursor(0)[2] + 1

    vim.notify("LINE=" .. line, vim.log.levels.INFO)
    local start, finish, reason = get_word(line, "!")
    vim.notify("reason=" .. reason)
    if (start == nil) or (finish == nil) then
        return nil
    end

    if (pos < start) or (pos > finish) then
	    vim.notify("cursor not on target word")

        return nil
    end

    local word = string.sub(line, start, finish)
    print("Autocomplete triggered for word:", word)
    vim.notify("WORD=" .. word)
    return word
end

return M

