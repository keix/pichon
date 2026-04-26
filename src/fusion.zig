// =============================================================================
// Fusion operations
// =============================================================================
// Combined filter + reduce in a single pass.
// Backed by unified SIMD primitives.
// =============================================================================

const simd = @import("simd.zig");

// -----------------------------------------------------------------------------
// Exports: sum_gt (filter > threshold, then sum)
// -----------------------------------------------------------------------------

pub export fn pichon_sum_gt_i32(ptr: [*]const i32, len: usize, threshold: i32) i64 {
    return simd.sumGtWiden(i32, i64, ptr, len, threshold);
}

pub export fn pichon_sum_gt_i64(ptr: [*]const i64, len: usize, threshold: i64) i64 {
    return simd.sumGt(i64, ptr, len, threshold);
}

pub export fn pichon_sum_gt_f64(ptr: [*]const f64, len: usize, threshold: f64) f64 {
    return simd.sumGt(f64, ptr, len, threshold);
}

// -----------------------------------------------------------------------------
// Exports: sum_lt (filter < threshold, then sum)
// -----------------------------------------------------------------------------

pub export fn pichon_sum_lt_i32(ptr: [*]const i32, len: usize, threshold: i32) i64 {
    return simd.sumLtWiden(i32, i64, ptr, len, threshold);
}

pub export fn pichon_sum_lt_i64(ptr: [*]const i64, len: usize, threshold: i64) i64 {
    return simd.sumLt(i64, ptr, len, threshold);
}

pub export fn pichon_sum_lt_f64(ptr: [*]const f64, len: usize, threshold: f64) f64 {
    return simd.sumLt(f64, ptr, len, threshold);
}

// -----------------------------------------------------------------------------
// Exports: count_gt (count where > threshold)
// -----------------------------------------------------------------------------

pub export fn pichon_count_gt_i32(ptr: [*]const i32, len: usize, threshold: i32) usize {
    return simd.countGt(i32, ptr, len, threshold);
}

pub export fn pichon_count_gt_i64(ptr: [*]const i64, len: usize, threshold: i64) usize {
    return simd.countGt(i64, ptr, len, threshold);
}

pub export fn pichon_count_gt_f64(ptr: [*]const f64, len: usize, threshold: f64) usize {
    return simd.countGt(f64, ptr, len, threshold);
}

// -----------------------------------------------------------------------------
// Exports: count_lt (count where < threshold)
// -----------------------------------------------------------------------------

pub export fn pichon_count_lt_i32(ptr: [*]const i32, len: usize, threshold: i32) usize {
    return simd.countLt(i32, ptr, len, threshold);
}

pub export fn pichon_count_lt_i64(ptr: [*]const i64, len: usize, threshold: i64) usize {
    return simd.countLt(i64, ptr, len, threshold);
}

pub export fn pichon_count_lt_f64(ptr: [*]const f64, len: usize, threshold: f64) usize {
    return simd.countLt(f64, ptr, len, threshold);
}

// -----------------------------------------------------------------------------
// Exports: min_gt (filter > threshold, then min)
// -----------------------------------------------------------------------------

pub export fn pichon_min_gt_i32(ptr: [*]const i32, len: usize, threshold: i32) i32 {
    return simd.minGt(i32, ptr, len, threshold);
}

pub export fn pichon_min_gt_i64(ptr: [*]const i64, len: usize, threshold: i64) i64 {
    return simd.minGt(i64, ptr, len, threshold);
}

pub export fn pichon_min_gt_f64(ptr: [*]const f64, len: usize, threshold: f64) f64 {
    return simd.minGt(f64, ptr, len, threshold);
}

// -----------------------------------------------------------------------------
// Exports: min_lt (filter < threshold, then min)
// -----------------------------------------------------------------------------

pub export fn pichon_min_lt_i32(ptr: [*]const i32, len: usize, threshold: i32) i32 {
    return simd.minLt(i32, ptr, len, threshold);
}

pub export fn pichon_min_lt_i64(ptr: [*]const i64, len: usize, threshold: i64) i64 {
    return simd.minLt(i64, ptr, len, threshold);
}

pub export fn pichon_min_lt_f64(ptr: [*]const f64, len: usize, threshold: f64) f64 {
    return simd.minLt(f64, ptr, len, threshold);
}

// -----------------------------------------------------------------------------
// Exports: max_gt (filter > threshold, then max)
// -----------------------------------------------------------------------------

pub export fn pichon_max_gt_i32(ptr: [*]const i32, len: usize, threshold: i32) i32 {
    return simd.maxGt(i32, ptr, len, threshold);
}

pub export fn pichon_max_gt_i64(ptr: [*]const i64, len: usize, threshold: i64) i64 {
    return simd.maxGt(i64, ptr, len, threshold);
}

pub export fn pichon_max_gt_f64(ptr: [*]const f64, len: usize, threshold: f64) f64 {
    return simd.maxGt(f64, ptr, len, threshold);
}

// -----------------------------------------------------------------------------
// Exports: max_lt (filter < threshold, then max)
// -----------------------------------------------------------------------------

pub export fn pichon_max_lt_i32(ptr: [*]const i32, len: usize, threshold: i32) i32 {
    return simd.maxLt(i32, ptr, len, threshold);
}

pub export fn pichon_max_lt_i64(ptr: [*]const i64, len: usize, threshold: i64) i64 {
    return simd.maxLt(i64, ptr, len, threshold);
}

pub export fn pichon_max_lt_f64(ptr: [*]const f64, len: usize, threshold: f64) f64 {
    return simd.maxLt(f64, ptr, len, threshold);
}

// -----------------------------------------------------------------------------
// Tests
// -----------------------------------------------------------------------------

const testing = @import("std").testing;

test "sum_gt_i32" {
    const data = [_]i32{ 10, 50, 30, 80, 20 };
    const result = pichon_sum_gt_i32(&data, data.len, 25);
    // 50 + 30 + 80 = 160
    try testing.expectEqual(@as(i64, 160), result);
}

test "sum_lt_i32" {
    const data = [_]i32{ 10, 50, 30, 80, 20 };
    const result = pichon_sum_lt_i32(&data, data.len, 25);
    // 10 + 20 = 30
    try testing.expectEqual(@as(i64, 30), result);
}

test "count_gt_i32" {
    const data = [_]i32{ 10, 50, 30, 80, 20 };
    const count = pichon_count_gt_i32(&data, data.len, 25);
    try testing.expectEqual(@as(usize, 3), count);
}

test "sum_gt_i64" {
    const data = [_]i64{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
    const result = pichon_sum_gt_i64(&data, data.len, 5);
    // 6 + 7 + 8 + 9 + 10 = 40
    try testing.expectEqual(@as(i64, 40), result);
}

test "sum_gt_f64" {
    const data = [_]f64{ 1.5, 2.5, 3.5, 4.5 };
    const result = pichon_sum_gt_f64(&data, data.len, 2.0);
    // 2.5 + 3.5 + 4.5 = 10.5
    try testing.expectApproxEqAbs(@as(f64, 10.5), result, 0.001);
}

test "count_gt_f64" {
    const data = [_]f64{ 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0 };
    const count = pichon_count_gt_f64(&data, data.len, 5.0);
    try testing.expectEqual(@as(usize, 5), count);
}

test "min_gt_i32" {
    const data = [_]i32{ 10, 50, 30, 80, 20 };
    const result = pichon_min_gt_i32(&data, data.len, 25);
    // min of {50, 30, 80} = 30
    try testing.expectEqual(@as(i32, 30), result);
}

test "min_lt_i32" {
    const data = [_]i32{ 10, 50, 30, 80, 20 };
    const result = pichon_min_lt_i32(&data, data.len, 25);
    // min of {10, 20} = 10
    try testing.expectEqual(@as(i32, 10), result);
}

test "max_gt_i32" {
    const data = [_]i32{ 10, 50, 30, 80, 20 };
    const result = pichon_max_gt_i32(&data, data.len, 25);
    // max of {50, 30, 80} = 80
    try testing.expectEqual(@as(i32, 80), result);
}

test "max_lt_i32" {
    const data = [_]i32{ 10, 50, 30, 80, 20 };
    const result = pichon_max_lt_i32(&data, data.len, 25);
    // max of {10, 20} = 20
    try testing.expectEqual(@as(i32, 20), result);
}

test "min_gt_f64" {
    const data = [_]f64{ 1.5, 2.5, 3.5, 4.5 };
    const result = pichon_min_gt_f64(&data, data.len, 2.0);
    // min of {2.5, 3.5, 4.5} = 2.5
    try testing.expectApproxEqAbs(@as(f64, 2.5), result, 0.001);
}

test "max_lt_f64" {
    const data = [_]f64{ 1.5, 2.5, 3.5, 4.5 };
    const result = pichon_max_lt_f64(&data, data.len, 3.0);
    // max of {1.5, 2.5} = 2.5
    try testing.expectApproxEqAbs(@as(f64, 2.5), result, 0.001);
}

test "min_gt_i64" {
    const data = [_]i64{ 10, 50, 30, 80, 20 };
    const result = pichon_min_gt_i64(&data, data.len, 25);
    // min of {50, 30, 80} = 30
    try testing.expectEqual(@as(i64, 30), result);
}

test "min_lt_i64" {
    const data = [_]i64{ 10, 50, 30, 80, 20 };
    const result = pichon_min_lt_i64(&data, data.len, 25);
    // min of {10, 20} = 10
    try testing.expectEqual(@as(i64, 10), result);
}

test "max_gt_i64" {
    const data = [_]i64{ 10, 50, 30, 80, 20 };
    const result = pichon_max_gt_i64(&data, data.len, 25);
    // max of {50, 30, 80} = 80
    try testing.expectEqual(@as(i64, 80), result);
}

test "max_lt_i64" {
    const data = [_]i64{ 10, 50, 30, 80, 20 };
    const result = pichon_max_lt_i64(&data, data.len, 25);
    // max of {10, 20} = 20
    try testing.expectEqual(@as(i64, 20), result);
}

test "min_lt_f64" {
    const data = [_]f64{ 1.5, 2.5, 3.5, 4.5 };
    const result = pichon_min_lt_f64(&data, data.len, 3.0);
    // min of {1.5, 2.5} = 1.5
    try testing.expectApproxEqAbs(@as(f64, 1.5), result, 0.001);
}

test "max_gt_f64" {
    const data = [_]f64{ 1.5, 2.5, 3.5, 4.5 };
    const result = pichon_max_gt_f64(&data, data.len, 2.0);
    // max of {2.5, 3.5, 4.5} = 4.5
    try testing.expectApproxEqAbs(@as(f64, 4.5), result, 0.001);
}

test "sum_lt_i64" {
    const data = [_]i64{ 10, 50, 30, 80, 20 };
    const result = pichon_sum_lt_i64(&data, data.len, 25);
    // 10 + 20 = 30
    try testing.expectEqual(@as(i64, 30), result);
}

test "sum_lt_f64" {
    const data = [_]f64{ 1.5, 2.5, 3.5, 4.5 };
    const result = pichon_sum_lt_f64(&data, data.len, 3.0);
    // 1.5 + 2.5 = 4.0
    try testing.expectApproxEqAbs(@as(f64, 4.0), result, 0.001);
}

test "count_gt_i64" {
    const data = [_]i64{ 10, 50, 30, 80, 20 };
    const count = pichon_count_gt_i64(&data, data.len, 25);
    // {50, 30, 80} = 3
    try testing.expectEqual(@as(usize, 3), count);
}

test "count_lt_i32" {
    const data = [_]i32{ 10, 50, 30, 80, 20 };
    const count = pichon_count_lt_i32(&data, data.len, 25);
    // {10, 20} = 2
    try testing.expectEqual(@as(usize, 2), count);
}

test "count_lt_i64" {
    const data = [_]i64{ 10, 50, 30, 80, 20 };
    const count = pichon_count_lt_i64(&data, data.len, 25);
    // {10, 20} = 2
    try testing.expectEqual(@as(usize, 2), count);
}

test "count_lt_f64" {
    const data = [_]f64{ 1.5, 2.5, 3.5, 4.5 };
    const count = pichon_count_lt_f64(&data, data.len, 3.0);
    // {1.5, 2.5} = 2
    try testing.expectEqual(@as(usize, 2), count);
}
