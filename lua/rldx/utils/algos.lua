local M = {}

function M.sort(data)
	table.sort(data, function(a, b)
		return a.count > b.count
	end)
	return data
end

-- Credit: https://stackoverflow.com/questions/20066835/lua-remove-duplicate-elements
function M.dedupe(data)
	local hash = {}
	local res = {}

	for _,v in ipairs(data) do
		if (not hash[v]) then
			res[#res+1] = v
			hash[v] = true
		end
	end
	return res
end

return M


