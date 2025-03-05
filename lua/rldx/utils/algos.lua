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

function M.copy_table(obj, seen)
	if type(obj) ~= 'table' then return obj end
	if seen and seen[obj] then return seen[obj] end
	local s = seen or {}
	local res = setmetatable({}, getmetatable(obj))
	s[obj] = res
	for k, v in pairs(obj) do res[M.copy_table(k, s)] = M.copy_table(v, s) end
	return res
end

function M.generate_salt(length)
	length = length or 16
	local chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
	math.randomseed(os.time())
	local salt = ""
	for i = 1, length do
		ix = math.random(1, #chars)
		salt = salt .. string.sub(chars, ix, ix)
	end
	return salt
end

return M


