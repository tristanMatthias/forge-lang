use std::collections::HashMap;
use std::ffi::CStr;
use std::os::raw::c_char;
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::{Arc, LazyLock, Mutex};
use std::thread;
use std::time::Duration;

struct ScheduleEntry {
    interval_ms: i64,
    stop_flag: Arc<AtomicBool>,
    handle: Option<thread::JoinHandle<()>>,
}

static SCHEDULES: LazyLock<Mutex<HashMap<String, ScheduleEntry>>> =
    LazyLock::new(|| Mutex::new(HashMap::new()));

#[no_mangle]
pub extern "C" fn forge_cron_create(name: *const c_char) {
    let name = unsafe { CStr::from_ptr(name) }
        .to_str()
        .unwrap()
        .to_string();
    let mut schedules = SCHEDULES.lock().unwrap();
    schedules.insert(
        name,
        ScheduleEntry {
            interval_ms: 1000,
            stop_flag: Arc::new(AtomicBool::new(false)),
            handle: None,
        },
    );
}

#[no_mangle]
pub extern "C" fn forge_cron_set_interval(name: *const c_char, ms: i64) {
    let name = unsafe { CStr::from_ptr(name) }.to_str().unwrap();
    let mut schedules = SCHEDULES.lock().unwrap();
    if let Some(entry) = schedules.get_mut(name) {
        entry.interval_ms = ms;
    }
}

#[no_mangle]
pub extern "C" fn forge_cron_start_with_handler(
    name: *const c_char,
    handler: extern "C" fn() -> i64,
) {
    let name = unsafe { CStr::from_ptr(name) }
        .to_str()
        .unwrap()
        .to_string();

    let mut schedules = SCHEDULES.lock().unwrap();
    if let Some(entry) = schedules.get_mut(&name) {
        let interval = entry.interval_ms;
        let stop_flag = entry.stop_flag.clone();
        stop_flag.store(false, Ordering::SeqCst);

        let handle = thread::spawn(move || {
            loop {
                thread::sleep(Duration::from_millis(interval as u64));
                if stop_flag.load(Ordering::SeqCst) {
                    break;
                }
                handler();
            }
        });
        entry.handle = Some(handle);
    }
}

#[no_mangle]
pub extern "C" fn forge_cron_stop(name: *const c_char) {
    let name = unsafe { CStr::from_ptr(name) }
        .to_str()
        .unwrap()
        .to_string();

    let handle = {
        let mut schedules = SCHEDULES.lock().unwrap();
        if let Some(entry) = schedules.get_mut(&name) {
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
