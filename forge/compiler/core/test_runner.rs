/// Feature example test runner.
///
/// Runs `.fg` files from feature example directories and validates
/// their output against `/// expect: <line>` comments.

use std::path::{Path, PathBuf};
use std::process::Command;

/// Result of running a single example test
#[derive(Debug)]
pub struct TestResult {
    pub file: PathBuf,
    pub feature: String,
    pub passed: bool,
    pub expected: Vec<String>,
    pub actual: Vec<String>,
    pub error: Option<String>,
}

/// Result of running all tests for a feature
#[derive(Debug)]
pub struct FeatureTestResult {
    pub feature: String,
    pub total: usize,
    pub passed: usize,
    pub results: Vec<TestResult>,
}

/// Find the compiler/features/ directory relative to the forge binary
fn find_features_dir() -> Option<PathBuf> {
    // Try relative to current directory (when running from forge/ dir)
    let candidates = [
        PathBuf::from("compiler/features"),
        PathBuf::from("src/features"),  // fallback for old layout
    ];

    // Also try relative to the binary location
    if let Ok(exe) = std::env::current_exe() {
        if let Some(parent) = exe.parent() {
            // Binary is in target/release/ or target/debug/, go up to forge/
            for ancestor in parent.ancestors() {
                let candidate = ancestor.join("compiler/features");
                if candidate.is_dir() {
                    return Some(candidate);
                }
            }
        }
    }

    for c in &candidates {
        if c.is_dir() {
            return Some(c.clone());
        }
    }
    None
}

/// Extract `/// expect: <line>` comments from a .fg file
pub fn extract_expected_output(source: &str) -> Vec<String> {
    source
        .lines()
        .filter_map(|line| {
            let trimmed = line.trim();
            if let Some(rest) = trimmed.strip_prefix("/// expect:") {
                Some(rest.trim().to_string())
            } else {
                None
            }
        })
        .collect()
}

/// Extract the doc comment block (/// lines) from a .fg file
pub fn extract_doc_comment(source: &str) -> Vec<String> {
    source
        .lines()
        .take_while(|line| {
            let trimmed = line.trim();
            trimmed.starts_with("///") || trimmed.is_empty()
        })
        .filter_map(|line| {
            let trimmed = line.trim();
            trimmed.strip_prefix("///").map(|s| s.to_string())
        })
        .collect()
}

/// Run a single .fg example file and check its output
pub fn run_example(forge_bin: &Path, fg_file: &Path, feature: &str) -> TestResult {
    let source = match std::fs::read_to_string(fg_file) {
        Ok(s) => s,
        Err(e) => {
            return TestResult {
                file: fg_file.to_path_buf(),
                feature: feature.to_string(),
                passed: false,
                expected: vec![],
                actual: vec![],
                error: Some(format!("cannot read file: {}", e)),
            };
        }
    };

    let expected = extract_expected_output(&source);
    if expected.is_empty() {
        return TestResult {
            file: fg_file.to_path_buf(),
            feature: feature.to_string(),
            passed: false,
            expected: vec![],
            actual: vec![],
            error: Some("no /// expect: comments found".to_string()),
        };
    }

    let output = Command::new(forge_bin)
        .arg("run")
        .arg(fg_file)
        .output();

    match output {
        Ok(out) => {
            let stdout = String::from_utf8_lossy(&out.stdout);
            let stderr = String::from_utf8_lossy(&out.stderr);
            let actual: Vec<String> = stdout
                .lines()
                .map(|l| l.to_string())
                .collect();

            let passed = actual == expected;

            TestResult {
                file: fg_file.to_path_buf(),
                feature: feature.to_string(),
                passed,
                expected,
                actual,
                error: if !out.status.success() && !passed {
                    Some(format!("exit code {}: {}", out.status.code().unwrap_or(-1), stderr.trim()))
                } else {
                    None
                },
            }
        }
        Err(e) => TestResult {
            file: fg_file.to_path_buf(),
            feature: feature.to_string(),
            passed: false,
            expected,
            actual: vec![],
            error: Some(format!("failed to execute: {}", e)),
        },
    }
}

/// Get all .fg files in a feature's examples/ directory
fn get_example_files(feature_dir: &Path) -> Vec<PathBuf> {
    let examples_dir = feature_dir.join("examples");
    if !examples_dir.is_dir() {
        return vec![];
    }

    let mut files: Vec<PathBuf> = std::fs::read_dir(&examples_dir)
        .ok()
        .into_iter()
        .flatten()
        .filter_map(|e| e.ok())
        .map(|e| e.path())
        .filter(|p| p.extension().and_then(|e| e.to_str()) == Some("fg"))
        .collect();

    files.sort();
    files
}

/// Run tests for a single feature, returns (passed, total)
pub fn test_feature(forge_bin: &Path, features_dir: &Path, feature: &str) -> FeatureTestResult {
    let feature_dir = features_dir.join(feature);
    let files = get_example_files(&feature_dir);

    let mut results = Vec::new();
    for file in &files {
        results.push(run_example(forge_bin, file, feature));
    }

    let passed = results.iter().filter(|r| r.passed).count();
    let total = results.len();

    FeatureTestResult {
        feature: feature.to_string(),
        total,
        passed,
        results,
    }
}

/// Get test counts for a feature without printing (for `forge features`)
pub fn count_feature_tests(forge_bin: &Path, features_dir: &Path, feature: &str) -> (usize, usize) {
    let result = test_feature(forge_bin, features_dir, feature);
    (result.passed, result.total)
}

/// Run tests for all features or a specific feature, with output
pub fn run_tests(target: Option<&str>) -> bool {
    let forge_bin = std::env::current_exe().unwrap_or_else(|_| PathBuf::from("forge"));
    let features_dir = match find_features_dir() {
        Some(d) => d,
        None => {
            eprintln!("error: cannot find compiler/features/ directory");
            eprintln!("hint: run from the forge/ project directory");
            return false;
        }
    };

    let features: Vec<String> = if let Some(target) = target {
        // Single feature
        vec![target.to_string()]
    } else {
        // All features
        let mut features: Vec<String> = std::fs::read_dir(&features_dir)
            .ok()
            .into_iter()
            .flatten()
            .filter_map(|e| e.ok())
            .filter(|e| e.path().is_dir() && e.path().join("examples").is_dir())
            .filter_map(|e| e.file_name().into_string().ok())
            .collect();
        features.sort();
        features
    };

    let mut total_passed = 0usize;
    let mut total_tests = 0usize;
    let mut all_passed = true;
    let mut feature_results = Vec::new();

    for feature in &features {
        let result = test_feature(&forge_bin, &features_dir, feature);
        total_passed += result.passed;
        total_tests += result.total;

        if result.total > 0 {
            feature_results.push(result);
        }
    }

    // Print results
    for result in &feature_results {
        let status = if result.passed == result.total {
            "\x1b[32m✓\x1b[0m"
        } else {
            all_passed = false;
            "\x1b[31m✗\x1b[0m"
        };

        println!(
            "  {} {:<28} {}/{}",
            status, result.feature, result.passed, result.total
        );

        // Show failures
        for test in &result.results {
            if !test.passed {
                let name = test.file.file_stem().unwrap_or_default().to_string_lossy();
                println!("    \x1b[31m✗\x1b[0m {}", name);
                if let Some(ref err) = test.error {
                    // Truncate error to first 2 lines
                    for line in err.lines().take(2) {
                        println!("      {}", line);
                    }
                } else {
                    println!("      expected: {:?}", test.expected);
                    println!("      actual:   {:?}", test.actual);
                }
            }
        }
    }

    println!();
    if all_passed {
        println!(
            "  \x1b[32m{}/{} tests passed\x1b[0m",
            total_passed, total_tests
        );
    } else {
        println!(
            "  \x1b[31m{}/{} tests passed\x1b[0m",
            total_passed, total_tests
        );
    }

    all_passed
}

/// List all features with their example counts (for `forge features` with test data)
pub fn get_all_feature_test_counts() -> Vec<(String, usize, usize)> {
    let forge_bin = std::env::current_exe().unwrap_or_else(|_| PathBuf::from("forge"));
    let features_dir = match find_features_dir() {
        Some(d) => d,
        None => return vec![],
    };

    let mut counts = Vec::new();
    let mut features: Vec<String> = std::fs::read_dir(&features_dir)
        .ok()
        .into_iter()
        .flatten()
        .filter_map(|e| e.ok())
        .filter(|e| e.path().is_dir())
        .filter_map(|e| e.file_name().into_string().ok())
        .collect();
    features.sort();

    for feature in &features {
        let (passed, total) = count_feature_tests(&forge_bin, &features_dir, feature);
        counts.push((feature.clone(), passed, total));
    }

    counts
}
