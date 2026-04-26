#ifndef PICHON_H
#define PICHON_H

#include <stdint.h>
#include <stddef.h>

// =============================================================================
// Pichon C ABI
// =============================================================================

// -----------------------------------------------------------------------------
// Reduce: sum
// -----------------------------------------------------------------------------

int64_t pichon_sum_i32(const int32_t* ptr, size_t len);
int64_t pichon_sum_i64(const int64_t* ptr, size_t len);
double  pichon_sum_f64(const double* ptr, size_t len);

// -----------------------------------------------------------------------------
// Reduce: min
// -----------------------------------------------------------------------------

int32_t pichon_min_i32(const int32_t* ptr, size_t len);
int64_t pichon_min_i64(const int64_t* ptr, size_t len);
double  pichon_min_f64(const double* ptr, size_t len);

// -----------------------------------------------------------------------------
// Reduce: max
// -----------------------------------------------------------------------------

int32_t pichon_max_i32(const int32_t* ptr, size_t len);
int64_t pichon_max_i64(const int64_t* ptr, size_t len);
double  pichon_max_f64(const double* ptr, size_t len);

// -----------------------------------------------------------------------------
// Filter: greater than
// -----------------------------------------------------------------------------

size_t pichon_filter_gt_i32(const int32_t* in, size_t len, int32_t* out, int32_t threshold);
size_t pichon_filter_gt_i64(const int64_t* in, size_t len, int64_t* out, int64_t threshold);
size_t pichon_filter_gt_f64(const double* in, size_t len, double* out, double threshold);

// -----------------------------------------------------------------------------
// Map: binary add
// -----------------------------------------------------------------------------

void pichon_add_i32(const int32_t* a, const int32_t* b, size_t len, int32_t* out);
void pichon_add_i64(const int64_t* a, const int64_t* b, size_t len, int64_t* out);
void pichon_add_f64(const double* a, const double* b, size_t len, double* out);

// -----------------------------------------------------------------------------
// Map: binary sub
// -----------------------------------------------------------------------------

void pichon_sub_i32(const int32_t* a, const int32_t* b, size_t len, int32_t* out);
void pichon_sub_i64(const int64_t* a, const int64_t* b, size_t len, int64_t* out);
void pichon_sub_f64(const double* a, const double* b, size_t len, double* out);

// -----------------------------------------------------------------------------
// Map: binary mul
// -----------------------------------------------------------------------------

void pichon_mul_i32(const int32_t* a, const int32_t* b, size_t len, int32_t* out);
void pichon_mul_i64(const int64_t* a, const int64_t* b, size_t len, int64_t* out);
void pichon_mul_f64(const double* a, const double* b, size_t len, double* out);

// -----------------------------------------------------------------------------
// Map: scalar add
// -----------------------------------------------------------------------------

void pichon_add_s_i32(const int32_t* a, size_t len, int32_t scalar, int32_t* out);
void pichon_add_s_i64(const int64_t* a, size_t len, int64_t scalar, int64_t* out);
void pichon_add_s_f64(const double* a, size_t len, double scalar, double* out);

// -----------------------------------------------------------------------------
// Map: scalar sub
// -----------------------------------------------------------------------------

void pichon_sub_s_i32(const int32_t* a, size_t len, int32_t scalar, int32_t* out);
void pichon_sub_s_i64(const int64_t* a, size_t len, int64_t scalar, int64_t* out);
void pichon_sub_s_f64(const double* a, size_t len, double scalar, double* out);

// -----------------------------------------------------------------------------
// Map: scalar mul
// -----------------------------------------------------------------------------

void pichon_mul_s_i32(const int32_t* a, size_t len, int32_t scalar, int32_t* out);
void pichon_mul_s_i64(const int64_t* a, size_t len, int64_t scalar, int64_t* out);
void pichon_mul_s_f64(const double* a, size_t len, double scalar, double* out);

#endif // PICHON_H
