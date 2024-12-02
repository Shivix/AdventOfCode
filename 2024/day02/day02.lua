local file = assert(io.open("input", "r"))

local reports = {}
local dampened_reports = {}
for line in file:lines() do
    local report = {}
    for reading in line:gmatch("[0-9]+") do
        table.insert(report, tonumber(reading))
    end
    table.insert(reports, report)

    local report_set = {}
    table.insert(dampened_reports, report_set)
    for n = 1, #report do
        local dampened_report = {}
        table.insert(report_set, dampened_report)
        -- Copy by value
        for _, v in ipairs(report) do
            table.insert(dampened_report, v)
        end
        table.remove(dampened_report, n)
    end
end
file:close()

local function check_safe(report)
    local prev_increasing = report[2] > report[1]
    local prev_reading = report[1]
    for i = 2, #report do
        local reading = report[i]
        local diff = math.abs(reading - prev_reading)
        if diff < 1 or diff > 3 then
            return false
        end
        local increasing = reading > prev_reading
        if increasing ~= prev_increasing then
            return false
        end
        prev_reading = reading
        prev_increasing = increasing
    end
    return true
end

local safe_reports = 0
for _, report in ipairs(reports) do
    if check_safe(report) then
        safe_reports = safe_reports + 1
    end
end
print("part1:", safe_reports)

safe_reports = 0
for _, d_reports in ipairs(dampened_reports) do
    for _, report in ipairs(d_reports) do
        if check_safe(report) then
            safe_reports = safe_reports + 1
            break
        end
    end
end
print("part2:", safe_reports)
