local cmp = require("cmp")
local xor = require("rldx.extras.xor")
local h = require("rldx.extras.md5")
local algos = require("rldx.utils.algos")

local M = {}

local load = {}

function decode_hex_apply(cc)
	return string.char(tonumber(cc, 16))
end

function encode_hex_apply(c)
	return string.format("%02X", string.byte(c))
end

function is_empty(tab)
	if next(tab) == nil then
		return true
	end
	return false
end

function load.from_hex(value, opts, abort)
	if value["metadata"] == nil then
		vim.notify(
			"RLDX contact " .. name .. " has no encryption settings", 
			"error"
		)
		return value, opts, true
	end

	if value.metadata.encryption == "plaintext" then
		return value, opts, abort
	end

	value.name = (value.name:gsub("..", decode_hex_apply))
	if value.properties ~= nil then
		value.properties = (value.properties:gsub("..", decode_hex_apply))
	else
		value.properties = ""
	end
	return value, opts, abort
end

function load.decrypt(value, opts, abort)
	if value["metadata"] == nil then
		vim.notify(
			"RLDX contact " .. name .. " has no encryption settings", 
			"error"
		)
		return value, opts, true
	end

	-- Short circuit for plaintext catalog.
	if value.metadata.encryption == "plaintext" then
		if value.properties == nil or value.properties == "" then
			value.properties = {}
		end
		return value, opts, abort
	end

	if (opts["key"] == nil) or (opts["key"] == "") then
		vim.notify("no RLDX encryption key was provided", "error")
		return value, opts, abort
	end

	value.name = xor(value.name, opts.key)
	if value.properties ~= nil then
		value.properties = vim.fn.json_decode(xor(value.properties, opts.key))
	else
		value.properties = {}
	end

	return value, opts, abort
end

function load.format(value, opts, abort)
	value.name = value.name:gsub("\x0E", ".")
	value.name = string.lower(value.name)
	return value, opts, abort
end

function M.to_completions(data, opts)
	local output = {}

	local abort = false
	local badkey = (opts["key"] == nil) or (opts["key"] == "")
	if (opts["encryption"] ~= "plaintext") and badkey then
		vim.notify("RLDX_ENCRYPTION_KEY environment variable missing", "error")
		abort = true
	end

	for name, value in pairs(data.contacts) do
		if abort == false then
			value, opts, abort = load.from_hex(value, opts, false)
		end

		if abort == false then
			value, opts, abort = load.decrypt(value, opts, abort)
		end

		if abort == false then
			value, opts, abort = load.format(value, opts, abort)
		end

		if abort then
			vim.notify("RLDX is aborting catalog load", "warn")
			return nil
		end

		table.insert(
			output,
			{
				label = value.name,
				properties = value.properties,
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

	entry.label = (entry.label:gsub(".", encode_hex_apply))
	if entry.properties ~= nil then
		entry.properties = (entry.properties:gsub(".", encode_hex_apply))
	else
		entry.properties = {}
	end

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
	if entry.properties ~= nil then
		entry.properties = xor(vim.fn.json_encode(entry.properties), opts.key)
	else
		entry.properties = {}
	end

	return entry, opts, abort
end

function M.from_completions(data, opts)
	local contacts = {}

	local abort = false
	local badkey = (opts["key"] == nil) or (opts["key"] == "")
	if (opts["encryption"] ~= "plaintext") and badkey then
		vim.notify("RLDX_ENCRYPTION_KEY environment variable missing", "error")
		abort = true
	end

	for _, entry in ipairs(data) do
		if opts["hash_salt_len"] == nil then
			vim.notify("failed to get hash salt length", "error")
			abort = true
		end
		local salt = algos.generate_salt(opts["hash_salt_len"])
		local hashed_name = "md5::" .. h.sumhexa(entry.label .. salt)
		if opts["encryption"] == nil then
			vim.notify(
				"no RLDX encryption settings were provided",
				"error"
			)
			return nil
		end


		if abort == false then
			entry, opts, abort = save.encrypt(entry, opts, false)
		end

		if abort == false then
			entry, opts, abort = save.to_hex(entry, opts, abort)
		end

		if abort then
			vim.notify("RLDX is aborting catalog save", "warn")
			return nil
		end

		contact = {
			name = entry.label,
			salt = salt,
			metadata = {
				encryption = opts.encryption
			}
		}

		if entry.properties ~= nil then
			contact.properties = entry.properties
		end

		contacts[hashed_name] = contact
	end
 
	return {
		header = {
			rldx_schema = "0.3.0"
		},
		contacts = contacts,
	}
end

return M


