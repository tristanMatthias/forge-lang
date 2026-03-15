// C ABI trampolines codegen
//
// The C ABI trampoline/coercion logic is implemented in
// `compiler/core/codegen/codegen/extern_ffi.rs`, which contains:
//
// - `compile_extern_fn`: Declares an LLVM external function with C ABI type
//   mapping. Maps Forge types to C types (e.g., `string` -> `ptr`, `int` -> `i64`).
//   Also registers the Forge-level return type in `fn_return_types` for type inference.
//
// - `extern_type_to_llvm`: Maps Forge TypeExpr to LLVM BasicMetadataTypeEnum
//   for extern function parameters. Handles string/cstring/ptr -> pointer,
//   int/i64 -> i64, i32 -> i32, float/f64 -> f64, bool/i8 -> i8.
//
// The ForgeString-to-ptr coercion for call arguments is handled by `coerce_value`
// in `compiler/core/codegen/codegen/expressions_calls.rs`, which auto-extracts
// the raw pointer from a ForgeString struct when the target parameter type is ptr.
//
// For ptr-to-ForgeString conversion (wrapping extern return values), component
// templates use `strlen(__ptr)` + `forge_string_new(__ptr, __len)` patterns
// that are expanded at the AST level before codegen.
