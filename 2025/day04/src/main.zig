const std = @import("std");
const assert = std.debug.assert;
const print = std.debug.print;

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const input = @embedFile("input");
    const warehouse = try Warehouse.new(allocator, input);
    defer warehouse.free(allocator);
    const answer = part1(warehouse);
    print("{d}\n", .{answer});
    assert(1451 == answer);

    const answer2 = try part2(allocator, warehouse);
    print("{d}\n", .{answer2});
    assert(8701 == answer2);
}

const Warehouse = struct {
    storage: []u8,
    width: usize,

    pub fn new(allocator: std.mem.Allocator, storage: []const u8) !Warehouse {
        const line_pos = std.mem.indexOfScalar(u8, storage, '\n');
        const line_len = line_pos orelse unreachable;
        assert(line_len == std.mem.count(u8, storage, "\n"));
        const buf = try allocator.alloc(u8, storage.len);
        @memcpy(buf, storage);
        return .{ .storage = buf, .width = line_len + 1 };
    }

    pub fn free(self: *const Warehouse, allocator: std.mem.Allocator) void {
        allocator.free(self.storage);
    }

    pub fn count_surrounding_papers(self: *const Warehouse, y: usize, x: usize) i32 {
        const Direction = struct {
            y: isize,
            x: isize,
        };
        const directions = [_]Direction{
            .{ .y = 0, .x = 1 }, // right
            .{ .y = 1, .x = 1 }, // down + right
            .{ .y = 1, .x = 0 }, // down
            .{ .y = 1, .x = -1 }, // down + left
            .{ .y = 0, .x = -1 }, // left
            .{ .y = -1, .x = -1 }, // up + left
            .{ .y = -1, .x = 0 }, // up
            .{ .y = -1, .x = 1 }, // up + right
        };
        var count: i32 = 0;
        for (directions) |direction| {
            const ny = @as(isize, @intCast(y)) + direction.y;
            const nx = @as(isize, @intCast(x)) + direction.x;
            // Assumes inputs are square
            if (ny < 0 or ny >= self.width - 1 or nx < 0 or nx >= self.width - 1) {
                continue;
            }
            if (self.get_pos(@intCast(ny), @intCast(nx)) == '@') {
                count += 1;
            }
        }
        return count;
    }

    pub fn get_pos(self: *const Warehouse, y: usize, x: usize) u8 {
        return self.storage[y * self.width + x];
    }

    pub fn set_pos(self: *const Warehouse, y: usize, x: usize, value: u8) void {
        self.storage[y * self.width + x] = value;
    }
};

fn part1(warehouse: Warehouse) i32 {
    var answer: i32 = 0;
    for (0..warehouse.width - 1) |i| {
        for (0..warehouse.width - 1) |j| {
            if (warehouse.get_pos(i, j) != '@') {
                continue;
            }
            const count = warehouse.count_surrounding_papers(i, j);
            if (count < 4) {
                answer += 1;
            }
        }
    }
    return answer;
}

fn part2(allocator: std.mem.Allocator, warehouse: Warehouse) !i32 {
    const Pos = struct {
        y: usize,
        x: usize,
    };
    var reachable_papers = std.ArrayList(Pos).empty;
    defer reachable_papers.deinit(allocator);
    var answer: i32 = 0;
    while (true) {
        var reached_this_round: i32 = 0;
        for (0..warehouse.width - 1) |i| {
            for (0..warehouse.width - 1) |j| {
                if (warehouse.get_pos(i, j) != '@') {
                    continue;
                }
                const count = warehouse.count_surrounding_papers(i, j);
                if (count < 4) {
                    reached_this_round += 1;
                    try reachable_papers.append(allocator, Pos{.y = i, .x = j});
                }
            }
        }
        if (reached_this_round == 0) {
            break;
        }
        answer += reached_this_round;
        for (reachable_papers.items) |pos| {
            warehouse.set_pos(pos.y, pos.x, '.');
        }
        reachable_papers.clearRetainingCapacity();
    }
    return answer;
}

test "warehouse test" {
    const input = get_test_input();
    const allocator = std.testing.allocator;
    const warehouse = try Warehouse.new(allocator, input);
    defer warehouse.free(allocator);

    // 10 positions + newline
    try std.testing.expectEqual(warehouse.width, 11);
    try std.testing.expectEqual(warehouse.get_pos(0, 0), '.');
    try std.testing.expectEqual(warehouse.get_pos(0, 0), warehouse.storage[0]);
    try std.testing.expectEqual(warehouse.get_pos(0, 1), warehouse.storage[1]);
    try std.testing.expectEqual(warehouse.get_pos(0, 2), warehouse.storage[2]);

    try std.testing.expectEqual(warehouse.get_pos(1, 0), '@');
    try std.testing.expectEqual(warehouse.get_pos(1, 0), warehouse.storage[11]);
    try std.testing.expectEqual(warehouse.get_pos(1, 1), '@');
    try std.testing.expectEqual(warehouse.get_pos(1, 1), warehouse.storage[12]);
    try std.testing.expectEqual(warehouse.get_pos(1, 2), '@');
    try std.testing.expectEqual(warehouse.get_pos(1, 2), warehouse.storage[13]);
    try std.testing.expectEqual(warehouse.get_pos(1, 3), '.');
    try std.testing.expectEqual(warehouse.get_pos(1, 3), warehouse.storage[14]);

    try std.testing.expectEqual(warehouse.get_pos(6, 0), '.');
    try std.testing.expectEqual(warehouse.get_pos(6, 1), '@');
    try std.testing.expectEqual(warehouse.get_pos(6, 2), '.');
    try std.testing.expectEqual(warehouse.get_pos(6, 3), '@');
    try std.testing.expectEqual(warehouse.get_pos(6, 4), '.');

    try std.testing.expectEqual(warehouse.count_surrounding_papers(0, 2), 3);
    try std.testing.expectEqual(warehouse.count_surrounding_papers(0, 3), 3);
    try std.testing.expectEqual(warehouse.count_surrounding_papers(1, 1), 6);
    try std.testing.expectEqual(warehouse.count_surrounding_papers(1, 4), 4);
    try std.testing.expectEqual(warehouse.count_surrounding_papers(2, 2), 6);
    try std.testing.expectEqual(warehouse.count_surrounding_papers(5, 7), 5);
    try std.testing.expectEqual(warehouse.count_surrounding_papers(6, 3), 6);
    try std.testing.expectEqual(warehouse.count_surrounding_papers(8, 8), 5);
    try std.testing.expectEqual(warehouse.count_surrounding_papers(9, 9), 2);
}

test "part1 test" {
    const input = get_test_input();
    const allocator = std.testing.allocator;
    const warehouse = try Warehouse.new(allocator, input);
    defer warehouse.free(allocator);
    const answer = part1(warehouse);
    try std.testing.expectEqual(13, answer);
}

test "part2 test" {
    const allocator = std.testing.allocator;
    const input = get_test_input();
    const warehouse = try Warehouse.new(allocator, input);
    defer warehouse.free(allocator);
    const answer = try part2(allocator, warehouse);
    try std.testing.expectEqual(43, answer);
}

fn get_test_input() []const u8 {
    const input =
        \\..@@.@@@@.
        \\@@@.@.@.@@
        \\@@@@@.@.@@
        \\@.@@@@..@.
        \\@@.@@@@.@@
        \\.@@@@@@@.@
        \\.@.@.@.@@@
        \\@.@@@.@@@@
        \\.@@@@@@@@.
        \\@.@.@@@.@.
    ;
    return input ++ "\n";
}
