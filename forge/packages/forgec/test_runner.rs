/// Module example test runner.
///
/// Every test runs the same way: fork() a child process, JIT-compile and
/// execute the .fg file in the child, capture stdout+stderr via pipes,
/// compare against `/// expect:` comments. Fork gives complete process
/// isolation so package global state can never leak between tests.
///
/// Parallel mode (-j N): all forks happen sequentially on the main thread
/// (avoiding fd inheritance issues), while N worker threads handle pipe
/// reading + waitpid concurrently.

use std::collections::HashMap;
use std::io::{self, Write};
use std::path::{Path, PathBuf};
use std::sync::mpsc;
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
    /// Number of parallel test jobs. 0 or 1 = sequential.
    pub jobs: usize,
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
            jobs: 0,
        }
    }
}

// ── Results ─────────────────────────────────────────────────────────

#[derive(Debug)]
pub struct TestResult {
    pub file: PathBuf,
    pub module: String,
    pub passed: bool,
    pub expected: Vec<String>,
    pub actual: Vec<String>,
    pub error: Option<String>,
    pub duration: Duration,
}

#[derive(Debug)]
pub struct ModuleTestResult {
    pub module: String,
    pub total: usize,
    pub passed: usize,
    pub results: Vec<TestResult>,
    pub duration: Duration,
}

// ── Parsed expectations from source ─────────────────────────────────

struct TestExpectations {
    stdout: Vec<String>,
    stderr: Vec<String>,
    error: Option<String>,
    exit_code: Option<i32>,
}

impl TestExpectations {
    fn from_source(source: &str) -> Self {
        Self {
            stdout: extract_expected_output(source),
            stderr: extract_expected_stderr(source),
            error: extract_expected_error(source),
            exit_code: extract_expected_exit_code(source),
        }
    }

    fn is_empty(&self) -> bool {
        self.stdout.is_empty() && self.stderr.is_empty() && self.error.is_none()
    }

    fn is_check(&self) -> bool {
        self.error.is_some()
    }
}

// ── Color helpers ───────────────────────────────────────────────────

struct Colors {
    enabled: bool,
}

impl Colors {
    fn new(no_color: bool) -> Self {
        Self { enabled: !no_color && atty_stdout() }
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

/// Find modules directory by scanning from CWD.
/// A module is any directory containing an `examples/` subdirectory with .fg test files.
/// Returns the parent directory that contains the modules.
pub fn find_modules_dir() -> Option<PathBuf> {
    let cwd = std::env::current_dir().ok()?;

    // Check if CWD itself contains modules (dirs with examples/)
    if has_modules(&cwd) {
        return Some(cwd);
    }

    // Check common subdirectory patterns
    for subdir in &["features", "modules", "src/features", "src/modules",
                     "packages/forgec/features"] {
        let candidate = cwd.join(subdir);
        if candidate.is_dir() && has_modules(&candidate) {
            return Some(candidate);
        }
    }

    None
}

/// Check if a directory contains at least one module (subdir with examples/*.fg)
fn has_modules(dir: &Path) -> bool {
    std::fs::read_dir(dir)
        .ok()
        .into_iter()
        .flatten()
        .filter_map(|e| e.ok())
        .any(|e| e.path().is_dir() && e.path().join("examples").is_dir())
}

fn get_example_files(module_dir: &Path) -> Vec<PathBuf> {
    let examples_dir = module_dir.join("examples");
    if !examples_dir.is_dir() { return vec![]; }

    let mut files: Vec<PathBuf> = std::fs::read_dir(&examples_dir)
        .ok()
        .into_iter()
        .flatten()
        .filter_map(|e| e.ok())
        .map(|e| e.path())
        .filter(|p| p.extension().and_then(|e| e.to_str()) == Some("fg"))
        .filter(|p| {
            // Skip helper/module files that have no test expectations.
            // These are companion files imported by actual test files.
            if let Ok(source) = std::fs::read_to_string(p) {
                source.contains("/// expect:") || source.contains("/// expect-error:") || source.contains("/// expect-stderr:")
            } else {
                false
            }
        })
        .collect();
    files.sort();
    files
}

fn discover_modules(modules_dir: &Path) -> Vec<String> {
    let mut modules: Vec<String> = std::fs::read_dir(modules_dir)
        .ok()
        .into_iter()
        .flatten()
        .filter_map(|e| e.ok())
        .filter(|e| e.path().is_dir() && e.path().join("examples").is_dir())
        .filter_map(|e| e.file_name().into_string().ok())
        .collect();
    modules.sort();
    modules
}

/// Discover modules and build work items, applying an optional filter.
fn discover_work_items(
    modules_dir: &Path,
    target: Option<&str>,
    filter: Option<&str>,
) -> (Vec<(String, PathBuf)>, HashMap<String, usize>, Vec<String>) {
    let mut modules: Vec<String> = match target {
        Some(t) => vec![t.to_string()],
        None => discover_modules(modules_dir),
    };

    if let Some(f) = filter {
        modules.retain(|m| m.contains(f));
    }

    let mut work_items: Vec<(String, PathBuf)> = Vec::new();
    let mut module_test_counts: HashMap<String, usize> = HashMap::new();
    let mut module_order: Vec<String> = Vec::new();

    for module in &modules {
        let files = get_example_files(&modules_dir.join(module));
        if files.is_empty() { continue; }
        module_test_counts.insert(module.clone(), files.len());
        module_order.push(module.clone());
        for file in files {
            work_items.push((module.clone(), file));
        }
    }

    (work_items, module_test_counts, module_order)
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

// ── Test execution ──────────────────────────────────────────────────

extern "C" {
    fn pipe(pipefd: *mut i32) -> i32;
    fn fork() -> i32;
    fn close(fd: i32) -> i32;
    fn dup2(oldfd: i32, newfd: i32) -> i32;
    fn waitpid(pid: i32, status: *mut i32, options: i32) -> i32;
    fn fflush(stream: *mut std::ffi::c_void) -> i32;
    fn _exit(status: i32) -> !;
    fn dlsym(handle: *mut std::ffi::c_void, symbol: *const i8) -> *mut std::ffi::c_void;
}

#[cfg(target_os = "macos")]
const RTLD_DEFAULT: *mut std::ffi::c_void = -2isize as *mut std::ffi::c_void;
#[cfg(not(target_os = "macos"))]
const RTLD_DEFAULT: *mut std::ffi::c_void = std::ptr::null_mut();

fn make_error_result(fg_file: &Path, module: &str, error: String) -> TestResult {
    TestResult {
        file: fg_file.to_path_buf(), module: module.to_string(),
        passed: false, expected: vec![], actual: vec![],
        error: Some(error), duration: Duration::ZERO,
    }
}

/// Read source, validate expectations, fork+run+collect.
fn run_example_forked(fg_file: &Path, module: &str) -> TestResult {
    let source = match std::fs::read_to_string(fg_file) {
        Ok(s) => s,
        Err(e) => return make_error_result(fg_file, module, format!("cannot read file: {}", e)),
    };

    let expectations = TestExpectations::from_source(&source);
    if expectations.is_empty() {
        return make_error_result(fg_file, module,
            "no /// expect:, /// expect-stderr:, or /// expect-error: comments found".to_string());
    }

    match fork_child(fg_file, expectations.is_check()) {
        Ok((pid, stdout_fd, stderr_fd, start)) =>
            collect_child(pid, stdout_fd, stderr_fd, start, fg_file, module, &expectations),
        Err(e) => make_error_result(fg_file, module, e),
    }
}

/// Fork a child to run a single test. Must be called from a single thread
/// (no concurrent forks) to avoid fd inheritance issues.
/// Returns (pid, stdout_read_fd, stderr_read_fd, start_time).
fn fork_child(fg_file: &Path, is_check: bool) -> Result<(i32, i32, i32, Instant), String> {
    let start = Instant::now();

    let mut stdout_pipe: [i32; 2] = [0; 2];
    let mut stderr_pipe: [i32; 2] = [0; 2];
    if unsafe { pipe(stdout_pipe.as_mut_ptr()) } != 0 || unsafe { pipe(stderr_pipe.as_mut_ptr()) } != 0 {
        return Err("failed to create pipes".to_string());
    }

    let pid = unsafe { fork() };

    if pid == 0 {
        // ── Child process ──────────────────────────────────────
        use crate::driver::{Driver, OptLevel};
        unsafe {
            close(stdout_pipe[0]);
            close(stderr_pipe[0]);
            dup2(stdout_pipe[1], 1);
            dup2(stderr_pipe[1], 2);
            close(stdout_pipe[1]);
            close(stderr_pipe[1]);
        }

        let mut driver = Driver::new();
        driver.optimization = OptLevel::Dev;

        let mut exit_code = if is_check {
            match driver.check(fg_file) {
                Ok(_) => 0,
                Err(e) => { eprintln!("{}", e.render()); 1 }
            }
        } else {
            match driver.run_jit(fg_file) {
                Ok(code) => code,
                Err(e) => { eprintln!("{}", e.render()); 1 }
            }
        };

        // Call package cleanup (e.g., forge_test_summary).
        // Use dlsym + _exit because exit() deadlocks in forked children.
        unsafe {
            let sym = dlsym(RTLD_DEFAULT, b"forge_test_summary\0".as_ptr() as *const i8);
            if !sym.is_null() {
                let f: extern "C" fn() -> i64 = std::mem::transmute(sym);
                if f() != 0 { exit_code = 1; }
            }
        }

        let _ = io::stdout().flush();
        let _ = io::stderr().flush();
        unsafe { fflush(std::ptr::null_mut()); }
        unsafe { _exit(exit_code); }
    }

    if pid < 0 {
        unsafe { close(stdout_pipe[0]); close(stdout_pipe[1]); close(stderr_pipe[0]); close(stderr_pipe[1]); }
        return Err("fork() failed".to_string());
    }

    // Parent: close write ends
    unsafe { close(stdout_pipe[1]); close(stderr_pipe[1]); }
    Ok((pid, stdout_pipe[0], stderr_pipe[0], start))
}

/// Read pipes from a finished child, wait for exit, and build TestResult.
fn collect_child(
    pid: i32, stdout_fd: i32, stderr_fd: i32, start: Instant,
    fg_file: &Path, module: &str, expectations: &TestExpectations,
) -> TestResult {
    use std::io::Read as _;
    use std::os::unix::io::FromRawFd;

    // Read both pipes concurrently to avoid deadlock when buffers fill
    let stderr_thread = std::thread::spawn(move || {
        let mut s = String::new();
        let mut f = unsafe { std::fs::File::from_raw_fd(stderr_fd) };
        let _ = f.read_to_string(&mut s);
        s
    });
    let mut stdout_str = String::new();
    let mut stdout_file = unsafe { std::fs::File::from_raw_fd(stdout_fd) };
    let _ = stdout_file.read_to_string(&mut stdout_str);
    let stderr_str = stderr_thread.join().unwrap_or_default();

    let mut status: i32 = 0;
    unsafe { waitpid(pid, &mut status, 0); }
    let duration = start.elapsed();

    let killed_by_signal = (status & 0x7f) != 0;
    if killed_by_signal {
        let sig = status & 0x7f;
        return make_error_result(fg_file, module, format!("child killed by signal {} (crash)", sig));
    }

    let exit_code = (status >> 8) & 0xff;
    evaluate_result(fg_file, module, exit_code, duration, &stdout_str, &stderr_str, expectations)
}

/// Run tests in parallel. All forks happen sequentially on the main thread
/// (avoiding fd inheritance issues), worker threads read pipes + waitpid.
fn run_tests_parallel(
    jobs: usize,
    work_items: Vec<(String, PathBuf)>,
    tx: mpsc::Sender<TestResult>,
) -> Vec<std::thread::JoinHandle<()>> {
    let mut handles: Vec<std::thread::JoinHandle<()>> = Vec::new();

    let (slot_tx, slot_rx) = mpsc::sync_channel::<()>(jobs);
    for _ in 0..jobs {
        let _ = slot_tx.send(());
    }

    for (module, file) in work_items {
        if slot_rx.recv().is_err() { break; }

        let source = match std::fs::read_to_string(&file) {
            Ok(s) => s,
            Err(e) => {
                let _ = tx.send(make_error_result(&file, &module, format!("cannot read file: {}", e)));
                let _ = slot_tx.send(());
                continue;
            }
        };

        let expectations = TestExpectations::from_source(&source);
        if expectations.is_empty() {
            let _ = tx.send(make_error_result(&file, &module,
                "no /// expect:, /// expect-stderr:, or /// expect-error: comments found".to_string()));
            let _ = slot_tx.send(());
            continue;
        }

        // Fork on main thread, then spawn worker to collect
        match fork_child(&file, expectations.is_check()) {
            Ok((pid, stdout_fd, stderr_fd, start)) => {
                let tx = tx.clone();
                let slot_tx = slot_tx.clone();
                handles.push(std::thread::spawn(move || {
                    let result = collect_child(pid, stdout_fd, stderr_fd, start,
                                               &file, &module, &expectations);
                    let _ = tx.send(result);
                    let _ = slot_tx.send(());
                }));
            }
            Err(e) => {
                let _ = tx.send(make_error_result(&file, &module, e));
                let _ = slot_tx.send(());
            }
        }
    }

    handles
}

fn evaluate_result(
    fg_file: &Path, module: &str, exit_code: i32, duration: Duration,
    stdout_str: &str, stderr_str: &str, exp: &TestExpectations,
) -> TestResult {
    if let Some(ref error_code) = exp.error {
        let passed = exit_code != 0 && stderr_str.contains(error_code.as_str());
        return TestResult {
            file: fg_file.to_path_buf(), module: module.to_string(), passed, duration,
            expected: vec![format!("error: {}", error_code)],
            actual: if exit_code != 0 {
                vec![format!("error: {}", error_code)]
            } else {
                vec!["no error (compiled successfully)".to_string()]
            },
            error: if !passed {
                Some(if exit_code == 0 {
                    "expected compilation to fail, but it succeeded".to_string()
                } else {
                    format!("expected error code {}, got: {}",
                        error_code, stderr_str.lines().next().unwrap_or(""))
                })
            } else { None },
        };
    }

    if !exp.stderr.is_empty() {
        let clean = strip_ansi_codes(stderr_str);
        let stderr_lines: Vec<&str> = clean.lines().collect();
        let missing: Vec<String> = exp.stderr.iter()
            .filter(|e| !stderr_lines.iter().any(|line| line.contains(e.as_str())))
            .cloned()
            .collect();
        let exit_ok = exp.exit_code.map_or(true, |code| exit_code == code);
        let passed = missing.is_empty() && exit_ok;

        return TestResult {
            file: fg_file.to_path_buf(), module: module.to_string(), passed, duration,
            expected: exp.stderr.clone(),
            actual: stderr_lines.iter().map(|s| s.to_string()).collect(),
            error: if !passed {
                Some(if !missing.is_empty() {
                    format!("missing in stderr: {:?}", missing)
                } else {
                    format!("expected exit code {:?}, got {}", exp.exit_code, exit_code)
                })
            } else { None },
        };
    }

    let actual: Vec<String> = stdout_str.lines().map(|l| l.to_string()).collect();
    let passed = actual == exp.stdout;

    TestResult {
        file: fg_file.to_path_buf(), module: module.to_string(), passed, duration,
        expected: exp.stdout.clone(), actual,
        error: if !passed && exit_code != 0 {
            Some(format!("exit code {}: {}", exit_code, stderr_str.trim()))
        } else { None },
    }
}

pub fn test_module(modules_dir: &Path, module: &str) -> ModuleTestResult {
    let files = get_example_files(&modules_dir.join(module));
    let start = Instant::now();
    let results: Vec<TestResult> = files.iter()
        .map(|file| run_example_forked(file, module))
        .collect();
    let passed = results.iter().filter(|r| r.passed).count();
    let total = results.len();
    ModuleTestResult { module: module.to_string(), total, passed, results, duration: start.elapsed() }
}

// ── Main entry point ────────────────────────────────────────────────

pub fn run_tests(target: Option<&str>, config: &TestRunConfig) -> bool {
    match config.format {
        OutputFormat::Human => run_tests_human(target, config),
        OutputFormat::Json => run_tests_json(target, config),
        OutputFormat::Stream => run_tests_stream(target, config),
    }
}

// ── Progress state for human output ─────────────────────────────────

struct ProgressState {
    module_test_counts: HashMap<String, usize>,
    module_results: HashMap<String, Vec<TestResult>>,
    module_starts: HashMap<String, Instant>,
    suite_start: Instant,
    failures: Vec<(String, TestResult)>,
    footer_lines: usize,
    spinner_idx: usize,
    running: Vec<String>,
    completed: usize,
    total: usize,
    passed: usize,
    failed: usize,
}

impl ProgressState {
    fn new(module_test_counts: HashMap<String, usize>, total: usize) -> Self {
        Self {
            module_test_counts,
            module_results: HashMap::new(),
            module_starts: HashMap::new(),
            suite_start: Instant::now(),
            failures: Vec::new(),
            footer_lines: 0,
            spinner_idx: 0,
            running: Vec::new(),
            completed: 0,
            total,
            passed: 0,
            failed: 0,
        }
    }

    /// Record a completed test result.
    fn record(&mut self, result: TestResult) {
        self.completed += 1;
        if result.passed { self.passed += 1; } else { self.failed += 1; }
        let module = result.module.clone();
        self.module_starts.entry(module.clone()).or_insert_with(Instant::now);
        self.module_results.entry(module).or_default().push(result);
    }

    /// Update the progress footer (spinner + bar).
    fn update_footer(&mut self, c: &Colors) {
        clear_footer(self.footer_lines);
        self.spinner_idx = (self.spinner_idx + 1) % SPINNER.len();
        print_footer(c, &self.running, self.completed, self.total,
                     self.suite_start.elapsed(), self.spinner_idx);
        let _ = io::stdout().flush();
        self.footer_lines = 2;
    }

    /// Render the module if all its tests are done.
    fn try_render_module(&mut self, module: &str, config: &TestRunConfig, c: &Colors, is_tty: bool) {
        let expected = self.module_test_counts.get(module).copied().unwrap_or(0);
        let current = self.module_results.get(module).map(|v| v.len()).unwrap_or(0);
        if current != expected { return; }

        let mod_start = self.module_starts.get(module).copied().unwrap_or(self.suite_start);
        let mod_duration = mod_start.elapsed();

        let results = self.module_results.remove(module).unwrap_or_default();
        let mod_passed = results.iter().filter(|r| r.passed).count();
        let mod_total = results.len();

        let (mod_failures, kept_results): (Vec<_>, Vec<_>) =
            results.into_iter().partition(|r| !r.passed);
        let mod_failures: Vec<(String, TestResult)> =
            mod_failures.into_iter().map(|r| (module.to_string(), r)).collect();

        if !config.quiet {
            if is_tty {
                clear_footer(self.footer_lines);
                self.footer_lines = 0;
            }

            print_module_result(module, mod_passed, mod_total, mod_duration,
                                 &mod_failures, &kept_results, config, c);

            if is_tty {
                print_footer(c, &self.running, self.completed, self.total,
                             self.suite_start.elapsed(), self.spinner_idx);
                let _ = io::stdout().flush();
                self.footer_lines = 2;
            }
        }

        self.failures.extend(mod_failures);
    }
}

// ── Human output ────────────────────────────────────────────────────

fn run_tests_human(target: Option<&str>, config: &TestRunConfig) -> bool {
    let modules_dir = match find_modules_dir() {
        Some(d) => d,
        None => {
            let err = crate::errors::CompileError::CliError {
                message: "no test modules found in current directory".to_string(),
                help: Some("run `forge test` from a directory containing modules with examples/".to_string()),
            };
            eprint!("{}", err.render());
            return false;
        }
    };

    let c = Colors::new(config.no_color);
    let is_tty = c.enabled;

    let (work_items, module_test_counts, module_order) =
        discover_work_items(&modules_dir, target, config.filter.as_deref());

    let total_tests = work_items.len();
    let module_count = module_order.len();

    if total_tests == 0 {
        if !config.quiet { println!("\n  No tests found."); }
        return true;
    }

    if !config.quiet {
        println!("\n  {} {} tests from {} modules\n",
            c.dim("Running"), total_tests, module_count);
    }

    let mut state = ProgressState::new(module_test_counts, total_tests);
    let mut stopped_early = false;

    if is_tty && !config.quiet {
        c.hide_cursor();
        print_footer(&c, &[], 0, total_tests, Duration::ZERO, 0);
        let _ = io::stdout().flush();
        state.footer_lines = 2;
    }

    if config.jobs > 1 {
        let (tx, rx) = mpsc::channel::<TestResult>();
        let handles = run_tests_parallel(config.jobs, work_items, tx);

        for result in rx {
            let module = result.module.clone();
            state.record(result);

            if is_tty && !config.quiet { state.update_footer(&c); }
            state.try_render_module(&module, config, &c, is_tty);

            if config.fail_fast && state.failed > 0 {
                stopped_early = true;
                break;
            }
        }

        for h in handles { let _ = h.join(); }
    } else {
        for (module, file) in &work_items {
            let label = format!("{}/{}", module,
                file.file_stem().unwrap_or_default().to_string_lossy());

            if is_tty && !config.quiet {
                state.running.push(label.clone());
                state.update_footer(&c);
            }

            let result = run_example_forked(file, module);
            state.record(result);
            state.running.retain(|r| r != &label);

            state.try_render_module(module, config, &c, is_tty);

            if config.fail_fast && state.failed > 0 {
                stopped_early = true;
                break;
            }
        }
    }

    if is_tty && !config.quiet {
        clear_footer(state.footer_lines);
        c.show_cursor();
        let _ = io::stdout().flush();
    }

    print_human_summary(&state, module_count, stopped_early, &c, config);
    state.failed == 0
}

fn print_human_summary(
    state: &ProgressState, module_count: usize, stopped_early: bool,
    c: &Colors, config: &TestRunConfig,
) {
    let suite_duration = state.suite_start.elapsed();

    println!("\n  {}\n", c.dim(&"─".repeat(54)));

    if state.failed == 0 {
        println!("  {} {}", c.green("✓"), c.green(&format!("{} passed", state.passed)));
    } else {
        println!("  {}  {}",
            c.red(&format!("✖ {} failed", state.failed)),
            c.green(&format!("✓ {} passed", state.passed)),
        );

        if !config.quiet && !state.failures.is_empty() {
            println!("\n  {}:\n", c.dim("Failures"));
            for (i, (module, test)) in state.failures.iter().enumerate() {
                let name = test.file.file_stem().unwrap_or_default().to_string_lossy();
                println!("    {}) {} > {}", i + 1, module, name);
                if let Some(ref err) = test.error {
                    for line in err.lines().take(2) {
                        println!("       {}", c.red(line));
                    }
                } else {
                    print_diff(&test.expected, &test.actual, c, 7);
                }
                println!();
            }
        }

        if stopped_early {
            println!("  {}", c.dim("Stopped early (--fail-fast)"));
        }
    }

    println!("\n  {}\n\n  {}",
        c.dim(&format!("Duration: {} | Modules: {} | Tests: {}",
            format_duration(suite_duration), module_count, state.total)),
        c.dim(&"─".repeat(54)),
    );
}

// ── Module result rendering ─────────────────────────────────────────

fn print_module_result(
    module: &str, passed: usize, total: usize, duration: Duration,
    failures: &[(String, TestResult)], passing: &[TestResult],
    config: &TestRunConfig, c: &Colors,
) {
    let icon = if passed == total { c.green("✓") } else { c.red("●") };

    if passed == total && !config.verbose {
        println!("  {} {:<32} {}  {}",
            icon, module,
            c.dim(&format!("{}/{}", passed, total)),
            c.dim(&format_duration(duration)),
        );
        return;
    }

    let counts = if passed == total {
        c.dim(&format!("{}/{}", passed, total))
    } else {
        format!("{} {}", c.dim(&format!("{}/{}", passed, total)),
            c.red(&format!("{} failed", total - passed)))
    };
    println!("  {} {}  {}", icon, module, counts);

    for test in passing {
        let name = test.file.file_stem().unwrap_or_default().to_string_lossy();
        println!("    {} {:<36} {}", c.green("✓"), name, c.dim(&format_duration(test.duration)));
    }
    for (_, test) in failures {
        let name = test.file.file_stem().unwrap_or_default().to_string_lossy();
        println!("    {} {:<36} {}", c.red("✖"), name, c.dim(&format_duration(test.duration)));
        print_failure_detail(test, c);
    }
    println!();
}

// ── Spinner + progress bar ──────────────────────────────────────────

const SPINNER: &[char] = &['◐', '◓', '◑', '◒'];

fn print_footer(
    c: &Colors, running: &[String],
    completed: usize, total: usize, elapsed: Duration, spinner_idx: usize,
) {
    let spinner = SPINNER[spinner_idx % SPINNER.len()];

    if running.is_empty() {
        println!("  {} {}", c.cyan(&spinner.to_string()), c.dim("waiting..."));
    } else {
        let max_show = 3;
        let shown: Vec<&str> = running.iter().take(max_show).map(|s| s.as_str()).collect();
        let extra = if running.len() > max_show {
            format!("  {}", c.dim(&format!("+{} more", running.len() - max_show)))
        } else { String::new() };
        println!("  {} {}{}", c.cyan(&spinner.to_string()), c.dim(&shown.join("  ")), extra);
    }

    let bar_width = 40usize;
    let filled = if total > 0 { (completed * bar_width) / total } else { 0 };
    println!("  {}{}  {}/{}  {}",
        c.green(&"█".repeat(filled)),
        c.dim(&"░".repeat(bar_width - filled)),
        completed, total, c.dim(&format_duration(elapsed)),
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

fn print_diff(expected: &[String], actual: &[String], c: &Colors, indent: usize) {
    let pad = " ".repeat(indent);

    // Detect same content in wrong order
    if expected.len() == actual.len() && expected.len() > 1 {
        let mut exp_sorted = expected.to_vec();
        let mut act_sorted = actual.to_vec();
        exp_sorted.sort();
        act_sorted.sort();
        if exp_sorted == act_sorted && expected != actual {
            println!("{}{}  output lines match but in wrong order:", pad, c.red("!"));
            println!("{}   {} {}", pad, c.dim("expected:"), expected.join(", "));
            println!("{}   {}   {}", pad, c.dim("actual:"), actual.join(", "));
            return;
        }
    }

    for i in 0..expected.len().max(actual.len()) {
        let exp = expected.get(i).map(|s| s.as_str()).unwrap_or("");
        let act = actual.get(i).map(|s| s.as_str()).unwrap_or("");
        if exp == act {
            println!("{}  {}", pad, c.dim(act));
        } else {
            if !exp.is_empty() { println!("{}{} {}", pad, c.green("expected:"), c.green(exp)); }
            if !act.is_empty() { println!("{}{} {}", pad, c.red("  actual:"), c.red(act)); }
        }
    }
}

fn format_duration(d: Duration) -> String {
    let us = d.as_micros();
    if us < 1000 { format!("{}µs", us) }
    else if us < 1_000_000 { format!("{:.1}ms", us as f64 / 1000.0) }
    else { format!("{:.1}s", d.as_secs_f64()) }
}

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

// ── Stream output (JSON lines) ──────────────────────────────────────

fn emit_stream_result(result: &TestResult) {
    let name = result.file.file_stem().unwrap_or_default().to_string_lossy();
    let ms = result.duration.as_millis();
    if result.passed {
        println!("{{\"event\":\"pass\",\"module\":\"{}\",\"test\":\"{}\",\"duration_ms\":{}}}",
            result.module, name, ms);
    } else {
        let err = result.error.as_deref().unwrap_or("")
            .replace('\\', "\\\\").replace('"', "\\\"").replace('\n', "\\n");
        println!("{{\"event\":\"fail\",\"module\":\"{}\",\"test\":\"{}\",\"duration_ms\":{},\"error\":\"{}\"}}",
            result.module, name, ms, err);
    }
}

fn run_tests_stream(target: Option<&str>, config: &TestRunConfig) -> bool {
    let modules_dir = match find_modules_dir() {
        Some(d) => d,
        None => {
            println!("{{\"event\":\"error\",\"message\":\"no test modules found in current directory\"}}");
            return false;
        }
    };

    let (work_items, module_test_counts, _) =
        discover_work_items(&modules_dir, target, config.filter.as_deref());

    println!("{{\"event\":\"suite_start\",\"modules\":{},\"tests\":{}}}",
        module_test_counts.len(), work_items.len());

    let suite_start = Instant::now();
    let mut total_passed = 0usize;
    let mut total_failed = 0usize;
    let mut module_started: std::collections::HashSet<String> = std::collections::HashSet::new();
    let mut module_results: HashMap<String, Vec<TestResult>> = HashMap::new();
    let mut module_starts: HashMap<String, Instant> = HashMap::new();

    let mut handle_result = |result: TestResult| {
        let module = result.module.clone();

        if module_started.insert(module.clone()) {
            let count = module_test_counts.get(&module).copied().unwrap_or(0);
            println!("{{\"event\":\"module_start\",\"module\":\"{}\",\"tests\":{}}}", module, count);
            module_starts.insert(module.clone(), Instant::now());
        }

        if result.passed { total_passed += 1; } else { total_failed += 1; }
        emit_stream_result(&result);
        module_results.entry(module.clone()).or_default().push(result);

        let expected = module_test_counts.get(&module).copied().unwrap_or(0);
        if module_results.get(&module).map(|v| v.len()).unwrap_or(0) == expected {
            let results = module_results.remove(&module).unwrap_or_default();
            let mod_passed = results.iter().filter(|r| r.passed).count();
            let mod_dur = module_starts.get(&module).map(|s| s.elapsed().as_millis()).unwrap_or(0);
            println!("{{\"event\":\"module_end\",\"module\":\"{}\",\"passed\":{},\"total\":{},\"duration_ms\":{}}}",
                module, mod_passed, results.len(), mod_dur);
        }
        total_failed
    };

    if config.jobs > 1 {
        let (tx, rx) = mpsc::channel::<TestResult>();
        let handles = run_tests_parallel(config.jobs, work_items, tx);
        for result in rx {
            let failed = handle_result(result);
            if config.fail_fast && failed > 0 { break; }
        }
        for h in handles { let _ = h.join(); }
    } else {
        for (module, file) in &work_items {
            let failed = handle_result(run_example_forked(file, module));
            if config.fail_fast && failed > 0 { break; }
        }
    }

    println!("{{\"event\":\"suite_end\",\"passed\":{},\"failed\":{},\"duration_ms\":{}}}",
        total_passed, total_failed, suite_start.elapsed().as_millis());
    total_failed == 0
}

// ── JSON output (array) ─────────────────────────────────────────────

fn run_tests_json(target: Option<&str>, config: &TestRunConfig) -> bool {
    let modules_dir = match find_modules_dir() {
        Some(d) => d,
        None => {
            println!("{{\"error\": \"no test modules found in current directory\"}}");
            return false;
        }
    };

    let (_, _, module_order) =
        discover_work_items(&modules_dir, target, config.filter.as_deref());

    let module_results: Vec<ModuleTestResult> = module_order.iter()
        .map(|m| test_module(&modules_dir, m))
        .collect();

    let mut all_passed = true;
    let entries: Vec<String> = module_results.iter().map(|result| {
        if result.passed != result.total { all_passed = false; }
        let tests: Vec<String> = result.results.iter().map(|t| {
            let name = t.file.file_stem().unwrap_or_default().to_string_lossy();
            format!("{{\"name\":\"{}\",\"passed\":{}}}", name, t.passed)
        }).collect();
        format!("{{\"module\":\"{}\",\"passed\":{},\"total\":{},\"tests\":[{}]}}",
            result.module, result.passed, result.total, tests.join(","))
    }).collect();

    println!("[{}]", entries.join(","));
    all_passed
}

// ── Public API for `compiler features` ─────────────────────────────────

pub fn count_module_tests(modules_dir: &Path, module: &str) -> (usize, usize) {
    let result = test_module(modules_dir, module);
    (result.passed, result.total)
}

pub fn get_all_module_test_counts() -> Vec<(String, usize, usize)> {
    let modules_dir = match find_modules_dir() {
        Some(d) => d,
        None => return vec![],
    };
    discover_modules(&modules_dir).iter()
        .map(|m| {
            let (passed, total) = count_module_tests(&modules_dir, m);
            (m.clone(), passed, total)
        })
        .collect()
}

pub fn get_all_module_example_counts() -> Vec<(String, usize)> {
    let modules_dir = match find_modules_dir() {
        Some(d) => d,
        None => return vec![],
    };
    discover_modules(&modules_dir).iter()
        .map(|m| {
            let count = get_example_files(&modules_dir.join(m)).len();
            (m.clone(), count)
        })
        .collect()
}
