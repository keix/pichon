// =============================================================================
// Behavior: Reduce
// =============================================================================
// Purpose: Verify correctness of reduce operations
//
// Coverage:
//   - sum: i32, i64, f64 (with overflow safety via widening)
//   - min: i32, i64, f64
//   - max: i32, i64, f64
//
// Run: zig build test
// =============================================================================

const std = @import("std");
const testing = std.testing;
const pichon = @import("pichon");
const reduce = pichon.reduce;

// -----------------------------------------------------------------------------
// sum
// -----------------------------------------------------------------------------

test "sum_i32" {
    const data = [_]i32{ 1, 2, 3, 4, 5 };
    const result = reduce.pichon_sum_i32(&data, data.len);
    try testing.expectEqual(@as(i64, 15), result);
}

test "sum_i32 overflow safety" {
    const data = [_]i32{ 2147483647, 1 };
    const result = reduce.pichon_sum_i32(&data, data.len);
    try testing.expectEqual(@as(i64, 2147483648), result);
}

test "sum_i64" {
    const data = [_]i64{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
    const result = reduce.pichon_sum_i64(&data, data.len);
    try testing.expectEqual(@as(i64, 55), result);
}

test "sum_f64" {
    const data = [_]f64{ 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0 };
    const result = reduce.pichon_sum_f64(&data, data.len);
    try testing.expectApproxEqAbs(@as(f64, 55.0), result, 0.001);
}

// -----------------------------------------------------------------------------
// min
// -----------------------------------------------------------------------------

test "min_i32" {
    const data = [_]i32{ 5, 2, 8, 1, 9 };
    const result = reduce.pichon_min_i32(&data, data.len);
    try testing.expectEqual(@as(i32, 1), result);
}

test "min_i64" {
    const data = [_]i64{ 5, 2, 8, 1, 9 };
    const result = reduce.pichon_min_i64(&data, data.len);
    try testing.expectEqual(@as(i64, 1), result);
}

test "min_f64" {
    const data = [_]f64{ 5.5, 2.2, 8.8, 1.1, 9.9 };
    const result = reduce.pichon_min_f64(&data, data.len);
    try testing.expectApproxEqAbs(@as(f64, 1.1), result, 0.001);
}

// -----------------------------------------------------------------------------
// max
// -----------------------------------------------------------------------------

test "max_i32" {
    const data = [_]i32{ 5, 2, 8, 1, 9 };
    const result = reduce.pichon_max_i32(&data, data.len);
    try testing.expectEqual(@as(i32, 9), result);
}

test "max_i64" {
    const data = [_]i64{ 5, 2, 8, 1, 9 };
    const result = reduce.pichon_max_i64(&data, data.len);
    try testing.expectEqual(@as(i64, 9), result);
}

test "max_f64" {
    const data = [_]f64{ 5.5, 2.2, 8.8, 1.1, 9.9 };
    const result = reduce.pichon_max_f64(&data, data.len);
    try testing.expectApproxEqAbs(@as(f64, 9.9), result, 0.001);
}

// -----------------------------------------------------------------------------
// Edge cases: empty array
// -----------------------------------------------------------------------------

test "sum_i32 empty" {
    const data = [_]i32{};
    const result = reduce.pichon_sum_i32(&data, 0);
    try testing.expectEqual(@as(i64, 0), result);
}

test "min_i32 empty" {
    const data = [_]i32{};
    const result = reduce.pichon_min_i32(&data, 0);
    try testing.expectEqual(@as(i32, 0), result);
}

test "max_i32 empty" {
    const data = [_]i32{};
    const result = reduce.pichon_max_i32(&data, 0);
    try testing.expectEqual(@as(i32, 0), result);
}

// -----------------------------------------------------------------------------
// Edge cases: single element
// -----------------------------------------------------------------------------

test "sum_i32 single" {
    const data = [_]i32{42};
    const result = reduce.pichon_sum_i32(&data, 1);
    try testing.expectEqual(@as(i64, 42), result);
}

test "min_i32 single" {
    const data = [_]i32{42};
    const result = reduce.pichon_min_i32(&data, 1);
    try testing.expectEqual(@as(i32, 42), result);
}

test "max_i32 single" {
    const data = [_]i32{42};
    const result = reduce.pichon_max_i32(&data, 1);
    try testing.expectEqual(@as(i32, 42), result);
}

// -----------------------------------------------------------------------------
// Edge cases: negative values
// -----------------------------------------------------------------------------

test "min_i64 negative" {
    const data = [_]i64{ -5, -2, -8, -1, -9 };
    const result = reduce.pichon_min_i64(&data, data.len);
    try testing.expectEqual(@as(i64, -9), result);
}

test "max_i64 negative" {
    const data = [_]i64{ -5, -2, -8, -1, -9 };
    const result = reduce.pichon_max_i64(&data, data.len);
    try testing.expectEqual(@as(i64, -1), result);
}

test "min_f64 negative" {
    const data = [_]f64{ -5.5, -2.2, -8.8, -1.1, -9.9 };
    const result = reduce.pichon_min_f64(&data, data.len);
    try testing.expectApproxEqAbs(@as(f64, -9.9), result, 0.001);
}

test "max_f64 negative" {
    const data = [_]f64{ -5.5, -2.2, -8.8, -1.1, -9.9 };
    const result = reduce.pichon_max_f64(&data, data.len);
    try testing.expectApproxEqAbs(@as(f64, -1.1), result, 0.001);
}
