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
| i32  | 38 ms  | 1.9 ms | 20x     |
| i64  | 38 ms  | 3.5 ms | 11x     |
| f64  | 28 ms  | 3.5 ms | 8x      |

Fusion (filter > threshold, then reduce) on 10M elements:

**sum_gt**

| type | Python | 2-pass | fusion | speedup |
|------|--------|--------|--------|---------|
| i32  | 170 ms | 4.0 ms | 2.2 ms | 77x     |
| i64  | 170 ms | 7.3 ms | 3.6 ms | 47x     |
| f64  | 147 ms | 8.0 ms | 3.5 ms | 42x     |

**min_gt**

| type | Python | 2-pass | fusion | speedup |
|------|--------|--------|--------|---------|
| i32  | 195 ms | 3.9 ms | 2.0 ms | 98x     |
| i64  | 195 ms | 8.0 ms | 4.5 ms | 43x     |
| f64  | 182 ms | 10 ms  | 4.9 ms | 37x     |

**max_gt**

| type | Python | 2-pass | fusion | speedup |
|------|--------|--------|--------|---------|
| i32  | 190 ms | 3.9 ms | 2.0 ms | 95x     |
| i64  | 190 ms | 7.8 ms | 4.5 ms | 42x     |
| f64  | 175 ms | 9.7 ms | 4.8 ms | 37x     |

Vectorization moves computation into registers. Fusion removes memory traffic.

## Contract
- All operations require contiguous memory.
- Input arrays must have identical lengths.
- In-place operations are only allowed where explicitly documented.
- The C layer performs no bounds checking.
- Violating these conditions results in undefined behavior.

## Spec / Testing
Tests define and verify observable behavior.

Run:

```bash
zig build test --summary all
```

The test suite covers:

- behavior (correctness)
- ABI stability
- codegen assumptions

## Build

```bash
zig build -Doptimize=ReleaseFast
```

## API
Low-level bindings are available under `pichon._native` for advanced use.

| Category | Functions |
|----------|-----------|
| reduce | `sum_{i32,i64,f64}` `min_{i32,i64,f64}` `max_{i32,i64,f64}` |
| filter | `filter_gt_{i32,i64,f64}` `filter_lt_{i32,i64,f64}` |
| map    | `add_{i32,i64,f64}` `sub_{i32,i64,f64}` `mul_{i32,i64,f64}` |
| map (scalar) | `add_s_{i32,i64,f64}` `sub_s_{i32,i64,f64}` `mul_s_{i32,i64,f64}` |
| fusion | `sum_gt_{i32,i64,f64}` `sum_lt_{i32,i64,f64}` `count_gt_{i32,i64,f64}` `count_lt_{i32,i64,f64}` `min_gt_{i32,i64,f64}` `min_lt_{i32,i64,f64}` `max_gt_{i32,i64,f64}` `max_lt_{i32,i64,f64}` |

## Usage

```python
import pichon
from ctypes import c_int32

data = (c_int32 * 5)(10, 20, 30, 40, 50)

# reduce
pichon.sum_i32(data)  # 150

# filter
out, count = pichon.filter_gt_i32(data, 25)
print(list(out[:count]))  # [30, 40, 50]

# map
a = (c_int32 * 3)(100, 200, 300)
b = (c_int32 * 3)(10, 20, 30)
print(list(pichon.mul_i32(a, b)))  # [1000, 4000, 9000]

# map scalar
print(list(pichon.mul_s_i32(a, 2)))  # [200, 400, 600]

# fusion (filter + reduce in single pass)
pichon.sum_gt_i32(data, 25)    # 120 (30+40+50)
pichon.count_gt_i32(data, 25)  # 3
```

## Structure

```
src/
├── lib.zig      # entry point
├── simd.zig     # SIMD primitives
├── reduce.zig   # sum, min, max
├── filter.zig   # filter_gt, filter_lt
├── map.zig      # add, sub, mul, add_s, sub_s, mul_s
└── fusion.zig   # sum_gt/lt, count_gt/lt, min_gt/lt, max_gt/lt

include/
└── pichon.h     # C ABI

python/pichon/
├── __init__.py  # public API
└── _native.py   # C ABI binding

bench/           # benchmarks
```

## License
Copyright (c) 2026 Kei Sawamura  
Pichon is licensed under the MIT License.
