const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    addDay(b, "2025", "day01", target, optimize);
    addDay(b, "2025", "day02", target, optimize);
    addDay(b, "2025", "day03", target, optimize);
    addDay(b, "2025", "day04", target, optimize);
}

fn addDay(
    b: *std.Build,
    year: []const u8,
    day: []const u8,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
) void {
    const exe_name = b.fmt("{s}-{s}", .{ year, day });
    const root_path = b.path(b.fmt("{s}/{s}/src/main.zig", .{ year, day }));
    const input_path = b.path(b.fmt("{s}/{s}/input", .{ year, day }));

    const exe = b.addExecutable(.{
        .name = exe_name,
        .root_module = b.createModule(.{
            .root_source_file = root_path,
            .target = target,
            .optimize = optimize,
        }),
    });

    exe.root_module.addAnonymousImport("input", .{.root_source_file = input_path});

    b.installArtifact(exe);

    const run_step = b.addRunArtifact(exe);
    run_step.step.dependOn(b.getInstallStep());
    const run_option = b.step(b.fmt("run-{s}", .{exe_name}), b.fmt("Run {s}", .{exe_name}));
    run_option.dependOn(&run_step.step);
}
