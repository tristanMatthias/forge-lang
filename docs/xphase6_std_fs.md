# @std/fs Provider Spec

## provider.toml

```toml
[provider]
name = "fs"
namespace = "std"
version = "0.1.0"
description = "File system operations"

[native]
library = "forge_fs"
```

## provider.fg

```forge
extern fn forge_fs_read(path: string) -> string
extern fn forge_fs_read_bytes(path: string) -> bytes
extern fn forge_fs_write(path: string, content: string) -> bool
extern fn forge_fs_write_bytes(path: string, content: bytes) -> bool
extern fn forge_fs_append(path: string, content: string) -> bool
extern fn forge_fs_exists(path: string) -> bool
extern fn forge_fs_is_file(path: string) -> bool
extern fn forge_fs_is_dir(path: string) -> bool
extern fn forge_fs_mkdir(path: string, recursive: bool) -> bool
extern fn forge_fs_remove(path: string) -> bool
extern fn forge_fs_remove_dir(path: string, recursive: bool) -> bool
extern fn forge_fs_copy(from: string, to: string) -> bool
extern fn forge_fs_rename(from: string, to: string) -> bool
extern fn forge_fs_list_dir(path: string) -> string
extern fn forge_fs_file_size(path: string) -> int
extern fn forge_fs_modified_time(path: string) -> int
extern fn forge_fs_cwd() -> string
extern fn forge_fs_join_path(a: string, b: string) -> string
extern fn forge_fs_parent(path: string) -> string
extern fn forge_fs_filename(path: string) -> string
extern fn forge_fs_extension(path: string) -> string
extern fn forge_fs_glob(pattern: string) -> string

export fn read(path: string) -> Result<string, string> {
  let content = forge_fs_read(path)
  if content == "\0ERR" { Err(`failed to read ${path}`) } else { Ok(content) }
}

export fn read_bytes(path: string) -> Result<bytes, string> {
  let content = forge_fs_read_bytes(path)
  if content.length == 0 { Err(`failed to read ${path}`) } else { Ok(content) }
}

export fn write(path: string, content: string) -> Result<void, string> {
  if forge_fs_write(path, content) { Ok(()) } else { Err(`failed to write ${path}`) }
}

export fn append(path: string, content: string) -> Result<void, string> {
  if forge_fs_append(path, content) { Ok(()) } else { Err(`failed to append ${path}`) }
}

export fn exists(path: string) -> bool { forge_fs_exists(path) }
export fn is_file(path: string) -> bool { forge_fs_is_file(path) }
export fn is_dir(path: string) -> bool { forge_fs_is_dir(path) }

export fn mkdir(path: string) -> Result<void, string> {
  if forge_fs_mkdir(path, true) { Ok(()) } else { Err(`failed to create ${path}`) }
}

export fn remove(path: string) -> Result<void, string> {
  if forge_fs_remove(path) { Ok(()) } else { Err(`failed to remove ${path}`) }
}

export fn remove_dir(path: string) -> Result<void, string> {
  if forge_fs_remove_dir(path, true) { Ok(()) } else { Err(`failed to remove ${path}`) }
}

export fn copy(from: string, to: string) -> Result<void, string> {
  if forge_fs_copy(from, to) { Ok(()) } else { Err(`failed to copy ${from} to ${to}`) }
}

export fn rename(from: string, to: string) -> Result<void, string> {
  if forge_fs_rename(from, to) { Ok(()) } else { Err(`failed to rename ${from} to ${to}`) }
}

export fn list(path: string) -> Result<List<string>, string> {
  let result = forge_fs_list_dir(path)
  if result == "\0ERR" { Err(`failed to list ${path}`) } else { Ok(json.parse(result)) }
}

export fn size(path: string) -> int { forge_fs_file_size(path) }
export fn modified(path: string) -> int { forge_fs_modified_time(path) }
export fn cwd() -> string { forge_fs_cwd() }
export fn join(a: string, b: string) -> string { forge_fs_join_path(a, b) }
export fn parent(path: string) -> string { forge_fs_parent(path) }
export fn filename(path: string) -> string { forge_fs_filename(path) }
export fn extension(path: string) -> string { forge_fs_extension(path) }

export fn glob(pattern: string) -> Result<List<string>, string> {
  let result = forge_fs_glob(pattern)
  if result == "\0ERR" { Err(`failed to glob ${pattern}`) } else { Ok(json.parse(result)) }
}
```

## Native Library (Rust)

```rust
// providers/std-fs/src/lib.rs

use std::ffi::{CStr, CString};
use std::fs;
use std::os::raw::c_char;
use std::path::Path;
use std::time::UNIX_EPOCH;

// ── String helpers ──

unsafe fn to_str(ptr: *const c_char, len: i64) -> String {
    let slice = std::slice::from_raw_parts(ptr as *const u8, len as usize);
    String::from_utf8_lossy(slice).to_string()
}

fn to_forge(s: &str) -> (*const c_char, i64) {
    let c = CString::new(s).unwrap_or_default();
    let len = c.as_bytes().len() as i64;
    (c.into_raw() as *const c_char, len)
}

fn err_string() -> (*const c_char, i64) {
    to_forge("\0ERR")
}

// ── File operations ──

#[no_mangle]
pub extern "C" fn forge_fs_read(path: *const c_char, path_len: i64) -> (*const c_char, i64) {
    let path = unsafe { to_str(path, path_len) };
    match fs::read_to_string(&path) {
        Ok(content) => to_forge(&content),
        Err(_) => err_string(),
    }
}

#[no_mangle]
pub extern "C" fn forge_fs_write(
    path: *const c_char, path_len: i64,
    content: *const c_char, content_len: i64,
) -> i8 {
    let path = unsafe { to_str(path, path_len) };
    let content = unsafe { to_str(content, content_len) };
    match fs::write(&path, &content) {
        Ok(_) => 1,
        Err(_) => 0,
    }
}

#[no_mangle]
pub extern "C" fn forge_fs_append(
    path: *const c_char, path_len: i64,
    content: *const c_char, content_len: i64,
) -> i8 {
    use std::io::Write;
    let path = unsafe { to_str(path, path_len) };
    let content = unsafe { to_str(content, content_len) };
    match fs::OpenOptions::new().append(true).create(true).open(&path) {
        Ok(mut f) => if f.write_all(content.as_bytes()).is_ok() { 1 } else { 0 },
        Err(_) => 0,
    }
}

#[no_mangle]
pub extern "C" fn forge_fs_exists(path: *const c_char, path_len: i64) -> i8 {
    let path = unsafe { to_str(path, path_len) };
    if Path::new(&path).exists() { 1 } else { 0 }
}

#[no_mangle]
pub extern "C" fn forge_fs_is_file(path: *const c_char, path_len: i64) -> i8 {
    let path = unsafe { to_str(path, path_len) };
    if Path::new(&path).is_file() { 1 } else { 0 }
}

#[no_mangle]
pub extern "C" fn forge_fs_is_dir(path: *const c_char, path_len: i64) -> i8 {
    let path = unsafe { to_str(path, path_len) };
    if Path::new(&path).is_dir() { 1 } else { 0 }
}

#[no_mangle]
pub extern "C" fn forge_fs_mkdir(path: *const c_char, path_len: i64, recursive: i8) -> i8 {
    let path = unsafe { to_str(path, path_len) };
    let result = if recursive != 0 {
        fs::create_dir_all(&path)
    } else {
        fs::create_dir(&path)
    };
    if result.is_ok() { 1 } else { 0 }
}

#[no_mangle]
pub extern "C" fn forge_fs_remove(path: *const c_char, path_len: i64) -> i8 {
    let path = unsafe { to_str(path, path_len) };
    if fs::remove_file(&path).is_ok() { 1 } else { 0 }
}

#[no_mangle]
pub extern "C" fn forge_fs_remove_dir(path: *const c_char, path_len: i64, recursive: i8) -> i8 {
    let path = unsafe { to_str(path, path_len) };
    let result = if recursive != 0 {
        fs::remove_dir_all(&path)
    } else {
        fs::remove_dir(&path)
    };
    if result.is_ok() { 1 } else { 0 }
}

#[no_mangle]
pub extern "C" fn forge_fs_copy(
    from: *const c_char, from_len: i64,
    to: *const c_char, to_len: i64,
) -> i8 {
    let from = unsafe { to_str(from, from_len) };
    let to = unsafe { to_str(to, to_len) };
    if fs::copy(&from, &to).is_ok() { 1 } else { 0 }
}

#[no_mangle]
pub extern "C" fn forge_fs_rename(
    from: *const c_char, from_len: i64,
    to: *const c_char, to_len: i64,
) -> i8 {
    let from = unsafe { to_str(from, from_len) };
    let to = unsafe { to_str(to, to_len) };
    if fs::rename(&from, &to).is_ok() { 1 } else { 0 }
}

#[no_mangle]
pub extern "C" fn forge_fs_list_dir(path: *const c_char, path_len: i64) -> (*const c_char, i64) {
    let path = unsafe { to_str(path, path_len) };
    match fs::read_dir(&path) {
        Ok(entries) => {
            let names: Vec<String> = entries
                .filter_map(|e| e.ok())
                .map(|e| e.file_name().to_string_lossy().to_string())
                .collect();
            let json = format!("[{}]", names.iter()
                .map(|n| format!("\"{}\"", n))
                .collect::<Vec<_>>()
                .join(","));
            to_forge(&json)
        }
        Err(_) => err_string(),
    }
}

#[no_mangle]
pub extern "C" fn forge_fs_file_size(path: *const c_char, path_len: i64) -> i64 {
    let path = unsafe { to_str(path, path_len) };
    fs::metadata(&path).map(|m| m.len() as i64).unwrap_or(-1)
}

#[no_mangle]
pub extern "C" fn forge_fs_modified_time(path: *const c_char, path_len: i64) -> i64 {
    let path = unsafe { to_str(path, path_len) };
    fs::metadata(&path)
        .and_then(|m| m.modified())
        .map(|t| t.duration_since(UNIX_EPOCH).unwrap_or_default().as_secs() as i64)
        .unwrap_or(-1)
}

#[no_mangle]
pub extern "C" fn forge_fs_cwd() -> (*const c_char, i64) {
    match std::env::current_dir() {
        Ok(p) => to_forge(&p.to_string_lossy()),
        Err(_) => to_forge("."),
    }
}

#[no_mangle]
pub extern "C" fn forge_fs_join_path(
    a: *const c_char, a_len: i64,
    b: *const c_char, b_len: i64,
) -> (*const c_char, i64) {
    let a = unsafe { to_str(a, a_len) };
    let b = unsafe { to_str(b, b_len) };
    let joined = Path::new(&a).join(&b);
    to_forge(&joined.to_string_lossy())
}

#[no_mangle]
pub extern "C" fn forge_fs_parent(path: *const c_char, path_len: i64) -> (*const c_char, i64) {
    let path = unsafe { to_str(path, path_len) };
    let parent = Path::new(&path).parent().unwrap_or(Path::new(""));
    to_forge(&parent.to_string_lossy())
}

#[no_mangle]
pub extern "C" fn forge_fs_filename(path: *const c_char, path_len: i64) -> (*const c_char, i64) {
    let path = unsafe { to_str(path, path_len) };
    let name = Path::new(&path).file_name().unwrap_or_default();
    to_forge(&name.to_string_lossy())
}

#[no_mangle]
pub extern "C" fn forge_fs_extension(path: *const c_char, path_len: i64) -> (*const c_char, i64) {
    let path = unsafe { to_str(path, path_len) };
    let ext = Path::new(&path).extension().unwrap_or_default();
    to_forge(&ext.to_string_lossy())
}

#[no_mangle]
pub extern "C" fn forge_fs_glob(pattern: *const c_char, pattern_len: i64) -> (*const c_char, i64) {
    let pattern = unsafe { to_str(pattern, pattern_len) };
    // Simple glob: walk current dir and match with basic wildcard
    // For production, use the `glob` crate
    match glob::glob(&pattern) {
        Ok(paths) => {
            let matches: Vec<String> = paths
                .filter_map(|p| p.ok())
                .map(|p| p.to_string_lossy().to_string())
                .collect();
            let json = format!("[{}]", matches.iter()
                .map(|m| format!("\"{}\"", m))
                .collect::<Vec<_>>()
                .join(","));
            to_forge(&json)
        }
        Err(_) => err_string(),
    }
}
```

## Cargo.toml

```toml
[package]
name = "forge_fs"
version = "0.1.0"
edition = "2021"

[lib]
crate-type = ["staticlib"]

[dependencies]
glob = "0.3"
```

## Tests

```forge
// test_fs.fg
use @std.fs

fn main() {
  // Write and read
  fs.write("test.txt", "hello forge")?
  let content = fs.read("test.txt")?
  println(content)                           // hello forge

  // Exists
  println(string(fs.exists("test.txt")))     // true
  println(string(fs.exists("nope.txt")))     // false

  // Append
  fs.append("test.txt", "\ngoodbye")?
  println(fs.read("test.txt")?)              // hello forge\ngoodbye

  // File info
  println(string(fs.is_file("test.txt")))    // true
  println(string(fs.is_dir("test.txt")))     // false
  println(string(fs.size("test.txt")))       // > 0

  // Path operations
  println(fs.join("src", "main.fg"))         // src/main.fg
  println(fs.parent("src/main.fg"))          // src
  println(fs.filename("src/main.fg"))        // main.fg
  println(fs.extension("src/main.fg"))       // fg

  // Directory operations
  fs.mkdir("test_dir")?
  println(string(fs.is_dir("test_dir")))     // true
  fs.write("test_dir/a.txt", "a")?
  fs.write("test_dir/b.txt", "b")?
  let files = fs.list("test_dir")?
  println(string(files.length))              // 2

  // Copy and rename
  fs.copy("test.txt", "test_copy.txt")?
  println(string(fs.exists("test_copy.txt"))) // true
  fs.rename("test_copy.txt", "test_moved.txt")?
  println(string(fs.exists("test_copy.txt"))) // false
  println(string(fs.exists("test_moved.txt"))) // true

  // Glob
  let fg_files = fs.glob("test_dir/*.txt")?
  println(string(fg_files.length))           // 2

  // Cleanup
  fs.remove("test.txt")?
  fs.remove("test_moved.txt")?
  fs.remove_dir("test_dir")?
  println("done")
}
```
