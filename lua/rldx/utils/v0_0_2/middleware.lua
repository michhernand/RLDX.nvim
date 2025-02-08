local cmp = require("cmp")

local M = {}

function M.to_completions(data)
	local output = {}
	for _, entry in ipairs(data) do
		table.insert(
			output,
			{
				label = entry.name,
				kind = cmp.lsp.CompletionItemKind.Text,
			}
		)
	end
	return output
end

function M.from_completions(data)
	local output = {}
	for _, entry in ipairs(data) do
		table.insert(
			output,
			{
				name = entry.label,
				count = -1,
			}
		)
	end
	return output
end

return M
