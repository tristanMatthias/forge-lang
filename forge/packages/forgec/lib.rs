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
pub mod semver;
pub mod resolver;
pub mod lockfile;
pub mod capabilities;
pub mod naming;
pub mod transparency;
pub mod path_deps;
pub mod git_deps;
pub mod pkg_commands;
pub mod publish;
pub mod escalation;
pub mod audit;
pub mod cache;
pub mod quality;
pub mod artifacts;
pub mod bitcode_cache;
