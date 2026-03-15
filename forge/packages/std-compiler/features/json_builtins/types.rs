// JSON builtins type inference:
// - json.parse(str) → inferred from json_parse_hint (set by let binding type annotation)
// - json.stringify(val) → Type::String
// - json.parse_list(str) → List<T> where T is inferred from context
//
// The json_parse_hint field on Codegen is set when a let binding has a type
// annotation and the right side is json.parse(), enabling type-directed parsing.
