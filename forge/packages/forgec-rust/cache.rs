use std::path::{Path, PathBuf};

// ── Path helpers ───────────────────────────────────────────────────

/// Returns `~/.forge/cache/`
pub fn forge_cache_dir() -> PathBuf {
    let home = std::env::var("HOME").unwrap_or_else(|_| "/tmp".to_string());
    PathBuf::from(home).join(".forge").join("cache")
}

/// Creates all cache subdirectories if they don't exist.
pub fn ensure_cache_dirs() {
    let base = forge_cache_dir();
    for subdir in &["artifacts", "source", "context", "index", "git"] {
        std::fs::create_dir_all(base.join(subdir)).ok();
    }
}

// ── Size helpers ───────────────────────────────────────────────────

/// Recursively compute the total byte size of a directory.
fn dir_size(path: &Path) -> u64 {
    if !path.exists() {
        return 0;
    }
    let mut total = 0u64;
    if let Ok(entries) = std::fs::read_dir(path) {
        for entry in entries.flatten() {
            let p = entry.path();
            if p.is_dir() {
                total += dir_size(&p);
            } else if let Ok(meta) = entry.metadata() {
                total += meta.len();
            }
        }
    }
    total
}

/// Format a byte count as a human-readable string (B / KB / MB / GB).
fn human_size(bytes: u64) -> String {
    if bytes < 1024 {
        format!("{} B", bytes)
    } else if bytes < 1024 * 1024 {
        format!("{:.1} KB", bytes as f64 / 1024.0)
    } else if bytes < 1024 * 1024 * 1024 {
        format!("{:.1} MB", bytes as f64 / (1024.0 * 1024.0))
    } else {
        format!("{:.2} GB", bytes as f64 / (1024.0 * 1024.0 * 1024.0))
    }
}

// ── Public API ─────────────────────────────────────────────────────

/// Returns a formatted table showing cache sizes per tier.
pub fn cache_status() -> String {
    let base = forge_cache_dir();

    // Tier 1 — never auto-evicted
    let artifacts = dir_size(&base.join("artifacts"));
    let index = dir_size(&base.join("index"));
    let git = dir_size(&base.join("git"));
    let tier1 = artifacts + index + git;

    // Tier 2 — evictable
    let source = dir_size(&base.join("source"));
    let context = dir_size(&base.join("context"));
    let tier2 = source + context;

    let total = tier1 + tier2;

    let mut out = String::new();
    out.push_str(&format!(
        "\n  \x1b[1mForge cache\x1b[0m  \x1b[2m({})\x1b[0m\n\n",
        base.display()
    ));

    // Header row
    out.push_str("  \x1b[2m  Dir         Size       Tier   Policy\x1b[0m\n");
    out.push_str("  \x1b[2m  ─────────────────────────────────────\x1b[0m\n");

    // Tier 1 rows
    out.push_str(&format!(
        "  \x1b[32m\u{2713}\x1b[0m  artifacts  {:>8}   T1     keep\n",
        human_size(artifacts)
    ));
    out.push_str(&format!(
        "  \x1b[32m\u{2713}\x1b[0m  index      {:>8}   T1     keep\n",
        human_size(index)
    ));
    out.push_str(&format!(
        "  \x1b[32m\u{2713}\x1b[0m  git        {:>8}   T1     keep\n",
        human_size(git)
    ));

    // Tier 2 rows
    out.push_str(&format!(
        "  \x1b[33m~\x1b[0m  source     {:>8}   T2     evictable\n",
        human_size(source)
    ));
    out.push_str(&format!(
        "  \x1b[33m~\x1b[0m  context    {:>8}   T2     evictable\n",
        human_size(context)
    ));

    out.push_str("  \x1b[2m  ─────────────────────────────────────\x1b[0m\n");
    out.push_str(&format!(
        "     Tier 1 (keep)     {:>8}\n",
        human_size(tier1)
    ));
    out.push_str(&format!(
        "     Tier 2 (evictable){:>8}\n",
        human_size(tier2)
    ));
    out.push_str(&format!(
        "     \x1b[1mTotal             {:>8}\x1b[0m\n",
        human_size(total)
    ));
    out.push('\n');

    out
}

/// Remove all files under a directory, returning (files_removed, bytes_freed).
fn evict_dir(path: &Path) -> (usize, u64) {
    if !path.exists() {
        return (0, 0);
    }
    let mut files = 0usize;
    let mut bytes = 0u64;
    if let Ok(entries) = std::fs::read_dir(path) {
        for entry in entries.flatten() {
            let p = entry.path();
            let size = if p.is_dir() {
                dir_size(&p)
            } else {
                entry.metadata().map(|m| m.len()).unwrap_or(0)
            };
            let removed = if p.is_dir() {
                std::fs::remove_dir_all(&p).is_ok()
            } else {
                std::fs::remove_file(&p).is_ok()
            };
            if removed {
                files += 1;
                bytes += size;
            }
        }
    }
    (files, bytes)
}

/// Evict Tier 2 caches (source/, context/).
/// If `aggressive` is true, also evicts git/ repos not referenced by the
/// project lockfile in `project_dir` (if provided).
pub fn cache_gc(aggressive: bool, project_dir: Option<&Path>) -> Result<String, String> {
    let base = forge_cache_dir();
    let mut total_files = 0usize;
    let mut total_bytes = 0u64;
    let mut out = String::new();

    // Always evict Tier 2
    for subdir in &["source", "context"] {
        let dir = base.join(subdir);
        let (files, bytes) = evict_dir(&dir);
        if files > 0 {
            out.push_str(&format!(
                "  \x1b[33m~\x1b[0m  evicted {} item(s) from {}/ ({})\n",
                files,
                subdir,
                human_size(bytes)
            ));
        } else {
            out.push_str(&format!("  \x1b[2m  {}/ is already empty\x1b[0m\n", subdir));
        }
        total_files += files;
        total_bytes += bytes;
    }

    // Aggressive: evict git/ repos not in lockfile
    if aggressive {
        let git_dir = base.join("git");
        if git_dir.exists() {
            let pinned = load_lockfile_git_deps(project_dir);
            let mut evicted_repos = 0usize;
            let mut evicted_bytes = 0u64;

            if let Ok(entries) = std::fs::read_dir(&git_dir) {
                for entry in entries.flatten() {
                    let path = entry.path();
                    let name = path
                        .file_name()
                        .and_then(|n| n.to_str())
                        .unwrap_or("")
                        .to_string();
                    if !pinned.contains(&name) {
                        let size = dir_size(&path);
                        let removed = if path.is_dir() {
                            std::fs::remove_dir_all(&path).is_ok()
                        } else {
                            std::fs::remove_file(&path).is_ok()
                        };
                        if removed {
                            evicted_repos += 1;
                            evicted_bytes += size;
                        }
                    }
                }
            }

            if evicted_repos > 0 {
                out.push_str(&format!(
                    "  \x1b[33m~\x1b[0m  evicted {} git repo(s) from git/ ({})\n",
                    evicted_repos,
                    human_size(evicted_bytes)
                ));
                total_files += evicted_repos;
                total_bytes += evicted_bytes;
            } else {
                out.push_str("  \x1b[2m  git/ has no evictable repos\x1b[0m\n");
            }
        }
    }

    if total_files == 0 {
        out.push_str("  nothing to evict — cache is already clean\n");
    } else {
        out.push_str(&format!(
            "\n  freed {} across {} item(s)\n",
            human_size(total_bytes),
            total_files
        ));
    }

    Ok(out)
}

/// Load git dependency identifiers from forge.lock (repo slugs used as dir names).
/// Returns an empty set if there is no lockfile or it can't be parsed.
fn load_lockfile_git_deps(project_dir: Option<&Path>) -> std::collections::HashSet<String> {
    let mut pinned = std::collections::HashSet::new();
    let dir = match project_dir {
        Some(d) => d.to_path_buf(),
        None => std::env::current_dir().unwrap_or_else(|_| PathBuf::from(".")),
    };
    let lockfile = dir.join("forge.lock");
    if let Ok(content) = std::fs::read_to_string(&lockfile) {
        // Simple heuristic: lines like `git = "https://github.com/org/repo.git"`
        // We derive the dir name from the last path segment without `.git`.
        for line in content.lines() {
            let line = line.trim();
            if line.starts_with("git") && line.contains("github.com") {
                if let Some(url_part) = line.split('"').nth(1) {
                    let slug = url_part
                        .trim_end_matches(".git")
                        .rsplit('/')
                        .next()
                        .unwrap_or("")
                        .to_string();
                    if !slug.is_empty() {
                        pinned.insert(slug);
                    }
                }
            }
        }
    }
    pinned
}

/// Wipe the entire cache (all subdirs under `~/.forge/cache/`).
pub fn cache_clear() -> Result<String, String> {
    let base = forge_cache_dir();
    if !base.exists() {
        return Ok("  cache directory does not exist — nothing to clear\n".to_string());
    }

    let size_before = dir_size(&base);
    let mut out = String::new();

    for subdir in &["artifacts", "source", "context", "index", "git"] {
        let dir = base.join(subdir);
        if dir.exists() {
            match std::fs::remove_dir_all(&dir) {
                Ok(_) => {
                    out.push_str(&format!("  \x1b[31m\u{2717}\x1b[0m  removed {}/\n", subdir));
                }
                Err(e) => {
                    return Err(format!("failed to remove {}/: {}", subdir, e));
                }
            }
        }
    }

    // Recreate empty dirs so the cache is usable immediately
    ensure_cache_dirs();

    out.push_str(&format!(
        "\n  cache cleared — freed {}\n",
        human_size(size_before)
    ));

    Ok(out)
}

/// Check which deps are declared in forge.lock and report which are / are not
/// in the local cache. No HTTP fetching is performed; this is a dry-run report.
pub fn cache_prefetch(project_dir: &Path) -> Result<String, String> {
    let lockfile = project_dir.join("forge.lock");
    if !lockfile.exists() {
        return Err(
            "no forge.lock found — run `forge build` first to generate a lockfile".to_string(),
        );
    }

    let content = std::fs::read_to_string(&lockfile)
        .map_err(|e| format!("cannot read forge.lock: {}", e))?;

    let base = forge_cache_dir();
    let mut out = String::new();
    out.push_str("  \x1b[1mprefetch dry-run\x1b[0m  (HTTP not yet available)\n\n");

    // Collect [[package]] blocks
    let package_blocks: Vec<&str> = content.split("[[package]]").skip(1).collect();

    if package_blocks.is_empty() {
        out.push_str("  no packages in forge.lock\n");
        return Ok(out);
    }

    let mut cached = 0usize;
    let mut missing = 0usize;

    for block in &package_blocks {
        let name = block
            .lines()
            .find(|l| l.trim_start().starts_with("name"))
            .and_then(|l| l.split('"').nth(1))
            .unwrap_or("unknown");
        let version = block
            .lines()
            .find(|l| l.trim_start().starts_with("version"))
            .and_then(|l| l.split('"').nth(1))
            .unwrap_or("0.0.0");

        // Check Tier 1: does an artifact exist?
        let artifact_exists = base.join("artifacts").join(format!("{}-{}.a", name, version)).exists()
            || base.join("artifacts").join(name).exists();

        if artifact_exists {
            out.push_str(&format!(
                "  \x1b[32m\u{2713}\x1b[0m  {}@{}  in cache\n",
                name, version
            ));
            cached += 1;
        } else {
            out.push_str(&format!(
                "  \x1b[33m~\x1b[0m  {}@{}  \x1b[2mwould fetch\x1b[0m\n",
                name, version
            ));
            missing += 1;
        }
    }

    out.push_str(&format!(
        "\n  {} cached, {} would be fetched\n",
        cached, missing
    ));
    if missing > 0 {
        out.push_str(
            "  \x1b[2mrun `forge build` when online to populate the cache\x1b[0m\n",
        );
    }

    Ok(out)
}

// ── Tests ──────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_human_size_bytes() {
        assert_eq!(human_size(0), "0 B");
        assert_eq!(human_size(512), "512 B");
        assert_eq!(human_size(1023), "1023 B");
    }

    #[test]
    fn test_human_size_kb() {
        assert_eq!(human_size(1024), "1.0 KB");
        assert_eq!(human_size(2048), "2.0 KB");
    }

    #[test]
    fn test_human_size_mb() {
        assert_eq!(human_size(1024 * 1024), "1.0 MB");
    }

    #[test]
    fn test_human_size_gb() {
        assert_eq!(human_size(1024 * 1024 * 1024), "1.00 GB");
    }

    #[test]
    fn test_cache_status_contains_dirs() {
        let status = cache_status();
        assert!(status.contains("artifacts"));
        assert!(status.contains("source"));
        assert!(status.contains("context"));
        assert!(status.contains("index"));
        assert!(status.contains("git"));
        assert!(status.contains("Tier 1"));
        assert!(status.contains("Tier 2"));
    }

    #[test]
    fn test_forge_cache_dir_under_home() {
        let dir = forge_cache_dir();
        let s = dir.to_string_lossy();
        assert!(s.contains(".forge"));
        assert!(s.contains("cache"));
    }
}
