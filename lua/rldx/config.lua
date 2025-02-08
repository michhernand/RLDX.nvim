local cmp = require("cmp")
local comp = require("rldx.completion")
local hl = require("rldx.highlighting")

local utils = require("rldx.utils")

local M = {}

function M.getPath(str)
	return str:match("(.*[/\\])")
end

function M.setup(options)
	utils.resolve_opts(options)
	os.execute("mkdir -p " .. M.getPath(utils.options.db_filename))
	os.execute("touch " .. utils.options.db_filename)

	if utils.options.highlight_enabled then
		hl.setup_highlight()
	end

	content, err = utils.read_json_file(utils.options.db_filename)
	if err ~= nil then
		vim.notify(err, "warn")
	end

	comp.update_completion_options(content)
	comp.completion_db = content
	cmp.register_source("cmp_rolodex", comp.source.new())

	vim.api.nvim_create_user_command(
	"RolodexAdd", 
	comp.rolodex_add_cmd,
	{ nargs = 1 }
	)
end

cmp.event:on("confirm_done", function(event)
	local entry = event.entry:get_insert_text()
	if entry then
		for i, dbentry in ipairs(comp.completion_db) do
			if dbentry.name == entry then
				comp.completion_db[i].count = comp.completion_db[i].count + 1
				break
			end
		end
	end

	utils.write_json_file(
	utils.options.db_filename, 
	utils.sort(comp.completion_db)
	)
end)

return M

