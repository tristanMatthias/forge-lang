use rusqlite::Connection;
use serde_json::Value;
use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use std::sync::Mutex;

static DB: Mutex<Option<Connection>> = Mutex::new(None);

fn cstr(ptr: *const c_char) -> &'static str {
    unsafe { CStr::from_ptr(ptr) }.to_str().unwrap()
}

fn json_result(s: String) -> *mut c_char {
    CString::new(s).unwrap().into_raw()
}

fn query_to_json(conn: &Connection, sql: &str, params: &[&dyn rusqlite::types::ToSql]) -> String {
    let mut stmt = match conn.prepare(sql) {
        Ok(s) => s,
        Err(e) => {
            eprintln!("SQL prepare error: {}", e);
            return "[]".to_string();
        }
    };

    let col_count = stmt.column_count();
    let col_names: Vec<String> = (0..col_count)
        .map(|i| stmt.column_name(i).unwrap().to_string())
        .collect();

    let mut rows = Vec::new();
    let mut row_iter = match stmt.query(params) {
        Ok(r) => r,
        Err(e) => {
            eprintln!("SQL query error: {}", e);
            return "[]".to_string();
        }
    };

    while let Ok(Some(row)) = row_iter.next() {
        let mut obj = String::from("{");
        for (i, name) in col_names.iter().enumerate() {
            if i > 0 {
                obj.push(',');
            }
            if let Ok(val) = row.get::<_, i64>(i) {
                obj.push_str(&format!("\"{}\":{}", name, val));
            } else if let Ok(val) = row.get::<_, f64>(i) {
                obj.push_str(&format!("\"{}\":{}", name, val));
            } else if let Ok(val) = row.get::<_, String>(i) {
                let escaped = val.replace('\\', "\\\\").replace('"', "\\\"");
                obj.push_str(&format!("\"{}\":\"{}\"", name, escaped));
            } else {
                obj.push_str(&format!("\"{}\":null", name));
            }
        }
        obj.push('}');
        rows.push(obj);
    }

    format!("[{}]", rows.join(","))
}

// ===== Core functions (kept as-is) =====

#[no_mangle]
pub extern "C" fn forge_model_init(path: *const c_char) {
    let mut db = DB.lock().unwrap();
    if db.is_some() {
        return; // Already initialized
    }
    let path = cstr(path);
    if let Some(parent) = std::path::Path::new(path).parent() {
        std::fs::create_dir_all(parent).ok();
    }
    let conn = Connection::open(path).expect("Failed to open database");
    conn.execute_batch("PRAGMA journal_mode=WAL;").ok();
    *db = Some(conn);
}

#[no_mangle]
pub extern "C" fn forge_model_exec(sql: *const c_char) -> i32 {
    let sql = cstr(sql);
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

// ===== New JSON-based API =====

#[no_mangle]
pub extern "C" fn forge_model_insert_json(
    table: *const c_char,
    data_json: *const c_char,
) -> *mut c_char {
    let table = cstr(table);
    let data_str = cstr(data_json);
    let db = DB.lock().unwrap();
    let conn = db.as_ref().expect("Database not initialized");

    let data: Value = match serde_json::from_str(data_str) {
        Ok(v) => v,
        Err(e) => {
            eprintln!("JSON parse error: {}", e);
            return json_result("null".to_string());
        }
    };

    let obj = match data.as_object() {
        Some(o) => o,
        None => {
            eprintln!("Expected JSON object for insert");
            return json_result("null".to_string());
        }
    };

    let columns: Vec<&str> = obj.keys().map(|k| k.as_str()).collect();
    let placeholders: Vec<String> = (0..columns.len()).map(|_| "?".to_string()).collect();
    let sql = format!(
        "INSERT INTO {} ({}) VALUES ({})",
        table,
        columns.join(", "),
        placeholders.join(", ")
    );

    let values: Vec<String> = obj
        .values()
        .map(|v| match v {
            Value::String(s) => s.clone(),
            Value::Number(n) => n.to_string(),
            Value::Bool(b) => if *b { "1".to_string() } else { "0".to_string() },
            Value::Null => "NULL".to_string(),
            other => other.to_string(),
        })
        .collect();

    let param_refs: Vec<&dyn rusqlite::types::ToSql> = values
        .iter()
        .map(|s| s as &dyn rusqlite::types::ToSql)
        .collect();

    match conn.execute(&sql, param_refs.as_slice()) {
        Ok(_) => {
            let rowid = conn.last_insert_rowid();
            let select_sql = format!("SELECT * FROM {} WHERE rowid = ?", table);
            let result = query_to_json(conn, &select_sql, &[&rowid as &dyn rusqlite::types::ToSql]);
            // Unwrap array to single object
            if result.starts_with('[') && result.ends_with(']') {
                let inner = &result[1..result.len() - 1];
                if !inner.is_empty() {
                    return json_result(inner.to_string());
                }
            }
            json_result(result)
        }
        Err(e) => {
            eprintln!("SQL insert error: {} | SQL: {}", e, sql);
            json_result("null".to_string())
        }
    }
}

#[no_mangle]
pub extern "C" fn forge_model_get_by_id(
    table: *const c_char,
    id: i64,
) -> *mut c_char {
    let table = cstr(table);
    let db = DB.lock().unwrap();
    let conn = db.as_ref().expect("Database not initialized");

    let sql = format!("SELECT * FROM {} WHERE id = ?", table);
    let result = query_to_json(conn, &sql, &[&id as &dyn rusqlite::types::ToSql]);
    // Unwrap to single object or null
    if result.starts_with('[') && result.ends_with(']') {
        let inner = &result[1..result.len() - 1];
        if inner.is_empty() {
            return json_result("null".to_string());
        }
        return json_result(inner.to_string());
    }
    json_result(result)
}

#[no_mangle]
pub extern "C" fn forge_model_update_json(
    table: *const c_char,
    id: i64,
    changes_json: *const c_char,
) -> *mut c_char {
    let table = cstr(table);
    let changes_str = cstr(changes_json);
    let db = DB.lock().unwrap();
    let conn = db.as_ref().expect("Database not initialized");

    let changes: Value = match serde_json::from_str(changes_str) {
        Ok(v) => v,
        Err(e) => {
            eprintln!("JSON parse error: {}", e);
            return json_result("null".to_string());
        }
    };

    let obj = match changes.as_object() {
        Some(o) => o,
        None => {
            eprintln!("Expected JSON object for update");
            return json_result("null".to_string());
        }
    };

    let set_clauses: Vec<String> = obj.keys().map(|k| format!("{} = ?", k)).collect();
    let sql = format!("UPDATE {} SET {} WHERE id = ?", table, set_clauses.join(", "));

    let mut values: Vec<String> = obj
        .values()
        .map(|v| match v {
            Value::String(s) => s.clone(),
            Value::Number(n) => n.to_string(),
            Value::Bool(b) => if *b { "1".to_string() } else { "0".to_string() },
            Value::Null => "NULL".to_string(),
            other => other.to_string(),
        })
        .collect();
    values.push(id.to_string());

    let param_refs: Vec<&dyn rusqlite::types::ToSql> = values
        .iter()
        .map(|s| s as &dyn rusqlite::types::ToSql)
        .collect();

    match conn.execute(&sql, param_refs.as_slice()) {
        Ok(_) => {
            // Return updated record
            let select_sql = format!("SELECT * FROM {} WHERE id = ?", table);
            let result = query_to_json(conn, &select_sql, &[&id as &dyn rusqlite::types::ToSql]);
            if result.starts_with('[') && result.ends_with(']') {
                let inner = &result[1..result.len() - 1];
                if !inner.is_empty() {
                    return json_result(inner.to_string());
                }
            }
            json_result(result)
        }
        Err(e) => {
            eprintln!("SQL update error: {} | SQL: {}", e, sql);
            json_result("null".to_string())
        }
    }
}

#[no_mangle]
pub extern "C" fn forge_model_list_json(
    table: *const c_char,
    filter_json: *const c_char,
) -> *mut c_char {
    let table = cstr(table);
    let filter_str = cstr(filter_json);
    let db = DB.lock().unwrap();
    let conn = db.as_ref().expect("Database not initialized");

    if filter_str.is_empty() || filter_str == "{}" || filter_str == "null" {
        let sql = format!("SELECT * FROM {}", table);
        return json_result(query_to_json(conn, &sql, &[]));
    }

    let filter: Value = match serde_json::from_str(filter_str) {
        Ok(v) => v,
        Err(_) => {
            let sql = format!("SELECT * FROM {}", table);
            return json_result(query_to_json(conn, &sql, &[]));
        }
    };

    if let Some(obj) = filter.as_object() {
        if obj.is_empty() {
            let sql = format!("SELECT * FROM {}", table);
            return json_result(query_to_json(conn, &sql, &[]));
        }

        let where_clauses: Vec<String> = obj.keys().map(|k| format!("{} = ?", k)).collect();
        let sql = format!("SELECT * FROM {} WHERE {}", table, where_clauses.join(" AND "));

        let values: Vec<String> = obj
            .values()
            .map(|v| match v {
                Value::String(s) => s.clone(),
                Value::Number(n) => n.to_string(),
                Value::Bool(b) => if *b { "1".to_string() } else { "0".to_string() },
                other => other.to_string(),
            })
            .collect();

        let param_refs: Vec<&dyn rusqlite::types::ToSql> = values
            .iter()
            .map(|s| s as &dyn rusqlite::types::ToSql)
            .collect();

        json_result(query_to_json(conn, &sql, param_refs.as_slice()))
    } else {
        let sql = format!("SELECT * FROM {}", table);
        json_result(query_to_json(conn, &sql, &[]))
    }
}

#[no_mangle]
pub extern "C" fn forge_model_delete_json(
    table: *const c_char,
    id: i64,
) -> i64 {
    let table = cstr(table);
    let db = DB.lock().unwrap();
    let conn = db.as_ref().expect("Database not initialized");

    let sql = format!("DELETE FROM {} WHERE id = ?", table);
    match conn.execute(&sql, [&id as &dyn rusqlite::types::ToSql]) {
        Ok(n) => n as i64,
        Err(e) => {
            eprintln!("SQL delete error: {}", e);
            -1
        }
    }
}

#[no_mangle]
pub extern "C" fn forge_model_count_json(
    table: *const c_char,
    filter_json: *const c_char,
) -> i64 {
    let table = cstr(table);
    let filter_str = cstr(filter_json);
    let db = DB.lock().unwrap();
    let conn = db.as_ref().expect("Database not initialized");

    if filter_str.is_empty() || filter_str == "{}" || filter_str == "null" {
        let sql = format!("SELECT COUNT(*) FROM {}", table);
        return conn.query_row(&sql, [], |row| row.get::<_, i64>(0)).unwrap_or(-1);
    }

    let filter: Value = match serde_json::from_str(filter_str) {
        Ok(v) => v,
        Err(_) => {
            let sql = format!("SELECT COUNT(*) FROM {}", table);
            return conn.query_row(&sql, [], |row| row.get::<_, i64>(0)).unwrap_or(-1);
        }
    };

    if let Some(obj) = filter.as_object() {
        if obj.is_empty() {
            let sql = format!("SELECT COUNT(*) FROM {}", table);
            return conn.query_row(&sql, [], |row| row.get::<_, i64>(0)).unwrap_or(-1);
        }

        let where_clauses: Vec<String> = obj.keys().map(|k| format!("{} = ?", k)).collect();
        let sql = format!("SELECT COUNT(*) FROM {} WHERE {}", table, where_clauses.join(" AND "));

        let values: Vec<String> = obj
            .values()
            .map(|v| match v {
                Value::String(s) => s.clone(),
                Value::Number(n) => n.to_string(),
                Value::Bool(b) => if *b { "1".to_string() } else { "0".to_string() },
                other => other.to_string(),
            })
            .collect();

        let param_refs: Vec<&dyn rusqlite::types::ToSql> = values
            .iter()
            .map(|s| s as &dyn rusqlite::types::ToSql)
            .collect();

        conn.query_row(&sql, param_refs.as_slice(), |row| row.get::<_, i64>(0))
            .unwrap_or(-1)
    } else {
        let sql = format!("SELECT COUNT(*) FROM {}", table);
        conn.query_row(&sql, [], |row| row.get::<_, i64>(0)).unwrap_or(-1)
    }
}

/// Create a table from a JSON schema definition.
/// schema_json format: [{"name":"id","type":"int","annotations":[{"name":"primary"},{"name":"auto_increment"}]}, ...]
/// This keeps all SQL type mapping knowledge inside the provider, not the compiler.
#[no_mangle]
pub extern "C" fn forge_model_create_table(
    table: *const c_char,
    schema_json: *const c_char,
) -> i32 {
    let table = cstr(table);
    let schema_str = cstr(schema_json);
    let db = DB.lock().unwrap();
    let conn = db.as_ref().expect("Database not initialized");

    let schema: Vec<Value> = match serde_json::from_str(schema_str) {
        Ok(v) => v,
        Err(e) => {
            eprintln!("Schema JSON parse error: {}", e);
            return -1;
        }
    };

    let mut cols = Vec::new();
    for field in &schema {
        let name = field["name"].as_str().unwrap_or("unknown");
        let forge_type = field["type"].as_str().unwrap_or("string");
        let sql_type = match forge_type {
            "int" => "INTEGER",
            "float" => "REAL",
            "bool" => "INTEGER",
            _ => "TEXT",
        };

        let mut col = format!("{} {}", name, sql_type);

        if let Some(anns) = field["annotations"].as_array() {
            for ann in anns {
                if let Some(ann_name) = ann["name"].as_str() {
                    match ann_name {
                        "primary" => col.push_str(" PRIMARY KEY"),
                        "auto_increment" => col.push_str(" AUTOINCREMENT"),
                        "unique" => col.push_str(" UNIQUE"),
                        "default" => {
                            if let Some(args) = ann["args"].as_array() {
                                if let Some(arg) = args.first() {
                                    if let Some(b) = arg.as_bool() {
                                        col.push_str(&format!(" DEFAULT {}", if b { 1 } else { 0 }));
                                    } else if let Some(n) = arg.as_i64() {
                                        col.push_str(&format!(" DEFAULT {}", n));
                                    } else if let Some(s) = arg.as_str() {
                                        col.push_str(&format!(" DEFAULT '{}'", s));
                                    }
                                }
                            }
                        }
                        _ => {}
                    }
                }
            }
        }

        cols.push(col);
    }

    let sql = format!("CREATE TABLE IF NOT EXISTS {} ({})", table, cols.join(", "));
    match conn.execute_batch(&sql) {
        Ok(_) => 0,
        Err(e) => {
            eprintln!("SQL create table error: {}", e);
            -1
        }
    }
}

// ===== Legacy API (kept for backward compatibility during transition) =====

#[no_mangle]
pub extern "C" fn forge_model_insert(
    sql: *const c_char,
    param_values: *const *const c_char,
    param_count: i64,
) -> i64 {
    let sql = cstr(sql);
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

#[no_mangle]
pub extern "C" fn forge_model_update(
    sql: *const c_char,
    param_values: *const *const c_char,
    param_count: i64,
) -> i64 {
    let sql = cstr(sql);
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

#[no_mangle]
pub extern "C" fn forge_model_query(
    sql: *const c_char,
    param_values: *const *const c_char,
    param_count: i64,
) -> *mut c_char {
    let sql = cstr(sql);
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

    json_result(query_to_json(conn, sql, param_refs.as_slice()))
}

#[no_mangle]
pub extern "C" fn forge_model_count(sql: *const c_char) -> i64 {
    let sql = cstr(sql);
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
