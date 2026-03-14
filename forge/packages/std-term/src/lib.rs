use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use std::sync::atomic::{AtomicI64, Ordering};
use std::sync::Mutex;
use std::collections::HashMap;
use std::io::Write;

fn cstr(ptr: *const c_char) -> String {
    unsafe { CStr::from_ptr(ptr) }.to_str().unwrap_or("").to_string()
}

fn to_c(s: &str) -> *mut c_char {
    CString::new(s).unwrap_or_default().into_raw()
}

// ── TTY / Terminal Info ──

/// Check if stdout is a TTY
#[no_mangle]
pub extern "C" fn forge_term_is_tty() -> i64 {
    unsafe { if libc::isatty(1) != 0 { 1 } else { 0 } }
}

/// Get terminal width (columns)
#[no_mangle]
pub extern "C" fn forge_term_width() -> i64 {
    #[cfg(unix)]
    {
        let mut ws: libc::winsize = unsafe { std::mem::zeroed() };
        let result = unsafe { libc::ioctl(1, libc::TIOCGWINSZ, &mut ws) };
        if result == 0 && ws.ws_col > 0 {
            ws.ws_col as i64
        } else {
            80
        }
    }
    #[cfg(not(unix))]
    { 80 }
}

// ── ANSI Wrapping ──

/// Wrap text with ANSI code if stdout is a TTY
#[no_mangle]
pub extern "C" fn forge_term_wrap(code: *const c_char, text: *const c_char) -> *mut c_char {
    let code = cstr(code);
    let text = cstr(text);
    let is_tty = unsafe { libc::isatty(1) != 0 };
    if is_tty {
        to_c(&format!("\x1b[{}m{}\x1b[0m", code, text))
    } else {
        to_c(&text)
    }
}

// ── Spinner ──

struct SpinnerEntry {
    active: std::sync::Arc<std::sync::atomic::AtomicBool>,
    handle: Option<std::thread::JoinHandle<()>>,
}

static SPINNER_NEXT_ID: AtomicI64 = AtomicI64::new(1);

fn spinner_registry() -> &'static Mutex<HashMap<i64, SpinnerEntry>> {
    use std::sync::OnceLock;
    static REGISTRY: OnceLock<Mutex<HashMap<i64, SpinnerEntry>>> = OnceLock::new();
    REGISTRY.get_or_init(|| Mutex::new(HashMap::new()))
}

/// Start a spinner with a message. Returns spinner ID.
#[no_mangle]
pub extern "C" fn forge_term_spinner_start(msg: *const c_char) -> i64 {
    let msg = cstr(msg);
    let id = SPINNER_NEXT_ID.fetch_add(1, Ordering::SeqCst);
    let active = std::sync::Arc::new(std::sync::atomic::AtomicBool::new(true));
    let active_clone = active.clone();

    let handle = std::thread::spawn(move || {
        let frames = ["\u{280B}", "\u{2819}", "\u{2839}", "\u{2838}",
                       "\u{283C}", "\u{2834}", "\u{2826}", "\u{2827}",
                       "\u{2807}", "\u{280F}"];
        let mut i = 0;
        while active_clone.load(Ordering::Relaxed) {
            eprint!("\r{} {} ", frames[i % frames.len()], msg);
            let _ = std::io::stderr().flush();
            std::thread::sleep(std::time::Duration::from_millis(80));
            i += 1;
        }
    });

    if let Ok(mut reg) = spinner_registry().lock() {
        reg.insert(id, SpinnerEntry {
            active,
            handle: Some(handle),
        });
    }

    id
}

/// Stop spinner and print done message
#[no_mangle]
pub extern "C" fn forge_term_spinner_done(id: i64, msg: *const c_char) {
    let msg = cstr(msg);
    if let Ok(mut reg) = spinner_registry().lock() {
        if let Some(mut entry) = reg.remove(&id) {
            entry.active.store(false, Ordering::Relaxed);
            if let Some(handle) = entry.handle.take() {
                let _ = handle.join();
            }
            // Clear line and print done
            eprint!("\r\x1b[2K");
            eprintln!("\u{2713} {}", msg);
        }
    }
}

// ── Progress Bar ──

struct ProgressEntry {
    total: i64,
    label: String,
}

static PROGRESS_NEXT_ID: AtomicI64 = AtomicI64::new(1);

fn progress_registry() -> &'static Mutex<HashMap<i64, ProgressEntry>> {
    use std::sync::OnceLock;
    static REGISTRY: OnceLock<Mutex<HashMap<i64, ProgressEntry>>> = OnceLock::new();
    REGISTRY.get_or_init(|| Mutex::new(HashMap::new()))
}

/// Start a progress bar. Returns progress ID.
#[no_mangle]
pub extern "C" fn forge_term_progress_start(total: i64, label: *const c_char) -> i64 {
    let label = cstr(label);
    let id = PROGRESS_NEXT_ID.fetch_add(1, Ordering::SeqCst);
    if let Ok(mut reg) = progress_registry().lock() {
        reg.insert(id, ProgressEntry { total, label: label.clone() });
    }
    // Print initial empty bar
    eprint!("\r{}: [{}] 0%", label, " ".repeat(30));
    let _ = std::io::stderr().flush();
    id
}

/// Update progress bar
#[no_mangle]
pub extern "C" fn forge_term_progress_update(id: i64, current: i64) {
    if let Ok(reg) = progress_registry().lock() {
        if let Some(entry) = reg.get(&id) {
            let pct = if entry.total > 0 { (current * 100 / entry.total) as usize } else { 0 };
            let filled = pct * 30 / 100;
            let bar: String = "\u{2588}".repeat(filled)
                + &"\u{2591}".repeat(30 - filled);
            eprint!("\r{}: [{}] {}%", entry.label, bar, pct);
            let _ = std::io::stderr().flush();
        }
    }
}

/// Complete progress bar
#[no_mangle]
pub extern "C" fn forge_term_progress_done(id: i64, msg: *const c_char) {
    let msg = cstr(msg);
    if let Ok(mut reg) = progress_registry().lock() {
        reg.remove(&id);
    }
    eprint!("\r\x1b[2K");
    eprintln!("\u{2713} {}", msg);
}

// ── Terminal Control ──

/// Print to stderr (for term output that shouldn't mix with stdout)
#[no_mangle]
pub extern "C" fn forge_term_eprint(msg: *const c_char) {
    let msg = cstr(msg);
    eprint!("{}", msg);
    let _ = std::io::stderr().flush();
}

/// Clear the current line
#[no_mangle]
pub extern "C" fn forge_term_clear_line() {
    eprint!("\r\x1b[2K");
    let _ = std::io::stderr().flush();
}

/// Move cursor up N lines
#[no_mangle]
pub extern "C" fn forge_term_cursor_up(n: i64) {
    eprint!("\x1b[{}A", n);
    let _ = std::io::stderr().flush();
}
