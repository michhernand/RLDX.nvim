local cmp = require("cmp")
local sett = require("rldx.settings")
local crud = require("rldx.utils.crud")

local M = {}

function M.reset()
	require("rldx").setup()
end

M.VERSION = "0.1.0"

M.contacts = {}

function M.getPath(str)
	return str:match("(.*[/\\])")
end

function M.setup_highlight(color, bold)
	vim.api.nvim_set_hl(0, "RolodexHighlight", { 
		fg = color, 
		bold =bold, 
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
	os.execute("mkdir -p " .. M.getPath(sett.options.filename))
	os.execute("touch " .. sett.options.filename)

	if sett.options.highlight_enabled == true then
		M.setup_highlight(
			sett.options.highlight_color,
			sett.options.highlight_bold
		)
	end

	-- Load Contacts Database
	M.contacts, err = crud.load_contacts(
		sett.options.filename,
		true,
		"0.0.2"
	)

	-- Register the Source with nvim-cmp
	cmp.register_source("cmp_rolodex", M.source.new())

	-- Register the Add Contact command
	vim.api.nvim_create_user_command(
		"RldxAdd", 
		M.rldx_add_cmd,
		{ nargs = 1 }
	)

	vim.api.nvim_create_user_command(
		"RldxList",
		M.rldx_list_cmd,
		{ nargs = 0 }
	)
end

-- ########################################################
-- COMMANDS
function M.rldx_list_cmd(opts)
	vim.notify(vim.inspect(M.contacts))
end

function M.rldx_add_cmd(opts)
	local name = opts.args
	table.insert(
		M.contacts, 
		{
			label = name,
			kind = cmp.lsp.CompletionItemKind.Text,
		}
	)

	ok, err = crud.save_contacts(
		sett.options.filename,
		M.contacts,
		sett.options.schema_ver
	)
	
	if ok == true then
		vim.notify("Added '" .. name .. "' to Catalog")
	else
		vim.notify(err)
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
