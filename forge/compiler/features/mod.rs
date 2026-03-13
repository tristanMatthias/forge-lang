/// Language feature modules.
///
/// Each feature is a self-contained module that registers its metadata
/// via the `forge_feature!` macro. Features are discovered at link time
/// by the `inventory` crate and listed by `forge features`.
///
/// To add a new feature:
/// 1. Create a new module file (e.g., `my_feature.rs`)
/// 2. Add `forge_feature! { ... }` with metadata
/// 3. Add `pub mod my_feature;` below
/// 4. Run `forge features` to verify

pub mod immutability;
pub mod pipe_operator;
pub mod string_templates;
pub mod ranges;
pub mod for_loops;
pub mod closures;
pub mod it_parameter;
pub mod null_safety;
pub mod error_propagation;
pub mod pattern_matching;
pub mod traits;
pub mod generics;
pub mod extern_ffi;
pub mod c_abi_trampolines;
pub mod json_builtins;
pub mod channels;
pub mod select_syntax;
pub mod spawn;
pub mod defer;
pub mod with_expression;
pub mod shell_shorthand;
pub mod components;
pub mod component_syntax;
pub mod component_events;
pub mod component_config;
pub mod parallel;
pub mod is_keyword;
pub mod table_literal;
pub mod spec_test;
pub mod error_messages;
pub mod type_operators;
