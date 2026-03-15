crate::forge_feature! {
    name: "Modules",
    id: "modules",
    status: Wip,
    depends: ["imports"],
    enables: [],
    tokens: ["mod"],
    ast_nodes: ["ModDecl"],
    description: "Rust-style file-based module system with mod declarations",
    syntax: ["mod module_name", "use module.{symbol}", "export fn name()"],
    short: "declaration-based module system like Rust",
    symbols: [],
    long_description: "\
Forge uses a Rust-style module system. Declare modules with `mod foo` to tell the compiler \
to find and include the module's source file. The compiler looks for `foo.fg` in the same \
directory, or `foo/mod.fg` for directory modules (like Rust).

Module resolution rules:
- `mod foo` → looks for `foo.fg` or `foo/mod.fg` relative to the declaring file
- If both exist, it's a compile error (ambiguous)
- Nested modules: `mod bar` inside `foo.fg` → looks for `foo/bar.fg` or `foo/bar/mod.fg`
- Symbols are private by default; use `export` to make them visible to other modules
- Import with `use foo.{bar, baz}` after declaring the module

All modules compile into a single LLVM module with name-mangled symbols. Imported functions \
are injected into the importing program's AST so they have access to the full runtime.",
    grammar: "<mod_decl> ::= \"mod\" <ident>\n<export> ::= \"export\" <decl>",
    category: "Special",
}

pub mod types;
pub mod parser;
pub mod resolver;
pub mod project;
pub mod codegen;
