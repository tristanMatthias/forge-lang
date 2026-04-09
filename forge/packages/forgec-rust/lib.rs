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
pub mod package;
pub mod parser;
pub mod registry;
pub mod site;
pub mod test_runner;
pub mod typeck;

pub mod artifacts;
pub mod audit;
pub mod bitcode_cache;
pub mod cache;
pub mod capabilities;
pub mod escalation;
pub mod features;
pub mod git_deps;
pub mod lockfile;
pub mod naming;
pub mod path_deps;
pub mod pkg_commands;
pub mod publish;
pub mod quality;
pub mod resolver;
pub mod semver;
pub mod transparency;
