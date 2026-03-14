crate::forge_feature! {
    name: "Error Messages",
    id: "error_messages",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: [],
    description: "Comprehensive tests for every compiler error code and diagnostic",
    syntax: [],
    short: "comprehensive error messages with codes and help text",
    symbols: [],
    long_description: "\
Forge's error system produces structured, actionable error messages with unique error codes. \
Every error includes a code (like F0012 for type mismatch), a clear description of what went \
wrong, the source location with highlighted code, and a help message suggesting how to fix it.

Error codes are stable identifiers that can be looked up with `forge explain F0012`. Each code \
has a detailed explanation with examples of common causes and fixes. This makes errors searchable \
and referenceable in documentation and team communication.

The error system covers not just syntax and type errors but also common mistakes from other \
languages. Writing a semicolon, using `=>` instead of `->`, or using `var`/`let` from JavaScript \
all produce targeted error messages that explain the Forge equivalent.

Every error path in the compiler goes through the structured error rendering system. There are no \
raw error strings or panics that produce unhelpful messages. This is enforced by design: the \
`CompileError` type has a fixed set of variants, each with a dedicated rendering function that \
includes help text.",
    category: "Special",
}
