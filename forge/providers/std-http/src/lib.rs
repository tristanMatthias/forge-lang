use std::ffi::{CStr, CString};
use std::io::Read;
use std::os::raw::c_char;
use std::sync::Mutex;
use tiny_http::{Header, Method, Request, Response, Server};

type HandlerFn = extern "C" fn(
    method: *const c_char,
    path: *const c_char,
    body: *const c_char,
    params_json: *const c_char,
    response_buf: *mut c_char,
    response_buf_len: i64,
) -> i64; // returns status code

struct Route {
    method: String,
    path_pattern: String,
    handler: HandlerFn,
}

static ROUTES: Mutex<Vec<Route>> = Mutex::new(Vec::new());

#[no_mangle]
pub extern "C" fn forge_http_add_route(
    method: *const c_char,
    path: *const c_char,
    handler: HandlerFn,
) {
    let method = unsafe { CStr::from_ptr(method) }
        .to_str()
        .unwrap()
        .to_string();
    let path = unsafe { CStr::from_ptr(path) }
        .to_str()
        .unwrap()
        .to_string();
    ROUTES.lock().unwrap().push(Route {
        method,
        path_pattern: path,
        handler,
    });
}

#[no_mangle]
pub extern "C" fn forge_http_serve(port: u16) {
    let addr = format!("0.0.0.0:{}", port);
    let server = Server::http(&addr).expect("Failed to start server");
    eprintln!("Server running on http://localhost:{}", port);

    for request in server.incoming_requests() {
        handle_request(request);
    }
}

fn handle_request(mut request: Request) {
    let method = request.method().to_string().to_uppercase();
    let url = request.url().to_string();
    let path = url.split('?').next().unwrap_or(&url).to_string();

    // Read body
    let mut body = String::new();
    request.as_reader().read_to_string(&mut body).ok();

    let routes = ROUTES.lock().unwrap();

    for route in routes.iter() {
        if route.method == method {
            if let Some(params) = match_path(&route.path_pattern, &path) {
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

                let header =
                    Header::from_bytes("Content-Type", "application/json").unwrap();

                if status == 204 {
                    // No content
                    let response = Response::from_string("")
                        .with_status_code(status as i32)
                        .with_header(header);
                    request.respond(response).ok();
                } else {
                    let response = Response::from_string(response_body)
                        .with_status_code(status as i32)
                        .with_header(header);
                    request.respond(response).ok();
                }
                return;
            }
        }
    }

    // 404
    let header = Header::from_bytes("Content-Type", "application/json").unwrap();
    let response = Response::from_string("{\"error\":\"not found\"}")
        .with_status_code(404)
        .with_header(header);
    request.respond(response).ok();
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
