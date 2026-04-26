// =============================================================================
// Fusion operations
// =============================================================================
// Combined filter + reduce in a single pass.
// =============================================================================

// -----------------------------------------------------------------------------
// Generic implementations (internal)
// -----------------------------------------------------------------------------

fn sumGtGeneric(comptime T: type, comptime R: type, ptr: [*]const T, len: usize, threshold: T) R {
    var total: R = 0;
    for (ptr[0..len]) |v| {
        if (v > threshold) {
            total += @as(R, v);
        }
    }
    return total;
}

fn sumLtGeneric(comptime T: type, comptime R: type, ptr: [*]const T, len: usize, threshold: T) R {
    var total: R = 0;
    for (ptr[0..len]) |v| {
        if (v < threshold) {
            total += @as(R, v);
        }
    }
    return total;
}

fn countGtGeneric(comptime T: type, ptr: [*]const T, len: usize, threshold: T) usize {
    var count: usize = 0;
    for (ptr[0..len]) |v| {
        if (v > threshold) {
            count += 1;
        }
    }
    return count;
}

fn countLtGeneric(comptime T: type, ptr: [*]const T, len: usize, threshold: T) usize {
    var count: usize = 0;
    for (ptr[0..len]) |v| {
        if (v < threshold) {
            count += 1;
        }
    }
    return count;
}

// -----------------------------------------------------------------------------
// Exports: sum_gt (filter > threshold, then sum)
// -----------------------------------------------------------------------------

pub export fn pichon_sum_gt_i32(ptr: [*]const i32, len: usize, threshold: i32) i64 {
    return sumGtGeneric(i32, i64, ptr, len, threshold);
}

pub export fn pichon_sum_gt_i64(ptr: [*]const i64, len: usize, threshold: i64) i64 {
    return sumGtGeneric(i64, i64, ptr, len, threshold);
}

pub export fn pichon_sum_gt_f64(ptr: [*]const f64, len: usize, threshold: f64) f64 {
    return sumGtGeneric(f64, f64, ptr, len, threshold);
}

// -----------------------------------------------------------------------------
// Exports: sum_lt (filter < threshold, then sum)
// -----------------------------------------------------------------------------

pub export fn pichon_sum_lt_i32(ptr: [*]const i32, len: usize, threshold: i32) i64 {
    return sumLtGeneric(i32, i64, ptr, len, threshold);
}

pub export fn pichon_sum_lt_i64(ptr: [*]const i64, len: usize, threshold: i64) i64 {
    return sumLtGeneric(i64, i64, ptr, len, threshold);
}

pub export fn pichon_sum_lt_f64(ptr: [*]const f64, len: usize, threshold: f64) f64 {
    return sumLtGeneric(f64, f64, ptr, len, threshold);
}

// -----------------------------------------------------------------------------
// Exports: count_gt (count where > threshold)
// -----------------------------------------------------------------------------

pub export fn pichon_count_gt_i32(ptr: [*]const i32, len: usize, threshold: i32) usize {
    return countGtGeneric(i32, ptr, len, threshold);
}

pub export fn pichon_count_gt_i64(ptr: [*]const i64, len: usize, threshold: i64) usize {
    return countGtGeneric(i64, ptr, len, threshold);
}

pub export fn pichon_count_gt_f64(ptr: [*]const f64, len: usize, threshold: f64) usize {
    return countGtGeneric(f64, ptr, len, threshold);
}

// -----------------------------------------------------------------------------
// Exports: count_lt (count where < threshold)
// -----------------------------------------------------------------------------

pub export fn pichon_count_lt_i32(ptr: [*]const i32, len: usize, threshold: i32) usize {
    return countLtGeneric(i32, ptr, len, threshold);
}

pub export fn pichon_count_lt_i64(ptr: [*]const i64, len: usize, threshold: i64) usize {
    return countLtGeneric(i64, ptr, len, threshold);
}

pub export fn pichon_count_lt_f64(ptr: [*]const f64, len: usize, threshold: f64) usize {
    return countLtGeneric(f64, ptr, len, threshold);
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

test "sum_gt_f64" {
    const data = [_]f64{ 1.5, 2.5, 3.5, 4.5 };
    const result = pichon_sum_gt_f64(&data, data.len, 2.0);
    // 2.5 + 3.5 + 4.5 = 10.5
    try testing.expectApproxEqAbs(@as(f64, 10.5), result, 0.001);
}
