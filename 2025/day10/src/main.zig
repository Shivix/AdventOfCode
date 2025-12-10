const std = @import("std");
const builtin = @import("builtin");
const assert = std.debug.assert;
const print = std.debug.print;

pub fn main() !void {
    const input = @embedFile("input");
    var dbg_alloc: std.heap.DebugAllocator(.{}) = .init;
    defer _ = dbg_alloc.deinit();
    const gpa = dbg_alloc.allocator();

    var machines = try new_machine_list(gpa, input);
    defer {
        for (0..machines.items.len) |i| {
            machines.items[i].deinit(gpa);
        }
        machines.deinit(gpa);
    }

    var answer: usize = 0;
    for (machines.items) |machine| {
        answer += try find_min_presses(machine.buttons, machine.lights);
    }
    print("part1: {d}\n", .{answer});
    assert(answer == 459);
}

// Each bit represents a light.
const Lights = usize;
const Buttons = []usize;
const Joltages = []usize;

const MachineList = std.ArrayList(Machine);

const Machine = struct {
    lights: Lights,
    buttons: Buttons,
    joltages: Joltages,

    pub fn new(allocator: std.mem.Allocator, input: []const u8) !Machine {
        const parsed = parse_machine(input);
        const result: Machine = .{
            .lights = try new_lights(parsed[0]),
            .buttons = try new_buttons(allocator, parsed[1]),
            .joltages = try new_joltages(allocator, parsed[2]),
        };
        return result;
    }

    pub fn deinit(self: *Machine, allocator: std.mem.Allocator) void {
        allocator.free(self.buttons);
        allocator.free(self.joltages);
    }
};

fn parse_machine(input: []const u8) struct { []const u8, []const u8, []const u8 } {
    const light_end = std.mem.indexOfScalar(u8, input, ']') orelse @panic("can not parse machine");
    const joltage_start = std.mem.indexOfScalar(u8, input, '{') orelse @panic("can not parse machine");
    return .{ input[1..light_end], input[light_end + 2 .. joltage_start - 1], input[joltage_start + 1 .. input.len - 1] };
}

fn new_machine_list(allocator: std.mem.Allocator, input: []const u8) !MachineList {
    var result = MachineList.empty;
    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    while (lines.next()) |line| {
        const machine = try Machine.new(allocator, line);
        try result.append(allocator, machine);
    }
    return result;
}

fn new_lights(input: []const u8) !usize {
    var result: usize = 0;
    // This should work on either endian, but putting this here anyway.
    assert(builtin.cpu.arch.endian() == .little);

    for (input, 0..) |c, i| {
        switch (c) {
            '.' => {},
            '#' => result |= (@as(usize, 1) << @intCast(i)),
            else => {
                print("TEST: {s}\n", .{input});
                return error.InvalidLights;
            },
        }
    }
    return result;
}

fn new_buttons(allocator: std.mem.Allocator, input: []const u8) !Buttons {
    const count = std.mem.count(u8, input, " ") + 1;
    const result = try allocator.alloc(usize, count);
    @memset(result, 0);

    var buttons = std.mem.splitScalar(u8, input, ' ');
    var i: usize = 0;
    while (buttons.next()) |group| {
        // Strip ()
        const inner = group[1 .. group.len - 1];
        var it = std.mem.splitScalar(u8, inner, ',');
        while (it.next()) |n| {
            const val = try std.fmt.parseUnsigned(u6, n, 10);
            assert(val < @bitSizeOf(usize));
            result[i] |= (@as(usize, 1) << val);
        }
        i += 1;
    }
    return result;
}

fn new_joltages(allocator: std.mem.Allocator, input: []const u8) !Joltages {
    const count = std.mem.count(u8, input, ",") + 1;
    var joltages = try allocator.alloc(usize, count);

    var it = std.mem.splitScalar(u8, input, ',');
    var i: usize = 0;
    while (it.next()) |n| {
        joltages[i] = try std.fmt.parseUnsigned(usize, n, 10);
        i += 1;
    }
    return joltages;
}

pub fn find_min_presses(buttons: []const usize, goal: usize) !usize {
    var current_best: usize = std.math.maxInt(usize);

    const max_iterations = @as(usize, 1) << @intCast(buttons.len);
    for (0..max_iterations) |i| {
        const buttons_used = @popCount(i);
        if (buttons_used >= current_best) {
            continue;
        }

        var lights: usize = 0;
        var buttons_to_press = i;
        while (buttons_to_press != 0) : (buttons_to_press &= buttons_to_press - 1) {
            const next_button = @ctz(buttons_to_press);
            lights ^= buttons[next_button];
        }

        if (lights == goal) {
            current_best = buttons_used;
        }
    }

    assert(current_best != std.math.maxInt(usize));
    return current_best;
}

test "test data" {
    const input = get_test_input();
    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    const allocator = std.testing.allocator;
    const first_line = lines.peek().?;
    const parsed = parse_machine(first_line);
    try std.testing.expectEqualStrings(".##.", parsed[0]);
    try std.testing.expectEqualStrings("(3) (1,3) (2) (2,3) (0,2) (0,1)", parsed[1]);
    try std.testing.expectEqualStrings("3,5,4,7", parsed[2]);

    var first_machine = try Machine.new(allocator, first_line);
    defer first_machine.deinit(allocator);
    try std.testing.expectEqual(0b0110, first_machine.lights);
    try std.testing.expectEqual(0b1000, first_machine.buttons[0]);
    try std.testing.expectEqual(0b1010, first_machine.buttons[1]);
    try std.testing.expectEqual(0b0100, first_machine.buttons[2]);
    try std.testing.expectEqual(0b1100, first_machine.buttons[3]);
    try std.testing.expectEqualSlices(usize, &.{ 3, 5, 4, 7 }, first_machine.joltages);

    var machines = try new_machine_list(allocator, input);
    defer {
        for (0..machines.items.len) |i| {
            machines.items[i].deinit(allocator);
        }
        machines.deinit(allocator);
    }
    try std.testing.expectEqual(3, machines.items.len);

    try std.testing.expectEqual(2, try find_min_presses(machines.items[0].buttons, machines.items[0].lights));
    try std.testing.expectEqual(3, try find_min_presses(machines.items[1].buttons, machines.items[1].lights));
    try std.testing.expectEqual(2, try find_min_presses(machines.items[2].buttons, machines.items[2].lights));

    var answer: usize = 0;
    for (machines.items) |machine| {
        answer += try find_min_presses(machine.buttons, machine.lights);
    }
    try std.testing.expectEqual(7, answer);
}

fn get_test_input() []const u8 {
    const input =
        \\[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
        \\[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
        \\[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
    ;
    return input;
}
