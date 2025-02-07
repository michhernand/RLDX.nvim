local config = require("rolodex.config")

local M = {}

function M.reset()
	require("rolodex").setup()
end

M.VERSION = "0.0.1"

M.setup = config.setup

return M

