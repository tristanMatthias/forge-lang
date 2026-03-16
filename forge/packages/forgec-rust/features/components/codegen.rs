// Components codegen
//
// Component blocks (ComponentBlockDecl) are expanded into regular AST nodes
// (FnDecl, ExternFn, Let, etc.) during the component expansion phase, which
// runs BEFORE codegen. By the time codegen processes the program, all component
// blocks have been fully expanded into standard statements that the normal
// codegen pipeline handles.
//
// The expansion logic lives in `compiler/core/component_expand/mod.rs`.
// As a result, codegen has no direct component-specific handling.
