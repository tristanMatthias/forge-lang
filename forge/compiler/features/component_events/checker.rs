// Component events checker
//
// Event declarations and user hooks (`on before_create(data) { ... }`) are
// processed during the component expansion phase. Event handlers become regular
// FnDecl nodes (named `on_<event>`) and unhandled events get no-op stub
// functions. By the time the type checker runs, these are standard function
// declarations.
//
// The expansion logic lives in `compiler/core/component_expand/mod.rs`.
// No type checker logic is needed for component events.
