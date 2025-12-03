const std = @import("std");

fn part1(comptime IterT: type, rotations_it: *IterT) !i32 {
    var dial: i32 = 50;
    var answer: i32 = 0;
    while (rotations_it.next()) |rotation| {
        const direction = rotation[0];
        var amount = try std.fmt.parseInt(i32, rotation[1..], 10);
        amount = @mod(amount, 100);
        if (direction == 'L') {
            amount = -amount;
        }
        dial += amount;
        if (dial > 99) {
            dial = @mod(dial, 100);
        }
        if (dial < 0) {
            dial += 100;
        }
        if (dial == 0) {
            answer += 1;
        }
    }
    return answer;
}

fn part2(comptime IterT: type, rotations_it: *IterT) !i32 {
    var dial: i32 = 50;
    var answer: i32 = 0;
    while (rotations_it.next()) |rotation| {
        var direction: i32 = 1;
        if (rotation[0] == 'L') {
            direction = -1;
        }
        const amount = try std.fmt.parseInt(i32, rotation[1..], 10);
        for (0..@intCast(amount)) |_| {
            dial += direction;
            if (dial == 100) {
                dial = 0;
            }
            if (dial == -1) {
                dial = 99;
            }
            if (dial == 0) {
                answer += 1;
            }
        }
    }
    return answer;
}

pub fn main() !void {
    const input = @embedFile("input");

    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    const answer = try part1(@TypeOf(lines), &lines);
    std.debug.print("{d}\n", .{ answer });

    var lines2 = std.mem.tokenizeScalar(u8, input, '\n');
    const answer2 = try part2(@TypeOf(lines2), &lines2);
    std.debug.print("{d}\n", .{ answer2 });
}

test "test input" {
    const rotations =
        \\L68
        \\L30
        \\R48
        \\L5
        \\R60
        \\L55
        \\L1
        \\L99
        \\R14
        \\L82
    ;
    var it = std.mem.splitScalar(u8, rotations, '\n');
    const answer = part1(@TypeOf(it), &it);
    try std.testing.expectEqual(3, answer);

    var it2 = std.mem.splitScalar(u8, rotations, '\n');
    const answer2 = part2(@TypeOf(it2), &it2);
    try std.testing.expectEqual(6, answer2);
}
