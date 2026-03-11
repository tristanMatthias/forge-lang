use rusqlite::{Connection, params_from_iter};
use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use std::sync::Mutex;

static DB: Mutex<Option<Connection>> = Mutex::new(None);

#[no_mangle]
pub extern "C" fn forge_model_init(path: *const c_char) {
    let path = unsafe { CStr::from_ptr(path) }.to_str().unwrap();
    // Create parent directory if needed
    if let Some(parent) = std::path::Path::new(path).parent() {
        std::fs::create_dir_all(parent).ok();
    }
    let conn = Connection::open(path).expect("Failed to open database");
    conn.execute_batch("PRAGMA journal_mode=WAL;").ok();
    *DB.lock().unwrap() = Some(conn);
}

#[no_mangle]
pub extern "C" fn forge_model_exec(sql: *const c_char) -> i32 {
    let sql = unsafe { CStr::from_ptr(sql) }.to_str().unwrap();
    let db = DB.lock().unwrap();
    let conn = db.as_ref().expect("Database not initialized");
    match conn.execute_batch(sql) {
        Ok(_) => 0,
        Err(e) => {
            eprintln!("SQL error: {}", e);
            -1
        }
    }
}

/// Execute an INSERT and return last_insert_rowid
#[no_mangle]
pub extern "C" fn forge_model_insert(
    sql: *const c_char,
    param_values: *const *const c_char,
    param_count: i64,
) -> i64 {
    let sql = unsafe { CStr::from_ptr(sql) }.to_str().unwrap();
    let db = DB.lock().unwrap();
    let conn = db.as_ref().expect("Database not initialized");

    let mut params: Vec<String> = Vec::new();
    for i in 0..param_count as usize {
        let p = unsafe { *param_values.add(i) };
        let s = unsafe { CStr::from_ptr(p) }.to_str().unwrap().to_string();
        params.push(s);
    }

    let param_refs: Vec<&dyn rusqlite::types::ToSql> = params
        .iter()
        .map(|s| s as &dyn rusqlite::types::ToSql)
        .collect();

    match conn.execute(sql, param_refs.as_slice()) {
        Ok(_) => conn.last_insert_rowid(),
        Err(e) => {
            eprintln!("SQL insert error: {} | SQL: {}", e, sql);
            -1
        }
    }
}

/// Execute an UPDATE/DELETE, return rows affected
#[no_mangle]
pub extern "C" fn forge_model_update(
    sql: *const c_char,
    param_values: *const *const c_char,
    param_count: i64,
) -> i64 {
    let sql = unsafe { CStr::from_ptr(sql) }.to_str().unwrap();
    let db = DB.lock().unwrap();
    let conn = db.as_ref().expect("Database not initialized");

    let mut params: Vec<String> = Vec::new();
    for i in 0..param_count as usize {
        let p = unsafe { *param_values.add(i) };
        let s = unsafe { CStr::from_ptr(p) }.to_str().unwrap().to_string();
        params.push(s);
    }

    let param_refs: Vec<&dyn rusqlite::types::ToSql> = params
        .iter()
        .map(|s| s as &dyn rusqlite::types::ToSql)
        .collect();

    match conn.execute(sql, param_refs.as_slice()) {
        Ok(n) => n as i64,
        Err(e) => {
            eprintln!("SQL update error: {} | SQL: {}", e, sql);
            -1
        }
    }
}

/// Execute a SELECT query, return results as JSON string.
/// Caller must free the returned string with forge_model_free_string.
#[no_mangle]
pub extern "C" fn forge_model_query(
    sql: *const c_char,
    param_values: *const *const c_char,
    param_count: i64,
) -> *mut c_char {
    let sql = unsafe { CStr::from_ptr(sql) }.to_str().unwrap();
    let db = DB.lock().unwrap();
    let conn = db.as_ref().expect("Database not initialized");

    let mut params: Vec<String> = Vec::new();
    for i in 0..param_count as usize {
        let p = unsafe { *param_values.add(i) };
        let s = unsafe { CStr::from_ptr(p) }.to_str().unwrap().to_string();
        params.push(s);
    }

    let param_refs: Vec<&dyn rusqlite::types::ToSql> = params
        .iter()
        .map(|s| s as &dyn rusqlite::types::ToSql)
        .collect();

    let mut stmt = match conn.prepare(sql) {
        Ok(s) => s,
        Err(e) => {
            eprintln!("SQL prepare error: {}", e);
            return CString::new("[]").unwrap().into_raw();
        }
    };

    let col_count = stmt.column_count();
    let col_names: Vec<String> = (0..col_count)
        .map(|i| stmt.column_name(i).unwrap().to_string())
        .collect();

    let mut rows = Vec::new();
    let mut row_iter = match stmt.query(param_refs.as_slice()) {
        Ok(r) => r,
        Err(e) => {
            eprintln!("SQL query error: {}", e);
            return CString::new("[]").unwrap().into_raw();
        }
    };

    while let Ok(Some(row)) = row_iter.next() {
        let mut obj = String::from("{");
        for (i, name) in col_names.iter().enumerate() {
            if i > 0 {
                obj.push(',');
            }
            // Try to get as different types
            if let Ok(val) = row.get::<_, i64>(i) {
                obj.push_str(&format!("\"{}\":{}", name, val));
            } else if let Ok(val) = row.get::<_, f64>(i) {
                obj.push_str(&format!("\"{}\":{}", name, val));
            } else if let Ok(val) = row.get::<_, String>(i) {
                // Escape quotes in string
                let escaped = val.replace('\\', "\\\\").replace('"', "\\\"");
                obj.push_str(&format!("\"{}\":\"{}\"", name, escaped));
            } else {
                obj.push_str(&format!("\"{}\":null", name));
            }
        }
        obj.push('}');
        rows.push(obj);
    }

    let json = format!("[{}]", rows.join(","));
    CString::new(json).unwrap().into_raw()
}

/// Execute a SELECT COUNT query, return the count
#[no_mangle]
pub extern "C" fn forge_model_count(sql: *const c_char) -> i64 {
    let sql = unsafe { CStr::from_ptr(sql) }.to_str().unwrap();
    let db = DB.lock().unwrap();
    let conn = db.as_ref().expect("Database not initialized");
    match conn.query_row(sql, [], |row| row.get::<_, i64>(0)) {
        Ok(count) => count,
        Err(e) => {
            eprintln!("SQL count error: {}", e);
            -1
        }
    }
}

#[no_mangle]
pub extern "C" fn forge_model_free_string(s: *mut c_char) {
    if !s.is_null() {
        unsafe {
            drop(CString::from_raw(s));
        }
    }
}
