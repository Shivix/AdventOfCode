local function part1(input)
    local dial = 50
    local answer = 0
    for line in input do
        local direction = line:sub(1, 1)
        local amount = line:sub(2, -1)
        amount = amount % 100
        if direction == "L" then
            amount = -amount
        end
        dial = dial + amount
        if dial > 99 then
            dial = dial % 100
        end
        if dial < 0 then
            dial = dial + 100;
        end
        if dial == 0 then
            answer = answer + 1
        end
    end
    return answer
end

local function part2(input)
    local dial = 50
    local answer = 0
    for line in input do
        local direction = line:sub(1, 1) == "R" and 1 or -1
        local amount = line:sub(2, -1)
        for _ = 0, amount - 1 do
            dial = dial + direction
            if dial == 100 then
                dial = 0
            end
            if dial == -1 then
                dial = 99
            end
            if dial == 0 then
                answer = answer + 1
            end
        end
    end
    return answer
end

local part1_answer = part1(io.lines("2025/day01/input"))
print("part1: ", part1_answer)
assert(part1_answer == 1055)

local part2_answer = part2(io.lines("2025/day01/input"))
print("part2: ", part2_answer)
assert(part2_answer == 6386)
