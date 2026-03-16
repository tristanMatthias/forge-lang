use std::path::{Path, PathBuf};
use std::process::Command;

/// A Git dependency specification from forge.toml
#[derive(Debug, Clone)]
pub struct GitDependency {
    pub name: String,
    pub url: String,
    pub reference: GitRef,
}

#[derive(Debug, Clone)]
pub enum GitRef {
    Tag(String),
    Branch(String),
    Rev(String),
    Default, // HEAD of default branch
}

/// A resolved Git dependency with pinned commit
#[derive(Debug, Clone)]
pub struct ResolvedGitDep {
    pub name: String,
    pub url: String,
    pub reference: GitRef,
    pub resolved_rev: String,   // full commit hash
    pub checkout_path: PathBuf, // path in cache
}

/// Parse a git dependency from forge.toml value.
/// Git deps look like: { git = "https://...", tag = "v1.0.0" }
pub fn parse_git_dep(name: &str, value: &toml::Value) -> Option<GitDependency> {
    let table = value.as_table()?;
    let url = table.get("git")?.as_str()?.to_string();

    let reference = if let Some(tag) = table.get("tag").and_then(|v| v.as_str()) {
        GitRef::Tag(tag.to_string())
    } else if let Some(branch) = table.get("branch").and_then(|v| v.as_str()) {
        GitRef::Branch(branch.to_string())
    } else if let Some(rev) = table.get("rev").and_then(|v| v.as_str()) {
        GitRef::Rev(rev.to_string())
    } else {
        GitRef::Default
    };

    Some(GitDependency {
        name: name.to_string(),
        url,
        reference,
    })
}

/// Resolve a git dependency: clone/fetch to cache, checkout ref, return resolved info.
pub fn resolve_git_dep(
    dep: &GitDependency,
    cache_dir: &Path,
) -> Result<ResolvedGitDep, String> {
    let git_cache = cache_dir.join("git");
    std::fs::create_dir_all(&git_cache)
        .map_err(|e| format!("cannot create git cache: {}", e))?;

    // Use URL hash as directory name to avoid conflicts
    let dir_name = simple_hash(&dep.url);
    let repo_dir = git_cache.join(&dir_name);

    // Clone or fetch
    if repo_dir.exists() {
        // Fetch latest
        let output = Command::new("git")
            .args(["fetch", "--all", "--tags"])
            .current_dir(&repo_dir)
            .output()
            .map_err(|e| format!("git fetch failed: {}", e))?;

        if !output.status.success() {
            let stderr = String::from_utf8_lossy(&output.stderr);
            return Err(format!(
                "git fetch failed for '{}': {}",
                dep.url, stderr
            ));
        }
    } else {
        // Clone bare
        let output = Command::new("git")
            .args([
                "clone",
                "--bare",
                &dep.url,
                repo_dir.to_str().unwrap(),
            ])
            .output()
            .map_err(|e| format!("git clone failed: {}", e))?;

        if !output.status.success() {
            let stderr = String::from_utf8_lossy(&output.stderr);
            return Err(format!(
                "git clone failed for '{}': {}",
                dep.url, stderr
            ));
        }
    }

    // Resolve ref to commit hash
    let ref_spec = match &dep.reference {
        GitRef::Tag(t) => format!("refs/tags/{}", t),
        GitRef::Branch(b) => format!("refs/heads/{}", b),
        GitRef::Rev(r) => r.clone(),
        GitRef::Default => "HEAD".to_string(),
    };

    let output = Command::new("git")
        .args(["rev-parse", &ref_spec])
        .current_dir(&repo_dir)
        .output()
        .map_err(|e| format!("git rev-parse failed: {}", e))?;

    if !output.status.success() {
        let stderr = String::from_utf8_lossy(&output.stderr);
        return Err(format!(
            "ref '{}' not found in '{}': {}",
            ref_spec, dep.url, stderr
        ));
    }

    let resolved_rev = String::from_utf8_lossy(&output.stdout)
        .trim()
        .to_string();

    // Create a checkout directory for this specific revision
    let checkout_dir = git_cache.join(format!(
        "{}-{}",
        dir_name,
        &resolved_rev[..12.min(resolved_rev.len())]
    ));

    if !checkout_dir.exists() {
        // Create worktree or archive checkout
        let output = Command::new("git")
            .args(["archive", "--format=tar", &resolved_rev])
            .current_dir(&repo_dir)
            .output()
            .map_err(|e| format!("git archive failed: {}", e))?;

        if output.status.success() {
            std::fs::create_dir_all(&checkout_dir)
                .map_err(|e| format!("cannot create checkout dir: {}", e))?;

            // Extract tar to checkout dir
            let tar_output = Command::new("tar")
                .args(["xf", "-"])
                .current_dir(&checkout_dir)
                .stdin(std::process::Stdio::piped())
                .spawn()
                .and_then(|mut child| {
                    use std::io::Write;
                    child.stdin.as_mut().unwrap().write_all(&output.stdout)?;
                    child.wait()
                })
                .map_err(|e| format!("tar extract failed: {}", e))?;

            if !tar_output.success() {
                return Err("failed to extract git archive".to_string());
            }
        }
    }

    // Verify package.toml exists
    if !checkout_dir.join("package.toml").exists() {
        return Err(format!(
            "git dependency '{}' at {} (rev {}) has no package.toml",
            dep.name,
            dep.url,
            &resolved_rev[..12.min(resolved_rev.len())]
        ));
    }

    Ok(ResolvedGitDep {
        name: dep.name.clone(),
        url: dep.url.clone(),
        reference: dep.reference.clone(),
        resolved_rev,
        checkout_path: checkout_dir,
    })
}

/// Simple hash for directory naming (not cryptographic)
fn simple_hash(s: &str) -> String {
    let mut hash: u64 = 5381;
    for byte in s.bytes() {
        hash = hash.wrapping_mul(33).wrapping_add(byte as u64);
    }
    format!("{:016x}", hash)
}

/// Format the lockfile source string for a git dependency
pub fn lockfile_source(dep: &ResolvedGitDep) -> String {
    format!("git+{}@{}", dep.url, dep.resolved_rev)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_git_dep_tag() {
        let val: toml::Value = toml::from_str(
            r#"git = "https://github.com/user/repo"
tag = "v1.0.0""#,
        )
        .unwrap();
        let dep = parse_git_dep("my-dep", &val).unwrap();
        assert_eq!(dep.name, "my-dep");
        assert_eq!(dep.url, "https://github.com/user/repo");
        assert!(matches!(dep.reference, GitRef::Tag(ref t) if t == "v1.0.0"));
    }

    #[test]
    fn test_parse_git_dep_branch() {
        let val: toml::Value = toml::from_str(
            r#"git = "https://github.com/user/repo"
branch = "main""#,
        )
        .unwrap();
        let dep = parse_git_dep("my-dep", &val).unwrap();
        assert!(matches!(dep.reference, GitRef::Branch(ref b) if b == "main"));
    }

    #[test]
    fn test_parse_git_dep_rev() {
        let val: toml::Value = toml::from_str(
            r#"git = "https://github.com/user/repo"
rev = "abc123""#,
        )
        .unwrap();
        let dep = parse_git_dep("my-dep", &val).unwrap();
        assert!(matches!(dep.reference, GitRef::Rev(ref r) if r == "abc123"));
    }

    #[test]
    fn test_parse_git_dep_default() {
        let val: toml::Value =
            toml::from_str(r#"git = "https://github.com/user/repo""#).unwrap();
        let dep = parse_git_dep("my-dep", &val).unwrap();
        assert!(matches!(dep.reference, GitRef::Default));
    }

    #[test]
    fn test_parse_non_git() {
        let val: toml::Value = toml::Value::String("^1.0.0".to_string());
        assert!(parse_git_dep("pkg", &val).is_none());
    }

    #[test]
    fn test_simple_hash() {
        let h1 = simple_hash("https://github.com/user/repo1");
        let h2 = simple_hash("https://github.com/user/repo2");
        assert_ne!(h1, h2);
        // Deterministic
        assert_eq!(h1, simple_hash("https://github.com/user/repo1"));
    }

    #[test]
    fn test_lockfile_source_format() {
        let dep = ResolvedGitDep {
            name: "test".to_string(),
            url: "https://github.com/user/repo".to_string(),
            reference: GitRef::Tag("v1.0.0".to_string()),
            resolved_rev: "abc123def456".to_string(),
            checkout_path: PathBuf::from("/tmp/cache/test"),
        };
        assert_eq!(
            lockfile_source(&dep),
            "git+https://github.com/user/repo@abc123def456"
        );
    }
}
