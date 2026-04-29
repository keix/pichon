// =============================================================================
// Behavior: Filter
// =============================================================================
// Purpose: Verify correctness of filter operations
//
// Coverage:
//   - filter_gt: i32, i64, f64 (elements > threshold)
//   - filter_lt: i32, i64, f64 (elements < threshold)
//
// Run: zig build test
// =============================================================================

const std = @import("std");
const testing = std.testing;
const pichon = @import("pichon");
const filter = pichon.filter;

// -----------------------------------------------------------------------------
// filter_gt i32
// -----------------------------------------------------------------------------

test "filter_gt_i32" {
    const data = [_]i32{ 10, 50, 30, 80, 20 };
    var output: [5]i32 = undefined;

    const count = filter.pichon_filter_gt_i32(&data, data.len, &output, 25);

    try testing.expectEqual(@as(usize, 3), count);
    try testing.expectEqual(@as(i32, 50), output[0]);
    try testing.expectEqual(@as(i32, 30), output[1]);
    try testing.expectEqual(@as(i32, 80), output[2]);
}

test "filter_gt_i32 none match" {
    const data = [_]i32{ 1, 2, 3 };
    var output: [3]i32 = undefined;

    const count = filter.pichon_filter_gt_i32(&data, data.len, &output, 100);

    try testing.expectEqual(@as(usize, 0), count);
}

test "filter_gt_i32 all match" {
    const data = [_]i32{ 10, 20, 30 };
    var output: [3]i32 = undefined;

    const count = filter.pichon_filter_gt_i32(&data, data.len, &output, 0);

    try testing.expectEqual(@as(usize, 3), count);
}

// -----------------------------------------------------------------------------
// filter_lt i32
// -----------------------------------------------------------------------------

test "filter_lt_i32" {
    const data = [_]i32{ 10, 50, 30, 80, 20 };
    var output: [5]i32 = undefined;

    const count = filter.pichon_filter_lt_i32(&data, data.len, &output, 25);

    try testing.expectEqual(@as(usize, 2), count);
    try testing.expectEqual(@as(i32, 10), output[0]);
    try testing.expectEqual(@as(i32, 20), output[1]);
}

test "filter_lt_i32 none match" {
    const data = [_]i32{ 100, 200, 300 };
    var output: [3]i32 = undefined;

    const count = filter.pichon_filter_lt_i32(&data, data.len, &output, 50);

    try testing.expectEqual(@as(usize, 0), count);
}

test "filter_lt_i32 all match" {
    const data = [_]i32{ 10, 20, 30 };
    var output: [3]i32 = undefined;

    const count = filter.pichon_filter_lt_i32(&data, data.len, &output, 100);

    try testing.expectEqual(@as(usize, 3), count);
}

// -----------------------------------------------------------------------------
// filter_gt i64
// -----------------------------------------------------------------------------

test "filter_gt_i64" {
    const data = [_]i64{ 10, 50, 30, 80, 20 };
    var output: [5]i64 = undefined;

    const count = filter.pichon_filter_gt_i64(&data, data.len, &output, 25);

    try testing.expectEqual(@as(usize, 3), count);
    try testing.expectEqual(@as(i64, 50), output[0]);
    try testing.expectEqual(@as(i64, 30), output[1]);
    try testing.expectEqual(@as(i64, 80), output[2]);
}

test "filter_gt_i64 none match" {
    const data = [_]i64{ 1, 2, 3 };
    var output: [3]i64 = undefined;

    const count = filter.pichon_filter_gt_i64(&data, data.len, &output, 100);

    try testing.expectEqual(@as(usize, 0), count);
}

test "filter_gt_i64 all match" {
    const data = [_]i64{ 10, 20, 30 };
    var output: [3]i64 = undefined;

    const count = filter.pichon_filter_gt_i64(&data, data.len, &output, 0);

    try testing.expectEqual(@as(usize, 3), count);
}

// -----------------------------------------------------------------------------
// filter_lt i64
// -----------------------------------------------------------------------------

test "filter_lt_i64" {
    const data = [_]i64{ 10, 50, 30, 80, 20 };
    var output: [5]i64 = undefined;

    const count = filter.pichon_filter_lt_i64(&data, data.len, &output, 25);

    try testing.expectEqual(@as(usize, 2), count);
    try testing.expectEqual(@as(i64, 10), output[0]);
    try testing.expectEqual(@as(i64, 20), output[1]);
}

test "filter_lt_i64 none match" {
    const data = [_]i64{ 100, 200, 300 };
    var output: [3]i64 = undefined;

    const count = filter.pichon_filter_lt_i64(&data, data.len, &output, 50);

    try testing.expectEqual(@as(usize, 0), count);
}

test "filter_lt_i64 all match" {
    const data = [_]i64{ 10, 20, 30 };
    var output: [3]i64 = undefined;

    const count = filter.pichon_filter_lt_i64(&data, data.len, &output, 100);

    try testing.expectEqual(@as(usize, 3), count);
}

// -----------------------------------------------------------------------------
// filter_gt f64
// -----------------------------------------------------------------------------

test "filter_gt_f64" {
    const data = [_]f64{ 10.5, 50.5, 30.5, 80.5, 20.5 };
    var output: [5]f64 = undefined;

    const count = filter.pichon_filter_gt_f64(&data, data.len, &output, 25.0);

    try testing.expectEqual(@as(usize, 3), count);
    try testing.expectApproxEqAbs(@as(f64, 50.5), output[0], 0.001);
    try testing.expectApproxEqAbs(@as(f64, 30.5), output[1], 0.001);
    try testing.expectApproxEqAbs(@as(f64, 80.5), output[2], 0.001);
}

test "filter_gt_f64 none match" {
    const data = [_]f64{ 1.0, 2.0, 3.0 };
    var output: [3]f64 = undefined;

    const count = filter.pichon_filter_gt_f64(&data, data.len, &output, 100.0);

    try testing.expectEqual(@as(usize, 0), count);
}

test "filter_gt_f64 all match" {
    const data = [_]f64{ 10.0, 20.0, 30.0 };
    var output: [3]f64 = undefined;

    const count = filter.pichon_filter_gt_f64(&data, data.len, &output, 0.0);

    try testing.expectEqual(@as(usize, 3), count);
}

// -----------------------------------------------------------------------------
// filter_lt f64
// -----------------------------------------------------------------------------

test "filter_lt_f64" {
    const data = [_]f64{ 10.5, 50.5, 30.5, 80.5, 20.5 };
    var output: [5]f64 = undefined;

    const count = filter.pichon_filter_lt_f64(&data, data.len, &output, 25.0);

    try testing.expectEqual(@as(usize, 2), count);
    try testing.expectApproxEqAbs(@as(f64, 10.5), output[0], 0.001);
    try testing.expectApproxEqAbs(@as(f64, 20.5), output[1], 0.001);
}

test "filter_lt_f64 none match" {
    const data = [_]f64{ 100.0, 200.0, 300.0 };
    var output: [3]f64 = undefined;

    const count = filter.pichon_filter_lt_f64(&data, data.len, &output, 50.0);

    try testing.expectEqual(@as(usize, 0), count);
}

test "filter_lt_f64 all match" {
    const data = [_]f64{ 10.0, 20.0, 30.0 };
    var output: [3]f64 = undefined;

    const count = filter.pichon_filter_lt_f64(&data, data.len, &output, 100.0);

    try testing.expectEqual(@as(usize, 3), count);
}

// -----------------------------------------------------------------------------
// Edge cases: empty array
// -----------------------------------------------------------------------------

test "filter_gt_i32 empty" {
    const data = [_]i32{};
    var output: [0]i32 = undefined;

    const count = filter.pichon_filter_gt_i32(&data, 0, &output, 0);

    try testing.expectEqual(@as(usize, 0), count);
}

test "filter_lt_i32 empty" {
    const data = [_]i32{};
    var output: [0]i32 = undefined;

    const count = filter.pichon_filter_lt_i32(&data, 0, &output, 0);

    try testing.expectEqual(@as(usize, 0), count);
}

// -----------------------------------------------------------------------------
// Edge cases: single element
// -----------------------------------------------------------------------------

test "filter_gt_i32 single match" {
    const data = [_]i32{50};
    var output: [1]i32 = undefined;

    const count = filter.pichon_filter_gt_i32(&data, 1, &output, 25);

    try testing.expectEqual(@as(usize, 1), count);
    try testing.expectEqual(@as(i32, 50), output[0]);
}

test "filter_gt_i32 single no match" {
    const data = [_]i32{10};
    var output: [1]i32 = undefined;

    const count = filter.pichon_filter_gt_i32(&data, 1, &output, 25);

    try testing.expectEqual(@as(usize, 0), count);
}
