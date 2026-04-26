"""
Pichon Python binding via ctypes.

Usage:
    from binding import lib, c_int32, c_int64, c_double, c_size_t

    # Create array
    data = (c_int32 * 5)(10, 20, 30, 40, 50)

    # Sum
    total = lib.pichon_sum_i32(data, len(data))
    print(total)  # 150

    # Filter
    out = (c_int32 * 5)()
    count = lib.pichon_filter_gt_i32(data, len(data), out, 25)
    print(list(out[:count]))  # [30, 40, 50]
"""

from ctypes import (
    CDLL,
    POINTER,
    c_int32,
    c_int64,
    c_double,
    c_size_t,
)
from pathlib import Path

# Find library
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
# Reduce: min/max
# =============================================================================

lib.pichon_min_i32.argtypes = [POINTER(c_int32), c_size_t]
lib.pichon_min_i32.restype = c_int32

lib.pichon_max_i32.argtypes = [POINTER(c_int32), c_size_t]
lib.pichon_max_i32.restype = c_int32

lib.pichon_min_i64.argtypes = [POINTER(c_int64), c_size_t]
lib.pichon_min_i64.restype = c_int64

lib.pichon_max_i64.argtypes = [POINTER(c_int64), c_size_t]
lib.pichon_max_i64.restype = c_int64

lib.pichon_min_f64.argtypes = [POINTER(c_double), c_size_t]
lib.pichon_min_f64.restype = c_double

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
# Convenience functions
# =============================================================================

def sum_i32(data: list[int]) -> int:
    """Sum a list of integers."""
    arr = (c_int32 * len(data))(*data)
    return lib.pichon_sum_i32(arr, len(data))


def filter_gt_i32(data: list[int], threshold: int) -> list[int]:
    """Filter integers greater than threshold."""
    arr = (c_int32 * len(data))(*data)
    out = (c_int32 * len(data))()
    count = lib.pichon_filter_gt_i32(arr, len(data), out, threshold)
    return list(out[:count])


if __name__ == "__main__":
    # Demo
    data = [10, 50, 30, 80, 20]

    print(f"Data: {data}")
    print(f"Sum: {sum_i32(data)}")
    print(f"Filter > 25: {filter_gt_i32(data, 25)}")
