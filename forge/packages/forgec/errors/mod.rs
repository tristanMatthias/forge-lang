pub mod autofix;
pub mod compile_error;
pub mod diagnostic;
pub mod diff;
pub mod registry;
pub mod suggestions;

pub use compile_error::CompileError;
pub use diagnostic::*;
pub use registry::ErrorRegistry;
pub use suggestions::{did_you_mean, levenshtein};
