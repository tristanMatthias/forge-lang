// C ABI trampolines parser
//
// ABI trampolines are a codegen-only concern. The parser does not have any
// special handling for C ABI compatibility — extern function declarations
// are parsed by the extern_ffi feature, and the trampoline/coercion logic
// is applied during code generation.
