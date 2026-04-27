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
The model enables efficient SoA layouts and SIMD execution.

### Benchmark

Reduce (sum) on 10M elements:

| type | Python | Pichon | speedup |
|------|--------|--------|---------|
| i32  | 40 ms  | 2.5 ms | 16x     |
| i64  | 40 ms  | 3.8 ms | 11x     |
| f64  | 30 ms  | 4.0 ms | 8x      |

Fusion (filter > threshold, then reduce) on 10M elements:

**sum_gt**

| type | Python | 2-pass | fusion | speedup |
|------|--------|--------|--------|---------|
| i32  | 171 ms | 4.0 ms | 2.4 ms | 73x     |
| i64  | 174 ms | 11 ms  | 4.2 ms | 41x     |
| f64  | 147 ms | 8.5 ms | 3.9 ms | 38x     |

**min_gt**

| type | Python | 2-pass | fusion | speedup |
|------|--------|--------|--------|---------|
| i32  | 199 ms | 4.9 ms | 2.2 ms | 90x     |
| i64  | 197 ms | 9.3 ms | 6.5 ms | 30x     |
| f64  | 184 ms | 11 ms  | 6.1 ms | 30x     |

**max_gt**

| type | Python | 2-pass | fusion | speedup |
|------|--------|--------|--------|---------|
| i32  | 190 ms | 4.0 ms | 2.1 ms | 91x     |
| i64  | 190 ms | 11 ms  | 6.2 ms | 31x     |
| f64  | 176 ms | 12 ms  | 6.2 ms | 29x     |

Vectorization moves computation into registers. Fusion removes memory traffic.

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
| fusion | `pichon_sum_gt_{i32,i64,f64}`<br>`pichon_sum_lt_{i32,i64,f64}`<br>`pichon_count_gt_{i32,i64,f64}`<br>`pichon_count_lt_{i32,i64,f64}`<br>`pichon_min_gt_{i32,i64,f64}`<br>`pichon_min_lt_{i32,i64,f64}`<br>`pichon_max_gt_{i32,i64,f64}`<br>`pichon_max_lt_{i32,i64,f64}` |

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
├── simd.zig     # SIMD primitives
├── reduce.zig   # sum, min, max
├── filter.zig   # filter_gt
├── map.zig      # add, sub, mul, add_s, sub_s, mul_s
├── fusion.zig   # sum_gt/lt, count_gt/lt, min_gt/lt, max_gt/lt
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
