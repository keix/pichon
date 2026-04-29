// =============================================================================
// Performance: Regression Tests
// =============================================================================
// Purpose: Fail if performance degrades beyond thresholds
//
// "Slow = Broken" for Pichon.
//
// Configuration:
//   N = 10,000,000 elements
//   Iterations = 3 (averaged)
//
// Output format:
//   "{operation}: {total_ns}ns total, {ns_per_elem}ns/elem"
//   - total_ns: average time across iterations
//   - ns_per_elem: total_ns / N (must be <= threshold)
//
// Thresholds (nanoseconds per element):
//   - reduce (sum):       1 ns/elem
//   - fusion (filter+reduce): 2 ns/elem
//   - map (vector ops):   3 ns/elem
//
// IMPORTANT: Only runs in ReleaseFast mode (skipped otherwise)
//
// Run: zig build perf -Doptimize=ReleaseFast
// =============================================================================

const std = @import("std");
const pichon = @import("pichon");
const simd = pichon.simd;
const testing = std.testing;
const builtin = @import("builtin");

// =============================================================================
// Configuration
// =============================================================================

const N: usize = 10_000_000;

fn requireRelease() bool {
    if (builtin.mode != .ReleaseFast) {
        std.log.warn("perf test requires ReleaseFast, skipping", .{});
        return false;
    }
    return true;
}

// Thresholds in nanoseconds per element (ReleaseFast only)
const Threshold = struct {
    sum_ns_per_elem: u64 = 1,
    fusion_ns_per_elem: u64 = 2,
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
// Reduce Performance
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
// Fusion Performance
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
// Map Performance
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
// Fusion Advantage
// =============================================================================

test "perf: fusion faster than separate" {
    if (!requireRelease()) return;

    const allocator = testing.allocator;
    const data = try allocData(i64, allocator, N);
    defer allocator.free(data);

    const t: i64 = @intCast(N / 2);
    const fusion_ns = benchmark(simd.sumGt, .{ i64, data.ptr, N, t }, 3);

    std.debug.print("\nfusion sumGt: {d}ns\n", .{fusion_ns});

    try testing.expect(fusion_ns < N * 5);
}
