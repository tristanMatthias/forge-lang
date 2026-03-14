pub mod core;
pub mod features;

// Re-exports so existing internal imports (`crate::lexer`, etc.) keep working.
// As features are extracted, these re-exports gradually become unnecessary.
pub use core::codegen;
pub use core::component_expand;
pub use core::docs;
pub use core::driver;
pub use core::errors;
pub use core::feature;
pub use core::lang;
pub use core::lexer;
pub use core::parser;
pub use core::package;
pub use core::registry;
pub use core::site;
pub use core::test_runner;
pub use core::typeck;
