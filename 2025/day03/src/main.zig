const std = @import("std");
const assert = std.debug.assert;

pub fn main() !void {
    const input = @embedFile("input");
    const answer1 = try calculate_total_joltage(input, 2);
    std.debug.print("part1: {d}\n", .{answer1});
    assert(answer1 == 17613);

    const answer2 = try calculate_total_joltage(input, 12);
    std.debug.print("part2: {d}\n", .{answer2});
    assert(answer2 == 175304218462560);
}

fn calculate_joltage(bank: []const u8, comptime no_of_batteries: usize) !i64 {
    var batteries: [no_of_batteries]u8 = undefined;
    var start_pos: usize = 0;
    for (0..no_of_batteries) |battery_n| {
        var largest: u8 = 0;
        for (start_pos..bank.len - no_of_batteries + battery_n + 1) |battery_pos| {
            const battery = bank[battery_pos];
            if (battery > largest) {
                largest = battery;
                // Add one to start next check from the position after, to avoid finding the same number.
                start_pos = battery_pos + 1;
            }
        }
        batteries[battery_n] = largest;
    }
    return try std.fmt.parseInt(i64, batteries[0..], 10);
}

fn calculate_total_joltage(input: []const u8, comptime no_of_batteries: usize) !i64 {
    var answer: i64 = 0;
    var banks = std.mem.tokenizeScalar(u8, input, '\n');
    while (banks.next()) |bank| {
        answer += try calculate_joltage(bank, no_of_batteries);
    }
    return answer;
}

test "part1 test" {
    const banks = .{
        "987654321111111",
        "811111111111119",
        "234234234234278",
        "818181911112111",
    };
    const input = banks[0] ++ "\n" ++ banks[1] ++ "\n" ++ banks[2] ++ "\n" ++ banks[3];
    const joltage1 = try calculate_joltage(banks[0], 2);
    try std.testing.expectEqual(98, joltage1);
    const joltage2 = try calculate_joltage(banks[1], 2);
    try std.testing.expectEqual(89, joltage2);
    const joltage3 = try calculate_joltage(banks[2], 2);
    try std.testing.expectEqual(78, joltage3);
    const joltage4 = try calculate_joltage(banks[3], 2);
    try std.testing.expectEqual(92, joltage4);
    const answer = try calculate_total_joltage(input, 2);
    try std.testing.expectEqual(357, answer);
}

test "part2 test" {
    const banks = .{
        "987654321111111",
        "811111111111119",
        "234234234234278",
        "818181911112111",
    };
    const input = banks[0] ++ "\n" ++ banks[1] ++ "\n" ++ banks[2] ++ "\n" ++ banks[3];
    const joltage1 = try calculate_joltage(banks[0], 12);
    try std.testing.expectEqual(987654321111, joltage1);
    const joltage2 = try calculate_joltage(banks[1], 12);
    try std.testing.expectEqual(811111111119, joltage2);
    const joltage3 = try calculate_joltage(banks[2], 12);
    try std.testing.expectEqual(434234234278, joltage3);
    const joltage4 = try calculate_joltage(banks[3], 12);
    try std.testing.expectEqual(888911112111, joltage4);
    const answer = try calculate_total_joltage(input, 12);
    try std.testing.expectEqual(3121910778619, answer);
}
