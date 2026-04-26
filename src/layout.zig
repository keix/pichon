// =============================================================================
// Layout definitions
// =============================================================================
// This module defines memory layouts for structured data.
// All structs must be `extern` for C ABI compatibility.
// =============================================================================

/// Example item struct for demonstration.
/// Real usage will define layouts on Python side.
pub const Item = extern struct {
    price: i32,
};
