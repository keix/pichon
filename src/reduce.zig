// =============================================================================
// Reduce operations
// =============================================================================
// Type-specific exports for C ABI, backed by unified SIMD primitives.
// =============================================================================

const simd = @import("simd.zig");

// -----------------------------------------------------------------------------
// Scalar implementations for standalone min/max
// (Fused min/max use SIMD in simd.zig)
// -----------------------------------------------------------------------------

fn minGeneric(comptime T: type, ptr: [*]const T, len: usize) T {
    if (len == 0) return 0;

    var result: T = ptr[0];
    for (ptr[1..len]) |v| {
        if (v < result) result = v;
    }
    return result;
}

fn maxGeneric(comptime T: type, ptr: [*]const T, len: usize) T {
    if (len == 0) return 0;

    var result: T = ptr[0];
    for (ptr[1..len]) |v| {
        if (v > result) result = v;
    }
    return result;
}

// -----------------------------------------------------------------------------
// Exports: sum (SIMD)
// -----------------------------------------------------------------------------

pub export fn pichon_sum_i32(ptr: [*]const i32, len: usize) i64 {
    return simd.sumWiden(i32, i64, ptr, len);
}

pub export fn pichon_sum_i64(ptr: [*]const i64, len: usize) i64 {
    return simd.sum(i64, ptr, len);
}

pub export fn pichon_sum_f64(ptr: [*]const f64, len: usize) f64 {
    return simd.sum(f64, ptr, len);
}

// -----------------------------------------------------------------------------
// Exports: min (scalar)
// -----------------------------------------------------------------------------

pub export fn pichon_min_i32(ptr: [*]const i32, len: usize) i32 {
    return minGeneric(i32, ptr, len);
}

pub export fn pichon_min_i64(ptr: [*]const i64, len: usize) i64 {
    return minGeneric(i64, ptr, len);
}

pub export fn pichon_min_f64(ptr: [*]const f64, len: usize) f64 {
    return minGeneric(f64, ptr, len);
}

// -----------------------------------------------------------------------------
// Exports: max (scalar)
// -----------------------------------------------------------------------------

pub export fn pichon_max_i32(ptr: [*]const i32, len: usize) i32 {
    return maxGeneric(i32, ptr, len);
}

pub export fn pichon_max_i64(ptr: [*]const i64, len: usize) i64 {
    return maxGeneric(i64, ptr, len);
}

pub export fn pichon_max_f64(ptr: [*]const f64, len: usize) f64 {
    return maxGeneric(f64, ptr, len);
}

// -----------------------------------------------------------------------------
// Tests
// -----------------------------------------------------------------------------

const testing = @import("std").testing;

test "sum_i32" {
    const data = [_]i32{ 1, 2, 3, 4, 5 };
    const result = pichon_sum_i32(&data, data.len);
    try testing.expectEqual(@as(i64, 15), result);
}

test "sum_i32 overflow safety" {
    const data = [_]i32{ 2147483647, 1 };
    const result = pichon_sum_i32(&data, data.len);
    try testing.expectEqual(@as(i64, 2147483648), result);
}

test "sum_i64" {
    const data = [_]i64{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
    const result = pichon_sum_i64(&data, data.len);
    try testing.expectEqual(@as(i64, 55), result);
}

test "sum_f64" {
    const data = [_]f64{ 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0 };
    const result = pichon_sum_f64(&data, data.len);
    try testing.expectApproxEqAbs(@as(f64, 55.0), result, 0.001);
}

test "min_i32" {
    const data = [_]i32{ 5, 2, 8, 1, 9 };
    const result = pichon_min_i32(&data, data.len);
    try testing.expectEqual(@as(i32, 1), result);
}

test "max_i32" {
    const data = [_]i32{ 5, 2, 8, 1, 9 };
    const result = pichon_max_i32(&data, data.len);
    try testing.expectEqual(@as(i32, 9), result);
}

test "min_i64" {
    const data = [_]i64{ 5, 2, 8, 1, 9 };
    const result = pichon_min_i64(&data, data.len);
    try testing.expectEqual(@as(i64, 1), result);
}

test "min_f64" {
    const data = [_]f64{ 5.5, 2.2, 8.8, 1.1, 9.9 };
    const result = pichon_min_f64(&data, data.len);
    try testing.expectApproxEqAbs(@as(f64, 1.1), result, 0.001);
}

test "max_i64" {
    const data = [_]i64{ 5, 2, 8, 1, 9 };
    const result = pichon_max_i64(&data, data.len);
    try testing.expectEqual(@as(i64, 9), result);
}

test "max_f64" {
    const data = [_]f64{ 5.5, 2.2, 8.8, 1.1, 9.9 };
    const result = pichon_max_f64(&data, data.len);
    try testing.expectApproxEqAbs(@as(f64, 9.9), result, 0.001);
}

// Edge cases: empty array
test "sum_i32 empty" {
    const data = [_]i32{};
    const result = pichon_sum_i32(&data, 0);
    try testing.expectEqual(@as(i64, 0), result);
}

test "min_i32 empty" {
    const data = [_]i32{};
    const result = pichon_min_i32(&data, 0);
    try testing.expectEqual(@as(i32, 0), result);
}

test "max_i32 empty" {
    const data = [_]i32{};
    const result = pichon_max_i32(&data, 0);
    try testing.expectEqual(@as(i32, 0), result);
}

// Edge cases: single element
test "sum_i32 single" {
    const data = [_]i32{42};
    const result = pichon_sum_i32(&data, 1);
    try testing.expectEqual(@as(i64, 42), result);
}

test "min_i32 single" {
    const data = [_]i32{42};
    const result = pichon_min_i32(&data, 1);
    try testing.expectEqual(@as(i32, 42), result);
}

test "max_i32 single" {
    const data = [_]i32{42};
    const result = pichon_max_i32(&data, 1);
    try testing.expectEqual(@as(i32, 42), result);
}

// Edge cases: negative values
test "min_i64 negative" {
    const data = [_]i64{ -5, -2, -8, -1, -9 };
    const result = pichon_min_i64(&data, data.len);
    try testing.expectEqual(@as(i64, -9), result);
}

test "max_i64 negative" {
    const data = [_]i64{ -5, -2, -8, -1, -9 };
    const result = pichon_max_i64(&data, data.len);
    try testing.expectEqual(@as(i64, -1), result);
}

test "min_f64 negative" {
    const data = [_]f64{ -5.5, -2.2, -8.8, -1.1, -9.9 };
    const result = pichon_min_f64(&data, data.len);
    try testing.expectApproxEqAbs(@as(f64, -9.9), result, 0.001);
}

test "max_f64 negative" {
    const data = [_]f64{ -5.5, -2.2, -8.8, -1.1, -9.9 };
    const result = pichon_max_f64(&data, data.len);
    try testing.expectApproxEqAbs(@as(f64, -1.1), result, 0.001);
}
