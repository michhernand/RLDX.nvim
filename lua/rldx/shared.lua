local M = {}

function M.lookup(name, catalog)
	for i, contact in ipairs(catalog) do

		-- Check if it's in RLDX format
		if contact.name ~= nil and contact.name == name then
			return i, contact

		-- Check if it's in cmp format
		elseif contact.label ~= nil and contact.label == name then
			return i, contact
		end
	end
	return -1, nil
end

function M.filter_out(name, catalog)
	filtered_catalog = {}
	for i, contact in ipairs(catalog) do

		-- Check if it's in RLDX format
		if contact.name ~= nil and contact.name ~= name then
			table.insert(filtered_catalog, contact)

		-- Check if it's in cmp format
		elseif contact.label ~= nil and contact.label ~= name then
			table.insert(filtered_catalog, contact)
		end
	end
	return filtered_catalog
end

return M
