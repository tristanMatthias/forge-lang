// Component syntax checker
//
// @syntax is a parser-level feature that desugars pattern-based syntax into
// `__component_<fn_name>(...)` calls during parsing. By the time the type
// checker runs, these have been further expanded by the component expansion
// phase into regular function calls and declarations.
//
// No type checker logic is needed for @syntax patterns.
