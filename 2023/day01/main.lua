local file = io.open("input")
if file == nil then
    error("cannot open file")
    return
end

local result = 0

for line in file:lines() do
    print(line)
    if #arg == 1 and arg[1] == "-2" then
        line = string.gsub(line, "one", "one1one")
        line = string.gsub(line, "two", "two2two")
        line = string.gsub(line, "three", "three3three")
        line = string.gsub(line, "four", "four4four")
        line = string.gsub(line, "five", "five5five")
        line = string.gsub(line, "six", "six6six")
        line = string.gsub(line, "seven", "seven7seven")
        line = string.gsub(line, "eight", "eight8eight")
        line = string.gsub(line, "nine", "nine9nine")
    end
    line = string.gsub(line, "%a", "")
    local first = line:sub(1,1)
    local last = line:sub(-1)
    print(first, last)
    local value = tonumber(first..last)
    result = result + value;
end

print(result)
file:close()
-- lua -e 'result=0 for line in io.lines() do line=string.gsub(line, "%a", "") result=result+tonumber(line:sub(1,1)..line:sub(-1)) end print(result)'
