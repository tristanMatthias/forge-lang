use std::collections::HashMap;
use std::ffi::{CStr, CString};
use std::io::Read;
use std::os::raw::c_char;
use std::sync::Mutex;
use std::thread::JoinHandle;
use tiny_http::{Header, Request, Response, Server};

type HandlerFn = extern "C" fn(
    method: *const c_char,
    path: *const c_char,
    body: *const c_char,
    params_json: *const c_char,
    response_buf: *mut c_char,
    response_buf_len: i64,
) -> i64; // returns status code

// Safety: HandlerFn is a plain function pointer (Send+Sync), String is Send+Sync
unsafe impl Send for Route {}
unsafe impl Sync for Route {}

struct Route {
    method: String,
    path_pattern: String,
    handler: HandlerFn,
}

/// Routes indexed by port number
static ROUTES: Mutex<Option<HashMap<u16, Vec<Route>>>> = Mutex::new(None);

/// Handles for spawned server threads
static SERVER_HANDLES: Mutex<Vec<JoinHandle<()>>> = Mutex::new(Vec::new());

/// Middleware function type: same signature as HandlerFn but used for pre/post processing
type MiddlewareFn = extern "C" fn(
    method: *const c_char,
    path: *const c_char,
    body: *const c_char,
    headers_json: *const c_char,
    response_buf: *mut c_char,
    response_buf_len: i64,
) -> i64;

unsafe impl Send for MiddlewareEntry {}
unsafe impl Sync for MiddlewareEntry {}

struct MiddlewareEntry {
    name: String,
    before: Option<MiddlewareFn>,
    after: Option<MiddlewareFn>,
}

static MIDDLEWARE: Mutex<Option<HashMap<u16, Vec<MiddlewareEntry>>>> = Mutex::new(None);

fn routes_map() -> std::sync::MutexGuard<'static, Option<HashMap<u16, Vec<Route>>>> {
    let mut guard = ROUTES.lock().unwrap();
    if guard.is_none() {
        *guard = Some(HashMap::new());
    }
    guard
}

#[no_mangle]
pub extern "C" fn forge_http_add_route(
    port: u16,
    method: *const c_char,
    path: *const c_char,
    handler: HandlerFn,
) {
    let method = unsafe { CStr::from_ptr(method) }
        .to_str()
        .unwrap()
        .to_string();
    let raw_path = unsafe { CStr::from_ptr(path) }
        .to_str()
        .unwrap()
        .to_string();
    let path = format!("{}{}", current_prefix(port), raw_path);
    routes_map()
        .as_mut()
        .unwrap()
        .entry(port)
        .or_default()
        .push(Route {
            method,
            path_pattern: path,
            handler,
        });
}

#[no_mangle]
pub extern "C" fn forge_http_serve(port: u16) {
    // Take this port's routes and middleware
    let (routes, has_more_ports) = {
        let mut map = routes_map();
        let m = map.as_mut().unwrap();
        let routes = m.remove(&port).unwrap_or_default();
        let has_more = !m.is_empty();
        (routes, has_more)
    };
    let middleware = {
        let mut guard = MIDDLEWARE.lock().unwrap();
        guard.as_mut().and_then(|m| m.remove(&port)).unwrap_or_default()
    };

    if has_more_ports {
        let handle = std::thread::spawn(move || {
            let addr = format!("0.0.0.0:{}", port);
            let server = Server::http(&addr).expect("Failed to start server");
            eprintln!("Server running on http://localhost:{}", port);
            for request in server.incoming_requests() {
                handle_request(request, &routes, &middleware);
            }
        });
        SERVER_HANDLES.lock().unwrap().push(handle);
    } else {
        let addr = format!("0.0.0.0:{}", port);
        let server = Server::http(&addr).expect("Failed to start server");
        eprintln!("Server running on http://localhost:{}", port);
        for request in server.incoming_requests() {
            handle_request(request, &routes, &middleware);
        }
    }
}

fn handle_request(mut request: Request, routes: &[Route], middleware: &[MiddlewareEntry]) {
    let method = request.method().to_string().to_uppercase();
    let url = request.url().to_string();
    let path = url.split('?').next().unwrap_or(&url).to_string();

    // Handle CORS preflight
    if method == "OPTIONS" {
        let cors_headers = vec![
            Header::from_bytes("Access-Control-Allow-Origin", "*").unwrap(),
            Header::from_bytes("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS").unwrap(),
            Header::from_bytes("Access-Control-Allow-Headers", "Content-Type, Authorization").unwrap(),
        ];
        let mut response = Response::from_string("").with_status_code(204);
        for h in cors_headers {
            response = response.with_header(h);
        }
        request.respond(response).ok();
        return;
    }

    // Collect headers as JSON for middleware
    let headers_json = {
        let mut parts = Vec::new();
        for h in request.headers() {
            let name = h.field.as_str().to_string().to_lowercase();
            let val = h.value.as_str().replace('"', "\\\"");
            parts.push(format!("\"{}\":\"{}\"", name, val));
        }
        format!("{{{}}}", parts.join(","))
    };

    // Parse query string
    let query_json = {
        if let Some(qs) = url.split('?').nth(1) {
            let mut parts = Vec::new();
            for pair in qs.split('&') {
                let mut kv = pair.splitn(2, '=');
                if let (Some(k), Some(v)) = (kv.next(), kv.next()) {
                    let decoded_v = v.replace('+', " ");
                    parts.push(format!("\"{}\":\"{}\"", k, decoded_v.replace('"', "\\\"")));
                }
            }
            format!("{{{}}}", parts.join(","))
        } else {
            "{}".to_string()
        }
    };

    // Read body
    let mut body = String::new();
    request.as_reader().read_to_string(&mut body).ok();

    // Run before-middleware (onion model: first registered = outermost)
    let method_c = CString::new(method.as_str()).unwrap();
    let path_c = CString::new(path.as_str()).unwrap();
    let body_c = CString::new(body.as_str()).unwrap();
    let headers_c = CString::new(headers_json.as_str()).unwrap();

    for mw in middleware.iter() {
        if let Some(before) = mw.before {
            let mut mw_buf = vec![0u8; 65536];
            let status = before(
                method_c.as_ptr(),
                path_c.as_ptr(),
                body_c.as_ptr(),
                headers_c.as_ptr(),
                mw_buf.as_mut_ptr() as *mut c_char,
                mw_buf.len() as i64,
            );
            if status != 0 {
                // Middleware short-circuited — return its response
                let mw_body = unsafe { CStr::from_ptr(mw_buf.as_ptr() as *const c_char) }
                    .to_str().unwrap_or("").to_string();
                let header = Header::from_bytes("Content-Type", "application/json").unwrap();
                let response = Response::from_string(mw_body)
                    .with_status_code(status as i32)
                    .with_header(header);
                request.respond(response).ok();
                return;
            }
        }
    }

    for route in routes.iter() {
        if route.method == method {
            if let Some(path_params) = match_path(&route.path_pattern, &path) {
                // Merge path params and query params
                let params = merge_params(&path_params, &query_json);
                let method_c = CString::new(method.as_str()).unwrap();
                let path_c = CString::new(path.as_str()).unwrap();
                let body_c = CString::new(body.as_str()).unwrap();
                let params_c = CString::new(params.as_str()).unwrap();

                let mut response_buf = vec![0u8; 65536];
                let status = (route.handler)(
                    method_c.as_ptr(),
                    path_c.as_ptr(),
                    body_c.as_ptr(),
                    params_c.as_ptr(),
                    response_buf.as_mut_ptr() as *mut c_char,
                    response_buf.len() as i64,
                );

                let response_body = unsafe {
                    CStr::from_ptr(response_buf.as_ptr() as *const c_char)
                }
                .to_str()
                .unwrap_or("")
                .to_string();

                // Run after-middleware in reverse order (onion model)
                for mw in middleware.iter().rev() {
                    if let Some(after) = mw.after {
                        let mut mw_buf = vec![0u8; 65536];
                        after(
                            method_c.as_ptr(),
                            path_c.as_ptr(),
                            body_c.as_ptr(),
                            headers_c.as_ptr(),
                            mw_buf.as_mut_ptr() as *mut c_char,
                            mw_buf.len() as i64,
                        );
                        // After-middleware is fire-and-forget (logging, metrics, etc.)
                    }
                }

                let header =
                    Header::from_bytes("Content-Type", "application/json").unwrap();
                let cors = Header::from_bytes("Access-Control-Allow-Origin", "*").unwrap();

                if status == 204 {
                    let response = Response::from_string("")
                        .with_status_code(status as i32)
                        .with_header(header)
                        .with_header(cors);
                    request.respond(response).ok();
                } else {
                    let response = Response::from_string(response_body)
                        .with_status_code(status as i32)
                        .with_header(header)
                        .with_header(cors);
                    request.respond(response).ok();
                }
                return;
            }
        }
    }

    // 404
    let header = Header::from_bytes("Content-Type", "application/json").unwrap();
    let cors = Header::from_bytes("Access-Control-Allow-Origin", "*").unwrap();
    let response = Response::from_string("{\"error\":\"not found\"}")
        .with_status_code(404)
        .with_header(header)
        .with_header(cors);
    request.respond(response).ok();
}

// ── Model function lookup via dlsym ──
// Uses runtime symbol lookup so @std.http doesn't have a hard link dependency
// on @std.model. CRUD only works when both providers are loaded.

use std::sync::Once;

type ListJsonFn = unsafe extern "C" fn(*const c_char, *const c_char) -> *const c_char;
type InsertJsonFn = unsafe extern "C" fn(*const c_char, *const c_char) -> *const c_char;
type GetByIdFn = unsafe extern "C" fn(*const c_char, i64) -> *const c_char;
type UpdateJsonFn = unsafe extern "C" fn(*const c_char, i64, *const c_char) -> *const c_char;
type DeleteJsonFn = unsafe extern "C" fn(*const c_char, i64) -> i64;
type FreeStringFn = unsafe extern "C" fn(*const c_char);
type PaginateJsonFn = unsafe extern "C" fn(*const c_char, *const c_char, i64, i64, *const c_char) -> *const c_char;

struct ModelFns {
    list_json: Option<ListJsonFn>,
    insert_json: Option<InsertJsonFn>,
    get_by_id: Option<GetByIdFn>,
    update_json: Option<UpdateJsonFn>,
    delete_json: Option<DeleteJsonFn>,
    free_string: Option<FreeStringFn>,
    paginate_json: Option<PaginateJsonFn>,
}

static mut MODEL_FNS: ModelFns = ModelFns {
    list_json: None,
    insert_json: None,
    get_by_id: None,
    update_json: None,
    delete_json: None,
    free_string: None,
    paginate_json: None,
};

static MODEL_FNS_INIT: Once = Once::new();

fn lookup_sym(name: &[u8]) -> *mut std::ffi::c_void {
    extern "C" { fn dlsym(handle: *mut std::ffi::c_void, symbol: *const c_char) -> *mut std::ffi::c_void; }
    // RTLD_DEFAULT: macOS = (void*)-2, Linux = NULL
    #[cfg(target_os = "macos")]
    let handle = -2isize as *mut std::ffi::c_void;
    #[cfg(not(target_os = "macos"))]
    let handle = std::ptr::null_mut();
    unsafe { dlsym(handle, name.as_ptr() as *const c_char) }
}

fn init_model_fns() {
    MODEL_FNS_INIT.call_once(|| {
        // SAFETY: Only called once via Once, and MODEL_FNS is only written here
        unsafe {
            macro_rules! lookup {
                ($field:ident, $sym:literal) => {
                    let p = lookup_sym($sym);
                    if !p.is_null() { MODEL_FNS.$field = Some(std::mem::transmute(p)); }
                };
            }
            lookup!(list_json, b"forge_model_list_json\0");
            lookup!(insert_json, b"forge_model_insert_json\0");
            lookup!(get_by_id, b"forge_model_get_by_id\0");
            lookup!(update_json, b"forge_model_update_json\0");
            lookup!(delete_json, b"forge_model_delete_json\0");
            lookup!(free_string, b"forge_model_free_string\0");
            lookup!(paginate_json, b"forge_model_paginate_json\0");
        }
    });
}

fn model_list_json(table: *const c_char, filter: *const c_char) -> *const c_char {
    init_model_fns();
    unsafe { match MODEL_FNS.list_json {
        Some(f) => f(table, filter),
        None => { eprintln!("error: CRUD requires @std.model"); std::ptr::null() }
    }}
}
fn model_insert_json(table: *const c_char, data: *const c_char) -> *const c_char {
    init_model_fns();
    unsafe { MODEL_FNS.insert_json.map_or(std::ptr::null(), |f| f(table, data)) }
}
fn model_get_by_id(table: *const c_char, id: i64) -> *const c_char {
    init_model_fns();
    unsafe { MODEL_FNS.get_by_id.map_or(std::ptr::null(), |f| f(table, id)) }
}
fn model_update_json(table: *const c_char, id: i64, changes: *const c_char) -> *const c_char {
    init_model_fns();
    unsafe { MODEL_FNS.update_json.map_or(std::ptr::null(), |f| f(table, id, changes)) }
}
fn model_delete_json(table: *const c_char, id: i64) -> i64 {
    init_model_fns();
    unsafe { MODEL_FNS.delete_json.map_or(0, |f| f(table, id)) }
}
fn model_free_string(ptr: *const c_char) {
    init_model_fns();
    unsafe { if let Some(f) = MODEL_FNS.free_string { f(ptr); } }
}
fn model_paginate_json(table: *const c_char, filter: *const c_char, page: i64, per_page: i64, order: *const c_char) -> *const c_char {
    init_model_fns();
    unsafe { MODEL_FNS.paginate_json.map_or(std::ptr::null(), |f| f(table, filter, page, per_page, order)) }
}

fn cstr(ptr: *const c_char) -> &'static str {
    unsafe { CStr::from_ptr(ptr) }.to_str().unwrap_or("")
}

/// Mount CRUD endpoints for a model table at a base path.
/// Registers 5 routes: GET list, POST create, GET by id, PUT update, DELETE.
#[no_mangle]
pub extern "C" fn forge_http_mount_crud(port: u16, table: *const c_char, base_path: *const c_char) {
    let table_s = cstr(table).to_string();
    let base_s = cstr(base_path).to_string();
    let id_path = format!("{}/:id", base_s);

    // GET /base — list all
    {
        let method_c = CString::new("GET").unwrap();
        let path_c = CString::new(base_s.as_str()).unwrap();
        forge_http_add_route(port, method_c.as_ptr(), path_c.as_ptr(), mount_list_handler);
    }

    // POST /base — create
    {
        let method_c = CString::new("POST").unwrap();
        let path_c = CString::new(base_s.as_str()).unwrap();
        forge_http_add_route(port, method_c.as_ptr(), path_c.as_ptr(), mount_create_handler);
    }

    // GET /base/:id — get by id
    {
        let method_c = CString::new("GET").unwrap();
        let path_c = CString::new(id_path.as_str()).unwrap();
        forge_http_add_route(port, method_c.as_ptr(), path_c.as_ptr(), mount_get_handler);
    }

    // PUT /base/:id — update
    {
        let method_c = CString::new("PUT").unwrap();
        let path_c = CString::new(id_path.as_str()).unwrap();
        forge_http_add_route(port, method_c.as_ptr(), path_c.as_ptr(), mount_update_handler);
    }

    // DELETE /base/:id — delete
    {
        let method_c = CString::new("DELETE").unwrap();
        let path_c = CString::new(id_path.as_str()).unwrap();
        forge_http_add_route(port, method_c.as_ptr(), path_c.as_ptr(), mount_delete_handler);
    }

    // Register this mount with the prefixed path (same as routes use)
    let prefixed_base = format!("{}{}", current_prefix(port), base_s);
    MOUNTS.lock().unwrap().push(MountInfo {
        table: table_s,
        base_path: prefixed_base,
    });
}

struct MountInfo {
    table: String,
    base_path: String,
}

static MOUNTS: Mutex<Vec<MountInfo>> = Mutex::new(Vec::new());

/// Find the table name for a given request path by matching against registered mounts.
fn find_mount_table(path: &str) -> Option<String> {
    let mounts = MOUNTS.lock().unwrap();
    // Try exact base path match first, then /:id pattern
    let clean_path = path.trim_end_matches('/');
    for m in mounts.iter() {
        let base = m.base_path.trim_end_matches('/');
        if clean_path == base {
            return Some(m.table.clone());
        }
        // Check if path is base/:id (one more segment)
        if clean_path.starts_with(base) && clean_path[base.len()..].starts_with('/') {
            let rest = &clean_path[base.len() + 1..];
            if !rest.contains('/') && !rest.is_empty() {
                return Some(m.table.clone());
            }
        }
    }
    None
}

extern "C" fn mount_list_handler(
    _method: *const c_char,
    path: *const c_char,
    _body: *const c_char,
    params: *const c_char,
    response_buf: *mut c_char,
    response_buf_len: i64,
) -> i64 {
    let path_s = cstr(path);
    let table = match find_mount_table(path_s) {
        Some(t) => t,
        None => return 404,
    };
    let table_c = CString::new(table.as_str()).unwrap();

    // Check for pagination query params in the params JSON
    let params_s = cstr(params);
    let page = extract_param_int(params_s, "page");
    let per = extract_param_int(params_s, "per").or_else(|| extract_param_int(params_s, "per_page"));

    if let (Some(page), Some(per)) = (page, per) {
        // Paginated response
        let filter_c = CString::new("{}").unwrap();
        let order_c = CString::new("id").unwrap();
        let json = unsafe { model_paginate_json(table_c.as_ptr(), filter_c.as_ptr(), page, per, order_c.as_ptr()) };
        copy_cstr_to_buf(json, response_buf, response_buf_len);
        unsafe { model_free_string(json) };
    } else {
        let filter_c = CString::new("{}").unwrap();
        let json = unsafe { model_list_json(table_c.as_ptr(), filter_c.as_ptr()) };
        copy_cstr_to_buf(json, response_buf, response_buf_len);
        unsafe { model_free_string(json) };
    }
    200
}

fn extract_param_int(params_json: &str, key: &str) -> Option<i64> {
    let pattern = format!("\"{}\":\"", key);
    if let Some(start) = params_json.find(&pattern) {
        let rest = &params_json[start + pattern.len()..];
        if let Some(end) = rest.find('"') {
            return rest[..end].parse::<i64>().ok();
        }
    }
    None
}

extern "C" fn mount_create_handler(
    _method: *const c_char,
    path: *const c_char,
    body: *const c_char,
    _params: *const c_char,
    response_buf: *mut c_char,
    response_buf_len: i64,
) -> i64 {
    let path_s = cstr(path);
    let table = match find_mount_table(path_s) {
        Some(t) => t,
        None => return 404,
    };
    let table_c = CString::new(table.as_str()).unwrap();
    let json = unsafe { model_insert_json(table_c.as_ptr(), body) };
    let result_str = cstr(json);
    // Check for validation failure
    if result_str.trim() == "null" || result_str.is_empty() {
        let error_json = r#"{"error":"validation failed"}"#;
        copy_str_to_buf(error_json, response_buf, response_buf_len);
        unsafe { model_free_string(json) };
        return 400;
    }
    if result_str.contains("\"__validation_error\":true") {
        // Strip the internal flag and forward the structured error
        let cleaned = result_str.replace("\"__validation_error\":true,", "");
        copy_str_to_buf(&cleaned, response_buf, response_buf_len);
        unsafe { model_free_string(json) };
        return 400;
    }
    copy_cstr_to_buf(json, response_buf, response_buf_len);
    unsafe { model_free_string(json) };
    201
}

extern "C" fn mount_get_handler(
    _method: *const c_char,
    path: *const c_char,
    _body: *const c_char,
    params: *const c_char,
    response_buf: *mut c_char,
    response_buf_len: i64,
) -> i64 {
    let path_s = cstr(path);
    let table = match find_mount_table(path_s) {
        Some(t) => t,
        None => return 404,
    };
    let table_c = CString::new(table.as_str()).unwrap();
    let id = parse_id_from_params(params);
    let json = unsafe { model_get_by_id(table_c.as_ptr(), id) };
    let result_str = cstr(json);
    if result_str.trim() == "null" || result_str.is_empty() {
        let error_json = r#"{"error":"not found"}"#;
        let bytes = error_json.as_bytes();
        let copy_len = std::cmp::min(bytes.len(), (response_buf_len - 1) as usize);
        unsafe {
            std::ptr::copy_nonoverlapping(bytes.as_ptr(), response_buf as *mut u8, copy_len);
            *response_buf.add(copy_len) = 0;
        }
        unsafe { model_free_string(json) };
        return 404;
    }
    copy_cstr_to_buf(json, response_buf, response_buf_len);
    unsafe { model_free_string(json) };
    200
}

extern "C" fn mount_update_handler(
    _method: *const c_char,
    path: *const c_char,
    body: *const c_char,
    params: *const c_char,
    response_buf: *mut c_char,
    response_buf_len: i64,
) -> i64 {
    let path_s = cstr(path);
    let table = match find_mount_table(path_s) {
        Some(t) => t,
        None => return 404,
    };
    let table_c = CString::new(table.as_str()).unwrap();
    let id = parse_id_from_params(params);
    let json = unsafe { model_update_json(table_c.as_ptr(), id, body) };
    let result_str = cstr(json);
    if result_str.trim() == "null" || result_str.is_empty() {
        let error_json = r#"{"error":"validation failed"}"#;
        copy_str_to_buf(error_json, response_buf, response_buf_len);
        unsafe { model_free_string(json) };
        return 400;
    }
    if result_str.contains("\"__validation_error\":true") {
        let cleaned = result_str.replace("\"__validation_error\":true,", "");
        copy_str_to_buf(&cleaned, response_buf, response_buf_len);
        unsafe { model_free_string(json) };
        return 400;
    }
    copy_cstr_to_buf(json, response_buf, response_buf_len);
    unsafe { model_free_string(json) };
    200
}

extern "C" fn mount_delete_handler(
    _method: *const c_char,
    path: *const c_char,
    _body: *const c_char,
    params: *const c_char,
    _response_buf: *mut c_char,
    _response_buf_len: i64,
) -> i64 {
    let path_s = cstr(path);
    let table = match find_mount_table(path_s) {
        Some(t) => t,
        None => return 404,
    };
    let table_c = CString::new(table.as_str()).unwrap();
    let id = parse_id_from_params(params);
    unsafe { model_delete_json(table_c.as_ptr(), id) };
    204
}

fn parse_id_from_params(params_json: *const c_char) -> i64 {
    let s = cstr(params_json);
    if let Some(start) = s.find("\"id\":\"") {
        let rest = &s[start + 6..];
        if let Some(end) = rest.find('"') {
            return rest[..end].parse::<i64>().unwrap_or(0);
        }
    }
    0
}

/// Convert a raw C string pointer to a heap-allocated C string.
/// Used by route handlers to convert body/params ptrs to strings.
/// The extern fn ABI will auto-wrap the return value as a ForgeString.
#[no_mangle]
pub extern "C" fn forge_http_ptr_to_str(ptr: *const c_char) -> *mut c_char {
    if ptr.is_null() {
        return CString::new("").unwrap().into_raw();
    }
    let s = unsafe { CStr::from_ptr(ptr) }.to_str().unwrap_or("");
    CString::new(s).unwrap().into_raw()
}

/// Write a Forge string (passed as C string pointer by extern fn ABI) to a response buffer.
/// Called by generated route handlers to copy JSON response into the HTTP response buffer.
#[no_mangle]
pub extern "C" fn forge_http_write_response(buf: *mut c_char, buf_len: i64, json: *const c_char) {
    if buf.is_null() || buf_len <= 0 {
        return;
    }
    if json.is_null() {
        unsafe { *buf = 0; }
        return;
    }
    let s = unsafe { CStr::from_ptr(json) }.to_bytes();
    let copy_len = std::cmp::min(s.len(), (buf_len - 1) as usize);
    unsafe {
        std::ptr::copy_nonoverlapping(s.as_ptr(), buf as *mut u8, copy_len);
        *buf.add(copy_len) = 0;
    }
}

fn copy_str_to_buf(s: &str, dst: *mut c_char, dst_len: i64) {
    if dst.is_null() || dst_len <= 0 {
        return;
    }
    let bytes = s.as_bytes();
    let copy_len = std::cmp::min(bytes.len(), (dst_len - 1) as usize);
    unsafe {
        std::ptr::copy_nonoverlapping(bytes.as_ptr(), dst as *mut u8, copy_len);
        *dst.add(copy_len) = 0;
    }
}

fn copy_cstr_to_buf(src: *const c_char, dst: *mut c_char, dst_len: i64) {
    if src.is_null() || dst.is_null() || dst_len <= 0 {
        return;
    }
    let s = cstr(src);
    let bytes = s.as_bytes();
    let copy_len = std::cmp::min(bytes.len(), (dst_len - 1) as usize);
    unsafe {
        std::ptr::copy_nonoverlapping(bytes.as_ptr(), dst as *mut u8, copy_len);
        *dst.add(copy_len) = 0; // null terminate
    }
}

// ── Auto CRUD mount (derives path from model name) ──

#[no_mangle]
pub extern "C" fn forge_http_mount_crud_auto(port: u16, model: *const c_char) {
    let model_s = cstr(model).to_string();
    // Derive path: "User" -> "/users", "Post" -> "/posts"
    let path = format!("/{}", pluralize(&model_s.to_lowercase()));
    let table_c = CString::new(model_s.as_str()).unwrap();
    let path_c = CString::new(path.as_str()).unwrap();
    forge_http_mount_crud(port, table_c.as_ptr(), path_c.as_ptr());
}

fn pluralize(s: &str) -> String {
    if s.ends_with('s') || s.ends_with("sh") || s.ends_with("ch") || s.ends_with('x') || s.ends_with('z') {
        format!("{}es", s)
    } else if s.ends_with('y') && !s.ends_with("ay") && !s.ends_with("ey") && !s.ends_with("oy") && !s.ends_with("uy") {
        format!("{}ies", &s[..s.len() - 1])
    } else {
        format!("{}s", s)
    }
}

// ── Route prefix stack for `under` blocks ──

static PREFIX_STACK: Mutex<Option<HashMap<u16, Vec<String>>>> = Mutex::new(None);

fn current_prefix(port: u16) -> String {
    let guard = PREFIX_STACK.lock().unwrap();
    if let Some(map) = guard.as_ref() {
        if let Some(stack) = map.get(&port) {
            return stack.join("");
        }
    }
    String::new()
}

#[no_mangle]
pub extern "C" fn forge_http_push_prefix(port: u16, prefix: *const c_char) {
    let prefix_s = cstr(prefix).to_string();
    let mut guard = PREFIX_STACK.lock().unwrap();
    if guard.is_none() {
        *guard = Some(HashMap::new());
    }
    guard.as_mut().unwrap().entry(port).or_default().push(prefix_s);
}

#[no_mangle]
pub extern "C" fn forge_http_pop_prefix(port: u16) {
    let mut guard = PREFIX_STACK.lock().unwrap();
    if let Some(map) = guard.as_mut() {
        if let Some(stack) = map.get_mut(&port) {
            stack.pop();
        }
    }
}

// ── Middleware registration ──

fn middleware_map() -> std::sync::MutexGuard<'static, Option<HashMap<u16, Vec<MiddlewareEntry>>>> {
    let mut guard = MIDDLEWARE.lock().unwrap();
    if guard.is_none() {
        *guard = Some(HashMap::new());
    }
    guard
}

#[no_mangle]
pub extern "C" fn forge_http_add_middleware(port: u16, name: *const c_char, handler: MiddlewareFn) {
    let name_s = cstr(name).to_string();
    let mut guard = middleware_map();
    let entries = guard.as_mut().unwrap().entry(port).or_default();
    // Check if middleware with this name exists, update its before handler
    if let Some(entry) = entries.iter_mut().find(|e| e.name == name_s) {
        entry.before = Some(handler);
    } else {
        entries.push(MiddlewareEntry {
            name: name_s,
            before: Some(handler),
            after: None,
        });
    }
}

#[no_mangle]
pub extern "C" fn forge_http_add_middleware_after(port: u16, name: *const c_char, handler: MiddlewareFn) {
    let name_s = cstr(name).to_string();
    let mut guard = middleware_map();
    let entries = guard.as_mut().unwrap().entry(port).or_default();
    // Check if middleware with this name exists, update its after handler
    if let Some(entry) = entries.iter_mut().find(|e| e.name == name_s) {
        entry.after = Some(handler);
    } else {
        entries.push(MiddlewareEntry {
            name: name_s,
            before: None,
            after: Some(handler),
        });
    }
}

/// Merge two JSON objects (both are `{...}` strings). Path params take priority.
fn merge_params(path_params: &str, query_params: &str) -> String {
    if query_params == "{}" || query_params.is_empty() {
        return path_params.to_string();
    }
    if path_params == "{}" || path_params.is_empty() {
        return query_params.to_string();
    }
    // Strip outer braces and combine
    let p = path_params.trim_start_matches('{').trim_end_matches('}');
    let q = query_params.trim_start_matches('{').trim_end_matches('}');
    if p.is_empty() {
        return format!("{{{}}}", q);
    }
    if q.is_empty() {
        return format!("{{{}}}", p);
    }
    format!("{{{},{}}}", p, q)
}

fn match_path(pattern: &str, actual: &str) -> Option<String> {
    let pattern_parts: Vec<&str> = pattern.split('/').filter(|s| !s.is_empty()).collect();
    let actual_parts: Vec<&str> = actual.split('/').filter(|s| !s.is_empty()).collect();

    if pattern_parts.len() != actual_parts.len() {
        return None;
    }

    let mut params = Vec::new();
    for (p, a) in pattern_parts.iter().zip(actual_parts.iter()) {
        if p.starts_with(':') {
            let name = &p[1..];
            params.push(format!("\"{}\":\"{}\"", name, a));
        } else if p != a {
            return None;
        }
    }

    Some(format!("{{{}}}", params.join(",")))
}
