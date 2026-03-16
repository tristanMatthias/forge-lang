use std::path::{Path, PathBuf};

/// Supported target triples
pub const TARGETS: &[&str] = &[
    "x86_64-unknown-linux-gnu",
    "aarch64-unknown-linux-gnu",
    "x86_64-apple-darwin",
    "aarch64-apple-darwin",
    "wasm32-wasi",
];

/// Detect the current platform's target triple
pub fn current_target() -> &'static str {
    #[cfg(all(target_arch = "x86_64", target_os = "linux"))]
    { "x86_64-unknown-linux-gnu" }
    #[cfg(all(target_arch = "aarch64", target_os = "linux"))]
    { "aarch64-unknown-linux-gnu" }
    #[cfg(all(target_arch = "x86_64", target_os = "macos"))]
    { "x86_64-apple-darwin" }
    #[cfg(all(target_arch = "aarch64", target_os = "macos"))]
    { "aarch64-apple-darwin" }
    #[cfg(not(any(
        all(target_arch = "x86_64", target_os = "linux"),
        all(target_arch = "aarch64", target_os = "linux"),
        all(target_arch = "x86_64", target_os = "macos"),
        all(target_arch = "aarch64", target_os = "macos"),
    )))]
    { "unknown" }
}

/// Type of pre-compiled artifact
#[derive(Debug, Clone, PartialEq)]
pub enum ArtifactKind {
    /// LLVM bitcode for pure Forge packages
    Bitcode,
    /// Static library for native packages
    StaticLib,
}

/// Metadata about a cached artifact
#[derive(Debug, Clone)]
pub struct ArtifactInfo {
    pub package: String,
    pub version: String,
    pub target: String,
    pub kind: ArtifactKind,
    pub hash: String,       // SHA-256
    pub size_bytes: u64,
    pub path: PathBuf,
}

/// Look up a cached artifact for a package
pub fn find_cached_artifact(
    cache_dir: &Path,
    package: &str,
    version: &str,
    target: &str,
) -> Option<ArtifactInfo> {
    let artifacts_dir = cache_dir.join("artifacts");

    // Check for static lib (.a)
    let lib_name = format!("lib{}_{}.a", package.replace('-', "_"), target.replace('-', "_"));
    let lib_path = artifacts_dir.join(&lib_name);
    if lib_path.exists() {
        let size = std::fs::metadata(&lib_path).ok()?.len();
        return Some(ArtifactInfo {
            package: package.to_string(),
            version: version.to_string(),
            target: target.to_string(),
            kind: ArtifactKind::StaticLib,
            hash: String::new(), // would be computed from file
            size_bytes: size,
            path: lib_path,
        });
    }

    // Check for bitcode (.bc)
    let bc_name = format!("{}_{}.bc", package.replace('-', "_"), target.replace('-', "_"));
    let bc_path = artifacts_dir.join(&bc_name);
    if bc_path.exists() {
        let size = std::fs::metadata(&bc_path).ok()?.len();
        return Some(ArtifactInfo {
            package: package.to_string(),
            version: version.to_string(),
            target: target.to_string(),
            kind: ArtifactKind::Bitcode,
            hash: String::new(),
            size_bytes: size,
            path: bc_path,
        });
    }

    None
}

/// Download a pre-compiled artifact from the registry
pub fn download_artifact(
    registry_url: &str,
    package: &str,
    version: &str,
    target: &str,
    cache_dir: &Path,
) -> Result<ArtifactInfo, String> {
    let _url = format!(
        "{}/v1/packages/{}/{}/artifact/{}",
        registry_url, package, version, target
    );

    let artifacts_dir = cache_dir.join("artifacts");
    std::fs::create_dir_all(&artifacts_dir)
        .map_err(|e| format!("cannot create artifacts cache: {}", e))?;

    // TODO: HTTP GET to download artifact
    // For now, return not-found
    Err(format!(
        "artifact not available for {} v{} (target: {}). \
         Install the package's build toolchain to compile from source.",
        package, version, target
    ))
}

/// Verify an artifact's hash matches expected
pub fn verify_artifact(
    artifact: &ArtifactInfo,
    expected_hash: &str,
) -> Result<(), String> {
    if expected_hash.is_empty() || artifact.hash.is_empty() {
        return Ok(()); // Skip verification if no hash available
    }

    if artifact.hash != expected_hash {
        return Err(format!(
            "artifact hash mismatch for {} v{} (target: {})\n  expected: {}\n  got: {}",
            artifact.package, artifact.version, artifact.target,
            expected_hash, artifact.hash
        ));
    }

    Ok(())
}

/// Get the artifact resolution strategy for a package
pub fn resolve_artifact(
    package: &str,
    version: &str,
    is_native: bool,
    cache_dir: &Path,
    registry_url: &str,
) -> ArtifactResolution {
    let target = current_target();

    // Check cache first
    if let Some(cached) = find_cached_artifact(cache_dir, package, version, target) {
        return ArtifactResolution::Cached(cached);
    }

    // Try to download
    match download_artifact(registry_url, package, version, target, cache_dir) {
        Ok(info) => ArtifactResolution::Downloaded(info),
        Err(_) => {
            if is_native {
                ArtifactResolution::BuildFromSource
            } else {
                ArtifactResolution::CompileFromForge
            }
        }
    }
}

/// How an artifact will be obtained
#[derive(Debug)]
pub enum ArtifactResolution {
    /// Found in local cache
    Cached(ArtifactInfo),
    /// Downloaded from registry
    Downloaded(ArtifactInfo),
    /// Must compile native code from source
    BuildFromSource,
    /// Must compile pure Forge to bitcode
    CompileFromForge,
}

/// Format artifact size for display
pub fn format_size(bytes: u64) -> String {
    if bytes >= 1_048_576 {
        format!("{:.1}MB", bytes as f64 / 1_048_576.0)
    } else if bytes >= 1024 {
        format!("{:.1}KB", bytes as f64 / 1024.0)
    } else {
        format!("{}B", bytes)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_current_target_is_known() {
        let target = current_target();
        assert_ne!(target, "unknown", "target should be detected");
        assert!(TARGETS.contains(&target), "target {} should be in TARGETS list", target);
    }

    #[test]
    fn test_format_size() {
        assert_eq!(format_size(500), "500B");
        assert_eq!(format_size(1500), "1.5KB");
        assert_eq!(format_size(2_500_000), "2.4MB");
    }

    #[test]
    fn test_verify_artifact_empty_hash() {
        let info = ArtifactInfo {
            package: "test".to_string(),
            version: "1.0.0".to_string(),
            target: "x86_64-apple-darwin".to_string(),
            kind: ArtifactKind::StaticLib,
            hash: String::new(),
            size_bytes: 0,
            path: PathBuf::from("/tmp/test.a"),
        };
        assert!(verify_artifact(&info, "").is_ok());
    }
}
