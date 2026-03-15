use std::ffi::{CStr, CString};
use std::fs::File;
use std::os::raw::c_char;
use std::path::Path;

use flate2::read::GzDecoder;
use flate2::write::GzEncoder;
use flate2::Compression;
use tar::{Archive, Builder};

// ── Helpers ──

fn cstr(ptr: *const c_char) -> String {
    if ptr.is_null() {
        return String::new();
    }
    unsafe { CStr::from_ptr(ptr) }
        .to_str()
        .unwrap_or("")
        .to_string()
}

fn to_c(s: &str) -> *mut c_char {
    CString::new(s).unwrap_or_default().into_raw()
}

// ── Archive operations ──

#[no_mangle]
pub extern "C" fn forge_archive_create(
    dir_path: *const c_char,
    output_path: *const c_char,
) -> *mut c_char {
    let dir_path = cstr(dir_path);
    let output_path = cstr(output_path);

    match create_tar_gz(&dir_path, &output_path) {
        Ok(()) => to_c("ok"),
        Err(e) => to_c(&e),
    }
}

fn create_tar_gz(dir_path: &str, output_path: &str) -> Result<(), String> {
    let file = File::create(output_path).map_err(|e| format!("create output: {}", e))?;
    let enc = GzEncoder::new(file, Compression::default());
    let mut builder = Builder::new(enc);

    let base = Path::new(dir_path);
    add_dir_recursive(&mut builder, base, base)?;

    let enc = builder.into_inner().map_err(|e| format!("finish tar: {}", e))?;
    enc.finish().map_err(|e| format!("finish gzip: {}", e))?;
    Ok(())
}

fn add_dir_recursive(
    builder: &mut Builder<GzEncoder<File>>,
    path: &Path,
    base: &Path,
) -> Result<(), String> {
    let entries = std::fs::read_dir(path).map_err(|e| format!("read dir: {}", e))?;
    for entry in entries {
        let entry = entry.map_err(|e| format!("dir entry: {}", e))?;
        let full = entry.path();
        let rel = full.strip_prefix(base).map_err(|e| format!("strip prefix: {}", e))?;

        if full.is_dir() {
            add_dir_recursive(builder, &full, base)?;
        } else {
            builder
                .append_path_with_name(&full, rel)
                .map_err(|e| format!("add file {}: {}", rel.display(), e))?;
        }
    }
    Ok(())
}

#[no_mangle]
pub extern "C" fn forge_archive_extract(
    archive_path: *const c_char,
    output_dir: *const c_char,
) -> *mut c_char {
    let archive_path = cstr(archive_path);
    let output_dir = cstr(output_dir);

    match extract_tar_gz(&archive_path, &output_dir) {
        Ok(()) => to_c("ok"),
        Err(e) => to_c(&e),
    }
}

fn extract_tar_gz(archive_path: &str, output_dir: &str) -> Result<(), String> {
    // Create output directory if needed
    std::fs::create_dir_all(output_dir).map_err(|e| format!("create dir: {}", e))?;

    let file = File::open(archive_path).map_err(|e| format!("open archive: {}", e))?;
    let dec = GzDecoder::new(file);
    let mut archive = Archive::new(dec);
    archive
        .unpack(output_dir)
        .map_err(|e| format!("unpack: {}", e))?;
    Ok(())
}

#[no_mangle]
pub extern "C" fn forge_archive_list(archive_path: *const c_char) -> *mut c_char {
    let archive_path = cstr(archive_path);

    match list_tar_gz(&archive_path) {
        Ok(json) => to_c(&json),
        Err(e) => to_c(&e),
    }
}

fn list_tar_gz(archive_path: &str) -> Result<String, String> {
    let file = File::open(archive_path).map_err(|e| format!("open archive: {}", e))?;
    let dec = GzDecoder::new(file);
    let mut archive = Archive::new(dec);

    let mut entries_json = Vec::new();
    let entries = archive.entries().map_err(|e| format!("read entries: {}", e))?;

    for entry in entries {
        let entry = entry.map_err(|e| format!("read entry: {}", e))?;
        let path = entry
            .path()
            .map_err(|e| format!("entry path: {}", e))?
            .to_string_lossy()
            .to_string();
        let size = entry.size();
        let is_dir = entry.header().entry_type().is_dir();

        let path_escaped = path.replace('\\', "\\\\").replace('"', "\\\"");
        entries_json.push(format!(
            "{{\"path\":\"{}\",\"size\":{},\"is_dir\":{}}}",
            path_escaped, size, is_dir
        ));
    }

    Ok(format!("[{}]", entries_json.join(",")))
}

#[no_mangle]
pub extern "C" fn forge_archive_create_from_files(
    files_json: *const c_char,
    base_dir: *const c_char,
    output_path: *const c_char,
) -> *mut c_char {
    let files_json = cstr(files_json);
    let base_dir = cstr(base_dir);
    let output_path = cstr(output_path);

    match create_from_files(&files_json, &base_dir, &output_path) {
        Ok(()) => to_c("ok"),
        Err(e) => to_c(&e),
    }
}

fn create_from_files(files_json: &str, base_dir: &str, output_path: &str) -> Result<(), String> {
    let files: Vec<String> =
        serde_json::from_str(files_json).map_err(|e| format!("parse json: {}", e))?;

    let file = File::create(output_path).map_err(|e| format!("create output: {}", e))?;
    let enc = GzEncoder::new(file, Compression::default());
    let mut builder = Builder::new(enc);

    let base = Path::new(base_dir);
    for rel_path in &files {
        let full = base.join(rel_path);
        builder
            .append_path_with_name(&full, rel_path)
            .map_err(|e| format!("add file {}: {}", rel_path, e))?;
    }

    let enc = builder
        .into_inner()
        .map_err(|e| format!("finish tar: {}", e))?;
    enc.finish().map_err(|e| format!("finish gzip: {}", e))?;
    Ok(())
}
