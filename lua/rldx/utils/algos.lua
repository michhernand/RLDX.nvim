local M = {}

function M.sort(data)
	table.sort(data, function(a, b)
		return a.count > b.count
	end)
	return data
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
    local salt = ""
    
    -- Get system-specific information
    local unique_data = ""
    
    -- Memory address of a new table (contains system pointer info)
    unique_data = unique_data .. tostring({})
    
    -- Try to get hostname (works on many systems)
    local hostname_file = io.popen("hostname")
    if hostname_file then
        local hostname = hostname_file:read("*a") or ""
        hostname_file:close()
        unique_data = unique_data .. hostname
    end
    
    -- Try to get process ID (works on Unix-like systems)
    local pid_file = io.popen("echo $PPID")
    if pid_file then
        local pid = pid_file:read("*a") or ""
        pid_file:close()
        unique_data = unique_data .. pid
    end
    
    -- Hash the unique data into a number
    local hash_value = 0
    for i = 1, #unique_data do
        hash_value = (hash_value * 256 + string.byte(unique_data, i)) % 2147483647
    end
    
    -- Seed with combination of time and hardware info
    math.randomseed(os.time() + hash_value + os.clock() * 1000000)
    
    -- Generate the salt
    for i = 1, length do
        local ix = math.random(1, #chars)
        salt = salt .. string.sub(chars, ix, ix)
    end
    
    return salt
end

return M


