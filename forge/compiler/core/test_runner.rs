/// Feature example test runner.
///
/// Runs `.fg` files from feature example directories and validates
/// their output against `/// expect: <line>` comments.
///
/// Tests run in parallel across worker threads. The human output mode
/// shows a live progress bar, spinner for in-flight tests, and results
/// as features complete.

use std::collections::{HashMap, HashSet, VecDeque};
use std::io::{self, Write};
use std::path::{Path, PathBuf};
use std::process::Command;
use std::sync::atomic::{AtomicBool, AtomicUsize, Ordering};
use std::sync::{mpsc, Arc, Mutex};
use std::time::{Duration, Instant};

// ── Config ──────────────────────────────────────────────────────────

#[derive(Debug, Clone, Copy, PartialEq)]
pub enum OutputFormat {
    Human,
    Json,
    Stream,
}

#[derive(Debug)]
pub struct TestRunConfig {
    pub format: OutputFormat,
    pub filter: Option<String>,
    pub fail_fast: bool,
    pub no_color: bool,
    pub verbose: bool,
    pub quiet: bool,
}

impl Default for TestRunConfig {
    fn default() -> Self {
        Self {
            format: OutputFormat::Human,
            filter: None,
            fail_fast: false,
            no_color: false,
            verbose: false,
            quiet: false,
        }
    }
}

// ── Results ─────────────────────────────────────────────────────────

#[derive(Debug)]
pub struct TestResult {
    pub file: PathBuf,
    pub feature: String,
    pub passed: bool,
    pub expected: Vec<String>,
    pub actual: Vec<String>,
    pub error: Option<String>,
    pub duration: Duration,
}

#[derive(Debug)]
pub struct FeatureTestResult {
    pub feature: String,
    pub total: usize,
    pub passed: usize,
    pub results: Vec<TestResult>,
    pub duration: Duration,
}

// ── Color helpers ───────────────────────────────────────────────────

struct Colors {
    enabled: bool,
}

impl Colors {
    fn new(no_color: bool) -> Self {
        let enabled = !no_color && atty_stdout();
        Self { enabled }
    }
    fn green(&self, s: &str) -> String {
        if self.enabled { format!("\x1b[32m{}\x1b[0m", s) } else { s.to_string() }
    }
    fn red(&self, s: &str) -> String {
        if self.enabled { format!("\x1b[31m{}\x1b[0m", s) } else { s.to_string() }
    }
    fn dim(&self, s: &str) -> String {
        if self.enabled { format!("\x1b[2m{}\x1b[0m", s) } else { s.to_string() }
    }
    fn cyan(&self, s: &str) -> String {
        if self.enabled { format!("\x1b[36m{}\x1b[0m", s) } else { s.to_string() }
    }
    fn hide_cursor(&self) {
        if self.enabled { print!("\x1b[?25l"); }
    }
    fn show_cursor(&self) {
        if self.enabled { print!("\x1b[?25h"); }
    }
}

fn atty_stdout() -> bool {
    unsafe { libc_isatty(1) != 0 }
}

extern "C" { fn isatty(fd: i32) -> i32; }
unsafe fn libc_isatty(fd: i32) -> i32 { unsafe { isatty(fd) } }

// ── Discovery ───────────────────────────────────────────────────────

pub fn find_features_dir() -> Option<PathBuf> {
    let candidates = [
        PathBuf::from("compiler/features"),
        PathBuf::from("src/features"),
    ];

    if let Ok(exe) = std::env::current_exe() {
        if let Some(parent) = exe.parent() {
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

fn discover_features(features_dir: &Path) -> Vec<String> {
    let mut features: Vec<String> = std::fs::read_dir(features_dir)
        .ok()
        .into_iter()
        .flatten()
        .filter_map(|e| e.ok())
        .filter(|e| e.path().is_dir() && e.path().join("examples").is_dir())
        .filter_map(|e| e.file_name().into_string().ok())
        .collect();
    features.sort();
    features
}

// ── Extraction ──────────────────────────────────────────────────────

pub fn extract_expected_output(source: &str) -> Vec<String> {
    source.lines()
        .filter_map(|line| line.trim().strip_prefix("/// expect:").map(|r| r.trim().to_string()))
        .collect()
}

pub fn extract_expected_stderr(source: &str) -> Vec<String> {
    source.lines()
        .filter_map(|line| line.trim().strip_prefix("/// expect-stderr:").map(|r| r.trim().to_string()))
        .collect()
}

pub fn extract_expected_exit_code(source: &str) -> Option<i32> {
    source.lines().find_map(|line| {
        line.trim().strip_prefix("/// expect-exit:").and_then(|r| r.trim().parse().ok())
    })
}

pub fn extract_expected_error(source: &str) -> Option<String> {
    source.lines().find_map(|line| {
        line.trim().strip_prefix("/// expect-error:").map(|r| r.trim().to_string())
    })
}

pub fn extract_doc_comment(source: &str) -> Vec<String> {
    source.lines()
        .take_while(|line| { let t = line.trim(); t.starts_with("///") || t.is_empty() })
        .filter_map(|line| line.trim().strip_prefix("///").map(|s| s.to_string()))
        .collect()
}

// ── Execution ───────────────────────────────────────────────────────

pub fn run_example(forge_bin: &Path, fg_file: &Path, feature: &str) -> TestResult {
    let source = match std::fs::read_to_string(fg_file) {
        Ok(s) => s,
        Err(e) => {
            return TestResult {
                file: fg_file.to_path_buf(), feature: feature.to_string(),
                passed: false, expected: vec![], actual: vec![],
                error: Some(format!("cannot read file: {}", e)),
                duration: Duration::ZERO,
            };
        }
    };

    let expected = extract_expected_output(&source);
    let expected_stderr = extract_expected_stderr(&source);
    let expected_error = extract_expected_error(&source);
    let expected_exit = extract_expected_exit_code(&source);

    if expected.is_empty() && expected_stderr.is_empty() && expected_error.is_none() {
        return TestResult {
            file: fg_file.to_path_buf(), feature: feature.to_string(),
            passed: false, expected: vec![], actual: vec![],
            error: Some("no /// expect:, /// expect-stderr:, or /// expect-error: comments found".to_string()),
            duration: Duration::ZERO,
        };
    }

    let cmd = if expected_error.is_some() { "check" } else { "run" };

    let start = Instant::now();
    let mut proc = Command::new(forge_bin);
    proc.arg(cmd);
    if cmd == "run" {
        proc.arg("--dev");
    }
    proc.arg(fg_file);
    let output = proc.output();
    let duration = start.elapsed();

    match output {
        Ok(out) => {
            let stdout = String::from_utf8_lossy(&out.stdout);
            let stderr = String::from_utf8_lossy(&out.stderr);

            // expect-error tests
            if let Some(ref error_code) = expected_error {
                let passed = !out.status.success() && stderr.contains(error_code.as_str());
                return TestResult {
                    file: fg_file.to_path_buf(), feature: feature.to_string(), passed, duration,
                    expected: vec![format!("error: {}", error_code)],
                    actual: if !out.status.success() {
                        vec![format!("error: {}", error_code)]
                    } else {
                        vec!["no error (compiled successfully)".to_string()]
                    },
                    error: if !passed {
                        if out.status.success() {
                            Some("expected compilation to fail, but it succeeded".to_string())
                        } else {
                            Some(format!("expected error code {}, got: {}", error_code, stderr.lines().next().unwrap_or("")))
                        }
                    } else { None },
                };
            }

            // expect-stderr tests
            if !expected_stderr.is_empty() {
                let clean_stderr = strip_ansi_codes(&stderr);
                let stderr_lines: Vec<&str> = clean_stderr.lines().collect();
                let mut missing = Vec::new();
                for exp in &expected_stderr {
                    if !stderr_lines.iter().any(|line| line.contains(exp.as_str())) {
                        missing.push(exp.clone());
                    }
                }
                let exit_ok = expected_exit.map_or(true, |code| out.status.code() == Some(code));
                let passed = missing.is_empty() && exit_ok;

                return TestResult {
                    file: fg_file.to_path_buf(), feature: feature.to_string(), passed, duration,
                    expected: expected_stderr,
                    actual: stderr_lines.iter().map(|s| s.to_string()).collect(),
                    error: if !passed {
                        if !missing.is_empty() {
                            Some(format!("missing in stderr: {:?}", missing))
                        } else {
                            Some(format!("expected exit code {:?}, got {:?}", expected_exit, out.status.code()))
                        }
                    } else { None },
                };
            }

            // stdout comparison
            let actual: Vec<String> = stdout.lines().map(|l| l.to_string()).collect();
            let passed = actual == expected;

            TestResult {
                file: fg_file.to_path_buf(), feature: feature.to_string(), passed, duration,
                expected, actual,
                error: if !out.status.success() && !passed {
                    Some(format!("exit code {}: {}", out.status.code().unwrap_or(-1), stderr.trim()))
                } else { None },
            }
        }
        Err(e) => TestResult {
            file: fg_file.to_path_buf(), feature: feature.to_string(),
            passed: false, expected, actual: vec![],
            error: Some(format!("failed to execute: {}", e)),
            duration,
        },
    }
}

pub fn test_feature(forge_bin: &Path, features_dir: &Path, feature: &str) -> FeatureTestResult {
    let feature_dir = features_dir.join(feature);
    let files = get_example_files(&feature_dir);

    let start = Instant::now();
    let mut results = Vec::new();
    for file in &files {
        results.push(run_example(forge_bin, file, feature));
    }
    let duration = start.elapsed();

    let passed = results.iter().filter(|r| r.passed).count();
    let total = results.len();

    FeatureTestResult { feature: feature.to_string(), total, passed, results, duration }
}

// ── Main entry point ────────────────────────────────────────────────

pub fn run_tests(target: Option<&str>, config: &TestRunConfig) -> bool {
    match config.format {
        OutputFormat::Human => run_tests_human(target, config),
        OutputFormat::Json => run_tests_json(target),
        OutputFormat::Stream => run_tests_stream(target, config),
    }
}

// ── Worker events ───────────────────────────────────────────────────

enum TestEvent {
    Started { feature: String, file_stem: String },
    Done(TestResult),
}

// ── Human output (parallel) ─────────────────────────────────────────

fn run_tests_human(target: Option<&str>, config: &TestRunConfig) -> bool {
    let forge_bin = std::env::current_exe().unwrap_or_else(|_| PathBuf::from("forge"));
    let features_dir = match find_features_dir() {
        Some(d) => d,
        None => {
            let err = crate::errors::CompileError::CliError {
                message: "cannot find compiler/features/ directory".to_string(),
                help: Some("run forge test from the forge project root directory".to_string()),
            };
            eprint!("{}", err.render());
            return false;
        }
    };

    let c = Colors::new(config.no_color);
    let is_tty = c.enabled;

    let features: Vec<String> = match target {
        Some(t) => vec![t.to_string()],
        None => discover_features(&features_dir),
    };

    // Apply filter
    let features: Vec<String> = if let Some(ref filter) = config.filter {
        features.into_iter().filter(|f| f.contains(filter.as_str())).collect()
    } else {
        features
    };

    // ── Discovery: build work queue ─────────────────────────────────
    let mut work_items: VecDeque<(String, PathBuf)> = VecDeque::new();
    let mut feature_test_counts: HashMap<String, usize> = HashMap::new();
    let mut feature_order: Vec<String> = Vec::new(); // preserve alphabetical order

    for feature in &features {
        let files = get_example_files(&features_dir.join(feature));
        if files.is_empty() { continue; }
        feature_test_counts.insert(feature.clone(), files.len());
        feature_order.push(feature.clone());
        for file in files {
            work_items.push_back((feature.clone(), file));
        }
    }

    let total_tests = work_items.len();
    let feature_count = feature_order.len();

    if total_tests == 0 {
        if !config.quiet {
            println!();
            println!("  No tests found.");
        }
        return true;
    }

    // ── Print discovery header ──────────────────────────────────────
    if !config.quiet {
        println!();
        println!("  {} {} tests from {} features",
            c.dim("Running"),
            total_tests,
            feature_count,
        );
        println!();
    }

    // ── Parallel execution ──────────────────────────────────────────
    let num_workers = std::thread::available_parallelism()
        .map(|n| n.get().min(8))
        .unwrap_or(4);

    let work = Arc::new(Mutex::new(work_items));
    let (tx, rx) = mpsc::channel::<TestEvent>();
    let forge_bin = Arc::new(forge_bin);
    let stop_flag = Arc::new(AtomicBool::new(false));

    let mut handles = Vec::new();
    for _ in 0..num_workers {
        let work = work.clone();
        let tx = tx.clone();
        let forge_bin = forge_bin.clone();
        let stop_flag = stop_flag.clone();
        handles.push(std::thread::spawn(move || {
            loop {
                if stop_flag.load(Ordering::Relaxed) { break; }
                let item = work.lock().unwrap().pop_front();
                match item {
                    Some((feature, file)) => {
                        let file_stem = file.file_stem()
                            .unwrap_or_default().to_string_lossy().to_string();
                        let _ = tx.send(TestEvent::Started {
                            feature: feature.clone(),
                            file_stem: file_stem.clone(),
                        });
                        let result = run_example(&forge_bin, &file, &feature);
                        let _ = tx.send(TestEvent::Done(result));
                    }
                    None => break,
                }
            }
        }));
    }
    drop(tx);

    // ── Receive results and render ──────────────────────────────────
    let suite_start = Instant::now();
    let mut completed_tests = 0usize;
    let mut total_passed = 0usize;
    let mut total_failed = 0usize;
    let mut spinner_idx = 0usize;

    // Per-feature tracking
    let mut feature_results: HashMap<String, Vec<TestResult>> = HashMap::new();
    let mut feature_starts: HashMap<String, Instant> = HashMap::new();
    let mut completed_features: HashSet<String> = HashSet::new();

    // Currently running tests (feature/file_stem)
    let mut running: Vec<String> = Vec::new();

    // Failures for summary
    let mut failures: Vec<(String, TestResult)> = Vec::new();

    // Output buffering: we print features in completion order
    // but track results to print the summary in original order
    let mut printed_features: Vec<FeaturePrintData> = Vec::new();

    let mut footer_lines = 0usize;

    if is_tty && !config.quiet {
        c.hide_cursor();
        print_footer(&c, &running, completed_tests, total_tests, Duration::ZERO, spinner_idx);
        let _ = io::stdout().flush();
        footer_lines = 2;
    }

    let mut stopped_early = false;

    for event in rx {
        match event {
            TestEvent::Started { feature, file_stem } => {
                let label = format!("{}/{}", feature, file_stem);
                running.push(label);
                feature_starts.entry(feature).or_insert_with(Instant::now);

                // Update footer
                if is_tty && !config.quiet {
                    clear_footer(footer_lines);
                    spinner_idx = (spinner_idx + 1) % SPINNER.len();
                    print_footer(&c, &running, completed_tests, total_tests, suite_start.elapsed(), spinner_idx);
                    let _ = io::stdout().flush();
                    footer_lines = 2;
                }
            }
            TestEvent::Done(result) => {
                completed_tests += 1;
                if result.passed { total_passed += 1; } else { total_failed += 1; }

                // Remove from running
                let label = format!("{}/{}", result.feature,
                    result.file.file_stem().unwrap_or_default().to_string_lossy());
                running.retain(|r| r != &label);

                let feature = result.feature.clone();
                feature_results.entry(feature.clone()).or_default().push(result);

                // Check if feature complete
                let expected_count = feature_test_counts.get(&feature).copied().unwrap_or(0);
                let current_count = feature_results.get(&feature).map(|v| v.len()).unwrap_or(0);

                if current_count == expected_count && !completed_features.contains(&feature) {
                    completed_features.insert(feature.clone());

                    let feat_start = feature_starts.get(&feature).copied()
                        .unwrap_or(suite_start);
                    let feat_duration = feat_start.elapsed();

                    let results = feature_results.remove(&feature).unwrap_or_default();
                    let feat_passed = results.iter().filter(|r| r.passed).count();
                    let feat_total = results.len();

                    // Collect failures
                    let mut feat_failures: Vec<(String, TestResult)> = Vec::new();
                    let mut kept_results: Vec<TestResult> = Vec::new();
                    for r in results {
                        if !r.passed {
                            feat_failures.push((feature.clone(), r));
                        } else {
                            kept_results.push(r);
                        }
                    }

                    if !config.quiet {
                        if is_tty {
                            clear_footer(footer_lines);
                            footer_lines = 0;
                        }

                        print_feature_result(
                            &feature, feat_passed, feat_total, feat_duration,
                            &feat_failures, &kept_results, config, &c,
                        );

                        if is_tty {
                            print_footer(&c, &running, completed_tests, total_tests, suite_start.elapsed(), spinner_idx);
                            let _ = io::stdout().flush();
                            footer_lines = 2;
                        }
                    }

                    // Save feature data for summary
                    printed_features.push(FeaturePrintData {
                        feature: feature.clone(),
                        passed: feat_passed,
                        total: feat_total,
                    });

                    failures.extend(feat_failures);
                } else if is_tty && !config.quiet {
                    // Just update footer
                    clear_footer(footer_lines);
                    spinner_idx = (spinner_idx + 1) % SPINNER.len();
                    print_footer(&c, &running, completed_tests, total_tests, suite_start.elapsed(), spinner_idx);
                    let _ = io::stdout().flush();
                    footer_lines = 2;
                }

                if config.fail_fast && total_failed > 0 {
                    stop_flag.store(true, Ordering::Relaxed);
                    stopped_early = true;
                    // Drain remaining events
                    break;
                }
            }
        }
    }

    // Wait for workers to finish
    for h in handles {
        let _ = h.join();
    }

    // Clear footer
    if is_tty && !config.quiet {
        clear_footer(footer_lines);
        c.show_cursor();
        let _ = io::stdout().flush();
    }

    let suite_duration = suite_start.elapsed();

    // ── Summary ─────────────────────────────────────────────────────
    println!();
    println!("  {}", c.dim(&"─".repeat(54)));
    println!();

    if total_failed == 0 {
        println!("  {} {}", c.green("✓"), c.green(&format!("{} passed", total_passed)));
    } else {
        let mut parts = Vec::new();
        parts.push(c.red(&format!("✖ {} failed", total_failed)));
        parts.push(c.green(&format!("✓ {} passed", total_passed)));
        println!("  {}", parts.join("  "));

        if !config.quiet && !failures.is_empty() {
            println!();
            println!("  {}:", c.dim("Failures"));
            println!();
            for (i, (feature, test)) in failures.iter().enumerate() {
                let name = test.file.file_stem().unwrap_or_default().to_string_lossy();
                println!("    {}) {} > {}", i + 1, feature, name);
                if let Some(ref err) = test.error {
                    for line in err.lines().take(2) {
                        println!("       {}", c.red(line));
                    }
                } else {
                    print_diff(&test.expected, &test.actual, &c, 7);
                }
                println!();
            }
        }

        if stopped_early {
            println!("  {}", c.dim("Stopped early (--fail-fast)"));
        }
    }

    println!();
    println!(
        "  {}",
        c.dim(&format!(
            "Duration: {} | Features: {} | Tests: {}",
            format_duration(suite_duration),
            feature_count,
            total_tests,
        ))
    );
    println!();
    println!("  {}", c.dim(&"─".repeat(54)));

    total_failed == 0
}

struct FeaturePrintData {
    feature: String,
    passed: usize,
    total: usize,
}

fn print_feature_result(
    feature: &str,
    passed: usize,
    total: usize,
    duration: Duration,
    failures: &[(String, TestResult)],
    passing_results: &[TestResult],
    config: &TestRunConfig,
    c: &Colors,
) {
    let feature_icon = if passed == total {
        c.green("✓")
    } else {
        c.red("●")
    };

    if passed == total && !config.verbose {
        // Compact line for fully passing features
        println!(
            "  {} {:<32} {}  {}",
            feature_icon,
            feature,
            c.dim(&format!("{}/{}", passed, total)),
            c.dim(&format_duration(duration)),
        );
    } else {
        // Expanded: show each test
        let counts = if passed == total {
            c.dim(&format!("{}/{}", passed, total))
        } else {
            let failed = total - passed;
            format!("{} {}",
                c.dim(&format!("{}/{}", passed, total)),
                c.red(&format!("{} failed", failed)),
            )
        };
        println!("  {} {}  {}", feature_icon, feature, counts);

        // Show passing tests
        for test in passing_results {
            let name = test.file.file_stem().unwrap_or_default().to_string_lossy();
            let dur = c.dim(&format_duration(test.duration));
            println!("    {} {:<36} {}", c.green("✓"), name, dur);
        }

        // Show failing tests with inline details
        for (_, test) in failures {
            let name = test.file.file_stem().unwrap_or_default().to_string_lossy();
            let dur = c.dim(&format_duration(test.duration));
            println!("    {} {:<36} {}", c.red("✖"), name, dur);
            print_failure_detail(test, c);
        }
        println!();
    }
}

// ── Spinner + progress bar ──────────────────────────────────────────

const SPINNER: &[char] = &['◐', '◓', '◑', '◒'];

fn print_footer(
    c: &Colors,
    running: &[String],
    completed: usize,
    total: usize,
    elapsed: Duration,
    spinner_idx: usize,
) {
    let spinner = SPINNER[spinner_idx % SPINNER.len()];

    // Line 1: spinner + currently running files
    if running.is_empty() {
        println!("  {} {}", c.cyan(&spinner.to_string()), c.dim("waiting..."));
    } else {
        let max_show = 3;
        let shown: Vec<&str> = running.iter().take(max_show).map(|s| s.as_str()).collect();
        let label = shown.join("  ");
        let extra = if running.len() > max_show {
            format!("  {}",  c.dim(&format!("+{} more", running.len() - max_show)))
        } else {
            String::new()
        };
        println!("  {} {}{}", c.cyan(&spinner.to_string()), c.dim(&label), extra);
    }

    // Line 2: progress bar
    let bar_width = 40usize;
    let filled = if total > 0 { (completed * bar_width) / total } else { 0 };
    let empty = bar_width - filled;

    let bar = format!("{}{}",
        c.green(&"█".repeat(filled)),
        c.dim(&"░".repeat(empty)),
    );

    println!(
        "  {}  {}/{}  {}",
        bar,
        completed,
        total,
        c.dim(&format_duration(elapsed)),
    );
}

fn clear_footer(lines: usize) {
    if lines == 0 { return; }
    let stdout = io::stdout();
    let mut handle = stdout.lock();
    for _ in 0..lines {
        let _ = write!(handle, "\x1b[A\x1b[2K");
    }
    let _ = handle.flush();
}

// ── Shared formatting ───────────────────────────────────────────────

fn print_failure_detail(test: &TestResult, c: &Colors) {
    if let Some(ref err) = test.error {
        // The compiler now renders structured errors to stderr.
        // Extract the first meaningful lines (skip blank lines, limit output).
        let clean = strip_ansi_codes(err);
        let lines: Vec<&str> = clean.lines()
            .map(|l| l.trim())
            .filter(|l| !l.is_empty())
            .collect();

        for line in lines.iter().take(6) {
            println!("        {}", c.red(line));
        }
        if lines.len() > 6 {
            println!("        {}", c.dim(&format!("... ({} more lines)", lines.len() - 6)));
        }
    } else {
        print_diff(&test.expected, &test.actual, c, 8);
    }
    println!();
}

fn print_failure_summary(test: &TestResult, c: &Colors) {
    if let Some(ref err) = test.error {
        // Show first meaningful error line in the summary
        let clean = strip_ansi_codes(err);
        let first = clean.lines()
            .map(|l| l.trim())
            .find(|l| !l.is_empty() && !l.starts_with("help:"))
            .unwrap_or("compilation failed");
        let display = if first.len() > 80 { &first[..77] } else { first };
        println!("       {}", c.red(display));
    } else {
        print_diff(&test.expected, &test.actual, c, 7);
    }
}

fn print_diff(expected: &[String], actual: &[String], c: &Colors, indent: usize) {
    let pad = " ".repeat(indent);
    let max = expected.len().max(actual.len());
    for i in 0..max {
        let exp = expected.get(i).map(|s| s.as_str()).unwrap_or("");
        let act = actual.get(i).map(|s| s.as_str()).unwrap_or("");
        if exp == act {
            println!("{}  {}", pad, c.dim(act));
        } else {
            if !exp.is_empty() {
                println!("{}{} {}", pad, c.green("-"), c.green(exp));
            }
            if !act.is_empty() {
                println!("{}{} {}", pad, c.red("+"), c.red(act));
            }
        }
    }
}

fn format_duration(d: Duration) -> String {
    let ms = d.as_millis();
    if ms < 1000 {
        format!("{}ms", ms)
    } else {
        format!("{:.1}s", d.as_secs_f64())
    }
}

// ── Stream output (JSON lines) ──────────────────────────────────────

fn run_tests_stream(target: Option<&str>, config: &TestRunConfig) -> bool {
    let forge_bin = std::env::current_exe().unwrap_or_else(|_| PathBuf::from("forge"));
    let features_dir = match find_features_dir() {
        Some(d) => d,
        None => {
            println!("{{\"event\":\"error\",\"message\":\"cannot find compiler/features/ directory\"}}");
            return false;
        }
    };

    let features = match target {
        Some(t) => vec![t.to_string()],
        None => discover_features(&features_dir),
    };

    let total_tests: usize = features.iter()
        .map(|f| get_example_files(&features_dir.join(f)).len())
        .sum();

    println!(
        "{{\"event\":\"suite_start\",\"features\":{},\"tests\":{}}}",
        features.len(), total_tests
    );

    let suite_start = Instant::now();
    let mut total_passed = 0usize;
    let mut total_failed = 0usize;

    for feature in &features {
        if let Some(ref filter) = config.filter {
            if !feature.contains(filter.as_str()) { continue; }
        }

        let files = get_example_files(&features_dir.join(feature));
        println!(
            "{{\"event\":\"feature_start\",\"feature\":\"{}\",\"tests\":{}}}",
            feature, files.len()
        );

        let feat_start = Instant::now();
        let mut feat_passed = 0usize;
        let mut feat_total = 0usize;

        for file in &files {
            let result = run_example(&forge_bin, file, feature);
            feat_total += 1;
            let name = result.file.file_stem().unwrap_or_default().to_string_lossy();
            let ms = result.duration.as_millis();

            if result.passed {
                feat_passed += 1;
                total_passed += 1;
                println!(
                    "{{\"event\":\"pass\",\"feature\":\"{}\",\"test\":\"{}\",\"duration_ms\":{}}}",
                    feature, name, ms
                );
            } else {
                total_failed += 1;
                let error_json = result.error.as_deref().unwrap_or("")
                    .replace('\\', "\\\\").replace('"', "\\\"").replace('\n', "\\n");
                println!(
                    "{{\"event\":\"fail\",\"feature\":\"{}\",\"test\":\"{}\",\"duration_ms\":{},\"error\":\"{}\"}}",
                    feature, name, ms, error_json
                );
            }

            if config.fail_fast && total_failed > 0 { break; }
        }

        let feat_dur = feat_start.elapsed().as_millis();
        println!(
            "{{\"event\":\"feature_end\",\"feature\":\"{}\",\"passed\":{},\"total\":{},\"duration_ms\":{}}}",
            feature, feat_passed, feat_total, feat_dur
        );

        if config.fail_fast && total_failed > 0 { break; }
    }

    let suite_dur = suite_start.elapsed().as_millis();
    println!(
        "{{\"event\":\"suite_end\",\"passed\":{},\"failed\":{},\"duration_ms\":{}}}",
        total_passed, total_failed, suite_dur
    );

    total_failed == 0
}

// ── JSON output (array) ─────────────────────────────────────────────

fn run_tests_json(target: Option<&str>) -> bool {
    let forge_bin = std::env::current_exe().unwrap_or_else(|_| PathBuf::from("forge"));
    let features_dir = match find_features_dir() {
        Some(d) => d,
        None => {
            println!("{{\"error\": \"cannot find compiler/features/ directory\"}}");
            return false;
        }
    };

    let features = match target {
        Some(t) => vec![t.to_string()],
        None => discover_features(&features_dir),
    };

    let mut all_passed = true;
    let mut feature_entries = Vec::new();

    for feature in &features {
        let result = test_feature(&forge_bin, &features_dir, feature);
        if result.passed != result.total { all_passed = false; }

        let test_entries: Vec<String> = result.results.iter().map(|t| {
            let name = t.file.file_stem().unwrap_or_default().to_string_lossy();
            format!("{{\"name\":\"{}\",\"passed\":{}}}", name, t.passed)
        }).collect();

        feature_entries.push(format!(
            "{{\"feature\":\"{}\",\"passed\":{},\"total\":{},\"tests\":[{}]}}",
            result.feature, result.passed, result.total, test_entries.join(",")
        ));
    }

    println!("[{}]", feature_entries.join(","));
    all_passed
}

// ── Utility ─────────────────────────────────────────────────────────

fn strip_ansi_codes(s: &str) -> String {
    let mut result = String::with_capacity(s.len());
    let mut chars = s.chars().peekable();
    while let Some(c) = chars.next() {
        if c == '\x1b' {
            while let Some(&next) = chars.peek() {
                chars.next();
                if next == 'm' { break; }
            }
        } else {
            result.push(c);
        }
    }
    result
}

/// Get test counts for a feature without printing (for `forge features`)
pub fn count_feature_tests(forge_bin: &Path, features_dir: &Path, feature: &str) -> (usize, usize) {
    let result = test_feature(forge_bin, features_dir, feature);
    (result.passed, result.total)
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
        .ok().into_iter().flatten().filter_map(|e| e.ok())
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

/// Fast example count for `forge features` table — counts .fg files without compiling them
pub fn get_all_feature_example_counts() -> Vec<(String, usize)> {
    let features_dir = match find_features_dir() {
        Some(d) => d,
        None => return vec![],
    };

    let mut counts = Vec::new();
    let mut features: Vec<String> = std::fs::read_dir(&features_dir)
        .ok().into_iter().flatten().filter_map(|e| e.ok())
        .filter(|e| e.path().is_dir())
        .filter_map(|e| e.file_name().into_string().ok())
        .collect();
    features.sort();

    for feature in &features {
        let files = get_example_files(&features_dir.join(feature));
        counts.push((feature.clone(), files.len()));
    }
    counts
}
