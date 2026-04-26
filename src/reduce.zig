// =============================================================================
// Reduce operations
// =============================================================================
// Generic implementations + type-specific exports for C ABI.
// =============================================================================

// -----------------------------------------------------------------------------
// Generic implementations (internal)
// -----------------------------------------------------------------------------

fn sumGeneric(comptime T: type, comptime R: type, ptr: [*]const T, len: usize) R {
    if (len == 0) return 0;

    var total: R = 0;
    for (ptr[0..len]) |v| {
        total += @as(R, v);
    }
    return total;
}

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
// Exports: sum
// -----------------------------------------------------------------------------

pub export fn pichon_sum_i32(ptr: [*]const i32, len: usize) i64 {
    return sumGeneric(i32, i64, ptr, len);
}

pub export fn pichon_sum_i64(ptr: [*]const i64, len: usize) i64 {
    return sumGeneric(i64, i64, ptr, len);
}

pub export fn pichon_sum_f64(ptr: [*]const f64, len: usize) f64 {
    return sumGeneric(f64, f64, ptr, len);
}

// -----------------------------------------------------------------------------
// Exports: min
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
// Exports: max
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
