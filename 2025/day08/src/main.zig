const std = @import("std");
const assert = std.debug.assert;
const print = std.debug.print;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const input = @embedFile("input");

    var junction_boxes = try new_junction_box(allocator, input);
    defer junction_boxes.deinit(allocator);

    for (0..1000) |_| {
        _ = try connect_closest_two(&junction_boxes);
    }
    const answer = try part1(allocator, junction_boxes);
    print("part1: {d}\n", .{answer});
    assert(answer == 42315);

    const answer2 = try part2(allocator, &junction_boxes);
    print("part2: {d}\n", .{answer2});
    assert(answer2 == 8079278220);
}

const Pos = struct {
    x: i64,
    y: i64,
    z: i64,
};
const DirectConnections = std.StaticBitSet(1000);
const JunctionBox = struct {
    pos: Pos,
    circuit: i32,
    i: usize,
    direct_connections: DirectConnections,
};
const JunctionBoxList = std.ArrayList(JunctionBox);

fn new_junction_box(allocator: std.mem.Allocator, input: []const u8) !JunctionBoxList {
    var result = JunctionBoxList.empty;
    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    var i: usize = 0;
    while (lines.next()) |line| {
        var it = std.mem.splitScalar(u8, line, ',');
        const x = it.next() orelse @panic("invalid input file");
        const y = it.next() orelse @panic("invalid input file");
        const z = it.rest();
        try result.append(allocator, JunctionBox{
            .pos = Pos{
                .x = try std.fmt.parseInt(i64, x, 10),
                .y = try std.fmt.parseInt(i64, y, 10),
                .z = try std.fmt.parseInt(i64, z, 10),
            },
            .circuit = 0,
            .i = i,
            .direct_connections = DirectConnections.initEmpty(),
        });
        i += 1;
    }
    return result;
}

fn find_closest(list: JunctionBoxList, junction_box: JunctionBox) struct { usize, i64 } {
    var closest_i: usize = 0;
    var closest_distance: i64 = std.math.maxInt(i64);
    for (list.items, 0..list.items.len) |jb, i| {
        const distance = get_distance(junction_box.pos, jb.pos);
        // Skip itself.
        if (distance == 0) {
            continue;
        }
        assert(distance != closest_distance);
        if (distance < closest_distance) {
            if (jb.direct_connections.isSet(junction_box.i)) {
                continue;
            }
            closest_distance = distance;
            closest_i = i;
        }
    }
    assert(closest_distance != std.math.maxInt(i64));
    return .{ closest_i, closest_distance };
}

fn find_closest_two_unconnected(list: JunctionBoxList) struct { usize, usize } {
    var closest_pos: struct { usize, usize } = .{ 0, 0 };
    var closest_distance: i64 = std.math.maxInt(i64);
    for (list.items, 0..list.items.len) |jb, i| {
        const r = find_closest(list, jb);
        const closest_i = r[0];
        const distance = r[1];
        // Happens because it may find the reverse of current closest.
        //assert(distance != closest_distance);
        if (distance < closest_distance) {
            closest_distance = distance;
            closest_pos = .{ i, closest_i };
        }
    }
    assert(closest_distance != std.math.maxInt(i64));
    return closest_pos;
}

var counter: i32 = 0;
fn next_circuit() i32 {
    counter += 1;
    return counter;
}

fn connect_closest_two(list: *JunctionBoxList) !struct { JunctionBox, JunctionBox } {
    const closest_two = find_closest_two_unconnected(list.*);
    var first = &list.items[closest_two[0]];
    var second = &list.items[closest_two[1]];
    if (first.circuit == 0 and second.circuit == 0) {
        // Create new circuit.
        const circuit = next_circuit();
        first.circuit = circuit;
        second.circuit = circuit;
    } else if (first.circuit == 0) {
        // Use seconds circuit.
        first.circuit = second.circuit;
    } else if (second.circuit == 0) {
        // Use firsts circuit.
        second.circuit = first.circuit;
    } else if (first.circuit != second.circuit) {
        // Merge two circuits into one. Merge into first.
        const removed_circuit: i32 = second.circuit;
        const circuit = first.circuit;
        for (0..list.items.len) |i| {
            if (list.items[i].circuit == removed_circuit) {
                list.items[i].circuit = circuit;
            }
        }
    }
    first.direct_connections.set(second.i);
    second.direct_connections.set(first.i);
    return .{first.*, second.*};
}

fn get_distance(p1: Pos, p2: Pos) i64 {
    const nx = p2.x - p1.x;
    const ny = p2.y - p1.y;
    const nz = p2.z - p1.z;
    return nx * nx + ny * ny + nz * nz;
}

fn get_circuit_counts(allocator: std.mem.Allocator, list: JunctionBoxList) !std.AutoArrayHashMap(i32, usize) {
    var result = std.AutoArrayHashMap(i32, usize).init(allocator);
    for (list.items) |jb| {
        if (!result.contains(jb.circuit)) {
            try result.put(jb.circuit, 1);
        } else {
            result.getPtr(jb.circuit).?.* += 1;
        }
    }
    return result;
}

fn get_number_of_circuits(allocator: std.mem.Allocator, junction_boxes: JunctionBoxList) !usize {
    var circuit_counts = try get_circuit_counts(allocator, junction_boxes);
    defer circuit_counts.deinit();
    return circuit_counts.count();
}

fn part1(allocator: std.mem.Allocator, junction_boxes: JunctionBoxList) !usize {
    var circuit_counts = try get_circuit_counts(allocator, junction_boxes);
    defer circuit_counts.deinit();
    var it = circuit_counts.iterator();
    var set = std.ArrayList(usize).empty;
    defer set.deinit(allocator);
    while (it.next()) |elem| {
        if (elem.key_ptr.* != 0) {
            try set.append(allocator, elem.value_ptr.*);
        }
    }
    std.mem.sort(usize, set.items, {}, std.sort.desc(usize));
    var answer: usize = 1;
    for (0..3) |i| {
        answer *= set.items[i];
    }
    return answer;
}

fn part2(allocator: std.mem.Allocator, junction_boxes: *JunctionBoxList) !i64 {
    while (true) {
        const connected = try connect_closest_two(&junction_boxes.*);
        const count = try get_number_of_circuits(allocator, junction_boxes.*);
        if (count == 1) {
            return connected[0].pos.x * connected[1].pos.x;
        }
    }
    unreachable;
}

test "pos test" {
    const pos1 = Pos{ .x = 50, .y = 20, .z = 81 };
    const pos2 = Pos{ .x = 10, .y = 21, .z = 50 };
    try std.testing.expectEqual(2562, get_distance(pos1, pos2));
}

test "test data" {
    const input = get_test_data();
    const allocator = std.testing.allocator;

    var junction_boxes = try new_junction_box(allocator, input);
    defer junction_boxes.deinit(allocator);
    try std.testing.expectEqual(20, junction_boxes.items.len);
    try std.testing.expectEqual(162, junction_boxes.items[0].pos.x);
    try std.testing.expectEqual(817, junction_boxes.items[0].pos.y);
    try std.testing.expectEqual(812, junction_boxes.items[0].pos.z);

    const closest = find_closest(junction_boxes, junction_boxes.items[0]);
    try std.testing.expectEqual(19, closest[0]);

    const closest_two = find_closest_two_unconnected(junction_boxes);
    try std.testing.expectEqual(.{ 0, 19 }, closest_two);

    _ = try connect_closest_two(&junction_boxes);
    try std.testing.expectEqual(1, junction_boxes.items[0].circuit);
    try std.testing.expectEqual(1, junction_boxes.items[19].circuit);

    try std.testing.expectEqual(1, junction_boxes.items[0].direct_connections.count());
    try std.testing.expectEqual(1, junction_boxes.items[19].direct_connections.count());

    try std.testing.expect(junction_boxes.items[0].direct_connections.isSet(19));
    try std.testing.expect(junction_boxes.items[19].direct_connections.isSet(0));

    try std.testing.expectEqual(.{ 0, 7 }, find_closest_two_unconnected(junction_boxes));

    _ = try connect_closest_two(&junction_boxes);
    try std.testing.expectEqual(1, junction_boxes.items[0].circuit);
    try std.testing.expectEqual(1, junction_boxes.items[7].circuit);
    try std.testing.expectEqual(1, junction_boxes.items[19].circuit);
    try std.testing.expectEqual(0, junction_boxes.items[1].circuit);

    try std.testing.expectEqual(2, junction_boxes.items[0].direct_connections.count());
    try std.testing.expectEqual(1, junction_boxes.items[7].direct_connections.count());
    try std.testing.expectEqual(1, junction_boxes.items[19].direct_connections.count());

    try std.testing.expect(junction_boxes.items[0].direct_connections.isSet(19));
    try std.testing.expect(junction_boxes.items[0].direct_connections.isSet(7));
    try std.testing.expect(junction_boxes.items[7].direct_connections.isSet(0));

    try std.testing.expectEqual(.{ 2, 13 }, find_closest_two_unconnected(junction_boxes));

    _ = try connect_closest_two(&junction_boxes);
    try std.testing.expectEqual(1, junction_boxes.items[0].circuit);
    try std.testing.expectEqual(1, junction_boxes.items[7].circuit);
    try std.testing.expectEqual(1, junction_boxes.items[19].circuit);
    try std.testing.expectEqual(0, junction_boxes.items[1].circuit);
    try std.testing.expectEqual(2, junction_boxes.items[2].circuit);
    try std.testing.expectEqual(2, junction_boxes.items[13].circuit);

    try std.testing.expectEqual(2, junction_boxes.items[0].direct_connections.count());
    try std.testing.expectEqual(1, junction_boxes.items[7].direct_connections.count());
    try std.testing.expectEqual(1, junction_boxes.items[19].direct_connections.count());
    try std.testing.expectEqual(1, junction_boxes.items[2].direct_connections.count());
    try std.testing.expectEqual(1, junction_boxes.items[13].direct_connections.count());

    try std.testing.expect(junction_boxes.items[2].direct_connections.isSet(13));
    try std.testing.expect(junction_boxes.items[13].direct_connections.isSet(2));

    try std.testing.expectEqual(.{ 7, 19 }, find_closest_two_unconnected(junction_boxes));

    // 3 have already been connected
    for (3..10) |_| {
        _ = try connect_closest_two(&junction_boxes);
    }
    const answer = try part1(allocator, junction_boxes);
    try std.testing.expectEqual(40, answer);

    const answer2 = try part2(allocator, &junction_boxes);
    try std.testing.expectEqual(25272, answer2);
}

fn get_test_data() []const u8 {
    const input =
        \\162,817,812
        \\57,618,57
        \\906,360,560
        \\592,479,940
        \\352,342,300
        \\466,668,158
        \\542,29,236
        \\431,825,988
        \\739,650,466
        \\52,470,668
        \\216,146,977
        \\819,987,18
        \\117,168,530
        \\805,96,715
        \\346,949,466
        \\970,615,88
        \\941,993,340
        \\862,61,35
        \\984,92,344
        \\425,690,689
    ;
    return input;
}
