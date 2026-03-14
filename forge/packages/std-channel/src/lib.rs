use std::collections::HashMap;
use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use std::sync::atomic::{AtomicBool, AtomicI64, Ordering};
use std::sync::{Mutex, OnceLock};
use std::time::Duration;

use crossbeam_channel::{Receiver, Select, Sender};

// ── Helpers ──

fn cstr(ptr: *const c_char) -> String {
    unsafe { CStr::from_ptr(ptr) }.to_str().unwrap_or("").to_string()
}

fn to_c(s: &str) -> *mut c_char {
    CString::new(s).unwrap_or_default().into_raw()
}

// ── Channel registry ──

struct Channel {
    sender: Option<Sender<String>>,
    receiver: Receiver<String>,
    capacity: i64,
    closed: AtomicBool,
}

static NEXT_ID: AtomicI64 = AtomicI64::new(1);

fn registry() -> &'static Mutex<HashMap<i64, Channel>> {
    static REGISTRY: OnceLock<Mutex<HashMap<i64, Channel>>> = OnceLock::new();
    REGISTRY.get_or_init(|| Mutex::new(HashMap::new()))
}

// ── Channel operations ──

#[no_mangle]
pub extern "C" fn forge_channel_create(capacity: i64) -> i64 {
    let (sender, receiver) = if capacity <= 0 {
        crossbeam_channel::unbounded()
    } else {
        crossbeam_channel::bounded(capacity as usize)
    };

    let id = NEXT_ID.fetch_add(1, Ordering::SeqCst);
    let channel = Channel {
        sender: Some(sender),
        receiver,
        capacity: if capacity <= 0 { 0 } else { capacity },
        closed: AtomicBool::new(false),
    };

    registry().lock().unwrap().insert(id, channel);
    id
}

#[no_mangle]
pub extern "C" fn forge_channel_send(id: i64, data: *const c_char) -> i8 {
    let msg = cstr(data);
    let reg = registry().lock().unwrap();
    if let Some(ch) = reg.get(&id) {
        if ch.closed.load(Ordering::SeqCst) {
            eprintln!("PANIC: send on closed channel {}", id);
            std::process::abort();
        }
        if let Some(ref sender) = ch.sender {
            match sender.send(msg) {
                Ok(_) => 1,
                Err(_) => {
                    eprintln!("PANIC: send on closed channel {}", id);
                    std::process::abort();
                }
            }
        } else {
            eprintln!("PANIC: send on closed channel {}", id);
            std::process::abort();
        }
    } else {
        eprintln!("PANIC: send on unknown channel {}", id);
        std::process::abort();
    }
}

#[no_mangle]
pub extern "C" fn forge_channel_receive(id: i64) -> *mut c_char {
    let receiver = {
        let reg = registry().lock().unwrap();
        match reg.get(&id) {
            Some(ch) => ch.receiver.clone(),
            None => return to_c("\0CLOSED"),
        }
    };

    match receiver.recv() {
        Ok(msg) => to_c(&msg),
        Err(_) => to_c("\0CLOSED"),
    }
}

#[no_mangle]
pub extern "C" fn forge_channel_try_receive(id: i64, timeout_ms: i64) -> *mut c_char {
    let receiver = {
        let reg = registry().lock().unwrap();
        match reg.get(&id) {
            Some(ch) => ch.receiver.clone(),
            None => return to_c("\0CLOSED"),
        }
    };

    let timeout = Duration::from_millis(timeout_ms as u64);
    match receiver.recv_timeout(timeout) {
        Ok(msg) => to_c(&msg),
        Err(crossbeam_channel::RecvTimeoutError::Timeout) => to_c("\0TIMEOUT"),
        Err(crossbeam_channel::RecvTimeoutError::Disconnected) => to_c("\0CLOSED"),
    }
}

#[no_mangle]
pub extern "C" fn forge_channel_close(id: i64) {
    let mut reg = registry().lock().unwrap();
    if let Some(ch) = reg.get_mut(&id) {
        ch.closed.store(true, Ordering::SeqCst);
        // Drop the sender so receivers get disconnected
        ch.sender = None;
    }
}

#[no_mangle]
pub extern "C" fn forge_channel_is_closed(id: i64) -> i8 {
    let reg = registry().lock().unwrap();
    match reg.get(&id) {
        Some(ch) => {
            if ch.closed.load(Ordering::SeqCst) { 1 } else { 0 }
        }
        None => 1,
    }
}

#[no_mangle]
pub extern "C" fn forge_channel_length(id: i64) -> i64 {
    let reg = registry().lock().unwrap();
    match reg.get(&id) {
        Some(ch) => ch.receiver.len() as i64,
        None => 0,
    }
}

#[no_mangle]
pub extern "C" fn forge_channel_capacity(id: i64) -> i64 {
    let reg = registry().lock().unwrap();
    match reg.get(&id) {
        Some(ch) => ch.capacity,
        None => 0,
    }
}

#[no_mangle]
pub extern "C" fn forge_channel_is_empty(id: i64) -> i8 {
    let reg = registry().lock().unwrap();
    match reg.get(&id) {
        Some(ch) => if ch.receiver.is_empty() { 1 } else { 0 },
        None => 1,
    }
}

#[no_mangle]
pub extern "C" fn forge_channel_is_full(id: i64) -> i8 {
    let reg = registry().lock().unwrap();
    match reg.get(&id) {
        Some(ch) => if ch.receiver.is_full() { 1 } else { 0 },
        None => 0,
    }
}

#[no_mangle]
pub extern "C" fn forge_channel_drain(id: i64) -> *mut c_char {
    let receiver = {
        let reg = registry().lock().unwrap();
        match reg.get(&id) {
            Some(ch) => ch.receiver.clone(),
            None => return to_c("[]"),
        }
    };

    let mut messages: Vec<String> = Vec::new();
    loop {
        match receiver.try_recv() {
            Ok(msg) => messages.push(msg),
            Err(_) => break,
        }
    }

    let json_arr: Vec<String> = messages
        .iter()
        .map(|m| {
            format!(
                "\"{}\"",
                m.replace('\\', "\\\\").replace('"', "\\\"")
            )
        })
        .collect();
    let json = format!("[{}]", json_arr.join(","));
    to_c(&json)
}

#[no_mangle]
pub extern "C" fn forge_channel_select(
    channel_ids_json: *const c_char,
    timeout_ms: i64,
) -> *mut c_char {
    let json_str = cstr(channel_ids_json);

    // Parse the JSON array of channel IDs
    let ids: Vec<i64> = match serde_json::from_str(&json_str) {
        Ok(v) => v,
        Err(_) => return to_c("{\"index\":-1}"),
    };

    if ids.is_empty() {
        return to_c("{\"index\":-1}");
    }

    // Collect receivers (clone them so we can drop the lock)
    let receivers: Vec<Receiver<String>> = {
        let reg = registry().lock().unwrap();
        let mut recvs = Vec::new();
        for &id in &ids {
            match reg.get(&id) {
                Some(ch) => recvs.push(ch.receiver.clone()),
                None => return to_c("{\"index\":-1}"),
            }
        }
        recvs
    };

    // Build a crossbeam Select
    let mut sel = Select::new();
    for recv in &receivers {
        sel.recv(recv);
    }

    let result = if timeout_ms <= 0 {
        // Block indefinitely
        let oper = sel.select();
        let index = oper.index();
        match oper.recv(&receivers[index]) {
            Ok(msg) => {
                let escaped = msg.replace('\\', "\\\\").replace('"', "\\\"");
                format!("{{\"index\":{},\"data\":\"{}\"}}", index, escaped)
            }
            Err(_) => "{\"index\":-1}".to_string(),
        }
    } else {
        let timeout = Duration::from_millis(timeout_ms as u64);
        match sel.select_timeout(timeout) {
            Ok(oper) => {
                let index = oper.index();
                match oper.recv(&receivers[index]) {
                    Ok(msg) => {
                        let escaped = msg.replace('\\', "\\\\").replace('"', "\\\"");
                        format!("{{\"index\":{},\"data\":\"{}\"}}", index, escaped)
                    }
                    Err(_) => "{\"index\":-1}".to_string(),
                }
            }
            Err(_) => "{\"index\":-1}".to_string(),
        }
    };

    to_c(&result)
}

#[no_mangle]
pub extern "C" fn forge_channel_tick_create(interval_ms: i64) -> i64 {
    let (sender, receiver) = crossbeam_channel::unbounded();

    let id = NEXT_ID.fetch_add(1, Ordering::SeqCst);
    let channel = Channel {
        sender: Some(sender.clone()),
        receiver,
        capacity: 0,
        closed: AtomicBool::new(false),
    };

    registry().lock().unwrap().insert(id, channel);

    // Spawn a background thread that sends "tick" at the given interval
    let interval = Duration::from_millis(interval_ms as u64);
    std::thread::spawn(move || loop {
        std::thread::sleep(interval);
        if sender.send("tick".to_string()).is_err() {
            // Receiver dropped / channel closed
            break;
        }
    });

    id
}
