use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use std::sync::Mutex;
use std::time::{SystemTime, UNIX_EPOCH};

use jsonwebtoken::{decode, encode, Algorithm, DecodingKey, EncodingKey, Header, Validation};
use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};

// ---------------------------------------------------------------------------
// Global config
// ---------------------------------------------------------------------------

struct AuthConfig {
    secret: String,
    expiry_seconds: i64,
}

static AUTH_CONFIG: Mutex<Option<AuthConfig>> = Mutex::new(None);

// ---------------------------------------------------------------------------
// JWT claims
// ---------------------------------------------------------------------------

#[derive(Debug, Serialize, Deserialize)]
struct Claims {
    sub: String,
    role: String,
    exp: u64,
    // preserve any extra fields from the input
    #[serde(flatten)]
    extra: serde_json::Value,
}

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

fn now_secs() -> u64 {
    SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap_or_default()
        .as_secs()
}

// ---------------------------------------------------------------------------
// Exported functions
// ---------------------------------------------------------------------------

/// Initialize the auth system with a secret and token expiry.
#[no_mangle]
pub extern "C" fn forge_auth_init(secret: *const c_char, expiry_seconds: i64) {
    let secret = c_str_to_string(secret);
    let mut cfg = AUTH_CONFIG.lock().unwrap();
    *cfg = Some(AuthConfig {
        secret,
        expiry_seconds,
    });
}

/// Create a JWT token from user JSON (must contain "id" and "role" fields).
/// Returns the token string.
#[no_mangle]
pub extern "C" fn forge_auth_create_token(user_json: *const c_char) -> *const c_char {
    let json_str = c_str_to_string(user_json);

    let cfg_guard = AUTH_CONFIG.lock().unwrap();
    let cfg = match cfg_guard.as_ref() {
        Some(c) => c,
        None => return string_to_c(String::new()),
    };

    // Parse the user JSON to extract id and role
    let user: serde_json::Value = match serde_json::from_str(&json_str) {
        Ok(v) => v,
        Err(_) => return string_to_c(String::new()),
    };

    let sub = match user.get("id") {
        Some(v) => match v {
            serde_json::Value::Number(n) => n.to_string(),
            serde_json::Value::String(s) => s.clone(),
            _ => "0".to_string(),
        },
        None => "0".to_string(),
    };

    let role = user
        .get("role")
        .and_then(|v| v.as_str())
        .unwrap_or("user")
        .to_string();

    let exp = now_secs() + cfg.expiry_seconds as u64;

    let claims = Claims {
        sub,
        role,
        exp,
        extra: serde_json::Value::Null,
    };

    let token = encode(
        &Header::default(),
        &claims,
        &EncodingKey::from_secret(cfg.secret.as_bytes()),
    );

    match token {
        Ok(t) => string_to_c(t),
        Err(_) => string_to_c(String::new()),
    }
}

/// Verify a JWT token and return the claims as JSON.
/// Returns empty string on failure.
#[no_mangle]
pub extern "C" fn forge_auth_verify_token(token: *const c_char) -> *const c_char {
    let token_str = c_str_to_string(token);

    let cfg_guard = AUTH_CONFIG.lock().unwrap();
    let cfg = match cfg_guard.as_ref() {
        Some(c) => c,
        None => return string_to_c(String::new()),
    };

    let mut validation = Validation::new(Algorithm::HS256);
    validation.validate_exp = true;

    let token_data = decode::<Claims>(
        &token_str,
        &DecodingKey::from_secret(cfg.secret.as_bytes()),
        &validation,
    );

    match token_data {
        Ok(data) => {
            let result = serde_json::json!({
                "sub": data.claims.sub,
                "role": data.claims.role,
                "exp": data.claims.exp,
            });
            string_to_c(result.to_string())
        }
        Err(_) => string_to_c(String::new()),
    }
}

/// Check if a token has the required role. Returns 1 if yes, 0 otherwise.
#[no_mangle]
pub extern "C" fn forge_auth_check_role(
    token: *const c_char,
    required_role: *const c_char,
) -> i64 {
    let token_str = c_str_to_string(token);
    let role_str = c_str_to_string(required_role);

    let cfg_guard = AUTH_CONFIG.lock().unwrap();
    let cfg = match cfg_guard.as_ref() {
        Some(c) => c,
        None => return 0,
    };

    let mut validation = Validation::new(Algorithm::HS256);
    validation.validate_exp = true;

    let token_data = decode::<Claims>(
        &token_str,
        &DecodingKey::from_secret(cfg.secret.as_bytes()),
        &validation,
    );

    match token_data {
        Ok(data) => {
            if data.claims.role == role_str {
                1
            } else {
                0
            }
        }
        Err(_) => 0,
    }
}

/// Hash a password using SHA-256. Returns hex-encoded hash.
#[no_mangle]
pub extern "C" fn forge_auth_hash_password(password: *const c_char) -> *const c_char {
    let pw = c_str_to_string(password);

    let mut hasher = Sha256::new();
    hasher.update(pw.as_bytes());
    let result = hasher.finalize();
    let hex_str = hex::encode(result);

    string_to_c(hex_str)
}

/// Verify a password against a SHA-256 hash. Returns 1 if match, 0 otherwise.
#[no_mangle]
pub extern "C" fn forge_auth_verify_password(
    password: *const c_char,
    hash: *const c_char,
) -> i64 {
    let pw = c_str_to_string(password);
    let expected_hash = c_str_to_string(hash);

    let mut hasher = Sha256::new();
    hasher.update(pw.as_bytes());
    let result = hasher.finalize();
    let computed_hash = hex::encode(result);

    if computed_hash == expected_hash {
        1
    } else {
        0
    }
}
