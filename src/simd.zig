// =============================================================================
// SIMD primitives
// =============================================================================
// Thin abstraction over vectorized operations.
// Lane width is determined by the target architecture via std.simd.
// =============================================================================

const std = @import("std");

// -----------------------------------------------------------------------------
// Core abstractions
// -----------------------------------------------------------------------------

pub fn lanes(comptime T: type) comptime_int {
    return std.simd.suggestVectorLength(T) orelse 1;
}

pub fn Vec(comptime T: type) type {
    return @Vector(lanes(T), T);
}

pub fn splat(comptime T: type, value: T) Vec(T) {
    return @splat(value);
}

pub fn reduceAdd(comptime T: type, v: Vec(T)) T {
    return @reduce(.Add, v);
}

pub fn reduceMin(comptime T: type, v: Vec(T)) T {
    return @reduce(.Min, v);
}

pub fn reduceMax(comptime T: type, v: Vec(T)) T {
    return @reduce(.Max, v);
}

// -----------------------------------------------------------------------------
// Reduce operations
// -----------------------------------------------------------------------------

pub fn sum(comptime T: type, ptr: [*]const T, len: usize) T {
    const L = comptime lanes(T);
    const U = 4 * L;

    var acc0: Vec(T) = splat(T, 0);
    var acc1: Vec(T) = splat(T, 0);
    var acc2: Vec(T) = splat(T, 0);
    var acc3: Vec(T) = splat(T, 0);
    var i: usize = 0;

    // 4x unrolled main loop
    while (i + U <= len) : (i += U) {
        acc0 += ptr[i..][0..L].*;
        acc1 += ptr[i + L ..][0..L].*;
        acc2 += ptr[i + 2 * L ..][0..L].*;
        acc3 += ptr[i + 3 * L ..][0..L].*;
    }

    // merge accumulators
    var acc = acc0 + acc1 + acc2 + acc3;

    // remainder (1 vector at a time)
    while (i + L <= len) : (i += L) {
        acc += ptr[i..][0..L].*;
    }

    var total: T = reduceAdd(T, acc);

    // scalar tail
    while (i < len) : (i += 1) {
        total += ptr[i];
    }

    return total;
}

pub fn sumWiden(comptime T: type, comptime R: type, ptr: [*]const T, len: usize) R {
    const L = comptime lanes(T);
    const U = 4 * L;
    const VecR = @Vector(L, R);

    var acc0: VecR = @splat(0);
    var acc1: VecR = @splat(0);
    var acc2: VecR = @splat(0);
    var acc3: VecR = @splat(0);
    var i: usize = 0;

    // 4x unrolled main loop
    while (i + U <= len) : (i += U) {
        const v0: Vec(T) = ptr[i..][0..L].*;
        const v1: Vec(T) = ptr[i + L ..][0..L].*;
        const v2: Vec(T) = ptr[i + 2 * L ..][0..L].*;
        const v3: Vec(T) = ptr[i + 3 * L ..][0..L].*;
        acc0 += @as(VecR, v0);
        acc1 += @as(VecR, v1);
        acc2 += @as(VecR, v2);
        acc3 += @as(VecR, v3);
    }

    // merge accumulators
    var acc = acc0 + acc1 + acc2 + acc3;

    // remainder (1 vector at a time)
    while (i + L <= len) : (i += L) {
        const chunk: Vec(T) = ptr[i..][0..L].*;
        acc += @as(VecR, chunk);
    }

    var total: R = @reduce(.Add, acc);

    // scalar tail
    while (i < len) : (i += 1) {
        total += @as(R, ptr[i]);
    }

    return total;
}

// -----------------------------------------------------------------------------
// Conditional sum (> threshold)
// -----------------------------------------------------------------------------

pub fn sumGt(comptime T: type, ptr: [*]const T, len: usize, threshold: T) T {
    const L = comptime lanes(T);
    const U = 4 * L;
    const zero: Vec(T) = splat(T, 0);
    const threshold_vec: Vec(T) = splat(T, threshold);

    var acc0: Vec(T) = zero;
    var acc1: Vec(T) = zero;
    var acc2: Vec(T) = zero;
    var acc3: Vec(T) = zero;
    var i: usize = 0;

    // 4x unrolled main loop
    while (i + U <= len) : (i += U) {
        const v0: Vec(T) = ptr[i..][0..L].*;
        const v1: Vec(T) = ptr[i + L ..][0..L].*;
        const v2: Vec(T) = ptr[i + 2 * L ..][0..L].*;
        const v3: Vec(T) = ptr[i + 3 * L ..][0..L].*;
        acc0 += @select(T, v0 > threshold_vec, v0, zero);
        acc1 += @select(T, v1 > threshold_vec, v1, zero);
        acc2 += @select(T, v2 > threshold_vec, v2, zero);
        acc3 += @select(T, v3 > threshold_vec, v3, zero);
    }

    // merge accumulators
    var acc = acc0 + acc1 + acc2 + acc3;

    // remainder (1 vector at a time)
    while (i + L <= len) : (i += L) {
        const chunk: Vec(T) = ptr[i..][0..L].*;
        acc += @select(T, chunk > threshold_vec, chunk, zero);
    }

    var total: T = reduceAdd(T, acc);

    // scalar tail
    while (i < len) : (i += 1) {
        if (ptr[i] > threshold) total += ptr[i];
    }

    return total;
}

pub fn sumGtWiden(comptime T: type, comptime R: type, ptr: [*]const T, len: usize, threshold: T) R {
    const L = comptime lanes(T);
    const U = 4 * L;
    const VecR = @Vector(L, R);
    const zero: Vec(T) = splat(T, 0);
    const zeroR: VecR = @splat(0);
    const threshold_vec: Vec(T) = splat(T, threshold);

    var acc0: VecR = zeroR;
    var acc1: VecR = zeroR;
    var acc2: VecR = zeroR;
    var acc3: VecR = zeroR;
    var i: usize = 0;

    // 4x unrolled main loop
    while (i + U <= len) : (i += U) {
        const v0: Vec(T) = ptr[i..][0..L].*;
        const v1: Vec(T) = ptr[i + L ..][0..L].*;
        const v2: Vec(T) = ptr[i + 2 * L ..][0..L].*;
        const v3: Vec(T) = ptr[i + 3 * L ..][0..L].*;
        acc0 += @as(VecR, @select(T, v0 > threshold_vec, v0, zero));
        acc1 += @as(VecR, @select(T, v1 > threshold_vec, v1, zero));
        acc2 += @as(VecR, @select(T, v2 > threshold_vec, v2, zero));
        acc3 += @as(VecR, @select(T, v3 > threshold_vec, v3, zero));
    }

    // merge accumulators
    var acc = acc0 + acc1 + acc2 + acc3;

    // remainder (1 vector at a time)
    while (i + L <= len) : (i += L) {
        const chunk: Vec(T) = ptr[i..][0..L].*;
        acc += @as(VecR, @select(T, chunk > threshold_vec, chunk, zero));
    }

    var total: R = @reduce(.Add, acc);

    // scalar tail
    while (i < len) : (i += 1) {
        if (ptr[i] > threshold) total += @as(R, ptr[i]);
    }

    return total;
}

// -----------------------------------------------------------------------------
// Conditional sum (< threshold)
// -----------------------------------------------------------------------------

pub fn sumLt(comptime T: type, ptr: [*]const T, len: usize, threshold: T) T {
    const L = comptime lanes(T);
    const U = 4 * L;
    const zero: Vec(T) = splat(T, 0);
    const threshold_vec: Vec(T) = splat(T, threshold);

    var acc0: Vec(T) = zero;
    var acc1: Vec(T) = zero;
    var acc2: Vec(T) = zero;
    var acc3: Vec(T) = zero;
    var i: usize = 0;

    // 4x unrolled main loop
    while (i + U <= len) : (i += U) {
        const v0: Vec(T) = ptr[i..][0..L].*;
        const v1: Vec(T) = ptr[i + L ..][0..L].*;
        const v2: Vec(T) = ptr[i + 2 * L ..][0..L].*;
        const v3: Vec(T) = ptr[i + 3 * L ..][0..L].*;
        acc0 += @select(T, v0 < threshold_vec, v0, zero);
        acc1 += @select(T, v1 < threshold_vec, v1, zero);
        acc2 += @select(T, v2 < threshold_vec, v2, zero);
        acc3 += @select(T, v3 < threshold_vec, v3, zero);
    }

    // merge accumulators
    var acc = acc0 + acc1 + acc2 + acc3;

    // remainder (1 vector at a time)
    while (i + L <= len) : (i += L) {
        const chunk: Vec(T) = ptr[i..][0..L].*;
        acc += @select(T, chunk < threshold_vec, chunk, zero);
    }

    var total: T = reduceAdd(T, acc);

    // scalar tail
    while (i < len) : (i += 1) {
        if (ptr[i] < threshold) total += ptr[i];
    }

    return total;
}

pub fn sumLtWiden(comptime T: type, comptime R: type, ptr: [*]const T, len: usize, threshold: T) R {
    const L = comptime lanes(T);
    const U = 4 * L;
    const VecR = @Vector(L, R);
    const zero: Vec(T) = splat(T, 0);
    const zeroR: VecR = @splat(0);
    const threshold_vec: Vec(T) = splat(T, threshold);

    var acc0: VecR = zeroR;
    var acc1: VecR = zeroR;
    var acc2: VecR = zeroR;
    var acc3: VecR = zeroR;
    var i: usize = 0;

    // 4x unrolled main loop
    while (i + U <= len) : (i += U) {
        const v0: Vec(T) = ptr[i..][0..L].*;
        const v1: Vec(T) = ptr[i + L ..][0..L].*;
        const v2: Vec(T) = ptr[i + 2 * L ..][0..L].*;
        const v3: Vec(T) = ptr[i + 3 * L ..][0..L].*;
        acc0 += @as(VecR, @select(T, v0 < threshold_vec, v0, zero));
        acc1 += @as(VecR, @select(T, v1 < threshold_vec, v1, zero));
        acc2 += @as(VecR, @select(T, v2 < threshold_vec, v2, zero));
        acc3 += @as(VecR, @select(T, v3 < threshold_vec, v3, zero));
    }

    // merge accumulators
    var acc = acc0 + acc1 + acc2 + acc3;

    // remainder (1 vector at a time)
    while (i + L <= len) : (i += L) {
        const chunk: Vec(T) = ptr[i..][0..L].*;
        acc += @as(VecR, @select(T, chunk < threshold_vec, chunk, zero));
    }

    var total: R = @reduce(.Add, acc);

    // scalar tail
    while (i < len) : (i += 1) {
        if (ptr[i] < threshold) total += @as(R, ptr[i]);
    }

    return total;
}

// -----------------------------------------------------------------------------
// Conditional count
// -----------------------------------------------------------------------------

pub fn countGt(comptime T: type, ptr: [*]const T, len: usize, threshold: T) usize {
    const L = comptime lanes(T);
    const U = 4 * L;
    const VecU = @Vector(L, usize);
    const threshold_vec: Vec(T) = splat(T, threshold);
    const zero: VecU = @splat(0);
    const one: VecU = @splat(1);

    var acc0: VecU = zero;
    var acc1: VecU = zero;
    var acc2: VecU = zero;
    var acc3: VecU = zero;
    var i: usize = 0;

    // 4x unrolled main loop
    while (i + U <= len) : (i += U) {
        const v0: Vec(T) = ptr[i..][0..L].*;
        const v1: Vec(T) = ptr[i + L ..][0..L].*;
        const v2: Vec(T) = ptr[i + 2 * L ..][0..L].*;
        const v3: Vec(T) = ptr[i + 3 * L ..][0..L].*;
        acc0 += @select(usize, v0 > threshold_vec, one, zero);
        acc1 += @select(usize, v1 > threshold_vec, one, zero);
        acc2 += @select(usize, v2 > threshold_vec, one, zero);
        acc3 += @select(usize, v3 > threshold_vec, one, zero);
    }

    // merge accumulators
    var acc = acc0 + acc1 + acc2 + acc3;

    // remainder (1 vector at a time)
    while (i + L <= len) : (i += L) {
        const chunk: Vec(T) = ptr[i..][0..L].*;
        acc += @select(usize, chunk > threshold_vec, one, zero);
    }

    var count: usize = @reduce(.Add, acc);

    // scalar tail
    while (i < len) : (i += 1) {
        if (ptr[i] > threshold) count += 1;
    }

    return count;
}

pub fn countLt(comptime T: type, ptr: [*]const T, len: usize, threshold: T) usize {
    const L = comptime lanes(T);
    const U = 4 * L;
    const VecU = @Vector(L, usize);
    const threshold_vec: Vec(T) = splat(T, threshold);
    const zero: VecU = @splat(0);
    const one: VecU = @splat(1);

    var acc0: VecU = zero;
    var acc1: VecU = zero;
    var acc2: VecU = zero;
    var acc3: VecU = zero;
    var i: usize = 0;

    // 4x unrolled main loop
    while (i + U <= len) : (i += U) {
        const v0: Vec(T) = ptr[i..][0..L].*;
        const v1: Vec(T) = ptr[i + L ..][0..L].*;
        const v2: Vec(T) = ptr[i + 2 * L ..][0..L].*;
        const v3: Vec(T) = ptr[i + 3 * L ..][0..L].*;
        acc0 += @select(usize, v0 < threshold_vec, one, zero);
        acc1 += @select(usize, v1 < threshold_vec, one, zero);
        acc2 += @select(usize, v2 < threshold_vec, one, zero);
        acc3 += @select(usize, v3 < threshold_vec, one, zero);
    }

    // merge accumulators
    var acc = acc0 + acc1 + acc2 + acc3;

    // remainder (1 vector at a time)
    while (i + L <= len) : (i += L) {
        const chunk: Vec(T) = ptr[i..][0..L].*;
        acc += @select(usize, chunk < threshold_vec, one, zero);
    }

    var count: usize = @reduce(.Add, acc);

    // scalar tail
    while (i < len) : (i += 1) {
        if (ptr[i] < threshold) count += 1;
    }

    return count;
}

// -----------------------------------------------------------------------------
// Conditional min (> threshold)
// -----------------------------------------------------------------------------

fn minIdentity(comptime T: type) T {
    return switch (@typeInfo(T)) {
        .int => std.math.maxInt(T),
        .float => std.math.inf(T),
        else => @compileError("unsupported type"),
    };
}

fn maxIdentity(comptime T: type) T {
    return switch (@typeInfo(T)) {
        .int => std.math.minInt(T),
        .float => -std.math.inf(T),
        else => @compileError("unsupported type"),
    };
}

pub fn minGt(comptime T: type, ptr: [*]const T, len: usize, threshold: T) T {
    const L = comptime lanes(T);
    const U = 4 * L;
    const identity: Vec(T) = splat(T, minIdentity(T));
    const threshold_vec: Vec(T) = splat(T, threshold);

    var acc0: Vec(T) = identity;
    var acc1: Vec(T) = identity;
    var acc2: Vec(T) = identity;
    var acc3: Vec(T) = identity;
    var i: usize = 0;

    // 4x unrolled main loop
    while (i + U <= len) : (i += U) {
        const v0: Vec(T) = ptr[i..][0..L].*;
        const v1: Vec(T) = ptr[i + L ..][0..L].*;
        const v2: Vec(T) = ptr[i + 2 * L ..][0..L].*;
        const v3: Vec(T) = ptr[i + 3 * L ..][0..L].*;
        acc0 = @min(acc0, @select(T, v0 > threshold_vec, v0, identity));
        acc1 = @min(acc1, @select(T, v1 > threshold_vec, v1, identity));
        acc2 = @min(acc2, @select(T, v2 > threshold_vec, v2, identity));
        acc3 = @min(acc3, @select(T, v3 > threshold_vec, v3, identity));
    }

    // merge accumulators
    var acc = @min(@min(acc0, acc1), @min(acc2, acc3));

    // remainder (1 vector at a time)
    while (i + L <= len) : (i += L) {
        const chunk: Vec(T) = ptr[i..][0..L].*;
        acc = @min(acc, @select(T, chunk > threshold_vec, chunk, identity));
    }

    var result: T = reduceMin(T, acc);

    // scalar tail
    while (i < len) : (i += 1) {
        if (ptr[i] > threshold and ptr[i] < result) result = ptr[i];
    }

    return result;
}

pub fn minLt(comptime T: type, ptr: [*]const T, len: usize, threshold: T) T {
    const L = comptime lanes(T);
    const U = 4 * L;
    const identity: Vec(T) = splat(T, minIdentity(T));
    const threshold_vec: Vec(T) = splat(T, threshold);

    var acc0: Vec(T) = identity;
    var acc1: Vec(T) = identity;
    var acc2: Vec(T) = identity;
    var acc3: Vec(T) = identity;
    var i: usize = 0;

    // 4x unrolled main loop
    while (i + U <= len) : (i += U) {
        const v0: Vec(T) = ptr[i..][0..L].*;
        const v1: Vec(T) = ptr[i + L ..][0..L].*;
        const v2: Vec(T) = ptr[i + 2 * L ..][0..L].*;
        const v3: Vec(T) = ptr[i + 3 * L ..][0..L].*;
        acc0 = @min(acc0, @select(T, v0 < threshold_vec, v0, identity));
        acc1 = @min(acc1, @select(T, v1 < threshold_vec, v1, identity));
        acc2 = @min(acc2, @select(T, v2 < threshold_vec, v2, identity));
        acc3 = @min(acc3, @select(T, v3 < threshold_vec, v3, identity));
    }

    // merge accumulators
    var acc = @min(@min(acc0, acc1), @min(acc2, acc3));

    // remainder (1 vector at a time)
    while (i + L <= len) : (i += L) {
        const chunk: Vec(T) = ptr[i..][0..L].*;
        acc = @min(acc, @select(T, chunk < threshold_vec, chunk, identity));
    }

    var result: T = reduceMin(T, acc);

    // scalar tail
    while (i < len) : (i += 1) {
        if (ptr[i] < threshold and ptr[i] < result) result = ptr[i];
    }

    return result;
}

// -----------------------------------------------------------------------------
// Map operations (element-wise)
// -----------------------------------------------------------------------------

pub fn addVec(comptime T: type, a: [*]const T, b: [*]const T, out: [*]T, len: usize) void {
    const L = comptime lanes(T);
    var i: usize = 0;

    while (i + L <= len) : (i += L) {
        const va: Vec(T) = a[i..][0..L].*;
        const vb: Vec(T) = b[i..][0..L].*;
        out[i..][0..L].* = va + vb;
    }

    while (i < len) : (i += 1) {
        out[i] = a[i] + b[i];
    }
}

pub fn subVec(comptime T: type, a: [*]const T, b: [*]const T, out: [*]T, len: usize) void {
    const L = comptime lanes(T);
    var i: usize = 0;

    while (i + L <= len) : (i += L) {
        const va: Vec(T) = a[i..][0..L].*;
        const vb: Vec(T) = b[i..][0..L].*;
        out[i..][0..L].* = va - vb;
    }

    while (i < len) : (i += 1) {
        out[i] = a[i] - b[i];
    }
}

pub fn mulVec(comptime T: type, a: [*]const T, b: [*]const T, out: [*]T, len: usize) void {
    const L = comptime lanes(T);
    var i: usize = 0;

    while (i + L <= len) : (i += L) {
        const va: Vec(T) = a[i..][0..L].*;
        const vb: Vec(T) = b[i..][0..L].*;
        out[i..][0..L].* = va * vb;
    }

    while (i < len) : (i += 1) {
        out[i] = a[i] * b[i];
    }
}

pub fn addScalarVec(comptime T: type, a: [*]const T, scalar: T, out: [*]T, len: usize) void {
    const L = comptime lanes(T);
    const vs: Vec(T) = splat(T, scalar);
    var i: usize = 0;

    while (i + L <= len) : (i += L) {
        const va: Vec(T) = a[i..][0..L].*;
        out[i..][0..L].* = va + vs;
    }

    while (i < len) : (i += 1) {
        out[i] = a[i] + scalar;
    }
}

pub fn subScalarVec(comptime T: type, a: [*]const T, scalar: T, out: [*]T, len: usize) void {
    const L = comptime lanes(T);
    const vs: Vec(T) = splat(T, scalar);
    var i: usize = 0;

    while (i + L <= len) : (i += L) {
        const va: Vec(T) = a[i..][0..L].*;
        out[i..][0..L].* = va - vs;
    }

    while (i < len) : (i += 1) {
        out[i] = a[i] - scalar;
    }
}

pub fn mulScalarVec(comptime T: type, a: [*]const T, scalar: T, out: [*]T, len: usize) void {
    const L = comptime lanes(T);
    const vs: Vec(T) = splat(T, scalar);
    var i: usize = 0;

    while (i + L <= len) : (i += L) {
        const va: Vec(T) = a[i..][0..L].*;
        out[i..][0..L].* = va * vs;
    }

    while (i < len) : (i += 1) {
        out[i] = a[i] * scalar;
    }
}

// -----------------------------------------------------------------------------
// Conditional max (> threshold)
// -----------------------------------------------------------------------------

pub fn maxGt(comptime T: type, ptr: [*]const T, len: usize, threshold: T) T {
    const L = comptime lanes(T);
    const U = 4 * L;
    const identity: Vec(T) = splat(T, maxIdentity(T));
    const threshold_vec: Vec(T) = splat(T, threshold);

    var acc0: Vec(T) = identity;
    var acc1: Vec(T) = identity;
    var acc2: Vec(T) = identity;
    var acc3: Vec(T) = identity;
    var i: usize = 0;

    // 4x unrolled main loop
    while (i + U <= len) : (i += U) {
        const v0: Vec(T) = ptr[i..][0..L].*;
        const v1: Vec(T) = ptr[i + L ..][0..L].*;
        const v2: Vec(T) = ptr[i + 2 * L ..][0..L].*;
        const v3: Vec(T) = ptr[i + 3 * L ..][0..L].*;
        acc0 = @max(acc0, @select(T, v0 > threshold_vec, v0, identity));
        acc1 = @max(acc1, @select(T, v1 > threshold_vec, v1, identity));
        acc2 = @max(acc2, @select(T, v2 > threshold_vec, v2, identity));
        acc3 = @max(acc3, @select(T, v3 > threshold_vec, v3, identity));
    }

    // merge accumulators
    var acc = @max(@max(acc0, acc1), @max(acc2, acc3));

    // remainder (1 vector at a time)
    while (i + L <= len) : (i += L) {
        const chunk: Vec(T) = ptr[i..][0..L].*;
        acc = @max(acc, @select(T, chunk > threshold_vec, chunk, identity));
    }

    var result: T = reduceMax(T, acc);

    // scalar tail
    while (i < len) : (i += 1) {
        if (ptr[i] > threshold and ptr[i] > result) result = ptr[i];
    }

    return result;
}

pub fn maxLt(comptime T: type, ptr: [*]const T, len: usize, threshold: T) T {
    const L = comptime lanes(T);
    const U = 4 * L;
    const identity: Vec(T) = splat(T, maxIdentity(T));
    const threshold_vec: Vec(T) = splat(T, threshold);

    var acc0: Vec(T) = identity;
    var acc1: Vec(T) = identity;
    var acc2: Vec(T) = identity;
    var acc3: Vec(T) = identity;
    var i: usize = 0;

    // 4x unrolled main loop
    while (i + U <= len) : (i += U) {
        const v0: Vec(T) = ptr[i..][0..L].*;
        const v1: Vec(T) = ptr[i + L ..][0..L].*;
        const v2: Vec(T) = ptr[i + 2 * L ..][0..L].*;
        const v3: Vec(T) = ptr[i + 3 * L ..][0..L].*;
        acc0 = @max(acc0, @select(T, v0 < threshold_vec, v0, identity));
        acc1 = @max(acc1, @select(T, v1 < threshold_vec, v1, identity));
        acc2 = @max(acc2, @select(T, v2 < threshold_vec, v2, identity));
        acc3 = @max(acc3, @select(T, v3 < threshold_vec, v3, identity));
    }

    // merge accumulators
    var acc = @max(@max(acc0, acc1), @max(acc2, acc3));

    // remainder (1 vector at a time)
    while (i + L <= len) : (i += L) {
        const chunk: Vec(T) = ptr[i..][0..L].*;
        acc = @max(acc, @select(T, chunk < threshold_vec, chunk, identity));
    }

    var result: T = reduceMax(T, acc);

    // scalar tail
    while (i < len) : (i += 1) {
        if (ptr[i] < threshold and ptr[i] > result) result = ptr[i];
    }

    return result;
}
