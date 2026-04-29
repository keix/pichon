// =============================================================================
// Codegen: Memory Access Patterns
// =============================================================================
// Purpose: Verify memory access guarantees core to Pichon's design
//
// Verified guarantees:
//   - No aliasing: output is independent of input
//   - Contiguous access: sequential memory traversal
//   - Single-pass: fusion reads data exactly once
//   - Zero-copy: reduce operates directly on input buffer
//   - Boundary safety: operations respect length parameter
//
// Run: zig build test
// =============================================================================

const std = @import("std");
const pichon = @import("pichon");
const simd = pichon.simd;
const map = pichon.map;
const testing = std.testing;

// =============================================================================
// Aliasing Behavior
// =============================================================================

test "memory: map output is independent of input" {
    const a = [_]i32{ 1, 2, 3, 4, 5 };
    const b = [_]i32{ 10, 20, 30, 40, 50 };
    var out: [5]i32 = undefined;

    map.pichon_add_i32(&a, &b, 5, &out);

    try testing.expectEqual(@as(i32, 1), a[0]);
    try testing.expectEqual(@as(i32, 10), b[0]);
    try testing.expectEqual(@as(i32, 11), out[0]);
}

test "memory: scalar map output is independent of input" {
    const a = [_]i32{ 1, 2, 3, 4, 5 };
    var out: [5]i32 = undefined;

    map.pichon_add_s_i32(&a, 5, 100, &out);

    try testing.expectEqual(@as(i32, 1), a[0]);
    try testing.expectEqual(@as(i32, 101), out[0]);
}

// =============================================================================
// Contiguous Access
// =============================================================================

test "memory: contiguous access for sum" {
    var data: [100]i64 = undefined;
    for (&data, 0..) |*v, i| {
        v.* = @intCast(i + 1);
    }

    const result = simd.sum(i64, &data, data.len);
    try testing.expectEqual(@as(i64, 5050), result);
}

test "memory: contiguous access for map" {
    var a: [100]i32 = undefined;
    var b: [100]i32 = undefined;
    var out: [100]i32 = undefined;

    for (&a, &b, 0..) |*av, *bv, i| {
        av.* = @intCast(i);
        bv.* = 1;
    }

    simd.addVec(i32, &a, &b, &out, 100);

    for (out, 0..) |v, i| {
        try testing.expectEqual(@as(i32, @intCast(i + 1)), v);
    }
}

// =============================================================================
// Single-Pass Guarantee for Fusion
// =============================================================================

test "memory: fusion sum_gt is single-pass" {
    const N = 10000;
    var data: [N]i32 = undefined;
    for (&data, 0..) |*v, i| {
        v.* = @intCast(i);
    }

    const threshold: i32 = N / 2;
    const result = simd.sumGtWiden(i32, i64, &data, N, threshold);

    var expected: i64 = 0;
    for (data) |v| {
        if (v > threshold) expected += v;
    }
    try testing.expectEqual(expected, result);
}

test "memory: fusion count_gt is single-pass" {
    const N = 10000;
    var data: [N]i64 = undefined;
    for (&data, 0..) |*v, i| {
        v.* = @intCast(i);
    }

    const threshold: i64 = N / 2;
    const result = simd.countGt(i64, &data, N, threshold);

    const expected: usize = N - @as(usize, @intCast(threshold)) - 1;
    try testing.expectEqual(expected, result);
}

test "memory: fusion min_gt is single-pass" {
    const N = 10000;
    var data: [N]i32 = undefined;
    for (&data, 0..) |*v, i| {
        v.* = @intCast(i);
    }

    const threshold: i32 = N / 2;
    const result = simd.minGt(i32, &data, N, threshold);

    try testing.expectEqual(threshold + 1, result);
}

// =============================================================================
// Zero-Copy
// =============================================================================

test "memory: reduce operates on original buffer" {
    var data = [_]i32{ 1, 2, 3, 4, 5 };
    const ptr: [*]const i32 = &data;

    const result = simd.sumWiden(i32, i64, ptr, data.len);
    try testing.expectEqual(@as(i64, 15), result);

    data[0] = 100;

    const result2 = simd.sumWiden(i32, i64, ptr, data.len);
    try testing.expectEqual(@as(i64, 114), result2);
}

// =============================================================================
// Boundary Safety
// =============================================================================

test "memory: operations respect length parameter" {
    const data = [_]i32{ 1, 2, 3, 4, 5, 100, 200, 300 };

    const result = simd.sumWiden(i32, i64, &data, 5);
    try testing.expectEqual(@as(i64, 15), result);
}

test "memory: map respects output length" {
    const a = [_]i32{ 1, 2, 3, 4, 5 };
    const b = [_]i32{ 10, 20, 30, 40, 50 };
    var out = [_]i32{ 0, 0, 0, 0, 0, 999, 999, 999 };

    simd.addVec(i32, &a, &b, &out, 5);

    try testing.expectEqual(@as(i32, 11), out[0]);
    try testing.expectEqual(@as(i32, 55), out[4]);
    try testing.expectEqual(@as(i32, 999), out[5]);
    try testing.expectEqual(@as(i32, 999), out[7]);
}
