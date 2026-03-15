use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use std::path::Path;

use sha2::{Sha256, Digest};
use hmac::{Hmac, Mac};

type HmacSha256 = Hmac<Sha256>;

// ── Helpers ──

fn cstr(ptr: *const c_char) -> String {
    if ptr.is_null() {
        return String::new();
    }
    unsafe { CStr::from_ptr(ptr) }.to_str().unwrap_or("").to_string()
}

fn to_c(s: &str) -> *mut c_char {
    CString::new(s).unwrap_or_default().into_raw()
}

// ── Crypto operations ──

#[no_mangle]
pub extern "C" fn forge_crypto_sha256(data: *const c_char) -> *mut c_char {
    let data = cstr(data);
    let mut hasher = Sha256::new();
    hasher.update(data.as_bytes());
    to_c(&hex::encode(hasher.finalize()))
}

#[no_mangle]
pub extern "C" fn forge_crypto_sha256_file(path: *const c_char) -> *mut c_char {
    let path = cstr(path);
    match std::fs::read(&path) {
        Ok(contents) => {
            let mut hasher = Sha256::new();
            hasher.update(&contents);
            to_c(&hex::encode(hasher.finalize()))
        }
        Err(_) => to_c(""),
    }
}

#[no_mangle]
pub extern "C" fn forge_crypto_sha256_dir(path: *const c_char) -> *mut c_char {
    let path = cstr(path);
    match hash_directory(Path::new(&path)) {
        Ok(hash) => to_c(&hash),
        Err(_) => to_c(""),
    }
}

#[no_mangle]
pub extern "C" fn forge_crypto_hmac_sha256(data: *const c_char, key: *const c_char) -> *mut c_char {
    let data = cstr(data);
    let key = cstr(key);
    let mut mac = HmacSha256::new_from_slice(key.as_bytes())
        .expect("HMAC can take key of any size");
    mac.update(data.as_bytes());
    to_c(&hex::encode(mac.finalize().into_bytes()))
}

#[no_mangle]
pub extern "C" fn forge_crypto_random_bytes(count: i64) -> *mut c_char {
    let count = if count < 0 { 0 } else { count as usize };
    let mut buf = vec![0u8; count];
    getrandom::getrandom(&mut buf).unwrap_or(());
    to_c(&hex::encode(buf))
}

// ── Directory hashing ──

fn hash_directory(path: &Path) -> Result<String, std::io::Error> {
    let mut entries = Vec::new();
    collect_files(path, path, &mut entries)?;
    entries.sort(); // deterministic ordering

    let mut hasher = Sha256::new();
    for (rel_path, contents) in &entries {
        hasher.update(rel_path.as_bytes());
        hasher.update(b"\0");
        hasher.update(contents);
    }
    Ok(hex::encode(hasher.finalize()))
}

fn collect_files(base: &Path, current: &Path, entries: &mut Vec<(String, Vec<u8>)>) -> Result<(), std::io::Error> {
    for entry in std::fs::read_dir(current)? {
        let entry = entry?;
        let path = entry.path();
        if path.is_dir() {
            collect_files(base, &path, entries)?;
        } else {
            let rel = path.strip_prefix(base).unwrap().to_string_lossy().to_string();
            let contents = std::fs::read(&path)?;
            entries.push((rel, contents));
        }
    }
    Ok(())
}
