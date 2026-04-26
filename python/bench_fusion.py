"""
Benchmark: Fusion vs 2-pass (filter + reduce)
"""

import time
from ctypes import c_int32, c_int64, c_double
from binding import lib

N = 10_000_000
THRESHOLD = N // 2  # Filter ~50% of elements


# =============================================================================
# sum_gt benchmarks
# =============================================================================

def bench_sum_i32():
    py_list = list(range(N))
    c_array = (c_int32 * N)(*py_list)
    out = (c_int32 * N)()
    threshold = THRESHOLD

    # Python: filter + sum
    t0 = time.perf_counter()
    py_result = sum(x for x in py_list if x > threshold)
    py_time = time.perf_counter() - t0

    # Pichon 2-pass: filter_gt + sum
    t0 = time.perf_counter()
    count = lib.pichon_filter_gt_i32(c_array, N, out, threshold)
    two_pass_result = lib.pichon_sum_i32(out, count)
    two_pass_time = time.perf_counter() - t0

    # Pichon fusion: sum_gt
    t0 = time.perf_counter()
    fusion_result = lib.pichon_sum_gt_i32(c_array, N, threshold)
    fusion_time = time.perf_counter() - t0

    return py_time, two_pass_time, fusion_time, py_result, two_pass_result, fusion_result


def bench_sum_i64():
    py_list = list(range(N))
    c_array = (c_int64 * N)(*py_list)
    out = (c_int64 * N)()
    threshold = THRESHOLD

    t0 = time.perf_counter()
    py_result = sum(x for x in py_list if x > threshold)
    py_time = time.perf_counter() - t0

    t0 = time.perf_counter()
    count = lib.pichon_filter_gt_i64(c_array, N, out, threshold)
    two_pass_result = lib.pichon_sum_i64(out, count)
    two_pass_time = time.perf_counter() - t0

    t0 = time.perf_counter()
    fusion_result = lib.pichon_sum_gt_i64(c_array, N, threshold)
    fusion_time = time.perf_counter() - t0

    return py_time, two_pass_time, fusion_time, py_result, two_pass_result, fusion_result


def bench_sum_f64():
    py_list = [float(i) for i in range(N)]
    c_array = (c_double * N)(*py_list)
    out = (c_double * N)()
    threshold = float(THRESHOLD)

    t0 = time.perf_counter()
    py_result = sum(x for x in py_list if x > threshold)
    py_time = time.perf_counter() - t0

    t0 = time.perf_counter()
    count = lib.pichon_filter_gt_f64(c_array, N, out, threshold)
    two_pass_result = lib.pichon_sum_f64(out, count)
    two_pass_time = time.perf_counter() - t0

    t0 = time.perf_counter()
    fusion_result = lib.pichon_sum_gt_f64(c_array, N, threshold)
    fusion_time = time.perf_counter() - t0

    return py_time, two_pass_time, fusion_time, py_result, two_pass_result, fusion_result


# =============================================================================
# min_gt benchmarks
# =============================================================================

def bench_min_i32():
    py_list = list(range(N))
    c_array = (c_int32 * N)(*py_list)
    out = (c_int32 * N)()
    threshold = THRESHOLD

    t0 = time.perf_counter()
    py_result = min(x for x in py_list if x > threshold)
    py_time = time.perf_counter() - t0

    t0 = time.perf_counter()
    count = lib.pichon_filter_gt_i32(c_array, N, out, threshold)
    two_pass_result = lib.pichon_min_i32(out, count)
    two_pass_time = time.perf_counter() - t0

    t0 = time.perf_counter()
    fusion_result = lib.pichon_min_gt_i32(c_array, N, threshold)
    fusion_time = time.perf_counter() - t0

    return py_time, two_pass_time, fusion_time, py_result, two_pass_result, fusion_result


def bench_min_i64():
    py_list = list(range(N))
    c_array = (c_int64 * N)(*py_list)
    out = (c_int64 * N)()
    threshold = THRESHOLD

    t0 = time.perf_counter()
    py_result = min(x for x in py_list if x > threshold)
    py_time = time.perf_counter() - t0

    t0 = time.perf_counter()
    count = lib.pichon_filter_gt_i64(c_array, N, out, threshold)
    two_pass_result = lib.pichon_min_i64(out, count)
    two_pass_time = time.perf_counter() - t0

    t0 = time.perf_counter()
    fusion_result = lib.pichon_min_gt_i64(c_array, N, threshold)
    fusion_time = time.perf_counter() - t0

    return py_time, two_pass_time, fusion_time, py_result, two_pass_result, fusion_result


def bench_min_f64():
    py_list = [float(i) for i in range(N)]
    c_array = (c_double * N)(*py_list)
    out = (c_double * N)()
    threshold = float(THRESHOLD)

    t0 = time.perf_counter()
    py_result = min(x for x in py_list if x > threshold)
    py_time = time.perf_counter() - t0

    t0 = time.perf_counter()
    count = lib.pichon_filter_gt_f64(c_array, N, out, threshold)
    two_pass_result = lib.pichon_min_f64(out, count)
    two_pass_time = time.perf_counter() - t0

    t0 = time.perf_counter()
    fusion_result = lib.pichon_min_gt_f64(c_array, N, threshold)
    fusion_time = time.perf_counter() - t0

    return py_time, two_pass_time, fusion_time, py_result, two_pass_result, fusion_result


# =============================================================================
# max_gt benchmarks
# =============================================================================

def bench_max_i32():
    py_list = list(range(N))
    c_array = (c_int32 * N)(*py_list)
    out = (c_int32 * N)()
    threshold = THRESHOLD

    t0 = time.perf_counter()
    py_result = max(x for x in py_list if x > threshold)
    py_time = time.perf_counter() - t0

    t0 = time.perf_counter()
    count = lib.pichon_filter_gt_i32(c_array, N, out, threshold)
    two_pass_result = lib.pichon_max_i32(out, count)
    two_pass_time = time.perf_counter() - t0

    t0 = time.perf_counter()
    fusion_result = lib.pichon_max_gt_i32(c_array, N, threshold)
    fusion_time = time.perf_counter() - t0

    return py_time, two_pass_time, fusion_time, py_result, two_pass_result, fusion_result


def bench_max_i64():
    py_list = list(range(N))
    c_array = (c_int64 * N)(*py_list)
    out = (c_int64 * N)()
    threshold = THRESHOLD

    t0 = time.perf_counter()
    py_result = max(x for x in py_list if x > threshold)
    py_time = time.perf_counter() - t0

    t0 = time.perf_counter()
    count = lib.pichon_filter_gt_i64(c_array, N, out, threshold)
    two_pass_result = lib.pichon_max_i64(out, count)
    two_pass_time = time.perf_counter() - t0

    t0 = time.perf_counter()
    fusion_result = lib.pichon_max_gt_i64(c_array, N, threshold)
    fusion_time = time.perf_counter() - t0

    return py_time, two_pass_time, fusion_time, py_result, two_pass_result, fusion_result


def bench_max_f64():
    py_list = [float(i) for i in range(N)]
    c_array = (c_double * N)(*py_list)
    out = (c_double * N)()
    threshold = float(THRESHOLD)

    t0 = time.perf_counter()
    py_result = max(x for x in py_list if x > threshold)
    py_time = time.perf_counter() - t0

    t0 = time.perf_counter()
    count = lib.pichon_filter_gt_f64(c_array, N, out, threshold)
    two_pass_result = lib.pichon_max_f64(out, count)
    two_pass_time = time.perf_counter() - t0

    t0 = time.perf_counter()
    fusion_result = lib.pichon_max_gt_f64(c_array, N, threshold)
    fusion_time = time.perf_counter() - t0

    return py_time, two_pass_time, fusion_time, py_result, two_pass_result, fusion_result


# =============================================================================
# Main
# =============================================================================

def run_benchmarks(title, benchmarks):
    print(f"\n{title}")
    print(f"{'type':<4} | {'Python':>10} | {'2-pass':>10} | {'fusion':>10} | {'2p/fusion':>9} | {'verify'}")
    print("-" * 70)

    for name, bench in benchmarks:
        py_t, two_t, fus_t, py_r, two_r, fus_r = bench()
        match = "ok" if py_r == two_r == fus_r else "MISMATCH"
        speedup = two_t / fus_t
        print(f"{name:<4} | {py_t*1000:>8.2f}ms | {two_t*1000:>8.2f}ms | {fus_t*1000:>8.2f}ms | {speedup:>8.2f}x | {match}")


if __name__ == "__main__":
    print(f"N = {N:,}, threshold = {THRESHOLD:,} (filter ~50%)")

    run_benchmarks("sum_gt (filter > threshold, then sum)", [
        ("i32", bench_sum_i32),
        ("i64", bench_sum_i64),
        ("f64", bench_sum_f64),
    ])

    run_benchmarks("min_gt (filter > threshold, then min)", [
        ("i32", bench_min_i32),
        ("i64", bench_min_i64),
        ("f64", bench_min_f64),
    ])

    run_benchmarks("max_gt (filter > threshold, then max)", [
        ("i32", bench_max_i32),
        ("i64", bench_max_i64),
        ("f64", bench_max_f64),
    ])
