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
            finish = i
        end

	return start, finish
end

-- if start == nil and end == nil then prefix not found.
-- if start != nil and end == nil then prefix was found at the last word of the line.
-- if start != nil and end != nil then prefix was found before the last word of the line.
function M.get_words(line, prefix)
	local start = nil
	local starts = {}

	local finish = nil
	local finishes = {}

	for i = 1, #line do
		char, prev_char = M.extract_chars(i, line)
		if char == nil then
			return starts, finishes
		end

		start, finish = M.eval_char(i, char, prev_char, prefix, start)
		if (start ~= nil) and ((finish ~= nil) or (i == #line)) then
			table.insert(starts, start)
			if (finish ~= nil) then
				table.insert(finishes, finish)
			end
			start = nil
			finish = nil
		end
	end
	return starts, finishes
end

function M.is_on_target(line, prefix, pos)
	starts, finishes = M.get_words(line, prefix)
	if #starts < #finishes then
		error("finishes list cannot be longer than starts list")
	end

	for i = 1, math.max(#starts, #finishes) do
		start_ok = true
		if pos < starts[i] then
			start_ok = false
		end

		finish_ok = true
		if i <= #finishes then
			if pos > finishes[i] then
				finish_ok = false
			end
		end

		if start_ok and finish_ok then
			return true
		end
	end
	return false
end

function M.autocomplete_handler()
end

return M

