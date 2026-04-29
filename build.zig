const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // =========================================================================
    // Source Modules
    // =========================================================================

    const src_module = b.createModule(.{
        .root_source_file = b.path("src/lib.zig"),
        .target = target,
        .optimize = optimize,
    });

    // =========================================================================
    // Library
    // =========================================================================

    const lib = b.addLibrary(.{
        .linkage = .dynamic,
        .name = "pichon",
        .root_module = src_module,
    });

    b.installArtifact(lib);

    // =========================================================================
    // Test Steps
    // =========================================================================

    const test_step = b.step("test", "Run behavior, ABI, and codegen tests");
    const perf_step = b.step("perf", "Run performance tests (use -Doptimize=ReleaseFast)");

    // -------------------------------------------------------------------------
    // Behavior Tests
    // -------------------------------------------------------------------------

    const behavior_tests = [_][]const u8{
        "tests/behavior/reduce_test.zig",
        "tests/behavior/filter_test.zig",
        "tests/behavior/map_test.zig",
        "tests/behavior/fusion_test.zig",
    };

    for (behavior_tests) |test_file| {
        const t = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(test_file),
                .target = target,
                .optimize = optimize,
                .imports = &.{
                    .{ .name = "pichon", .module = src_module },
                },
            }),
        });
        const run = b.addRunArtifact(t);
        test_step.dependOn(&run.step);
    }

    // -------------------------------------------------------------------------
    // ABI Tests
    // -------------------------------------------------------------------------

    const abi_tests = [_][]const u8{
        "tests/abi/signature_test.zig",
        "tests/abi/layout_test.zig",
    };

    for (abi_tests) |test_file| {
        const t = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(test_file),
                .target = target,
                .optimize = optimize,
                .imports = &.{
                    .{ .name = "pichon", .module = src_module },
                },
            }),
        });
        const run = b.addRunArtifact(t);
        test_step.dependOn(&run.step);
    }

    // -------------------------------------------------------------------------
    // Codegen Tests
    // -------------------------------------------------------------------------

    const codegen_tests = [_][]const u8{
        "tests/codegen/simd_test.zig",
        "tests/codegen/memory_test.zig",
    };

    for (codegen_tests) |test_file| {
        const t = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(test_file),
                .target = target,
                .optimize = optimize,
                .imports = &.{
                    .{ .name = "pichon", .module = src_module },
                },
            }),
        });
        const run = b.addRunArtifact(t);
        test_step.dependOn(&run.step);
    }

    // -------------------------------------------------------------------------
    // Performance Tests
    // -------------------------------------------------------------------------

    const perf_tests = [_][]const u8{
        "tests/perf/perf_test.zig",
    };

    for (perf_tests) |test_file| {
        const t = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(test_file),
                .target = target,
                .optimize = optimize,
                .imports = &.{
                    .{ .name = "pichon", .module = src_module },
                },
            }),
        });
        const run = b.addRunArtifact(t);
        perf_step.dependOn(&run.step);
    }
}
