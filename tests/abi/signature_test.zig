// =============================================================================
// ABI: Function Signatures
// =============================================================================
// Purpose: Freeze function signatures via compile-time assertions
//
// These tests are SACRED - signature changes require versioned migration.
//
// Verified signatures:
//   - reduce: (ptr, len) -> result
//   - filter: (ptr, len, out, threshold) -> count
//   - map:    (a, b, len, out) or (a, len, scalar, out)
//   - fusion: (ptr, len, threshold) -> result
//
// Run: zig build test
// =============================================================================

const std = @import("std");
const pichon = @import("pichon");
const reduce = pichon.reduce;
const filter = pichon.filter;
const map = pichon.map;
const fusion = pichon.fusion;

// =============================================================================
// Signature Verification Helpers
// =============================================================================

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
// Runtime test (ensures comptime blocks are evaluated)
// =============================================================================

const testing = std.testing;

test "ABI signatures are locked" {
    // If this compiles, all comptime assertions passed
    try testing.expect(true);
}
