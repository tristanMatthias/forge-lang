// C ABI trampolines checker
//
// ABI trampolines are a codegen-only concern. The type checker does not need
// special handling for C ABI coercions — type checking operates on the
// Forge-level types (string, int, etc.) without awareness of the underlying
// LLVM type mappings or ForgeString-to-ptr conversions.
