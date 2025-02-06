local M = {}

function M.file_exists(filepath)
	if filepath == nil then error("file exists received invalid argument") end
	local file = io.open(filepath, "r")
	if file then
		file:close()
		return true
	else
		return false
	end
end

function M.write_json_file(filepath, data)
	if filepath == nil then return false, "rolodex.nvim cannot find json db", "warn" end
	local json_str = vim.fn.json_encode(data) -- Convert table to JSON string
	local ok, err = pcall(vim.fn.writefile, { json_str }, filepath) -- Write to file
	if not ok then
		return false, "Failed to write file: " .. err
	end
	return true, nil
end

function M.read_json_file(filepath, create)
	if filepath == nil then return {}, "rolodex.nvim cannot find json db", "warn" end
	if (M.file_exists(filepath) == false) and (create == true) then
		M.write_json_file(filepath, {})
	end
	content = vim.fn.readfile(filepath)
	if not content or #content == 0 then
		return {}, nil
	end

	local json_str = table.concat(content, "\n")
	local ok, result = pcall(vim.fn.json_decode, json_str)
	if not ok then return {}, "rolodex.nvim failed to parse contact json", "warn" end
	return result, nil
end

function M.sort(data)
	table.sort(data, function(a, b)
		return a.count > b.count
	end)
	return data
end

return M

