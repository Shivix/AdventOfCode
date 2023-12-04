local function score(matches)
    return 1 << (matches - 1)
end

assert(score(1) == 1)
assert(score(2) == 2)
assert(score(3) == 4)
assert(score(4) == 8)

local function calculate_winnings(line)
    local winning_number_line = line:match(":(.*)|")
    local scratch_number_line = line:match("|(.*)")
    local winning_numbers = {}
    for i in winning_number_line:gmatch("%d+") do
        winning_numbers[i] = true
    end
    local matches = 0
    for i in scratch_number_line:gmatch("%d+") do
        if winning_numbers[i] ~= nil then
            matches = matches + 1
        end
    end
    return matches
end

assert(calculate_winnings("Card   3: 19 70  1 34 10 79 | 95 19 63 83 46 77 75  3 12 70 65 22 13") == 2)

local file = io.open("input")
assert(file)

local cards = {}

local part1 = 0
for line in file:lines() do
    local matches = calculate_winnings(line)
    table.insert(cards, {matches = matches, copies = 1})
    part1 = part1 + score(matches)
end

file:close()

local part2 = 0
for i, card in ipairs(cards) do
    for _ = 1, card.copies do
        for j = 1, card.matches do
            cards[i + j].copies = cards[i + j].copies + 1
        end
        part2 = part2 + 1
    end
end

print(part1, part2)
assert(part1 == 19135 and part2 == 5704953)

