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
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
