use std::collections::HashMap;
use std::ffi::{CStr, CString};
use std::io::Read;
use std::os::raw::c_char;
use std::sync::atomic::{AtomicI64, Ordering};
use std::sync::Mutex;
use std::thread::JoinHandle;
use std::time::Instant;
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
                handle_request(request, &routes, &middleware, port);
            }
        });
        SERVER_HANDLES.lock().unwrap().push(handle);
    } else {
        let addr = format!("0.0.0.0:{}", port);
        let server = Server::http(&addr).expect("Failed to start server");
        eprintln!("Server running on http://localhost:{}", port);
        for request in server.incoming_requests() {
            handle_request(request, &routes, &middleware, port);
        }
    }
}

fn handle_request(mut request: Request, routes: &[Route], middleware: &[MiddlewareEntry], port: u16) {
    let start = std::time::Instant::now();
    let method = request.method().to_string().to_uppercase();
    let url = request.url().to_string();
    let path = url.split('?').next().unwrap_or(&url).to_string();

    // Get client IP for rate limiting
    let client_ip = request
        .remote_addr()
        .map(|a| a.ip().to_string())
        .unwrap_or_else(|| "unknown".to_string());

    // Check rate limiting before any processing
    if !check_rate_limit(port, &path, &client_ip) {
        let header = Header::from_bytes("Content-Type", "application/json").unwrap();
        let timing = Header::from_bytes("X-Response-Time", format!("{}ms", start.elapsed().as_millis())).unwrap();
        let response = Response::from_string(r#"{"error":"too many requests"}"#)
            .with_status_code(429)
            .with_header(header)
            .with_header(timing);
        request.respond(response).ok();
        return;
    }

    // Check for SSE endpoint
    if method == "GET" {
        if let Some(stream_id) = find_sse_stream(port, &path) {
            // Handle SSE request in a separate thread so the server loop continues
            std::thread::spawn(move || {
                handle_sse_request(request, stream_id);
            });
            return;
        }
    }

    // Check for WebSocket upgrade
    // WebSocket requests have "Upgrade: websocket" header
    {
        let is_upgrade = request.headers().iter().any(|h| {
            h.field.as_str().to_string().to_lowercase() == "upgrade"
                && h.value.as_str().to_lowercase() == "websocket"
        });
        if is_upgrade && is_ws_path(port, &path) {
            // Extract the underlying stream via tiny_http's upgrade mechanism.
            // tiny_http's upgrade() handles sending the 101 response internally.
            let response = Response::from_string("");
            let stream = request.upgrade("websocket", response);
            let dyn_stream: DynStream = Box::new(stream);
            let client_id = do_ws_upgrade(dyn_stream);
            if client_id > 0 {
                // Store the client_id in the pending map for the path
                ws_pending_map()
                    .as_mut()
                    .unwrap()
                    .entry(path.clone())
                    .or_default()
                    .push(client_id);
                // If a handler is registered for this path, spawn a thread to call it
                if let Some(handler) = get_ws_handler(port, &path) {
                    std::thread::spawn(move || {
                        handler(client_id);
                    });
                }
            }
            return;
        }
    }

    // Handle CORS preflight
    if method == "OPTIONS" {
        let cors_headers = vec![
            Header::from_bytes("Access-Control-Allow-Origin", "*").unwrap(),
            Header::from_bytes("Access-Control-Allow-Methods", "GET, POST, PUT, PATCH, DELETE, OPTIONS").unwrap(),
            Header::from_bytes("Access-Control-Allow-Headers", "Content-Type, Authorization").unwrap(),
        ];
        let mut response = Response::from_string("").with_status_code(204);
        for h in cors_headers {
            response = response.with_header(h);
        }
        response = response.with_header(
            Header::from_bytes("X-Response-Time", format!("{}ms", start.elapsed().as_millis())).unwrap()
        );
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
                let timing = Header::from_bytes("X-Response-Time", format!("{}ms", start.elapsed().as_millis())).unwrap();
                let response = Response::from_string(mw_body)
                    .with_status_code(status as i32)
                    .with_header(header)
                    .with_header(timing);
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
                let timing = Header::from_bytes("X-Response-Time", format!("{}ms", start.elapsed().as_millis())).unwrap();

                if status == 204 {
                    let response = Response::from_string("")
                        .with_status_code(status as i32)
                        .with_header(header)
                        .with_header(cors)
                        .with_header(timing);
                    request.respond(response).ok();
                } else {
                    let response = Response::from_string(response_body)
                        .with_status_code(status as i32)
                        .with_header(header)
                        .with_header(cors)
                        .with_header(timing);
                    request.respond(response).ok();
                }
                return;
            }
        }
    }

    // Check static file mounts before returning 404
    if let Some((content, content_type)) = try_serve_static(&path) {
        let header = Header::from_bytes("Content-Type", content_type).unwrap();
        let cors = Header::from_bytes("Access-Control-Allow-Origin", "*").unwrap();
        let timing = Header::from_bytes("X-Response-Time", format!("{}ms", start.elapsed().as_millis())).unwrap();
        let response = Response::from_data(content)
            .with_status_code(200)
            .with_header(header)
            .with_header(cors)
            .with_header(timing);
        request.respond(response).ok();
        return;
    }

    // 404 — use custom handler if set
    let not_found_body = get_custom_error_body(port, 404)
        .unwrap_or_else(|| r#"{"error":"not found"}"#.to_string());
    let header = Header::from_bytes("Content-Type", "application/json").unwrap();
    let cors = Header::from_bytes("Access-Control-Allow-Origin", "*").unwrap();
    let timing = Header::from_bytes("X-Response-Time", format!("{}ms", start.elapsed().as_millis())).unwrap();
    let response = Response::from_string(not_found_body)
        .with_status_code(404)
        .with_header(header)
        .with_header(cors)
        .with_header(timing);
    request.respond(response).ok();
}

// ── Model function lookup via dlsym ──
// Uses runtime symbol lookup so @std.http doesn't have a hard link dependency
// on @std.model. CRUD only works when both packages are loaded.

use std::sync::Once;

type ListJsonFn = unsafe extern "C" fn(*const c_char, *const c_char) -> *const c_char;
type InsertJsonFn = unsafe extern "C" fn(*const c_char, *const c_char) -> *const c_char;
type GetByIdFn = unsafe extern "C" fn(*const c_char, i64) -> *const c_char;
type UpdateJsonFn = unsafe extern "C" fn(*const c_char, i64, *const c_char) -> *const c_char;
type DeleteJsonFn = unsafe extern "C" fn(*const c_char, i64) -> i64;
type FreeStringFn = unsafe extern "C" fn(*const c_char);
type PaginateJsonFn = unsafe extern "C" fn(*const c_char, *const c_char, i64, i64, *const c_char) -> *const c_char;
type SearchJsonFn = unsafe extern "C" fn(*const c_char, *const c_char) -> *const c_char;
type CountJsonFn = unsafe extern "C" fn(*const c_char, *const c_char) -> i64;

struct ModelFns {
    list_json: Option<ListJsonFn>,
    insert_json: Option<InsertJsonFn>,
    get_by_id: Option<GetByIdFn>,
    update_json: Option<UpdateJsonFn>,
    delete_json: Option<DeleteJsonFn>,
    free_string: Option<FreeStringFn>,
    paginate_json: Option<PaginateJsonFn>,
    search_json: Option<SearchJsonFn>,
    count_json: Option<CountJsonFn>,
}

static mut MODEL_FNS: ModelFns = ModelFns {
    list_json: None,
    insert_json: None,
    get_by_id: None,
    update_json: None,
    delete_json: None,
    free_string: None,
    paginate_json: None,
    search_json: None,
    count_json: None,
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
            lookup!(search_json, b"forge_model_search_json\0");
            lookup!(count_json, b"forge_model_count_json\0");
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
fn model_search_json(table: *const c_char, search: *const c_char) -> *const c_char {
    init_model_fns();
    unsafe { MODEL_FNS.search_json.map_or(std::ptr::null(), |f| f(table, search)) }
}
fn model_count_json(table: *const c_char, filter: *const c_char) -> i64 {
    init_model_fns();
    unsafe { MODEL_FNS.count_json.map_or(0, |f| f(table, filter)) }
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

    // GET /base/search — search (must be before :id route)
    {
        let search_path = format!("{}/search", base_s);
        let method_c = CString::new("GET").unwrap();
        let path_c = CString::new(search_path.as_str()).unwrap();
        forge_http_add_route(port, method_c.as_ptr(), path_c.as_ptr(), mount_search_handler);
    }

    // GET /base/count — count records
    {
        let count_path = format!("{}/count", base_s);
        let method_c = CString::new("GET").unwrap();
        let path_c = CString::new(count_path.as_str()).unwrap();
        forge_http_add_route(port, method_c.as_ptr(), path_c.as_ptr(), mount_count_handler);
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

    // PATCH /base/:id — partial update (same handler as PUT)
    {
        let method_c = CString::new("PATCH").unwrap();
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
        None => {
            copy_str_to_buf(r#"{"error":"not found","message":"no model mounted at this path"}"#, response_buf, response_buf_len);
            return 404;
        }
    };
    let table_c = CString::new(table.as_str()).unwrap();

    // Check for pagination query params in the params JSON
    let params_s = cstr(params);
    let page = extract_param_int(params_s, "page");
    let per = extract_param_int(params_s, "per").or_else(|| extract_param_int(params_s, "per_page"));

    // Build filter from non-reserved query params (e.g., ?role=admin&status=active)
    let filter_json = build_filter_from_params(params_s);
    let order = extract_param_str(params_s, "order").unwrap_or_else(|| "id".to_string());

    // Apply default order if not explicitly specified in params
    let order = if extract_param_str(params_s, "order").is_some() {
        order
    } else if let Some(default_order) = get_default_order(path_s) {
        default_order
    } else {
        order
    };

    if let (Some(page), Some(per)) = (page, per) {
        // Paginated response
        let filter_c = CString::new(filter_json.as_str()).unwrap();
        let order_c = CString::new(order.as_str()).unwrap();
        let json = model_paginate_json(table_c.as_ptr(), filter_c.as_ptr(), page, per, order_c.as_ptr());
        let result_str = cstr(json).to_string();
        let filtered = maybe_filter_expose(path_s, &result_str);
        copy_str_to_buf(&filtered, response_buf, response_buf_len);
        unsafe { model_free_string(json) };
    } else {
        let filter_c = CString::new(filter_json.as_str()).unwrap();
        let json = model_list_json(table_c.as_ptr(), filter_c.as_ptr());
        let result_str = cstr(json).to_string();
        let filtered = maybe_filter_expose(path_s, &result_str);
        copy_str_to_buf(&filtered, response_buf, response_buf_len);
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

fn extract_param_str(params_json: &str, key: &str) -> Option<String> {
    let pattern = format!("\"{}\":\"", key);
    if let Some(start) = params_json.find(&pattern) {
        let rest = &params_json[start + pattern.len()..];
        if let Some(end) = rest.find('"') {
            return Some(rest[..end].to_string());
        }
    }
    None
}

/// Build a filter JSON object from query params, excluding reserved keys (page, per, per_page, order, q)
fn build_filter_from_params(params_json: &str) -> String {
    const RESERVED: &[&str] = &["page", "per", "per_page", "order", "q"];
    if params_json.is_empty() || params_json == "{}" {
        return "{}".to_string();
    }
    // Simple JSON key-value extraction from {"key":"val","key2":"val2",...}
    let trimmed = params_json.trim_start_matches('{').trim_end_matches('}');
    if trimmed.is_empty() {
        return "{}".to_string();
    }
    let mut filter_parts = Vec::new();
    // Split on commas carefully (simple approach for non-nested JSON)
    for pair in trimmed.split(',') {
        let pair = pair.trim();
        if let Some(colon) = pair.find(':') {
            let key = pair[..colon].trim().trim_matches('"');
            if !RESERVED.contains(&key) {
                filter_parts.push(pair.to_string());
            }
        }
    }
    if filter_parts.is_empty() {
        "{}".to_string()
    } else {
        format!("{{{}}}", filter_parts.join(","))
    }
}

/// Find the table name for a given base path (exact match only, no /:id suffix).
fn find_mount_table_by_base(base_path: &str) -> Option<String> {
    let mounts = MOUNTS.lock().unwrap();
    let clean = base_path.trim_end_matches('/');
    for m in mounts.iter() {
        if m.base_path.trim_end_matches('/') == clean {
            return Some(m.table.clone());
        }
    }
    None
}

extern "C" fn mount_search_handler(
    _method: *const c_char,
    path: *const c_char,
    _body: *const c_char,
    params: *const c_char,
    response_buf: *mut c_char,
    response_buf_len: i64,
) -> i64 {
    // Strip /search suffix to find the mount base path
    let path_s = cstr(path);
    let base_path = path_s.trim_end_matches("/search");
    let table = match find_mount_table_by_base(base_path) {
        Some(t) => t,
        None => return 404,
    };
    let table_c = CString::new(table.as_str()).unwrap();
    let params_s = cstr(params);
    let q = extract_param_str(params_s, "q").unwrap_or_default();
    let search_json = format!(r#"{{"columns":["*"],"query":"{}"}}"#, q.replace('"', "\\\""));
    let search_c = CString::new(search_json).unwrap();
    let json = model_search_json(table_c.as_ptr(), search_c.as_ptr());
    copy_cstr_to_buf(json, response_buf, response_buf_len);
    unsafe { model_free_string(json) };
    200
}

extern "C" fn mount_count_handler(
    _method: *const c_char,
    path: *const c_char,
    _body: *const c_char,
    _params: *const c_char,
    response_buf: *mut c_char,
    response_buf_len: i64,
) -> i64 {
    let path_s = cstr(path);
    let base_path = path_s.trim_end_matches("/count");
    let table = match find_mount_table_by_base(base_path) {
        Some(t) => t,
        None => return 404,
    };
    let table_c = CString::new(table.as_str()).unwrap();
    let filter_c = CString::new("{}").unwrap();
    let count = model_count_json(table_c.as_ptr(), filter_c.as_ptr());
    let result = format!(r#"{{"count":{}}}"#, count);
    copy_str_to_buf(&result, response_buf, response_buf_len);
    200
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
        None => {
            copy_str_to_buf(r#"{"error":"not found","message":"no model mounted at this path"}"#, response_buf, response_buf_len);
            return 404;
        }
    };
    let table_c = CString::new(table.as_str()).unwrap();

    // Validate that body is non-empty JSON
    let body_s = cstr(body);
    if body_s.trim().is_empty() || body_s.trim() == "{}" {
        let error_json = format!(
            r#"{{"error":"validation failed","message":"request body is empty","resource":"{}","action":"create"}}"#,
            table
        );
        copy_str_to_buf(&error_json, response_buf, response_buf_len);
        return 400;
    }

    let json = unsafe { model_insert_json(table_c.as_ptr(), body) };
    let result_str = cstr(json);
    // Check for validation failure
    if result_str.trim() == "null" || result_str.is_empty() {
        let error_json = format!(
            r#"{{"error":"validation failed","message":"insert returned no result","resource":"{}","action":"create"}}"#,
            table
        );
        copy_str_to_buf(&error_json, response_buf, response_buf_len);
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
        None => {
            copy_str_to_buf(r#"{"error":"not found","message":"no model mounted at this path"}"#, response_buf, response_buf_len);
            return 404;
        }
    };
    let table_c = CString::new(table.as_str()).unwrap();
    let id = parse_id_from_params(params);
    if id == 0 {
        let error_json = format!(
            r#"{{"error":"bad request","message":"invalid or missing id parameter","resource":"{}","action":"get"}}"#,
            table
        );
        copy_str_to_buf(&error_json, response_buf, response_buf_len);
        return 400;
    }
    let json = unsafe { model_get_by_id(table_c.as_ptr(), id) };
    let result_str = cstr(json);
    if result_str.trim() == "null" || result_str.is_empty() {
        let error_json = format!(
            r#"{{"error":"not found","message":"{} with id {} not found","resource":"{}","id":{}}}"#,
            table, id, table, id
        );
        copy_str_to_buf(&error_json, response_buf, response_buf_len);
        unsafe { model_free_string(json) };
        return 404;
    }
    let result_owned = result_str.to_string();
    let filtered = maybe_filter_expose(path_s, &result_owned);
    copy_str_to_buf(&filtered, response_buf, response_buf_len);
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
        None => {
            copy_str_to_buf(r#"{"error":"not found","message":"no model mounted at this path"}"#, response_buf, response_buf_len);
            return 404;
        }
    };
    let table_c = CString::new(table.as_str()).unwrap();
    let id = parse_id_from_params(params);
    if id == 0 {
        let error_json = format!(
            r#"{{"error":"bad request","message":"invalid or missing id parameter","resource":"{}","action":"update"}}"#,
            table
        );
        copy_str_to_buf(&error_json, response_buf, response_buf_len);
        return 400;
    }

    // Validate that body is non-empty
    let body_s = cstr(body);
    if body_s.trim().is_empty() || body_s.trim() == "{}" {
        let error_json = format!(
            r#"{{"error":"validation failed","message":"request body is empty","resource":"{}","action":"update","id":{}}}"#,
            table, id
        );
        copy_str_to_buf(&error_json, response_buf, response_buf_len);
        return 400;
    }

    let json = unsafe { model_update_json(table_c.as_ptr(), id, body) };
    let result_str = cstr(json);
    if result_str.trim() == "null" || result_str.is_empty() {
        let error_json = format!(
            r#"{{"error":"not found","message":"{} with id {} not found","resource":"{}","action":"update","id":{}}}"#,
            table, id, table, id
        );
        copy_str_to_buf(&error_json, response_buf, response_buf_len);
        unsafe { model_free_string(json) };
        return 404;
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
    response_buf: *mut c_char,
    response_buf_len: i64,
) -> i64 {
    let path_s = cstr(path);
    let table = match find_mount_table(path_s) {
        Some(t) => t,
        None => {
            copy_str_to_buf(r#"{"error":"not found","message":"no model mounted at this path"}"#, response_buf, response_buf_len);
            return 404;
        }
    };
    let table_c = CString::new(table.as_str()).unwrap();
    let id = parse_id_from_params(params);
    if id == 0 {
        let error_json = format!(
            r#"{{"error":"bad request","message":"invalid or missing id parameter","resource":"{}","action":"delete"}}"#,
            table
        );
        copy_str_to_buf(&error_json, response_buf, response_buf_len);
        return 400;
    }
    let rows = unsafe { model_delete_json(table_c.as_ptr(), id) };
    if rows > 0 {
        copy_str_to_buf(r#"{"deleted":true}"#, response_buf, response_buf_len);
        200
    } else {
        let error_json = format!(
            r#"{{"error":"not found","message":"{} with id {} not found","resource":"{}","id":{}}}"#,
            table, id, table, id
        );
        copy_str_to_buf(&error_json, response_buf, response_buf_len);
        404
    }
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

// ── Static file serving ──

struct StaticMount {
    url_prefix: String,
    dir_path: String,
}

unsafe impl Send for StaticMount {}
unsafe impl Sync for StaticMount {}

static STATIC_MOUNTS: Mutex<Vec<StaticMount>> = Mutex::new(Vec::new());

#[no_mangle]
pub extern "C" fn forge_http_serve_static(port: u16, url_prefix: *const c_char, dir_path: *const c_char) {
    let _ = port; // port recorded for future per-port filtering; currently global
    let prefix_s = cstr(url_prefix).to_string();
    let dir_s = cstr(dir_path).to_string();
    STATIC_MOUNTS.lock().unwrap().push(StaticMount {
        url_prefix: prefix_s,
        dir_path: dir_s,
    });
}

fn content_type_for_ext(ext: &str) -> &'static str {
    match ext {
        "html" | "htm" => "text/html; charset=utf-8",
        "css"          => "text/css; charset=utf-8",
        "js" | "mjs"   => "application/javascript; charset=utf-8",
        "json"         => "application/json",
        "png"          => "image/png",
        "jpg" | "jpeg" => "image/jpeg",
        "svg"          => "image/svg+xml",
        "ico"          => "image/x-icon",
        _              => "application/octet-stream",
    }
}

/// Try to serve a static file for the given request path.
/// Returns `Some((bytes, content_type))` if a matching static mount is found and the file exists.
fn try_serve_static(path: &str) -> Option<(Vec<u8>, &'static str)> {
    let mounts = STATIC_MOUNTS.lock().unwrap();
    for mount in mounts.iter() {
        let prefix = mount.url_prefix.trim_end_matches('/');
        let url_path = path.trim_end_matches('/');
        // Match exact prefix or prefix/... paths
        let rel = if url_path == prefix {
            "index.html"
        } else if url_path.starts_with(prefix) && url_path[prefix.len()..].starts_with('/') {
            url_path[prefix.len() + 1..].trim_start_matches('/')
        } else {
            continue;
        };
        // Prevent path traversal
        if rel.contains("..") {
            continue;
        }
        let file_path = std::path::Path::new(&mount.dir_path).join(rel);
        if let Ok(bytes) = std::fs::read(&file_path) {
            let ext = file_path
                .extension()
                .and_then(|e| e.to_str())
                .unwrap_or("");
            let ct = content_type_for_ext(ext);
            return Some((bytes, ct));
        }
    }
    None
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

// ══════════════════════════════════════════════════════════════════════
// Feature 1: WebSocket Support
// ══════════════════════════════════════════════════════════════════════

use tungstenite::{accept, Message, WebSocket};
use std::io::Write;

/// A type alias for the type-erased stream returned by tiny_http's upgrade
type DynStream = Box<dyn ReadWriteSend>;

/// Trait combining Read + Write + Send for use as a trait object
trait ReadWriteSend: Read + Write + Send {}
impl<T: Read + Write + Send> ReadWriteSend for T {}

/// WebSocket handler function type: called with client_id when a new connection is accepted
type WsHandlerFn = extern "C" fn(client_id: i64);

// Safety: WsHandlerFn is a plain function pointer (Send+Sync)
unsafe impl Send for WsHandlerEntry {}
unsafe impl Sync for WsHandlerEntry {}

struct WsHandlerEntry {
    handler: WsHandlerFn,
}

/// Registered WebSocket paths per port
static WS_PATHS: Mutex<Option<HashMap<u16, Vec<String>>>> = Mutex::new(None);

/// Connected WebSocket clients, keyed by client_id
static WS_CLIENTS: Mutex<Option<HashMap<i64, WebSocket<DynStream>>>> = Mutex::new(None);

/// Atomic counter for generating unique client IDs
static WS_CLIENT_COUNTER: AtomicI64 = AtomicI64::new(1);

/// Channel for delivering new WS connections from the HTTP server thread to consumers.
/// Maps path -> list of (client_id, WebSocket) pairs waiting to be picked up.
static WS_PENDING: Mutex<Option<HashMap<String, Vec<i64>>>> = Mutex::new(None);

/// Registered WebSocket handlers per (port, path)
static WS_HANDLERS: Mutex<Option<HashMap<(u16, String), WsHandlerEntry>>> = Mutex::new(None);

fn ws_handlers_map() -> std::sync::MutexGuard<'static, Option<HashMap<(u16, String), WsHandlerEntry>>> {
    let mut guard = WS_HANDLERS.lock().unwrap();
    if guard.is_none() {
        *guard = Some(HashMap::new());
    }
    guard
}

fn ws_paths_map() -> std::sync::MutexGuard<'static, Option<HashMap<u16, Vec<String>>>> {
    let mut guard = WS_PATHS.lock().unwrap();
    if guard.is_none() {
        *guard = Some(HashMap::new());
    }
    guard
}

fn ws_clients_map() -> std::sync::MutexGuard<'static, Option<HashMap<i64, WebSocket<DynStream>>>> {
    let mut guard = WS_CLIENTS.lock().unwrap();
    if guard.is_none() {
        *guard = Some(HashMap::new());
    }
    guard
}

fn ws_pending_map() -> std::sync::MutexGuard<'static, Option<HashMap<String, Vec<i64>>>> {
    let mut guard = WS_PENDING.lock().unwrap();
    if guard.is_none() {
        *guard = Some(HashMap::new());
    }
    guard
}

/// Register a WebSocket endpoint on a given port and path.
#[no_mangle]
pub extern "C" fn forge_http_ws_upgrade(port: i64, path: *const c_char) {
    let path_s = cstr(path).to_string();
    ws_paths_map()
        .as_mut()
        .unwrap()
        .entry(port as u16)
        .or_default()
        .push(path_s);
}

/// Register a handler function for a WebSocket endpoint.
/// The handler is called in a new thread for each accepted connection, with the client_id.
#[no_mangle]
pub extern "C" fn forge_http_ws_set_handler(port: i64, path: *const c_char, handler: WsHandlerFn) {
    let path_s = cstr(path).to_string();
    ws_handlers_map()
        .as_mut()
        .unwrap()
        .insert((port as u16, path_s), WsHandlerEntry { handler });
}

/// Look up the registered WS handler for a (port, path) pair.
fn get_ws_handler(port: u16, path: &str) -> Option<WsHandlerFn> {
    let guard = ws_handlers_map();
    guard.as_ref().unwrap().get(&(port, path.to_string())).map(|e| e.handler)
}

/// Check if a request path is a registered WebSocket path for the given port.
fn is_ws_path(port: u16, path: &str) -> bool {
    let guard = ws_paths_map();
    if let Some(paths) = guard.as_ref().unwrap().get(&port) {
        return paths.iter().any(|p| p == path);
    }
    false
}

/// Perform WebSocket upgrade on a stream extracted from a tiny_http request.
/// Returns the client_id assigned to this connection, or -1 on failure.
fn do_ws_upgrade(stream: DynStream) -> i64 {
    match accept(stream) {
        Ok(ws) => {
            let client_id = WS_CLIENT_COUNTER.fetch_add(1, Ordering::SeqCst);
            ws_clients_map().as_mut().unwrap().insert(client_id, ws);
            client_id
        }
        Err(e) => {
            eprintln!("WebSocket handshake failed: {}", e);
            -1
        }
    }
}

/// Send a text message to a connected WebSocket client.
#[no_mangle]
pub extern "C" fn forge_http_ws_send(client_id: i64, message: *const c_char) {
    let msg = cstr(message).to_string();
    let mut guard = ws_clients_map();
    if let Some(ws) = guard.as_mut().unwrap().get_mut(&client_id) {
        if let Err(e) = ws.send(Message::Text(msg)) {
            eprintln!("WebSocket send error (client {}): {}", client_id, e);
        }
    } else {
        eprintln!("WebSocket client {} not found", client_id);
    }
}

/// Blocking receive from a WebSocket client. Returns the message text.
/// Returns empty string on error or connection close.
#[no_mangle]
pub extern "C" fn forge_http_ws_receive(client_id: i64) -> *const c_char {
    let msg = {
        let mut guard = ws_clients_map();
        if let Some(ws) = guard.as_mut().unwrap().get_mut(&client_id) {
            match ws.read() {
                Ok(Message::Text(text)) => text,
                Ok(Message::Binary(bin)) => String::from_utf8_lossy(&bin).to_string(),
                Ok(Message::Close(_)) => String::new(),
                Ok(_) => {
                    // Ping/Pong frames are handled automatically by tungstenite;
                    // recurse by dropping the lock and trying again would be complex,
                    // so just return empty for non-text frames.
                    String::new()
                }
                Err(_) => String::new(),
            }
        } else {
            String::new()
        }
    };
    CString::new(msg).unwrap().into_raw()
}

/// Close a WebSocket connection.
#[no_mangle]
pub extern "C" fn forge_http_ws_close(client_id: i64) {
    let mut guard = ws_clients_map();
    if let Some(mut ws) = guard.as_mut().unwrap().remove(&client_id) {
        let _ = ws.close(None);
        // Flush the close frame
        loop {
            match ws.read() {
                Ok(Message::Close(_)) | Err(_) => break,
                _ => {}
            }
        }
    }
}

// ══════════════════════════════════════════════════════════════════════
// Feature 2: SSE (Server-Sent Events)
// ══════════════════════════════════════════════════════════════════════

use std::sync::mpsc;

/// SSE handler function type: called with stream_id when the endpoint is registered
type SseHandlerFn = extern "C" fn(stream_id: i64);

/// Registered SSE handlers per (port, path)
static SSE_HANDLERS: Mutex<Option<HashMap<(u16, String), SseHandlerFn>>> = Mutex::new(None);

fn sse_handlers_map() -> std::sync::MutexGuard<'static, Option<HashMap<(u16, String), SseHandlerFn>>> {
    let mut guard = SSE_HANDLERS.lock().unwrap();
    if guard.is_none() {
        *guard = Some(HashMap::new());
    }
    guard
}

/// Registered SSE paths per port
static SSE_PATHS: Mutex<Option<HashMap<u16, Vec<String>>>> = Mutex::new(None);

/// SSE streams: stream_id -> list of senders (one per connected client).
/// Each sender pushes formatted SSE data bytes to the client's response pipe.
static SSE_STREAMS: Mutex<Option<HashMap<i64, Vec<mpsc::Sender<Vec<u8>>>>>> = Mutex::new(None);

/// Atomic counter for generating unique SSE stream IDs
static SSE_STREAM_COUNTER: AtomicI64 = AtomicI64::new(1);

/// Maps (port, path) -> stream_id for looking up streams during request handling
static SSE_PATH_TO_STREAM: Mutex<Option<HashMap<(u16, String), i64>>> = Mutex::new(None);

fn sse_paths_map() -> std::sync::MutexGuard<'static, Option<HashMap<u16, Vec<String>>>> {
    let mut guard = SSE_PATHS.lock().unwrap();
    if guard.is_none() {
        *guard = Some(HashMap::new());
    }
    guard
}

fn sse_streams_map() -> std::sync::MutexGuard<'static, Option<HashMap<i64, Vec<mpsc::Sender<Vec<u8>>>>>> {
    let mut guard = SSE_STREAMS.lock().unwrap();
    if guard.is_none() {
        *guard = Some(HashMap::new());
    }
    guard
}

fn sse_path_to_stream_map() -> std::sync::MutexGuard<'static, Option<HashMap<(u16, String), i64>>> {
    let mut guard = SSE_PATH_TO_STREAM.lock().unwrap();
    if guard.is_none() {
        *guard = Some(HashMap::new());
    }
    guard
}

/// A Read adapter backed by an mpsc::Receiver<Vec<u8>>.
/// tiny_http uses Read to stream the response body.
struct SseReader {
    receiver: mpsc::Receiver<Vec<u8>>,
    buffer: Vec<u8>,
    pos: usize,
}

impl Read for SseReader {
    fn read(&mut self, buf: &mut [u8]) -> std::io::Result<usize> {
        // If we have leftover bytes from a previous chunk, serve those first
        if self.pos < self.buffer.len() {
            let n = std::cmp::min(buf.len(), self.buffer.len() - self.pos);
            buf[..n].copy_from_slice(&self.buffer[self.pos..self.pos + n]);
            self.pos += n;
            return Ok(n);
        }
        // Block waiting for the next chunk
        match self.receiver.recv() {
            Ok(data) => {
                if data.is_empty() {
                    // Empty vec signals end of stream
                    return Ok(0);
                }
                let n = std::cmp::min(buf.len(), data.len());
                buf[..n].copy_from_slice(&data[..n]);
                if n < data.len() {
                    self.buffer = data;
                    self.pos = n;
                } else {
                    self.buffer.clear();
                    self.pos = 0;
                }
                Ok(n)
            }
            Err(_) => Ok(0), // Sender dropped, end of stream
        }
    }
}

/// Register an SSE endpoint. Returns the stream_id.
#[no_mangle]
pub extern "C" fn forge_http_sse_start(port: i64, path: *const c_char) -> i64 {
    let path_s = cstr(path).to_string();
    let port_u16 = port as u16;
    let stream_id = SSE_STREAM_COUNTER.fetch_add(1, Ordering::SeqCst);

    sse_paths_map()
        .as_mut()
        .unwrap()
        .entry(port_u16)
        .or_default()
        .push(path_s.clone());

    sse_streams_map()
        .as_mut()
        .unwrap()
        .insert(stream_id, Vec::new());

    sse_path_to_stream_map()
        .as_mut()
        .unwrap()
        .insert((port_u16, path_s), stream_id);

    stream_id
}

/// Check if a request path is a registered SSE path for the given port.
/// Returns the stream_id if found, or -1 if not an SSE path.
fn find_sse_stream(port: u16, path: &str) -> Option<i64> {
    let guard = sse_path_to_stream_map();
    guard.as_ref().unwrap().get(&(port, path.to_string())).copied()
}

/// Handle an incoming SSE connection: send headers and register the client sender.
fn handle_sse_request(request: Request, stream_id: i64) {
    let (sender, receiver) = mpsc::channel::<Vec<u8>>();

    // Register this client's sender in the stream
    {
        let mut guard = sse_streams_map();
        if let Some(senders) = guard.as_mut().unwrap().get_mut(&stream_id) {
            senders.push(sender);
        } else {
            // Stream was already closed
            return;
        }
    }

    // Send the initial SSE comment to keep the connection alive
    let reader = SseReader {
        receiver,
        buffer: Vec::new(),
        pos: 0,
    };

    // tiny_http streaming: use a large content-length (chunked isn't directly supported,
    // but we can use a very large content-length and the connection will stay open).
    let response = Response::new(
        tiny_http::StatusCode(200),
        vec![
            Header::from_bytes("Content-Type", "text/event-stream").unwrap(),
            Header::from_bytes("Cache-Control", "no-cache").unwrap(),
            Header::from_bytes("Connection", "keep-alive").unwrap(),
            Header::from_bytes("Access-Control-Allow-Origin", "*").unwrap(),
        ],
        reader,
        // Use None for content length to allow streaming until connection closes
        None,
        None,
    );
    // respond() blocks until the reader returns 0 bytes, which happens
    // when all senders are dropped or forge_http_sse_close is called
    let _ = request.respond(response);
}

/// Send an SSE event to all connected clients on a stream.
#[no_mangle]
pub extern "C" fn forge_http_sse_send(stream_id: i64, event_type: *const c_char, data: *const c_char) {
    let event = cstr(event_type);
    let data_s = cstr(data);

    // Format as SSE: "event: <type>\ndata: <data>\n\n"
    let mut payload = String::new();
    if !event.is_empty() {
        payload.push_str(&format!("event: {}\n", event));
    }
    for line in data_s.lines() {
        payload.push_str(&format!("data: {}\n", line));
    }
    payload.push('\n');

    let bytes = payload.into_bytes();

    let mut guard = sse_streams_map();
    if let Some(senders) = guard.as_mut().unwrap().get_mut(&stream_id) {
        // Send to all clients, remove any that have disconnected
        senders.retain(|sender| sender.send(bytes.clone()).is_ok());
    }
}

/// Close all SSE connections for a stream.
#[no_mangle]
pub extern "C" fn forge_http_sse_close(stream_id: i64) {
    let mut guard = sse_streams_map();
    if let Some(senders) = guard.as_mut().unwrap().remove(&stream_id) {
        // Send empty vec to signal EOF, then drop all senders
        for sender in senders {
            let _ = sender.send(Vec::new());
        }
    }
}

/// Register a handler function for an SSE endpoint.
/// The handler is called in a new thread with the stream_id, allowing it to
/// push events via forge_http_sse_send.
#[no_mangle]
pub extern "C" fn forge_http_sse_set_handler(port: i64, path: *const c_char, handler: SseHandlerFn) {
    let path_s = cstr(path).to_string();
    let port_u16 = port as u16;

    // Store the handler for later invocation
    sse_handlers_map()
        .as_mut()
        .unwrap()
        .insert((port_u16, path_s.clone()), handler);

    // Look up the stream_id for this (port, path) and spawn the handler
    if let Some(stream_id) = {
        let guard = sse_path_to_stream_map();
        guard.as_ref().unwrap().get(&(port_u16, path_s)).copied()
    } {
        std::thread::spawn(move || {
            handler(stream_id);
        });
    }
}

// ══════════════════════════════════════════════════════════════════════
// Custom Error Handlers
// ══════════════════════════════════════════════════════════════════════

/// Custom 404 response body per port
static NOT_FOUND_HANDLERS: Mutex<Option<HashMap<u16, String>>> = Mutex::new(None);

/// Custom error response bodies per (port, status_code)
static ERROR_RESPONSES: Mutex<Option<HashMap<(u16, i32), String>>> = Mutex::new(None);

fn not_found_handlers_map() -> std::sync::MutexGuard<'static, Option<HashMap<u16, String>>> {
    let mut guard = NOT_FOUND_HANDLERS.lock().unwrap();
    if guard.is_none() {
        *guard = Some(HashMap::new());
    }
    guard
}

fn error_responses_map() -> std::sync::MutexGuard<'static, Option<HashMap<(u16, i32), String>>> {
    let mut guard = ERROR_RESPONSES.lock().unwrap();
    if guard.is_none() {
        *guard = Some(HashMap::new());
    }
    guard
}

/// Set a custom 404 response body for a port.
#[no_mangle]
pub extern "C" fn forge_http_set_not_found_handler(port: i64, body_json: *const c_char) {
    let body = cstr(body_json).to_string();
    not_found_handlers_map()
        .as_mut()
        .unwrap()
        .insert(port as u16, body);
}

/// Set a custom error response body for a specific status code on a port.
#[no_mangle]
pub extern "C" fn forge_http_set_error_response(port: i64, status_code: i64, body_json: *const c_char) {
    let body = cstr(body_json).to_string();
    error_responses_map()
        .as_mut()
        .unwrap()
        .insert((port as u16, status_code as i32), body);
}

/// Look up custom error body for a given port and status code.
/// Returns the custom body if set, or None for default behavior.
fn get_custom_error_body(port: u16, status_code: i32) -> Option<String> {
    // Check for specific status code override first
    {
        let guard = error_responses_map();
        if let Some(body) = guard.as_ref().unwrap().get(&(port, status_code)) {
            return Some(body.clone());
        }
    }
    // For 404, also check the not-found handler
    if status_code == 404 {
        let guard = not_found_handlers_map();
        if let Some(body) = guard.as_ref().unwrap().get(&port) {
            return Some(body.clone());
        }
    }
    None
}

// ══════════════════════════════════════════════════════════════════════
// Feature 3: Rate Limiter
// ══════════════════════════════════════════════════════════════════════

struct RateLimitRule {
    path_prefix: String,
    max_requests: i64,
    window_seconds: i64,
}

/// Rate limit rules per port
static RATE_LIMITS: Mutex<Option<HashMap<u16, Vec<RateLimitRule>>>> = Mutex::new(None);

/// Request tracking: (port, path_prefix) -> (ip -> list of request timestamps)
static RATE_LIMIT_TRACKER: Mutex<Option<HashMap<(u16, String), HashMap<String, Vec<Instant>>>>> = Mutex::new(None);

fn rate_limits_map() -> std::sync::MutexGuard<'static, Option<HashMap<u16, Vec<RateLimitRule>>>> {
    let mut guard = RATE_LIMITS.lock().unwrap();
    if guard.is_none() {
        *guard = Some(HashMap::new());
    }
    guard
}

fn rate_tracker_map() -> std::sync::MutexGuard<'static, Option<HashMap<(u16, String), HashMap<String, Vec<Instant>>>>> {
    let mut guard = RATE_LIMIT_TRACKER.lock().unwrap();
    if guard.is_none() {
        *guard = Some(HashMap::new());
    }
    guard
}

/// Configure rate limiting for a path prefix on a port.
#[no_mangle]
pub extern "C" fn forge_http_rate_limit(
    port: i64,
    path_prefix: *const c_char,
    max_requests: i64,
    window_seconds: i64,
) {
    let prefix = cstr(path_prefix).to_string();
    rate_limits_map()
        .as_mut()
        .unwrap()
        .entry(port as u16)
        .or_default()
        .push(RateLimitRule {
            path_prefix: prefix,
            max_requests,
            window_seconds,
        });
}

/// Check if a request should be rate-limited.
/// Returns true if the request is allowed, false if it should be rejected (429).
// ══════════════════════════════════════════════════════════════════════
// Feature 4: Multipart File Upload
// ══════════════════════════════════════════════════════════════════════

/// Parse a multipart/form-data body given the Content-Type header value.
/// Returns a JSON array of parts:
/// `[{"field":"file","filename":"doc.pdf","content_type":"application/pdf","data":"...base64..."}]`
#[no_mangle]
pub extern "C" fn forge_http_parse_multipart(
    body: *const c_char,
    content_type: *const c_char,
) -> *const c_char {
    let body_s = cstr(body);
    let ct = cstr(content_type);

    // Extract boundary from Content-Type: multipart/form-data; boundary=XXXX
    let boundary = match extract_boundary(ct) {
        Some(b) => b,
        None => {
            return CString::new(r#"[{"error":"no boundary found in content-type"}]"#)
                .unwrap()
                .into_raw();
        }
    };

    let parts = parse_multipart_body(body_s, &boundary);
    let mut json_parts = Vec::new();
    for part in parts {
        let data_b64 = base64_encode(part.data.as_bytes());
        let field = part.field_name.replace('"', "\\\"");
        let filename = part.filename.replace('"', "\\\"");
        let ct = part.content_type.replace('"', "\\\"");
        json_parts.push(format!(
            r#"{{"field":"{}","filename":"{}","content_type":"{}","size":{},"data":"{}"}}"#,
            field, filename, ct, part.data.len(), data_b64
        ));
    }
    let result = format!("[{}]", json_parts.join(","));
    CString::new(result).unwrap().into_raw()
}

fn extract_boundary(content_type: &str) -> Option<String> {
    for part in content_type.split(';') {
        let trimmed = part.trim();
        if trimmed.starts_with("boundary=") {
            let val = trimmed["boundary=".len()..].trim_matches('"').to_string();
            return Some(val);
        }
    }
    None
}

struct MultipartPart {
    field_name: String,
    filename: String,
    content_type: String,
    data: String,
}

fn parse_multipart_body(body: &str, boundary: &str) -> Vec<MultipartPart> {
    let delimiter = format!("--{}", boundary);
    let end_delimiter = format!("--{}--", boundary);
    let mut parts = Vec::new();

    // Split on the boundary delimiter
    let sections: Vec<&str> = body.split(&delimiter).collect();

    for section in sections.iter().skip(1) {
        // Skip the final delimiter
        let section = section.trim_start_matches("\r\n").trim_start_matches('\n');
        if section.starts_with("--") || section.is_empty() {
            continue;
        }
        // Remove trailing end delimiter if present
        let section = if section.ends_with(&end_delimiter) {
            &section[..section.len() - end_delimiter.len()]
        } else {
            section
        };

        // Split headers from body on double newline
        let (headers_str, data) = if let Some(pos) = section.find("\r\n\r\n") {
            (&section[..pos], &section[pos + 4..])
        } else if let Some(pos) = section.find("\n\n") {
            (&section[..pos], &section[pos + 2..])
        } else {
            continue;
        };

        // Trim trailing \r\n from data
        let data = data.trim_end_matches("\r\n").trim_end_matches('\n');

        let mut field_name = String::new();
        let mut filename = String::new();
        let mut content_type = String::from("application/octet-stream");

        for header_line in headers_str.lines() {
            let lower = header_line.to_lowercase();
            if lower.starts_with("content-disposition:") {
                // Parse: Content-Disposition: form-data; name="file"; filename="doc.pdf"
                for attr in header_line.split(';') {
                    let attr = attr.trim();
                    if attr.starts_with("name=") || attr.starts_with("name =\"") {
                        field_name = attr
                            .splitn(2, '=')
                            .nth(1)
                            .unwrap_or("")
                            .trim_matches('"')
                            .to_string();
                    } else if attr.starts_with("filename=") || attr.starts_with("filename =\"") {
                        filename = attr
                            .splitn(2, '=')
                            .nth(1)
                            .unwrap_or("")
                            .trim_matches('"')
                            .to_string();
                    }
                }
            } else if lower.starts_with("content-type:") {
                content_type = header_line
                    .splitn(2, ':')
                    .nth(1)
                    .unwrap_or("")
                    .trim()
                    .to_string();
            }
        }

        parts.push(MultipartPart {
            field_name,
            filename,
            content_type,
            data: data.to_string(),
        });
    }

    parts
}

/// Simple base64 encoder (no external dependency)
fn base64_encode(input: &[u8]) -> String {
    const CHARS: &[u8] = b"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    let mut result = String::with_capacity((input.len() + 2) / 3 * 4);
    for chunk in input.chunks(3) {
        let b0 = chunk[0] as u32;
        let b1 = if chunk.len() > 1 { chunk[1] as u32 } else { 0 };
        let b2 = if chunk.len() > 2 { chunk[2] as u32 } else { 0 };
        let triple = (b0 << 16) | (b1 << 8) | b2;
        result.push(CHARS[((triple >> 18) & 0x3F) as usize] as char);
        result.push(CHARS[((triple >> 12) & 0x3F) as usize] as char);
        if chunk.len() > 1 {
            result.push(CHARS[((triple >> 6) & 0x3F) as usize] as char);
        } else {
            result.push('=');
        }
        if chunk.len() > 2 {
            result.push(CHARS[(triple & 0x3F) as usize] as char);
        } else {
            result.push('=');
        }
    }
    result
}

/// Simple base64 decoder
fn base64_decode(input: &str) -> Option<Vec<u8>> {
    fn decode_char(c: u8) -> Option<u8> {
        match c {
            b'A'..=b'Z' => Some(c - b'A'),
            b'a'..=b'z' => Some(c - b'a' + 26),
            b'0'..=b'9' => Some(c - b'0' + 52),
            b'+' => Some(62),
            b'/' => Some(63),
            b'=' => Some(0),
            _ => None,
        }
    }
    let bytes: Vec<u8> = input.bytes().filter(|b| !b.is_ascii_whitespace()).collect();
    if bytes.len() % 4 != 0 {
        return None;
    }
    let mut result = Vec::with_capacity(bytes.len() / 4 * 3);
    for chunk in bytes.chunks(4) {
        let a = decode_char(chunk[0])?;
        let b = decode_char(chunk[1])?;
        let c = decode_char(chunk[2])?;
        let d = decode_char(chunk[3])?;
        let triple = ((a as u32) << 18) | ((b as u32) << 12) | ((c as u32) << 6) | (d as u32);
        result.push((triple >> 16) as u8);
        if chunk[2] != b'=' {
            result.push((triple >> 8) as u8);
        }
        if chunk[3] != b'=' {
            result.push(triple as u8);
        }
    }
    Some(result)
}

/// Decode base64 data and save to a file path.
/// Returns 1 on success, 0 on failure.
#[no_mangle]
pub extern "C" fn forge_http_save_upload(
    base64_data: *const c_char,
    dest_path: *const c_char,
) -> i64 {
    let data_s = cstr(base64_data);
    let path_s = cstr(dest_path);

    match base64_decode(data_s) {
        Some(bytes) => {
            match std::fs::write(path_s, &bytes) {
                Ok(_) => 1,
                Err(e) => {
                    eprintln!("forge_http_save_upload: write error: {}", e);
                    0
                }
            }
        }
        None => {
            eprintln!("forge_http_save_upload: base64 decode error");
            0
        }
    }
}

// ══════════════════════════════════════════════════════════════════════
// Feature 4b: File Download (respond with file contents)
// ══════════════════════════════════════════════════════════════════════

/// Read a file from disk and write its contents as the HTTP response.
/// Writes a JSON object with base64-encoded file data and metadata into the response buffer.
/// Returns 1 on success, 0 on failure (file not found, read error, etc.).
#[no_mangle]
pub extern "C" fn forge_http_respond_file(
    response_buf: *mut c_char,
    response_buf_len: i64,
    file_path: *const c_char,
) -> i64 {
    if response_buf.is_null() || response_buf_len <= 0 || file_path.is_null() {
        return 0;
    }
    let path_s = cstr(file_path);
    let path = std::path::Path::new(path_s);

    // Check file exists
    if !path.exists() {
        let err_json = r#"{"error":"file not found"}"#;
        forge_http_write_response(response_buf, response_buf_len, CString::new(err_json).unwrap().as_ptr());
        return 0;
    }

    // Read file bytes
    match std::fs::read(path) {
        Ok(bytes) => {
            // Base64-encode file contents
            let encoded = base64_encode(&bytes);
            // Detect a simple content type from extension
            let ext = path.extension().and_then(|e| e.to_str()).unwrap_or("");
            let content_type = match ext {
                "html" | "htm" => "text/html",
                "css" => "text/css",
                "js" => "application/javascript",
                "json" => "application/json",
                "png" => "image/png",
                "jpg" | "jpeg" => "image/jpeg",
                "gif" => "image/gif",
                "svg" => "image/svg+xml",
                "pdf" => "application/pdf",
                "txt" => "text/plain",
                "xml" => "application/xml",
                "zip" => "application/zip",
                _ => "application/octet-stream",
            };
            let filename = path.file_name().and_then(|f| f.to_str()).unwrap_or("download");
            let resp = format!(
                r#"{{"data":"{}","content_type":"{}","filename":"{}","size":{}}}"#,
                encoded, content_type, filename, bytes.len()
            );
            let c_resp = CString::new(resp).unwrap();
            forge_http_write_response(response_buf, response_buf_len, c_resp.as_ptr());
            1
        }
        Err(e) => {
            eprintln!("forge_http_respond_file: read error: {}", e);
            let err_json = format!(r#"{{"error":"{}"}}"#, e);
            let c_err = CString::new(err_json).unwrap();
            forge_http_write_response(response_buf, response_buf_len, c_err.as_ptr());
            0
        }
    }
}

// ══════════════════════════════════════════════════════════════════════
// Feature 5: CRUD Expose (Field Filtering) + Default Order
// ══════════════════════════════════════════════════════════════════════

/// Maps (port, base_path) -> list of exposed field names
static CRUD_EXPOSE: Mutex<Option<HashMap<(u16, String), Vec<String>>>> = Mutex::new(None);

fn crud_expose_map() -> std::sync::MutexGuard<'static, Option<HashMap<(u16, String), Vec<String>>>> {
    let mut guard = CRUD_EXPOSE.lock().unwrap();
    if guard.is_none() {
        *guard = Some(HashMap::new());
    }
    guard
}

/// Set which fields should be exposed (returned) in CRUD responses.
/// fields_json: a JSON array of field names, e.g. `["id","name","email"]`
#[no_mangle]
pub extern "C" fn forge_http_crud_expose(
    port: i64,
    base_path: *const c_char,
    fields_json: *const c_char,
) {
    let base = cstr(base_path).to_string();
    let fields_s = cstr(fields_json);

    // Simple JSON array parser: ["field1","field2",...]
    let mut fields = Vec::new();
    let trimmed = fields_s.trim().trim_start_matches('[').trim_end_matches(']');
    for part in trimmed.split(',') {
        let field = part.trim().trim_matches('"').trim();
        if !field.is_empty() {
            fields.push(field.to_string());
        }
    }

    crud_expose_map()
        .as_mut()
        .unwrap()
        .insert((port as u16, base.clone()), fields);
}

/// Maps (port, base_path) -> (order_field, order_direction)
static CRUD_DEFAULT_ORDER: Mutex<Option<HashMap<(u16, String), (String, String)>>> = Mutex::new(None);

fn crud_order_map() -> std::sync::MutexGuard<'static, Option<HashMap<(u16, String), (String, String)>>> {
    let mut guard = CRUD_DEFAULT_ORDER.lock().unwrap();
    if guard.is_none() {
        *guard = Some(HashMap::new());
    }
    guard
}

/// Set default ordering for a CRUD list endpoint.
#[no_mangle]
pub extern "C" fn forge_http_crud_set_order(
    port: i64,
    base_path: *const c_char,
    order_field: *const c_char,
    order_dir: *const c_char,
) {
    let base = cstr(base_path).to_string();
    let field = cstr(order_field).to_string();
    let dir = cstr(order_dir).to_string();
    crud_order_map()
        .as_mut()
        .unwrap()
        .insert((port as u16, base), (field, dir));
}

/// Get the expose fields for a given mount path. Returns None if no filter is set.
fn get_expose_fields(path: &str) -> Option<Vec<String>> {
    let guard = crud_expose_map();
    let map = guard.as_ref().unwrap();
    // Try matching against all registered expose rules
    for ((_, base), fields) in map.iter() {
        let base_clean = base.trim_end_matches('/');
        let path_clean = path.trim_end_matches('/');
        if path_clean == base_clean || path_clean.starts_with(&format!("{}/", base_clean)) {
            return Some(fields.clone());
        }
    }
    None
}

/// Get the default order for a given mount base path.
fn get_default_order(path: &str) -> Option<String> {
    let guard = crud_order_map();
    let map = guard.as_ref().unwrap();
    for ((_, base), (field, dir)) in map.iter() {
        let base_clean = base.trim_end_matches('/');
        let path_clean = path.trim_end_matches('/');
        if path_clean == base_clean || path_clean.starts_with(&format!("{}/", base_clean)) {
            return Some(format!("{} {}", field, dir));
        }
    }
    None
}

/// Filter a JSON object string to only include the specified fields.
/// Works on both single objects `{...}` and arrays `[{...},{...}]`.
fn filter_json_fields(json: &str, fields: &[String]) -> String {
    let trimmed = json.trim();
    if trimmed.starts_with('[') {
        // Array of objects
        let inner = trimmed.trim_start_matches('[').trim_end_matches(']');
        let objects = split_json_array(inner);
        let filtered: Vec<String> = objects
            .iter()
            .map(|obj| filter_single_json_object(obj.trim(), fields))
            .collect();
        format!("[{}]", filtered.join(","))
    } else if trimmed.starts_with('{') {
        filter_single_json_object(trimmed, fields)
    } else {
        json.to_string()
    }
}

/// Split a JSON array's inner content into individual elements, respecting nesting.
fn split_json_array(s: &str) -> Vec<String> {
    let mut result = Vec::new();
    let mut depth = 0;
    let mut start = 0;
    let bytes = s.as_bytes();
    let mut in_string = false;
    let mut escape = false;

    for i in 0..bytes.len() {
        if escape {
            escape = false;
            continue;
        }
        match bytes[i] {
            b'\\' if in_string => escape = true,
            b'"' => in_string = !in_string,
            b'{' | b'[' if !in_string => depth += 1,
            b'}' | b']' if !in_string => depth -= 1,
            b',' if !in_string && depth == 0 => {
                let elem = s[start..i].trim();
                if !elem.is_empty() {
                    result.push(elem.to_string());
                }
                start = i + 1;
            }
            _ => {}
        }
    }
    let last = s[start..].trim();
    if !last.is_empty() {
        result.push(last.to_string());
    }
    result
}

/// Filter a single JSON object to only include specified fields.
fn filter_single_json_object(json: &str, fields: &[String]) -> String {
    // Parse key-value pairs from the JSON object
    let trimmed = json.trim().trim_start_matches('{').trim_end_matches('}');
    let mut result_parts = Vec::new();
    let mut pos = 0;
    let bytes = trimmed.as_bytes();

    while pos < bytes.len() {
        // Skip whitespace
        while pos < bytes.len() && bytes[pos].is_ascii_whitespace() {
            pos += 1;
        }
        if pos >= bytes.len() {
            break;
        }

        // Expect a quoted key
        if bytes[pos] != b'"' {
            pos += 1;
            continue;
        }
        pos += 1; // skip opening quote
        let key_start = pos;
        while pos < bytes.len() && bytes[pos] != b'"' {
            if bytes[pos] == b'\\' {
                pos += 1;
            }
            pos += 1;
        }
        let key = &trimmed[key_start..pos];
        pos += 1; // skip closing quote

        // Skip colon and whitespace
        while pos < bytes.len() && (bytes[pos] == b':' || bytes[pos].is_ascii_whitespace()) {
            pos += 1;
        }

        // Read value (could be string, number, object, array, bool, null)
        let value_start = pos;
        let mut depth = 0;
        let mut in_str = false;
        let mut esc = false;
        loop {
            if pos >= bytes.len() {
                break;
            }
            if esc {
                esc = false;
                pos += 1;
                continue;
            }
            match bytes[pos] {
                b'\\' if in_str => {
                    esc = true;
                    pos += 1;
                }
                b'"' => {
                    in_str = !in_str;
                    pos += 1;
                }
                b'{' | b'[' if !in_str => {
                    depth += 1;
                    pos += 1;
                }
                b'}' | b']' if !in_str => {
                    if depth == 0 {
                        break;
                    }
                    depth -= 1;
                    pos += 1;
                }
                b',' if !in_str && depth == 0 => {
                    break;
                }
                _ => {
                    pos += 1;
                }
            }
        }
        let value = trimmed[value_start..pos].trim();

        // Skip comma
        if pos < bytes.len() && bytes[pos] == b',' {
            pos += 1;
        }

        // Check if this key is in the allowed fields
        if fields.iter().any(|f| f == key) {
            result_parts.push(format!("\"{}\":{}", key, value));
        }
    }

    format!("{{{}}}", result_parts.join(","))
}

/// If expose fields are configured for this path, filter the JSON response.
fn maybe_filter_expose(path: &str, json: &str) -> String {
    match get_expose_fields(path) {
        Some(fields) => filter_json_fields(json, &fields),
        None => json.to_string(),
    }
}

fn check_rate_limit(port: u16, path: &str, client_ip: &str) -> bool {
    let rules_guard = rate_limits_map();
    let rules = match rules_guard.as_ref().unwrap().get(&port) {
        Some(r) => r,
        None => return true, // No rules for this port
    };

    let now = Instant::now();

    for rule in rules {
        if path.starts_with(&rule.path_prefix) {
            let key = (port, rule.path_prefix.clone());
            let window = std::time::Duration::from_secs(rule.window_seconds as u64);

            let mut tracker = rate_tracker_map();
            let ip_map = tracker
                .as_mut()
                .unwrap()
                .entry(key)
                .or_default();

            let timestamps = ip_map.entry(client_ip.to_string()).or_default();

            // Remove expired entries
            timestamps.retain(|t| now.duration_since(*t) < window);

            if timestamps.len() as i64 >= rule.max_requests {
                return false; // Rate limited
            }

            timestamps.push(now);
            return true;
        }
    }

    true // No matching rule
}

// ══════════════════════════════════════════════════════════════════════
// Feature 7: CRUD Configuration — Auth, Pagination, Nested Routes
// ══════════════════════════════════════════════════════════════════════

/// Maps port -> auth setting string (e.g. "required", "optional", "none")
static CRUD_AUTH_SETTING: Mutex<Option<HashMap<u16, String>>> = Mutex::new(None);

fn crud_auth_map() -> std::sync::MutexGuard<'static, Option<HashMap<u16, String>>> {
    let mut guard = CRUD_AUTH_SETTING.lock().unwrap();
    if guard.is_none() {
        *guard = Some(HashMap::new());
    }
    guard
}

/// Set the auth requirement for CRUD endpoints on this server.
/// setting: "required", "optional", "none", or a custom auth package name.
#[no_mangle]
pub extern "C" fn forge_http_crud_set_auth(
    port: i64,
    setting: *const c_char,
) {
    let s = cstr(setting).to_string();
    crud_auth_map()
        .as_mut()
        .unwrap()
        .insert(port as u16, s);
}

/// Maps port -> default page size for CRUD list endpoints
static CRUD_PAGINATE_SIZE: Mutex<Option<HashMap<u16, i64>>> = Mutex::new(None);

fn crud_paginate_map() -> std::sync::MutexGuard<'static, Option<HashMap<u16, i64>>> {
    let mut guard = CRUD_PAGINATE_SIZE.lock().unwrap();
    if guard.is_none() {
        *guard = Some(HashMap::new());
    }
    guard
}

/// Set default pagination page size for all CRUD list endpoints on this server.
#[no_mangle]
pub extern "C" fn forge_http_crud_set_paginate(
    port: i64,
    page_size: i64,
) {
    crud_paginate_map()
        .as_mut()
        .unwrap()
        .insert(port as u16, page_size);
}

/// Nested CRUD route entry
struct CrudNestEntry {
    child: String,
    parent: String,
    path: String,
}

/// Maps port -> list of nested route definitions
static CRUD_NEST_ROUTES: Mutex<Option<HashMap<u16, Vec<CrudNestEntry>>>> = Mutex::new(None);

fn crud_nest_map() -> std::sync::MutexGuard<'static, Option<HashMap<u16, Vec<CrudNestEntry>>>> {
    let mut guard = CRUD_NEST_ROUTES.lock().unwrap();
    if guard.is_none() {
        *guard = Some(HashMap::new());
    }
    guard
}

/// Register a nested CRUD route: child model nested under parent at the given path.
/// e.g. crud_nest(port, "Comment", "Post", "/posts/:id/comments")
#[no_mangle]
pub extern "C" fn forge_http_crud_nest(
    port: i64,
    child: *const c_char,
    parent: *const c_char,
    path: *const c_char,
) {
    let child_s = cstr(child).to_string();
    let parent_s = cstr(parent).to_string();
    let path_s = cstr(path).to_string();
    crud_nest_map()
        .as_mut()
        .unwrap()
        .entry(port as u16)
        .or_default()
        .push(CrudNestEntry {
            child: child_s,
            parent: parent_s,
            path: path_s,
        });
}

/// Get the auth setting for a given port, if configured.
fn get_crud_auth(port: u16) -> Option<String> {
    let guard = crud_auth_map();
    guard.as_ref().unwrap().get(&port).cloned()
}

/// Get the pagination page size for a given port, if configured.
fn get_crud_page_size(port: u16) -> Option<i64> {
    let guard = crud_paginate_map();
    guard.as_ref().unwrap().get(&port).copied()
}

// ---------------------------------------------------------------------------
// HTTP Client
// ---------------------------------------------------------------------------

/// Helper: convert a C string pointer to a Rust String.
fn http_c_str_to_string(ptr: *const c_char) -> String {
    if ptr.is_null() {
        return String::new();
    }
    unsafe { CStr::from_ptr(ptr) }
        .to_str()
        .unwrap_or("")
        .to_string()
}

/// Helper: convert a Rust String to a leaked C string pointer.
fn http_string_to_c(s: String) -> *const c_char {
    CString::new(s)
        .unwrap_or_else(|_| CString::new("").unwrap())
        .into_raw() as *const c_char
}

/// Make an HTTP request.
/// method: "GET", "POST", "PUT", "DELETE", "PATCH", "HEAD"
/// url: the URL to request
/// headers_json: JSON object of headers, e.g. {"Content-Type": "application/json"} or empty string for none
/// body: request body string, or empty string for none
/// Returns JSON: {"status": 200, "body": "...", "headers": {"content-type": "..."}}
#[no_mangle]
pub extern "C" fn forge_http_request(
    method: *const c_char,
    url: *const c_char,
    headers_json: *const c_char,
    body: *const c_char,
) -> *const c_char {
    let method_str = http_c_str_to_string(method);
    let url_str = http_c_str_to_string(url);
    let headers_str = http_c_str_to_string(headers_json);
    let body_str = http_c_str_to_string(body);

    let request = match method_str.to_uppercase().as_str() {
        "GET" => ureq::get(&url_str),
        "POST" => ureq::post(&url_str),
        "PUT" => ureq::put(&url_str),
        "DELETE" => ureq::delete(&url_str),
        "PATCH" => ureq::patch(&url_str),
        "HEAD" => ureq::head(&url_str),
        _ => return http_string_to_c(format!(r#"{{"status":0,"body":"unsupported method: {}","headers":{{}}}}"#, method_str)),
    };

    // Add headers
    let request = if !headers_str.is_empty() {
        if let Ok(headers) = serde_json::from_str::<serde_json::Value>(&headers_str) {
            if let Some(obj) = headers.as_object() {
                let mut req = request;
                for (key, value) in obj {
                    if let Some(v) = value.as_str() {
                        req = req.set(key, v);
                    }
                }
                req
            } else {
                request
            }
        } else {
            request
        }
    } else {
        request
    };

    // Send request
    let result = if !body_str.is_empty() {
        request.send_string(&body_str)
    } else {
        request.call()
    };

    match result {
        Ok(response) => {
            let status = response.status();
            // Collect response headers
            let mut resp_headers = serde_json::Map::new();
            for name in response.headers_names() {
                if let Some(value) = response.header(&name) {
                    resp_headers.insert(name, serde_json::Value::String(value.to_string()));
                }
            }
            let body = response.into_string().unwrap_or_default();
            let result = serde_json::json!({
                "status": status,
                "body": body,
                "headers": resp_headers,
            });
            http_string_to_c(result.to_string())
        }
        Err(ureq::Error::Status(status, response)) => {
            let body = response.into_string().unwrap_or_default();
            let result = serde_json::json!({
                "status": status,
                "body": body,
                "headers": {},
            });
            http_string_to_c(result.to_string())
        }
        Err(e) => {
            let result = serde_json::json!({
                "status": 0,
                "body": format!("request failed: {}", e),
                "headers": {},
            });
            http_string_to_c(result.to_string())
        }
    }
}

/// Convenience: HTTP GET, returns just the body string.
#[no_mangle]
pub extern "C" fn forge_http_get(url: *const c_char) -> *const c_char {
    let url_str = http_c_str_to_string(url);
    match ureq::get(&url_str).call() {
        Ok(response) => {
            let body = response.into_string().unwrap_or_default();
            http_string_to_c(body)
        }
        Err(ureq::Error::Status(_, response)) => {
            let body = response.into_string().unwrap_or_default();
            http_string_to_c(body)
        }
        Err(e) => http_string_to_c(format!("error: {}", e)),
    }
}

/// Convenience: HTTP POST with JSON body, returns response body string.
#[no_mangle]
pub extern "C" fn forge_http_post(
    url: *const c_char,
    body: *const c_char,
) -> *const c_char {
    let url_str = http_c_str_to_string(url);
    let body_str = http_c_str_to_string(body);
    match ureq::post(&url_str)
        .set("Content-Type", "application/json")
        .send_string(&body_str)
    {
        Ok(response) => {
            let body = response.into_string().unwrap_or_default();
            http_string_to_c(body)
        }
        Err(ureq::Error::Status(_, response)) => {
            let body = response.into_string().unwrap_or_default();
            http_string_to_c(body)
        }
        Err(e) => http_string_to_c(format!("error: {}", e)),
    }
}

/// Download a URL to a file. Returns "ok" on success, error message on failure.
#[no_mangle]
pub extern "C" fn forge_http_download(
    url: *const c_char,
    output_path: *const c_char,
) -> *const c_char {
    let url_str = http_c_str_to_string(url);
    let path_str = http_c_str_to_string(output_path);

    match ureq::get(&url_str).call() {
        Ok(response) => {
            let mut reader = response.into_reader();
            match std::fs::File::create(&path_str) {
                Ok(mut file) => {
                    match std::io::copy(&mut reader, &mut file) {
                        Ok(_) => http_string_to_c("ok".to_string()),
                        Err(e) => http_string_to_c(format!("write error: {}", e)),
                    }
                }
                Err(e) => http_string_to_c(format!("file create error: {}", e)),
            }
        }
        Err(e) => http_string_to_c(format!("download error: {}", e)),
    }
}
