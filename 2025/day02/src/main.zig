const std = @import("std");
const assert = std.debug.assert;
const print = std.debug.print;

pub fn main() !void {
    const input = @embedFile("input");

    const answer = try part1(input);
    print("{d}\n", .{answer});
    assert(12586854255 == answer);

    const answer2 = try part2(input);
    print("{d}\n", .{answer2});
    assert(17298174201 == answer2);
}

const Range = struct {
    lhs: usize,
    rhs: usize,
};

fn parse_range(range: []const u8) !Range {
    var it = std.mem.splitScalar(u8, range, '-');
    const lhs = std.mem.trim(u8, it.next().?, "\n");
    const rhs = std.mem.trim(u8, it.rest(), "\n");
    const left = try std.fmt.parseInt(usize, lhs, 10);
    const right = try std.fmt.parseInt(usize, rhs, 10);
    return Range{ .lhs = left, .rhs = right };
}

fn part1(input: []const u8) !usize {
    var answer: usize = 0;
    var ranges = std.mem.tokenizeScalar(u8, input, ',');
    while (ranges.next()) |elem| {
        const range = try parse_range(elem);
        // Results in a max length of integer of 15 digits
        var buf: [16]u8 = undefined;
        for (range.lhs..range.rhs + 1) |id| {
            const id_str = try std.fmt.bufPrint(&buf, "{}", .{id});
            if (id_str.len % 2 == 1) {
                continue;
            }
            const mid = id_str.len / 2;
            if (std.mem.eql(u8, id_str[0..mid], id_str[mid..])) {
                answer += id;
            }
        }
    }
    return answer;
}

fn part2(input: []const u8) !usize {
    var answer: usize = 0;
    var ranges = std.mem.tokenizeScalar(u8, input, ',');
    while (ranges.next()) |elem| {
        const range = try parse_range(elem);
        // Results in a max length of integer of 15 digits
        var buf: [16]u8 = undefined;
        for (range.lhs..range.rhs + 1) |id| {
            const id_str = try std.fmt.bufPrint(&buf, "{}", .{id});
            for (1..id_str.len / 2 + 1) |len_to_check| {
                if (id_str.len % len_to_check != 0) {
                    continue;
                }
                var pos: usize = len_to_check;
                while (pos < id_str.len) : (pos += len_to_check) {
                    if (!std.mem.eql(u8, id_str[0..len_to_check], id_str[pos..pos + len_to_check])) {
                        break;
                    }
                } else {
                    answer += id;
                    break;
                }
            }
        }
    }
    return answer;
}

test "test case" {
    const input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124";
    const answer = try part1(input);
    try std.testing.expectEqual(1227775554, answer);

    const answer2 = try part2(input);
    try std.testing.expectEqual(4174379265, answer2);
}
