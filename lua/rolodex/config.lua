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

function M.detect_prefix(prefix_char, case_sensitive)
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]

	if not line then 
		return {
			false,
			"",
		}
	end

	local before_cursor = line:sub(1, col)
	local after_cursor = line:sub(col + 1)

	local word_start = before_cursor:match("(%S+)$") or ""
	local word_end = after_cursor:match("^(%S*)") or ""

	local word = word_start .. word_end
	local in_prefix_word = (word:sub(1, 1) == prefix_char)

	word = string.sub(word, 2, -1)
	if case_sensitive == false then
		word = word:lower()
	end

	return {
		in_prefix_word,
		word,
	}
end

function M.setup(options)
	M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})

	if M.options.binary_path == nil then
		vim.notify("binary_path not populated in opts", "error")
	end

	if M.options.binary_path == "" then
		vim.notify("binary_path is empty string in opts", "error")
	end

	if M.options.prefix_char == nil then
		vim.notify("prefix_char is not populated in opts", "error")
	end

	if M.options.prefix_char == "" then
		vim.notify("prefix_char is empty string in opts", "error")
	end

	vim.api.nvim_create_user_command('DexLookup', function(args)
		local prefix_args = M.detect_prefix(
			M.options.prefix_char, 
			M.options.case_sensitive
		)

		vim.notify("LUA WORD: " .. prefix_args[2])
		if prefix_args[1] == false then
			vim.notify("Terminating Early")
			return
		end

		local result = vim.fn.rpcrequest(
		M.ensure_job(M.options.binary_path), 
		'dex_lookup', prefix_args
		)

		if result ~= nil then
			vim.notify(vim.inspect(result))
		end

	end, { nargs = '*' })
end

return M
