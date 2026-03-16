use crate::errors::CompileError;
use crate::package::PackageCapabilities;

/// Compare capabilities between two versions of a package.
/// Returns the list of newly added capabilities.
pub fn detect_escalation(
    old_caps: &PackageCapabilities,
    new_caps: &PackageCapabilities,
) -> Vec<String> {
    let mut new = Vec::new();
    if !old_caps.network && new_caps.network {
        new.push("network".to_string());
    }
    if !old_caps.filesystem && new_caps.filesystem {
        new.push("filesystem".to_string());
    }
    if !old_caps.compile_time_codegen && new_caps.compile_time_codegen {
        new.push("compile_time_codegen".to_string());
    }
    if !old_caps.native && new_caps.native {
        new.push("native".to_string());
    }
    if !old_caps.ffi && new_caps.ffi {
        new.push("ffi".to_string());
    }
    new
}

/// Classify version bump as major, minor, or patch
#[derive(Debug, PartialEq)]
pub enum BumpKind {
    Major,
    Minor,
    Patch,
    Unknown,
}

pub fn classify_bump(old_version: &str, new_version: &str) -> BumpKind {
    let old_parts: Vec<u64> = old_version
        .split('.')
        .filter_map(|s| s.parse().ok())
        .collect();
    let new_parts: Vec<u64> = new_version
        .split('.')
        .filter_map(|s| s.parse().ok())
        .collect();
    if old_parts.len() < 3 || new_parts.len() < 3 {
        return BumpKind::Unknown;
    }
    if new_parts[0] > old_parts[0] {
        return BumpKind::Major;
    }
    if new_parts[1] > old_parts[1] {
        return BumpKind::Minor;
    }
    if new_parts[2] > old_parts[2] {
        return BumpKind::Patch;
    }
    BumpKind::Unknown
}

/// Check if a version update introduces capability escalation.
/// For patch updates, any new capability is a hard error (E0462).
/// For minor updates, new capabilities generate a warning.
/// For major updates, new capabilities are expected.
pub fn check_escalation(
    package_name: &str,
    old_version: &str,
    new_version: &str,
    old_caps: &PackageCapabilities,
    new_caps: &PackageCapabilities,
) -> Result<Option<EscalationWarning>, CompileError> {
    let new_capabilities = detect_escalation(old_caps, new_caps);
    if new_capabilities.is_empty() {
        return Ok(None);
    }

    let bump = classify_bump(old_version, new_version);

    match bump {
        BumpKind::Patch => {
            // Hard error -- patches should NEVER need new capabilities
            Err(CompileError::CapabilityEscalation {
                package: package_name.to_string(),
                old_version: old_version.to_string(),
                new_version: new_version.to_string(),
                old_caps: format_caps(old_caps),
                new_caps: format_caps(new_caps),
            })
        }
        BumpKind::Minor => {
            // Warning -- minor updates shouldn't usually need new capabilities
            Ok(Some(EscalationWarning {
                package: package_name.to_string(),
                old_version: old_version.to_string(),
                new_version: new_version.to_string(),
                new_capabilities,
                severity: EscalationSeverity::Warning,
            }))
        }
        BumpKind::Major | BumpKind::Unknown => {
            // Info -- major updates can introduce new capabilities
            Ok(Some(EscalationWarning {
                package: package_name.to_string(),
                old_version: old_version.to_string(),
                new_version: new_version.to_string(),
                new_capabilities,
                severity: EscalationSeverity::Info,
            }))
        }
    }
}

#[derive(Debug, PartialEq)]
pub enum EscalationSeverity {
    Warning,
    Info,
}

#[derive(Debug)]
pub struct EscalationWarning {
    pub package: String,
    pub old_version: String,
    pub new_version: String,
    pub new_capabilities: Vec<String>,
    pub severity: EscalationSeverity,
}

fn format_caps(caps: &PackageCapabilities) -> Vec<String> {
    let mut v = Vec::new();
    if caps.network {
        v.push("network".to_string());
    }
    if caps.filesystem {
        v.push("filesystem".to_string());
    }
    if caps.compile_time_codegen {
        v.push("compile_time_codegen".to_string());
    }
    if caps.native {
        v.push("native".to_string());
    }
    if caps.ffi {
        v.push("ffi".to_string());
    }
    v
}

/// Check if a capability has been explicitly approved by the user.
/// Approvals stored in forge.toml [capabilities.approved]
pub fn is_approved(project_dir: &std::path::Path, package: &str, capability: &str) -> bool {
    let toml_path = project_dir.join("forge.toml");
    let content = match std::fs::read_to_string(&toml_path) {
        Ok(c) => c,
        Err(_) => return false,
    };
    // Look for [capabilities.approved] section with package.capability = true
    let key = format!("{}.{}", package, capability);
    content.contains(&key)
}

// -- Unit tests ---------------------------------------------------------------

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_detect_no_escalation() {
        let old = PackageCapabilities {
            network: true,
            ..Default::default()
        };
        let new = PackageCapabilities {
            network: true,
            ..Default::default()
        };
        assert!(detect_escalation(&old, &new).is_empty());
    }

    #[test]
    fn test_detect_escalation() {
        let old = PackageCapabilities {
            network: true,
            ..Default::default()
        };
        let new = PackageCapabilities {
            network: true,
            filesystem: true,
            ..Default::default()
        };
        let esc = detect_escalation(&old, &new);
        assert_eq!(esc, vec!["filesystem"]);
    }

    #[test]
    fn test_classify_bump() {
        assert_eq!(classify_bump("1.0.0", "1.0.1"), BumpKind::Patch);
        assert_eq!(classify_bump("1.0.0", "1.1.0"), BumpKind::Minor);
        assert_eq!(classify_bump("1.0.0", "2.0.0"), BumpKind::Major);
    }

    #[test]
    fn test_patch_escalation_is_error() {
        let old = PackageCapabilities {
            network: true,
            ..Default::default()
        };
        let new = PackageCapabilities {
            network: true,
            filesystem: true,
            ..Default::default()
        };
        let result = check_escalation("suspicious-pkg", "1.0.0", "1.0.1", &old, &new);
        assert!(result.is_err());
    }

    #[test]
    fn test_minor_escalation_is_warning() {
        let old = PackageCapabilities {
            network: true,
            ..Default::default()
        };
        let new = PackageCapabilities {
            network: true,
            filesystem: true,
            ..Default::default()
        };
        let result = check_escalation("some-pkg", "1.0.0", "1.1.0", &old, &new);
        assert!(result.is_ok());
        let warning = result.unwrap().unwrap();
        assert_eq!(warning.severity, EscalationSeverity::Warning);
        assert_eq!(warning.new_capabilities, vec!["filesystem"]);
    }

    #[test]
    fn test_major_escalation_is_info() {
        let old = PackageCapabilities {
            network: true,
            ..Default::default()
        };
        let new = PackageCapabilities {
            network: true,
            filesystem: true,
            ..Default::default()
        };
        let result = check_escalation("some-pkg", "1.0.0", "2.0.0", &old, &new);
        assert!(result.is_ok());
        let warning = result.unwrap().unwrap();
        assert_eq!(warning.severity, EscalationSeverity::Info);
    }

    #[test]
    fn test_no_escalation_returns_none() {
        let caps = PackageCapabilities {
            network: true,
            ..Default::default()
        };
        let result = check_escalation("pkg", "1.0.0", "1.0.1", &caps, &caps);
        assert!(result.is_ok());
        assert!(result.unwrap().is_none());
    }

    #[test]
    fn test_multiple_new_capabilities() {
        let old = PackageCapabilities::default();
        let new = PackageCapabilities {
            network: true,
            filesystem: true,
            ffi: true,
            ..Default::default()
        };
        let esc = detect_escalation(&old, &new);
        assert_eq!(esc, vec!["network", "filesystem", "ffi"]);
    }

    #[test]
    fn test_classify_bump_unknown() {
        assert_eq!(classify_bump("bad", "1.0.0"), BumpKind::Unknown);
        assert_eq!(classify_bump("1.0.0", "1.0.0"), BumpKind::Unknown);
    }

    #[test]
    fn test_is_approved_missing_file() {
        let dir = std::path::Path::new("/tmp/forge_test_nonexistent_dir");
        assert!(!is_approved(dir, "some-pkg", "network"));
    }
}
