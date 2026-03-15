// Components types
//
// Component blocks are expanded into regular AST nodes during the component
// expansion phase, which runs before type inference. The type system has no
// special component-related type variants — all component-generated code uses
// standard types (String, Int, Struct, etc.).
//
// Component-related AST types (ComponentBlockDecl, ComponentTemplateDef,
// ComponentTemplateItem, ComponentConfig, ComponentSchemaField, etc.) are
// defined in `compiler/core/parser/ast.rs` as part of the AST definitions.
