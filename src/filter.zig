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

fn filterLtGeneric(comptime T: type, in_ptr: [*]const T, len: usize, out_ptr: [*]T, threshold: T) usize {
    var out_index: usize = 0;

    for (in_ptr[0..len]) |v| {
        if (v < threshold) {
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
// Exports: filter less than
// -----------------------------------------------------------------------------

pub export fn pichon_filter_lt_i32(
    in_ptr: [*]const i32,
    len: usize,
    out_ptr: [*]i32,
    threshold: i32,
) usize {
    return filterLtGeneric(i32, in_ptr, len, out_ptr, threshold);
}

pub export fn pichon_filter_lt_i64(
    in_ptr: [*]const i64,
    len: usize,
    out_ptr: [*]i64,
    threshold: i64,
) usize {
    return filterLtGeneric(i64, in_ptr, len, out_ptr, threshold);
}

pub export fn pichon_filter_lt_f64(
    in_ptr: [*]const f64,
    len: usize,
    out_ptr: [*]f64,
    threshold: f64,
) usize {
    return filterLtGeneric(f64, in_ptr, len, out_ptr, threshold);
}
