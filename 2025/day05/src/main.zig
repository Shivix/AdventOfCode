const std = @import("std");
const assert = std.debug.assert;
const print = std.debug.print;

pub fn main() !void {
    const input = @embedFile("input");
    var it = std.mem.splitSequence(u8, input, "\n\n");
    const fresh_ranges = it.next() orelse @panic("invalid input file");
    const ingredients = it.rest();

    const allocator = std.heap.page_allocator;
    var fresh_ids = try create_fresh_ids(allocator, fresh_ranges);
    defer fresh_ids.deinit(allocator);
    assert(fresh_ids.items.len <= 184);

    const part1 = try count_fresh_ingredients(fresh_ids, ingredients);
    print("part1: {d}\n", .{part1});
    assert(part1 == 674);

    const part2 = count_fresh_ids(fresh_ids);
    print("part2: {d}\n", .{part2});
    assert(part2 == 352509891817881);
}

const Range = struct { usize, usize };
const FreshIDs = std.ArrayList(Range);

fn parse_range(range: []const u8) !struct { usize, usize } {
    var it = std.mem.splitScalar(u8, range, '-');
    const lhs = std.mem.trim(u8, it.next().?, "\n");
    const rhs = std.mem.trim(u8, it.rest(), "\n");
    const left = try std.fmt.parseInt(usize, lhs, 10);
    const right = try std.fmt.parseInt(usize, rhs, 10);
    assert(left <= right);
    return .{ left, right };
}

fn create_fresh_ids(allocator: std.mem.Allocator, input: []const u8) !FreshIDs {
    var result = FreshIDs.empty;
    var base = FreshIDs.empty;
    defer base.deinit(allocator);

    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    while (lines.next()) |line| {
        if (!std.mem.containsAtLeast(u8, line, 1, "-")) {
            break;
        }
        const range = try parse_range(line);
        try base.append(allocator, range);
    }

    std.mem.sort(Range, base.items, {}, struct {
        fn call(_: void, a: Range, b: Range) bool {
            return a[0] < b[0];
        }
    }.call);
    for (base.items) |base_elem| {
        var range = base_elem;
        for (result.items) |elem| {
            if (range[0] >= elem[0] and range[0] <= elem[1]) {
                range[0] = elem[1] + 1;
            }
            if (range[1] >= elem[0] and range[1] <= elem[1]) {
                range[1] = elem[0] - 1;
            }
        }
        if (range[0] <= range[1]) {
            try result.append(allocator, range);
        }
    }
    return result;
}

fn count_fresh_ids(fresh_ids: FreshIDs) usize {
    var answer: usize = 0;
    for (fresh_ids.items) |range| {
        answer += range[1] - range[0] + 1;
    }
    return answer;
}

fn count_fresh_ingredients(fresh_ids: FreshIDs, ingredients: []const u8) !i32 {
    var answer: i32 = 0;
    var lines = std.mem.tokenizeScalar(u8, ingredients, '\n');
    while (lines.next()) |line| {
        if (std.mem.containsAtLeast(u8, line, 1, "-")) {
            continue;
        }
        const id = try std.fmt.parseInt(usize, line, 10);
        for (fresh_ids.items) |fresh_range| {
            if (id >= fresh_range[0] and id <= fresh_range[1]) {
                answer += 1;
                break;
            }
        }
    }
    return answer;
}

test "testy test" {
    const input = get_test_input();
    const allocator = std.testing.allocator;
    var fresh_list = try create_fresh_ids(allocator, input);
    defer fresh_list.deinit(allocator);
    try std.testing.expectEqual(4, fresh_list.items.len);
    try std.testing.expectEqual(.{ 3, 5 }, fresh_list.items[0]);
    try std.testing.expectEqual(.{ 10, 14 }, fresh_list.items[1]);
    try std.testing.expectEqual(.{ 15, 18 }, fresh_list.items[2]);
    try std.testing.expectEqual(.{ 19, 20 }, fresh_list.items[3]);

    const answer = try count_fresh_ingredients(fresh_list, input);
    try std.testing.expectEqual(3, answer);

    const count = count_fresh_ids(fresh_list);
    try std.testing.expectEqual(14, count);
}

fn get_test_input() []const u8 {
    const input =
        \\3-5
        \\10-14
        \\16-20
        \\12-18
        \\
        \\1
        \\5
        \\8
        \\11
        \\17
        \\32
    ;
    return input;
}
