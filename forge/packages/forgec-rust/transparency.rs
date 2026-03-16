/// Transparency log: an append-only audit trail of all publish events.
///
/// Each entry records a package publish with its content hash, author,
/// timestamp, and registry signature. The log can be verified for
/// sequential integrity and cross-checked against lockfile hashes.

use serde::{Deserialize, Serialize};

/// A single entry in the transparency log
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct LogEntry {
    /// Sequential entry number
    pub sequence: u64,
    /// Package name
    pub package: String,
    /// Published version
    pub version: String,
    /// SHA-256 content hash of the source
    pub content_hash: String,
    /// Author who published
    pub author: String,
    /// ISO 8601 timestamp
    pub timestamp: String,
    /// HMAC signature by the registry
    pub signature: String,
}

/// The full transparency log
#[derive(Debug, Serialize, Deserialize)]
pub struct TransparencyLog {
    pub entries: Vec<LogEntry>,
}

impl TransparencyLog {
    /// Parse a log from JSON
    pub fn from_json(json: &str) -> Result<Self, String> {
        serde_json::from_str(json).map_err(|e| format!("failed to parse transparency log: {}", e))
    }

    /// Serialize to JSON
    pub fn to_json(&self) -> String {
        serde_json::to_string_pretty(self).unwrap_or_else(|_| "{}".to_string())
    }

    /// Verify log integrity: check that entries are sequential,
    /// timestamps are monotonically increasing, and no gaps exist
    pub fn verify_integrity(&self) -> Result<(), Vec<String>> {
        let mut errors = Vec::new();

        for (i, entry) in self.entries.iter().enumerate() {
            let expected_seq = i as u64 + 1;
            if entry.sequence != expected_seq {
                errors.push(format!(
                    "sequence gap: expected {} but found {} (package {}@{})",
                    expected_seq, entry.sequence, entry.package, entry.version
                ));
            }
        }

        // Check monotonically increasing timestamps
        for window in self.entries.windows(2) {
            let prev = &window[0];
            let curr = &window[1];
            if curr.timestamp < prev.timestamp {
                errors.push(format!(
                    "timestamp not monotonic: entry {} ({}) comes before entry {} ({})",
                    prev.sequence, prev.timestamp, curr.sequence, curr.timestamp
                ));
            }
        }

        if errors.is_empty() {
            Ok(())
        } else {
            Err(errors)
        }
    }

    /// Find all entries for a given package
    pub fn entries_for(&self, package: &str) -> Vec<&LogEntry> {
        self.entries.iter().filter(|e| e.package == package).collect()
    }

    /// Find the entry for a specific package@version
    pub fn find_entry(&self, package: &str, version: &str) -> Option<&LogEntry> {
        self.entries
            .iter()
            .find(|e| e.package == package && e.version == version)
    }

    /// Verify that a lockfile's content hashes match the log.
    /// Returns a list of mismatches.
    pub fn verify_against_lockfile(
        &self,
        locked_deps: &[(String, String, String)], // (name, version, expected_hash)
    ) -> Vec<HashMismatch> {
        let mut mismatches = Vec::new();

        for (name, version, expected_hash) in locked_deps {
            if let Some(entry) = self.find_entry(name, version) {
                if &entry.content_hash != expected_hash {
                    mismatches.push(HashMismatch {
                        package: name.clone(),
                        version: version.clone(),
                        lockfile_hash: expected_hash.clone(),
                        log_hash: entry.content_hash.clone(),
                    });
                }
            }
        }

        mismatches
    }

    /// Return packages from locked_deps that have no entry in the log
    pub fn find_missing(
        &self,
        locked_deps: &[(String, String, String)],
    ) -> Vec<(String, String)> {
        locked_deps
            .iter()
            .filter(|(name, version, _)| self.find_entry(name, version).is_none())
            .map(|(name, version, _)| (name.clone(), version.clone()))
            .collect()
    }
}

#[derive(Debug)]
pub struct HashMismatch {
    pub package: String,
    pub version: String,
    pub lockfile_hash: String,
    pub log_hash: String,
}

/// Format an audit report
pub fn format_audit_report(
    log: &TransparencyLog,
    mismatches: &[HashMismatch],
    missing: &[(String, String)],
) -> String {
    let mut out = String::new();

    out.push_str(&format!(
        "Transparency Log Audit Report\n{}\n\n",
        "=".repeat(30)
    ));

    out.push_str(&format!("Log entries: {}\n", log.entries.len()));

    // Integrity check
    match log.verify_integrity() {
        Ok(()) => {
            out.push_str("Integrity:   OK (sequential, monotonic timestamps)\n");
        }
        Err(errors) => {
            out.push_str(&format!("Integrity:   FAILED ({} issues)\n", errors.len()));
            for err in &errors {
                out.push_str(&format!("  - {}\n", err));
            }
        }
    }

    out.push('\n');

    // Hash verification
    if mismatches.is_empty() && missing.is_empty() {
        out.push_str("Hash verification: ALL PASS\n");
        out.push_str("All lockfile hashes match the transparency log.\n");
    } else {
        if !mismatches.is_empty() {
            out.push_str(&format!(
                "Hash mismatches: {} FAILED\n",
                mismatches.len()
            ));
            for m in mismatches {
                out.push_str(&format!(
                    "  {}@{}\n    lockfile: {}\n    log:      {}\n",
                    m.package, m.version, m.lockfile_hash, m.log_hash
                ));
            }
            out.push('\n');
        }

        if !missing.is_empty() {
            out.push_str(&format!(
                "Missing from log: {} packages\n",
                missing.len()
            ));
            for (name, version) in missing {
                out.push_str(&format!("  {}@{}\n", name, version));
            }
            out.push('\n');
        }
    }

    out
}

/// Format a summary of log entries for a specific package
pub fn format_package_log(log: &TransparencyLog, package: &str) -> String {
    let entries = log.entries_for(package);
    if entries.is_empty() {
        return format!("No log entries found for package '{}'.\n", package);
    }

    let mut out = String::new();
    out.push_str(&format!(
        "Transparency log for '{}' ({} entries)\n{}\n\n",
        package,
        entries.len(),
        "-".repeat(40)
    ));

    for entry in &entries {
        out.push_str(&format!(
            "  #{:<4} v{:<12} {} by {}\n         hash: {}\n         sig:  {}\n\n",
            entry.sequence,
            entry.version,
            entry.timestamp,
            entry.author,
            entry.content_hash,
            entry.signature,
        ));
    }

    out
}

/// Format a summary of all dependencies and their log verification status
pub fn format_deps_summary(
    log: &TransparencyLog,
    locked_deps: &[(String, String, String)],
) -> String {
    let mismatches = log.verify_against_lockfile(locked_deps);
    let missing = log.find_missing(locked_deps);

    let mismatch_set: std::collections::HashSet<(&str, &str)> = mismatches
        .iter()
        .map(|m| (m.package.as_str(), m.version.as_str()))
        .collect();
    let missing_set: std::collections::HashSet<(&str, &str)> = missing
        .iter()
        .map(|(n, v)| (n.as_str(), v.as_str()))
        .collect();

    let mut out = String::new();
    out.push_str(&format!(
        "Dependency Audit ({} packages)\n{}\n\n",
        locked_deps.len(),
        "-".repeat(30)
    ));

    for (name, version, _hash) in locked_deps {
        let status = if mismatch_set.contains(&(name.as_str(), version.as_str())) {
            "MISMATCH"
        } else if missing_set.contains(&(name.as_str(), version.as_str())) {
            "NOT IN LOG"
        } else {
            "OK"
        };
        out.push_str(&format!("  {:<30} v{:<12} {}\n", name, version, status));
    }

    out.push('\n');

    let ok_count = locked_deps.len() - mismatches.len() - missing.len();
    out.push_str(&format!(
        "Summary: {} ok, {} mismatches, {} not in log\n",
        ok_count,
        mismatches.len(),
        missing.len()
    ));

    out
}

#[cfg(test)]
mod tests {
    use super::*;

    fn sample_log() -> TransparencyLog {
        TransparencyLog {
            entries: vec![
                LogEntry {
                    sequence: 1,
                    package: "http-client".to_string(),
                    version: "1.0.0".to_string(),
                    content_hash: "abc123".to_string(),
                    author: "alice".to_string(),
                    timestamp: "2025-01-01T00:00:00Z".to_string(),
                    signature: "sig1".to_string(),
                },
                LogEntry {
                    sequence: 2,
                    package: "json-parser".to_string(),
                    version: "2.0.0".to_string(),
                    content_hash: "def456".to_string(),
                    author: "bob".to_string(),
                    timestamp: "2025-01-02T00:00:00Z".to_string(),
                    signature: "sig2".to_string(),
                },
                LogEntry {
                    sequence: 3,
                    package: "http-client".to_string(),
                    version: "1.1.0".to_string(),
                    content_hash: "ghi789".to_string(),
                    author: "alice".to_string(),
                    timestamp: "2025-01-03T00:00:00Z".to_string(),
                    signature: "sig3".to_string(),
                },
            ],
        }
    }

    #[test]
    fn test_roundtrip_json() {
        let log = sample_log();
        let json = log.to_json();
        let parsed = TransparencyLog::from_json(&json).unwrap();
        assert_eq!(parsed.entries.len(), 3);
        assert_eq!(parsed.entries[0].package, "http-client");
    }

    #[test]
    fn test_verify_integrity_ok() {
        let log = sample_log();
        assert!(log.verify_integrity().is_ok());
    }

    #[test]
    fn test_verify_integrity_gap() {
        let mut log = sample_log();
        log.entries[1].sequence = 5; // gap
        let errs = log.verify_integrity().unwrap_err();
        assert!(errs[0].contains("sequence gap"));
    }

    #[test]
    fn test_verify_integrity_timestamp() {
        let mut log = sample_log();
        log.entries[2].timestamp = "2024-01-01T00:00:00Z".to_string(); // before previous
        let errs = log.verify_integrity().unwrap_err();
        assert!(errs[0].contains("timestamp not monotonic"));
    }

    #[test]
    fn test_entries_for() {
        let log = sample_log();
        let entries = log.entries_for("http-client");
        assert_eq!(entries.len(), 2);
    }

    #[test]
    fn test_find_entry() {
        let log = sample_log();
        let entry = log.find_entry("json-parser", "2.0.0").unwrap();
        assert_eq!(entry.sequence, 2);
        assert!(log.find_entry("nonexistent", "1.0.0").is_none());
    }

    #[test]
    fn test_verify_against_lockfile_ok() {
        let log = sample_log();
        let deps = vec![
            ("http-client".to_string(), "1.0.0".to_string(), "abc123".to_string()),
            ("json-parser".to_string(), "2.0.0".to_string(), "def456".to_string()),
        ];
        let mismatches = log.verify_against_lockfile(&deps);
        assert!(mismatches.is_empty());
    }

    #[test]
    fn test_verify_against_lockfile_mismatch() {
        let log = sample_log();
        let deps = vec![
            ("http-client".to_string(), "1.0.0".to_string(), "WRONG".to_string()),
        ];
        let mismatches = log.verify_against_lockfile(&deps);
        assert_eq!(mismatches.len(), 1);
        assert_eq!(mismatches[0].lockfile_hash, "WRONG");
        assert_eq!(mismatches[0].log_hash, "abc123");
    }

    #[test]
    fn test_find_missing() {
        let log = sample_log();
        let deps = vec![
            ("http-client".to_string(), "1.0.0".to_string(), "abc123".to_string()),
            ("unknown-pkg".to_string(), "0.1.0".to_string(), "xxx".to_string()),
        ];
        let missing = log.find_missing(&deps);
        assert_eq!(missing.len(), 1);
        assert_eq!(missing[0].0, "unknown-pkg");
    }

    #[test]
    fn test_format_audit_report_clean() {
        let log = sample_log();
        let report = format_audit_report(&log, &[], &[]);
        assert!(report.contains("Log entries: 3"));
        assert!(report.contains("ALL PASS"));
    }

    #[test]
    fn test_format_package_log() {
        let log = sample_log();
        let out = format_package_log(&log, "http-client");
        assert!(out.contains("2 entries"));
        assert!(out.contains("v1.0.0"));
        assert!(out.contains("v1.1.0"));
    }
}
