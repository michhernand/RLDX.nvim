local cmp = require("cmp")

local utils = require("rolodex.utils")

local M = {}

M.options = {}

M._options = nil

local defaults = {
	prefix_char = "@",
	db_filename = "./db.json",
	highlight_enabled = true,
	highlight_color = "#00ffff",
	hgihlight_bold = true,
}




M.completion_db = {}

M.completion_options = {}

local source = {}

source.new = function()
	return setmetatable({}, { __index = source })
end

source.is_available = function()
	return true
end

source.get_trigger_characters = function()
	return { M.options.prefix_char }
end

source.complete = function(_, request, callback)
	callback(M.completion_options)
end

function M.update_completion_options(content)
	for _, entry in ipairs(utils.sort(content)) do
		table.insert(M.completion_options, {
			label = entry.name,
			kind = cmp.lsp.CompletionItemKind.Text,
		})
	end
end


function M.setup_highlight()
	vim.api.nvim_set_hl(0, "RolodexHighlight", { 
		fg = M.options.highlight_color, 
		bold = M.options.highlight_bold
	})

	vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
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
	M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})
	
	if M.options.highlight_enabled then
		M.setup_highlight()
	end

	content, err = utils.read_json_file(M.options.db_filename)
	if err ~= nil then
		vim.notify(err, "warn")
	end

	M.update_completion_options(content)
	M.completion_db = content

	cmp.register_source("cmp_rolodex", source.new())

	vim.api.nvim_create_user_command(
	"RolodexAdd",
	function(opts)
		local name = opts.args
		table.insert(M.completion_db, {name=name, count=0})
		utils.write_json_file(M.options.db_filename, utils.sort(M.completion_db))
		M.update_completion_options(M.completion_db)
		vim.notify("Added '" .. name .. "' to Rolodex")
	end,
	{ nargs = 1 }
	)
end

cmp.event:on("confirm_done", function(event)
    local entry = event.entry:get_insert_text()
    if entry then
	for i, dbentry in ipairs(M.completion_db) do
		if dbentry.name == entry then
			M.completion_db[i].count = M.completion_db[i].count + 1
			break
		end
	end
    end

    utils.write_json_file(M.options.db_filename, utils.sort(M.completion_db))
end)

return M

