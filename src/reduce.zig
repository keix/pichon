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
