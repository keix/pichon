// =============================================================================
// Map operations
// =============================================================================
// Element-wise transformations.
// =============================================================================

const simd = @import("simd.zig");

// -----------------------------------------------------------------------------
// Generic implementations (internal)
// -----------------------------------------------------------------------------

fn add(comptime T: type, a: [*]const T, b: [*]const T, len: usize, out: [*]T) void {
    simd.addVec(T, a, b, out, len);
}

fn sub(comptime T: type, a: [*]const T, b: [*]const T, len: usize, out: [*]T) void {
    simd.subVec(T, a, b, out, len);
}

fn mul(comptime T: type, a: [*]const T, b: [*]const T, len: usize, out: [*]T) void {
    simd.mulVec(T, a, b, out, len);
}

fn addScalar(comptime T: type, a: [*]const T, len: usize, scalar: T, out: [*]T) void {
    simd.addScalarVec(T, a, scalar, out, len);
}

fn subScalar(comptime T: type, a: [*]const T, len: usize, scalar: T, out: [*]T) void {
    simd.subScalarVec(T, a, scalar, out, len);
}

fn mulScalar(comptime T: type, a: [*]const T, len: usize, scalar: T, out: [*]T) void {
    simd.mulScalarVec(T, a, scalar, out, len);
}

// -----------------------------------------------------------------------------
// Exports: binary add
// -----------------------------------------------------------------------------

pub export fn pichon_add_i32(a: [*]const i32, b: [*]const i32, len: usize, out: [*]i32) void {
    add(i32, a, b, len, out);
}

pub export fn pichon_add_i64(a: [*]const i64, b: [*]const i64, len: usize, out: [*]i64) void {
    add(i64, a, b, len, out);
}

pub export fn pichon_add_f64(a: [*]const f64, b: [*]const f64, len: usize, out: [*]f64) void {
    add(f64, a, b, len, out);
}

// -----------------------------------------------------------------------------
// Exports: binary sub
// -----------------------------------------------------------------------------

pub export fn pichon_sub_i32(a: [*]const i32, b: [*]const i32, len: usize, out: [*]i32) void {
    sub(i32, a, b, len, out);
}

pub export fn pichon_sub_i64(a: [*]const i64, b: [*]const i64, len: usize, out: [*]i64) void {
    sub(i64, a, b, len, out);
}

pub export fn pichon_sub_f64(a: [*]const f64, b: [*]const f64, len: usize, out: [*]f64) void {
    sub(f64, a, b, len, out);
}

// -----------------------------------------------------------------------------
// Exports: binary mul
// -----------------------------------------------------------------------------

pub export fn pichon_mul_i32(a: [*]const i32, b: [*]const i32, len: usize, out: [*]i32) void {
    mul(i32, a, b, len, out);
}

pub export fn pichon_mul_i64(a: [*]const i64, b: [*]const i64, len: usize, out: [*]i64) void {
    mul(i64, a, b, len, out);
}

pub export fn pichon_mul_f64(a: [*]const f64, b: [*]const f64, len: usize, out: [*]f64) void {
    mul(f64, a, b, len, out);
}

// -----------------------------------------------------------------------------
// Exports: scalar add
// -----------------------------------------------------------------------------

pub export fn pichon_add_s_i32(a: [*]const i32, len: usize, scalar: i32, out: [*]i32) void {
    addScalar(i32, a, len, scalar, out);
}

pub export fn pichon_add_s_i64(a: [*]const i64, len: usize, scalar: i64, out: [*]i64) void {
    addScalar(i64, a, len, scalar, out);
}

pub export fn pichon_add_s_f64(a: [*]const f64, len: usize, scalar: f64, out: [*]f64) void {
    addScalar(f64, a, len, scalar, out);
}

// -----------------------------------------------------------------------------
// Exports: scalar sub
// -----------------------------------------------------------------------------

pub export fn pichon_sub_s_i32(a: [*]const i32, len: usize, scalar: i32, out: [*]i32) void {
    subScalar(i32, a, len, scalar, out);
}

pub export fn pichon_sub_s_i64(a: [*]const i64, len: usize, scalar: i64, out: [*]i64) void {
    subScalar(i64, a, len, scalar, out);
}

pub export fn pichon_sub_s_f64(a: [*]const f64, len: usize, scalar: f64, out: [*]f64) void {
    subScalar(f64, a, len, scalar, out);
}

// -----------------------------------------------------------------------------
// Exports: scalar mul
// -----------------------------------------------------------------------------

pub export fn pichon_mul_s_i32(a: [*]const i32, len: usize, scalar: i32, out: [*]i32) void {
    mulScalar(i32, a, len, scalar, out);
}

pub export fn pichon_mul_s_i64(a: [*]const i64, len: usize, scalar: i64, out: [*]i64) void {
    mulScalar(i64, a, len, scalar, out);
}

pub export fn pichon_mul_s_f64(a: [*]const f64, len: usize, scalar: f64, out: [*]f64) void {
    mulScalar(f64, a, len, scalar, out);
}

// -----------------------------------------------------------------------------
// Tests
// -----------------------------------------------------------------------------

const testing = @import("std").testing;

test "add_i32" {
    const a = [_]i32{ 1, 2, 3 };
    const b = [_]i32{ 10, 20, 30 };
    var out: [3]i32 = undefined;

    pichon_add_i32(&a, &b, 3, &out);

    try testing.expectEqual(@as(i32, 11), out[0]);
    try testing.expectEqual(@as(i32, 22), out[1]);
    try testing.expectEqual(@as(i32, 33), out[2]);
}

test "sub_i32" {
    const a = [_]i32{ 100, 200, 300 };
    const b = [_]i32{ 10, 20, 30 };
    var out: [3]i32 = undefined;

    pichon_sub_i32(&a, &b, 3, &out);

    try testing.expectEqual(@as(i32, 90), out[0]);
    try testing.expectEqual(@as(i32, 180), out[1]);
    try testing.expectEqual(@as(i32, 270), out[2]);
}

test "mul_i32" {
    const a = [_]i32{ 2, 3, 4 };
    const b = [_]i32{ 10, 10, 10 };
    var out: [3]i32 = undefined;

    pichon_mul_i32(&a, &b, 3, &out);

    try testing.expectEqual(@as(i32, 20), out[0]);
    try testing.expectEqual(@as(i32, 30), out[1]);
    try testing.expectEqual(@as(i32, 40), out[2]);
}

test "add_s_i32" {
    const a = [_]i32{ 1, 2, 3 };
    var out: [3]i32 = undefined;

    pichon_add_s_i32(&a, 3, 100, &out);

    try testing.expectEqual(@as(i32, 101), out[0]);
    try testing.expectEqual(@as(i32, 102), out[1]);
    try testing.expectEqual(@as(i32, 103), out[2]);
}

test "mul_s_f64" {
    const a = [_]f64{ 100.0, 200.0, 300.0 };
    var out: [3]f64 = undefined;

    pichon_mul_s_f64(&a, 3, 1.1, &out);

    try testing.expectApproxEqAbs(@as(f64, 110.0), out[0], 0.001);
    try testing.expectApproxEqAbs(@as(f64, 220.0), out[1], 0.001);
    try testing.expectApproxEqAbs(@as(f64, 330.0), out[2], 0.001);
}
