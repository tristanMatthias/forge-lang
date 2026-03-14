/// Core compiler infrastructure.
///
/// Shared types and pipeline components used by all features.
/// Feature-specific code belongs in `features/`, not here.

pub mod codegen;
pub mod component_expand;
pub mod driver;
pub mod errors;
pub mod feature;
pub mod lexer;
pub mod parser;
pub mod provider;
pub mod registry;
pub mod test_runner;
pub mod typeck;
