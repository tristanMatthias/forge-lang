// Extern FFI type resolution.
//
// Return type inference for extern functions is handled in codegen.rs
// (compile_extern_fn registers forge-level return types in fn_return_types).
//
// The C ABI type mapping (string -> ptr, int -> i64, etc.) is also in codegen.rs.
//
// No additional type-level logic is needed for extern FFI at this time.
