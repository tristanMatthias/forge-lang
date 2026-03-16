/// Package dependency management commands: add, remove, update, deps.
///
/// Operates on `forge.toml` files using string-based TOML editing to preserve
/// comments and formatting. Calls into `crate::resolver` for version resolution.

use std::collections::HashMap;
use std::path::Path;

// ── Package specifier parsing ───────────────────────────────────────

/// A parsed package specifier from the CLI.
///
/// Supports these formats:
/// - `graphql`            → name="graphql", version="*"
/// - `graphql@^1.0.0`     → name="graphql", version="^1.0.0"
/// - `@std/http`          → name="@std/http", version="*"
/// - `@std/http@>=0.1.0`  → name="@std/http", version=">=0.1.0"
/// - `git:https://...`    → name from URL, source=git
#[derive(Debug, Clone)]
pub struct PackageSpec {
    pub name: String,
    pub version: String,
    pub source: DepSourceSpec,
}

#[derive(Debug, Clone)]
pub enum DepSourceSpec {
    Registry,
    Git { url: String },
    Path { path: String },
}

/// Parse a CLI package specifier string into a `PackageSpec`.
pub fn parse_package_spec(input: &str, version_override: Option<&str>) -> Result<PackageSpec, String> {
    let input = input.trim();
    if input.is_empty() {
        return Err("empty package specifier".to_string());
    }

    // Git source: git:https://...
    if let Some(url) = input.strip_prefix("git:") {
        let name = url
            .rsplit('/')
            .next()
            .unwrap_or(url)
            .trim_end_matches(".git")
            .to_string();
        return Ok(PackageSpec {
            name,
            version: version_override.unwrap_or("*").to_string(),
            source: DepSourceSpec::Git { url: url.to_string() },
        });
    }

    // Path source: path:./local/dir
    if let Some(path) = input.strip_prefix("path:") {
        let name = Path::new(path)
            .file_name()
            .and_then(|n| n.to_str())
            .unwrap_or(path)
            .to_string();
        return Ok(PackageSpec {
            name,
            version: version_override.unwrap_or("*").to_string(),
            source: DepSourceSpec::Path { path: path.to_string() },
        });
    }

    // Scoped package: @scope/name or @scope/name@version
    if input.starts_with('@') {
        // Find the version separator — it's the '@' after the scope's '@'
        // e.g., "@std/http@>=0.1.0" → split at the second '@'
        if let Some(slash_pos) = input.find('/') {
            let after_slash = &input[slash_pos + 1..];
            if let Some(at_pos) = after_slash.find('@') {
                let name = input[..slash_pos + 1 + at_pos].to_string();
                let ver = &after_slash[at_pos + 1..];
                return Ok(PackageSpec {
                    name,
                    version: version_override.unwrap_or(ver).to_string(),
                    source: DepSourceSpec::Registry,
                });
            }
        }
        // No version suffix
        return Ok(PackageSpec {
            name: input.to_string(),
            version: version_override.unwrap_or("*").to_string(),
            source: DepSourceSpec::Registry,
        });
    }

    // Unscoped package: name or name@version
    if let Some(at_pos) = input.find('@') {
        let name = input[..at_pos].to_string();
        let ver = &input[at_pos + 1..];
        Ok(PackageSpec {
            name,
            version: version_override.unwrap_or(ver).to_string(),
            source: DepSourceSpec::Registry,
        })
    } else {
        Ok(PackageSpec {
            name: input.to_string(),
            version: version_override.unwrap_or("*").to_string(),
            source: DepSourceSpec::Registry,
        })
    }
}

// ── forge.toml manipulation ─────────────────────────────────────────

/// Read forge.toml content from the project directory.
fn read_manifest(project_dir: &Path) -> Result<String, String> {
    let path = project_dir.join("forge.toml");
    std::fs::read_to_string(&path).map_err(|e| {
        format!(
            "cannot read forge.toml in '{}': {}\nhint: run `forge package new <name>` to create a project",
            project_dir.display(),
            e
        )
    })
}

/// Write forge.toml content back to disk.
fn write_manifest(project_dir: &Path, content: &str) -> Result<(), String> {
    let path = project_dir.join("forge.toml");
    std::fs::write(&path, content).map_err(|e| {
        format!("cannot write forge.toml: {}", e)
    })
}

/// Find the byte range of the `[dependencies]` section in the TOML content.
/// Returns (section_start, section_end) where section_end is the start of the
/// next `[section]` header or end of file.
fn find_dependencies_section(content: &str) -> Option<(usize, usize)> {
    let mut in_deps = false;
    let mut start = 0usize;

    for (i, line) in content.lines().enumerate() {
        let trimmed = line.trim();
        let line_start = content.lines().take(i).map(|l| l.len() + 1).sum::<usize>();

        if trimmed == "[dependencies]" {
            in_deps = true;
            start = line_start + line.len() + 1; // after the header line
            continue;
        }

        if in_deps && trimmed.starts_with('[') {
            // Found the next section
            return Some((start, line_start));
        }
    }

    if in_deps {
        Some((start, content.len()))
    } else {
        None
    }
}

/// Parse the `[dependencies]` section into a map of name -> version string.
fn parse_deps_section(content: &str) -> HashMap<String, String> {
    let mut deps = HashMap::new();

    let range = match find_dependencies_section(content) {
        Some(r) => r,
        None => return deps,
    };

    let section = &content[range.0..range.1];
    for line in section.lines() {
        let trimmed = line.trim();
        if trimmed.is_empty() || trimmed.starts_with('#') {
            continue;
        }
        // Parse: name = "version" or name = { version = "...", ... }
        if let Some(eq_pos) = trimmed.find('=') {
            let key = trimmed[..eq_pos].trim().trim_matches('"');
            let value = trimmed[eq_pos + 1..].trim();
            // Simple string value: "^1.0.0"
            if value.starts_with('"') && value.ends_with('"') && value.len() >= 2 {
                let ver = &value[1..value.len() - 1];
                deps.insert(key.to_string(), ver.to_string());
            }
            // Inline table: { version = "..." }
            else if value.starts_with('{') {
                if let Some(ver_start) = value.find("version") {
                    let after = &value[ver_start..];
                    if let Some(eq2) = after.find('=') {
                        let ver_val = after[eq2 + 1..].trim();
                        if let Some(first_quote) = ver_val.find('"') {
                            let rest = &ver_val[first_quote + 1..];
                            if let Some(end_quote) = rest.find('"') {
                                deps.insert(key.to_string(), rest[..end_quote].to_string());
                            }
                        }
                    }
                }
            }
        }
    }

    deps
}

/// Add or replace a dependency line in the `[dependencies]` section.
fn set_dep_in_manifest(content: &str, name: &str, spec: &PackageSpec) -> String {
    let dep_line = match &spec.source {
        DepSourceSpec::Registry => {
            format!("{} = \"{}\"", name, spec.version)
        }
        DepSourceSpec::Git { url } => {
            format!("{} = {{ git = \"{}\", version = \"{}\" }}", name, url, spec.version)
        }
        DepSourceSpec::Path { path } => {
            format!("{} = {{ path = \"{}\", version = \"{}\" }}", name, path, spec.version)
        }
    };

    if let Some((sec_start, sec_end)) = find_dependencies_section(content) {
        let section = &content[sec_start..sec_end];

        // Check if this dep already exists — replace the line
        let mut new_section = String::new();
        let mut found = false;
        for line in section.lines() {
            let trimmed = line.trim();
            if !trimmed.is_empty() && !trimmed.starts_with('#') {
                if let Some(eq_pos) = trimmed.find('=') {
                    let key = trimmed[..eq_pos].trim().trim_matches('"');
                    if key == name {
                        new_section.push_str(&dep_line);
                        new_section.push('\n');
                        found = true;
                        continue;
                    }
                }
            }
            new_section.push_str(line);
            new_section.push('\n');
        }

        if !found {
            // Append the new dep line
            new_section.push_str(&dep_line);
            new_section.push('\n');
        }

        format!("{}{}{}", &content[..sec_start], new_section, &content[sec_end..])
    } else {
        // No [dependencies] section — append one
        let mut result = content.to_string();
        if !result.ends_with('\n') {
            result.push('\n');
        }
        result.push_str("\n[dependencies]\n");
        result.push_str(&dep_line);
        result.push('\n');
        result
    }
}

/// Remove a dependency line from the `[dependencies]` section.
fn remove_dep_from_manifest(content: &str, name: &str) -> (String, bool) {
    if let Some((sec_start, sec_end)) = find_dependencies_section(content) {
        let section = &content[sec_start..sec_end];
        let mut new_section = String::new();
        let mut found = false;

        for line in section.lines() {
            let trimmed = line.trim();
            if !trimmed.is_empty() && !trimmed.starts_with('#') {
                if let Some(eq_pos) = trimmed.find('=') {
                    let key = trimmed[..eq_pos].trim().trim_matches('"');
                    if key == name {
                        found = true;
                        continue; // skip this line
                    }
                }
            }
            new_section.push_str(line);
            new_section.push('\n');
        }

        (
            format!("{}{}{}", &content[..sec_start], new_section, &content[sec_end..]),
            found,
        )
    } else {
        (content.to_string(), false)
    }
}

// ── Public API ──────────────────────────────────────────────────────

/// Add a dependency to forge.toml.
///
/// Returns Ok(version_added) or Err(message).
pub fn add_dependency(
    project_dir: &Path,
    package: &str,
    version: Option<&str>,
) -> Result<String, String> {
    let spec = parse_package_spec(package, version)?;
    let content = read_manifest(project_dir)?;

    // Check if already present
    let existing = parse_deps_section(&content);
    let action = if existing.contains_key(&spec.name) {
        "updated"
    } else {
        "added"
    };

    let new_content = set_dep_in_manifest(&content, &spec.name, &spec);
    write_manifest(project_dir, &new_content)?;

    eprintln!(
        "  {} {} {} @ {}",
        if action == "added" { "+" } else { "~" },
        action,
        spec.name,
        spec.version
    );

    Ok(spec.version)
}

/// Remove a dependency from forge.toml.
pub fn remove_dependency(
    project_dir: &Path,
    package: &str,
) -> Result<(), String> {
    let content = read_manifest(project_dir)?;

    let (new_content, found) = remove_dep_from_manifest(&content, package);
    if !found {
        return Err(format!(
            "dependency '{}' not found in forge.toml\nhint: run `forge deps` to see current dependencies",
            package
        ));
    }

    write_manifest(project_dir, &new_content)?;
    eprintln!("  - removed {}", package);

    Ok(())
}

/// Update dependencies.
///
/// If `package` is None, report all deps. If Some, update just that one.
/// If `version` is Some, pin to that version.
///
/// Returns list of (name, old_version, new_version) for updated deps.
pub fn update_dependency(
    project_dir: &Path,
    package: Option<&str>,
    version: Option<&str>,
) -> Result<Vec<(String, String, String)>, String> {
    let content = read_manifest(project_dir)?;
    let existing = parse_deps_section(&content);

    if existing.is_empty() {
        eprintln!("  no dependencies in forge.toml");
        return Ok(vec![]);
    }

    let mut updated = Vec::new();

    match package {
        Some(name) => {
            let old_ver = existing.get(name).ok_or_else(|| {
                format!(
                    "dependency '{}' not found in forge.toml\nhint: run `forge deps` to see current dependencies",
                    name
                )
            })?;

            let new_ver = version.unwrap_or("*");
            if old_ver != new_ver {
                let spec = PackageSpec {
                    name: name.to_string(),
                    version: new_ver.to_string(),
                    source: DepSourceSpec::Registry,
                };
                let new_content = set_dep_in_manifest(&content, name, &spec);
                write_manifest(project_dir, &new_content)?;
                eprintln!("  ~ {} {} -> {}", name, old_ver, new_ver);
                updated.push((name.to_string(), old_ver.clone(), new_ver.to_string()));
            } else {
                eprintln!("  {} already at {}", name, old_ver);
            }
        }
        None => {
            // Report all deps — actual re-resolution would need a registry
            eprintln!("  dependencies:");
            let mut sorted: Vec<_> = existing.iter().collect();
            sorted.sort_by_key(|(k, _)| k.clone());
            for (name, ver) in sorted {
                eprintln!("    {} = \"{}\"", name, ver);
            }
            eprintln!();
            eprintln!("  hint: specify a package to update, e.g., `forge update graphql`");
        }
    }

    Ok(updated)
}

/// List all dependencies from forge.toml.
pub fn list_deps(project_dir: &Path, flat: bool) -> Result<(), String> {
    let content = read_manifest(project_dir)?;

    // Read project name/version from [package] section
    let config: toml::Value = toml::from_str(&content)
        .map_err(|e| format!("invalid forge.toml: {}", e))?;

    let project_name = config
        .get("package")
        .and_then(|p| p.get("name"))
        .and_then(|v| v.as_str())
        .unwrap_or("(unknown)");
    let project_version = config
        .get("package")
        .and_then(|p| p.get("version"))
        .and_then(|v| v.as_str())
        .unwrap_or("0.0.0");

    let deps = parse_deps_section(&content);
    if deps.is_empty() {
        eprintln!("  {} v{} — no dependencies", project_name, project_version);
        return Ok(());
    }

    if flat {
        let mut sorted: Vec<_> = deps.iter().collect();
        sorted.sort_by_key(|(k, _)| k.clone());
        for (name, ver) in sorted {
            println!("{} = \"{}\"", name, ver);
        }
    } else {
        println!("{} v{}", project_name, project_version);
        let mut sorted: Vec<_> = deps.iter().collect();
        sorted.sort_by_key(|(k, _)| k.clone());
        let count = sorted.len();
        for (i, (name, ver)) in sorted.iter().enumerate() {
            let connector = if i == count - 1 { "\\--" } else { "+--" };
            println!("{} {} v{}", connector, name, ver);
        }
    }

    Ok(())
}

/// Show outdated dependencies.
///
/// Returns (name, current_version, latest_available).
/// For now, reports the current state since we need a live registry for
/// actual latest-version lookups.
pub fn list_outdated(project_dir: &Path) -> Result<Vec<(String, String, String)>, String> {
    let content = read_manifest(project_dir)?;
    let deps = parse_deps_section(&content);

    if deps.is_empty() {
        eprintln!("  no dependencies in forge.toml");
        return Ok(vec![]);
    }

    // Try to resolve against local packages to show what's available
    let packages_dir = project_dir.join("packages");
    let available = crate::resolver::scan_local_packages(&packages_dir);

    let mut outdated = Vec::new();
    let mut sorted: Vec<_> = deps.iter().collect();
    sorted.sort_by_key(|(k, _)| k.clone());

    for (name, current_range) in &sorted {
        if let Some(pkg_versions) = available.get(name.as_str()) {
            // Find the latest version
            if let Some(latest) = pkg_versions.versions.last() {
                let req = crate::resolver::VersionReq::parse(current_range);
                let is_satisfied = req.as_ref().map(|r| r.matches(latest)).unwrap_or(false);
                if !is_satisfied {
                    outdated.push((
                        name.to_string(),
                        current_range.to_string(),
                        latest.clone(),
                    ));
                }
            }
        }
    }

    if outdated.is_empty() {
        eprintln!("  all dependencies are up to date");
    } else {
        eprintln!("  outdated dependencies:");
        for (name, current, latest) in &outdated {
            eprintln!("    {} {} -> {} available", name, current, latest);
        }
    }

    Ok(outdated)
}

// ── Tests ───────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;
    use std::fs;

    #[test]
    fn test_parse_spec_simple() {
        let spec = parse_package_spec("graphql", None).unwrap();
        assert_eq!(spec.name, "graphql");
        assert_eq!(spec.version, "*");
        assert!(matches!(spec.source, DepSourceSpec::Registry));
    }

    #[test]
    fn test_parse_spec_with_version() {
        let spec = parse_package_spec("graphql@^1.0.0", None).unwrap();
        assert_eq!(spec.name, "graphql");
        assert_eq!(spec.version, "^1.0.0");
    }

    #[test]
    fn test_parse_spec_scoped() {
        let spec = parse_package_spec("@std/http", None).unwrap();
        assert_eq!(spec.name, "@std/http");
        assert_eq!(spec.version, "*");
    }

    #[test]
    fn test_parse_spec_scoped_with_version() {
        let spec = parse_package_spec("@std/http@>=0.1.0", None).unwrap();
        assert_eq!(spec.name, "@std/http");
        assert_eq!(spec.version, ">=0.1.0");
    }

    #[test]
    fn test_parse_spec_git() {
        let spec = parse_package_spec("git:https://github.com/user/repo.git", None).unwrap();
        assert_eq!(spec.name, "repo");
        assert_eq!(spec.version, "*");
        assert!(matches!(spec.source, DepSourceSpec::Git { .. }));
    }

    #[test]
    fn test_parse_spec_path() {
        let spec = parse_package_spec("path:./my-local-pkg", None).unwrap();
        assert_eq!(spec.name, "my-local-pkg");
        assert!(matches!(spec.source, DepSourceSpec::Path { .. }));
    }

    #[test]
    fn test_parse_spec_version_override() {
        let spec = parse_package_spec("graphql@^1.0.0", Some("^2.0.0")).unwrap();
        assert_eq!(spec.name, "graphql");
        assert_eq!(spec.version, "^2.0.0"); // override wins
    }

    #[test]
    fn test_parse_spec_empty() {
        assert!(parse_package_spec("", None).is_err());
    }

    #[test]
    fn test_set_dep_new_section() {
        let content = "[package]\nname = \"my-app\"\nversion = \"1.0.0\"\n";
        let spec = PackageSpec {
            name: "graphql".to_string(),
            version: "^1.0.0".to_string(),
            source: DepSourceSpec::Registry,
        };
        let result = set_dep_in_manifest(content, "graphql", &spec);
        assert!(result.contains("[dependencies]"));
        assert!(result.contains("graphql = \"^1.0.0\""));
    }

    #[test]
    fn test_set_dep_existing_section() {
        let content = "[package]\nname = \"my-app\"\n\n[dependencies]\nhttp = \"^0.1.0\"\n";
        let spec = PackageSpec {
            name: "graphql".to_string(),
            version: "^1.0.0".to_string(),
            source: DepSourceSpec::Registry,
        };
        let result = set_dep_in_manifest(content, "graphql", &spec);
        assert!(result.contains("http = \"^0.1.0\""));
        assert!(result.contains("graphql = \"^1.0.0\""));
    }

    #[test]
    fn test_set_dep_replace_existing() {
        let content = "[dependencies]\ngraphql = \"^1.0.0\"\n";
        let spec = PackageSpec {
            name: "graphql".to_string(),
            version: "^2.0.0".to_string(),
            source: DepSourceSpec::Registry,
        };
        let result = set_dep_in_manifest(content, "graphql", &spec);
        assert!(result.contains("graphql = \"^2.0.0\""));
        assert!(!result.contains("graphql = \"^1.0.0\""));
    }

    #[test]
    fn test_remove_dep() {
        let content = "[dependencies]\ngraphql = \"^1.0.0\"\nhttp = \"^0.1.0\"\n";
        let (result, found) = remove_dep_from_manifest(content, "graphql");
        assert!(found);
        assert!(!result.contains("graphql"));
        assert!(result.contains("http = \"^0.1.0\""));
    }

    #[test]
    fn test_remove_dep_not_found() {
        let content = "[dependencies]\nhttp = \"^0.1.0\"\n";
        let (_, found) = remove_dep_from_manifest(content, "graphql");
        assert!(!found);
    }

    #[test]
    fn test_parse_deps_section() {
        let content = "[package]\nname = \"x\"\n\n[dependencies]\nalpha = \"^1.0.0\"\nbeta = \"~2.0.0\"\n\n[build]\nopt = true\n";
        let deps = parse_deps_section(content);
        assert_eq!(deps.len(), 2);
        assert_eq!(deps["alpha"], "^1.0.0");
        assert_eq!(deps["beta"], "~2.0.0");
    }

    #[test]
    fn test_parse_deps_inline_table() {
        let content = "[dependencies]\nmypkg = { version = \"^1.0.0\", git = \"https://example.com\" }\n";
        let deps = parse_deps_section(content);
        assert_eq!(deps["mypkg"], "^1.0.0");
    }

    #[test]
    fn test_add_dependency_roundtrip() {
        let dir = std::env::temp_dir().join("forge_test_add_dep");
        let _ = fs::create_dir_all(&dir);
        fs::write(
            dir.join("forge.toml"),
            "[package]\nname = \"test-app\"\nversion = \"1.0.0\"\n",
        )
        .unwrap();

        let result = add_dependency(&dir, "graphql@^1.0.0", None);
        assert!(result.is_ok());
        assert_eq!(result.unwrap(), "^1.0.0");

        let content = fs::read_to_string(dir.join("forge.toml")).unwrap();
        assert!(content.contains("graphql = \"^1.0.0\""));

        // Cleanup
        let _ = fs::remove_dir_all(&dir);
    }

    #[test]
    fn test_remove_dependency_roundtrip() {
        let dir = std::env::temp_dir().join("forge_test_remove_dep");
        let _ = fs::create_dir_all(&dir);
        fs::write(
            dir.join("forge.toml"),
            "[package]\nname = \"test-app\"\n\n[dependencies]\ngraphql = \"^1.0.0\"\n",
        )
        .unwrap();

        let result = remove_dependency(&dir, "graphql");
        assert!(result.is_ok());

        let content = fs::read_to_string(dir.join("forge.toml")).unwrap();
        assert!(!content.contains("graphql"));

        // Cleanup
        let _ = fs::remove_dir_all(&dir);
    }

    #[test]
    fn test_set_dep_git_source() {
        let content = "[dependencies]\n";
        let spec = PackageSpec {
            name: "mylib".to_string(),
            version: "^1.0.0".to_string(),
            source: DepSourceSpec::Git {
                url: "https://github.com/user/mylib.git".to_string(),
            },
        };
        let result = set_dep_in_manifest(content, "mylib", &spec);
        assert!(result.contains("mylib = { git = \"https://github.com/user/mylib.git\", version = \"^1.0.0\" }"));
    }

    #[test]
    fn test_set_dep_path_source() {
        let content = "[dependencies]\n";
        let spec = PackageSpec {
            name: "local".to_string(),
            version: "*".to_string(),
            source: DepSourceSpec::Path {
                path: "../my-local-pkg".to_string(),
            },
        };
        let result = set_dep_in_manifest(content, "local", &spec);
        assert!(result.contains("local = { path = \"../my-local-pkg\", version = \"*\" }"));
    }
}
