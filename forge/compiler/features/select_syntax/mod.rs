pub mod parser;
pub mod checker;
pub mod codegen;
pub mod types;

crate::forge_feature! {
    name: "Select Syntax",
    id: "select_syntax",
    status: Stable,
    depends: ["channels"],
    enables: [],
    tokens: ["select"],
    ast_nodes: ["Select", "SelectArm"],
    description: "Channel multiplexing with select { binding <- ch -> body } and guards",
}
