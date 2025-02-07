local cmp = require("cmp")

local utils = require("rolodex.utils")

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
	return { utils.options.prefix_char }
end

M.source.complete = function(_, request, callback)
	callback(M.completion_options)
end

function M.update_completion_options(content)
	for _, entry in ipairs(utils.sort(content)) do
		table.insert(M.completion_options, {
			label = entry.name,
			kind = cmp.lsp.CompletionItemKind.Text,
		})
	end
end

function M.rolodex_add_cmd(opts)
	local name = opts.args
	table.insert(M.completion_db, {name=name, count=0})
	utils.write_json_file(
		utils.options.db_filename, 
		utils.sort(M.completion_db)
	)

	M.update_completion_options(M.completion_db)
	vim.notify("Added '" .. name .. "' to Rolodex")
end

return M
