// =============================================================================
// Filter operations
// =============================================================================
// Generic implementations + type-specific exports for C ABI.
// Caller provides output buffer. Returns count of matches.
// =============================================================================

// -----------------------------------------------------------------------------
// Generic implementations (internal)
// -----------------------------------------------------------------------------

fn filterGtGeneric(comptime T: type, in_ptr: [*]const T, len: usize, out_ptr: [*]T, threshold: T) usize {
    var out_index: usize = 0;

    for (in_ptr[0..len]) |v| {
        if (v > threshold) {
            out_ptr[out_index] = v;
            out_index += 1;
        }
    }

    return out_index;
}

// -----------------------------------------------------------------------------
// Exports: filter greater than
// -----------------------------------------------------------------------------

pub export fn pichon_filter_gt_i32(
    in_ptr: [*]const i32,
    len: usize,
    out_ptr: [*]i32,
    threshold: i32,
) usize {
    return filterGtGeneric(i32, in_ptr, len, out_ptr, threshold);
}

pub export fn pichon_filter_gt_i64(
    in_ptr: [*]const i64,
    len: usize,
    out_ptr: [*]i64,
    threshold: i64,
) usize {
    return filterGtGeneric(i64, in_ptr, len, out_ptr, threshold);
}

pub export fn pichon_filter_gt_f64(
    in_ptr: [*]const f64,
    len: usize,
    out_ptr: [*]f64,
    threshold: f64,
) usize {
    return filterGtGeneric(f64, in_ptr, len, out_ptr, threshold);
}

// -----------------------------------------------------------------------------
// Tests
// -----------------------------------------------------------------------------

const testing = @import("std").testing;

test "filter_gt_i32" {
    const data = [_]i32{ 10, 50, 30, 80, 20 };
    var output: [5]i32 = undefined;

    const count = pichon_filter_gt_i32(&data, data.len, &output, 25);

    try testing.expectEqual(@as(usize, 3), count);
    try testing.expectEqual(@as(i32, 50), output[0]);
    try testing.expectEqual(@as(i32, 30), output[1]);
    try testing.expectEqual(@as(i32, 80), output[2]);
}

test "filter_gt_i32 none match" {
    const data = [_]i32{ 1, 2, 3 };
    var output: [3]i32 = undefined;

    const count = pichon_filter_gt_i32(&data, data.len, &output, 100);

    try testing.expectEqual(@as(usize, 0), count);
}

test "filter_gt_i32 all match" {
    const data = [_]i32{ 10, 20, 30 };
    var output: [3]i32 = undefined;

    const count = pichon_filter_gt_i32(&data, data.len, &output, 0);

    try testing.expectEqual(@as(usize, 3), count);
}
