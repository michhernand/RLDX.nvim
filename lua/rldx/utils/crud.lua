local fs = require("rldx.utils.fs")

local v0_0_2_mw = require("rldx.utils.v0_0_2.middleware")

local M = {}

function M.save_contacts(filepath, catalog, ver)
	if ver == "0.0.2" then
		catalog = v0_0_2_mw.from_completions(catalog)
	elseif ver == nil then
		vim.notify("invlaid schema version: nil", "error")
		return false
	else
		vim.notify("invalid schema version: " .. ver, "error")
		return false
	end

	local ok, err = fs.write_json_file(
		filepath,
		catalog
	)

	if err ~= nil then
		vim.notify(err, "error")
		return false
	end

	return true
end

function M.load_contacts(filepath, create, ver)
	local catalog, err = fs.read_json_file(filepath, create)
	if err ~= nil then
		vim.notify(err, "error")
		return nil
	end

	if ver == "0.0.2" then
		catalog = v0_0_2_mw.to_completions(catalog)
	elseif ver == nil then
		vim.notify("invlaid schema version: nil", "error")
		return {}
	else
		vim.notify("invalid schema version: " .. ver, "error")
		return {}
	end

	return catalog
end

return M
