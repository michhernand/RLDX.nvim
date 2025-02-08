local config = require("rldx.config")

local M = {}

function M.reset()
	require("rldx").setup()
end

M.VERSION = "0.1.0"

M.setup = config.setup

return M

