// =============================================================================
// ABI: Type Layout
// =============================================================================
// Purpose: Freeze type sizes, alignments, and SIMD configuration
//
// These tests are SACRED - layout changes break FFI compatibility.
//
// Verified guarantees:
//   - Type sizes: i32=4, i64=8, f64=8, usize=8, ptr=8
//   - Type alignment: i32=4, i64=8, f64=8
//   - SIMD lanes: i32>=4, i64>=2, f64>=2
//   - Sentinel values: min->maxInt, max->minInt (on no match)
//
// Run: zig build test
// =============================================================================

const std = @import("std");
const pichon = @import("pichon");
const simd = pichon.simd;
const testing = std.testing;

// =============================================================================
// Type Size Guarantees (comptime)
// =============================================================================

comptime {
    // Primitive types must match C ABI
    std.debug.assert(@sizeOf(i32) == 4);
    std.debug.assert(@sizeOf(i64) == 8);
    std.debug.assert(@sizeOf(f64) == 8);
    std.debug.assert(@sizeOf(usize) == 8); // 64-bit platform

    // Alignment must match C ABI
    std.debug.assert(@alignOf(i32) == 4);
    std.debug.assert(@alignOf(i64) == 8);
    std.debug.assert(@alignOf(f64) == 8);
}

// =============================================================================
// SIMD Lane Width Lock (comptime)
// =============================================================================

comptime {
    const i32_lanes = simd.lanes(i32);
    const i64_lanes = simd.lanes(i64);
    const f64_lanes = simd.lanes(f64);

    // Minimum lane requirements (must vectorize)
    std.debug.assert(i32_lanes >= 4);
    std.debug.assert(i64_lanes >= 2);
    std.debug.assert(f64_lanes >= 2);

    // Lane relationship (i32 should have 2x lanes of i64)
    std.debug.assert(i32_lanes == i64_lanes * 2);
    std.debug.assert(i64_lanes == f64_lanes);
}

// =============================================================================
// Sentinel Value Specification (comptime)
// =============================================================================

comptime {
    // min with no match returns maxInt (sentinel)
    std.debug.assert(simd.minGt(i32, @as([*]const i32, &[_]i32{}), 0, 0) == std.math.maxInt(i32));

    // max with no match returns minInt (sentinel)
    std.debug.assert(simd.maxGt(i32, @as([*]const i32, &[_]i32{}), 0, 0) == std.math.minInt(i32));
}

// =============================================================================
// Runtime Tests
// =============================================================================

test "type sizes match C ABI" {
    try testing.expectEqual(@as(usize, 4), @sizeOf(i32));
    try testing.expectEqual(@as(usize, 8), @sizeOf(i64));
    try testing.expectEqual(@as(usize, 8), @sizeOf(f64));
    try testing.expectEqual(@as(usize, 8), @sizeOf(usize));
    try testing.expectEqual(@as(usize, 8), @sizeOf([*]const i32));
}

test "SIMD lanes are vectorized" {
    try testing.expect(simd.lanes(i32) >= 4);
    try testing.expect(simd.lanes(i64) >= 2);
    try testing.expect(simd.lanes(f64) >= 2);
}

test "sentinel values are consistent" {
    // min sentinel = maxInt
    try testing.expectEqual(std.math.maxInt(i32), simd.minGt(i32, &[_]i32{}, 0, 0));
    try testing.expectEqual(std.math.maxInt(i64), simd.minGt(i64, &[_]i64{}, 0, 0));

    // max sentinel = minInt
    try testing.expectEqual(std.math.minInt(i32), simd.maxGt(i32, &[_]i32{}, 0, 0));
    try testing.expectEqual(std.math.minInt(i64), simd.maxGt(i64, &[_]i64{}, 0, 0));
}
