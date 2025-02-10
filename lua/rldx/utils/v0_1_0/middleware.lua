local cmp = require("cmp")
local h = require("rldx.extras.md5")

local M = {}

function M.to_completions(data)
	local output = {}

	if data["contacts"] == nil then
		error("data with schema ver 1.1.0 is missing 'contacts' key")
	end

	for name, value in pairs(data.contacts) do
		table.insert(
			output,
			{
				label = value.name,
				kind = cmp.lsp.CompletionItemKind.Text,
			}
		)
	end
	return output
end

function M.from_completions(data)
	local contacts = {}
	for _, entry in ipairs(data) do
		contacts["md5::" .. h.sumhexa(entry.label)] = {
			name = entry.label,
			metadata = {
				-- TODO: Update to chosen encryption
				encryption = "plaintext"
			}
		}
	end

	return {
		header = {
			rldx_schema = "0.1.0"
		},
		contacts = contacts,
	}
end

return M
