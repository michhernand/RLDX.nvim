--[[
MIT License

Copyright (c) 2020 Brayan

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]

local bit = require("bit")

local function repeat_key(key, length)
    if #key >= length then
        return key:sub(1, length)
    end

    local times = math.floor(length / #key)
    local remain = length % #key
    local result = ''

    for _ = 1, times do
        result = result .. key
    end

    if remain > 0 then
        result = result .. key:sub(1, remain)
    end

    return result
end

local function xor(message, key)
    local rkey = repeat_key(key, #message)
    local result = {}

    for i = 1, #message do
        local k_byte = rkey:byte(i)
        local m_byte = message:byte(i)

        local xor_byte = bit.bxor(m_byte, k_byte)
        result[i] = string.char(xor_byte)
    end

    return table.concat(result)
end

return xor

