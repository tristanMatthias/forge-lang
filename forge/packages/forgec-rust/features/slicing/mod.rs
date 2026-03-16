pub mod checker;
pub mod codegen;
pub mod types;

crate::forge_feature! {
    name: "Slicing",
    id: "slicing",
    status: Stable,
    depends: ["ranges", "collections"],
    enables: [],
    tokens: [],
    ast_nodes: ["Slice"],
    description: "Range-based indexing to extract sub-lists and substrings",
    syntax: ["list[start..end]", "list[start..]", "list[..end]", "string[start..end]"],
    short: "list[1..3], string[0..5] — slice lists and strings with range syntax",
    symbols: [],
    long_description: "\
Slicing extracts a contiguous portion of a list or string using range syntax inside square \
brackets. The range `start..end` selects elements from index `start` (inclusive) to `end` \
(exclusive), matching Forge's standard range semantics.\n\
\n\
Three forms are supported: `collection[start..end]` for a bounded slice, `collection[start..]` \
to take everything from `start` to the end, and `collection[..end]` to take the first `end` \
elements. For lists, slicing always returns a new list of the same element type. For strings, \
slicing returns a new string (equivalent to `.substring(start, end)`).\n\
\n\
Out-of-bounds indices are clamped: `[0..100]` on a 5-element list returns all 5 elements. \
An empty or reversed range like `[3..1]` returns an empty list or empty string. Slicing never \
panics.",
    grammar: "<slice_expr> ::= <expr> \"[\" <expr> \"..\" <expr> \"]\" \
                              | <expr> \"[\" <expr> \"..\" \"]\" \
                              | <expr> \"[\" \"..\" <expr> \"]\"",
    category: "Collections",
}

// Runtime function: forge_list_slice(data_ptr, list_len, start, end, elem_size) -> {ptr, len}
// The return type is structurally {ptr, i64} — same layout as ForgeString.
crate::runtime_fn! { name: "forge_list_slice", feature: "slicing", params: [Ptr, I64, I64, I64, I64], ret: ForgeString }
