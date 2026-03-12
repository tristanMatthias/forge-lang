use std::ffi::{CStr, CString};
use std::fs;
use std::os::raw::c_char;
use std::path::Path;
use std::time::UNIX_EPOCH;

// ── Helpers ──

fn cstr(ptr: *const c_char) -> String {
    unsafe { CStr::from_ptr(ptr) }.to_str().unwrap_or("").to_string()
}

fn to_c(s: &str) -> *mut c_char {
    CString::new(s).unwrap_or_default().into_raw()
}

fn err_c() -> *mut c_char {
    to_c("\0ERR")
}

// ── File operations ──

#[no_mangle]
pub extern "C" fn forge_fs_read(path: *const c_char) -> *mut c_char {
    let path = cstr(path);
    match fs::read_to_string(&path) {
        Ok(content) => to_c(&content),
        Err(_) => err_c(),
    }
}

#[no_mangle]
pub extern "C" fn forge_fs_write(path: *const c_char, content: *const c_char) -> i8 {
    let path = cstr(path);
    let content = cstr(content);
    if fs::write(&path, &content).is_ok() { 1 } else { 0 }
}

#[no_mangle]
pub extern "C" fn forge_fs_append(path: *const c_char, content: *const c_char) -> i8 {
    use std::io::Write;
    let path = cstr(path);
    let content = cstr(content);
    match fs::OpenOptions::new().append(true).create(true).open(&path) {
        Ok(mut f) => if f.write_all(content.as_bytes()).is_ok() { 1 } else { 0 },
        Err(_) => 0,
    }
}

#[no_mangle]
pub extern "C" fn forge_fs_exists(path: *const c_char) -> i8 {
    let path = cstr(path);
    if Path::new(&path).exists() { 1 } else { 0 }
}

#[no_mangle]
pub extern "C" fn forge_fs_is_file(path: *const c_char) -> i8 {
    let path = cstr(path);
    if Path::new(&path).is_file() { 1 } else { 0 }
}

#[no_mangle]
pub extern "C" fn forge_fs_is_dir(path: *const c_char) -> i8 {
    let path = cstr(path);
    if Path::new(&path).is_dir() { 1 } else { 0 }
}

#[no_mangle]
pub extern "C" fn forge_fs_mkdir(path: *const c_char, recursive: i8) -> i8 {
    let path = cstr(path);
    let result = if recursive != 0 {
        fs::create_dir_all(&path)
    } else {
        fs::create_dir(&path)
    };
    if result.is_ok() { 1 } else { 0 }
}

#[no_mangle]
pub extern "C" fn forge_fs_remove(path: *const c_char) -> i8 {
    let path = cstr(path);
    if fs::remove_file(&path).is_ok() { 1 } else { 0 }
}

#[no_mangle]
pub extern "C" fn forge_fs_remove_dir(path: *const c_char, recursive: i8) -> i8 {
    let path = cstr(path);
    let result = if recursive != 0 {
        fs::remove_dir_all(&path)
    } else {
        fs::remove_dir(&path)
    };
    if result.is_ok() { 1 } else { 0 }
}

#[no_mangle]
pub extern "C" fn forge_fs_copy(from: *const c_char, to: *const c_char) -> i8 {
    let from = cstr(from);
    let to = cstr(to);
    if fs::copy(&from, &to).is_ok() { 1 } else { 0 }
}

#[no_mangle]
pub extern "C" fn forge_fs_rename(from: *const c_char, to: *const c_char) -> i8 {
    let from = cstr(from);
    let to = cstr(to);
    if fs::rename(&from, &to).is_ok() { 1 } else { 0 }
}

#[no_mangle]
pub extern "C" fn forge_fs_list(path: *const c_char) -> *mut c_char {
    let path = cstr(path);
    match fs::read_dir(&path) {
        Ok(entries) => {
            let names: Vec<String> = entries
                .filter_map(|e| e.ok())
                .map(|e| e.file_name().to_string_lossy().to_string())
                .collect();
            let json = format!("[{}]", names.iter()
                .map(|n| format!("\"{}\"", n.replace('\\', "\\\\").replace('"', "\\\"")))
                .collect::<Vec<_>>()
                .join(","));
            to_c(&json)
        }
        Err(_) => err_c(),
    }
}

#[no_mangle]
pub extern "C" fn forge_fs_size(path: *const c_char) -> i64 {
    let path = cstr(path);
    fs::metadata(&path).map(|m| m.len() as i64).unwrap_or(-1)
}

#[no_mangle]
pub extern "C" fn forge_fs_modified(path: *const c_char) -> i64 {
    let path = cstr(path);
    fs::metadata(&path)
        .and_then(|m| m.modified())
        .map(|t| t.duration_since(UNIX_EPOCH).unwrap_or_default().as_secs() as i64)
        .unwrap_or(-1)
}

#[no_mangle]
pub extern "C" fn forge_fs_cwd() -> *mut c_char {
    match std::env::current_dir() {
        Ok(p) => to_c(&p.to_string_lossy()),
        Err(_) => to_c("."),
    }
}

#[no_mangle]
pub extern "C" fn forge_fs_join(a: *const c_char, b: *const c_char) -> *mut c_char {
    let a = cstr(a);
    let b = cstr(b);
    let joined = Path::new(&a).join(&b);
    to_c(&joined.to_string_lossy())
}

#[no_mangle]
pub extern "C" fn forge_fs_parent(path: *const c_char) -> *mut c_char {
    let path = cstr(path);
    let parent = Path::new(&path).parent().unwrap_or(Path::new(""));
    to_c(&parent.to_string_lossy())
}

#[no_mangle]
pub extern "C" fn forge_fs_filename(path: *const c_char) -> *mut c_char {
    let path = cstr(path);
    let name = Path::new(&path).file_name().unwrap_or_default();
    to_c(&name.to_string_lossy())
}

#[no_mangle]
pub extern "C" fn forge_fs_extension(path: *const c_char) -> *mut c_char {
    let path = cstr(path);
    let ext = Path::new(&path).extension().unwrap_or_default();
    to_c(&ext.to_string_lossy())
}

#[no_mangle]
pub extern "C" fn forge_fs_glob(pattern: *const c_char) -> *mut c_char {
    let pattern = cstr(pattern);
    match glob::glob(&pattern) {
        Ok(paths) => {
            let matches: Vec<String> = paths
                .filter_map(|p| p.ok())
                .map(|p| p.to_string_lossy().to_string())
                .collect();
            let json = format!("[{}]", matches.iter()
                .map(|m| format!("\"{}\"", m.replace('\\', "\\\\").replace('"', "\\\"")))
                .collect::<Vec<_>>()
                .join(","));
            to_c(&json)
        }
        Err(_) => err_c(),
    }
}
