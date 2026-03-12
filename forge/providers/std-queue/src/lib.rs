use std::collections::{HashMap, VecDeque};
use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::{Arc, LazyLock, Mutex};
use std::thread;
use std::time::Duration;

static QUEUES: LazyLock<Mutex<HashMap<String, VecDeque<String>>>> =
    LazyLock::new(|| Mutex::new(HashMap::new()));

struct WorkerEntry {
    queue_name: String,
    stop_flag: Arc<AtomicBool>,
    handle: Option<thread::JoinHandle<()>>,
}

static WORKERS: LazyLock<Mutex<HashMap<String, WorkerEntry>>> =
    LazyLock::new(|| Mutex::new(HashMap::new()));

#[no_mangle]
pub extern "C" fn forge_queue_create(name: *const c_char) {
    let name = unsafe { CStr::from_ptr(name) }
        .to_str()
        .unwrap()
        .to_string();
    let mut queues = QUEUES.lock().unwrap();
    queues.entry(name).or_insert_with(VecDeque::new);
}

#[no_mangle]
pub extern "C" fn forge_queue_send(name: *const c_char, payload: *const c_char) {
    let name = unsafe { CStr::from_ptr(name) }.to_str().unwrap();
    let payload = unsafe { CStr::from_ptr(payload) }
        .to_str()
        .unwrap()
        .to_string();
    let mut queues = QUEUES.lock().unwrap();
    if let Some(q) = queues.get_mut(name) {
        q.push_back(payload);
    }
}

#[no_mangle]
pub extern "C" fn forge_queue_receive(name: *const c_char) -> *const c_char {
    let name = unsafe { CStr::from_ptr(name) }.to_str().unwrap();
    let mut queues = QUEUES.lock().unwrap();
    if let Some(q) = queues.get_mut(name) {
        if let Some(msg) = q.pop_front() {
            return CString::new(msg).unwrap().into_raw();
        }
    }
    CString::new("").unwrap().into_raw()
}

#[no_mangle]
pub extern "C" fn forge_queue_depth(name: *const c_char) -> i64 {
    let name = unsafe { CStr::from_ptr(name) }.to_str().unwrap();
    let queues = QUEUES.lock().unwrap();
    if let Some(q) = queues.get(name) {
        q.len() as i64
    } else {
        0
    }
}

#[no_mangle]
pub extern "C" fn forge_queue_drain(name: *const c_char) {
    let name = unsafe { CStr::from_ptr(name) }.to_str().unwrap();
    let mut queues = QUEUES.lock().unwrap();
    if let Some(q) = queues.get_mut(name) {
        q.clear();
    }
}

#[no_mangle]
pub extern "C" fn forge_worker_create(name: *const c_char, queue_name: *const c_char) {
    let name = unsafe { CStr::from_ptr(name) }
        .to_str()
        .unwrap()
        .to_string();
    let queue_name = unsafe { CStr::from_ptr(queue_name) }
        .to_str()
        .unwrap()
        .to_string();
    let mut workers = WORKERS.lock().unwrap();
    workers.insert(
        name,
        WorkerEntry {
            queue_name,
            stop_flag: Arc::new(AtomicBool::new(false)),
            handle: None,
        },
    );
}

#[no_mangle]
pub extern "C" fn forge_worker_start(
    name: *const c_char,
    handler: extern "C" fn(*const c_char),
) {
    let name = unsafe { CStr::from_ptr(name) }
        .to_str()
        .unwrap()
        .to_string();

    let mut workers = WORKERS.lock().unwrap();
    if let Some(entry) = workers.get_mut(&name) {
        let queue_name = entry.queue_name.clone();
        let stop_flag = entry.stop_flag.clone();
        stop_flag.store(false, Ordering::SeqCst);

        let handle = thread::spawn(move || {
            loop {
                if stop_flag.load(Ordering::SeqCst) {
                    break;
                }
                let msg = {
                    let mut queues = QUEUES.lock().unwrap();
                    queues.get_mut(&queue_name).and_then(|q| q.pop_front())
                };
                match msg {
                    Some(m) => {
                        let cs = CString::new(m).unwrap();
                        handler(cs.as_ptr());
                    }
                    None => {
                        // No messages, sleep briefly then check again
                        thread::sleep(Duration::from_millis(5));
                    }
                }
            }
        });
        entry.handle = Some(handle);
    }
}

#[no_mangle]
pub extern "C" fn forge_worker_stop(name: *const c_char) {
    let name = unsafe { CStr::from_ptr(name) }
        .to_str()
        .unwrap()
        .to_string();

    let handle = {
        let mut workers = WORKERS.lock().unwrap();
        if let Some(entry) = workers.get_mut(&name) {
            entry.stop_flag.store(true, Ordering::SeqCst);
            entry.handle.take()
        } else {
            None
        }
    };
    if let Some(h) = handle {
        let _ = h.join();
    }
}
