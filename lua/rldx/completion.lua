local cmp = require("cmp")

local sett = require("rldx.settings")
local crud = require("rldx.schema.crud")

local M = {}

M.completion_db = {}

M.completion_options = {}

M.source = {}

M.source.new = function()
	return setmetatable({}, { __index = M.source })
end

M.source.is_available = function()
	return true
end

M.source.get_trigger_characters = function()
	return { sett.options.prefix_char }
end

M.source.complete = function(_, request, callback)
	callback(M.completion_options)
end

function M.update_completion_options(content)
	for _, entry in ipairs(content) do
		table.insert(M.completion_options, {
			label = entry.name,
			kind = cmp.lsp.CompletionItemKind.Text,
		})
	end
end

function M.rolodex_add_cmd(opts)
	local name = opts.args
	ok, err = crud.add_contact(
		sett.options.db_filename,
		name, 
		M.completion_db
	)

	M.update_completion_options(M.completion_db)
	vim.notify("Added '" .. name .. "' to Catalog")
end

return M
