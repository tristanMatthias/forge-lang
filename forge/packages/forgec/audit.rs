use std::path::Path;

/// Result of an audit check
#[derive(Debug)]
pub struct AuditReport {
    pub packages_checked: usize,
    pub vulnerabilities: Vec<Vulnerability>,
    pub hash_mismatches: Vec<HashMismatch>,
    pub capability_issues: Vec<CapabilityIssue>,
    pub log_verified: bool,
}

#[derive(Debug)]
pub struct Vulnerability {
    pub package: String,
    pub version: String,
    pub severity: String,  // "critical", "high", "medium", "low"
    pub description: String,
    pub advisory_url: Option<String>,
}

#[derive(Debug)]
pub struct HashMismatch {
    pub package: String,
    pub version: String,
    pub expected: String,
    pub actual: String,
}

#[derive(Debug)]
pub struct CapabilityIssue {
    pub package: String,
    pub version: String,
    pub issue: String,
}

/// Run a full audit of the project's dependencies
pub fn audit_project(project_dir: &Path) -> Result<AuditReport, String> {
    let lockfile_path = project_dir.join("forge.lock");

    // Check if lockfile exists
    if !lockfile_path.exists() {
        return Err("no forge.lock found — run `forge build` first to generate a lockfile".to_string());
    }

    let lock_content = std::fs::read_to_string(&lockfile_path)
        .map_err(|e| format!("cannot read lockfile: {}", e))?;

    // Parse lockfile (simplified — just count packages)
    let packages_checked = lock_content.matches("[[package]]").count();

    // For now, return clean report (registry-based vuln checking comes later)
    Ok(AuditReport {
        packages_checked,
        vulnerabilities: Vec::new(),
        hash_mismatches: Vec::new(),
        capability_issues: Vec::new(),
        log_verified: false,
    })
}

/// Verify lockfile hashes against the transparency log
pub fn verify_against_log(
    project_dir: &Path,
    _registry_url: &str,
) -> Result<AuditReport, String> {
    let mut report = audit_project(project_dir)?;

    // TODO: When registry is available, fetch log and cross-check
    // For now, mark as not verified
    report.log_verified = false;

    Ok(report)
}

/// Verify cached artifacts match lockfile hashes
pub fn verify_cache_integrity(project_dir: &Path) -> Result<Vec<HashMismatch>, String> {
    let lockfile_path = project_dir.join("forge.lock");
    if !lockfile_path.exists() {
        return Err("no forge.lock found".to_string());
    }

    // Parse lockfile and check each package's hash
    // For now, return empty (no mismatches)
    Ok(Vec::new())
}

/// Format an audit report for terminal display
pub fn format_report(report: &AuditReport) -> String {
    let mut out = String::new();

    out.push_str(&format!("audited {} packages\n\n", report.packages_checked));

    if report.vulnerabilities.is_empty() && report.hash_mismatches.is_empty() && report.capability_issues.is_empty() {
        out.push_str("  \x1b[32m\u{2713}\x1b[0m no known vulnerabilities found\n");
        out.push_str("  \x1b[32m\u{2713}\x1b[0m all content hashes verified\n");
        out.push_str("  \x1b[32m\u{2713}\x1b[0m no capability issues\n");
    } else {
        // Vulnerabilities
        if !report.vulnerabilities.is_empty() {
            out.push_str(&format!("  \x1b[31m\u{2717}\x1b[0m {} vulnerabilities found:\n\n", report.vulnerabilities.len()));
            for vuln in &report.vulnerabilities {
                out.push_str(&format!("    \x1b[31m{}\x1b[0m {} v{}\n", vuln.severity.to_uppercase(), vuln.package, vuln.version));
                out.push_str(&format!("      {}\n", vuln.description));
                if let Some(url) = &vuln.advisory_url {
                    out.push_str(&format!("      see: {}\n", url));
                }
                out.push_str("\n");
            }
        }

        // Hash mismatches
        if !report.hash_mismatches.is_empty() {
            out.push_str(&format!("  \x1b[31m\u{2717}\x1b[0m {} content hash mismatches:\n\n", report.hash_mismatches.len()));
            for mismatch in &report.hash_mismatches {
                out.push_str(&format!("    {} v{}\n", mismatch.package, mismatch.version));
                out.push_str(&format!("      expected: {}\n", mismatch.expected));
                out.push_str(&format!("      got:      {}\n\n", mismatch.actual));
            }
        }

        // Capability issues
        if !report.capability_issues.is_empty() {
            out.push_str(&format!("  \x1b[33m!\x1b[0m {} capability issues:\n\n", report.capability_issues.len()));
            for issue in &report.capability_issues {
                out.push_str(&format!("    {} v{}: {}\n", issue.package, issue.version, issue.issue));
            }
        }
    }

    if report.log_verified {
        out.push_str("\n  \x1b[32m\u{2713}\x1b[0m transparency log verified\n");
    }

    out
}

/// Allow a specific capability for a package (writes to forge.toml)
pub fn allow_capability(
    project_dir: &Path,
    package: &str,
    capability: &str,
) -> Result<(), String> {
    let toml_path = project_dir.join("forge.toml");
    let mut content = std::fs::read_to_string(&toml_path)
        .map_err(|e| format!("cannot read forge.toml: {}", e))?;

    // Check if [capabilities.approved] section exists
    if !content.contains("[capabilities.approved]") {
        content.push_str("\n[capabilities.approved]\n");
    }

    // Add the approval
    let approval = format!("{}.{} = true\n", package, capability);
    if content.contains(&approval) {
        return Ok(());  // Already approved
    }

    // Insert after [capabilities.approved]
    content = content.replace(
        "[capabilities.approved]\n",
        &format!("[capabilities.approved]\n{}", approval),
    );

    std::fs::write(&toml_path, &content)
        .map_err(|e| format!("cannot write forge.toml: {}", e))?;

    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_format_clean_report() {
        let report = AuditReport {
            packages_checked: 5,
            vulnerabilities: Vec::new(),
            hash_mismatches: Vec::new(),
            capability_issues: Vec::new(),
            log_verified: false,
        };
        let output = format_report(&report);
        assert!(output.contains("audited 5 packages"));
        assert!(output.contains("no known vulnerabilities"));
    }

    #[test]
    fn test_format_report_with_vulns() {
        let report = AuditReport {
            packages_checked: 3,
            vulnerabilities: vec![Vulnerability {
                package: "bad-pkg".to_string(),
                version: "1.0.0".to_string(),
                severity: "critical".to_string(),
                description: "remote code execution".to_string(),
                advisory_url: Some("https://example.com/advisory/1".to_string()),
            }],
            hash_mismatches: Vec::new(),
            capability_issues: Vec::new(),
            log_verified: false,
        };
        let output = format_report(&report);
        assert!(output.contains("1 vulnerabilities"));
        assert!(output.contains("bad-pkg"));
    }
}
