local M = {}

M.options = {}

M._options = nil

local defaults = {
	binary_path = "/Users/michael/dev/rolodex.nvim/dex"
}

function M.ensure_job(path)
	chan = vim.fn.jobstart({ path }, { rpc = true })
	return chan
end

function M.setup(options)
	print("SETTING UP")
	M._options = options

	if options == nil then
		error("NIL")
	end
	M.options = vim.tbl_deep_extend("force", {}, defaults, M._options or {})

	if M.options.binary_path == nil then
		error("binary_path not populated in opts")
	end

	if M.options.binary_path == "" then
		error("binary_path is empty string in opts")
	end

	vim.notify(M.options.binary_path)

	vim.api.nvim_create_user_command('DexLookup', function(args)
		vim.fn.rpcrequest(
		-- require("rolodex").ensure_job(M.options.binary_path), 
		M.ensure_job(M.options.binary_path), 
		'dex_lookup', args.fargs
	)

	end, { nargs = '*' })
end

return M
