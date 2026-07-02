pub mod annotations;
pub mod bitwise;
pub mod c_abi_trampolines;
pub mod channels;
pub mod closures;
pub mod collections;
pub mod comments;
pub mod component_config;
pub mod component_events;
pub mod component_syntax;
pub mod components;
pub mod contextual_resolution;
pub mod datetime;
pub mod defer;
pub mod durations;
pub mod enums;
pub mod error_messages;
pub mod error_propagation;
pub mod expression_blocks;
pub mod extern_ffi;
pub mod field_mutability;
pub mod file_io;
pub mod fn_types;
pub mod for_loops;
pub mod functions;
pub mod generics;
pub mod if_else;
/// Language feature modules.
///
/// Each feature is a self-contained module that registers its metadata
/// via the `forge_feature!` macro. Features are discovered at link time
/// by the `inventory` crate and listed by `compiler features`.
///
/// To add a new feature:
/// 1. Create a new module file (e.g., `my_feature.rs`)
/// 2. Add `forge_feature! { ... }` with metadata
/// 3. Add `pub mod my_feature;` below
/// 4. Run `compiler features` to verify
pub mod immutability;
pub mod imports;
pub mod is_keyword;
pub mod it_parameter;
pub mod json_builtins;
pub mod match_tables;
pub mod modules;
pub mod null_safety;
pub mod null_throw;
pub mod numeric_literals;
pub mod operators;
pub mod parallel;
pub mod pattern_matching;
pub mod pipe_operator;
pub mod primitive_types;
pub mod printing;
pub mod process_uptime;
pub mod ptr_ops;
pub mod query_helpers;
pub mod ranges;
pub mod select_syntax;
pub mod shell_shorthand;
pub mod shorthand_fields;
pub mod slicing;
pub mod spawn;
pub mod spec_test;
pub mod stderr;
pub mod string_templates;
pub mod strings;
pub mod structs;
pub mod table_literal;
pub mod tagged_templates;
pub mod traits;
pub mod tuples;
pub mod type_conversion;
pub mod type_operators;
pub mod validation;
pub mod variables;
pub mod while_loops;
pub mod with_expression;
