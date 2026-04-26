"""
Simple benchmark: Python vs Pichon
"""

import time
from ctypes import c_int32
from binding import lib

N = 10_000_000

# Prepare data
py_list = list(range(N))
c_array = (c_int32 * N)(*py_list)

# Python sum (list)
t0 = time.perf_counter()
py_sum = sum(py_list)
t1 = time.perf_counter()
py_time = t1 - t0

# Pichon sum
t0 = time.perf_counter()
pichon_sum = lib.pichon_sum_i32(c_array, N)
t1 = time.perf_counter()
pichon_time = t1 - t0

print(f"N = {N:,}")
print(f"Python:  {py_time*1000:.2f} ms  (result: {py_sum})")
print(f"Pichon:  {pichon_time*1000:.2f} ms  (result: {pichon_sum})")
print(f"Speedup: {py_time/pichon_time:.1f}x")
