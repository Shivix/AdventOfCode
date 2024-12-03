const std = @import("std");
const split = std.mem.split;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    var list = std.ArrayList(std.ArrayList(i32)).init(allocator);
    defer list.deinit();

    const input = @embedFile("input");

    var lines = split(u8, input, "\n");
    while (lines.next()) |line| {
        var report = try list.addOne();
        var readings = split(u8, line, " ");
        //std.debug.print("{s}",  .{line});
        while (readings.next()) |reading| {
            std.debug.print("TEST |{s}|\n",  .{reading});
            try report.append(try std.fmt.parseInt(u16, reading, 10));
        }
    }

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();
    try stdout.print("part1: ", .{});
    try bw.flush();
}
