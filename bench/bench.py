"""
Benchmark: Python vs Pichon (i32, i64, f64)
"""

import sys

sys.path.insert(0, "python")

import time
from ctypes import c_int32, c_int64, c_double
from binding import lib

N = 10_000_000


def bench_i32():
    py_list = list(range(N))
    c_array = (c_int32 * N)(*py_list)

    t0 = time.perf_counter()
    py_sum = sum(py_list)
    py_time = time.perf_counter() - t0

    t0 = time.perf_counter()
    pichon_sum = lib.pichon_sum_i32(c_array, N)
    pichon_time = time.perf_counter() - t0

    return py_time, pichon_time, py_sum, pichon_sum


def bench_i64():
    py_list = list(range(N))
    c_array = (c_int64 * N)(*py_list)

    t0 = time.perf_counter()
    py_sum = sum(py_list)
    py_time = time.perf_counter() - t0

    t0 = time.perf_counter()
    pichon_sum = lib.pichon_sum_i64(c_array, N)
    pichon_time = time.perf_counter() - t0

    return py_time, pichon_time, py_sum, pichon_sum


def bench_f64():
    py_list = [float(i) for i in range(N)]
    c_array = (c_double * N)(*py_list)

    t0 = time.perf_counter()
    py_sum = sum(py_list)
    py_time = time.perf_counter() - t0

    t0 = time.perf_counter()
    pichon_sum = lib.pichon_sum_f64(c_array, N)
    pichon_time = time.perf_counter() - t0

    return py_time, pichon_time, py_sum, pichon_sum


if __name__ == "__main__":
    print(f"N = {N:,}\n")

    for name, bench in [("i32", bench_i32), ("i64", bench_i64), ("f64", bench_f64)]:
        py_t, pichon_t, py_r, pichon_r = bench()
        match = "ok" if py_r == pichon_r else "MISMATCH"
        print(
            f"{name}: Python {py_t * 1000:6.2f} ms | Pichon {pichon_t * 1000:5.2f} ms | {py_t / pichon_t:5.1f}x | {match}"
        )
