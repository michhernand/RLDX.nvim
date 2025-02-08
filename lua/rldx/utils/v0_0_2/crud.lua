local utils = require("rldx.utils.fs")
local middleware = require("rldx.schema.v0_0_2.middleware")

local M = {}

function M.save_contacts(filepath, catalog)
	local ok, err = utils.write_json_file(
		filepath,
		catalog
	)
	return ok, err
end

function M.load_contacts(filepath, create)
	local catalog, err = utils.read_json_file(filepath, create)
	if err ~= nil then
		return nil, err
	end
	return middleware.to_completions(catalog), nil
end

function M.add_contact(filepath, name, catalog)
	table.insert(catalog, { name = name, count= -1 })
	return M.save_contacts(filepath, catalog)
end

return M
