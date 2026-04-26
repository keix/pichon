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
# Fusion: sum_gt (filter > threshold, then sum)
# =============================================================================

lib.pichon_sum_gt_i32.argtypes = [POINTER(c_int32), c_size_t, c_int32]
lib.pichon_sum_gt_i32.restype = c_int64

lib.pichon_sum_gt_i64.argtypes = [POINTER(c_int64), c_size_t, c_int64]
lib.pichon_sum_gt_i64.restype = c_int64

lib.pichon_sum_gt_f64.argtypes = [POINTER(c_double), c_size_t, c_double]
lib.pichon_sum_gt_f64.restype = c_double

# =============================================================================
# Fusion: sum_lt (filter < threshold, then sum)
# =============================================================================

lib.pichon_sum_lt_i32.argtypes = [POINTER(c_int32), c_size_t, c_int32]
lib.pichon_sum_lt_i32.restype = c_int64

lib.pichon_sum_lt_i64.argtypes = [POINTER(c_int64), c_size_t, c_int64]
lib.pichon_sum_lt_i64.restype = c_int64

lib.pichon_sum_lt_f64.argtypes = [POINTER(c_double), c_size_t, c_double]
lib.pichon_sum_lt_f64.restype = c_double

# =============================================================================
# Fusion: count_gt (count where > threshold)
# =============================================================================

lib.pichon_count_gt_i32.argtypes = [POINTER(c_int32), c_size_t, c_int32]
lib.pichon_count_gt_i32.restype = c_size_t

lib.pichon_count_gt_i64.argtypes = [POINTER(c_int64), c_size_t, c_int64]
lib.pichon_count_gt_i64.restype = c_size_t

lib.pichon_count_gt_f64.argtypes = [POINTER(c_double), c_size_t, c_double]
lib.pichon_count_gt_f64.restype = c_size_t

# =============================================================================
# Fusion: count_lt (count where < threshold)
# =============================================================================

lib.pichon_count_lt_i32.argtypes = [POINTER(c_int32), c_size_t, c_int32]
lib.pichon_count_lt_i32.restype = c_size_t

lib.pichon_count_lt_i64.argtypes = [POINTER(c_int64), c_size_t, c_int64]
lib.pichon_count_lt_i64.restype = c_size_t

lib.pichon_count_lt_f64.argtypes = [POINTER(c_double), c_size_t, c_double]
lib.pichon_count_lt_f64.restype = c_size_t

# =============================================================================
# Fusion: min_gt (filter > threshold, then min)
# =============================================================================

lib.pichon_min_gt_i32.argtypes = [POINTER(c_int32), c_size_t, c_int32]
lib.pichon_min_gt_i32.restype = c_int32

lib.pichon_min_gt_i64.argtypes = [POINTER(c_int64), c_size_t, c_int64]
lib.pichon_min_gt_i64.restype = c_int64

lib.pichon_min_gt_f64.argtypes = [POINTER(c_double), c_size_t, c_double]
lib.pichon_min_gt_f64.restype = c_double

# =============================================================================
# Fusion: min_lt (filter < threshold, then min)
# =============================================================================

lib.pichon_min_lt_i32.argtypes = [POINTER(c_int32), c_size_t, c_int32]
lib.pichon_min_lt_i32.restype = c_int32

lib.pichon_min_lt_i64.argtypes = [POINTER(c_int64), c_size_t, c_int64]
lib.pichon_min_lt_i64.restype = c_int64

lib.pichon_min_lt_f64.argtypes = [POINTER(c_double), c_size_t, c_double]
lib.pichon_min_lt_f64.restype = c_double

# =============================================================================
# Fusion: max_gt (filter > threshold, then max)
# =============================================================================

lib.pichon_max_gt_i32.argtypes = [POINTER(c_int32), c_size_t, c_int32]
lib.pichon_max_gt_i32.restype = c_int32

lib.pichon_max_gt_i64.argtypes = [POINTER(c_int64), c_size_t, c_int64]
lib.pichon_max_gt_i64.restype = c_int64

lib.pichon_max_gt_f64.argtypes = [POINTER(c_double), c_size_t, c_double]
lib.pichon_max_gt_f64.restype = c_double

# =============================================================================
# Fusion: max_lt (filter < threshold, then max)
# =============================================================================

lib.pichon_max_lt_i32.argtypes = [POINTER(c_int32), c_size_t, c_int32]
lib.pichon_max_lt_i32.restype = c_int32

lib.pichon_max_lt_i64.argtypes = [POINTER(c_int64), c_size_t, c_int64]
lib.pichon_max_lt_i64.restype = c_int64

lib.pichon_max_lt_f64.argtypes = [POINTER(c_double), c_size_t, c_double]
lib.pichon_max_lt_f64.restype = c_double


# =============================================================================
# Demo
# =============================================================================

if __name__ == "__main__":
    print("=== i32 ===")
    data = (c_int32 * 5)(10, 20, 30, 40, 50)
    print(f"sum: {lib.pichon_sum_i32(data, 5)}")
    print(f"min: {lib.pichon_min_i32(data, 5)}")
    print(f"max: {lib.pichon_max_i32(data, 5)}")

    out = (c_int32 * 5)()
    count = lib.pichon_filter_gt_i32(data, 5, out, 25)
    print(f"filter > 25: {list(out[:count])}")

    a = (c_int32 * 3)(100, 200, 300)
    b = (c_int32 * 3)(10, 20, 30)
    out3 = (c_int32 * 3)()
    lib.pichon_mul_i32(a, b, 3, out3)
    print(f"mul: {list(out3)}")

    lib.pichon_mul_s_i32(a, 3, 2, a)
    print(f"in-place *2: {list(a)}")

    print("\n=== i64 ===")
    data64 = (c_int64 * 3)(10_000_000_000, 20_000_000_000, 30_000_000_000)
    print(f"sum: {lib.pichon_sum_i64(data64, 3)}")
    print(f"min: {lib.pichon_min_i64(data64, 3)}")
    print(f"max: {lib.pichon_max_i64(data64, 3)}")

    a64 = (c_int64 * 2)(1_000_000_000, 2_000_000_000)
    b64 = (c_int64 * 2)(3, 4)
    out64 = (c_int64 * 2)()
    lib.pichon_mul_i64(a64, b64, 2, out64)
    print(f"mul: {list(out64)}")

    print("\n=== f64 ===")
    dataf = (c_double * 4)(1.5, 2.5, 3.5, 4.5)
    print(f"sum: {lib.pichon_sum_f64(dataf, 4)}")
    print(f"min: {lib.pichon_min_f64(dataf, 4)}")
    print(f"max: {lib.pichon_max_f64(dataf, 4)}")

    af = (c_double * 3)(100.0, 200.0, 300.0)
    outf = (c_double * 3)()
    lib.pichon_mul_s_f64(af, 3, 1.1, outf)
    print(f"mul_s *1.1: {list(outf)}")

    print("\n=== Fusion ===")
    data = (c_int32 * 5)(10, 20, 30, 40, 50)
    print(f"sum_gt(25): {lib.pichon_sum_gt_i32(data, 5, 25)}")  # 30+40+50=120
    print(f"count_gt(25): {lib.pichon_count_gt_i32(data, 5, 25)}")  # 3
    print(f"min_gt(25): {lib.pichon_min_gt_i32(data, 5, 25)}")  # 30
    print(f"max_lt(35): {lib.pichon_max_lt_i32(data, 5, 35)}")  # 30
