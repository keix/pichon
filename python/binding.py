"""
Pichon Python binding via ctypes.
"""

from ctypes import CDLL, POINTER, c_int32, c_int64, c_double, c_size_t
from pathlib import Path

_lib_path = Path(__file__).parent.parent / "zig-out" / "lib" / "libpichon.so"
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

lib.pichon_filter_gt_i32.argtypes = [POINTER(c_int32), c_size_t, POINTER(c_int32), c_int32]
lib.pichon_filter_gt_i32.restype = c_size_t

lib.pichon_filter_gt_i64.argtypes = [POINTER(c_int64), c_size_t, POINTER(c_int64), c_int64]
lib.pichon_filter_gt_i64.restype = c_size_t

lib.pichon_filter_gt_f64.argtypes = [POINTER(c_double), c_size_t, POINTER(c_double), c_double]
lib.pichon_filter_gt_f64.restype = c_size_t

# =============================================================================
# Map: binary add/sub/mul
# =============================================================================

lib.pichon_add_i32.argtypes = [POINTER(c_int32), POINTER(c_int32), c_size_t, POINTER(c_int32)]
lib.pichon_add_i32.restype = None

lib.pichon_add_i64.argtypes = [POINTER(c_int64), POINTER(c_int64), c_size_t, POINTER(c_int64)]
lib.pichon_add_i64.restype = None

lib.pichon_add_f64.argtypes = [POINTER(c_double), POINTER(c_double), c_size_t, POINTER(c_double)]
lib.pichon_add_f64.restype = None

lib.pichon_sub_i32.argtypes = [POINTER(c_int32), POINTER(c_int32), c_size_t, POINTER(c_int32)]
lib.pichon_sub_i32.restype = None

lib.pichon_sub_i64.argtypes = [POINTER(c_int64), POINTER(c_int64), c_size_t, POINTER(c_int64)]
lib.pichon_sub_i64.restype = None

lib.pichon_sub_f64.argtypes = [POINTER(c_double), POINTER(c_double), c_size_t, POINTER(c_double)]
lib.pichon_sub_f64.restype = None

lib.pichon_mul_i32.argtypes = [POINTER(c_int32), POINTER(c_int32), c_size_t, POINTER(c_int32)]
lib.pichon_mul_i32.restype = None

lib.pichon_mul_i64.argtypes = [POINTER(c_int64), POINTER(c_int64), c_size_t, POINTER(c_int64)]
lib.pichon_mul_i64.restype = None

lib.pichon_mul_f64.argtypes = [POINTER(c_double), POINTER(c_double), c_size_t, POINTER(c_double)]
lib.pichon_mul_f64.restype = None

# =============================================================================
# Map: scalar add/sub/mul
# =============================================================================

lib.pichon_add_s_i32.argtypes = [POINTER(c_int32), c_size_t, c_int32, POINTER(c_int32)]
lib.pichon_add_s_i32.restype = None

lib.pichon_add_s_i64.argtypes = [POINTER(c_int64), c_size_t, c_int64, POINTER(c_int64)]
lib.pichon_add_s_i64.restype = None

lib.pichon_add_s_f64.argtypes = [POINTER(c_double), c_size_t, c_double, POINTER(c_double)]
lib.pichon_add_s_f64.restype = None

lib.pichon_sub_s_i32.argtypes = [POINTER(c_int32), c_size_t, c_int32, POINTER(c_int32)]
lib.pichon_sub_s_i32.restype = None

lib.pichon_sub_s_i64.argtypes = [POINTER(c_int64), c_size_t, c_int64, POINTER(c_int64)]
lib.pichon_sub_s_i64.restype = None

lib.pichon_sub_s_f64.argtypes = [POINTER(c_double), c_size_t, c_double, POINTER(c_double)]
lib.pichon_sub_s_f64.restype = None

lib.pichon_mul_s_i32.argtypes = [POINTER(c_int32), c_size_t, c_int32, POINTER(c_int32)]
lib.pichon_mul_s_i32.restype = None

lib.pichon_mul_s_i64.argtypes = [POINTER(c_int64), c_size_t, c_int64, POINTER(c_int64)]
lib.pichon_mul_s_i64.restype = None

lib.pichon_mul_s_f64.argtypes = [POINTER(c_double), c_size_t, c_double, POINTER(c_double)]
lib.pichon_mul_s_f64.restype = None


# =============================================================================
# Demo
# =============================================================================

if __name__ == "__main__":
    # reduce
    data = (c_int32 * 5)(10, 20, 30, 40, 50)
    print(f"sum: {lib.pichon_sum_i32(data, 5)}")
    print(f"min: {lib.pichon_min_i32(data, 5)}")
    print(f"max: {lib.pichon_max_i32(data, 5)}")

    # filter
    out = (c_int32 * 5)()
    count = lib.pichon_filter_gt_i32(data, 5, out, 25)
    print(f"filter > 25: {list(out[:count])}")

    # map: buffer reuse
    a = (c_int32 * 3)(100, 200, 300)
    b = (c_int32 * 3)(10, 20, 30)
    out = (c_int32 * 3)()

    lib.pichon_mul_i32(a, b, 3, out)
    print(f"mul: {list(out)}")

    lib.pichon_add_s_i32(a, 3, 5, out)
    print(f"add_s: {list(out)}")

    # map: in-place
    lib.pichon_mul_s_i32(a, 3, 2, a)
    print(f"in-place *2: {list(a)}")
