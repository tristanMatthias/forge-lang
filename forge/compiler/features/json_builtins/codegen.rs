// JSON builtins codegen lives in core/codegen/codegen/json.rs (~700 lines).
//
// Key compilation methods (all on impl Codegen<'ctx>):
//
// - `compile_json_parse_call()` — parses JSON string into a struct using
//   runtime's forge_json_get_* functions (get_string, get_int, get_float, get_bool)
//
// - `compile_json_parse_struct()` — recursively parses a JSON object into
//   a Forge struct value, handling nested structs and arrays
//
// - `compile_json_parse_list()` — parses a JSON array into a Forge list
//   of structs using forge_json_array_length + forge_json_array_get
//
// - `compile_json_stringify_call()` — converts a Forge struct value into
//   a JSON string using forge_json_* builder functions
//
// - `compile_json_stringify_struct()` — recursively stringifies struct
//   fields into JSON key-value pairs
//
// These methods remain in json.rs because they form a cohesive ~700-line module
// that is already well-separated from the rest of codegen.
