// Immutability parsing: let/mut/const declarations.
//
// The parsing methods live in core/parser/parser.rs because they are fundamental
// to the language grammar and tightly integrated with the statement parser:
//
// - `parse_let_with_export()` / `parse_let()` — immutable variable binding
// - `parse_mut_with_export()` / `parse_mut()` — mutable variable binding
// - `parse_const_with_export()` / `parse_const()` — constant binding
// - `parse_tuple_destructure()` — let (a, b) = expr
// - `parse_struct_destructure()` — let { a, b } = expr
// - `parse_list_destructure()` — let [a, b] = expr
//
// These remain in core because every Forge program uses variable bindings,
// making them a core language primitive rather than an optional feature.
