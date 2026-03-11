use serde::Deserialize;
use std::collections::HashMap;
use std::path::{Path, PathBuf};
use walkdir::WalkDir;

#[derive(Debug, Deserialize)]
pub struct ForgeToml {
    pub project: ProjectSection,
    pub build: Option<BuildSection>,
}

#[derive(Debug, Deserialize)]
pub struct ProjectSection {
    pub name: String,
    pub version: String,
    pub entry: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct BuildSection {
    pub opt_level: Option<u32>,
}

/// Information about a discovered module
#[derive(Debug, Clone)]
pub struct ModuleInfo {
    pub file_path: PathBuf,
    pub module_path: String,
}

/// Represents a Forge project loaded from forge.toml
pub struct ForgeProject {
    pub config: ForgeToml,
    pub root_dir: PathBuf,
    pub entry_file: PathBuf,
    pub modules: Vec<ModuleInfo>,
    /// Map from module_path -> index into modules
    pub module_map: HashMap<String, usize>,
}

impl ForgeProject {
    /// Load a project from a directory containing forge.toml
    pub fn load(project_dir: &Path) -> Result<Self, String> {
        let toml_path = project_dir.join("forge.toml");
        let toml_content = std::fs::read_to_string(&toml_path)
            .map_err(|e| format!("cannot read forge.toml: {}", e))?;

        let config: ForgeToml = toml::from_str(&toml_content)
            .map_err(|e| format!("invalid forge.toml: {}", e))?;

        let entry_rel = config
            .project
            .entry
            .clone()
            .unwrap_or_else(|| "src/main.fg".to_string());
        let entry_file = project_dir.join(&entry_rel);

        if !entry_file.exists() {
            return Err(format!("entry file not found: {}", entry_file.display()));
        }

        let src_dir = project_dir.join("src");
        let modules = discover_modules(&src_dir)?;

        let mut module_map = HashMap::new();
        for (i, m) in modules.iter().enumerate() {
            module_map.insert(m.module_path.clone(), i);
        }

        Ok(ForgeProject {
            config,
            root_dir: project_dir.to_path_buf(),
            entry_file,
            modules,
            module_map,
        })
    }
}

/// Discover all .fg files under src/ and compute their module paths.
///
/// Rules:
/// - `src/main.fg` -> skipped (entry point, not a named module)
/// - `src/foo.fg` -> module "foo"
/// - `src/foo/foo.fg` -> module "foo" (filename matches parent dir)
/// - `src/foo/bar.fg` -> module "foo.bar" (filename differs from parent dir)
fn discover_modules(src_dir: &Path) -> Result<Vec<ModuleInfo>, String> {
    if !src_dir.exists() {
        return Err(format!("src directory not found: {}", src_dir.display()));
    }

    let mut modules = Vec::new();

    for entry in WalkDir::new(src_dir)
        .into_iter()
        .filter_map(|e| e.ok())
    {
        let path = entry.path();
        if !path.is_file() {
            continue;
        }
        if path.extension().and_then(|e| e.to_str()) != Some("fg") {
            continue;
        }

        let rel = path
            .strip_prefix(src_dir)
            .map_err(|_| "failed to compute relative path".to_string())?;

        // Skip the entry point file (main.fg at src root)
        let rel_str = rel.to_str().unwrap_or("");
        if rel_str == "main.fg" {
            continue;
        }

        let module_path = compute_module_path(rel);
        if let Some(mp) = module_path {
            modules.push(ModuleInfo {
                file_path: path.to_path_buf(),
                module_path: mp,
            });
        }
    }

    Ok(modules)
}

/// Compute the module path from a relative path (relative to src/).
///
/// - `foo.fg` -> "foo"
/// - `foo/foo.fg` -> "foo"
/// - `foo/bar.fg` -> "foo.bar"
/// - `foo/bar/baz.fg` -> "foo.bar.baz"
/// - `foo/bar/bar.fg` -> "foo.bar"
fn compute_module_path(rel: &Path) -> Option<String> {
    let stem = rel.file_stem()?.to_str()?;
    let parent = rel.parent();

    match parent {
        None => {
            // File directly in src/: src/foo.fg -> "foo"
            Some(stem.to_string())
        }
        Some(p) if p.as_os_str().is_empty() => {
            // File directly in src/: src/foo.fg -> "foo"
            Some(stem.to_string())
        }
        Some(parent_path) => {
            // File in a subdirectory
            let parent_segments: Vec<&str> = parent_path
                .components()
                .filter_map(|c| c.as_os_str().to_str())
                .collect();

            // Check if filename matches the last directory component
            let last_dir = parent_segments.last().copied().unwrap_or("");
            if stem == last_dir {
                // src/math/math.fg -> "math"
                // src/foo/bar/bar.fg -> "foo.bar"
                Some(parent_segments.join("."))
            } else {
                // src/math/helpers.fg -> "math.helpers"
                let mut parts = parent_segments.clone();
                parts.push(stem);
                Some(parts.join("."))
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::path::Path;

    #[test]
    fn test_module_path_simple() {
        assert_eq!(
            compute_module_path(Path::new("math.fg")),
            Some("math".to_string())
        );
    }

    #[test]
    fn test_module_path_matching_dir() {
        assert_eq!(
            compute_module_path(Path::new("math/math.fg")),
            Some("math".to_string())
        );
    }

    #[test]
    fn test_module_path_different_name() {
        assert_eq!(
            compute_module_path(Path::new("math/helpers.fg")),
            Some("math.helpers".to_string())
        );
    }

    #[test]
    fn test_module_path_nested_matching() {
        assert_eq!(
            compute_module_path(Path::new("foo/bar/bar.fg")),
            Some("foo.bar".to_string())
        );
    }
}
