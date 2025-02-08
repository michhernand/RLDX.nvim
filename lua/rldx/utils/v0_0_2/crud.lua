local utils = require("rldx.utils.fs")
local middleware = require("rldx.utils.v0_0_2.middleware")

local M = {}

function M.save_contacts(filepath, catalog)
	local catalog = middleware.from_completions(catalog)
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

return M
