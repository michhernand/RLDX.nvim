local utils = require("rldx.utils")

local M = {}

function M.setup_highlight()
	vim.api.nvim_set_hl(0, "RolodexHighlight", { 
		fg = utils.options.highlight_color, 
		bold = utils.options.highlight_bold
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

return M
