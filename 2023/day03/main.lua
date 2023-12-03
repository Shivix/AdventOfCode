local function is_symbol(c)
    return c < '.' or c > '9' or c == '/'
end

local WIDTH = 140

local function make_adjacent_positions(i)
    return {
        i - 1,
        i - WIDTH - 1,
        i - WIDTH,
        i - WIDTH + 1,
        i + 1,
        i + WIDTH - 1,
        i + WIDTH,
        i + WIDTH + 1
    }
end

local schematic = {}
for line in io.lines("input") do

    for char in line:gmatch(".") do
        table.insert(schematic, char)
    end
end

local part_ref = {}
local part_positions = {}
local part_number = ""

for pos, character in ipairs(schematic) do
    if string.match(character, "%d") then
        part_number = part_number .. character
        table.insert(part_positions, pos)
    else
        for _, p in ipairs(part_positions) do
            part_ref[p] = tonumber(part_number)
        end
        part_positions = {}
        part_number = ""
    end
end

local part1 = 0
local part2 = 0
local parts_counted = {}

for i, char in ipairs(schematic) do
    if not is_symbol(char) then
        goto continue;
    end
    local first_part = 0
    for _, pos in ipairs(make_adjacent_positions(i)) do
        local part = part_ref[pos]
        if part ~= nil then
            -- N.B. No part numbers have more than one adjacent symbol
            if parts_counted[part] == nil then
                parts_counted[part] = true
                part1 = part1 + part
            end
            -- part 2
            if char == '*' then
                if first_part ~= 0 and part ~= first_part then
                    part2 = part2 + first_part * part
                end
                first_part = part
            end
        end
    end
    parts_counted = {}
    ::continue::
end

print("part1:", part1, "part2:", part2)
