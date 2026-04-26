#ifndef PICHON_H
#define PICHON_H

#include <stdint.h>
#include <stddef.h>

// =============================================================================
// Pichon C ABI
// =============================================================================
// This header defines the stable contract between Python and Zig.
// Do not change signatures without updating python/binding.py.
// =============================================================================

// -----------------------------------------------------------------------------
// Reduce: sum
// -----------------------------------------------------------------------------

// Sum i32 array, return i64 (overflow safe)
int64_t pichon_sum_i32(const int32_t* ptr, size_t len);

// Sum i64 array
int64_t pichon_sum_i64(const int64_t* ptr, size_t len);

// Sum f64 array
double pichon_sum_f64(const double* ptr, size_t len);

// -----------------------------------------------------------------------------
// Reduce: min/max
// -----------------------------------------------------------------------------

int32_t pichon_min_i32(const int32_t* ptr, size_t len);
int32_t pichon_max_i32(const int32_t* ptr, size_t len);

int64_t pichon_min_i64(const int64_t* ptr, size_t len);
int64_t pichon_max_i64(const int64_t* ptr, size_t len);

double pichon_min_f64(const double* ptr, size_t len);
double pichon_max_f64(const double* ptr, size_t len);

// -----------------------------------------------------------------------------
// Filter: greater than
// -----------------------------------------------------------------------------

// Filter i32 array, return count of matches written to out_ptr
size_t pichon_filter_gt_i32(
    const int32_t* in_ptr,
    size_t len,
    int32_t* out_ptr,
    int32_t threshold
);

size_t pichon_filter_gt_i64(
    const int64_t* in_ptr,
    size_t len,
    int64_t* out_ptr,
    int64_t threshold
);

size_t pichon_filter_gt_f64(
    const double* in_ptr,
    size_t len,
    double* out_ptr,
    double threshold
);

#endif // PICHON_H
