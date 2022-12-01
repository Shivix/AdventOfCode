local file = io.open("input")
if file == nil then
    error("cannot open file")
    return
end

local current = 0
local result = {}
for line in file:lines() do
    if line == "" then
        result[#result+1] = current
        current = 0
    else
        current = current + tonumber(line)
    end
end

table.sort(result)
print(result[#result])
print(result[#result] + result[#result-1] + result[#result-2])
file:close()
