local cmp = require("cmp")
local xor = require("rldx.extras.xor")
local h = require("rldx.extras.md5")

local M = {}

local load = {}

function load.from_hex(value, opts, abort)
	if value["metadata"] == nil then
		vim.notify(
			"RLDX contact " .. name .. "has no encryption settings", 
			"error"
		)
		return value, opts, true
	end

	if value.metadata.encryption == "plaintext" then
		return value, opts, abort
	end

	value.name = (value.name:gsub("..", function(cc)
		return string.char(tonumber(cc, 16))
	end))
	return value, opts, abort
end

function load.decrypt(value, opts, abort)
	if value["metadata"] == nil then
		vim.notify(
			"RLDX contact " .. name .. "has no encryption settings", 
			"error"
		)
		return value, opts, true
	end

	if value.metadata.encryption == "plaintext" then
		return value, opts, abort
	end

	if (opts["key"] == nil) or (opts["key"] == "") then
		vim.notify("no RLDX encryption key was provided", "error")
		return value, opts, abort
	end

	value.name = xor(value.name, opts.key)
	return value, opts, abort
end

function load.format(value, opts, abort)
	value.name = value.name:gsub("\x0E", ".")
	value.name = string.lower(value.name)
	return value, opts, abort
end

function M.to_completions(data, opts)
	local output = {}

	for name, value in pairs(data.contacts) do
		value, opts, abort = load.from_hex(value, opts, false)
		value, opts, abort = load.decrypt(value, opts, abort)
		value, opts, abort = load.format(value, opts, abort)

		if abort then
			vim.notify("RLDX is aborting catalog load", "warn")
			return nil
		end

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

local save = {}

function save.to_hex(entry, opts, abort)
	if opts["encryption"] == nil then
		vim.notify(
			"no RLDX encryption settings were provided",
			"error"
		)
		return entry, opts, true
	end

	if opts.encryption == "plaintext" then
		return entry, opts, abort
	end

	entry.label = (entry.label:gsub(".", function(c)
		return string.format("%02X", string.byte(c))
	end))
	return entry, opts, abort
end

function save.encrypt(entry, opts, abort)
	if opts["encryption"] == nil then
		vim.notify(
			"no RLDX encryption settings were provided",
			"error"
		)
		return entry, opts, true
	end

	if opts.encryption == "plaintext" then
		return entry, opts, abort
	end

	if (opts["key"] == nil) or (opts["key"] == "") then
		vim.notify(
			"no RLDX encryption key was provided",
			"error"
		)
		return entry, opts, true
	end


	entry.label = xor(entry.label, opts.key)
	return entry, opts, abort
end

function M.from_completions(data, opts)
	local contacts = {}

	for _, entry in ipairs(data) do
		hashed_name = "md5::" .. h.sumhexa(entry.label)

		entry, opts, abort = save.encrypt(entry, opts, false)
		entry, opts, abort = save.to_hex(entry, opts, abort)

		if abort then
			vim.notify("RLDX is aborting catalog save", "warn")
			return nil
		end

		contacts[hashed_name] = {
			name = entry.label,
			metadata = {
				encryption = opts.encryption
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
