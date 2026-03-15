/// Core compiler infrastructure.
///
/// Shared types and pipeline components used by all features.
/// Feature-specific code belongs in `features/`, not here.

pub mod ansi;
pub mod context;
pub mod feature;

pub mod codegen;
pub mod docs;
pub mod driver;
pub mod errors;
pub mod lang;
pub mod lexer;
pub mod parser;
pub mod package;
pub mod registry;
pub mod site;
pub mod test_runner;
pub mod typeck;

pub mod features;
