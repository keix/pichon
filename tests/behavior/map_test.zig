// =============================================================================
// Behavior: Map
// =============================================================================
// Purpose: Verify correctness of element-wise map operations
//
// Coverage:
//   - Binary: add, sub, mul (i32, i64, f64)
//   - Scalar: add_s, sub_s, mul_s (i32, i64, f64)
//
// Run: zig build test
// =============================================================================

const std = @import("std");
const testing = std.testing;
const pichon = @import("pichon");
const map = pichon.map;

// -----------------------------------------------------------------------------
// Binary add
// -----------------------------------------------------------------------------

test "add_i32" {
    const a = [_]i32{ 1, 2, 3 };
    const b = [_]i32{ 10, 20, 30 };
    var out: [3]i32 = undefined;

    map.pichon_add_i32(&a, &b, 3, &out);

    try testing.expectEqual(@as(i32, 11), out[0]);
    try testing.expectEqual(@as(i32, 22), out[1]);
    try testing.expectEqual(@as(i32, 33), out[2]);
}

test "add_i64" {
    const a = [_]i64{ 1, 2, 3 };
    const b = [_]i64{ 10, 20, 30 };
    var out: [3]i64 = undefined;

    map.pichon_add_i64(&a, &b, 3, &out);

    try testing.expectEqual(@as(i64, 11), out[0]);
    try testing.expectEqual(@as(i64, 22), out[1]);
    try testing.expectEqual(@as(i64, 33), out[2]);
}

test "add_f64" {
    const a = [_]f64{ 1.1, 2.2, 3.3 };
    const b = [_]f64{ 10.0, 20.0, 30.0 };
    var out: [3]f64 = undefined;

    map.pichon_add_f64(&a, &b, 3, &out);

    try testing.expectApproxEqAbs(@as(f64, 11.1), out[0], 0.001);
    try testing.expectApproxEqAbs(@as(f64, 22.2), out[1], 0.001);
    try testing.expectApproxEqAbs(@as(f64, 33.3), out[2], 0.001);
}

// -----------------------------------------------------------------------------
// Binary sub
// -----------------------------------------------------------------------------

test "sub_i32" {
    const a = [_]i32{ 100, 200, 300 };
    const b = [_]i32{ 10, 20, 30 };
    var out: [3]i32 = undefined;

    map.pichon_sub_i32(&a, &b, 3, &out);

    try testing.expectEqual(@as(i32, 90), out[0]);
    try testing.expectEqual(@as(i32, 180), out[1]);
    try testing.expectEqual(@as(i32, 270), out[2]);
}

test "sub_i64" {
    const a = [_]i64{ 100, 200, 300 };
    const b = [_]i64{ 10, 20, 30 };
    var out: [3]i64 = undefined;

    map.pichon_sub_i64(&a, &b, 3, &out);

    try testing.expectEqual(@as(i64, 90), out[0]);
    try testing.expectEqual(@as(i64, 180), out[1]);
    try testing.expectEqual(@as(i64, 270), out[2]);
}

test "sub_f64" {
    const a = [_]f64{ 100.5, 200.5, 300.5 };
    const b = [_]f64{ 10.0, 20.0, 30.0 };
    var out: [3]f64 = undefined;

    map.pichon_sub_f64(&a, &b, 3, &out);

    try testing.expectApproxEqAbs(@as(f64, 90.5), out[0], 0.001);
    try testing.expectApproxEqAbs(@as(f64, 180.5), out[1], 0.001);
    try testing.expectApproxEqAbs(@as(f64, 270.5), out[2], 0.001);
}

// -----------------------------------------------------------------------------
// Binary mul
// -----------------------------------------------------------------------------

test "mul_i32" {
    const a = [_]i32{ 2, 3, 4 };
    const b = [_]i32{ 10, 10, 10 };
    var out: [3]i32 = undefined;

    map.pichon_mul_i32(&a, &b, 3, &out);

    try testing.expectEqual(@as(i32, 20), out[0]);
    try testing.expectEqual(@as(i32, 30), out[1]);
    try testing.expectEqual(@as(i32, 40), out[2]);
}

test "mul_i64" {
    const a = [_]i64{ 2, 3, 4 };
    const b = [_]i64{ 10, 10, 10 };
    var out: [3]i64 = undefined;

    map.pichon_mul_i64(&a, &b, 3, &out);

    try testing.expectEqual(@as(i64, 20), out[0]);
    try testing.expectEqual(@as(i64, 30), out[1]);
    try testing.expectEqual(@as(i64, 40), out[2]);
}

test "mul_f64" {
    const a = [_]f64{ 2.0, 3.0, 4.0 };
    const b = [_]f64{ 1.5, 1.5, 1.5 };
    var out: [3]f64 = undefined;

    map.pichon_mul_f64(&a, &b, 3, &out);

    try testing.expectApproxEqAbs(@as(f64, 3.0), out[0], 0.001);
    try testing.expectApproxEqAbs(@as(f64, 4.5), out[1], 0.001);
    try testing.expectApproxEqAbs(@as(f64, 6.0), out[2], 0.001);
}

// -----------------------------------------------------------------------------
// Scalar add
// -----------------------------------------------------------------------------

test "add_s_i32" {
    const a = [_]i32{ 1, 2, 3 };
    var out: [3]i32 = undefined;

    map.pichon_add_s_i32(&a, 3, 100, &out);

    try testing.expectEqual(@as(i32, 101), out[0]);
    try testing.expectEqual(@as(i32, 102), out[1]);
    try testing.expectEqual(@as(i32, 103), out[2]);
}

test "add_s_i64" {
    const a = [_]i64{ 1, 2, 3 };
    var out: [3]i64 = undefined;

    map.pichon_add_s_i64(&a, 3, 100, &out);

    try testing.expectEqual(@as(i64, 101), out[0]);
    try testing.expectEqual(@as(i64, 102), out[1]);
    try testing.expectEqual(@as(i64, 103), out[2]);
}

test "add_s_f64" {
    const a = [_]f64{ 1.0, 2.0, 3.0 };
    var out: [3]f64 = undefined;

    map.pichon_add_s_f64(&a, 3, 0.5, &out);

    try testing.expectApproxEqAbs(@as(f64, 1.5), out[0], 0.001);
    try testing.expectApproxEqAbs(@as(f64, 2.5), out[1], 0.001);
    try testing.expectApproxEqAbs(@as(f64, 3.5), out[2], 0.001);
}

// -----------------------------------------------------------------------------
// Scalar sub
// -----------------------------------------------------------------------------

test "sub_s_i32" {
    const a = [_]i32{ 100, 200, 300 };
    var out: [3]i32 = undefined;

    map.pichon_sub_s_i32(&a, 3, 10, &out);

    try testing.expectEqual(@as(i32, 90), out[0]);
    try testing.expectEqual(@as(i32, 190), out[1]);
    try testing.expectEqual(@as(i32, 290), out[2]);
}

test "sub_s_i64" {
    const a = [_]i64{ 100, 200, 300 };
    var out: [3]i64 = undefined;

    map.pichon_sub_s_i64(&a, 3, 10, &out);

    try testing.expectEqual(@as(i64, 90), out[0]);
    try testing.expectEqual(@as(i64, 190), out[1]);
    try testing.expectEqual(@as(i64, 290), out[2]);
}

test "sub_s_f64" {
    const a = [_]f64{ 100.0, 200.0, 300.0 };
    var out: [3]f64 = undefined;

    map.pichon_sub_s_f64(&a, 3, 10.5, &out);

    try testing.expectApproxEqAbs(@as(f64, 89.5), out[0], 0.001);
    try testing.expectApproxEqAbs(@as(f64, 189.5), out[1], 0.001);
    try testing.expectApproxEqAbs(@as(f64, 289.5), out[2], 0.001);
}

// -----------------------------------------------------------------------------
// Scalar mul
// -----------------------------------------------------------------------------

test "mul_s_i32" {
    const a = [_]i32{ 2, 3, 4 };
    var out: [3]i32 = undefined;

    map.pichon_mul_s_i32(&a, 3, 10, &out);

    try testing.expectEqual(@as(i32, 20), out[0]);
    try testing.expectEqual(@as(i32, 30), out[1]);
    try testing.expectEqual(@as(i32, 40), out[2]);
}

test "mul_s_i64" {
    const a = [_]i64{ 2, 3, 4 };
    var out: [3]i64 = undefined;

    map.pichon_mul_s_i64(&a, 3, 10, &out);

    try testing.expectEqual(@as(i64, 20), out[0]);
    try testing.expectEqual(@as(i64, 30), out[1]);
    try testing.expectEqual(@as(i64, 40), out[2]);
}

test "mul_s_f64" {
    const a = [_]f64{ 100.0, 200.0, 300.0 };
    var out: [3]f64 = undefined;

    map.pichon_mul_s_f64(&a, 3, 1.1, &out);

    try testing.expectApproxEqAbs(@as(f64, 110.0), out[0], 0.001);
    try testing.expectApproxEqAbs(@as(f64, 220.0), out[1], 0.001);
    try testing.expectApproxEqAbs(@as(f64, 330.0), out[2], 0.001);
}

// -----------------------------------------------------------------------------
// Edge cases: empty array
// -----------------------------------------------------------------------------

test "add_i32 empty" {
    const a = [_]i32{};
    const b = [_]i32{};
    var out: [0]i32 = undefined;

    map.pichon_add_i32(&a, &b, 0, &out);
    // No crash = pass
}

test "add_s_i32 empty" {
    const a = [_]i32{};
    var out: [0]i32 = undefined;

    map.pichon_add_s_i32(&a, 0, 100, &out);
    // No crash = pass
}

// -----------------------------------------------------------------------------
// Edge cases: single element
// -----------------------------------------------------------------------------

test "add_i32 single" {
    const a = [_]i32{5};
    const b = [_]i32{10};
    var out: [1]i32 = undefined;

    map.pichon_add_i32(&a, &b, 1, &out);

    try testing.expectEqual(@as(i32, 15), out[0]);
}

test "add_s_i32 single" {
    const a = [_]i32{5};
    var out: [1]i32 = undefined;

    map.pichon_add_s_i32(&a, 1, 10, &out);

    try testing.expectEqual(@as(i32, 15), out[0]);
}
