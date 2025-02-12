local fs = require("rldx.utils.fs")
local algos = require("rldx.utils.algos")

local v0_0_2_mw = require("rldx.utils.v0_0_2.middleware")
local v0_1_0_mw = require("rldx.utils.v0_1_0.middleware")

local M = {}

function M.save_contacts(filepath, catalog, ver, opts)
	if ver == "0.0.2" then
		catalog = v0_0_2_mw.from_completions(catalog, opts)
	elseif (ver == "0.1.0") or (ver == "latest") then
		catalog = v0_1_0_mw.from_completions(catalog, opts)
	elseif ver == nil then
		vim.notify("invlaid schema version: nil", "error")
		return false
	else
		vim.notify("invalid schema version: " .. ver, "error")
		return false
	end

	if catalog == nil then
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

function M.load_contacts(filepath, create, opts)
	local catalog, err = fs.read_json_file(filepath, create)
	if err ~= nil then
		vim.notify(err, "error")
		return nil
	end

	local ver = nil
	local msg = nil
	if catalog["header"] and catalog["header"]["rldx_schema"] then
		ver = catalog["header"]["rldx_schema"]
	else
		ver = "0.0.2"
	end

	if ver == "0.0.2" then
		catalog = v0_0_2_mw.to_completions(catalog, opts)
	elseif ver == "0.1.0" then
		catalog = v0_1_0_mw.to_completions(catalog, opts)
	elseif ver == nil then
		vim.notify("invlaid schema version: nil", "error")
		return {}
	else
		vim.notify("invalid schema version: " .. ver, "error")
		return {}
	end

	if catalog == nil then
		return {}
	end

	vim.notify("Loaded " .. #catalog .. " RLDX contacts using catalog v" .. ver, "trace")
	return catalog
end

return M
