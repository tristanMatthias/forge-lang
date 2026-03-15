use std::collections::HashMap;
use std::ffi::{CStr, CString};
use std::io::{BufRead, BufReader, Read, Write};
use std::os::raw::c_char;
use std::process::{Child, Command, Stdio};
use std::sync::atomic::{AtomicI64, Ordering};
use std::sync::Mutex;
use std::time::{Duration, Instant};

// ── Helpers ──

fn cstr(ptr: *const c_char) -> String {
    unsafe { CStr::from_ptr(ptr) }.to_str().unwrap_or("").to_string()
}

fn to_c(s: &str) -> *mut c_char {
    CString::new(s).unwrap_or_default().into_raw()
}

fn escape_json(s: &str) -> String {
    let mut out = String::with_capacity(s.len());
    for ch in s.chars() {
        match ch {
            '"' => out.push_str("\\\""),
            '\\' => out.push_str("\\\\"),
            '\n' => out.push_str("\\n"),
            '\r' => out.push_str("\\r"),
            '\t' => out.push_str("\\t"),
            c if (c as u32) < 0x20 => {
                out.push_str(&format!("\\u{:04x}", c as u32));
            }
            c => out.push(c),
        }
    }
    out
}

fn result_json(stdout: &str, stderr: &str, code: i32) -> String {
    format!(
        "{{\"stdout\":\"{}\",\"stderr\":\"{}\",\"code\":{}}}",
        escape_json(stdout),
        escape_json(stderr),
        code
    )
}

// ── Process Registry ──

struct ProcessEntry {
    child: Child,
    stdout_reader: Option<BufReader<std::process::ChildStdout>>,
}

static NEXT_ID: AtomicI64 = AtomicI64::new(1);

fn registry() -> &'static Mutex<HashMap<i64, ProcessEntry>> {
    use std::sync::OnceLock;
    static REGISTRY: OnceLock<Mutex<HashMap<i64, ProcessEntry>>> = OnceLock::new();
    REGISTRY.get_or_init(|| Mutex::new(HashMap::new()))
}

// ── Parse options helpers ──

fn apply_opts(cmd: &mut Command, args_json: &str, opts_json: &str) {
    // Parse args array
    if !args_json.is_empty() {
        if let Ok(args) = serde_json::from_str::<Vec<String>>(args_json) {
            cmd.args(&args);
        }
    }

    // Parse opts object
    if !opts_json.is_empty() {
        if let Ok(opts) = serde_json::from_str::<serde_json::Value>(opts_json) {
            if let Some(cwd) = opts.get("cwd").and_then(|v| v.as_str()) {
                cmd.current_dir(cwd);
            }
            if let Some(env_obj) = opts.get("env").and_then(|v| v.as_object()) {
                for (k, v) in env_obj {
                    if let Some(val) = v.as_str() {
                        cmd.env(k, val);
                    }
                }
            }
        }
    }
}

fn get_timeout_ms(opts_json: &str) -> Option<u64> {
    if opts_json.is_empty() {
        return None;
    }
    serde_json::from_str::<serde_json::Value>(opts_json)
        .ok()
        .and_then(|opts| opts.get("timeout_ms").and_then(|v| v.as_u64()))
}

// ── Extern C Functions ──

/// Run a process synchronously and return JSON result.
#[no_mangle]
pub extern "C" fn forge_process_run(
    cmd: *const c_char,
    args_json: *const c_char,
    opts_json: *const c_char,
) -> *mut c_char {
    let cmd_str = cstr(cmd);
    let args_str = cstr(args_json);
    let opts_str = cstr(opts_json);

    let mut command = Command::new(&cmd_str);
    command.stdout(Stdio::piped()).stderr(Stdio::piped());
    apply_opts(&mut command, &args_str, &opts_str);

    let timeout = get_timeout_ms(&opts_str);

    match command.spawn() {
        Ok(mut child) => {
            if let Some(ms) = timeout {
                let timeout_dur = Duration::from_millis(ms);
                let start = Instant::now();

                // Poll for completion or timeout
                loop {
                    match child.try_wait() {
                        Ok(Some(status)) => {
                            let stdout = child
                                .stdout
                                .take()
                                .map(|mut s| {
                                    let mut buf = String::new();
                                    let _ = s.read_to_string(&mut buf);
                                    buf
                                })
                                .unwrap_or_default();
                            let stderr = child
                                .stderr
                                .take()
                                .map(|mut s| {
                                    let mut buf = String::new();
                                    let _ = s.read_to_string(&mut buf);
                                    buf
                                })
                                .unwrap_or_default();
                            let code = status.code().unwrap_or(-1);
                            return to_c(&result_json(&stdout, &stderr, code));
                        }
                        Ok(None) => {
                            if start.elapsed() >= timeout_dur {
                                let _ = child.kill();
                                let _ = child.wait();
                                return to_c(&result_json(
                                    "",
                                    &format!("process timed out after {}ms", ms),
                                    -1,
                                ));
                            }
                            std::thread::sleep(Duration::from_millis(10));
                        }
                        Err(e) => {
                            return to_c(&result_json(
                                "",
                                &format!("wait error: {}", e),
                                -1,
                            ));
                        }
                    }
                }
            } else {
                // No timeout: just wait
                match child.wait_with_output() {
                    Ok(output) => {
                        let stdout = String::from_utf8_lossy(&output.stdout).to_string();
                        let stderr = String::from_utf8_lossy(&output.stderr).to_string();
                        let code = output.status.code().unwrap_or(-1);
                        to_c(&result_json(&stdout, &stderr, code))
                    }
                    Err(e) => to_c(&result_json("", &format!("wait error: {}", e), -1)),
                }
            }
        }
        Err(e) => to_c(&result_json("", &format!("spawn error: {}", e), -1)),
    }
}

/// Execute a shell command and return just stdout (for $"..." syntax).
/// Returns stdout string directly, or empty string on error.
#[no_mangle]
pub extern "C" fn forge_process_exec(cmd: *const c_char) -> *mut c_char {
    let cmd_str = cstr(cmd);

    let mut command = Command::new("sh");
    command.arg("-c").arg(&cmd_str);
    command.stdout(Stdio::piped()).stderr(Stdio::piped());

    match command.spawn() {
        Ok(child) => match child.wait_with_output() {
            Ok(output) => {
                let stdout = String::from_utf8_lossy(&output.stdout).to_string();
                to_c(&stdout)
            }
            Err(_) => to_c(""),
        },
        Err(_) => to_c(""),
    }
}

/// Spawn a background process. Returns handle ID or -1 on failure.
#[no_mangle]
pub extern "C" fn forge_process_spawn(
    cmd: *const c_char,
    args_json: *const c_char,
    opts_json: *const c_char,
) -> i64 {
    let cmd_str = cstr(cmd);
    let args_str = cstr(args_json);
    let opts_str = cstr(opts_json);

    let mut command = Command::new(&cmd_str);
    command
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .stdin(Stdio::null());
    apply_opts(&mut command, &args_str, &opts_str);

    match command.spawn() {
        Ok(mut child) => {
            let id = NEXT_ID.fetch_add(1, Ordering::SeqCst);
            let reader = child.stdout.take().map(BufReader::new);
            let entry = ProcessEntry {
                child,
                stdout_reader: reader,
            };
            if let Ok(mut reg) = registry().lock() {
                reg.insert(id, entry);
            }
            id
        }
        Err(_) => -1,
    }
}

/// Kill a spawned process. Returns 1 on success, 0 on failure.
#[no_mangle]
pub extern "C" fn forge_process_kill(pid: i64) -> i8 {
    if let Ok(mut reg) = registry().lock() {
        if let Some(entry) = reg.get_mut(&pid) {
            if entry.child.kill().is_ok() {
                let _ = entry.child.wait();
                reg.remove(&pid);
                return 1;
            }
        }
    }
    0
}

/// Wait for a spawned process to complete. Returns JSON result.
#[no_mangle]
pub extern "C" fn forge_process_wait(pid: i64) -> *mut c_char {
    if let Ok(mut reg) = registry().lock() {
        if let Some(mut entry) = reg.remove(&pid) {
            // Read remaining stdout from the reader
            let stdout = if let Some(ref mut reader) = entry.stdout_reader {
                let mut buf = String::new();
                let _ = reader.read_to_string(&mut buf);
                buf
            } else {
                String::new()
            };

            // Read stderr
            let stderr = entry
                .child
                .stderr
                .take()
                .map(|s| {
                    let mut buf = String::new();
                    let _ = BufReader::new(s).read_to_string(&mut buf);
                    buf
                })
                .unwrap_or_default();

            match entry.child.wait() {
                Ok(status) => {
                    let code = status.code().unwrap_or(-1);
                    return to_c(&result_json(&stdout, &stderr, code));
                }
                Err(e) => {
                    return to_c(&result_json("", &format!("wait error: {}", e), -1));
                }
            }
        }
    }
    to_c(&result_json("", "process not found", -1))
}

/// Wait for a specific pattern in stdout, with timeout.
/// Returns 1 if found, 0 if timed out.
#[no_mangle]
pub extern "C" fn forge_process_wait_for_output(
    pid: i64,
    pattern: *const c_char,
    timeout_ms: i64,
) -> i8 {
    let pattern_str = cstr(pattern);
    let deadline = Instant::now() + Duration::from_millis(timeout_ms as u64);

    loop {
        if Instant::now() >= deadline {
            return 0;
        }

        if let Ok(mut reg) = registry().lock() {
            if let Some(entry) = reg.get_mut(&pid) {
                if let Some(ref mut reader) = entry.stdout_reader {
                    let mut line = String::new();
                    match reader.read_line(&mut line) {
                        Ok(0) => return 0, // EOF
                        Ok(_) => {
                            if line.contains(&pattern_str) {
                                return 1;
                            }
                            continue;
                        }
                        Err(_) => return 0,
                    }
                } else {
                    return 0;
                }
            } else {
                return 0;
            }
        }
    }
}

/// Read a single line from the process's stdout.
/// Returns the line, or "\0EOF" when stdout is closed.
#[no_mangle]
pub extern "C" fn forge_process_read_line(pid: i64) -> *mut c_char {
    if let Ok(mut reg) = registry().lock() {
        if let Some(entry) = reg.get_mut(&pid) {
            if let Some(ref mut reader) = entry.stdout_reader {
                let mut line = String::new();
                match reader.read_line(&mut line) {
                    Ok(0) => return to_c("\0EOF"),
                    Ok(_) => {
                        // Trim trailing newline
                        if line.ends_with('\n') {
                            line.pop();
                            if line.ends_with('\r') {
                                line.pop();
                            }
                        }
                        return to_c(&line);
                    }
                    Err(_) => return to_c("\0EOF"),
                }
            }
        }
    }
    to_c("\0EOF")
}

/// Check if a process is still running. Returns 1 if alive, 0 if not.
#[no_mangle]
pub extern "C" fn forge_process_is_alive(pid: i64) -> i8 {
    if let Ok(mut reg) = registry().lock() {
        if let Some(entry) = reg.get_mut(&pid) {
            match entry.child.try_wait() {
                Ok(Some(_)) => return 0, // Process has exited
                Ok(None) => return 1,    // Still running
                Err(_) => return 0,
            }
        }
    }
    0
}

/// Get an environment variable. Returns the value, or "\0NULL" if not set.
#[no_mangle]
pub extern "C" fn forge_process_env_get(key: *const c_char) -> *mut c_char {
    let key = cstr(key);
    match std::env::var(&key) {
        Ok(val) => to_c(&val),
        Err(_) => to_c("\0NULL"),
    }
}

/// Get command-line arguments as a JSON array of strings.
#[no_mangle]
pub extern "C" fn forge_process_args() -> *mut c_char {
    let args: Vec<String> = std::env::args().collect();
    let json = serde_json::to_string(&args).unwrap_or_else(|_| "[]".into());
    to_c(&json)
}

/// Exit the process with the given code.
#[no_mangle]
pub extern "C" fn forge_process_exit(code: i64) {
    std::process::exit(code as i32);
}

/// Execute a command with inherited stdin/stdout/stderr (passthrough).
/// Returns the exit code directly. No output capture — everything streams through.
#[no_mangle]
pub extern "C" fn forge_process_forward(
    cmd: *const c_char,
    args_json: *const c_char,
    opts_json: *const c_char,
) -> i64 {
    let cmd_str = cstr(cmd);
    let args_str = cstr(args_json);
    let opts_str = cstr(opts_json);

    let mut command = Command::new(&cmd_str);
    command
        .stdin(Stdio::inherit())
        .stdout(Stdio::inherit())
        .stderr(Stdio::inherit());
    apply_opts(&mut command, &args_str, &opts_str);

    match command.status() {
        Ok(status) => status.code().unwrap_or(-1) as i64,
        Err(_) => -1,
    }
}

/// Run a process with stdin piped from the input string. Returns JSON result.
#[no_mangle]
pub extern "C" fn forge_process_pipe(
    input: *const c_char,
    cmd: *const c_char,
    args_json: *const c_char,
) -> *mut c_char {
    let input_str = cstr(input);
    let cmd_str = cstr(cmd);
    let args_str = cstr(args_json);

    let mut command = Command::new(&cmd_str);
    command
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .stderr(Stdio::piped());
    apply_opts(&mut command, &args_str, "");

    match command.spawn() {
        Ok(mut child) => {
            // Write input to stdin
            if let Some(mut stdin) = child.stdin.take() {
                let _ = stdin.write_all(input_str.as_bytes());
                // stdin is dropped here, closing the pipe
            }

            match child.wait_with_output() {
                Ok(output) => {
                    let stdout = String::from_utf8_lossy(&output.stdout).to_string();
                    let stderr = String::from_utf8_lossy(&output.stderr).to_string();
                    let code = output.status.code().unwrap_or(-1);
                    to_c(&result_json(&stdout, &stderr, code))
                }
                Err(e) => to_c(&result_json("", &format!("wait error: {}", e), -1)),
            }
        }
        Err(e) => to_c(&result_json("", &format!("spawn error: {}", e), -1)),
    }
}

/// Return the directory containing the current executable.
/// Used by the CLI to find sibling binaries (e.g., `forgec` next to `forge`).
#[no_mangle]
pub extern "C" fn forge_process_self_dir() -> *mut c_char {
    match std::env::current_exe() {
        Ok(exe) => {
            if let Some(dir) = exe.parent() {
                to_c(&dir.to_string_lossy())
            } else {
                to_c(".")
            }
        }
        Err(_) => to_c("."),
    }
}
