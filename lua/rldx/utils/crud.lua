local v0_0_2_crud = require("rldx.utils.v0_0_2.crud")

local M = {}

function M.save_contacts(filepath, catalog, ver)
	if ver == "0.0.2" then
		return v0_0_2_crud.save_contacts(filepath, catalog)
	elseif ver == nil then
		vim.notify("invlaid schema version: nil", "error")
		return false, nil
	else
		vim.notify("invalid schema version: " .. ver, "error")
		return false, nil
	end
end

function M.load_contacts(filepath, create, ver)
	if ver == "0.0.2" then
		return v0_0_2_crud.load_contacts(filepath, catalog)
	elseif ver == nil then
		vim.notify("invlaid schema version: nil", "error")
	else
		vim.notify("invalid schema version: " .. ver, "error")
	end
end

return M
