local cmp = require("cmp")

local M = {}

function M.to_completions(data)
	local output = {}

	local ver = nil
	if data["header"] and data["header"]["rldx_schema"] then
		ver = data["header"]["rldx_schema"]
	end

	if ver ~= "0.1.0" then
		error("tried to read schema ver " .. ver .. " with 0.1.0 adapter")
	end

	if data["contacts"] == nil then
		error("data with schema ver 1.1.0 is missing 'contacts' key")
	end

	for _, entry in ipairs(data["contacts"]) do
		table.insert(
			output,
			{
				label = entry.name,
				kind = cmp.lsp.CompletionItemKind.Text
			}
		)
	end
	return output
end

function M.from_copmletions(data)
	local output = {
		header = {
			rldx_schema = "0.1.0"
		},
		contacts = {}
	}

	local contacts = {}
	for _, entry in ipairs(data) do
		-- TODO: Key should be hash
		contacts[entry.label] = {
			name = entry.label,
			metadata = {
				-- TODO: Update to chosen encryption
				encryption = "plaintext"
			}
		}
	end
end
