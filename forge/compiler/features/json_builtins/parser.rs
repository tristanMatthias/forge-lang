// JSON builtins have no dedicated parser syntax.
// json.parse(), json.stringify(), and json.parse_list() are handled as regular
// function calls via the static method dispatch system.
// The static method registry maps (namespace="json", method="parse") to the
// appropriate runtime function.
