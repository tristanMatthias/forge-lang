// Component config codegen is handled during template expansion.
//
// Config values become `$config_<field>` substitutions in the expanded AST.
// After expansion, the resulting AST contains plain literals/expressions
// that are compiled by normal codegen with no special config awareness.
