/// Quality signals system for the Forge package registry.
///
/// Computes a 0-10 score for each package based on multiple dimensions:
/// documentation, tests, capability minimalism, metadata completeness,
/// and dependency health.

/// A quality signal measurement
#[derive(Debug, Clone)]
pub struct QualitySignal {
    pub name: String,
    pub score: f64,      // 0.0 - 10.0
    pub weight: f64,     // relative importance
    pub details: String, // human explanation
}

/// Computed quality report for a package
#[derive(Debug)]
pub struct QualityReport {
    pub package: String,
    pub version: String,
    pub signals: Vec<QualitySignal>,
    pub overall_score: f64,
}

/// Metadata about a package (for quality computation)
#[derive(Debug, Default)]
pub struct PackageMeta {
    pub has_readme: bool,
    pub has_changelog: bool,
    pub has_license: bool,
    pub has_description: bool,
    pub has_repository: bool,
    pub has_documentation_url: bool,
    pub has_keywords: bool,
    pub has_authors: bool,
    pub has_examples: bool,
    pub has_tests: bool,
    pub test_count: usize,
    pub test_pass_count: usize,
    pub export_count: usize,
    pub documented_export_count: usize,
    pub capability_count: usize,
    pub dependency_count: usize,
    pub outdated_dep_count: usize,
}

/// Compute a quality report for a package.
pub fn compute_quality(
    package_name: &str,
    version: &str,
    meta: &PackageMeta,
) -> QualityReport {
    let mut signals = Vec::new();

    // 1. Documentation coverage
    signals.push(compute_docs_score(meta));

    // 2. Test coverage
    signals.push(compute_test_score(meta));

    // 3. Capability minimalism (fewer = better)
    signals.push(compute_capability_score(meta));

    // 4. Metadata completeness
    signals.push(compute_metadata_score(meta));

    // 5. Dependency health
    signals.push(compute_dep_health_score(meta));

    // Weighted average
    let total_weight: f64 = signals.iter().map(|s| s.weight).sum();
    let weighted_sum: f64 = signals.iter().map(|s| s.score * s.weight).sum();
    let overall = if total_weight > 0.0 { weighted_sum / total_weight } else { 0.0 };

    QualityReport {
        package: package_name.to_string(),
        version: version.to_string(),
        signals,
        overall_score: (overall * 10.0).round() / 10.0,
    }
}

fn compute_docs_score(meta: &PackageMeta) -> QualitySignal {
    let mut score: f64 = 0.0;
    if meta.has_readme { score += 3.0; }
    if meta.has_changelog { score += 1.0; }

    // Doc coverage on exports
    if meta.export_count > 0 {
        let coverage = meta.documented_export_count as f64 / meta.export_count as f64;
        score += coverage * 4.0;
    }

    if meta.has_examples { score += 2.0; }

    QualitySignal {
        name: "documentation".to_string(),
        score: score.min(10.0),
        weight: 2.0,
        details: format!(
            "README: {}, changelog: {}, examples: {}, doc coverage: {}/{}",
            if meta.has_readme { "yes" } else { "no" },
            if meta.has_changelog { "yes" } else { "no" },
            if meta.has_examples { "yes" } else { "no" },
            meta.documented_export_count,
            meta.export_count,
        ),
    }
}

fn compute_test_score(meta: &PackageMeta) -> QualitySignal {
    let score = if meta.test_count == 0 {
        0.0
    } else {
        let pass_rate = meta.test_pass_count as f64 / meta.test_count as f64;
        let count_bonus = (meta.test_count as f64 / 10.0).min(3.0);
        (pass_rate * 7.0 + count_bonus).min(10.0)
    };

    QualitySignal {
        name: "tests".to_string(),
        score,
        weight: 3.0,
        details: format!("{}/{} tests pass", meta.test_pass_count, meta.test_count),
    }
}

fn compute_capability_score(meta: &PackageMeta) -> QualitySignal {
    // Fewer capabilities = more trustworthy
    let score = match meta.capability_count {
        0 => 10.0,
        1 => 8.0,
        2 => 6.0,
        3 => 4.0,
        _ => 2.0,
    };

    QualitySignal {
        name: "capability_minimalism".to_string(),
        score,
        weight: 1.5,
        details: format!("{} capabilities declared", meta.capability_count),
    }
}

fn compute_metadata_score(meta: &PackageMeta) -> QualitySignal {
    let mut score: f64 = 0.0;
    if meta.has_description { score += 2.0; }
    if meta.has_license { score += 2.0; }
    if meta.has_repository { score += 2.0; }
    if meta.has_authors { score += 1.5; }
    if meta.has_keywords { score += 1.0; }
    if meta.has_documentation_url { score += 1.5; }

    QualitySignal {
        name: "metadata".to_string(),
        score: score.min(10.0),
        weight: 1.0,
        details: format!(
            "description: {}, license: {}, repo: {}, authors: {}",
            if meta.has_description { "yes" } else { "no" },
            if meta.has_license { "yes" } else { "no" },
            if meta.has_repository { "yes" } else { "no" },
            if meta.has_authors { "yes" } else { "no" },
        ),
    }
}

fn compute_dep_health_score(meta: &PackageMeta) -> QualitySignal {
    let score = if meta.dependency_count == 0 {
        10.0
    } else if meta.outdated_dep_count == 0 {
        9.0
    } else {
        let outdated_ratio = meta.outdated_dep_count as f64 / meta.dependency_count as f64;
        (9.0 * (1.0 - outdated_ratio)).max(2.0)
    };

    QualitySignal {
        name: "dependency_health".to_string(),
        score,
        weight: 1.5,
        details: format!(
            "{} deps, {} outdated",
            meta.dependency_count,
            meta.outdated_dep_count,
        ),
    }
}

/// Format a quality report for terminal display
pub fn format_report(report: &QualityReport) -> String {
    let mut out = String::new();

    // Overall score with color
    let color = if report.overall_score >= 7.0 { "32" }  // green
        else if report.overall_score >= 4.0 { "33" }     // yellow
        else { "31" };                                     // red

    out.push_str(&format!(
        "  {} v{} — quality score: \x1b[{}m{:.1}/10\x1b[0m\n\n",
        report.package, report.version, color, report.overall_score
    ));

    for signal in &report.signals {
        let bar = format_bar(signal.score);
        out.push_str(&format!(
            "    {:<25} {} {:.1}  {}\n",
            signal.name, bar, signal.score, signal.details
        ));
    }

    out
}

fn format_bar(score: f64) -> String {
    let filled = (score as usize).min(10);
    let empty = 10 - filled;
    format!(
        "\x1b[32m{}\x1b[90m{}\x1b[0m",
        "█".repeat(filled),
        "░".repeat(empty),
    )
}

/// Extract PackageMeta from a package directory
pub fn extract_meta(project_dir: &std::path::Path) -> PackageMeta {
    let mut meta = PackageMeta::default();

    meta.has_readme = project_dir.join("README.md").exists();
    meta.has_changelog = project_dir.join("CHANGELOG.md").exists();
    meta.has_examples = project_dir.join("examples").is_dir() || project_dir.join("example.fg").exists();
    meta.has_tests = project_dir.join("tests").is_dir();

    // Read package.toml for metadata
    if let Ok(content) = std::fs::read_to_string(project_dir.join("package.toml")) {
        if let Ok(toml_val) = content.parse::<toml::Value>() {
            if let Some(pkg) = toml_val.get("package") {
                meta.has_description = pkg.get("description").and_then(|v| v.as_str()).is_some();
                meta.has_license = pkg.get("license").and_then(|v| v.as_str()).is_some();
                meta.has_repository = pkg.get("repository").and_then(|v| v.as_str()).is_some();
                meta.has_documentation_url = pkg.get("documentation").and_then(|v| v.as_str()).is_some();
                meta.has_authors = pkg.get("authors").and_then(|v| v.as_array()).map(|a| !a.is_empty()).unwrap_or(false);
                meta.has_keywords = pkg.get("keywords").and_then(|v| v.as_array()).map(|a| !a.is_empty()).unwrap_or(false);
            }
            if let Some(caps) = toml_val.get("capabilities").and_then(|c| c.as_table()) {
                meta.capability_count = caps.values().filter(|v| v.as_bool() == Some(true)).count();
            }
            if let Some(deps) = toml_val.get("dependencies").and_then(|d| d.as_table()) {
                meta.dependency_count = deps.len();
            }
        }
    }

    meta
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_quality_perfect_package() {
        let meta = PackageMeta {
            has_readme: true,
            has_changelog: true,
            has_license: true,
            has_description: true,
            has_repository: true,
            has_documentation_url: true,
            has_keywords: true,
            has_authors: true,
            has_examples: true,
            has_tests: true,
            test_count: 50,
            test_pass_count: 50,
            export_count: 10,
            documented_export_count: 10,
            capability_count: 0,
            dependency_count: 3,
            outdated_dep_count: 0,
        };
        let report = compute_quality("perfect-pkg", "1.0.0", &meta);
        assert!(report.overall_score >= 8.0, "perfect package should score >= 8.0, got {}", report.overall_score);
    }

    #[test]
    fn test_quality_minimal_package() {
        let meta = PackageMeta::default();
        let report = compute_quality("empty-pkg", "0.1.0", &meta);
        assert!(report.overall_score < 4.0, "empty package should score < 4.0, got {}", report.overall_score);
    }

    #[test]
    fn test_format_bar() {
        let bar = format_bar(7.0);
        assert!(bar.contains("█"));
        assert!(bar.contains("░"));
    }
}
