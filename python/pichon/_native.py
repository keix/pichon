"""
Pichon: Low-level ctypes binding.
"""

import sys
from ctypes import CDLL, POINTER, c_int32, c_int64, c_double, c_size_t
from pathlib import Path

if sys.platform == "darwin":
    _lib_name = "libpichon.dylib"
elif sys.platform == "win32":
    _lib_name = "pichon.dll"
else:
    _lib_name = "libpichon.so"

_lib_path = Path(__file__).parent.parent.parent / "zig-out" / "lib" / _lib_name
lib = CDLL(str(_lib_path))

# =============================================================================
# Reduce: sum
# =============================================================================

lib.pichon_sum_i32.argtypes = [POINTER(c_int32), c_size_t]
lib.pichon_sum_i32.restype = c_int64

lib.pichon_sum_i64.argtypes = [POINTER(c_int64), c_size_t]
lib.pichon_sum_i64.restype = c_int64

lib.pichon_sum_f64.argtypes = [POINTER(c_double), c_size_t]
lib.pichon_sum_f64.restype = c_double

# =============================================================================
# Reduce: min
# =============================================================================

lib.pichon_min_i32.argtypes = [POINTER(c_int32), c_size_t]
lib.pichon_min_i32.restype = c_int32

lib.pichon_min_i64.argtypes = [POINTER(c_int64), c_size_t]
lib.pichon_min_i64.restype = c_int64

lib.pichon_min_f64.argtypes = [POINTER(c_double), c_size_t]
lib.pichon_min_f64.restype = c_double

# =============================================================================
# Reduce: max
# =============================================================================

lib.pichon_max_i32.argtypes = [POINTER(c_int32), c_size_t]
lib.pichon_max_i32.restype = c_int32

lib.pichon_max_i64.argtypes = [POINTER(c_int64), c_size_t]
lib.pichon_max_i64.restype = c_int64

lib.pichon_max_f64.argtypes = [POINTER(c_double), c_size_t]
lib.pichon_max_f64.restype = c_double

# =============================================================================
# Filter: greater than
# =============================================================================

lib.pichon_filter_gt_i32.argtypes = [
    POINTER(c_int32),
    c_size_t,
    POINTER(c_int32),
    c_int32,
]
lib.pichon_filter_gt_i32.restype = c_size_t

lib.pichon_filter_gt_i64.argtypes = [
    POINTER(c_int64),
    c_size_t,
    POINTER(c_int64),
    c_int64,
]
lib.pichon_filter_gt_i64.restype = c_size_t

lib.pichon_filter_gt_f64.argtypes = [
    POINTER(c_double),
    c_size_t,
    POINTER(c_double),
    c_double,
]
lib.pichon_filter_gt_f64.restype = c_size_t

# =============================================================================
# Filter: less than
# =============================================================================

lib.pichon_filter_lt_i32.argtypes = [
    POINTER(c_int32),
    c_size_t,
    POINTER(c_int32),
    c_int32,
]
lib.pichon_filter_lt_i32.restype = c_size_t

lib.pichon_filter_lt_i64.argtypes = [
    POINTER(c_int64),
    c_size_t,
    POINTER(c_int64),
    c_int64,
]
lib.pichon_filter_lt_i64.restype = c_size_t

lib.pichon_filter_lt_f64.argtypes = [
    POINTER(c_double),
    c_size_t,
    POINTER(c_double),
    c_double,
]
lib.pichon_filter_lt_f64.restype = c_size_t

# =============================================================================
# Map: binary add/sub/mul
# =============================================================================

lib.pichon_add_i32.argtypes = [
    POINTER(c_int32),
    POINTER(c_int32),
    c_size_t,
    POINTER(c_int32),
]
lib.pichon_add_i32.restype = None

lib.pichon_add_i64.argtypes = [
    POINTER(c_int64),
    POINTER(c_int64),
    c_size_t,
    POINTER(c_int64),
]
lib.pichon_add_i64.restype = None

lib.pichon_add_f64.argtypes = [
    POINTER(c_double),
    POINTER(c_double),
    c_size_t,
    POINTER(c_double),
]
lib.pichon_add_f64.restype = None

lib.pichon_sub_i32.argtypes = [
    POINTER(c_int32),
    POINTER(c_int32),
    c_size_t,
    POINTER(c_int32),
]
lib.pichon_sub_i32.restype = None

lib.pichon_sub_i64.argtypes = [
    POINTER(c_int64),
    POINTER(c_int64),
    c_size_t,
    POINTER(c_int64),
]
lib.pichon_sub_i64.restype = None

lib.pichon_sub_f64.argtypes = [
    POINTER(c_double),
    POINTER(c_double),
    c_size_t,
    POINTER(c_double),
]
lib.pichon_sub_f64.restype = None

lib.pichon_mul_i32.argtypes = [
    POINTER(c_int32),
    POINTER(c_int32),
    c_size_t,
    POINTER(c_int32),
]
lib.pichon_mul_i32.restype = None

lib.pichon_mul_i64.argtypes = [
    POINTER(c_int64),
    POINTER(c_int64),
    c_size_t,
    POINTER(c_int64),
]
lib.pichon_mul_i64.restype = None

lib.pichon_mul_f64.argtypes = [
    POINTER(c_double),
    POINTER(c_double),
    c_size_t,
    POINTER(c_double),
]
lib.pichon_mul_f64.restype = None

# =============================================================================
# Map: scalar add/sub/mul
# =============================================================================

lib.pichon_add_s_i32.argtypes = [POINTER(c_int32), c_size_t, c_int32, POINTER(c_int32)]
lib.pichon_add_s_i32.restype = None

lib.pichon_add_s_i64.argtypes = [POINTER(c_int64), c_size_t, c_int64, POINTER(c_int64)]
lib.pichon_add_s_i64.restype = None

lib.pichon_add_s_f64.argtypes = [
    POINTER(c_double),
    c_size_t,
    c_double,
    POINTER(c_double),
]
lib.pichon_add_s_f64.restype = None

lib.pichon_sub_s_i32.argtypes = [POINTER(c_int32), c_size_t, c_int32, POINTER(c_int32)]
lib.pichon_sub_s_i32.restype = None

lib.pichon_sub_s_i64.argtypes = [POINTER(c_int64), c_size_t, c_int64, POINTER(c_int64)]
lib.pichon_sub_s_i64.restype = None

lib.pichon_sub_s_f64.argtypes = [
    POINTER(c_double),
    c_size_t,
    c_double,
    POINTER(c_double),
]
lib.pichon_sub_s_f64.restype = None

lib.pichon_mul_s_i32.argtypes = [POINTER(c_int32), c_size_t, c_int32, POINTER(c_int32)]
lib.pichon_mul_s_i32.restype = None

lib.pichon_mul_s_i64.argtypes = [POINTER(c_int64), c_size_t, c_int64, POINTER(c_int64)]
lib.pichon_mul_s_i64.restype = None

lib.pichon_mul_s_f64.argtypes = [
    POINTER(c_double),
    c_size_t,
    c_double,
    POINTER(c_double),
]
lib.pichon_mul_s_f64.restype = None

# =============================================================================
# Fusion: sum_gt / sum_lt
# =============================================================================

lib.pichon_sum_gt_i32.argtypes = [POINTER(c_int32), c_size_t, c_int32]
lib.pichon_sum_gt_i32.restype = c_int64

lib.pichon_sum_gt_i64.argtypes = [POINTER(c_int64), c_size_t, c_int64]
lib.pichon_sum_gt_i64.restype = c_int64

lib.pichon_sum_gt_f64.argtypes = [POINTER(c_double), c_size_t, c_double]
lib.pichon_sum_gt_f64.restype = c_double

lib.pichon_sum_lt_i32.argtypes = [POINTER(c_int32), c_size_t, c_int32]
lib.pichon_sum_lt_i32.restype = c_int64

lib.pichon_sum_lt_i64.argtypes = [POINTER(c_int64), c_size_t, c_int64]
lib.pichon_sum_lt_i64.restype = c_int64

lib.pichon_sum_lt_f64.argtypes = [POINTER(c_double), c_size_t, c_double]
lib.pichon_sum_lt_f64.restype = c_double

# =============================================================================
# Fusion: count_gt / count_lt
# =============================================================================

lib.pichon_count_gt_i32.argtypes = [POINTER(c_int32), c_size_t, c_int32]
lib.pichon_count_gt_i32.restype = c_size_t

lib.pichon_count_gt_i64.argtypes = [POINTER(c_int64), c_size_t, c_int64]
lib.pichon_count_gt_i64.restype = c_size_t

lib.pichon_count_gt_f64.argtypes = [POINTER(c_double), c_size_t, c_double]
lib.pichon_count_gt_f64.restype = c_size_t

lib.pichon_count_lt_i32.argtypes = [POINTER(c_int32), c_size_t, c_int32]
lib.pichon_count_lt_i32.restype = c_size_t

lib.pichon_count_lt_i64.argtypes = [POINTER(c_int64), c_size_t, c_int64]
lib.pichon_count_lt_i64.restype = c_size_t

lib.pichon_count_lt_f64.argtypes = [POINTER(c_double), c_size_t, c_double]
lib.pichon_count_lt_f64.restype = c_size_t

# =============================================================================
# Fusion: min_gt / min_lt
# =============================================================================

lib.pichon_min_gt_i32.argtypes = [POINTER(c_int32), c_size_t, c_int32]
lib.pichon_min_gt_i32.restype = c_int32

lib.pichon_min_gt_i64.argtypes = [POINTER(c_int64), c_size_t, c_int64]
lib.pichon_min_gt_i64.restype = c_int64

lib.pichon_min_gt_f64.argtypes = [POINTER(c_double), c_size_t, c_double]
lib.pichon_min_gt_f64.restype = c_double

lib.pichon_min_lt_i32.argtypes = [POINTER(c_int32), c_size_t, c_int32]
lib.pichon_min_lt_i32.restype = c_int32

lib.pichon_min_lt_i64.argtypes = [POINTER(c_int64), c_size_t, c_int64]
lib.pichon_min_lt_i64.restype = c_int64

lib.pichon_min_lt_f64.argtypes = [POINTER(c_double), c_size_t, c_double]
lib.pichon_min_lt_f64.restype = c_double

# =============================================================================
# Fusion: max_gt / max_lt
# =============================================================================

lib.pichon_max_gt_i32.argtypes = [POINTER(c_int32), c_size_t, c_int32]
lib.pichon_max_gt_i32.restype = c_int32

lib.pichon_max_gt_i64.argtypes = [POINTER(c_int64), c_size_t, c_int64]
lib.pichon_max_gt_i64.restype = c_int64

lib.pichon_max_gt_f64.argtypes = [POINTER(c_double), c_size_t, c_double]
lib.pichon_max_gt_f64.restype = c_double

lib.pichon_max_lt_i32.argtypes = [POINTER(c_int32), c_size_t, c_int32]
lib.pichon_max_lt_i32.restype = c_int32

lib.pichon_max_lt_i64.argtypes = [POINTER(c_int64), c_size_t, c_int64]
lib.pichon_max_lt_i64.restype = c_int64

lib.pichon_max_lt_f64.argtypes = [POINTER(c_double), c_size_t, c_double]
lib.pichon_max_lt_f64.restype = c_double
