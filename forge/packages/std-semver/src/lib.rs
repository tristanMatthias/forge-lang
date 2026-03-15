use std::ffi::{CStr, CString};
use std::os::raw::c_char;

use semver::{Version, VersionReq};

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

// ---------------------------------------------------------------------------
// Exported functions
// ---------------------------------------------------------------------------

/// Returns 1 if the string is valid semver, 0 otherwise.
#[no_mangle]
pub extern "C" fn forge_semver_valid(version_str: *const c_char) -> i64 {
    let s = c_str_to_string(version_str);
    if Version::parse(&s).is_ok() {
        1
    } else {
        0
    }
}

/// Parse a semver string and return JSON with major, minor, patch, pre, build.
/// Returns empty string on invalid input.
#[no_mangle]
pub extern "C" fn forge_semver_parse(version_str: *const c_char) -> *const c_char {
    let s = c_str_to_string(version_str);
    match Version::parse(&s) {
        Ok(v) => {
            let json = serde_json::json!({
                "major": v.major,
                "minor": v.minor,
                "patch": v.patch,
                "pre": v.pre.to_string(),
                "build": v.build.to_string(),
            });
            string_to_c(json.to_string())
        }
        Err(_) => string_to_c(String::new()),
    }
}

/// Compare two semver strings. Returns -1, 0, or 1.
/// Returns 0 if either is invalid.
#[no_mangle]
pub extern "C" fn forge_semver_compare(a: *const c_char, b: *const c_char) -> i64 {
    let sa = c_str_to_string(a);
    let sb = c_str_to_string(b);
    match (Version::parse(&sa), Version::parse(&sb)) {
        (Ok(va), Ok(vb)) => match va.cmp(&vb) {
            std::cmp::Ordering::Less => -1,
            std::cmp::Ordering::Equal => 0,
            std::cmp::Ordering::Greater => 1,
        },
        _ => 0,
    }
}

/// Returns 1 if version satisfies the range, 0 otherwise.
/// Plain version strings like "1.0.0" are treated as "=1.0.0".
#[no_mangle]
pub extern "C" fn forge_semver_satisfies(
    version: *const c_char,
    range: *const c_char,
) -> i64 {
    let ver_str = c_str_to_string(version);
    let range_str = c_str_to_string(range);

    let ver = match Version::parse(&ver_str) {
        Ok(v) => v,
        Err(_) => return 0,
    };

    // Try parsing as VersionReq directly; if that fails, try prepending "="
    let req = match VersionReq::parse(&range_str) {
        Ok(r) => r,
        Err(_) => match VersionReq::parse(&format!("={}", range_str)) {
            Ok(r) => r,
            Err(_) => return 0,
        },
    };

    if req.matches(&ver) {
        1
    } else {
        0
    }
}

/// Takes a JSON array of version strings and a range.
/// Returns the highest version that satisfies the range, or empty string if none.
#[no_mangle]
pub extern "C" fn forge_semver_max_satisfying(
    versions_json: *const c_char,
    range: *const c_char,
) -> *const c_char {
    let json_str = c_str_to_string(versions_json);
    let range_str = c_str_to_string(range);

    let versions: Vec<String> = match serde_json::from_str(&json_str) {
        Ok(v) => v,
        Err(_) => return string_to_c(String::new()),
    };

    // Try parsing as VersionReq directly; if that fails, try prepending "="
    let req = match VersionReq::parse(&range_str) {
        Ok(r) => r,
        Err(_) => match VersionReq::parse(&format!("={}", range_str)) {
            Ok(r) => r,
            Err(_) => return string_to_c(String::new()),
        },
    };

    let mut best: Option<Version> = None;
    for vs in &versions {
        if let Ok(v) = Version::parse(vs) {
            if req.matches(&v) {
                if best.as_ref().map_or(true, |b| v > *b) {
                    best = Some(v);
                }
            }
        }
    }

    match best {
        Some(v) => string_to_c(v.to_string()),
        None => string_to_c(String::new()),
    }
}

/// Bump a version by level ("major", "minor", or "patch").
/// Returns the bumped version string, or empty string on invalid input.
#[no_mangle]
pub extern "C" fn forge_semver_bump(
    version: *const c_char,
    level: *const c_char,
) -> *const c_char {
    let ver_str = c_str_to_string(version);
    let level_str = c_str_to_string(level);

    let mut ver = match Version::parse(&ver_str) {
        Ok(v) => v,
        Err(_) => return string_to_c(String::new()),
    };

    match level_str.as_str() {
        "major" => {
            ver.major += 1;
            ver.minor = 0;
            ver.patch = 0;
            ver.pre = semver::Prerelease::EMPTY;
            ver.build = semver::BuildMetadata::EMPTY;
        }
        "minor" => {
            ver.minor += 1;
            ver.patch = 0;
            ver.pre = semver::Prerelease::EMPTY;
            ver.build = semver::BuildMetadata::EMPTY;
        }
        "patch" => {
            ver.patch += 1;
            ver.pre = semver::Prerelease::EMPTY;
            ver.build = semver::BuildMetadata::EMPTY;
        }
        _ => return string_to_c(String::new()),
    }

    string_to_c(ver.to_string())
}

/// Returns the difference level between two versions: "major", "minor", "patch", "pre", or "none".
/// Returns empty string if either version is invalid.
#[no_mangle]
pub extern "C" fn forge_semver_diff(a: *const c_char, b: *const c_char) -> *const c_char {
    let sa = c_str_to_string(a);
    let sb = c_str_to_string(b);

    match (Version::parse(&sa), Version::parse(&sb)) {
        (Ok(va), Ok(vb)) => {
            let result = if va.major != vb.major {
                "major"
            } else if va.minor != vb.minor {
                "minor"
            } else if va.patch != vb.patch {
                "patch"
            } else if va.pre != vb.pre {
                "pre"
            } else {
                "none"
            };
            string_to_c(result.to_string())
        }
        _ => string_to_c(String::new()),
    }
}
