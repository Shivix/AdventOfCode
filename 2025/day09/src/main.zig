const std = @import("std");
const assert = std.debug.assert;
const print = std.debug.print;

pub fn main() !void {
    const input = @embedFile("input");
    const allocator = std.heap.page_allocator;
    var red_tiles = try parse_input(allocator, input);
    const part1 = get_largest_area(red_tiles);
    print("part1: {d}\n", .{part1});
    assert(part1 == 4760959496);

    var all_tiles = try get_all_tiles(allocator, red_tiles);
    defer all_tiles.deinit();
    set_directions(&red_tiles, all_tiles);

    const part2 = get_largest_area_inbounds(red_tiles);
    print("part2: {d}\n", .{part2});
    assert(part2 == 1343576598);
}

const Direction = enum(usize) {
    north,
    east,
    south,
    west,
};

const Directions = [4]i64;
const Pos = struct { i64, i64 };
const Tile = struct {
    pos: Pos,
    directions: Directions,
};
const RedTiles = std.ArrayList(Tile);
const AllTiles = std.AutoHashMap(Pos, void);

fn parse_input(allocator: std.mem.Allocator, input: []const u8) !RedTiles {
    var result = RedTiles.empty;
    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    while (lines.next()) |line| {
        const comma_pos = std.mem.indexOfScalar(u8, line, ',') orelse @panic("could not find comma");
        try result.append(allocator, Tile{
            .pos = .{
                try std.fmt.parseInt(i64, line[0..comma_pos], 10),
                try std.fmt.parseInt(i64, line[comma_pos + 1 ..], 10),
            },
            .directions = std.mem.zeroes(Directions),
        });
    }
    return result;
}

fn get_all_tiles(allocator: std.mem.Allocator, red_tiles: RedTiles) !AllTiles {
    var result = AllTiles.init(allocator);
    for (red_tiles.items, 0..red_tiles.items.len) |tile, i| {
        // Add all red tiles.
        try result.put(tile.pos, {});

        var next_i = i + 1;
        if (next_i == red_tiles.items.len) {
            // Loop back round to first.
            next_i = 0;
        }
        const next_tile = &red_tiles.items[next_i];

        if (tile.pos[0] != next_tile.pos[0]) {
            const lower = @min(tile.pos[0], next_tile.pos[0]);
            const higher = @max(tile.pos[0], next_tile.pos[0]) + 1;
            for (@intCast(lower)..@intCast(higher)) |n| {
                try result.put(.{ @intCast(n), tile.pos[1] }, {});
            }
        } else if (tile.pos[1] != next_tile.pos[1]) {
            const lower = @min(tile.pos[1], next_tile.pos[1]);
            const higher = @max(tile.pos[1], next_tile.pos[1]) + 1;
            for (@intCast(lower)..@intCast(higher)) |n| {
                try result.put(.{ tile.pos[0], @intCast(n) }, {});
            }
        }
    }
    return result;
}

fn get_area_between(lhs: Pos, rhs: Pos) u64 {
    const height = @abs(lhs[0] - rhs[0]) + 1;
    const width = @abs(lhs[1] - rhs[1]) + 1;
    return height * width;
}

fn get_largest_area(input: RedTiles) u64 {
    var largest_area: u64 = 0;
    for (input.items) |tile| {
        for (input.items) |tile2| {
            const area = get_area_between(tile.pos, tile2.pos);
            if (area > largest_area) {
                largest_area = area;
            }
        }
    }
    return largest_area;
}

fn get_largest_area_inbounds(input: RedTiles) u64 {
    var largest_area: u64 = 0;
    for (input.items) |tile| {
        for (input.items) |tile2| {
            if (!check_inbound(tile, tile2) or !check_inbound(tile2, tile)) {
                continue;
            }
            const area = get_area_between(tile.pos, tile2.pos);
            if (area > largest_area) {
                largest_area = area;
            }
        }
    }
    return largest_area;
}

fn apply_direction(pos: Pos, direction: Direction) Pos {
    var result = pos;
    switch (direction) {
        .north => {
            result[1] -= 1;
        },
        .east => {
            result[0] += 1;
        },
        .south => {
            result[1] += 1;
        },
        .west => {
            result[0] -= 1;
        },
    }
    return result;
}

fn check_end(pos: Pos, direction: Direction) bool {
    switch (direction) {
        .north => {
            return pos[1] <= 0;
        },
        .east => {
            // Highest value in input file. Slow, but it works.
            return pos[0] >= 99999;
        },
        .south => {
            return pos[1] >= 99999;
        },
        .west => {
            return pos[0] <= 0;
        },
    }
}

fn get_max_boundary_direction(pos: Pos, direction: Direction, tiles: AllTiles) ?i64 {
    var current_pos = pos;
    var distance: i64 = 0;
    var outbound = false;
    var inbound_distance: i64 = 0;
    while (!check_end(current_pos, direction)) {
        distance += 1;
        current_pos = apply_direction(current_pos, direction);
        if (tiles.contains(current_pos)) {
            inbound_distance = distance;
            if (outbound) {
                return inbound_distance;
            }
        } else {
            // This is a bit of a hack, basically we can go "out of bounds" once, to allow for the hollow inside.
            outbound = true;
        }
    }
    if (inbound_distance > 0) {
        return inbound_distance;
    }
    return null;
}

fn set_directions(red_tiles: *RedTiles, all_tiles: AllTiles) void {
    for (0..red_tiles.items.len) |i| {
        var tile = &red_tiles.items[i];
        inline for (std.meta.fields(Direction)) |direction| {
            tile.directions[direction.value] = get_max_boundary_direction(tile.pos, @field(Direction, direction.name), all_tiles) orelse 0;
        }
    }
}

fn check_inbound(lhs: Tile, rhs: Tile) bool {
    if (lhs.pos[0] < rhs.pos[0]) {
        const boundary_distance = lhs.directions[@intFromEnum(Direction.east)];
        const pos_distance = rhs.pos[0] - lhs.pos[0];
        if (boundary_distance == 0 or boundary_distance < pos_distance) {
            return false;
        }
    }
    if (lhs.pos[0] > rhs.pos[0]) {
        const boundary_distance = lhs.directions[@intFromEnum(Direction.west)];
        const pos_distance = lhs.pos[0] - rhs.pos[0];
        if (boundary_distance == 0 or boundary_distance < pos_distance) {
            return false;
        }
    }
    if (lhs.pos[1] < rhs.pos[1]) {
        const boundary_distance = lhs.directions[@intFromEnum(Direction.south)];
        const pos_distance = rhs.pos[1] - lhs.pos[1];
        if (boundary_distance == 0 or boundary_distance < pos_distance) {
            return false;
        }
    }
    if (lhs.pos[1] > rhs.pos[1]) {
        const boundary_distance = lhs.directions[@intFromEnum(Direction.north)];
        const pos_distance = lhs.pos[1] - rhs.pos[1];
        if (boundary_distance == 0 or boundary_distance < pos_distance) {
            return false;
        }
    }
    return true;
}

test "test data" {
    const input = get_test_input();
    const allocator = std.testing.allocator;
    var red_tiles = try parse_input(allocator, input);
    defer red_tiles.deinit(allocator);
    try std.testing.expectEqual(8, red_tiles.items.len);
    try std.testing.expectEqual(.{ 7, 1 }, red_tiles.items[0].pos);
    try std.testing.expectEqual(.{ 7, 3 }, red_tiles.items[7].pos);

    try std.testing.expectEqual(24, get_area_between(.{ 2, 5 }, .{ 9, 7 }));
    try std.testing.expectEqual(35, get_area_between(.{ 7, 1 }, .{ 11, 7 }));
    try std.testing.expectEqual(6, get_area_between(.{ 7, 3 }, .{ 2, 3 }));
    try std.testing.expectEqual(50, get_area_between(.{ 2, 5 }, .{ 11, 1 }));

    const part1 = get_largest_area(red_tiles);
    try std.testing.expectEqual(50, part1);

    var all_tiles = try get_all_tiles(allocator, red_tiles);
    defer all_tiles.deinit();

    try std.testing.expect(all_tiles.contains(.{ 7, 1 }));
    try std.testing.expect(all_tiles.contains(.{ 8, 1 }));
    try std.testing.expect(all_tiles.contains(.{ 9, 1 }));
    try std.testing.expect(all_tiles.contains(.{ 10, 1 }));
    try std.testing.expect(all_tiles.contains(.{ 11, 1 }));
    try std.testing.expect(!all_tiles.contains(.{ 12, 1 }));

    try std.testing.expect(all_tiles.contains(.{ 11, 2 }));
    try std.testing.expect(all_tiles.contains(.{ 11, 3 }));
    try std.testing.expect(all_tiles.contains(.{ 11, 4 }));
    try std.testing.expect(all_tiles.contains(.{ 11, 5 }));
    try std.testing.expect(all_tiles.contains(.{ 11, 6 }));
    try std.testing.expect(all_tiles.contains(.{ 11, 7 }));
    try std.testing.expect(all_tiles.contains(.{ 10, 7 }));

    try std.testing.expect(all_tiles.contains(.{ 7, 2 }));
    try std.testing.expect(all_tiles.contains(.{ 7, 3 }));
    try std.testing.expect(!all_tiles.contains(.{ 7, 4 }));
    try std.testing.expect(all_tiles.contains(.{ 7, 5 }));
    try std.testing.expect(!all_tiles.contains(.{ 7, 6 }));

    try std.testing.expectEqual(4, get_max_boundary_direction(.{ 7, 1 }, Direction.east, all_tiles));
    try std.testing.expectEqual(4, get_max_boundary_direction(.{ 7, 1 }, Direction.south, all_tiles));

    try std.testing.expectEqual(6, get_max_boundary_direction(.{ 11, 1 }, Direction.south, all_tiles));
    try std.testing.expectEqual(4, get_max_boundary_direction(.{ 11, 1 }, Direction.west, all_tiles));

    try std.testing.expectEqual(2, get_max_boundary_direction(.{ 11, 7 }, Direction.west, all_tiles));
    try std.testing.expectEqual(6, get_max_boundary_direction(.{ 11, 7 }, Direction.north, all_tiles));

    try std.testing.expectEqual(6, get_max_boundary_direction(.{ 9, 7 }, Direction.north, all_tiles));
    try std.testing.expectEqual(2, get_max_boundary_direction(.{ 9, 7 }, Direction.east, all_tiles));
    try std.testing.expectEqual(null, get_max_boundary_direction(.{ 9, 7 }, Direction.west, all_tiles));
    try std.testing.expectEqual(null, get_max_boundary_direction(.{ 9, 7 }, Direction.south, all_tiles));

    try std.testing.expect(get_max_boundary_direction(.{ 9, 5 }, Direction.north, all_tiles) != null);
    try std.testing.expect(get_max_boundary_direction(.{ 9, 5 }, Direction.east, all_tiles) != null);
    try std.testing.expect(get_max_boundary_direction(.{ 9, 5 }, Direction.south, all_tiles) != null);
    try std.testing.expect(get_max_boundary_direction(.{ 9, 5 }, Direction.west, all_tiles) != null);

    set_directions(&red_tiles, all_tiles);

    try std.testing.expectEqual(0, red_tiles.items[0].directions[@intFromEnum(Direction.north)]);
    try std.testing.expectEqual(4, red_tiles.items[0].directions[@intFromEnum(Direction.east)]);
    try std.testing.expectEqual(4, red_tiles.items[0].directions[@intFromEnum(Direction.south)]);
    try std.testing.expectEqual(0, red_tiles.items[0].directions[@intFromEnum(Direction.west)]);

    try std.testing.expect(check_inbound(red_tiles.items[4], red_tiles.items[6]));
    try std.testing.expect(check_inbound(red_tiles.items[6], red_tiles.items[4]));
    try std.testing.expect(check_inbound(red_tiles.items[7], red_tiles.items[1]));
    try std.testing.expect(check_inbound(red_tiles.items[1], red_tiles.items[7]));
    try std.testing.expect(!check_inbound(red_tiles.items[3], red_tiles.items[5]));
    try std.testing.expect(!check_inbound(red_tiles.items[5], red_tiles.items[3]));
    try std.testing.expect(!check_inbound(red_tiles.items[0], red_tiles.items[3]));
    try std.testing.expect(!check_inbound(red_tiles.items[5], red_tiles.items[1]));
    try std.testing.expect(!check_inbound(red_tiles.items[1], red_tiles.items[5]));

    const part2 = get_largest_area_inbounds(red_tiles);
    try std.testing.expectEqual(24, part2);
}

fn get_test_input() []const u8 {
    const input =
        \\7,1
        \\11,1
        \\11,7
        \\9,7
        \\9,5
        \\2,5
        \\2,3
        \\7,3
    ;
    return input;
}
