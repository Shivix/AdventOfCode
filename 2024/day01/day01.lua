local file = assert(io.open("input", "r"))

local left_set = {}
local right_set = {}
for line in file:lines() do
    local split_pos = assert(line:find("%s"))

    local left = string.sub(line, 1, split_pos):gsub("%s", "")
    local right = string.sub(line, split_pos):gsub("%s", "")

    table.insert(left_set, left)
    table.insert(right_set, right)
end
file:close()

table.sort(left_set)
table.sort(right_set)

local part1 = 0
for i, left_val in ipairs(left_set) do
    local right_val = right_set[i]
    local difference = math.abs(left_val - right_val)
    part1 = part1 + difference
end

local part2 = 0
for _, left_val in ipairs(left_set) do
    local similarity = 0
    for _, right_val in ipairs(right_set) do
        if left_val == right_val then
            similarity = similarity + left_val
        end
    end
    part2 = part2 + similarity
end

print("part1:", part1)
print("part2:", part2)
