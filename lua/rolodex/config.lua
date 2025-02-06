local utils = require("rolodex.utils")

local M = {}

M.options = {}

M._options = nil

local defaults = {
	prefix_char = "@",
	binary_path = "/Users/michael/dev/rolodex.nvim/dex",
	case_sensitive = false,
}

local chan = nil

function M.ensure_job(path)
	if chan then
		return chan
	end

	chan = vim.fn.jobstart({ path }, { rpc = true })
	return chan
end


function M.handle_request(args)
	local in_prefix_word, args = utils.detect_prefix(
		M.options.prefix_char, 
		M.options.case_sensitive
	)

	if in_prefix_word == false then
		return
	end

	local result = vim.fn.rpcrequest(
	M.ensure_job(M.options.binary_path), 
	'dex_lookup', args
	)

	if result ~= nil then
		vim.notify(vim.inspect(result))
	end
end


function M.setup(options)
	M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})
	vim.api.nvim_create_user_command('DexLookup', M.handle_request, { nargs = '*' })
end

return M
