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
	if filepath == nil then 
		return false, "rldx.nvim cannot find json db"
	end

	local json_str = vim.fn.json_encode(data)
	local ok, err = pcall(vim.fn.writefile, { json_str }, filepath)
	if not ok then
		return false, "Failed to write file: " .. err
	end
	return true, nil
end

function M.read_json_file(filepath, create)
	if filepath == nil then 
		return {}, "rldx.nvim cannot find json db"
	end

	if (M.file_exists(filepath) == false) and (create == true) then
		M.write_json_file(filepath, {})
	end
	content = vim.fn.readfile(filepath)
	if not content or #content == 0 then
		return {}, nil
	end

	local json_str = table.concat(content, "\n")
	local ok, result = pcall(vim.fn.json_decode, json_str)

	if not ok then 
		return {}, "rldx.nvim failed to parse contact json"
	end

	return result, nil
end
return M
