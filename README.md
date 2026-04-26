# Pichon (ぴちょん)
Python defines structure. Native code executes.

## What is this
Pichon is an execution engine over contiguous memory.  
It operates on raw memory passed from Python through a C ABI, executing single-pass loops in Zig.

No serialization. No allocation. No I/O.

## Why it's fast
Pichon removes the Python interpreter from the hot loop.

Instead of iterating over Python objects, it operates on contiguous memory using native Zig code.

- No Python bytecode dispatch
- No object overhead
- No pointer chasing
- Single-pass execution

Performance comes from walking memory once.  
The model naturally extends to SoA layouts for improved locality and SIMD.

### Benchmark
These results reflect interpreter overhead, not algorithmic differences.

Summing 10,000,000 elements:

```
i32: Python  50.02 ms | Pichon  1.97 ms | 25.4x
i64: Python  41.68 ms | Pichon  4.08 ms | 10.2x
f64: Python  32.78 ms | Pichon  5.71 ms |  5.7x
```

Fusion vs 2-pass (filter > threshold, then sum):

```
i32: 2-pass  5.21 ms | fusion  2.08 ms | 2.5x
i64: 2-pass  8.90 ms | fusion  4.23 ms | 2.1x
f64: 2-pass  9.62 ms | fusion 10.52 ms | 0.9x
```


Note:
- i32/i64 are memory-bound → fusion reduces memory traffic and improves performance.
- f64 is compute-bound → fusion does not improve performance.

Fusion removes memory traffic, not computation.

## Build

```bash
zig build -Doptimize=ReleaseFast
```

## API

| Category | Functions |
|----------|-----------|
| reduce | `pichon_sum_{i32,i64,f64}`<br>`pichon_min_{i32,i64,f64}`<br>`pichon_max_{i32,i64,f64}` |
| filter | `pichon_filter_gt_{i32,i64,f64}` |
| map    | `pichon_add_{i32,i64,f64}`<br>`pichon_sub_{i32,i64,f64}`<br>`pichon_mul_{i32,i64,f64}` |
| map (scalar) | `pichon_add_s_{i32,i64,f64}`<br>`pichon_sub_s_{i32,i64,f64}`<br>`pichon_mul_s_{i32,i64,f64}` |
| fusion | `pichon_sum_gt_{i32,i64,f64}`<br>`pichon_sum_lt_{i32,i64,f64}`<br>`pichon_count_gt_{i32,i64,f64}`<br>`pichon_count_lt_{i32,i64,f64}` |

## Usage

```python
from python.binding import lib, c_int32

data = (c_int32 * 5)(10, 20, 30, 40, 50)

# reduce
lib.pichon_sum_i32(data, 5)  # 150

# filter
out = (c_int32 * 5)()
count = lib.pichon_filter_gt_i32(data, 5, out, 25)
print(list(out[:count]))  # [30, 40, 50]

# map
a = (c_int32 * 3)(100, 200, 300)
b = (c_int32 * 3)(10, 20, 30)
out = (c_int32 * 3)()
lib.pichon_mul_i32(a, b, 3, out)
print(list(out))  # [1000, 4000, 9000]

# map scalar (in-place)
lib.pichon_mul_s_i32(a, 3, 2, a)
print(list(a))  # [200, 400, 600]

# fusion (filter + reduce in single pass)
lib.pichon_sum_gt_i32(data, 5, 25)    # 120 (30+40+50)
lib.pichon_count_gt_i32(data, 5, 25)  # 3
```

## Structure

```
src/
├── lib.zig      # entry point
├── reduce.zig   # sum, min, max
├── filter.zig   # filter_gt
├── map.zig      # add, sub, mul, add_s, sub_s, mul_s
├── fusion.zig   # sum_gt, sum_lt, count_gt, count_lt
├── layout.zig
└── error.zig

include/
└── pichon.h     # C ABI

python/
├── binding.py   # ctypes binding
└── bench.py     # benchmark
```

## License
Copyright (c) 2026 Kei Sawamura  
Pichon is licensed under the MIT License.
