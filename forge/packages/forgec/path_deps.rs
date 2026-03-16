use std::path::{Path, PathBuf};

/// A resolved path dependency
#[derive(Debug, Clone)]
pub struct PathDependency {
    pub name: String,
    pub version: String,
    pub path: PathBuf,          // absolute resolved path
    pub original_path: String,   // as written in forge.toml
}

/// Parse a path dependency from forge.toml value.
/// Path deps look like: { path = "../my-lib" }
/// Returns None if this isn't a path dep (it's a version string).
pub fn parse_path_dep(name: &str, value: &toml::Value) -> Option<PathDependency> {
    let table = value.as_table()?;
    let path_str = table.get("path")?.as_str()?;
    Some(PathDependency {
        name: name.to_string(),
        version: table.get("version").and_then(|v| v.as_str()).unwrap_or("0.0.0").to_string(),
        path: PathBuf::from(path_str),
        original_path: path_str.to_string(),
    })
}

/// Resolve a path dependency relative to the project directory.
/// Verifies the target directory exists and contains a package.toml.
pub fn resolve_path_dep(
    project_dir: &Path,
    dep: &PathDependency,
) -> Result<PathDependency, String> {
    let abs_path = if dep.path.is_absolute() {
        dep.path.clone()
    } else {
        project_dir.join(&dep.path).canonicalize()
            .map_err(|e| format!("path dependency '{}' at '{}': {}", dep.name, dep.original_path, e))?
    };

    if !abs_path.exists() {
        return Err(format!(
            "path dependency '{}' points to '{}' which does not exist",
            dep.name, abs_path.display()
        ));
    }

    let pkg_toml = abs_path.join("package.toml");
    if !pkg_toml.exists() {
        return Err(format!(
            "path dependency '{}' at '{}' has no package.toml",
            dep.name, abs_path.display()
        ));
    }

    Ok(PathDependency {
        path: abs_path,
        ..dep.clone()
    })
}

/// Check that path dependencies are not included in a publishable package.
/// Path deps are local-only and cannot be resolved by other users.
pub fn check_no_path_deps_in_publish(
    deps: &[(String, toml::Value)],
) -> Result<(), Vec<String>> {
    let path_deps: Vec<String> = deps.iter()
        .filter_map(|(name, val)| {
            parse_path_dep(name, val).map(|_| name.clone())
        })
        .collect();

    if path_deps.is_empty() {
        Ok(())
    } else {
        Err(path_deps)
    }
}

/// Extract all path dependencies from a forge.toml dependencies table
pub fn extract_path_deps(
    deps: &toml::value::Table,
) -> Vec<PathDependency> {
    deps.iter()
        .filter_map(|(name, val)| parse_path_dep(name, val))
        .collect()
}

/// Extract all non-path (registry) dependencies from a forge.toml dependencies table
pub fn extract_registry_deps(
    deps: &toml::value::Table,
) -> Vec<(String, String)> {
    deps.iter()
        .filter_map(|(name, val)| {
            if val.is_str() {
                Some((name.clone(), val.as_str().unwrap().to_string()))
            } else if let Some(table) = val.as_table() {
                if table.contains_key("path") {
                    None  // Skip path deps
                } else {
                    table.get("version").and_then(|v| v.as_str())
                        .map(|v| (name.clone(), v.to_string()))
                }
            } else {
                None
            }
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_path_dep() {
        let val: toml::Value = toml::from_str(r#"path = "../my-lib""#).unwrap();
        let dep = parse_path_dep("my-lib", &val).unwrap();
        assert_eq!(dep.name, "my-lib");
        assert_eq!(dep.original_path, "../my-lib");
    }

    #[test]
    fn test_parse_version_string_not_path() {
        let val: toml::Value = toml::Value::String("^1.0.0".to_string());
        assert!(parse_path_dep("graphql", &val).is_none());
    }

    #[test]
    fn test_extract_registry_deps() {
        let toml_str = r#"
graphql = "^3.0.0"
local-lib = { path = "../lib" }
http-client = { version = "^1.0.0" }
"#;
        let table: toml::value::Table = toml::from_str(toml_str).unwrap();
        let registry = extract_registry_deps(&table);
        assert_eq!(registry.len(), 2);
        assert!(registry.iter().any(|(n, _)| n == "graphql"));
        assert!(registry.iter().any(|(n, _)| n == "http-client"));
    }

    #[test]
    fn test_check_no_path_deps_in_publish() {
        let toml_str = r#"
graphql = "^3.0.0"
local-lib = { path = "../lib" }
"#;
        let table: toml::value::Table = toml::from_str(toml_str).unwrap();
        let deps: Vec<(String, toml::Value)> = table.into_iter().collect();
        let result = check_no_path_deps_in_publish(&deps);
        assert!(result.is_err());
        assert_eq!(result.unwrap_err(), vec!["local-lib"]);
    }
}
