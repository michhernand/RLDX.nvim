local config = require("rolodex.config")

local M = {}

M.VERSION = "0.0.1"

M.setup = config.setup

function M.reset()
	require("rolodex").setup()
end

vim.api.nvim_set_hl(0, "RolodexHighlight", { fg = "#ff0000", bold = true })

vim.cmd [[
  syntax match RolodexPattern /\v\@\w+\.\w+/
  highlight link RolodexPattern RolodexHighlight
]]



vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
        vim.cmd [[
            syntax match RolodexPattern /\v\@\w+\.\w+/
            highlight link RolodexPattern RolodexHighlight
        ]]
    end,
})


return M

