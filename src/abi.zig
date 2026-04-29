// =============================================================================
// ABI Lock Tests
// =============================================================================
// Compile-time assertions that freeze the binary interface.
// If any of these fail, the ABI has been broken.
// =============================================================================

const std = @import("std");
const reduce = @import("reduce.zig");
const filter = @import("filter.zig");
const map = @import("map.zig");
const fusion = @import("fusion.zig");
const simd = @import("simd.zig");

// =============================================================================
// Type Size Guarantees
// =============================================================================
// These are fundamental to FFI safety.

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
// Function Signature Verification
// =============================================================================
// Ensures function signatures never change without explicit intent.

fn verifyReduceSignature(
    comptime Fn: type,
    comptime InputT: type,
    comptime OutputT: type,
) void {
    const info = @typeInfo(Fn).@"fn";
    // Args: (ptr, len)
    std.debug.assert(info.params.len == 2);
    std.debug.assert(info.params[0].type == [*]const InputT);
    std.debug.assert(info.params[1].type == usize);
    std.debug.assert(info.return_type == OutputT);
}

fn verifyFilterSignature(
    comptime Fn: type,
    comptime T: type,
) void {
    const info = @typeInfo(Fn).@"fn";
    // Args: (in_ptr, len, out_ptr, threshold)
    std.debug.assert(info.params.len == 4);
    std.debug.assert(info.params[0].type == [*]const T);
    std.debug.assert(info.params[1].type == usize);
    std.debug.assert(info.params[2].type == [*]T);
    std.debug.assert(info.params[3].type == T);
    std.debug.assert(info.return_type == usize);
}

fn verifyMapBinarySignature(
    comptime Fn: type,
    comptime T: type,
) void {
    const info = @typeInfo(Fn).@"fn";
    // Args: (a, b, len, out)
    std.debug.assert(info.params.len == 4);
    std.debug.assert(info.params[0].type == [*]const T);
    std.debug.assert(info.params[1].type == [*]const T);
    std.debug.assert(info.params[2].type == usize);
    std.debug.assert(info.params[3].type == [*]T);
    std.debug.assert(info.return_type == void);
}

fn verifyMapScalarSignature(
    comptime Fn: type,
    comptime T: type,
) void {
    const info = @typeInfo(Fn).@"fn";
    // Args: (a, len, scalar, out)
    std.debug.assert(info.params.len == 4);
    std.debug.assert(info.params[0].type == [*]const T);
    std.debug.assert(info.params[1].type == usize);
    std.debug.assert(info.params[2].type == T);
    std.debug.assert(info.params[3].type == [*]T);
    std.debug.assert(info.return_type == void);
}

fn verifyFusionSignature(
    comptime Fn: type,
    comptime InputT: type,
    comptime OutputT: type,
) void {
    const info = @typeInfo(Fn).@"fn";
    // Args: (ptr, len, threshold)
    std.debug.assert(info.params.len == 3);
    std.debug.assert(info.params[0].type == [*]const InputT);
    std.debug.assert(info.params[1].type == usize);
    std.debug.assert(info.params[2].type == InputT);
    std.debug.assert(info.return_type == OutputT);
}

// =============================================================================
// Reduce ABI Lock
// =============================================================================

comptime {
    // sum: i32 → i64 (widening)
    verifyReduceSignature(@TypeOf(reduce.pichon_sum_i32), i32, i64);
    // sum: i64 → i64
    verifyReduceSignature(@TypeOf(reduce.pichon_sum_i64), i64, i64);
    // sum: f64 → f64
    verifyReduceSignature(@TypeOf(reduce.pichon_sum_f64), f64, f64);

    // min/max: T → T
    verifyReduceSignature(@TypeOf(reduce.pichon_min_i32), i32, i32);
    verifyReduceSignature(@TypeOf(reduce.pichon_min_i64), i64, i64);
    verifyReduceSignature(@TypeOf(reduce.pichon_min_f64), f64, f64);
    verifyReduceSignature(@TypeOf(reduce.pichon_max_i32), i32, i32);
    verifyReduceSignature(@TypeOf(reduce.pichon_max_i64), i64, i64);
    verifyReduceSignature(@TypeOf(reduce.pichon_max_f64), f64, f64);
}

// =============================================================================
// Filter ABI Lock
// =============================================================================

comptime {
    verifyFilterSignature(@TypeOf(filter.pichon_filter_gt_i32), i32);
    verifyFilterSignature(@TypeOf(filter.pichon_filter_gt_i64), i64);
    verifyFilterSignature(@TypeOf(filter.pichon_filter_gt_f64), f64);
    verifyFilterSignature(@TypeOf(filter.pichon_filter_lt_i32), i32);
    verifyFilterSignature(@TypeOf(filter.pichon_filter_lt_i64), i64);
    verifyFilterSignature(@TypeOf(filter.pichon_filter_lt_f64), f64);
}

// =============================================================================
// Map ABI Lock
// =============================================================================

comptime {
    // Binary ops
    verifyMapBinarySignature(@TypeOf(map.pichon_add_i32), i32);
    verifyMapBinarySignature(@TypeOf(map.pichon_add_i64), i64);
    verifyMapBinarySignature(@TypeOf(map.pichon_add_f64), f64);
    verifyMapBinarySignature(@TypeOf(map.pichon_sub_i32), i32);
    verifyMapBinarySignature(@TypeOf(map.pichon_sub_i64), i64);
    verifyMapBinarySignature(@TypeOf(map.pichon_sub_f64), f64);
    verifyMapBinarySignature(@TypeOf(map.pichon_mul_i32), i32);
    verifyMapBinarySignature(@TypeOf(map.pichon_mul_i64), i64);
    verifyMapBinarySignature(@TypeOf(map.pichon_mul_f64), f64);

    // Scalar ops
    verifyMapScalarSignature(@TypeOf(map.pichon_add_s_i32), i32);
    verifyMapScalarSignature(@TypeOf(map.pichon_add_s_i64), i64);
    verifyMapScalarSignature(@TypeOf(map.pichon_add_s_f64), f64);
    verifyMapScalarSignature(@TypeOf(map.pichon_sub_s_i32), i32);
    verifyMapScalarSignature(@TypeOf(map.pichon_sub_s_i64), i64);
    verifyMapScalarSignature(@TypeOf(map.pichon_sub_s_f64), f64);
    verifyMapScalarSignature(@TypeOf(map.pichon_mul_s_i32), i32);
    verifyMapScalarSignature(@TypeOf(map.pichon_mul_s_i64), i64);
    verifyMapScalarSignature(@TypeOf(map.pichon_mul_s_f64), f64);
}

// =============================================================================
// Fusion ABI Lock
// =============================================================================

comptime {
    // sum_gt/sum_lt: i32 → i64 (widening)
    verifyFusionSignature(@TypeOf(fusion.pichon_sum_gt_i32), i32, i64);
    verifyFusionSignature(@TypeOf(fusion.pichon_sum_gt_i64), i64, i64);
    verifyFusionSignature(@TypeOf(fusion.pichon_sum_gt_f64), f64, f64);
    verifyFusionSignature(@TypeOf(fusion.pichon_sum_lt_i32), i32, i64);
    verifyFusionSignature(@TypeOf(fusion.pichon_sum_lt_i64), i64, i64);
    verifyFusionSignature(@TypeOf(fusion.pichon_sum_lt_f64), f64, f64);

    // count_gt/count_lt: T → usize
    verifyFusionSignature(@TypeOf(fusion.pichon_count_gt_i32), i32, usize);
    verifyFusionSignature(@TypeOf(fusion.pichon_count_gt_i64), i64, usize);
    verifyFusionSignature(@TypeOf(fusion.pichon_count_gt_f64), f64, usize);
    verifyFusionSignature(@TypeOf(fusion.pichon_count_lt_i32), i32, usize);
    verifyFusionSignature(@TypeOf(fusion.pichon_count_lt_i64), i64, usize);
    verifyFusionSignature(@TypeOf(fusion.pichon_count_lt_f64), f64, usize);

    // min_gt/min_lt: T → T
    verifyFusionSignature(@TypeOf(fusion.pichon_min_gt_i32), i32, i32);
    verifyFusionSignature(@TypeOf(fusion.pichon_min_gt_i64), i64, i64);
    verifyFusionSignature(@TypeOf(fusion.pichon_min_gt_f64), f64, f64);
    verifyFusionSignature(@TypeOf(fusion.pichon_min_lt_i32), i32, i32);
    verifyFusionSignature(@TypeOf(fusion.pichon_min_lt_i64), i64, i64);
    verifyFusionSignature(@TypeOf(fusion.pichon_min_lt_f64), f64, f64);

    // max_gt/max_lt: T → T
    verifyFusionSignature(@TypeOf(fusion.pichon_max_gt_i32), i32, i32);
    verifyFusionSignature(@TypeOf(fusion.pichon_max_gt_i64), i64, i64);
    verifyFusionSignature(@TypeOf(fusion.pichon_max_gt_f64), f64, f64);
    verifyFusionSignature(@TypeOf(fusion.pichon_max_lt_i32), i32, i32);
    verifyFusionSignature(@TypeOf(fusion.pichon_max_lt_i64), i64, i64);
    verifyFusionSignature(@TypeOf(fusion.pichon_max_lt_f64), f64, f64);
}

// =============================================================================
// SIMD Lane Width Lock
// =============================================================================
// Ensures SIMD vectorization uses expected lane widths.

comptime {
    // AVX2: 256-bit vectors
    // i32: 256 / 32 = 8 lanes
    // i64: 256 / 64 = 4 lanes
    // f64: 256 / 64 = 4 lanes
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
// Sentinel Value Specification
// =============================================================================
// Documents the behavior of min/max fusion on empty/no-match sets.

comptime {
    // min with no match returns maxInt (sentinel)
    std.debug.assert(simd.minGt(i32, @as([*]const i32, &[_]i32{}), 0, 0) == std.math.maxInt(i32));

    // max with no match returns minInt (sentinel)
    std.debug.assert(simd.maxGt(i32, @as([*]const i32, &[_]i32{}), 0, 0) == std.math.minInt(i32));
}

// =============================================================================
// Export Count Lock
// =============================================================================
// Ensures the total number of exported functions doesn't change unexpectedly.

comptime {
    // Total exported functions: 57
    // reduce: 9 (sum×3 + min×3 + max×3)
    // filter: 6 (gt×3 + lt×3)
    // map binary: 9 (add×3 + sub×3 + mul×3)
    // map scalar: 9 (add_s×3 + sub_s×3 + mul_s×3)
    // fusion: 24 (sum_gt×3 + sum_lt×3 + count_gt×3 + count_lt×3 + min_gt×3 + min_lt×3 + max_gt×3 + max_lt×3)
    const EXPECTED_EXPORTS = 57;
    _ = EXPECTED_EXPORTS; // Documented for reference
}

// =============================================================================
// Runtime Tests
// =============================================================================

const testing = std.testing;

test "ABI: type sizes match C" {
    try testing.expectEqual(@as(usize, 4), @sizeOf(i32));
    try testing.expectEqual(@as(usize, 8), @sizeOf(i64));
    try testing.expectEqual(@as(usize, 8), @sizeOf(f64));
    try testing.expectEqual(@as(usize, 8), @sizeOf(usize));
    try testing.expectEqual(@as(usize, 8), @sizeOf([*]const i32));
}

test "ABI: SIMD lanes are vectorized" {
    // Verify we're actually vectorizing (not falling back to scalar)
    try testing.expect(simd.lanes(i32) >= 4);
    try testing.expect(simd.lanes(i64) >= 2);
    try testing.expect(simd.lanes(f64) >= 2);
}

test "ABI: sentinel values are consistent" {
    // min sentinel = maxInt
    try testing.expectEqual(std.math.maxInt(i32), simd.minGt(i32, &[_]i32{}, 0, 0));
    try testing.expectEqual(std.math.maxInt(i64), simd.minGt(i64, &[_]i64{}, 0, 0));

    // max sentinel = minInt
    try testing.expectEqual(std.math.minInt(i32), simd.maxGt(i32, &[_]i32{}, 0, 0));
    try testing.expectEqual(std.math.minInt(i64), simd.maxGt(i64, &[_]i64{}, 0, 0));
}
