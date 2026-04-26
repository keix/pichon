# Pichon
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

### Benchmark
Summing 10,000,000 integers:

```
N = 10,000,000
Python:  39.79 ms
Pichon:  2.74 ms
Speedup: 14.5x
```

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

## Usage

```python
from python.binding import lib, c_int32

data = (c_int32 * 5)(10, 20, 30, 40, 50)

# reduce
lib.pichon_sum_i32(data, 5)  # 150

# filter
out = (c_int32 * 5)()
count = lib.pichon_filter_gt_i32(data, 5, out, 25)
# out[:count] = [30, 40, 50]

# map
a = (c_int32 * 3)(100, 200, 300)
b = (c_int32 * 3)(10, 20, 30)
out = (c_int32 * 3)()
lib.pichon_mul_i32(a, b, 3, out)  # [1000, 4000, 9000]

# map scalar (in-place)
lib.pichon_mul_s_i32(a, 3, 2, a)  # [200, 400, 600]
```

## Structure

```
src/
├── lib.zig      # entry point
├── reduce.zig   # sum, min, max
├── filter.zig   # filter_gt
├── map.zig      # add, sub, mul, add_s, sub_s, mul_s
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
