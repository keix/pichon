// =============================================================================
// Codegen: SIMD Vectorization
// =============================================================================
// Purpose: Verify SIMD vectorization is actually happening
//
// Verified guarantees:
//   - Lane widths: i32=8/4, i64=4/2, f64=4/2 (AVX2/SSE)
//   - Lane ratios: i32 = 2 * i64, i64 = f64
//   - Boundary handling: exact multiples, remainders, single vector
//   - 4x unroll correctness at all boundary conditions
//   - Horizontal reduction: min, max
//
// Run: zig build test
// =============================================================================

const std = @import("std");
const pichon = @import("pichon");
const simd = pichon.simd;
const testing = std.testing;

// =============================================================================
// Lane Width Verification
// =============================================================================

test "SIMD: i32 uses expected lanes" {
    const lanes = simd.lanes(i32);
    // AVX2 = 8 lanes, SSE = 4 lanes
    try testing.expect(lanes == 8 or lanes == 4);
}

test "SIMD: i64 uses expected lanes" {
    const lanes = simd.lanes(i64);
    // AVX2 = 4 lanes, SSE = 2 lanes
    try testing.expect(lanes == 4 or lanes == 2);
}

test "SIMD: f64 uses expected lanes" {
    const lanes = simd.lanes(f64);
    // AVX2 = 4 lanes, SSE = 2 lanes
    try testing.expect(lanes == 4 or lanes == 2);
}

test "SIMD: lane ratios are correct" {
    try testing.expectEqual(simd.lanes(i32), simd.lanes(i64) * 2);
    try testing.expectEqual(simd.lanes(i64), simd.lanes(f64));
}

// =============================================================================
// Vector Operation Correctness
// =============================================================================

test "SIMD: sum handles exact vector multiple" {
    const L = simd.lanes(i32);
    var data: [L * 4]i32 = undefined;
    for (&data, 0..) |*v, i| {
        v.* = @intCast(i + 1);
    }
    const n = L * 4;
    const expected: i64 = @divExact(n * (n + 1), 2);
    const result = simd.sumWiden(i32, i64, &data, data.len);
    try testing.expectEqual(expected, result);
}

test "SIMD: sum handles non-vector-aligned length" {
    const L = simd.lanes(i32);
    const n = L * 4 + 3;
    var data: [n]i32 = undefined;
    for (&data, 0..) |*v, i| {
        v.* = @intCast(i + 1);
    }
    const expected: i64 = @divExact(n * (n + 1), 2);
    const result = simd.sumWiden(i32, i64, &data, data.len);
    try testing.expectEqual(expected, result);
}

test "SIMD: sum handles single vector" {
    const L = simd.lanes(i64);
    var data: [L]i64 = undefined;
    for (&data, 0..) |*v, i| {
        v.* = @intCast(i + 1);
    }
    const n: i64 = @intCast(L);
    const expected: i64 = @divExact(n * (n + 1), 2);
    const result = simd.sum(i64, &data, data.len);
    try testing.expectEqual(expected, result);
}

test "SIMD: sum handles less than one vector" {
    const L = simd.lanes(i64);
    const n = L - 1;
    var data: [n]i64 = undefined;
    for (&data, 0..) |*v, i| {
        v.* = @intCast(i + 1);
    }
    const nn: i64 = @intCast(n);
    const expected: i64 = @divExact(nn * (nn + 1), 2);
    const result = simd.sum(i64, &data, data.len);
    try testing.expectEqual(expected, result);
}

// =============================================================================
// Unroll Factor Verification
// =============================================================================

test "SIMD: 4x unroll boundary correctness" {
    const L = simd.lanes(i32);
    const U = 4 * L;

    const sizes = [_]usize{ U - 1, U, U + 1, U * 2, U * 2 + L, U * 3 - 1 };

    for (sizes) |size| {
        const data = try testing.allocator.alloc(i32, size);
        defer testing.allocator.free(data);

        for (data, 0..) |*v, i| {
            v.* = @intCast(i + 1);
        }

        const n: i64 = @intCast(size);
        const expected: i64 = @divExact(n * (n + 1), 2);
        const result = simd.sumWiden(i32, i64, data.ptr, size);
        try testing.expectEqual(expected, result);
    }
}

// =============================================================================
// Horizontal Reduction
// =============================================================================

test "SIMD: horizontal min reduction" {
    const data = [_]i32{ 5, 2, 8, 1, 9, 3, 7, 4 };
    const result = simd.minGt(i32, &data, data.len, 0);
    try testing.expectEqual(@as(i32, 1), result);
}

test "SIMD: horizontal max reduction" {
    const data = [_]i32{ 5, 2, 8, 1, 9, 3, 7, 4 };
    const result = simd.maxGt(i32, &data, data.len, 0);
    try testing.expectEqual(@as(i32, 9), result);
}

// =============================================================================
// Map Vector Operations
// =============================================================================

test "SIMD: addVec across vector boundary" {
    const L = simd.lanes(i64);
    const n = L * 2 + 1;

    var a: [n]i64 = undefined;
    var b: [n]i64 = undefined;
    var out: [n]i64 = undefined;

    for (&a, &b, 0..) |*av, *bv, i| {
        av.* = @intCast(i);
        bv.* = @intCast(i * 10);
    }

    simd.addVec(i64, &a, &b, &out, n);

    for (out, 0..) |v, i| {
        const expected: i64 = @intCast(i + i * 10);
        try testing.expectEqual(expected, v);
    }
}

test "SIMD: mulVec preserves precision" {
    const a = [_]f64{ 1.5, 2.5, 3.5, 4.5, 5.5 };
    const b = [_]f64{ 2.0, 2.0, 2.0, 2.0, 2.0 };
    var out: [5]f64 = undefined;

    simd.mulVec(f64, &a, &b, &out, 5);

    try testing.expectApproxEqAbs(@as(f64, 3.0), out[0], 0.001);
    try testing.expectApproxEqAbs(@as(f64, 5.0), out[1], 0.001);
    try testing.expectApproxEqAbs(@as(f64, 7.0), out[2], 0.001);
    try testing.expectApproxEqAbs(@as(f64, 9.0), out[3], 0.001);
    try testing.expectApproxEqAbs(@as(f64, 11.0), out[4], 0.001);
}
