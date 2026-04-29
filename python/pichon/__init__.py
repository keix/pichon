"""
Pichon: SIMD-accelerated columnar operations.

This module provides high-level Python bindings to Pichon's Zig core.
All functions operate on ctypes arrays and hide length management.

All inputs must be contiguous ctypes arrays.
No bounds checking is performed.

Operations:
    reduce:  sum, min, max
    filter:  filter_gt, filter_lt
    map:     add, sub, mul (binary and scalar)
    fusion:  sum_gt, count_gt, min_gt, max_gt, etc.

Types: i32, i64, f64

Example:
    from ctypes import c_int32
    import pichon

    data = (c_int32 * 5)(1, 2, 3, 4, 5)
    print(pichon.sum_i32(data))        # 15
    print(pichon.sum_gt_i32(data, 2))  # 12 (3+4+5)
"""

from ctypes import c_int32, c_int64, c_double
from ._native import lib


# =============================================================================
# Reduce
# =============================================================================


def sum_i32(xs):
    return lib.pichon_sum_i32(xs, len(xs))


def sum_i64(xs):
    return lib.pichon_sum_i64(xs, len(xs))


def sum_f64(xs):
    return lib.pichon_sum_f64(xs, len(xs))


def min_i32(xs):
    return lib.pichon_min_i32(xs, len(xs))


def min_i64(xs):
    return lib.pichon_min_i64(xs, len(xs))


def min_f64(xs):
    return lib.pichon_min_f64(xs, len(xs))


def max_i32(xs):
    return lib.pichon_max_i32(xs, len(xs))


def max_i64(xs):
    return lib.pichon_max_i64(xs, len(xs))


def max_f64(xs):
    return lib.pichon_max_f64(xs, len(xs))


# =============================================================================
# Filter
# =============================================================================


def _filter_op(xs, threshold, ctype, fn):
    # CONTRACT:
    # - input must be contiguous ctypes array
    # - output buffer is preallocated to input size
    # - returned count defines valid region
    n = len(xs)
    out = (ctype * n)()
    count = fn(xs, n, out, threshold)
    return out, count


def filter_gt_i32(xs, threshold):
    return _filter_op(xs, threshold, c_int32, lib.pichon_filter_gt_i32)


def filter_gt_i64(xs, threshold):
    return _filter_op(xs, threshold, c_int64, lib.pichon_filter_gt_i64)


def filter_gt_f64(xs, threshold):
    return _filter_op(xs, threshold, c_double, lib.pichon_filter_gt_f64)


def filter_lt_i32(xs, threshold):
    return _filter_op(xs, threshold, c_int32, lib.pichon_filter_lt_i32)


def filter_lt_i64(xs, threshold):
    return _filter_op(xs, threshold, c_int64, lib.pichon_filter_lt_i64)


def filter_lt_f64(xs, threshold):
    return _filter_op(xs, threshold, c_double, lib.pichon_filter_lt_f64)


# =============================================================================
# Map: binary
# =============================================================================


def _binary_op(a, b, ctype, fn):
    # CONTRACT:
    # - inputs must have identical lengths
    # - inputs must be contiguous ctypes arrays
    # - no bounds checking is performed
    n = len(a)
    out = (ctype * n)()
    fn(a, b, n, out)
    return out


def add_i32(a, b):
    return _binary_op(a, b, c_int32, lib.pichon_add_i32)


def add_i64(a, b):
    return _binary_op(a, b, c_int64, lib.pichon_add_i64)


def add_f64(a, b):
    return _binary_op(a, b, c_double, lib.pichon_add_f64)


def sub_i32(a, b):
    return _binary_op(a, b, c_int32, lib.pichon_sub_i32)


def sub_i64(a, b):
    return _binary_op(a, b, c_int64, lib.pichon_sub_i64)


def sub_f64(a, b):
    return _binary_op(a, b, c_double, lib.pichon_sub_f64)


def mul_i32(a, b):
    return _binary_op(a, b, c_int32, lib.pichon_mul_i32)


def mul_i64(a, b):
    return _binary_op(a, b, c_int64, lib.pichon_mul_i64)


def mul_f64(a, b):
    return _binary_op(a, b, c_double, lib.pichon_mul_f64)


# =============================================================================
# Map: scalar
# =============================================================================


def _scalar_op(xs, scalar, ctype, fn):
    # CONTRACT:
    # - input must be contiguous ctypes array
    # - scalar must match ctype
    # - no bounds checking is performed
    n = len(xs)
    out = (ctype * n)()
    fn(xs, n, scalar, out)
    return out


def add_s_i32(xs, scalar):
    return _scalar_op(xs, scalar, c_int32, lib.pichon_add_s_i32)


def add_s_i64(xs, scalar):
    return _scalar_op(xs, scalar, c_int64, lib.pichon_add_s_i64)


def add_s_f64(xs, scalar):
    return _scalar_op(xs, scalar, c_double, lib.pichon_add_s_f64)


def sub_s_i32(xs, scalar):
    return _scalar_op(xs, scalar, c_int32, lib.pichon_sub_s_i32)


def sub_s_i64(xs, scalar):
    return _scalar_op(xs, scalar, c_int64, lib.pichon_sub_s_i64)


def sub_s_f64(xs, scalar):
    return _scalar_op(xs, scalar, c_double, lib.pichon_sub_s_f64)


def mul_s_i32(xs, scalar):
    return _scalar_op(xs, scalar, c_int32, lib.pichon_mul_s_i32)


def mul_s_i64(xs, scalar):
    return _scalar_op(xs, scalar, c_int64, lib.pichon_mul_s_i64)


def mul_s_f64(xs, scalar):
    return _scalar_op(xs, scalar, c_double, lib.pichon_mul_s_f64)


# =============================================================================
# Fusion
# =============================================================================


def sum_gt_i32(xs, threshold):
    return lib.pichon_sum_gt_i32(xs, len(xs), threshold)


def sum_gt_i64(xs, threshold):
    return lib.pichon_sum_gt_i64(xs, len(xs), threshold)


def sum_gt_f64(xs, threshold):
    return lib.pichon_sum_gt_f64(xs, len(xs), threshold)


def sum_lt_i32(xs, threshold):
    return lib.pichon_sum_lt_i32(xs, len(xs), threshold)


def sum_lt_i64(xs, threshold):
    return lib.pichon_sum_lt_i64(xs, len(xs), threshold)


def sum_lt_f64(xs, threshold):
    return lib.pichon_sum_lt_f64(xs, len(xs), threshold)


def count_gt_i32(xs, threshold):
    return lib.pichon_count_gt_i32(xs, len(xs), threshold)


def count_gt_i64(xs, threshold):
    return lib.pichon_count_gt_i64(xs, len(xs), threshold)


def count_gt_f64(xs, threshold):
    return lib.pichon_count_gt_f64(xs, len(xs), threshold)


def count_lt_i32(xs, threshold):
    return lib.pichon_count_lt_i32(xs, len(xs), threshold)


def count_lt_i64(xs, threshold):
    return lib.pichon_count_lt_i64(xs, len(xs), threshold)


def count_lt_f64(xs, threshold):
    return lib.pichon_count_lt_f64(xs, len(xs), threshold)


def min_gt_i32(xs, threshold):
    return lib.pichon_min_gt_i32(xs, len(xs), threshold)


def min_gt_i64(xs, threshold):
    return lib.pichon_min_gt_i64(xs, len(xs), threshold)


def min_gt_f64(xs, threshold):
    return lib.pichon_min_gt_f64(xs, len(xs), threshold)


def min_lt_i32(xs, threshold):
    return lib.pichon_min_lt_i32(xs, len(xs), threshold)


def min_lt_i64(xs, threshold):
    return lib.pichon_min_lt_i64(xs, len(xs), threshold)


def min_lt_f64(xs, threshold):
    return lib.pichon_min_lt_f64(xs, len(xs), threshold)


def max_gt_i32(xs, threshold):
    return lib.pichon_max_gt_i32(xs, len(xs), threshold)


def max_gt_i64(xs, threshold):
    return lib.pichon_max_gt_i64(xs, len(xs), threshold)


def max_gt_f64(xs, threshold):
    return lib.pichon_max_gt_f64(xs, len(xs), threshold)


def max_lt_i32(xs, threshold):
    return lib.pichon_max_lt_i32(xs, len(xs), threshold)


def max_lt_i64(xs, threshold):
    return lib.pichon_max_lt_i64(xs, len(xs), threshold)


def max_lt_f64(xs, threshold):
    return lib.pichon_max_lt_f64(xs, len(xs), threshold)
