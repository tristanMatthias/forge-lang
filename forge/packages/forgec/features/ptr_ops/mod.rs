pub mod codegen;
pub mod checker;

crate::forge_feature! {
    name: "Pointer Operations",
    id: "ptr_ops",
    status: Stable,
    depends: ["extern_ffi"],
    enables: [],
    tokens: [],
    ast_nodes: ["Index (ptr)", "Binary (ptr + int, ptr - ptr)"],
    description: "Byte-level memory access: ptr[i] read/write, ptr + offset, ptr - ptr, string.from_ptr, ptr.from_string.",
    syntax: ["ptr[i]", "ptr[i] = byte", "ptr + n", "ptr - ptr", "string.from_ptr(p, len)", "ptr.from_string(s)"],
    short: "pointer indexing, arithmetic, and string bridging",
    symbols: [],
    long_description: "\
Extends the `ptr` type with byte-level operations for systems programming. \
`ptr[i]` reads one byte at offset i (returned as int). `ptr[i] = byte` writes one byte. \
`ptr + n` advances a pointer by n bytes. `ptr - ptr` computes the byte distance. \
`string.from_ptr(p, len)` creates a Forge string from raw memory. \
`ptr.from_string(s)` extracts the raw pointer from a Forge string. \
These operations are unchecked — null pointer access emits a runtime panic.",
    category: "Types",
}

crate::builtin_namespace! { name: "ptr", feature: "ptr_ops" }

crate::builtin_namespace_method! { namespace: "ptr", method: "from_string", feature: "ptr_ops", ret: Ptr }
