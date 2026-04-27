"""
Pichon: Human-friendly interface.
Wraps binding.py to hide length management.
"""

from ctypes import c_int32, c_int64, c_double
from binding import lib

# =============================================================================
# Internal
# =============================================================================


def _ptr_len(xs):
    return xs, len(xs)


# =============================================================================
# Reduce
# =============================================================================


def sum_i32(xs):
    ptr, n = _ptr_len(xs)
    return lib.pichon_sum_i32(ptr, n)


def sum_i64(xs):
    ptr, n = _ptr_len(xs)
    return lib.pichon_sum_i64(ptr, n)


def sum_f64(xs):
    ptr, n = _ptr_len(xs)
    return lib.pichon_sum_f64(ptr, n)


def min_i32(xs):
    ptr, n = _ptr_len(xs)
    return lib.pichon_min_i32(ptr, n)


def min_i64(xs):
    ptr, n = _ptr_len(xs)
    return lib.pichon_min_i64(ptr, n)


def min_f64(xs):
    ptr, n = _ptr_len(xs)
    return lib.pichon_min_f64(ptr, n)


def max_i32(xs):
    ptr, n = _ptr_len(xs)
    return lib.pichon_max_i32(ptr, n)


def max_i64(xs):
    ptr, n = _ptr_len(xs)
    return lib.pichon_max_i64(ptr, n)


def max_f64(xs):
    ptr, n = _ptr_len(xs)
    return lib.pichon_max_f64(ptr, n)


# =============================================================================
# Filter
# =============================================================================


def filter_gt_i32(xs, threshold):
    ptr, n = _ptr_len(xs)
    out = (c_int32 * n)()
    count = lib.pichon_filter_gt_i32(ptr, n, out, threshold)
    return out, count


def filter_gt_i64(xs, threshold):
    ptr, n = _ptr_len(xs)
    out = (c_int64 * n)()
    count = lib.pichon_filter_gt_i64(ptr, n, out, threshold)
    return out, count


def filter_gt_f64(xs, threshold):
    ptr, n = _ptr_len(xs)
    out = (c_double * n)()
    count = lib.pichon_filter_gt_f64(ptr, n, out, threshold)
    return out, count


def filter_lt_i32(xs, threshold):
    ptr, n = _ptr_len(xs)
    out = (c_int32 * n)()
    count = lib.pichon_filter_lt_i32(ptr, n, out, threshold)
    return out, count


def filter_lt_i64(xs, threshold):
    ptr, n = _ptr_len(xs)
    out = (c_int64 * n)()
    count = lib.pichon_filter_lt_i64(ptr, n, out, threshold)
    return out, count


def filter_lt_f64(xs, threshold):
    ptr, n = _ptr_len(xs)
    out = (c_double * n)()
    count = lib.pichon_filter_lt_f64(ptr, n, out, threshold)
    return out, count


# =============================================================================
# Map: binary
# =============================================================================


def add_i32(a, b):
    n = len(a)
    out = (c_int32 * n)()
    lib.pichon_add_i32(a, b, n, out)
    return out


def add_i64(a, b):
    n = len(a)
    out = (c_int64 * n)()
    lib.pichon_add_i64(a, b, n, out)
    return out


def add_f64(a, b):
    n = len(a)
    out = (c_double * n)()
    lib.pichon_add_f64(a, b, n, out)
    return out


def sub_i32(a, b):
    n = len(a)
    out = (c_int32 * n)()
    lib.pichon_sub_i32(a, b, n, out)
    return out


def sub_i64(a, b):
    n = len(a)
    out = (c_int64 * n)()
    lib.pichon_sub_i64(a, b, n, out)
    return out


def sub_f64(a, b):
    n = len(a)
    out = (c_double * n)()
    lib.pichon_sub_f64(a, b, n, out)
    return out


def mul_i32(a, b):
    n = len(a)
    out = (c_int32 * n)()
    lib.pichon_mul_i32(a, b, n, out)
    return out


def mul_i64(a, b):
    n = len(a)
    out = (c_int64 * n)()
    lib.pichon_mul_i64(a, b, n, out)
    return out


def mul_f64(a, b):
    n = len(a)
    out = (c_double * n)()
    lib.pichon_mul_f64(a, b, n, out)
    return out


# =============================================================================
# Map: scalar
# =============================================================================


def add_s_i32(xs, scalar):
    ptr, n = _ptr_len(xs)
    out = (c_int32 * n)()
    lib.pichon_add_s_i32(ptr, n, scalar, out)
    return out


def add_s_i64(xs, scalar):
    ptr, n = _ptr_len(xs)
    out = (c_int64 * n)()
    lib.pichon_add_s_i64(ptr, n, scalar, out)
    return out


def add_s_f64(xs, scalar):
    ptr, n = _ptr_len(xs)
    out = (c_double * n)()
    lib.pichon_add_s_f64(ptr, n, scalar, out)
    return out


def sub_s_i32(xs, scalar):
    ptr, n = _ptr_len(xs)
    out = (c_int32 * n)()
    lib.pichon_sub_s_i32(ptr, n, scalar, out)
    return out


def sub_s_i64(xs, scalar):
    ptr, n = _ptr_len(xs)
    out = (c_int64 * n)()
    lib.pichon_sub_s_i64(ptr, n, scalar, out)
    return out


def sub_s_f64(xs, scalar):
    ptr, n = _ptr_len(xs)
    out = (c_double * n)()
    lib.pichon_sub_s_f64(ptr, n, scalar, out)
    return out


def mul_s_i32(xs, scalar):
    ptr, n = _ptr_len(xs)
    out = (c_int32 * n)()
    lib.pichon_mul_s_i32(ptr, n, scalar, out)
    return out


def mul_s_i64(xs, scalar):
    ptr, n = _ptr_len(xs)
    out = (c_int64 * n)()
    lib.pichon_mul_s_i64(ptr, n, scalar, out)
    return out


def mul_s_f64(xs, scalar):
    ptr, n = _ptr_len(xs)
    out = (c_double * n)()
    lib.pichon_mul_s_f64(ptr, n, scalar, out)
    return out


# =============================================================================
# Fusion
# =============================================================================


def sum_gt_i32(xs, threshold):
    ptr, n = _ptr_len(xs)
    return lib.pichon_sum_gt_i32(ptr, n, threshold)


def sum_gt_i64(xs, threshold):
    ptr, n = _ptr_len(xs)
    return lib.pichon_sum_gt_i64(ptr, n, threshold)


def sum_gt_f64(xs, threshold):
    ptr, n = _ptr_len(xs)
    return lib.pichon_sum_gt_f64(ptr, n, threshold)


def sum_lt_i32(xs, threshold):
    ptr, n = _ptr_len(xs)
    return lib.pichon_sum_lt_i32(ptr, n, threshold)


def sum_lt_i64(xs, threshold):
    ptr, n = _ptr_len(xs)
    return lib.pichon_sum_lt_i64(ptr, n, threshold)


def sum_lt_f64(xs, threshold):
    ptr, n = _ptr_len(xs)
    return lib.pichon_sum_lt_f64(ptr, n, threshold)


def count_gt_i32(xs, threshold):
    ptr, n = _ptr_len(xs)
    return lib.pichon_count_gt_i32(ptr, n, threshold)


def count_gt_i64(xs, threshold):
    ptr, n = _ptr_len(xs)
    return lib.pichon_count_gt_i64(ptr, n, threshold)


def count_gt_f64(xs, threshold):
    ptr, n = _ptr_len(xs)
    return lib.pichon_count_gt_f64(ptr, n, threshold)


def count_lt_i32(xs, threshold):
    ptr, n = _ptr_len(xs)
    return lib.pichon_count_lt_i32(ptr, n, threshold)


def count_lt_i64(xs, threshold):
    ptr, n = _ptr_len(xs)
    return lib.pichon_count_lt_i64(ptr, n, threshold)


def count_lt_f64(xs, threshold):
    ptr, n = _ptr_len(xs)
    return lib.pichon_count_lt_f64(ptr, n, threshold)


def min_gt_i32(xs, threshold):
    ptr, n = _ptr_len(xs)
    return lib.pichon_min_gt_i32(ptr, n, threshold)


def min_gt_i64(xs, threshold):
    ptr, n = _ptr_len(xs)
    return lib.pichon_min_gt_i64(ptr, n, threshold)


def min_gt_f64(xs, threshold):
    ptr, n = _ptr_len(xs)
    return lib.pichon_min_gt_f64(ptr, n, threshold)


def min_lt_i32(xs, threshold):
    ptr, n = _ptr_len(xs)
    return lib.pichon_min_lt_i32(ptr, n, threshold)


def min_lt_i64(xs, threshold):
    ptr, n = _ptr_len(xs)
    return lib.pichon_min_lt_i64(ptr, n, threshold)


def min_lt_f64(xs, threshold):
    ptr, n = _ptr_len(xs)
    return lib.pichon_min_lt_f64(ptr, n, threshold)


def max_gt_i32(xs, threshold):
    ptr, n = _ptr_len(xs)
    return lib.pichon_max_gt_i32(ptr, n, threshold)


def max_gt_i64(xs, threshold):
    ptr, n = _ptr_len(xs)
    return lib.pichon_max_gt_i64(ptr, n, threshold)


def max_gt_f64(xs, threshold):
    ptr, n = _ptr_len(xs)
    return lib.pichon_max_gt_f64(ptr, n, threshold)


def max_lt_i32(xs, threshold):
    ptr, n = _ptr_len(xs)
    return lib.pichon_max_lt_i32(ptr, n, threshold)


def max_lt_i64(xs, threshold):
    ptr, n = _ptr_len(xs)
    return lib.pichon_max_lt_i64(ptr, n, threshold)


def max_lt_f64(xs, threshold):
    ptr, n = _ptr_len(xs)
    return lib.pichon_max_lt_f64(ptr, n, threshold)
