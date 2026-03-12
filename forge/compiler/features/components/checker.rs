// Components checker
//
// Component blocks (ComponentBlockDecl) are expanded into regular AST nodes
// (FnDecl, ExternFn, Let, etc.) during the component expansion phase, which
// runs BEFORE type checking. By the time the type checker sees the program,
// all component blocks have been fully expanded into standard statements.
//
// The expansion logic lives in `compiler/core/component_expand/mod.rs`.
// As a result, the type checker has no direct component-specific handling.
