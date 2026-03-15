use serde::Deserialize;
use std::collections::HashMap;
use std::path::{Path, PathBuf};

#[derive(Debug, Deserialize)]
pub struct ForgeToml {
    pub project: ProjectSection,
    pub build: Option<BuildSection>,
    pub dependencies: Option<HashMap<String, String>>,
    #[serde(rename = "dev-dependencies")]
    pub dev_dependencies: Option<HashMap<String, String>>,
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

/// Represents a Forge project loaded from forge.toml.
/// Module discovery is declaration-based (via `mod` statements),
/// not filesystem-based.
pub struct ForgeProject {
    pub config: ForgeToml,
    pub root_dir: PathBuf,
    pub entry_file: PathBuf,
}

impl ForgeProject {
    /// Load a project from a directory containing forge.toml.
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

        Ok(ForgeProject {
            config,
            root_dir: project_dir.to_path_buf(),
            entry_file,
        })
    }
}
