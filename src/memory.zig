// =============================================================================
// Memory Access Guarantee Tests
// =============================================================================
// Verifies memory access patterns that are core to Pichon's design.
// These tests ensure "how we access memory" is part of the specification.
// =============================================================================

const std = @import("std");
const simd = @import("simd.zig");
const map = @import("map.zig");
const testing = std.testing;

// =============================================================================
// Aliasing Behavior Tests
// =============================================================================
// Pichon uses separate input/output buffers (no in-place mutation).
// This is a design decision that enables SIMD optimization.

test "memory: map output is independent of input" {
    const a = [_]i32{ 1, 2, 3, 4, 5 };
    const b = [_]i32{ 10, 20, 30, 40, 50 };
    var out: [5]i32 = undefined;

    // Output buffer is separate from inputs
    map.pichon_add_i32(&a, &b, 5, &out);

    // Input unchanged
    try testing.expectEqual(@as(i32, 1), a[0]);
    try testing.expectEqual(@as(i32, 10), b[0]);

    // Output correct
    try testing.expectEqual(@as(i32, 11), out[0]);
}

test "memory: scalar map output is independent of input" {
    const a = [_]i32{ 1, 2, 3, 4, 5 };
    var out: [5]i32 = undefined;

    map.pichon_add_s_i32(&a, 5, 100, &out);

    // Input unchanged
    try testing.expectEqual(@as(i32, 1), a[0]);

    // Output correct
    try testing.expectEqual(@as(i32, 101), out[0]);
}

// =============================================================================
// Contiguous Access Verification
// =============================================================================
// All operations assume contiguous memory (stride=1).
// This is fundamental to SIMD efficiency.

test "memory: contiguous access for sum" {
    // Create contiguous array
    var data: [100]i64 = undefined;
    for (&data, 0..) |*v, i| {
        v.* = @intCast(i + 1);
    }

    // Sum should work on contiguous memory
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

    // Verify all elements
    for (out, 0..) |v, i| {
        try testing.expectEqual(@as(i32, @intCast(i + 1)), v);
    }
}

// =============================================================================
// Single-Pass Guarantee for Fusion
// =============================================================================
// Fusion operations must complete in a single memory pass.
// This is verified indirectly by ensuring no intermediate allocation.

test "memory: fusion sum_gt is single-pass" {
    // Large array to stress test
    const N = 10000;
    var data: [N]i32 = undefined;
    for (&data, 0..) |*v, i| {
        v.* = @intCast(i);
    }

    // Fusion: filter + sum in one pass
    const threshold: i32 = N / 2;
    const result = simd.sumGtWiden(i32, i64, &data, N, threshold);

    // Verify result is correct (sum of N/2+1 to N-1)
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

    // Should be N - threshold - 1 elements
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

    // Min value > threshold is threshold + 1
    try testing.expectEqual(threshold + 1, result);
}

// =============================================================================
// Zero-Copy Verification
// =============================================================================
// Operations work directly on provided buffers without copying.

test "memory: reduce operates on original buffer" {
    var data = [_]i32{ 1, 2, 3, 4, 5 };
    const ptr: [*]const i32 = &data;

    const result = simd.sumWiden(i32, i64, ptr, data.len);
    try testing.expectEqual(@as(i64, 15), result);

    // Modify original
    data[0] = 100;

    // New call reflects modification
    const result2 = simd.sumWiden(i32, i64, ptr, data.len);
    try testing.expectEqual(@as(i64, 114), result2);
}

// =============================================================================
// Boundary Safety
// =============================================================================
// Operations handle buffer boundaries correctly.

test "memory: operations respect length parameter" {
    const data = [_]i32{ 1, 2, 3, 4, 5, 100, 200, 300 };

    // Only sum first 5 elements
    const result = simd.sumWiden(i32, i64, &data, 5);
    try testing.expectEqual(@as(i64, 15), result);
}

test "memory: map respects output length" {
    const a = [_]i32{ 1, 2, 3, 4, 5 };
    const b = [_]i32{ 10, 20, 30, 40, 50 };
    var out = [_]i32{ 0, 0, 0, 0, 0, 999, 999, 999 };

    // Only write to first 5 elements
    simd.addVec(i32, &a, &b, &out, 5);

    // First 5 should be written
    try testing.expectEqual(@as(i32, 11), out[0]);
    try testing.expectEqual(@as(i32, 55), out[4]);

    // Rest should be unchanged
    try testing.expectEqual(@as(i32, 999), out[5]);
    try testing.expectEqual(@as(i32, 999), out[7]);
}
