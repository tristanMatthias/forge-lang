use std::ffi::{CStr, CString};
use std::os::raw::c_char;

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

fn err_c() -> *mut c_char {
    to_c("")
}

/// Convert a `toml::Value` to a `serde_json::Value`.
fn toml_to_json(val: &toml::Value) -> serde_json::Value {
    match val {
        toml::Value::String(s) => serde_json::Value::String(s.clone()),
        toml::Value::Integer(i) => serde_json::json!(*i),
        toml::Value::Float(f) => serde_json::json!(*f),
        toml::Value::Boolean(b) => serde_json::Value::Bool(*b),
        toml::Value::Datetime(dt) => serde_json::Value::String(dt.to_string()),
        toml::Value::Array(arr) => {
            serde_json::Value::Array(arr.iter().map(toml_to_json).collect())
        }
        toml::Value::Table(tbl) => {
            let map: serde_json::Map<String, serde_json::Value> = tbl
                .iter()
                .map(|(k, v)| (k.clone(), toml_to_json(v)))
                .collect();
            serde_json::Value::Object(map)
        }
    }
}

/// Convert a `serde_json::Value` to a `toml::Value`.
fn json_to_toml(val: &serde_json::Value) -> toml::Value {
    match val {
        serde_json::Value::Null => toml::Value::String("null".to_string()),
        serde_json::Value::Bool(b) => toml::Value::Boolean(*b),
        serde_json::Value::Number(n) => {
            if let Some(i) = n.as_i64() {
                toml::Value::Integer(i)
            } else if let Some(f) = n.as_f64() {
                toml::Value::Float(f)
            } else {
                toml::Value::String(n.to_string())
            }
        }
        serde_json::Value::String(s) => toml::Value::String(s.clone()),
        serde_json::Value::Array(arr) => {
            toml::Value::Array(arr.iter().map(json_to_toml).collect())
        }
        serde_json::Value::Object(map) => {
            let mut tbl = toml::map::Map::new();
            for (k, v) in map {
                tbl.insert(k.clone(), json_to_toml(v));
            }
            toml::Value::Table(tbl)
        }
    }
}

/// Walk a dotted key path (e.g., "package.name") into a `toml::Value`.
fn walk_path<'a>(root: &'a toml::Value, dotted_key: &str) -> Option<&'a toml::Value> {
    if dotted_key.is_empty() {
        return Some(root);
    }
    let parts: Vec<&str> = dotted_key.split('.').collect();
    let mut current = root;
    for part in parts {
        match current {
            toml::Value::Table(tbl) => {
                current = tbl.get(part)?;
            }
            toml::Value::Array(arr) => {
                let idx: usize = part.parse().ok()?;
                current = arr.get(idx)?;
            }
            _ => return None,
        }
    }
    Some(current)
}

/// Walk a dotted key path mutably, creating intermediate tables as needed.
fn walk_path_mut<'a>(root: &'a mut toml::Value, dotted_key: &str) -> Option<&'a mut toml::Value> {
    if dotted_key.is_empty() {
        return Some(root);
    }
    let parts: Vec<&str> = dotted_key.split('.').collect();
    let mut current = root;
    for part in parts {
        match current {
            toml::Value::Table(tbl) => {
                current = tbl
                    .entry(part.to_string())
                    .or_insert_with(|| toml::Value::Table(toml::map::Map::new()));
            }
            toml::Value::Array(arr) => {
                let idx: usize = part.parse().ok()?;
                current = arr.get_mut(idx)?;
            }
            _ => return None,
        }
    }
    Some(current)
}

// ── Public API ──

/// Parse a TOML string and return its JSON representation.
#[no_mangle]
pub extern "C" fn forge_toml_parse(toml_str: *const c_char) -> *mut c_char {
    let input = cstr(toml_str);
    match input.parse::<toml::Value>() {
        Ok(val) => {
            let json = toml_to_json(&val);
            to_c(&json.to_string())
        }
        Err(_) => err_c(),
    }
}

/// Convert a JSON string to a pretty-printed TOML string.
#[no_mangle]
pub extern "C" fn forge_toml_stringify(json_str: *const c_char) -> *mut c_char {
    let input = cstr(json_str);
    match serde_json::from_str::<serde_json::Value>(&input) {
        Ok(json_val) => {
            let toml_val = json_to_toml(&json_val);
            match toml::to_string_pretty(&toml_val) {
                Ok(s) => to_c(&s),
                Err(_) => err_c(),
            }
        }
        Err(_) => err_c(),
    }
}

/// Get a value by dotted key path, returning it as a JSON string.
#[no_mangle]
pub extern "C" fn forge_toml_get(toml_str: *const c_char, key: *const c_char) -> *mut c_char {
    let input = cstr(toml_str);
    let key = cstr(key);
    match input.parse::<toml::Value>() {
        Ok(val) => match walk_path(&val, &key) {
            Some(found) => {
                let json = toml_to_json(found);
                to_c(&json.to_string())
            }
            None => err_c(),
        },
        Err(_) => err_c(),
    }
}

/// Set a value at a dotted key path. `json_value` is JSON-encoded.
/// Returns the modified TOML string.
#[no_mangle]
pub extern "C" fn forge_toml_set(
    toml_str: *const c_char,
    key: *const c_char,
    json_value: *const c_char,
) -> *mut c_char {
    let input = cstr(toml_str);
    let key = cstr(key);
    let json_val_str = cstr(json_value);

    let mut toml_val = match input.parse::<toml::Value>() {
        Ok(v) => v,
        Err(_) => return err_c(),
    };

    let new_val = match serde_json::from_str::<serde_json::Value>(&json_val_str) {
        Ok(jv) => json_to_toml(&jv),
        Err(_) => return err_c(),
    };

    // Split into parent path and leaf key
    if let Some(dot_pos) = key.rfind('.') {
        let parent_path = &key[..dot_pos];
        let leaf = &key[dot_pos + 1..];
        match walk_path_mut(&mut toml_val, parent_path) {
            Some(toml::Value::Table(tbl)) => {
                tbl.insert(leaf.to_string(), new_val);
            }
            _ => return err_c(),
        }
    } else {
        // Top-level key
        match &mut toml_val {
            toml::Value::Table(tbl) => {
                tbl.insert(key.clone(), new_val);
            }
            _ => return err_c(),
        }
    }

    match toml::to_string_pretty(&toml_val) {
        Ok(s) => to_c(&s),
        Err(_) => err_c(),
    }
}

/// Check if a dotted key path exists. Returns 1 if yes, 0 otherwise.
#[no_mangle]
pub extern "C" fn forge_toml_has(toml_str: *const c_char, key: *const c_char) -> i64 {
    let input = cstr(toml_str);
    let key = cstr(key);
    match input.parse::<toml::Value>() {
        Ok(val) => {
            if walk_path(&val, &key).is_some() {
                1
            } else {
                0
            }
        }
        Err(_) => 0,
    }
}

/// Return a JSON array of keys at the given path (empty string = top level).
#[no_mangle]
pub extern "C" fn forge_toml_keys(toml_str: *const c_char, path: *const c_char) -> *mut c_char {
    let input = cstr(toml_str);
    let path = cstr(path);
    match input.parse::<toml::Value>() {
        Ok(val) => match walk_path(&val, &path) {
            Some(toml::Value::Table(tbl)) => {
                let keys: Vec<serde_json::Value> = tbl
                    .keys()
                    .map(|k| serde_json::Value::String(k.clone()))
                    .collect();
                to_c(&serde_json::Value::Array(keys).to_string())
            }
            _ => err_c(),
        },
        Err(_) => err_c(),
    }
}

/// Remove a key at a dotted path and return the modified TOML string.
#[no_mangle]
pub extern "C" fn forge_toml_remove(toml_str: *const c_char, key: *const c_char) -> *mut c_char {
    let input = cstr(toml_str);
    let key = cstr(key);

    let mut toml_val = match input.parse::<toml::Value>() {
        Ok(v) => v,
        Err(_) => return err_c(),
    };

    if let Some(dot_pos) = key.rfind('.') {
        let parent_path = &key[..dot_pos];
        let leaf = &key[dot_pos + 1..];
        match walk_path_mut(&mut toml_val, parent_path) {
            Some(toml::Value::Table(tbl)) => {
                tbl.remove(leaf);
            }
            _ => return err_c(),
        }
    } else {
        match &mut toml_val {
            toml::Value::Table(tbl) => {
                tbl.remove(&key);
            }
            _ => return err_c(),
        }
    }

    match toml::to_string_pretty(&toml_val) {
        Ok(s) => to_c(&s),
        Err(_) => err_c(),
    }
}
