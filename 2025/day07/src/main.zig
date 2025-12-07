const std = @import("std");
const assert = std.debug.assert;
const print = std.debug.print;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const input = @embedFile("input");
    const tachyon = try Tachyon.new(allocator, input);

    const answer = try part1(allocator, tachyon);
    print("{d}\n", .{answer});
    assert(answer == 1711);

    const answer2 = try part2(allocator, tachyon);
    print("{d}\n", .{answer2});
    assert(answer2 == 36706966158365);
}

const Pos = struct {
    y: usize,
    x: usize,
};
const Beam = struct {
    pos: Pos,
    count: i64,
    pub fn new(pos: Pos) Beam {
        return Beam{ .pos = pos, .count = 1 };
    }
};
const BeamList = std.ArrayList(Beam);

const Tachyon = struct {
    storage: []u8,
    width: usize,
    height: usize,
    max_beams: usize,
    emitter_pos: Pos,

    pub fn new(allocator: std.mem.Allocator, storage: []const u8) !Tachyon {
        const no_of_splitters = std.mem.count(u8, storage, "^");
        const line_pos = std.mem.indexOfScalar(u8, storage, '\n');
        const line_len = line_pos orelse unreachable;
        const height = std.mem.count(u8, storage, "\n");
        const buf = try allocator.alloc(u8, storage.len);
        @memcpy(buf, storage);
        var emitter_pos: Pos = Pos{ .y = 0, .x = 0 };
        for (0..line_len) |i| {
            if (buf[i] == 'S') {
                emitter_pos.x = i;
                break;
            }
        } else {
            return error.EmitterNotFound;
        }
        // Width includes newline
        return .{ .storage = buf, .width = line_len + 1, .height = height, .max_beams = no_of_splitters + 1, .emitter_pos = emitter_pos };
    }

    pub fn deinit(self: *const Tachyon, allocator: std.mem.Allocator) void {
        allocator.free(self.storage);
    }

    pub fn get_pos(self: *const Tachyon, y: usize, x: usize) u8 {
        return self.storage[y * self.width + x];
    }

    pub fn at_pos(self: *const Tachyon, pos: Pos) u8 {
        return self.get_pos(pos.y, pos.x);
    }

    pub fn set_pos(self: *const Tachyon, y: usize, x: usize, value: u8) void {
        self.storage[y * self.width + x] = value;
    }
};

fn count_pos(list: BeamList, pos: Pos) i32 {
    var result: i32 = 0;
    for (list.items) |beam| {
        if (beam.pos.x == pos.x and beam.pos.y == pos.y) {
            result += 1;
        }
    }
    return result;
}

fn remove_duplicates(list: *BeamList) void {
    var i = list.items.len;
    while (i > 0) {
        i -= 1;
        if (count_pos(list.*, list.items[i].pos) > 1) {
            _ = list.orderedRemove(i);
        }
    }
}

fn append_or_increment(allocator: std.mem.Allocator, list: *BeamList, beam: Beam) !void {
    for (list.items, 0..list.items.len) |elem, i| {
        if (elem.pos.x == beam.pos.x and elem.pos.y == beam.pos.y) {
            list.items[i].count += beam.count;
            return;
        }
    }
    try list.append(allocator, beam);
}

fn part1(allocator: std.mem.Allocator, tachyon: Tachyon) !i32 {
    var beams = BeamList.empty;
    defer beams.deinit(allocator);
    try beams.append(allocator, Beam.new(tachyon.emitter_pos));
    // Avoid reallocating when appending.
    try beams.ensureTotalCapacity(allocator, tachyon.max_beams);
    var no_of_splits: i32 = 0;
    for (0..tachyon.height) |_| {
        for (0..beams.items.len) |i| {
            var beam = &beams.items[i];
            var new_pos = beam.pos;
            new_pos.y += 1;
            if (new_pos.y >= tachyon.height) {
                break;
            }
            if (tachyon.at_pos(new_pos) == '^') {
                no_of_splits += 1;

                var left_pos = new_pos;
                left_pos.x -= 1;
                // Reuse existing beam for left side.
                beam.pos = left_pos;
                var right_pos = new_pos;
                right_pos.x += 1;
                try beams.append(allocator, Beam.new(right_pos));
            } else {
                beams.items[i].pos.y += 1;
            }
        }
        remove_duplicates(&beams);
    }
    return no_of_splits;
}

fn part2(allocator: std.mem.Allocator, tachyon: Tachyon) !i64 {
    var beams = BeamList.empty;
    defer beams.deinit(allocator);
    try beams.append(allocator, Beam.new(tachyon.emitter_pos));
    // Avoid reallocating when appending.
    try beams.ensureTotalCapacity(allocator, tachyon.max_beams);
    var to_remove = std.ArrayList(usize).empty;
    defer to_remove.deinit(allocator);
    var no_of_timelines: i64 = 1;
    for (0..tachyon.height) |_| {
        for (beams.items, 0..beams.items.len) |beam, i| {
            var new_beam = beam;
            new_beam.pos.y += 1;
            if (new_beam.pos.y >= tachyon.height) {
                break;
            }
            if (tachyon.at_pos(new_beam.pos) == '^') {
                no_of_timelines += beam.count;

                var left_beam = new_beam;
                left_beam.pos.x -= 1;
                try append_or_increment(allocator, &beams, left_beam);
                var right_beam = new_beam;
                right_beam.pos.x += 1;
                try append_or_increment(allocator, &beams, right_beam);

                try to_remove.append(allocator, i);
            } else {
                beams.items[i].pos.y += 1;
            }
        }
        var i = to_remove.items.len;
        while (i > 0) {
            i -= 1;
            _ = beams.orderedRemove(to_remove.items[i]);
        }
        to_remove.clearRetainingCapacity();
    }
    return no_of_timelines;
}

test "test data" {
    const input = get_test_data();
    const allocator = std.testing.allocator;
    const tachyon = try Tachyon.new(allocator, input);
    defer tachyon.deinit(allocator);
    try std.testing.expectEqual(16, tachyon.width);
    try std.testing.expectEqual(15, tachyon.height);
    try std.testing.expectEqual(Pos{ .y = 0, .x = 7 }, tachyon.emitter_pos);

    const no_of_splits = part1(allocator, tachyon);
    try std.testing.expectEqual(21, no_of_splits);

    const no_of_timelines = part2(allocator, tachyon);
    try std.testing.expectEqual(40, no_of_timelines);
}

fn get_test_data() []const u8 {
    const input =
        \\.......S.......
        \\...............
        \\.......^.......
        \\...............
        \\......^.^......
        \\...............
        \\.....^.^.^.....
        \\...............
        \\....^.^...^....
        \\...............
        \\...^.^...^.^...
        \\...............
        \\..^...^.....^..
        \\...............
        \\.^.^.^.^.^...^.
        \\...............
    ;
    return input;
}
