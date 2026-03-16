use std::collections::HashMap;
use crate::package::PackageCapabilities;
use crate::errors::CompileError;

/// Mapping from package namespace.name to which capabilities they require.
/// Any package not listed here is assumed to require no capabilities.
fn capability_grants() -> HashMap<&'static str, Vec<&'static str>> {
    let mut m = HashMap::new();
    m.insert("std.http", vec!["network"]);
    m.insert("std.fs", vec!["filesystem"]);
    m.insert("std.process", vec!["filesystem", "network"]);
    m.insert("std.channel", vec![]);
    m.insert("std.model", vec!["network"]);
    m.insert("std.queue", vec!["network"]);
    m.insert("std.cron", vec![]);
    m.insert("std.term", vec![]);
    m.insert("std.cli", vec![]);
    m.insert("std.test", vec![]);
    m.insert("std.auth", vec![]);
    m.insert("std.ai", vec!["network"]);
    m.insert("std.crypto", vec![]);
    m.insert("std.toml", vec![]);
    m.insert("std.semver", vec![]);
    m.insert("std.archive", vec!["filesystem"]);
    m.insert("std.cache", vec!["filesystem", "network"]);
    m
}

/// Check that a package's declared capabilities cover all its actual usage.
/// `used_packages` is the list of "namespace.name" packages this package imports
/// (e.g., ["std.http", "std.fs"]).
/// `has_native_code` is true if the package ships a native (.a) library.
///
/// Returns Ok(()) if all capabilities are covered, or a Vec of errors for each
/// missing capability.
pub fn check_capabilities(
    package_name: &str,
    declared: &PackageCapabilities,
    used_packages: &[String],
    has_native_code: bool,
) -> Result<(), Vec<CompileError>> {
    let grants = capability_grants();
    let mut required: HashMap<&str, String> = HashMap::new();

    // Collect required capabilities from each imported package
    for used in used_packages {
        if let Some(caps) = grants.get(used.as_str()) {
            for cap in caps {
                required.entry(cap)
                    .or_insert_with(|| format!("imports @{}", used));
            }
        }
    }

    // Native code requires the `native` capability
    if has_native_code {
        required.entry("native")
            .or_insert_with(|| "ships native code".to_string());
    }

    // Check each required capability against declared
    let mut errors = Vec::new();
    for (cap, location) in &required {
        let has_cap = match *cap {
            "network" => declared.network,
            "filesystem" => declared.filesystem,
            "native" => declared.native,
            "ffi" => declared.ffi,
            "compile_time_codegen" => declared.compile_time_codegen,
            _ => false,
        };
        if !has_cap {
            errors.push(CompileError::UndeclaredCapability {
                package: package_name.to_string(),
                capability: cap.to_string(),
                location: location.clone(),
            });
        }
    }

    if errors.is_empty() {
        Ok(())
    } else {
        Err(errors)
    }
}

/// Format a capability tree showing each package and its declared capabilities.
///
/// Example output:
/// ```text
/// graphql v3.1.0
///   capabilities: [network, native]
///   +-- http-client v1.0.0
///       capabilities: [network, native]
/// ```
pub fn capability_tree(
    packages: &[(String, PackageCapabilities)],
) -> String {
    let mut out = String::new();
    for (i, (name, caps)) in packages.iter().enumerate() {
        let cap_list = caps_to_list(caps);
        let is_last = i == packages.len() - 1;
        let prefix = if i == 0 { "" } else if is_last { "  +-- " } else { "  +-- " };
        out.push_str(&format!("{}{}\n", prefix, name));
        let indent = if i == 0 { "  " } else if is_last { "      " } else { "  |   " };
        if cap_list.is_empty() {
            out.push_str(&format!("{}capabilities: [none]\n", indent));
        } else {
            out.push_str(&format!("{}capabilities: [{}]\n", indent, cap_list.join(", ")));
        }
    }
    out
}

/// Check for capability escalation between two versions of a package.
///
/// - Patch updates (x.y.Z) must not introduce new capabilities.
/// - Minor updates (x.Y.z) may add capabilities (returns None — allowed).
/// - Major updates (X.y.z) may change capabilities freely (returns None).
///
/// Returns Some(CapabilityEscalation) if a patch update introduces new capabilities.
pub fn check_escalation(
    package_name: &str,
    old_caps: &PackageCapabilities,
    new_caps: &PackageCapabilities,
    old_version: &str,
    new_version: &str,
) -> Option<CompileError> {
    let old_list = caps_to_list(old_caps);
    let new_list = caps_to_list(new_caps);

    // If capabilities haven't changed, no escalation
    if old_list == new_list {
        return None;
    }

    // Check if new capabilities were added (not just removed)
    let new_additions: Vec<String> = new_list.iter()
        .filter(|c| !old_list.contains(c))
        .cloned()
        .collect();
    if new_additions.is_empty() {
        return None;
    }

    // Parse versions to determine update type
    let old_parts = parse_semver(old_version);
    let new_parts = parse_semver(new_version);

    match (old_parts, new_parts) {
        (Some((old_major, old_minor, _)), Some((new_major, new_minor, _))) => {
            // Major version bump — capabilities can change freely
            if new_major > old_major {
                return None;
            }
            // Minor version bump — capabilities can be added
            if new_minor > old_minor {
                return None;
            }
            // Patch update (or same version) — new capabilities are not allowed
            Some(CompileError::CapabilityEscalation {
                package: package_name.to_string(),
                old_version: old_version.to_string(),
                new_version: new_version.to_string(),
                old_caps: old_list,
                new_caps: new_list,
            })
        }
        _ => {
            // If we can't parse versions, be conservative and report escalation
            Some(CompileError::CapabilityEscalation {
                package: package_name.to_string(),
                old_version: old_version.to_string(),
                new_version: new_version.to_string(),
                old_caps: old_list,
                new_caps: new_list,
            })
        }
    }
}

/// Convert PackageCapabilities to a sorted list of capability names.
fn caps_to_list(caps: &PackageCapabilities) -> Vec<String> {
    let mut list = Vec::new();
    if caps.compile_time_codegen { list.push("compile_time_codegen".to_string()); }
    if caps.ffi { list.push("ffi".to_string()); }
    if caps.filesystem { list.push("filesystem".to_string()); }
    if caps.native { list.push("native".to_string()); }
    if caps.network { list.push("network".to_string()); }
    list
}

/// Parse a semver string "X.Y.Z" into (major, minor, patch).
/// Returns None if the string doesn't match.
fn parse_semver(version: &str) -> Option<(u64, u64, u64)> {
    let parts: Vec<&str> = version.split('.').collect();
    if parts.len() != 3 {
        return None;
    }
    let major = parts[0].parse().ok()?;
    let minor = parts[1].parse().ok()?;
    // Handle pre-release suffixes like "1.2.3-beta"
    let patch_str = parts[2].split('-').next()?;
    let patch = patch_str.parse().ok()?;
    Some((major, minor, patch))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_no_caps_needed() {
        let caps = PackageCapabilities::default();
        let result = check_capabilities("my-pkg", &caps, &[], false);
        assert!(result.is_ok());
    }

    #[test]
    fn test_network_required_but_undeclared() {
        let caps = PackageCapabilities::default();
        let used = vec!["std.http".to_string()];
        let result = check_capabilities("my-pkg", &caps, &used, false);
        assert!(result.is_err());
        let errors = result.unwrap_err();
        assert_eq!(errors.len(), 1);
        match &errors[0] {
            CompileError::UndeclaredCapability { capability, .. } => {
                assert_eq!(capability, "network");
            }
            _ => panic!("expected UndeclaredCapability"),
        }
    }

    #[test]
    fn test_network_declared() {
        let caps = PackageCapabilities { network: true, ..Default::default() };
        let used = vec!["std.http".to_string()];
        let result = check_capabilities("my-pkg", &caps, &used, false);
        assert!(result.is_ok());
    }

    #[test]
    fn test_native_required() {
        let caps = PackageCapabilities::default();
        let result = check_capabilities("my-pkg", &caps, &[], true);
        assert!(result.is_err());
        let errors = result.unwrap_err();
        assert_eq!(errors.len(), 1);
        match &errors[0] {
            CompileError::UndeclaredCapability { capability, .. } => {
                assert_eq!(capability, "native");
            }
            _ => panic!("expected UndeclaredCapability"),
        }
    }

    #[test]
    fn test_multiple_missing_caps() {
        let caps = PackageCapabilities::default();
        let used = vec!["std.process".to_string()];
        let result = check_capabilities("my-pkg", &caps, &used, true);
        assert!(result.is_err());
        let errors = result.unwrap_err();
        // process requires filesystem + network, plus native = 3 missing
        assert_eq!(errors.len(), 3);
    }

    #[test]
    fn test_escalation_patch() {
        let old = PackageCapabilities::default();
        let new = PackageCapabilities { network: true, ..Default::default() };
        let result = check_escalation("pkg", &old, &new, "1.0.0", "1.0.1");
        assert!(result.is_some());
    }

    #[test]
    fn test_escalation_minor_allowed() {
        let old = PackageCapabilities::default();
        let new = PackageCapabilities { network: true, ..Default::default() };
        let result = check_escalation("pkg", &old, &new, "1.0.0", "1.1.0");
        assert!(result.is_none());
    }

    #[test]
    fn test_escalation_major_allowed() {
        let old = PackageCapabilities::default();
        let new = PackageCapabilities { network: true, filesystem: true, ..Default::default() };
        let result = check_escalation("pkg", &old, &new, "1.0.0", "2.0.0");
        assert!(result.is_none());
    }

    #[test]
    fn test_no_escalation_same_caps() {
        let caps = PackageCapabilities { network: true, ..Default::default() };
        let result = check_escalation("pkg", &caps, &caps, "1.0.0", "1.0.1");
        assert!(result.is_none());
    }

    #[test]
    fn test_capability_tree() {
        let packages = vec![
            ("graphql v3.1.0".to_string(), PackageCapabilities { network: true, native: true, ..Default::default() }),
            ("http-client v1.0.0".to_string(), PackageCapabilities { network: true, native: true, ..Default::default() }),
        ];
        let tree = capability_tree(&packages);
        assert!(tree.contains("graphql v3.1.0"));
        assert!(tree.contains("capabilities: [native, network]"));
        assert!(tree.contains("http-client v1.0.0"));
    }

    #[test]
    fn test_parse_semver() {
        assert_eq!(parse_semver("1.2.3"), Some((1, 2, 3)));
        assert_eq!(parse_semver("0.1.0"), Some((0, 1, 0)));
        assert_eq!(parse_semver("1.2.3-beta"), Some((1, 2, 3)));
        assert_eq!(parse_semver("bad"), None);
    }
}
