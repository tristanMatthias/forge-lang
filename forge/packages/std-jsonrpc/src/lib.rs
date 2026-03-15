use std::collections::HashMap;
use std::ffi::{CStr, CString};
use std::io::{self, BufRead, Write as IoWrite};
use std::os::raw::c_char;
use std::sync::Mutex;

// ── Types ──────────────────────────────────────────────────────────

/// Handler: takes (params_json_cstr, id_cstr), returns nothing.
/// The handler calls forge_jsonrpc_respond() internally to send the response.
type Handler = extern "C" fn(*const c_char, *const c_char);

struct RpcState {
    handlers: HashMap<String, Handler>,
}

static STATE: Mutex<Option<RpcState>> = Mutex::new(None);

// ── Helpers ────────────────────────────────────────────────────────

fn cstr(ptr: *const c_char) -> String {
    if ptr.is_null() { return String::new(); }
    unsafe { CStr::from_ptr(ptr) }.to_str().unwrap_or("").to_string()
}

fn to_c(s: &str) -> *mut c_char {
    CString::new(s).unwrap_or_default().into_raw()
}

// ── Content-Length Transport ───────────────────────────────────────

fn read_message(reader: &mut impl BufRead) -> io::Result<Option<String>> {
    let mut content_length: Option<usize> = None;
    loop {
        let mut line = String::new();
        if reader.read_line(&mut line)? == 0 { return Ok(None); }
        let trimmed = line.trim();
        if trimmed.is_empty() { break; }
        if let Some(len_str) = trimmed.strip_prefix("Content-Length: ") {
            if let Ok(len) = len_str.parse::<usize>() {
                content_length = Some(len);
            }
        }
    }
    match content_length {
        Some(len) => {
            let mut body = vec![0u8; len];
            reader.read_exact(&mut body)?;
            Ok(Some(String::from_utf8_lossy(&body).to_string()))
        }
        None => Ok(None),
    }
}

fn write_message(content: &str) {
    let mut stdout = io::stdout().lock();
    let _ = write!(stdout, "Content-Length: {}\r\n\r\n{}", content.len(), content);
    let _ = stdout.flush();
}

// ── Public API ─────────────────────────────────────────────────────

#[no_mangle]
pub extern "C" fn forge_jsonrpc_init() {
    let mut guard = STATE.lock().unwrap();
    *guard = Some(RpcState { handlers: HashMap::new() });
}

/// Register a handler for a JSON-RPC method.
/// Handler signature: fn(params_json: *const c_char, id_json: *const c_char)
#[no_mangle]
pub extern "C" fn forge_jsonrpc_on(method: *const c_char, handler: Handler) {
    let mut guard = STATE.lock().unwrap();
    let state = guard.as_mut().expect("forge_jsonrpc_init not called");
    state.handlers.insert(cstr(method), handler);
}

/// No-op — id is passed directly to the handler now
#[no_mangle]
pub extern "C" fn forge_jsonrpc_set_id(_id_ptr: *const c_char) {
    // Reserved for future use
}

/// Send a JSON-RPC response
#[no_mangle]
pub extern "C" fn forge_jsonrpc_respond(id_str: *const c_char, result_json: *const c_char) {
    let id = cstr(id_str);
    let result = cstr(result_json);
    // If id is empty, it's a notification response — don't send
    if id.is_empty() { return; }
    let msg = format!(
        r#"{{"jsonrpc":"2.0","id":{},"result":{}}}"#,
        id, result
    );
    write_message(&msg);
}

/// Send a JSON-RPC error response
#[no_mangle]
pub extern "C" fn forge_jsonrpc_error(id_str: *const c_char, code: i64, message: *const c_char) {
    let id = cstr(id_str);
    let msg_text = cstr(message);
    let escaped = msg_text.replace('\\', "\\\\").replace('"', "\\\"");
    let msg = format!(
        r#"{{"jsonrpc":"2.0","id":{},"error":{{"code":{},"message":"{}"}}}}"#,
        id, code, escaped
    );
    write_message(&msg);
}

/// Send a JSON-RPC notification (no id)
#[no_mangle]
pub extern "C" fn forge_jsonrpc_notify(method: *const c_char, params_json: *const c_char) {
    let method = cstr(method);
    let params = cstr(params_json);
    let msg = format!(
        r#"{{"jsonrpc":"2.0","method":"{}","params":{}}}"#,
        method, params
    );
    write_message(&msg);
}

/// Write to stderr (for logging without corrupting the JSON-RPC stream)
#[no_mangle]
pub extern "C" fn forge_jsonrpc_log(message: *const c_char) {
    let msg = cstr(message);
    eprintln!("[jsonrpc] {}", msg);
}

/// Main event loop: read stdin, dispatch to handlers
#[no_mangle]
pub extern "C" fn forge_jsonrpc_serve() {
    // Snapshot handlers so we can release the lock
    let handlers: HashMap<String, Handler> = {
        let guard = STATE.lock().unwrap();
        let state = guard.as_ref().expect("forge_jsonrpc_init not called");
        state.handlers.clone()
    };

    let stdin = io::stdin();
    let mut reader = io::BufReader::new(stdin.lock());

    eprintln!("[jsonrpc] Server starting");

    loop {
        let raw = match read_message(&mut reader) {
            Ok(Some(msg)) => msg,
            Ok(None) | Err(_) => break,
        };

        // Quick JSON parse to extract method, id, params
        let parsed: serde_json::Value = match serde_json::from_str(&raw) {
            Ok(v) => v,
            Err(_) => continue,
        };

        let method = match parsed.get("method").and_then(|m| m.as_str()) {
            Some(m) => m.to_string(),
            None => continue,
        };

        let id = parsed.get("id").cloned().unwrap_or(serde_json::Value::Null);
        let id_str = if id.is_null() { String::new() } else { id.to_string() };
        let params = parsed.get("params").unwrap_or(&serde_json::json!({})).to_string();

        if method == "exit" { break; }

        if let Some(handler) = handlers.get(&method) {
            let params_c = to_c(&params);
            let id_c = to_c(&id_str);
            handler(params_c, id_c);
            unsafe {
                drop(CString::from_raw(params_c));
                drop(CString::from_raw(id_c));
            }
        } else if !id.is_null() {
            // Unhandled request — method not found
            let escaped = method.replace('\\', "\\\\").replace('"', "\\\"");
            let msg = format!(
                r#"{{"jsonrpc":"2.0","id":{},"error":{{"code":-32601,"message":"Method not found: {}"}}}}"#,
                id_str, escaped
            );
            write_message(&msg);
        }
    }

    eprintln!("[jsonrpc] Server stopped");
}
