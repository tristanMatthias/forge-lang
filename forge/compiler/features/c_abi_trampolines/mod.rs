crate::forge_feature! {
    name: "C ABI Trampolines",
    id: "c_abi_trampolines",
    status: Stable,
    depends: ["extern_ffi"],
    enables: [],
    tokens: [],
    ast_nodes: [],
    description: "Automatic ForgeString to ptr coercion and ptr to ForgeString wrapping for extern calls",
    syntax: [],
    short: "automatic ForgeString/ptr coercion for FFI calls",
    symbols: [],
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
