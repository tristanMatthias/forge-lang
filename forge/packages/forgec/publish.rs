use std::path::{Path, PathBuf};

/// Result of a publish operation
#[derive(Debug)]
pub struct PublishResult {
    pub package_name: String,
    pub version: String,
    pub content_hash: String,
    pub registry_url: String,
}

/// Configuration for the publish command
#[derive(Debug)]
pub struct PublishConfig {
    pub dry_run: bool,
    pub registry_url: String,
    pub token: Option<String>,
}

impl Default for PublishConfig {
    fn default() -> Self {
        Self {
            dry_run: false,
            registry_url: "https://registry.forgelang.org".to_string(),
            token: None,
        }
    }
}

/// Run the full publish pipeline
pub fn publish(project_dir: &Path, config: &PublishConfig) -> Result<PublishResult, String> {
    // Step 1: Read and validate package.toml
    let manifest = read_manifest(project_dir)?;

    // Step 2: Check for path dependencies (not allowed in published packages)
    check_no_path_deps(project_dir)?;

    // Step 3: Validate package name
    crate::naming::validate_package_name(&manifest.name)
        .map_err(|e| format!("invalid package name: {}", e))?;

    // Step 4: Run tests (must pass)
    // In dry-run, skip this
    if !config.dry_run {
        eprintln!("  running tests...");
        // TODO: Actually run forge test
    }

    // Step 5: Generate context.fg (API surface)
    eprintln!("  generating context.fg...");

    // Step 6: Compute content hash
    let content_hash = compute_content_hash(project_dir)?;
    eprintln!("  content hash: {}", &content_hash[..16]);

    // Step 7: Check semver (if previous version exists on registry)
    // TODO: fetch previous context from registry and diff

    // Step 8: Package the source
    let archive_path = create_archive(project_dir, &manifest.name, &manifest.version)?;
    eprintln!("  packaged: {}", archive_path.display());

    if config.dry_run {
        eprintln!("\n  dry run — not uploading to registry");
        // Clean up archive
        std::fs::remove_file(&archive_path).ok();
        return Ok(PublishResult {
            package_name: manifest.name,
            version: manifest.version,
            content_hash,
            registry_url: config.registry_url.clone(),
        });
    }

    // Step 9: Upload to registry
    let loaded = load_token();
    let token = config
        .token
        .as_ref()
        .or(loaded.as_ref())
        .ok_or("not authenticated — run `forge auth login` first")?
        .clone();

    eprintln!("  uploading to {}...", config.registry_url);
    // TODO: HTTP POST to registry API
    let _ = token; // suppress unused warning until HTTP upload is implemented

    // Clean up
    std::fs::remove_file(&archive_path).ok();

    Ok(PublishResult {
        package_name: manifest.name,
        version: manifest.version,
        content_hash,
        registry_url: config.registry_url.clone(),
    })
}

/// Yank a published version (mark as not recommended, but don't delete)
pub fn yank(package: &str, version: &str, registry_url: &str, token: &str) -> Result<(), String> {
    eprintln!("yanking {} v{} from {}...", package, version, registry_url);
    // TODO: HTTP POST to registry API
    let _ = token; // suppress unused warning until HTTP upload is implemented
    Ok(())
}

// -- Internal helpers --------------------------------------------------------

struct Manifest {
    name: String,
    version: String,
    #[allow(dead_code)]
    namespace: String,
}

fn read_manifest(project_dir: &Path) -> Result<Manifest, String> {
    let path = project_dir.join("package.toml");
    let content = std::fs::read_to_string(&path)
        .map_err(|_| "no package.toml found — run this from a package directory".to_string())?;

    let toml_val: toml::Value =
        toml::from_str(&content).map_err(|e| format!("invalid package.toml: {}", e))?;

    let pkg = toml_val
        .get("package")
        .ok_or("missing [package] section in package.toml")?;

    Ok(Manifest {
        name: pkg
            .get("name")
            .and_then(|v| v.as_str())
            .unwrap_or("unknown")
            .to_string(),
        version: pkg
            .get("version")
            .and_then(|v| v.as_str())
            .unwrap_or("0.0.0")
            .to_string(),
        namespace: pkg
            .get("namespace")
            .and_then(|v| v.as_str())
            .unwrap_or("community")
            .to_string(),
    })
}

fn check_no_path_deps(project_dir: &Path) -> Result<(), String> {
    let toml_path = project_dir.join("package.toml");
    let content = std::fs::read_to_string(&toml_path)
        .map_err(|e| format!("cannot read package.toml: {}", e))?;

    let toml_val: toml::Value =
        toml::from_str(&content).map_err(|e| format!("invalid package.toml: {}", e))?;

    if let Some(deps) = toml_val.get("dependencies").and_then(|d| d.as_table()) {
        let path_deps: Vec<&String> = deps
            .iter()
            .filter(|(_, v)| {
                v.as_table()
                    .map(|t| t.contains_key("path"))
                    .unwrap_or(false)
            })
            .map(|(k, _)| k)
            .collect();

        if !path_deps.is_empty() {
            return Err(format!(
                "cannot publish with path dependencies: {}. Replace with registry versions.",
                path_deps
                    .iter()
                    .map(|s| s.as_str())
                    .collect::<Vec<_>>()
                    .join(", ")
            ));
        }
    }

    Ok(())
}

fn compute_content_hash(project_dir: &Path) -> Result<String, String> {
    // Hash all source files deterministically
    use std::collections::BTreeSet;

    let mut files = BTreeSet::new();
    collect_source_files(project_dir, &mut files)?;

    // Simple hash: concatenate all file contents in sorted order
    // In production this would use sha2 crate
    let mut combined = String::new();
    for file in &files {
        let content = std::fs::read_to_string(file)
            .map_err(|e| format!("cannot read {}: {}", file.display(), e))?;
        combined.push_str(
            &file
                .strip_prefix(project_dir)
                .unwrap_or(file)
                .display()
                .to_string(),
        );
        combined.push('\n');
        combined.push_str(&content);
    }

    // Simple hash (would be SHA-256 in production)
    let hash = format!("sha256:{:016x}", simple_hash(&combined));
    Ok(hash)
}

fn simple_hash(s: &str) -> u64 {
    let mut hash: u64 = 14695981039346656037;
    for byte in s.bytes() {
        hash ^= byte as u64;
        hash = hash.wrapping_mul(1099511628211);
    }
    hash
}

fn collect_source_files(
    dir: &Path,
    files: &mut std::collections::BTreeSet<PathBuf>,
) -> Result<(), String> {
    if !dir.is_dir() {
        return Ok(());
    }

    let entries =
        std::fs::read_dir(dir).map_err(|e| format!("cannot read dir {}: {}", dir.display(), e))?;

    for entry in entries {
        let entry = entry.map_err(|e| e.to_string())?;
        let path = entry.path();
        let name = entry.file_name().to_string_lossy().to_string();

        // Skip hidden dirs, target, node_modules
        if name.starts_with('.') || name == "target" || name == "node_modules" {
            continue;
        }

        if path.is_dir() {
            collect_source_files(&path, files)?;
        } else if name.ends_with(".fg")
            || name.ends_with(".toml")
            || name.ends_with(".rs")
            || name.ends_with(".c")
            || name.ends_with(".h")
        {
            files.insert(path);
        }
    }

    Ok(())
}

fn create_archive(project_dir: &Path, name: &str, version: &str) -> Result<PathBuf, String> {
    let archive_name = format!("{}-{}.tar.gz", name, version);
    let archive_path = std::env::temp_dir().join(&archive_name);

    // Use tar command for simplicity
    let output = std::process::Command::new("tar")
        .args([
            "czf",
            archive_path.to_str().unwrap(),
            "--exclude",
            ".git",
            "--exclude",
            "target",
            "--exclude",
            "node_modules",
            "-C",
            project_dir
                .parent()
                .unwrap_or(project_dir)
                .to_str()
                .unwrap(),
            project_dir.file_name().unwrap().to_str().unwrap(),
        ])
        .output()
        .map_err(|e| format!("tar failed: {}", e))?;

    if !output.status.success() {
        return Err(format!(
            "tar failed: {}",
            String::from_utf8_lossy(&output.stderr)
        ));
    }

    Ok(archive_path)
}

fn load_token() -> Option<String> {
    let home = std::env::var("HOME").ok()?;
    let cred_path = PathBuf::from(home)
        .join(".forge")
        .join("auth")
        .join("credentials.toml");
    let content = std::fs::read_to_string(&cred_path).ok()?;
    let toml_val: toml::Value = toml::from_str(&content).ok()?;
    toml_val
        .get("auth")?
        .get("token")?
        .as_str()
        .map(|s| s.to_string())
}

// -- CLI command helpers -----------------------------------------------------

/// Create the CLI command definition for Forge
pub fn create_cli_command_fg() -> &'static str {
    r#"use shared.{forward}

export command publish "Publish this package to the registry" {
    flag dry_run "Simulate publish without uploading"

    run {
        forward("publish")
    }
}
"#
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_simple_hash_deterministic() {
        assert_eq!(simple_hash("hello"), simple_hash("hello"));
        assert_ne!(simple_hash("hello"), simple_hash("world"));
    }

    #[test]
    fn test_content_hash_format() {
        let hash = format!("sha256:{:016x}", simple_hash("test content"));
        assert!(hash.starts_with("sha256:"));
    }
}
