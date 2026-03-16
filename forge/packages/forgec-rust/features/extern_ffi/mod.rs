crate::forge_feature! {
    name: "Extern FFI",
    id: "extern_ffi",
    status: Stable,
    depends: [],
    enables: ["c_abi_trampolines"],
    tokens: ["extern"],
    ast_nodes: ["ExternFn"],
    description: "C ABI foreign function declarations for native library interop",
    syntax: ["extern fn name(params) -> type"],
    short: "extern fn — C ABI foreign function declarations",
    symbols: [],
    long_description: "\
The foreign function interface allows Forge code to call C ABI functions from native libraries. \
Extern functions are declared in package template files with their C signatures, and the \
compiler generates the appropriate calling convention code.

Package `.a` static libraries implement the native side, and the Forge linker combines them \
with the compiled Forge code. This is how packages like `std-http`, `std-model`, and `std-fs` \
implement their functionality: Forge templates declare the interface, native code implements it.

Type coercion between Forge types and C types is handled automatically. Forge strings are \
converted to C pointers when passed to extern functions, and pointer returns are wrapped back \
into Forge strings. This happens transparently at call sites.

The FFI is designed for package authors, not end users. Application code uses packages through \
their Forge-level APIs (components, functions, static methods). The FFI layer is the plumbing \
that makes packages possible.",
    category: "Components",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
