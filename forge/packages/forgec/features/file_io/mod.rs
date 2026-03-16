pub mod codegen;

crate::forge_feature! {
    name: "File I/O",
    id: "file_io",
    status: Stable,
    depends: [],
    enables: [],
    tokens: [],
    ast_nodes: [],
    description: "Built-in file operations: read_file, write_file, file_exists",
    syntax: [
        "read_file(path)              — read entire file as string",
        "write_file(path, content)    — write string to file, returns bool",
        "file_exists(path)            — check if file exists, returns bool",
    ],
    short: "read_file, write_file, file_exists — built-in file operations",
    symbols: [],
    long_description: "\
`read_file(path)` reads the entire contents of a file and returns it as a string. If the file \
does not exist or cannot be read, it returns an empty string. The path must be a string.

`write_file(path, content)` writes a string to a file, creating it if it does not exist and \
overwriting any existing content. Returns `true` on success, `false` on failure. Parent \
directories must already exist.

`file_exists(path)` checks whether a file exists at the given path. Returns `true` if the \
file exists (regardless of permissions), `false` otherwise.

These are built-in functions available without any imports. They are designed for the common \
case of reading and writing text files. For more advanced file system operations (directories, \
copying, globbing), use the `@std.fs` package instead.

All paths are interpreted relative to the current working directory unless they are absolute.",
    grammar: "<file_call> ::= (\"read_file\" | \"write_file\" | \"file_exists\") \"(\" <args> \")\"",
    category: "Basics",
}

crate::builtin_fn! { name: "read_file", feature: "file_io", params: [String], ret: String, variadic: false }
crate::builtin_fn! { name: "write_file", feature: "file_io", params: [String, String], ret: Bool, variadic: false }
crate::builtin_fn! { name: "file_exists", feature: "file_io", params: [String], ret: Bool, variadic: false }

// Runtime function declarations
crate::runtime_fn! { name: "forge_read_file", feature: "file_io", params: [ForgeString], ret: ForgeString }
crate::runtime_fn! { name: "forge_write_file", feature: "file_io", params: [ForgeString, ForgeString], ret: I8 }
crate::runtime_fn! { name: "forge_file_exists", feature: "file_io", params: [ForgeString], ret: I8 }
