# Pichon
Pichon is a columnar execution engine for contiguous memory.  
It operates on raw memory passed from Python through a C ABI, executing single-pass loops in Zig.

No serialization. No allocation. No I/O.

## Why it is fast
Pichon removes the Python interpreter from the hot loop.

Instead of iterating over Python objects, it operates on contiguous memory
using native Zig code.

- No Python bytecode dispatch
- No object overhead
- No pointer chasing
- Single-pass execution

Performance comes from walking memory once.

## Design

```
Python → C ABI → Zig → result
```

- No serialization
- No allocation (caller provides buffers)
- No I/O

## Scope
Pichon is built to run close to the metal.

- Single-pass loops
- SIMD-friendly by design
- Parallelizable by construction

Performance comes from structure, not optimization.

## Build

```bash
zig build
zig build test
```

## API

| Category | Functions |
|----------|-----------|
| sum | `pichon_sum_{i32,i64,f64}` |
| min | `pichon_min_{i32,i64,f64}` |
| max | `pichon_max_{i32,i64,f64}` |
| filter | `pichon_filter_gt_{i32,i64,f64}` |

## Usage

```python
from python.binding import lib, c_int32, c_size_t

data = (c_int32 * 5)(10, 50, 30, 80, 20)

# sum
total = lib.pichon_sum_i32(data, 5)  # 190

# filter > threshold
out = (c_int32 * 5)()
count = lib.pichon_filter_gt_i32(data, 5, out, 25)
# out[:count] = [50, 30, 80]
```

## Structure

```
src/
├── lib.zig      # entry point
├── reduce.zig   # sum, min, max
├── filter.zig   # filter_gt
├── layout.zig   # struct definitions
└── error.zig    # error codes

include/
└── pichon.h     # C ABI

python/
└── binding.py   # ctypes binding
```

## License
Copyright KEI SAWAMURA 2026.  
Pichon is licensed under the MIT License. Use, copy, and modify freely.