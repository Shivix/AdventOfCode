const std = @import("std");
const assert = std.debug.assert;
const print = std.debug.print;

pub fn main() !void {
    const input = @embedFile("input");
    const allocator = std.heap.page_allocator;

    const answer = try part1(allocator, input);
    print("part1: {d}\n", .{answer});
    assert(answer == 7098065460541);

    const answer2 = try part2(allocator, input);
    print("part2: {d}\n", .{answer2});
    assert(answer2 == 13807151830618);
}

const HomeworkRow = std.ArrayList(i64);
const OperatorRow = std.ArrayList(Operator);
const Operator = enum {
    Multiply,
    Addition,
    pub fn parse(input: []const u8) !Operator {
        if (std.mem.eql(u8, input, "*")) {
            return Operator.Multiply;
        } else if (std.mem.eql(u8, input, "+")) {
            return Operator.Addition;
        }
        return error.InvalidCharacter;
    }
};

fn parse_row(comptime RowType: type, allocator: std.mem.Allocator, line: []const u8) !RowType {
    var result = RowType.empty;
    var it = std.mem.splitScalar(u8, line, ' ');
    while (it.next()) |value| {
        assert(!std.mem.containsAtLeast(u8, value, 1, " "));
        if (value.len == 0) {
            continue;
        }
        if (RowType == OperatorRow) {
            try result.append(allocator, try Operator.parse(value));
        } else if (RowType == HomeworkRow) {
            try result.append(allocator, try std.fmt.parseInt(i64, value, 10));
        }
    }
    return result;
}

fn part1(allocator: std.mem.Allocator, input: []const u8) !i64 {
    var lines = std.mem.splitScalar(u8, input, '\n');
    const line1 = lines.next().?;
    const line2 = lines.next().?;
    const line3 = lines.next().?;
    const line4 = lines.next().?;
    const line5 = lines.next().?;

    var number1 = try parse_row(HomeworkRow, allocator, line1);
    defer number1.deinit(allocator);
    var number2 = try parse_row(HomeworkRow, allocator, line2);
    defer number2.deinit(allocator);
    var number3 = try parse_row(HomeworkRow, allocator, line3);
    defer number3.deinit(allocator);
    var number4 = try parse_row(HomeworkRow, allocator, line4);
    defer number4.deinit(allocator);
    var operators = try parse_row(OperatorRow, allocator, line5);
    defer operators.deinit(allocator);

    var answer: i64 = 0;
    for (0..operators.items.len) |i| {
        if (operators.items[i] == Operator.Multiply) {
            answer += number1.items[i] * number2.items[i] * number3.items[i] * number4.items[i];
        } else {
            answer += number1.items[i] + number2.items[i] + number3.items[i] + number4.items[i];
        }
    }
    return answer;
}

fn part2(allocator: std.mem.Allocator, input: []const u8) !i64 {
    var lines = std.mem.splitScalar(u8, input, '\n');
    const line1 = lines.next().?;
    const line2 = lines.next().?;
    const line3 = lines.next().?;
    const line4 = lines.next().?;
    const line5 = lines.next().?;

    var transposed = std.ArrayList(u8).empty;
    defer transposed.deinit(allocator);
    var i = line1.len;
    while (i > 0) {
        i -= 1;
        try transposed.append(allocator, line1[i]);
        try transposed.append(allocator, line2[i]);
        try transposed.append(allocator, line3[i]);
        try transposed.append(allocator, line4[i]);
        try transposed.append(allocator, ' ');
        try transposed.append(allocator, line5[i]);
    }

    var numbers = HomeworkRow.empty;
    defer numbers.deinit(allocator);
    var it = std.mem.splitScalar(u8, transposed.items, ' ');
    var answer: i64 = 0;
    while (it.next()) |value| {
        if (value.len == 0) {
            continue;
        }
        if (std.mem.eql(u8, value, "+")) {
            for (numbers.items) |n| {
                answer += n;
            }
            numbers.clearRetainingCapacity();
            continue;
        } else if (std.mem.eql(u8, value, "*")) {
            var temp: i64 = 1;
            for (numbers.items) |n| {
                temp *= n;
            }
            answer += temp;
            numbers.clearRetainingCapacity();
            continue;
        }
        try numbers.append(allocator, try std.fmt.parseInt(i64, value, 10));
    }
    return answer;
}

test "part1 test" {
    const input = get_test_input();
    const allocator = std.testing.allocator;

    const answer = part1(allocator, input);
    try std.testing.expectEqual(4277556, answer);
}

test "part2 test" {
    const input = get_test_input();
    const allocator = std.testing.allocator;

    const answer = part2(allocator, input);
    try std.testing.expectEqual(32732661, answer);
}

fn get_test_input() []const u8 {
    const input =
        \\123 328  51 64 
        \\ 45 64  387 23 
        \\  6 98  215 314
        \\  1  0  1   0  
        \\*   +   *   +  
    ;
    return input;
}
