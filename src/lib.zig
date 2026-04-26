// =============================================================================
// Pichon: Columnar execution engine
// =============================================================================
// Entry point. Re-exports all public symbols.
// =============================================================================

pub const reduce = @import("reduce.zig");
pub const filter = @import("filter.zig");
pub const layout = @import("layout.zig");
pub const err = @import("error.zig");

// Force symbols to be included in the library
comptime {
    // reduce: sum
    _ = &reduce.pichon_sum_i32;
    _ = &reduce.pichon_sum_i64;
    _ = &reduce.pichon_sum_f64;

    // reduce: min
    _ = &reduce.pichon_min_i32;
    _ = &reduce.pichon_min_i64;
    _ = &reduce.pichon_min_f64;

    // reduce: max
    _ = &reduce.pichon_max_i32;
    _ = &reduce.pichon_max_i64;
    _ = &reduce.pichon_max_f64;

    // filter
    _ = &filter.pichon_filter_gt_i32;
    _ = &filter.pichon_filter_gt_i64;
    _ = &filter.pichon_filter_gt_f64;
}

// Tests
test {
    @import("std").testing.refAllDecls(@This());
}
