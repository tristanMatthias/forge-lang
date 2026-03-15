// Component config parsing is embedded within `parse_component_template_def()`
// in the components feature (components/parser.rs).
//
// Config blocks are defined as:
//   config { port: int = 3000, cors: bool = false }
//
// Parsed into `ConfigSchemaEntry` AST nodes with name, type, and default value.
// Config resolution at expansion time is handled by `resolve_config()` in
// core/component_expand/mod.rs.
