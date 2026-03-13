use rusqlite::Connection;
use serde_json::Value;
use std::collections::HashMap;
use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use std::sync::Mutex;

static DB: Mutex<Option<Connection>> = Mutex::new(None);

/// Per-table schema storage for validation
/// Maps table_name -> Vec<FieldSchema>
static SCHEMAS: Mutex<Option<HashMap<String, Vec<FieldSchema>>>> = Mutex::new(None);

/// Per-table hidden field names (fields with @hidden annotation)
/// Maps table_name -> Vec<field_name>
static HIDDEN_FIELDS: Mutex<Option<HashMap<String, Vec<String>>>> = Mutex::new(None);

#[derive(Debug, Clone)]
struct FieldSchema {
    name: String,
    field_type: String,
    annotations: Vec<FieldAnnotation>,
}

#[derive(Debug, Clone)]
struct FieldAnnotation {
    name: String,
    args: Vec<Value>,
}

struct ValidationError {
    field: String,
    rule: String,
    message: String,
}

fn validate_field(schema: &FieldSchema, value: &Value) -> Vec<ValidationError> {
    let mut errors = Vec::new();
    for ann in &schema.annotations {
        match ann.name.as_str() {
            "min" => {
                if let Some(min_val) = ann.args.first().and_then(|a| a.as_i64()) {
                    match &schema.field_type[..] {
                        "string" => {
                            let len = value.as_str().map(|s| s.len() as i64).unwrap_or(0);
                            if len < min_val {
                                errors.push(ValidationError {
                                    field: schema.name.clone(),
                                    rule: "min".to_string(),
                                    message: format!(
                                        "{} must be at least {} characters, got {}",
                                        schema.name, min_val, len
                                    ),
                                });
                            }
                        }
                        "int" | "float" => {
                            let num = value.as_i64().or_else(|| value.as_f64().map(|f| f as i64)).unwrap_or(0);
                            if num < min_val {
                                errors.push(ValidationError {
                                    field: schema.name.clone(),
                                    rule: "min".to_string(),
                                    message: format!(
                                        "{} must be at least {}, got {}",
                                        schema.name, min_val, num
                                    ),
                                });
                            }
                        }
                        _ => {}
                    }
                }
            }
            "max" => {
                if let Some(max_val) = ann.args.first().and_then(|a| a.as_i64()) {
                    match &schema.field_type[..] {
                        "string" => {
                            let len = value.as_str().map(|s| s.len() as i64).unwrap_or(0);
                            if len > max_val {
                                errors.push(ValidationError {
                                    field: schema.name.clone(),
                                    rule: "max".to_string(),
                                    message: format!(
                                        "{} must be at most {} characters, got {}",
                                        schema.name, max_val, len
                                    ),
                                });
                            }
                        }
                        "int" | "float" => {
                            let num = value.as_i64().or_else(|| value.as_f64().map(|f| f as i64)).unwrap_or(0);
                            if num > max_val {
                                errors.push(ValidationError {
                                    field: schema.name.clone(),
                                    rule: "max".to_string(),
                                    message: format!(
                                        "{} must be at most {}, got {}",
                                        schema.name, max_val, num
                                    ),
                                });
                            }
                        }
                        _ => {}
                    }
                }
            }
            "validate" => {
                if let Some(validator_name) = ann.args.first().and_then(|a| a.as_str()) {
                    match validator_name {
                        "email" => {
                            if let Some(s) = value.as_str() {
                                if !s.contains('@') || !s.contains('.') {
                                    errors.push(ValidationError {
                                        field: schema.name.clone(),
                                        rule: "email".to_string(),
                                        message: format!("{} must be a valid email address", schema.name),
                                    });
                                }
                            }
                        }
                        _ => {}
                    }
                }
            }
            _ => {}
        }
    }
    errors
}

fn validate_data(table: &str, data: &Value) -> Vec<ValidationError> {
    let schemas = SCHEMAS.lock().unwrap();
    let schemas = match schemas.as_ref() {
        Some(s) => s,
        None => return Vec::new(),
    };
    let field_schemas = match schemas.get(table) {
        Some(fs) => fs,
        None => return Vec::new(),
    };

    let obj = match data.as_object() {
        Some(o) => o,
        None => return Vec::new(),
    };

    let mut errors = Vec::new();
    for fs in field_schemas {
        if let Some(value) = obj.get(&fs.name) {
            errors.extend(validate_field(fs, value));
        }
    }
    errors
}

fn format_validation_errors(errors: &[ValidationError]) -> String {
    let fields: Vec<String> = errors.iter().map(|e| {
        format!(r#"{{"field":"{}","rule":"{}","message":"{}"}}"#, e.field, e.rule, e.message)
    }).collect();
    format!(r#"{{"__validation_error":true,"error":"validation failed","fields":[{}]}}"#, fields.join(","))
}

fn cstr(ptr: *const c_char) -> &'static str {
    unsafe { CStr::from_ptr(ptr) }.to_str().unwrap()
}

/// Get hidden field names for a table
fn get_hidden_fields(table: &str) -> Vec<String> {
    let guard = HIDDEN_FIELDS.lock().unwrap();
    guard.as_ref()
        .and_then(|m| m.get(table))
        .cloned()
        .unwrap_or_default()
}

/// Strip hidden fields from a JSON object string like {"id":1,"password":"secret","name":"alice"}
fn strip_hidden_from_json_obj(json: &str, hidden: &[String]) -> String {
    if hidden.is_empty() || json.is_empty() || json == "null" {
        return json.to_string();
    }
    // Parse and re-serialize without hidden fields
    if let Ok(Value::Object(mut map)) = serde_json::from_str::<Value>(json) {
        for field in hidden {
            map.remove(field);
        }
        serde_json::to_string(&Value::Object(map)).unwrap_or_else(|_| json.to_string())
    } else {
        json.to_string()
    }
}

/// Strip hidden fields from a JSON array string
fn strip_hidden_from_json_array(json: &str, hidden: &[String]) -> String {
    if hidden.is_empty() || json.is_empty() || json == "[]" {
        return json.to_string();
    }
    if let Ok(Value::Array(arr)) = serde_json::from_str::<Value>(json) {
        let filtered: Vec<Value> = arr.into_iter().map(|v| {
            if let Value::Object(mut map) = v {
                for field in hidden {
                    map.remove(field);
                }
                Value::Object(map)
            } else {
                v
            }
        }).collect();
        serde_json::to_string(&filtered).unwrap_or_else(|_| json.to_string())
    } else {
        json.to_string()
    }
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

    // Validate data against schema annotations
    let validation_errors = validate_data(table, &data);
    if !validation_errors.is_empty() {
        return json_result(format_validation_errors(&validation_errors));
    }

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
                    let hidden = get_hidden_fields(table);
                    return json_result(strip_hidden_from_json_obj(inner, &hidden));
                }
            }
            json_result(result)
        }
        Err(e) => {
            let err_msg = e.to_string();
            if err_msg.contains("UNIQUE constraint failed") {
                let field = err_msg.split('.').last().unwrap_or("unknown").to_string();
                let ve = vec![ValidationError {
                    field: field.clone(),
                    rule: "unique".to_string(),
                    message: format!("{} already exists", field),
                }];
                json_result(format_validation_errors(&ve))
            } else {
                json_result("null".to_string())
            }
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
        let hidden = get_hidden_fields(table);
        return json_result(strip_hidden_from_json_obj(inner, &hidden));
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

    // Validate changes against schema annotations
    let validation_errors = validate_data(table, &changes);
    if !validation_errors.is_empty() {
        return json_result(format_validation_errors(&validation_errors));
    }

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
                    let hidden = get_hidden_fields(table);
                    return json_result(strip_hidden_from_json_obj(inner, &hidden));
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

    let hidden = get_hidden_fields(table);

    if filter_str.is_empty() || filter_str == "{}" || filter_str == "null" {
        let sql = format!("SELECT * FROM {}", table);
        let result = query_to_json(conn, &sql, &[]);
        return json_result(strip_hidden_from_json_array(&result, &hidden));
    }

    let filter: Value = match serde_json::from_str(filter_str) {
        Ok(v) => v,
        Err(_) => {
            let sql = format!("SELECT * FROM {}", table);
            let result = query_to_json(conn, &sql, &[]);
            return json_result(strip_hidden_from_json_array(&result, &hidden));
        }
    };

    if let Some(obj) = filter.as_object() {
        if obj.is_empty() {
            let sql = format!("SELECT * FROM {}", table);
            let result = query_to_json(conn, &sql, &[]);
            return json_result(strip_hidden_from_json_array(&result, &hidden));
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

        let result = query_to_json(conn, &sql, param_refs.as_slice());
        json_result(strip_hidden_from_json_array(&result, &hidden))
    } else {
        let sql = format!("SELECT * FROM {}", table);
        let result = query_to_json(conn, &sql, &[]);
        json_result(strip_hidden_from_json_array(&result, &hidden))
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

/// Get a related record: looks up foreign_table where foreign_table.id = record.foreign_key_value
/// E.g., forge_model_get_related("posts", 1, "author_id", "users") → the user who authored post 1
#[no_mangle]
pub extern "C" fn forge_model_get_related(
    table: *const c_char,
    id: i64,
    foreign_key: *const c_char,
    related_table: *const c_char,
) -> *mut c_char {
    let table = cstr(table);
    let foreign_key = cstr(foreign_key);
    let related_table = cstr(related_table);
    let db = DB.lock().unwrap();
    let conn = db.as_ref().expect("Database not initialized");

    // First get the foreign key value from the source record
    let fk_sql = format!("SELECT {} FROM {} WHERE id = ?", foreign_key, table);
    let fk_value: Option<i64> = conn
        .query_row(&fk_sql, [&id as &dyn rusqlite::types::ToSql], |row| row.get(0))
        .ok();

    match fk_value {
        Some(fk_id) => {
            let sql = format!("SELECT * FROM {} WHERE id = ?", related_table);
            let result = query_to_json(conn, &sql, &[&fk_id as &dyn rusqlite::types::ToSql]);
            if result.starts_with('[') && result.ends_with(']') {
                let inner = &result[1..result.len() - 1];
                if inner.is_empty() {
                    return json_result("null".to_string());
                }
                return json_result(inner.to_string());
            }
            json_result(result)
        }
        None => json_result("null".to_string()),
    }
}

/// Get related records (has_many): looks up related_table where related_table.foreign_key = id
/// E.g., forge_model_get_related_many("users", 1, "author_id", "posts") → all posts by user 1
#[no_mangle]
pub extern "C" fn forge_model_get_related_many(
    _table: *const c_char,
    id: i64,
    foreign_key: *const c_char,
    related_table: *const c_char,
) -> *mut c_char {
    let foreign_key = cstr(foreign_key);
    let related_table = cstr(related_table);
    let db = DB.lock().unwrap();
    let conn = db.as_ref().expect("Database not initialized");

    let sql = format!("SELECT * FROM {} WHERE {} = ?", related_table, foreign_key);
    json_result(query_to_json(conn, &sql, &[&id as &dyn rusqlite::types::ToSql]))
}

/// Query with filter, order, limit, and offset — returns JSON array.
/// query_json is a JSON object with optional keys:
///   "where": { field: value, ... }
///   "order": "field" or "field DESC"
///   "limit": N
///   "offset": N
#[no_mangle]
pub extern "C" fn forge_model_query_json(
    table: *const c_char,
    query_json: *const c_char,
) -> *mut c_char {
    let table = cstr(table);
    let query_str = cstr(query_json);
    let db = DB.lock().unwrap();
    let conn = db.as_ref().expect("Database not initialized");

    let query: Value = match serde_json::from_str(query_str) {
        Ok(v) => v,
        Err(_) => {
            let sql = format!("SELECT * FROM {}", table);
            return json_result(query_to_json(conn, &sql, &[]));
        }
    };

    let mut sql = format!("SELECT * FROM {}", table);
    let mut values: Vec<String> = Vec::new();

    // WHERE clause (supports query operators: $gt, $gte, $lt, $lte, $like, $ne, $between)
    if let Some(where_obj) = query.get("where") {
        let where_str = serde_json::to_string(where_obj).unwrap_or_default();
        let (wc, wv) = build_where_clause(&where_str);
        sql.push_str(&wc);
        values.extend(wv);
    }

    // ORDER BY
    if let Some(order) = query.get("order").and_then(|o| o.as_str()) {
        sql.push_str(&format!(" ORDER BY {}", order));
    }

    // LIMIT
    if let Some(limit) = query.get("limit").and_then(|l| l.as_i64()) {
        sql.push_str(&format!(" LIMIT {}", limit));
    }

    // OFFSET
    if let Some(offset) = query.get("offset").and_then(|o| o.as_i64()) {
        sql.push_str(&format!(" OFFSET {}", offset));
    }

    let param_refs: Vec<&dyn rusqlite::types::ToSql> = values
        .iter()
        .map(|s| s as &dyn rusqlite::types::ToSql)
        .collect();

    let hidden = get_hidden_fields(table);
    let result = query_to_json(conn, &sql, param_refs.as_slice());
    json_result(strip_hidden_from_json_array(&result, &hidden))
}

/// Find the first record matching a filter, return as single JSON object or "null"
#[no_mangle]
pub extern "C" fn forge_model_find_by_json(
    table: *const c_char,
    filter_json: *const c_char,
) -> *mut c_char {
    let table = cstr(table);
    let filter_str = cstr(filter_json);
    let db = DB.lock().unwrap();
    let conn = db.as_ref().expect("Database not initialized");

    let filter: Value = match serde_json::from_str(filter_str) {
        Ok(v) => v,
        Err(_) => return json_result("null".to_string()),
    };

    if let Some(obj) = filter.as_object() {
        if obj.is_empty() {
            return json_result("null".to_string());
        }

        let where_clauses: Vec<String> = obj.keys().map(|k| format!("{} = ?", k)).collect();
        let sql = format!("SELECT * FROM {} WHERE {} LIMIT 1", table, where_clauses.join(" AND "));

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

        let result = query_to_json(conn, &sql, param_refs.as_slice());
        // Unwrap to single object or null
        if result.starts_with('[') && result.ends_with(']') {
            let inner = &result[1..result.len() - 1];
            if inner.is_empty() {
                return json_result("null".to_string());
            }
            let hidden = get_hidden_fields(table);
            return json_result(strip_hidden_from_json_obj(inner, &hidden));
        }
        json_result(result)
    } else {
        json_result("null".to_string())
    }
}

/// Aggregate: SUM of a column
#[no_mangle]
pub extern "C" fn forge_model_sum_json(table: *const c_char, column: *const c_char, filter_json: *const c_char) -> f64 {
    let table = cstr(table);
    let column = cstr(column);
    let filter_str = cstr(filter_json);
    let db = DB.lock().unwrap();
    let conn = db.as_ref().expect("DB not init");
    let (wc, vals) = build_where_clause(filter_str);
    let sql = format!("SELECT COALESCE(SUM({}), 0) FROM {}{}", column, table, wc);
    let pr: Vec<&dyn rusqlite::types::ToSql> = vals.iter().map(|s| s as &dyn rusqlite::types::ToSql).collect();
    conn.query_row(&sql, pr.as_slice(), |r| r.get::<_, f64>(0)).unwrap_or(0.0)
}

/// Aggregate: AVG of a column
#[no_mangle]
pub extern "C" fn forge_model_avg_json(table: *const c_char, column: *const c_char, filter_json: *const c_char) -> f64 {
    let table = cstr(table);
    let column = cstr(column);
    let filter_str = cstr(filter_json);
    let db = DB.lock().unwrap();
    let conn = db.as_ref().expect("DB not init");
    let (wc, vals) = build_where_clause(filter_str);
    let sql = format!("SELECT COALESCE(AVG({}), 0) FROM {}{}", column, table, wc);
    let pr: Vec<&dyn rusqlite::types::ToSql> = vals.iter().map(|s| s as &dyn rusqlite::types::ToSql).collect();
    conn.query_row(&sql, pr.as_slice(), |r| r.get::<_, f64>(0)).unwrap_or(0.0)
}

/// Health check
#[no_mangle]
pub extern "C" fn forge_model_health() -> i64 {
    let db = DB.lock().unwrap();
    match db.as_ref() {
        Some(conn) => conn.query_row("SELECT 1", [], |r| r.get::<_, i64>(0)).unwrap_or(0),
        None => 0,
    }
}

/// Paginated query
#[no_mangle]
pub extern "C" fn forge_model_paginate_json(
    table: *const c_char, filter_json: *const c_char,
    page: i64, per_page: i64, order: *const c_char,
) -> *mut c_char {
    let table = cstr(table);
    let filter_str = cstr(filter_json);
    let order_str = cstr(order);
    let db = DB.lock().unwrap();
    let conn = db.as_ref().expect("DB not init");
    let (wc, vals) = build_where_clause(filter_str);
    let pr: Vec<&dyn rusqlite::types::ToSql> = vals.iter().map(|s| s as &dyn rusqlite::types::ToSql).collect();
    let total = conn.query_row(&format!("SELECT COUNT(*) FROM {}{}", table, wc), pr.as_slice(), |r| r.get::<_, i64>(0)).unwrap_or(0);
    let total_pages = if per_page > 0 { (total + per_page - 1) / per_page } else { 1 };
    let offset = (page - 1) * per_page;
    let mut dsql = format!("SELECT * FROM {}{}", table, wc);
    if !order_str.is_empty() { dsql.push_str(&format!(" ORDER BY {}", order_str)); }
    dsql.push_str(&format!(" LIMIT {} OFFSET {}", per_page, offset));
    let pr2: Vec<&dyn rusqlite::types::ToSql> = vals.iter().map(|s| s as &dyn rusqlite::types::ToSql).collect();
    let data = query_to_json(conn, &dsql, pr2.as_slice());
    json_result(format!(r#"{{"data":{},"total":{},"current_page":{},"per_page":{},"total_pages":{},"has_next":{},"has_prev":{}}}"#,
        data, total, page, per_page, total_pages, page < total_pages, page > 1))
}

fn build_where_clause(filter_str: &str) -> (String, Vec<String>) {
    if filter_str.is_empty() || filter_str == "{}" || filter_str == "null" {
        return (String::new(), Vec::new());
    }
    let filter: Value = match serde_json::from_str(filter_str) {
        Ok(v) => v, Err(_) => return (String::new(), Vec::new()),
    };
    if let Some(obj) = filter.as_object() {
        if obj.is_empty() { return (String::new(), Vec::new()); }
        let mut clauses = Vec::new();
        let mut values = Vec::new();
        for (k, v) in obj {
            if let Some(op) = v.as_object() {
                if let Some(val) = op.get("$gt") { clauses.push(format!("{} > ?", k)); values.push(jv(val)); }
                else if let Some(val) = op.get("$gte") { clauses.push(format!("{} >= ?", k)); values.push(jv(val)); }
                else if let Some(val) = op.get("$lt") { clauses.push(format!("{} < ?", k)); values.push(jv(val)); }
                else if let Some(val) = op.get("$lte") { clauses.push(format!("{} <= ?", k)); values.push(jv(val)); }
                else if let Some(val) = op.get("$like") { clauses.push(format!("{} LIKE ?", k)); values.push(jv(val)); }
                else if let Some(val) = op.get("$ne") { clauses.push(format!("{} != ?", k)); values.push(jv(val)); }
                else if let Some(arr) = op.get("$between").and_then(|b| b.as_array()) {
                    if arr.len() == 2 { clauses.push(format!("{} BETWEEN ? AND ?", k)); values.push(jv(&arr[0])); values.push(jv(&arr[1])); }
                }
            } else {
                clauses.push(format!("{} = ?", k)); values.push(jv(v));
            }
        }
        if clauses.is_empty() { return (String::new(), Vec::new()); }
        (format!(" WHERE {}", clauses.join(" AND ")), values)
    } else { (String::new(), Vec::new()) }
}

fn jv(v: &Value) -> String {
    match v {
        Value::String(s) => s.clone(),
        Value::Number(n) => n.to_string(),
        Value::Bool(b) => if *b { "1".to_string() } else { "0".to_string() },
        other => other.to_string(),
    }
}

/// Full-text search across specified columns using LIKE
/// search_json format: {"columns": ["title", "body"], "query": "search term", "where": {...}, "order": "...", "limit": N}
#[no_mangle]
pub extern "C" fn forge_model_search_json(
    table: *const c_char,
    search_json: *const c_char,
) -> *mut c_char {
    let table = cstr(table);
    let search_str = cstr(search_json);
    let db = DB.lock().unwrap();
    let conn = db.as_ref().expect("DB not init");

    let search: Value = match serde_json::from_str(search_str) {
        Ok(v) => v,
        Err(_) => return json_result("[]".to_string()),
    };

    let query_term = search.get("query").and_then(|q| q.as_str()).unwrap_or("");
    let columns = search.get("columns").and_then(|c| c.as_array()).cloned().unwrap_or_default();

    let mut sql = format!("SELECT * FROM {}", table);
    let mut values: Vec<String> = Vec::new();
    let mut conditions: Vec<String> = Vec::new();

    // WHERE from filter
    if let Some(where_obj) = search.get("where") {
        let where_str = serde_json::to_string(where_obj).unwrap_or_default();
        let (wc, wv) = build_where_clause(&where_str);
        if !wc.is_empty() {
            // Strip leading " WHERE " to use in combined clause
            conditions.push(wc.trim_start_matches(" WHERE ").to_string());
            values.extend(wv);
        }
    }

    // Search LIKE conditions (OR across columns)
    if !query_term.is_empty() && !columns.is_empty() {
        let like_clauses: Vec<String> = columns.iter()
            .filter_map(|c| c.as_str())
            .map(|c| { values.push(format!("%{}%", query_term)); format!("{} LIKE ?", c) })
            .collect();
        if !like_clauses.is_empty() {
            conditions.push(format!("({})", like_clauses.join(" OR ")));
        }
    }

    if !conditions.is_empty() {
        sql.push_str(&format!(" WHERE {}", conditions.join(" AND ")));
    }

    if let Some(order) = search.get("order").and_then(|o| o.as_str()) {
        sql.push_str(&format!(" ORDER BY {}", order));
    }
    if let Some(limit) = search.get("limit").and_then(|l| l.as_i64()) {
        sql.push_str(&format!(" LIMIT {}", limit));
    }

    let pr: Vec<&dyn rusqlite::types::ToSql> = values.iter().map(|s| s as &dyn rusqlite::types::ToSql).collect();
    json_result(query_to_json(conn, &sql, pr.as_slice()))
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

    // Store schema for validation
    {
        let mut schemas = SCHEMAS.lock().unwrap();
        if schemas.is_none() {
            *schemas = Some(HashMap::new());
        }
        let schemas = schemas.as_mut().unwrap();
        let mut field_schemas = Vec::new();
        for field in &schema {
            let name = field["name"].as_str().unwrap_or("unknown").to_string();
            let field_type = field["type"].as_str().unwrap_or("string").to_string();
            let mut annotations = Vec::new();
            if let Some(anns) = field["annotations"].as_array() {
                for ann in anns {
                    let ann_name = ann["name"].as_str().unwrap_or("").to_string();
                    let args = ann["args"].as_array().cloned().unwrap_or_default();
                    annotations.push(FieldAnnotation { name: ann_name, args });
                }
            }
            field_schemas.push(FieldSchema { name, field_type, annotations });
        }
        // Register hidden fields
        let hidden: Vec<String> = field_schemas.iter()
            .filter(|fs| fs.annotations.iter().any(|a| a.name == "hidden"))
            .map(|fs| fs.name.clone())
            .collect();
        if !hidden.is_empty() {
            let mut hf = HIDDEN_FIELDS.lock().unwrap();
            if hf.is_none() {
                *hf = Some(HashMap::new());
            }
            hf.as_mut().unwrap().insert(table.to_string(), hidden);
        }

        schemas.insert(table.to_string(), field_schemas);
    }

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
pub extern "C" fn forge_model_delete_where(
    table: *const c_char,
    filter_json: *const c_char,
) -> i64 {
    let table = cstr(table);
    let filter_str = cstr(filter_json);
    let db = DB.lock().unwrap();
    let conn = db.as_ref().expect("Database not initialized");

    let (wc, vals) = build_where_clause(filter_str);
    if wc.is_empty() {
        return 0; // Don't allow deleting all records without filter
    }
    let sql = format!("DELETE FROM {}{}", table, wc);
    let pr: Vec<&dyn rusqlite::types::ToSql> = vals.iter().map(|s| s as &dyn rusqlite::types::ToSql).collect();
    match conn.execute(&sql, pr.as_slice()) {
        Ok(n) => n as i64,
        Err(e) => {
            eprintln!("SQL delete_where error: {}", e);
            -1
        }
    }
}

#[no_mangle]
pub extern "C" fn forge_model_upsert_json(
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
        None => return json_result("null".to_string()),
    };

    // Validate
    let validation_errors = validate_data(table, &data);
    if !validation_errors.is_empty() {
        return json_result(format_validation_errors(&validation_errors));
    }

    let columns: Vec<&str> = obj.keys().map(|k| k.as_str()).collect();
    let placeholders: Vec<String> = (0..columns.len()).map(|_| "?".to_string()).collect();
    let sql = format!(
        "INSERT OR REPLACE INTO {} ({}) VALUES ({})",
        table, columns.join(", "), placeholders.join(", ")
    );

    let values: Vec<String> = obj.values().map(|v| jv(v)).collect();
    let param_refs: Vec<&dyn rusqlite::types::ToSql> = values.iter().map(|s| s as &dyn rusqlite::types::ToSql).collect();

    match conn.execute(&sql, param_refs.as_slice()) {
        Ok(_) => {
            let rowid = conn.last_insert_rowid();
            let select_sql = format!("SELECT * FROM {} WHERE rowid = ?", table);
            let result = query_to_json(conn, &select_sql, &[&rowid as &dyn rusqlite::types::ToSql]);
            if result.starts_with('[') && result.ends_with(']') {
                let inner = &result[1..result.len() - 1];
                if !inner.is_empty() {
                    let hidden = get_hidden_fields(table);
                    return json_result(strip_hidden_from_json_obj(inner, &hidden));
                }
            }
            json_result(result)
        }
        Err(e) => {
            eprintln!("SQL upsert error: {}", e);
            json_result("null".to_string())
        }
    }
}

#[no_mangle]
pub extern "C" fn forge_model_exists(
    table: *const c_char,
    filter_json: *const c_char,
) -> i64 {
    let table = cstr(table);
    let filter_str = cstr(filter_json);
    let db = DB.lock().unwrap();
    let conn = db.as_ref().expect("Database not initialized");

    let (wc, vals) = build_where_clause(filter_str);
    let sql = format!("SELECT EXISTS(SELECT 1 FROM {}{})", table, wc);
    let pr: Vec<&dyn rusqlite::types::ToSql> = vals.iter().map(|s| s as &dyn rusqlite::types::ToSql).collect();
    conn.query_row(&sql, pr.as_slice(), |r| r.get::<_, i64>(0)).unwrap_or(0)
}

#[no_mangle]
pub extern "C" fn forge_model_update_where(
    table: *const c_char,
    filter_json: *const c_char,
    changes_json: *const c_char,
) -> i64 {
    let table = cstr(table);
    let filter_str = cstr(filter_json);
    let changes_str = cstr(changes_json);
    let db = DB.lock().unwrap();
    let conn = db.as_ref().expect("Database not initialized");

    let changes: Value = match serde_json::from_str(changes_str) {
        Ok(v) => v,
        Err(_) => return -1,
    };
    let obj = match changes.as_object() {
        Some(o) => o,
        None => return -1,
    };

    let set_clauses: Vec<String> = obj.keys().map(|k| format!("{} = ?", k)).collect();
    let mut values: Vec<String> = obj.values().map(|v| jv(v)).collect();

    let (wc, wv) = build_where_clause(filter_str);
    values.extend(wv);

    let sql = format!("UPDATE {} SET {}{}", table, set_clauses.join(", "), wc);
    let pr: Vec<&dyn rusqlite::types::ToSql> = values.iter().map(|s| s as &dyn rusqlite::types::ToSql).collect();
    match conn.execute(&sql, pr.as_slice()) {
        Ok(n) => n as i64,
        Err(e) => {
            eprintln!("SQL update_where error: {}", e);
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
