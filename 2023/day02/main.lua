local file = io.open("input")
assert(file)

local part1 = 0
local part2 = 0

-- Game 3: 3 green, 4 red; 10 red, 2 blue, 5 green; 9 red, 3 blue, 5 green
for line in file:lines() do
    local id = tonumber(line:match("Game ([0-9]+): "))
    local colours = {}
    for amount, colour in line:gmatch("([0-9]+) ([a-zA-Z]+)") do
        colours[colour] = math.max(colours[colour] or 0, tonumber(amount))
    end
    if colours.red <= 12 and colours.green <= 13 and colours.blue <= 14 then
        part1 = part1 + id;
    end
    part2 = part2 + colours.red * colours.green * colours.blue
end

print(part1, part2)
file:close()
