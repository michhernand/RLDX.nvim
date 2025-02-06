local M = {}

function M.ensure_job(path)
	if chan then
		return chan
	end
	chan = vim.fn.jobstart({ path }, { rpc = true })
	return chan
end

return M

