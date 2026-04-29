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
