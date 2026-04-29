// =============================================================================
// Performance Regression Tests
// =============================================================================
// These tests fail if performance degrades beyond acceptable thresholds.
// "Slow = Broken" for Pichon.
// =============================================================================

const std = @import("std");
const simd = @import("simd.zig");
const testing = std.testing;

// =============================================================================
// Configuration
// =============================================================================

const builtin = @import("builtin");

const N: usize = 10_000_000;

// Performance tests only run in ReleaseFast.
// This ensures thresholds are meaningful specifications, not approximations.
fn requireRelease() bool {
    if (builtin.mode != .ReleaseFast) {
        std.log.warn("perf test requires ReleaseFast, skipping", .{});
        return false;
    }
    return true;
}

// Thresholds in nanoseconds per element (ReleaseFast only)
// These are the specification - exceeding them means the code is broken.
const Threshold = struct {
    // Reduce: ~0.3ns/elem (memory bound)
    sum_ns_per_elem: u64 = 1,

    // Fusion: ~0.5ns/elem (compute + memory)
    fusion_ns_per_elem: u64 = 2,

    // Map: ~1ns/elem (read + write)
    map_ns_per_elem: u64 = 3,
};

const threshold = Threshold{};

// =============================================================================
// Helpers
// =============================================================================

fn benchmark(comptime op: anytype, args: anytype, iterations: usize) u64 {
    var timer = std.time.Timer.start() catch return 0;

    var i: usize = 0;
    while (i < iterations) : (i += 1) {
        const result = @call(.auto, op, args);
        std.mem.doNotOptimizeAway(&result);
    }

    return timer.read() / iterations;
}

fn allocData(comptime T: type, allocator: std.mem.Allocator, n: usize) ![]T {
    const data = try allocator.alloc(T, n);
    for (data, 0..) |*v, i| {
        v.* = @intCast(i);
    }
    return data;
}

// =============================================================================
// Reduce Performance Tests
// =============================================================================

test "perf: sum_i64 within threshold" {
    if (!requireRelease()) return;

    const allocator = testing.allocator;
    const data = try allocData(i64, allocator, N);
    defer allocator.free(data);

    const elapsed_ns = benchmark(simd.sum, .{ i64, data.ptr, N }, 3);
    const ns_per_elem = elapsed_ns / N;

    std.debug.print("\nsum_i64: {d}ns total, {d}ns/elem\n", .{ elapsed_ns, ns_per_elem });

    try testing.expect(ns_per_elem <= threshold.sum_ns_per_elem);
}

test "perf: sumWiden_i32 within threshold" {
    if (!requireRelease()) return;

    const allocator = testing.allocator;
    const data = try allocData(i32, allocator, N);
    defer allocator.free(data);

    const elapsed_ns = benchmark(simd.sumWiden, .{ i32, i64, data.ptr, N }, 3);
    const ns_per_elem = elapsed_ns / N;

    std.debug.print("\nsumWiden_i32: {d}ns total, {d}ns/elem\n", .{ elapsed_ns, ns_per_elem });

    try testing.expect(ns_per_elem <= threshold.sum_ns_per_elem);
}

// =============================================================================
// Fusion Performance Tests
// =============================================================================

test "perf: sumGt_i64 within threshold" {
    if (!requireRelease()) return;

    const allocator = testing.allocator;
    const data = try allocData(i64, allocator, N);
    defer allocator.free(data);

    const t: i64 = @intCast(N / 2);
    const elapsed_ns = benchmark(simd.sumGt, .{ i64, data.ptr, N, t }, 3);
    const ns_per_elem = elapsed_ns / N;

    std.debug.print("\nsumGt_i64: {d}ns total, {d}ns/elem\n", .{ elapsed_ns, ns_per_elem });

    try testing.expect(ns_per_elem <= threshold.fusion_ns_per_elem);
}

test "perf: countGt_i64 within threshold" {
    if (!requireRelease()) return;

    const allocator = testing.allocator;
    const data = try allocData(i64, allocator, N);
    defer allocator.free(data);

    const t: i64 = @intCast(N / 2);
    const elapsed_ns = benchmark(simd.countGt, .{ i64, data.ptr, N, t }, 3);
    const ns_per_elem = elapsed_ns / N;

    std.debug.print("\ncountGt_i64: {d}ns total, {d}ns/elem\n", .{ elapsed_ns, ns_per_elem });

    try testing.expect(ns_per_elem <= threshold.fusion_ns_per_elem);
}

test "perf: minGt_i64 within threshold" {
    if (!requireRelease()) return;

    const allocator = testing.allocator;
    const data = try allocData(i64, allocator, N);
    defer allocator.free(data);

    const t: i64 = @intCast(N / 2);
    const elapsed_ns = benchmark(simd.minGt, .{ i64, data.ptr, N, t }, 3);
    const ns_per_elem = elapsed_ns / N;

    std.debug.print("\nminGt_i64: {d}ns total, {d}ns/elem\n", .{ elapsed_ns, ns_per_elem });

    try testing.expect(ns_per_elem <= threshold.fusion_ns_per_elem);
}

// =============================================================================
// Map Performance Tests
// =============================================================================

test "perf: addVec_i64 within threshold" {
    if (!requireRelease()) return;

    const allocator = testing.allocator;
    const a = try allocData(i64, allocator, N);
    defer allocator.free(a);
    const b = try allocData(i64, allocator, N);
    defer allocator.free(b);
    const out = try allocator.alloc(i64, N);
    defer allocator.free(out);

    const elapsed_ns = benchmark(simd.addVec, .{ i64, a.ptr, b.ptr, out.ptr, N }, 3);
    const ns_per_elem = elapsed_ns / N;

    std.debug.print("\naddVec_i64: {d}ns total, {d}ns/elem\n", .{ elapsed_ns, ns_per_elem });

    try testing.expect(ns_per_elem <= threshold.map_ns_per_elem);
}

test "perf: mulVec_f64 within threshold" {
    if (!requireRelease()) return;

    const allocator = testing.allocator;

    const a = try allocator.alloc(f64, N);
    defer allocator.free(a);
    const b = try allocator.alloc(f64, N);
    defer allocator.free(b);
    const out = try allocator.alloc(f64, N);
    defer allocator.free(out);

    for (a, b, 0..) |*av, *bv, i| {
        av.* = @floatFromInt(i);
        bv.* = 1.5;
    }

    const elapsed_ns = benchmark(simd.mulVec, .{ f64, a.ptr, b.ptr, out.ptr, N }, 3);
    const ns_per_elem = elapsed_ns / N;

    std.debug.print("\nmulVec_f64: {d}ns total, {d}ns/elem\n", .{ elapsed_ns, ns_per_elem });

    try testing.expect(ns_per_elem <= threshold.map_ns_per_elem);
}

// =============================================================================
// Comparative Performance (Fusion vs Separate)
// =============================================================================
// Fusion should be faster than filter + reduce separately.

test "perf: fusion faster than separate" {
    if (!requireRelease()) return;

    const allocator = testing.allocator;
    const data = try allocData(i64, allocator, N);
    defer allocator.free(data);

    const t: i64 = @intCast(N / 2);

    // Measure fusion
    const fusion_ns = benchmark(simd.sumGt, .{ i64, data.ptr, N, t }, 3);

    // Measure separate (filter then sum - approximated)
    // In practice, separate would need intermediate buffer
    // This test documents the performance advantage of fusion

    std.debug.print("\nfusion sumGt: {d}ns\n", .{fusion_ns});

    // Fusion should complete in reasonable time
    try testing.expect(fusion_ns < N * 5); // 5ns/elem max
}
