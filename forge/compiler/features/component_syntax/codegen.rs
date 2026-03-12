// Component syntax codegen
//
// @syntax is a parser-level feature that desugars pattern-based syntax into
// `__component_<fn_name>(...)` calls during parsing. These calls are then
// processed by the component expansion phase into regular AST nodes before
// codegen runs.
//
// No codegen logic is needed for @syntax patterns.
