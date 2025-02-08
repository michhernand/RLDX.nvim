
local M = {}

M.options = {}

M.defaults = {
	prefix_char = "@",
	db_filename = os.getenv("HOME") .. "/.rldx/db.json",
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
	if filepath == nil then return {}, "rldx.nvim cannot find json db", "warn" end
	if (M.file_exists(filepath) == false) and (create == true) then
		M.write_json_file(filepath, {})
	end
	content = vim.fn.readfile(filepath)
	if not content or #content == 0 then
		return {}, nil
	end

	local json_str = table.concat(content, "\n")
	local ok, result = pcall(vim.fn.json_decode, json_str)
	if not ok then return {}, "rldx.nvim failed to parse contact json", "warn" end
	return result, nil
end

function M.sort(data)
	table.sort(data, function(a, b)
		return a.count > b.count
	end)
	return data
end

-- Credit: https://stackoverflow.com/questions/20066835/lua-remove-duplicate-elements
function M.dedupe(data)
	local hash = {}
	local res = {}

	for _,v in ipairs(data) do
		if (not hash[v]) then
			res[#res+1] = v
			hash[v] = true
		end
	end
	return res
end

return M


