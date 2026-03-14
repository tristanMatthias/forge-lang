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
    long_description: "\
ABI trampolines automatically convert between Forge's internal type representations and the C \
calling convention used by extern functions. When a Forge string (a struct with pointer and \
length) needs to be passed to a C function expecting a null-terminated pointer, the trampoline \
handles the conversion.

This automatic coercion means provider authors write straightforward C functions with standard \
types, and Forge handles the impedance mismatch at the boundary. No manual marshaling code is \
needed on either side.

Trampolines are generated at compile time for each extern function call. The compiler inspects \
the declared parameter and return types, inserts conversion code where needed, and ensures that \
memory is handled correctly across the boundary.

This system is invisible to both Forge users and provider authors. It exists purely as compiler \
infrastructure to make the FFI seamless. The generated code is optimized to minimize overhead, \
typically adding only a few instructions per call.",
}

pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;
