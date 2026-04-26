// =============================================================================
// Error codes
// =============================================================================
// Pichon uses integer error codes for C ABI compatibility.
// Zero means success. Negative values indicate errors.
// =============================================================================

pub const Error = enum(i32) {
    ok = 0,
    null_pointer = -1,
    empty_input = -2,
    invalid_length = -3,
    overflow = -4,
};
