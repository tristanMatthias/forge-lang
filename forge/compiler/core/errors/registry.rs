use serde::Deserialize;
use std::collections::HashMap;

#[derive(Debug, Clone, PartialEq)]
pub enum Level {
    Error,
    Warning,
}

#[derive(Debug, Clone)]
pub struct RegistryEntry {
    pub code: String,
    pub title: String,
    pub level: Level,
    pub message: String,
    pub help: String,
    pub doc: String,
}

#[derive(Debug)]
pub struct ErrorRegistry {
    entries: HashMap<String, RegistryEntry>,
}

#[derive(Deserialize)]
struct TomlEntry {
    title: String,
    level: String,
    message: String,
    #[serde(default)]
    help: String,
    #[serde(default)]
    doc: String,
}

impl ErrorRegistry {
    pub fn from_toml_str(toml_str: &str) -> Result<Self, String> {
        let table: HashMap<String, TomlEntry> =
            toml::from_str(toml_str).map_err(|e| format!("failed to parse registry TOML: {}", e))?;

        let mut entries = HashMap::new();
        for (code, entry) in table {
            let level = match entry.level.as_str() {
                "error" => Level::Error,
                "warning" => Level::Warning,
                other => return Err(format!("unknown level '{}' for code {}", other, code)),
            };
            entries.insert(
                code.clone(),
                RegistryEntry {
                    code,
                    title: entry.title,
                    level,
                    message: entry.message,
                    help: entry.help,
                    doc: entry.doc.trim().to_string(),
                },
            );
        }

        Ok(Self { entries })
    }

    pub fn lookup(&self, code: &str) -> Option<&RegistryEntry> {
        self.entries.get(code)
    }

    pub fn all_codes(&self) -> Vec<&str> {
        self.entries.keys().map(|s| s.as_str()).collect()
    }

    /// Load the built-in registry from the embedded TOML
    pub fn builtin() -> Self {
        let toml_str = include_str!("../../../errors/registry.toml");
        Self::from_toml_str(toml_str).expect("built-in registry.toml must be valid")
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    const TEST_TOML: &str = r#"
[F0001]
title = "Unexpected token"
level = "error"
message = "The parser encountered a token it did not expect."
help = "Check for missing punctuation."
doc = "Detailed docs here."

[F0801]
title = "Unused variable"
level = "warning"
message = "A variable was declared but never used."
help = "Prefix with _ to suppress."
doc = ""
"#;

    #[test]
    fn test_from_toml_str() {
        let registry = ErrorRegistry::from_toml_str(TEST_TOML).unwrap();
        assert!(registry.lookup("F0001").is_some());
        assert!(registry.lookup("F0801").is_some());
    }

    #[test]
    fn test_lookup_returns_correct_entry() {
        let registry = ErrorRegistry::from_toml_str(TEST_TOML).unwrap();
        let entry = registry.lookup("F0001").unwrap();
        assert_eq!(entry.title, "Unexpected token");
        assert_eq!(entry.level, Level::Error);
        assert_eq!(entry.code, "F0001");
    }

    #[test]
    fn test_lookup_warning_level() {
        let registry = ErrorRegistry::from_toml_str(TEST_TOML).unwrap();
        let entry = registry.lookup("F0801").unwrap();
        assert_eq!(entry.level, Level::Warning);
    }

    #[test]
    fn test_lookup_missing_code_returns_none() {
        let registry = ErrorRegistry::from_toml_str(TEST_TOML).unwrap();
        assert!(registry.lookup("F9999").is_none());
    }

    #[test]
    fn test_invalid_toml_returns_error() {
        let result = ErrorRegistry::from_toml_str("not valid toml {{{{");
        assert!(result.is_err());
    }

    #[test]
    fn test_invalid_level_returns_error() {
        let toml = r#"
[F0001]
title = "Test"
level = "fatal"
message = "test"
"#;
        let result = ErrorRegistry::from_toml_str(toml);
        assert!(result.is_err());
        assert!(result.unwrap_err().contains("unknown level"));
    }

    #[test]
    fn test_builtin_registry() {
        let registry = ErrorRegistry::builtin();
        assert!(registry.lookup("F0001").is_some());
        assert!(registry.lookup("F0020").is_some());
        assert!(registry.lookup("F9999").is_some());
    }

    #[test]
    fn test_all_codes() {
        let registry = ErrorRegistry::from_toml_str(TEST_TOML).unwrap();
        let codes = registry.all_codes();
        assert_eq!(codes.len(), 2);
        assert!(codes.contains(&"F0001"));
        assert!(codes.contains(&"F0801"));
    }
}
