local cmp = require("cmp")
local xor = require("rldx.extras.xor")
local h = require("rldx.extras.md5")
local algos = require("rldx.utils.algos")

local M = {}

local load = {}

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

	value.name = (value.name:gsub("..", function(cc)
		return string.char(tonumber(cc, 16))
	end))
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

		contacts[hashed_name] = {
			name = entry.label,
			salt = salt,
			metadata = {
				encryption = opts.encryption
			}
		}
	end
 
	return {
		header = {
			rldx_schema = "0.2.0"
		},
		contacts = contacts,
	}
end

return M

