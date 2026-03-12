// Component events codegen
//
// Event declarations and user hooks are expanded into regular FnDecl nodes
// during the component expansion phase, before codegen runs. The hook functions
// (e.g., `on_before_create`) are compiled as normal functions by the standard
// codegen pipeline. Service hooks are wired up via `build_hooked_fn()` in
// the component expander.
//
// The expansion logic lives in `compiler/core/component_expand/mod.rs`.
// No codegen logic is needed for component events.
