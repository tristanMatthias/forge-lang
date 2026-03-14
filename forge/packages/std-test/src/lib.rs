use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use std::sync::Mutex;
use std::sync::OnceLock;
use std::time::Instant;

// ── Helpers ──

fn cstr(ptr: *const c_char) -> String {
    unsafe { CStr::from_ptr(ptr) }.to_str().unwrap_or("").to_string()
}

#[allow(dead_code)]
fn to_c(s: &str) -> *mut c_char {
    CString::new(s).unwrap_or_default().into_raw()
}

// ── Test state ──

struct TestState {
    indent: usize,
    passed: usize,
    failed: usize,
    skipped: usize,
    todos: usize,
    start_time: Option<Instant>,
    has_failures: bool,
}

impl TestState {
    fn new() -> Self {
        Self {
            indent: 0,
            passed: 0,
            failed: 0,
            skipped: 0,
            todos: 0,
            start_time: None,
            has_failures: false,
        }
    }

    fn indent_str(&self) -> String {
        "  ".repeat(self.indent)
    }
}

fn state() -> &'static Mutex<TestState> {
    static STATE: OnceLock<Mutex<TestState>> = OnceLock::new();
    STATE.get_or_init(|| Mutex::new(TestState::new()))
}

// ── atexit summary ──

extern "C" fn atexit_summary() {
    let s = state().lock().unwrap();
    let total = s.passed + s.failed + s.skipped + s.todos;
    if total == 0 {
        return;
    }

    let elapsed = s.start_time.map(|t| t.elapsed()).unwrap_or_default();
    let elapsed_str = if elapsed.as_millis() < 1000 {
        format!("{:.1}ms", elapsed.as_secs_f64() * 1000.0)
    } else {
        format!("{:.2}s", elapsed.as_secs_f64())
    };

    eprintln!();

    let mut parts = Vec::new();
    if s.passed > 0 {
        parts.push(format!("\x1b[32m{} passed\x1b[0m", s.passed));
    }
    if s.failed > 0 {
        parts.push(format!("\x1b[31m{} failed\x1b[0m", s.failed));
    }
    if s.skipped > 0 {
        parts.push(format!("\x1b[33m{} skipped\x1b[0m", s.skipped));
    }
    if s.todos > 0 {
        parts.push(format!("\x1b[36m{} todo\x1b[0m", s.todos));
    }

    eprintln!("  {} ({})", parts.join(", "), elapsed_str);

    if s.has_failures {
        std::process::exit(1);
    }
}

extern "C" {
    fn atexit(cb: extern "C" fn()) -> i32;
}

static REGISTERED: std::sync::atomic::AtomicBool = std::sync::atomic::AtomicBool::new(false);

fn ensure_atexit() {
    if !REGISTERED.swap(true, std::sync::atomic::Ordering::SeqCst) {
        unsafe { atexit(atexit_summary); }
    }
}

// ── Extern functions ──

#[no_mangle]
pub extern "C" fn forge_test_start_spec(name: *const c_char) {
    ensure_atexit();
    let name = cstr(name);
    let mut s = state().lock().unwrap();
    if s.start_time.is_none() {
        s.start_time = Some(Instant::now());
    }
    let indent = s.indent_str();
    eprintln!("{}  {}", indent, name);
    s.indent += 1;
}

#[no_mangle]
pub extern "C" fn forge_test_end_spec() {
    let mut s = state().lock().unwrap();
    if s.indent > 0 {
        s.indent -= 1;
    }
}

#[no_mangle]
pub extern "C" fn forge_test_start_given(name: *const c_char) {
    let name = cstr(name);
    let mut s = state().lock().unwrap();
    let indent = s.indent_str();
    eprintln!("{}  given {}", indent, name);
    s.indent += 1;
}

#[no_mangle]
pub extern "C" fn forge_test_end_given() {
    let mut s = state().lock().unwrap();
    if s.indent > 0 {
        s.indent -= 1;
    }
}

#[no_mangle]
pub extern "C" fn forge_test_run_then(
    name: *const c_char,
    result: i8,
    file: *const c_char,
    line: i64,
) {
    let name = cstr(name);
    let file = cstr(file);
    let mut s = state().lock().unwrap();
    let indent = s.indent_str();

    if result != 0 {
        s.passed += 1;
        eprintln!("{}  \x1b[32m\u{2713}\x1b[0m {}", indent, name);
    } else {
        s.failed += 1;
        s.has_failures = true;
        eprintln!("{}  \x1b[31m\u{2717}\x1b[0m {}", indent, name);
        eprintln!();
        eprintln!("{}      at {}:{}", indent, file, line);
        eprintln!();
    }
}

#[no_mangle]
pub extern "C" fn forge_test_run_then_should_fail(
    name: *const c_char,
    did_error: i8,
    _error_msg: *const c_char,
    expected_msg: *const c_char,
    file: *const c_char,
    line: i64,
) {
    let name = cstr(name);
    let file = cstr(file);
    let expected = cstr(expected_msg);
    let mut s = state().lock().unwrap();
    let indent = s.indent_str();

    if did_error != 0 {
        s.passed += 1;
        eprintln!("{}  \x1b[32m\u{2713}\x1b[0m {}", indent, name);
    } else {
        s.failed += 1;
        s.has_failures = true;
        eprintln!("{}  \x1b[31m\u{2717}\x1b[0m {}", indent, name);
        eprintln!();
        if !expected.is_empty() {
            eprintln!("{}      expected error containing \"{}\"", indent, expected);
        } else {
            eprintln!("{}      expected an error, but succeeded", indent);
        }
        eprintln!("{}      at {}:{}", indent, file, line);
        eprintln!();
    }
}

#[no_mangle]
pub extern "C" fn forge_test_skip(name: *const c_char) {
    let name = cstr(name);
    let mut s = state().lock().unwrap();
    let indent = s.indent_str();
    s.skipped += 1;
    eprintln!("{}  \x1b[33m\u{2298}\x1b[0m {} \x1b[33m(skipped)\x1b[0m", indent, name);
}

#[no_mangle]
pub extern "C" fn forge_test_todo(name: *const c_char) {
    let name = cstr(name);
    let mut s = state().lock().unwrap();
    let indent = s.indent_str();
    s.todos += 1;
    eprintln!("{}  \x1b[36m\u{25CB}\x1b[0m {} \x1b[36m(todo)\x1b[0m", indent, name);
}

#[no_mangle]
pub extern "C" fn forge_test_summary() -> i64 {
    let s = state().lock().unwrap();
    let elapsed = s.start_time.map(|t| t.elapsed()).unwrap_or_default();
    let elapsed_str = if elapsed.as_millis() < 1000 {
        format!("{:.1}ms", elapsed.as_secs_f64() * 1000.0)
    } else {
        format!("{:.2}s", elapsed.as_secs_f64())
    };

    eprintln!();

    let mut parts = Vec::new();
    if s.passed > 0 {
        parts.push(format!("\x1b[32m{} passed\x1b[0m", s.passed));
    }
    if s.failed > 0 {
        parts.push(format!("\x1b[31m{} failed\x1b[0m", s.failed));
    }
    if s.skipped > 0 {
        parts.push(format!("\x1b[33m{} skipped\x1b[0m", s.skipped));
    }
    if s.todos > 0 {
        parts.push(format!("\x1b[36m{} todo\x1b[0m", s.todos));
    }

    if parts.is_empty() {
        eprintln!("  No tests found");
    } else {
        eprintln!("  {} ({})", parts.join(", "), elapsed_str);
    }

    if s.has_failures { 1 } else { 0 }
}

/// Approximate float comparison: |actual - expected| <= tolerance
#[no_mangle]
pub extern "C" fn forge_test_roughly(actual: f64, expected: f64, tolerance: f64) -> i8 {
    if (actual - expected).abs() <= tolerance { 1 } else { 0 }
}
