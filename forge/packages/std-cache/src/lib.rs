use std::ffi::{CStr, CString};
use std::fs;
use std::io::Read;
use std::os::raw::c_char;
use std::path::{Path, PathBuf};

use chrono::Utc;
use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use walkdir::WalkDir;

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

fn c_str_to_string(ptr: *const c_char) -> String {
    if ptr.is_null() {
        return String::new();
    }
    unsafe { CStr::from_ptr(ptr) }
        .to_str()
        .unwrap_or("")
        .to_string()
}

fn string_to_c(s: String) -> *const c_char {
    CString::new(s)
        .unwrap_or_else(|_| CString::new("").unwrap())
        .into_raw() as *const c_char
}

fn cache_root() -> PathBuf {
    dirs::home_dir()
        .unwrap_or_else(|| PathBuf::from("/tmp"))
        .join(".forge")
}

fn artifacts_dir() -> PathBuf {
    cache_root().join("cache").join("artifacts")
}

fn source_dir() -> PathBuf {
    cache_root().join("cache").join("source")
}

fn context_dir() -> PathBuf {
    cache_root().join("cache").join("context")
}

fn index_dir() -> PathBuf {
    cache_root().join("cache").join("index")
}

fn index_key(name: &str, version: &str) -> String {
    format!("{}@{}", name, version)
}

fn sha256_file(path: &Path) -> Result<String, std::io::Error> {
    let mut file = fs::File::open(path)?;
    let mut hasher = Sha256::new();
    let mut buf = [0u8; 8192];
    loop {
        let n = file.read(&mut buf)?;
        if n == 0 {
            break;
        }
        hasher.update(&buf[..n]);
    }
    Ok(hex::encode(hasher.finalize()))
}

fn ext_for_artifact_type(artifact_type: &str) -> &str {
    match artifact_type {
        "static_lib" => "a",
        "bitcode" => "bc",
        "object" => "o",
        _ => "bin",
    }
}

fn dir_size(dir: &Path) -> u64 {
    if !dir.exists() {
        return 0;
    }
    WalkDir::new(dir)
        .into_iter()
        .filter_map(|e| e.ok())
        .filter(|e| e.file_type().is_file())
        .filter_map(|e| e.metadata().ok())
        .map(|m| m.len())
        .sum()
}

// ---------------------------------------------------------------------------
// Index entry (TOML)
// ---------------------------------------------------------------------------

#[derive(Debug, Serialize, Deserialize, Default)]
struct IndexEntry {
    #[serde(default)]
    artifact: Option<IndexArtifact>,
    #[serde(default)]
    source: Option<IndexSource>,
    #[serde(default)]
    metadata: Option<IndexMetadata>,
}

#[derive(Debug, Serialize, Deserialize, Clone)]
struct IndexArtifact {
    hash: String,
    path: String,
    #[serde(rename = "type")]
    artifact_type: String,
}

#[derive(Debug, Serialize, Deserialize, Clone)]
struct IndexSource {
    hash: String,
    path: String,
}

#[derive(Debug, Serialize, Deserialize, Clone)]
struct IndexMetadata {
    cached_at: String,
    size_bytes: u64,
}

fn read_index_entry(name: &str, version: &str) -> Option<IndexEntry> {
    let path = index_dir().join(format!("{}.toml", index_key(name, version)));
    let content = fs::read_to_string(&path).ok()?;
    toml::from_str(&content).ok()
}

fn write_index_entry(name: &str, version: &str, entry: &IndexEntry) -> bool {
    let path = index_dir().join(format!("{}.toml", index_key(name, version)));
    match toml::to_string_pretty(entry) {
        Ok(content) => fs::write(&path, content).is_ok(),
        Err(_) => false,
    }
}

// ---------------------------------------------------------------------------
// Exported functions
// ---------------------------------------------------------------------------

/// Initialize cache directories. Returns cache root path.
#[no_mangle]
pub extern "C" fn forge_cache_init() -> *const c_char {
    let dirs = [artifacts_dir(), source_dir(), context_dir(), index_dir()];
    for d in &dirs {
        if let Err(_) = fs::create_dir_all(d) {
            return string_to_c(String::new());
        }
    }
    string_to_c(cache_root().to_string_lossy().to_string())
}

/// Store an artifact. Returns content hash.
#[no_mangle]
pub extern "C" fn forge_cache_store_artifact(
    name: *const c_char,
    version: *const c_char,
    artifact_path: *const c_char,
    artifact_type: *const c_char,
) -> *const c_char {
    let name = c_str_to_string(name);
    let version = c_str_to_string(version);
    let src_path = PathBuf::from(c_str_to_string(artifact_path));
    let atype = c_str_to_string(artifact_type);

    let hash = match sha256_file(&src_path) {
        Ok(h) => h,
        Err(_) => return string_to_c(String::new()),
    };

    let ext = ext_for_artifact_type(&atype);
    let dest_name = format!("{}.{}", hash, ext);
    let dest_path = artifacts_dir().join(&dest_name);

    if let Err(_) = fs::copy(&src_path, &dest_path) {
        return string_to_c(String::new());
    }

    let size = fs::metadata(&dest_path).map(|m| m.len()).unwrap_or(0);

    // Update index
    let mut entry = read_index_entry(&name, &version).unwrap_or_default();
    entry.artifact = Some(IndexArtifact {
        hash: format!("sha256:{}", hash),
        path: format!("artifacts/{}", dest_name),
        artifact_type: atype,
    });
    entry.metadata = Some(IndexMetadata {
        cached_at: Utc::now().to_rfc3339(),
        size_bytes: size,
    });
    write_index_entry(&name, &version, &entry);

    string_to_c(hash)
}

/// Get artifact path from cache. Returns empty string if not found.
#[no_mangle]
pub extern "C" fn forge_cache_get_artifact(
    name: *const c_char,
    version: *const c_char,
    artifact_type: *const c_char,
) -> *const c_char {
    let name = c_str_to_string(name);
    let version = c_str_to_string(version);
    let atype = c_str_to_string(artifact_type);

    if let Some(entry) = read_index_entry(&name, &version) {
        if let Some(artifact) = entry.artifact {
            if artifact.artifact_type == atype {
                let full_path = cache_root().join("cache").join(&artifact.path);
                if full_path.exists() {
                    return string_to_c(full_path.to_string_lossy().to_string());
                }
            }
        }
    }
    string_to_c(String::new())
}

/// Store source archive. Returns content hash.
#[no_mangle]
pub extern "C" fn forge_cache_store_source(
    name: *const c_char,
    version: *const c_char,
    archive_path: *const c_char,
) -> *const c_char {
    let name = c_str_to_string(name);
    let version = c_str_to_string(version);
    let src_path = PathBuf::from(c_str_to_string(archive_path));

    let hash = match sha256_file(&src_path) {
        Ok(h) => h,
        Err(_) => return string_to_c(String::new()),
    };

    let dest_name = format!("{}.tar.gz", hash);
    let dest_path = source_dir().join(&dest_name);

    if let Err(_) = fs::copy(&src_path, &dest_path) {
        return string_to_c(String::new());
    }

    // Update index
    let mut entry = read_index_entry(&name, &version).unwrap_or_default();
    entry.source = Some(IndexSource {
        hash: format!("sha256:{}", hash),
        path: format!("source/{}", dest_name),
    });
    if entry.metadata.is_none() {
        entry.metadata = Some(IndexMetadata {
            cached_at: Utc::now().to_rfc3339(),
            size_bytes: fs::metadata(&dest_path).map(|m| m.len()).unwrap_or(0),
        });
    }
    write_index_entry(&name, &version, &entry);

    string_to_c(hash)
}

/// Get source archive path. Returns empty string if not found.
#[no_mangle]
pub extern "C" fn forge_cache_get_source(
    name: *const c_char,
    version: *const c_char,
) -> *const c_char {
    let name = c_str_to_string(name);
    let version = c_str_to_string(version);

    if let Some(entry) = read_index_entry(&name, &version) {
        if let Some(source) = entry.source {
            let full_path = cache_root().join("cache").join(&source.path);
            if full_path.exists() {
                return string_to_c(full_path.to_string_lossy().to_string());
            }
        }
    }
    string_to_c(String::new())
}

/// Store context file. Returns 1 on success, 0 on failure.
#[no_mangle]
pub extern "C" fn forge_cache_store_context(
    name: *const c_char,
    version: *const c_char,
    content: *const c_char,
) -> i64 {
    let name = c_str_to_string(name);
    let version = c_str_to_string(version);
    let content = c_str_to_string(content);

    let filename = format!("{}@{}.fg", name, version);
    let path = context_dir().join(&filename);

    match fs::write(&path, &content) {
        Ok(_) => 1,
        Err(_) => 0,
    }
}

/// Get context file content. Returns empty string if not found.
#[no_mangle]
pub extern "C" fn forge_cache_get_context(
    name: *const c_char,
    version: *const c_char,
) -> *const c_char {
    let name = c_str_to_string(name);
    let version = c_str_to_string(version);

    let filename = format!("{}@{}.fg", name, version);
    let path = context_dir().join(&filename);

    match fs::read_to_string(&path) {
        Ok(content) => string_to_c(content),
        Err(_) => string_to_c(String::new()),
    }
}

/// Store index entry from JSON. Returns 1 on success, 0 on failure.
#[no_mangle]
pub extern "C" fn forge_cache_index_set(
    name: *const c_char,
    version: *const c_char,
    manifest_json: *const c_char,
) -> i64 {
    let name = c_str_to_string(name);
    let version = c_str_to_string(version);
    let json_str = c_str_to_string(manifest_json);

    let entry: IndexEntry = match serde_json::from_str(&json_str) {
        Ok(e) => e,
        Err(_) => return 0,
    };

    if write_index_entry(&name, &version, &entry) {
        1
    } else {
        0
    }
}

/// Get index entry as JSON. Returns empty string if not found.
#[no_mangle]
pub extern "C" fn forge_cache_index_get(
    name: *const c_char,
    version: *const c_char,
) -> *const c_char {
    let name = c_str_to_string(name);
    let version = c_str_to_string(version);

    match read_index_entry(&name, &version) {
        Some(entry) => match serde_json::to_string(&entry) {
            Ok(json) => string_to_c(json),
            Err(_) => string_to_c(String::new()),
        },
        None => string_to_c(String::new()),
    }
}

/// Verify artifact hash matches expected. Returns 1 if match, 0 if mismatch.
#[no_mangle]
pub extern "C" fn forge_cache_verify(
    name: *const c_char,
    version: *const c_char,
    expected_hash: *const c_char,
) -> i64 {
    let name = c_str_to_string(name);
    let version = c_str_to_string(version);
    let expected = c_str_to_string(expected_hash);

    // Strip "sha256:" prefix if present
    let expected_hex = expected
        .strip_prefix("sha256:")
        .unwrap_or(&expected);

    if let Some(entry) = read_index_entry(&name, &version) {
        if let Some(artifact) = entry.artifact {
            let full_path = cache_root().join("cache").join(&artifact.path);
            if let Ok(actual_hash) = sha256_file(&full_path) {
                return if actual_hash == expected_hex { 1 } else { 0 };
            }
        }
    }
    0
}

/// Cache status as JSON with size breakdown.
#[no_mangle]
pub extern "C" fn forge_cache_status() -> *const c_char {
    let artifacts_size = dir_size(&artifacts_dir());
    let source_size = dir_size(&source_dir());
    let context_size = dir_size(&context_dir());
    let index_size = dir_size(&index_dir());
    let total = artifacts_size + source_size + context_size + index_size;

    // Count index entries
    let entry_count = fs::read_dir(index_dir())
        .map(|rd| rd.filter_map(|e| e.ok()).count())
        .unwrap_or(0);

    let status = serde_json::json!({
        "cache_root": cache_root().to_string_lossy(),
        "total_size_bytes": total,
        "artifacts_size_bytes": artifacts_size,
        "source_size_bytes": source_size,
        "context_size_bytes": context_size,
        "index_size_bytes": index_size,
        "entry_count": entry_count,
    });

    string_to_c(status.to_string())
}

/// Garbage collect unreferenced source archives.
/// If aggressive != 0, also remove unreferenced artifacts.
/// Returns JSON summary.
#[no_mangle]
pub extern "C" fn forge_cache_gc(aggressive: i64) -> *const c_char {
    // Collect all referenced paths from index entries
    let mut referenced_paths = std::collections::HashSet::new();

    if let Ok(entries) = fs::read_dir(index_dir()) {
        for entry in entries.filter_map(|e| e.ok()) {
            if let Ok(content) = fs::read_to_string(entry.path()) {
                if let Ok(idx_entry) = toml::from_str::<IndexEntry>(&content) {
                    if let Some(artifact) = &idx_entry.artifact {
                        referenced_paths.insert(
                            cache_root()
                                .join("cache")
                                .join(&artifact.path)
                                .to_string_lossy()
                                .to_string(),
                        );
                    }
                    if let Some(source) = &idx_entry.source {
                        referenced_paths.insert(
                            cache_root()
                                .join("cache")
                                .join(&source.path)
                                .to_string_lossy()
                                .to_string(),
                        );
                    }
                }
            }
        }
    }

    let mut files_removed: u64 = 0;
    let mut bytes_freed: u64 = 0;

    // Always clean unreferenced source archives
    let dirs_to_clean = if aggressive != 0 {
        vec![source_dir(), artifacts_dir()]
    } else {
        vec![source_dir()]
    };

    for dir in &dirs_to_clean {
        if let Ok(entries) = fs::read_dir(dir) {
            for entry in entries.filter_map(|e| e.ok()) {
                let path = entry.path();
                if path.is_file() {
                    let path_str = path.to_string_lossy().to_string();
                    if !referenced_paths.contains(&path_str) {
                        let size = fs::metadata(&path).map(|m| m.len()).unwrap_or(0);
                        if fs::remove_file(&path).is_ok() {
                            files_removed += 1;
                            bytes_freed += size;
                        }
                    }
                }
            }
        }
    }

    let result = serde_json::json!({
        "files_removed": files_removed,
        "bytes_freed": bytes_freed,
        "aggressive": aggressive != 0,
    });

    string_to_c(result.to_string())
}

/// Clear entire cache. Returns 1 on success, 0 on failure.
#[no_mangle]
pub extern "C" fn forge_cache_clear() -> i64 {
    let cache_dir = cache_root().join("cache");
    if !cache_dir.exists() {
        return 1;
    }
    match fs::remove_dir_all(&cache_dir) {
        Ok(_) => {
            // Re-create the directory structure
            let dirs = [artifacts_dir(), source_dir(), context_dir(), index_dir()];
            for d in &dirs {
                if fs::create_dir_all(d).is_err() {
                    return 0;
                }
            }
            1
        }
        Err(_) => 0,
    }
}

/// Check if a package version is cached. Returns 1 if yes, 0 if no.
#[no_mangle]
pub extern "C" fn forge_cache_has(
    name: *const c_char,
    version: *const c_char,
) -> i64 {
    let name = c_str_to_string(name);
    let version = c_str_to_string(version);

    match read_index_entry(&name, &version) {
        Some(entry) => {
            // Check that at least one cached file actually exists
            if let Some(artifact) = &entry.artifact {
                let path = cache_root().join("cache").join(&artifact.path);
                if path.exists() {
                    return 1;
                }
            }
            if let Some(source) = &entry.source {
                let path = cache_root().join("cache").join(&source.path);
                if path.exists() {
                    return 1;
                }
            }
            // Index exists but no files — treat as not cached
            0
        }
        None => 0,
    }
}
