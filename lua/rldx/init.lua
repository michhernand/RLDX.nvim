local cmp = require("cmp")
local sett = require("rldx.settings")
local crud = require("rldx.utils.crud")
local algos = require("rldx.utils.algos")

local M = {}

function M.reset()
	require("rldx").setup()
end

M.VERSION = "0.3.0"

M.contacts = {}

-- Open and edit JSON in a temporary buffer.
function M.open_temp_buffer(contact)
	local buf = vim.api.nvim_create_buf(false, true)
	for option, value in pairs(sett.options.temporary_buffer_options) do
		vim.api.nvim_buf_set_option(buf, option, value)
	end

	local lines = vim.split(vim.fn.json_encode(contact.properties), "\n")
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	vim.cmd("split")
	vim.api.nvim_win_set_buf(0, buf)

	M.temp_buf = buf
	M.temp_name = contact.label

	vim.api.nvim_buf_set_keymap(buf, "n", "<C-c>", "", {
		callback = function() M.close_and_process() end,
		noremap = true,
		silent = true
	})

	vim.api.nvim_buf_set_keymap(buf, "i", "<C-c>", "", {
		callback = function() M.close_and_process() end,
		noremap = true,
		silent = true
	})

	vim.cmd("normal! i")
end

-- Close and save a temporary buffer.
function M.close_and_process()
	local content = table.concat(
	vim.api.nvim_buf_get_lines(M.temp_buf, 0, -1, false),
	"\n"
	)

	local win_id = vim.fn.bufwinid(M.temp_buf)
	if win_id ~= -1 then
		vim.api.nvim_win_close(win_id, true)
	end

	content = vim.fn.json_decode(content)

	local j
	for i, contact in ipairs(M.contacts) do
		if contact.label == M.temp_name then
			j = i
		end
	end

	if j == nil then
		vim.notify("RLDX failed to update properties for '" .. M.temp_name .. "'", "error")
		return
	end

	M.contacts[j].properties = content

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
		vim.notify("RLDX updated properties for '" .. M.temp_name .. "'")
	else
		vim.notify("RLDX failed to update properties")
		return
	end
end

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

	-- Load the catalog
	function M.rldx_load_cmd()
		M.contacts, err = crud.load_contacts(
			sett.options.filename,
			true,
			enc_opts
		)
		if err ~= nil then
			vim.notify("RLDX failed to load contacts", "error")
			return
		end
	end
	M.rldx_load_cmd()

	-- Register the Source with nvim-cmp
	cmp.register_source("cmp_rolodex", M.source.new())

	vim.api.nvim_create_user_command(
		"RldxLoad",
		M.rldx_load_cmd,
		{ nargs = 0 }
	)

	vim.api.nvim_create_user_command(
		"RldxSave",
		M.rldx_save_cmd,
		{ nargs = 0 }
	)

	-- Register the Add Contact command
	vim.api.nvim_create_user_command(
		"RldxAdd", 
		M.rldx_add_cmd,
		{ nargs = 0 }
	)

	vim.api.nvim_create_user_command(
		"RldxDelete",
		M.rldx_delete_cmd,
		{ nargs = 0 }
	)

	vim.api.nvim_create_user_command(
		"RldxList",
		M.rldx_list_cmd,
		{ nargs = 0 }
	)

	vim.api.nvim_create_user_command(
		"RldxProps",
		M.rldx_edit_props_cmd,
		{ nargs = 0 }
	)
end

-- ########################################################
-- COMMANDS

-- List catalog (for debug)
function M.rldx_list_cmd(opts)
	vim.notify(vim.inspect(M.contacts))
end

function M.rldx_edit_props_cmd(opts)
	local name = vim.fn.input('[PROPS] Enter Name: ')
	vim.cmd('redraw')
	vim.cmd('echo ""')

	if name == nil or name == "" then
		vim.notify("RLDX tried to edit props for an invalid name", "error")
		return
	end

	local chosen_contact
	for _, contact in ipairs(M.contacts) do
		if contact.label == name then
			chosen_contact = contact
			break
		end
	end

	if chosen_contact == nil then
		vim.notify("RLDX tried to edit props for a non-existant contact", "error")
		return
	end

	M.open_temp_buffer(chosen_contact)
end

function M.rldx_delete_cmd(opts)
	local name = vim.fn.input('[DELETE] Enter Name: ')
	vim.cmd('redraw')
	vim.cmd('echo ""')

	if name == nil or name == "" then
		vim.notify("RLDX tried to delete an invalid name", "error")
		return
	end

	local filtered_contacts = {}
	for _, contact in ipairs(M.contacts) do
		if contact.label ~= name then
			table.insert(filtered_contacts, contact)
		end
	end
	M.contacts = filtered_contacts


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
		vim.notify("RLDX deleted '" .. name .. "' from Catalog")
	else
		vim.notify("RLDX failed to delete contact from Catalog")
		return
	end
end

function M.rldx_save_cmd(opts)
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
		vim.notify("RLDX saved Catalog")
	else
		vim.notify("RLDX failed to save Catalog")
		return
	end
end

-- Add a contact to catalog
function M.rldx_add_cmd(opts)
	local name = vim.fn.input('[ADD] Enter Name: ')
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
		vim.notify("RLDX added '" .. name .. "' to Catalog")
	else
		vim.notify("RLDX failed to add contact to Catalog")
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
