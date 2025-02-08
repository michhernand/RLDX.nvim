local v0_0_2_crud = require("rldx.schema.v0_0_2.crud")

local M = {}

function M.save_contacts(filepath, catalog, ver)
	if ver == "0.0.2" then
		return v0_0_2_crud.save_contacts(filepath, catalog)
	elseif ver == nil then
		vim.notify("invlaid schema version: nil", "error")
	else
		vim.notify("invalid schema version: " .. ver, "error")
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

function M.add_contact(filepath, name, catalog, ver)
	if ver == "0.0.2" then
		return v0_0_2_crud.add_contact(filepath, name catalog)
	elseif ver == nil then
		vim.notify("invlaid schema version: nil", "error")
	else
		vim.notify("invalid schema version: " .. ver, "error")
	end
end
