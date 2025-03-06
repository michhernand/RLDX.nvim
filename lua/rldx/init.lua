local cmp = require("cmp")
local sett = require("rldx.settings")
local crud = require("rldx.utils.crud")
local algos = require("rldx.utils.algos")

local M = {}

function M.reset()
	require("rldx").setup()
end

M.VERSION = "0.2.0"

M.contacts = {}

function M.getPath(str)
	return str:match("(.*[/\\])")
end

function M.setup_highlight(color, bold)
	vim.api.nvim_set_hl(0, "RolodexHighlight", { 
		fg = color, 
		bold = bold, 
	})

	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		pattern = "*",
		callback = function()
			vim.cmd [[
			syntax match RolodexPattern /\v\@\w+\.\w+/
			highlight link RolodexPattern RolodexHighlight
			]]
		end,
	})
end

function M.setup(options)
	sett.resolve_opts(options)

	local nilkey = sett.session.encryption_key == nil
	local emptykey = sett.session.encryption_key == ""
	local plaintext = sett.session.encryption == "plaintext"

	if nilkey then
		sett.session.encryption_key = ""
		if plaintext == false then
			vim.notify("RLDX_ENCRYPTION_KEY env var missing", "warn")
		end
	elseif emptykey and (plaintext == false) then
		vim.notify("RLDX_ENCRYPTION_KEY env var missing", "warn")
	end

	os.execute("mkdir -p " .. M.getPath(sett.options.filename))
	os.execute("touch " .. sett.options.filename)

	if sett.options.highlight_enabled == true then
		M.setup_highlight(
			sett.options.highlight_color,
			sett.options.highlight_bold
		)
	end

	enc_opts = {
		encryption = sett.options.encryption,
		key = sett.session.encryption_key,
	}

	-- Load Contacts Database
	M.contacts, err = crud.load_contacts(
		sett.options.filename,
		true,
		enc_opts
	)

	-- Register the Source with nvim-cmp
	cmp.register_source("cmp_rolodex", M.source.new())

	-- Register the Add Contact command
	vim.api.nvim_create_user_command(
		"RldxAdd", 
		M.rldx_add_cmd,
		{ nargs = 0 }
	)

	vim.api.nvim_create_user_command(
		"RldxList",
		M.rldx_list_cmd,
		{ nargs = 0 }
	)
end

-- ########################################################
-- COMMANDS

-- List catalog (for debug)
function M.rldx_list_cmd(opts)
	vim.notify(vim.inspect(M.contacts))
end

-- Add a contact to catalog
function M.rldx_add_cmd(opts)
	local name = vim.fn.input('Enter Name: ')
	vim.cmd('redraw')
	vim.cmd('echo ""')

	if name == nil or name == "" then
		vim.notify("RLDX tried to add an invalid name", "error")
		return
	end

	table.insert(
		M.contacts, 
		{
			label = name,
			kind = cmp.lsp.CompletionItemKind.Text,
		}
	)

	enc_opts = {
		encryption = sett.options.encryption,
		key = sett.session.encryption_key,
		hash_salt_len = sett.options.hash_salt_length,
	}

	ok, err = crud.save_contacts(
		sett.options.filename,
		algos.copy_table(M.contacts),
		sett.options.schema_ver,
		enc_opts
	)

	if ok == true then
		vim.notify("Added '" .. name .. "' to Catalog")
	else
		vim.notify("Failed to add contact to Catalog")
		return
	end
end
-- ########################################################


-- ########################################################
-- cmp source configuration
M.source = {}

M.source.new = function()
	return setmetatable({}, { __index = M.source })
end

M.source.is_available = function()
	return true
end

M.source.get_trigger_characters = function()
	return { sett.options.prefix_char }
end

M.source.complete = function(_, request, callback)
	callback(M.contacts)
end
-- ########################################################

return M
