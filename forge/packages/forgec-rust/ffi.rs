//! FFI interface for the Forge compiler.
//!
//! Exposes compiler commands as extern "C" functions so the Forge CLI
//! (and other Forge programs) can call them directly via FFI instead of
//! spawning subprocesses.

use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use std::path::PathBuf;

use crate::driver::{Driver, OptLevel, ErrorFormat};
use crate::errors::CompileError;

// ── Helpers ──────────────────────────────────────────────────────────

fn cstr(ptr: *const c_char) -> String {
    if ptr.is_null() {
        return String::new();
    }
    unsafe { CStr::from_ptr(ptr) }
        .to_str()
        .unwrap_or("")
        .to_string()
}

/// Render a CompileError to stderr and return 1.
fn fail(e: CompileError) -> i64 {
    eprint!("{}", e.render());
    1
}

/// Resolve target file/project: returns (is_project, path).
fn resolve_target(file: &str) -> Result<(bool, PathBuf), i64> {
    if file.is_empty() {
        let cwd = std::env::current_dir().unwrap_or_else(|_| PathBuf::from("."));
        if cwd.join("forge.toml").exists() {
            Ok((true, cwd))
        } else {
            eprintln!("{}", CompileError::CliError {
                message: "no source file or project directory specified".to_string(),
                help: Some("usage: forge build <file.fg> or forge run <file.fg>".to_string()),
            }.render());
            Err(1)
        }
    } else {
        let path = PathBuf::from(file);
        if path.is_dir() || path.join("forge.toml").exists() {
            Ok((true, path))
        } else {
            Ok((false, path))
        }
    }
}

// ── Commands ─────────────────────────────────────────────────────────

/// Compile a Forge source file or project.
/// Returns 0 on success, non-zero on failure.
#[no_mangle]
pub extern "C" fn forge_compiler_build(
    file: *const c_char,
    dev: i64,
    emit_ir: i64,
    emit_ast: i64,
    error_format: *const c_char,
    output: *const c_char,
    max_errors: i64,
    profile: i64,
    profile_format: *const c_char,
) -> i64 {
    let file_str = cstr(file);
    let fmt = cstr(error_format);
    let out = cstr(output);
    let pfmt = cstr(profile_format);

    let (is_project, path) = match resolve_target(&file_str) {
        Ok(v) => v,
        Err(code) => return code,
    };

    let mut driver = Driver::new();
    driver.emit_ir = emit_ir != 0;
    driver.emit_ast = emit_ast != 0;
    driver.optimization = if dev != 0 { OptLevel::Dev } else { OptLevel::Release };
    driver.error_format = if fmt == "json" { ErrorFormat::Json } else { ErrorFormat::Human };
    if !out.is_empty() {
        driver.output = Some(PathBuf::from(out));
    }
    driver.max_errors = max_errors as usize;
    driver.profile = profile != 0;
    driver.profile_format = pfmt;

    let result = if is_project {
        driver.compile_project(&path)
    } else {
        driver.compile(&path)
    };

    match result {
        Ok(path) => {
            if !driver.emit_ir && !driver.emit_ast {
                eprintln!("compiled to {}", path.display());
            }
            0
        }
        Err(e) => fail(e),
    }
}

/// Compile and run a Forge source file or project.
/// Returns exit code of the executed program, or non-zero on compilation failure.
#[no_mangle]
pub extern "C" fn forge_compiler_run(
    file: *const c_char,
    dev: i64,
    no_jit: i64,
    profile: i64,
) -> i64 {
    let file_str = cstr(file);

    let (is_project, path) = match resolve_target(&file_str) {
        Ok(v) => v,
        Err(code) => return code,
    };

    let mut driver = Driver::new();
    driver.optimization = if dev != 0 { OptLevel::Dev } else { OptLevel::Release };
    driver.profile = profile != 0;

    // JIT path for single files
    if !is_project && no_jit == 0 {
        match driver.run_jit(&path) {
            Ok(exit_code) => return exit_code as i64,
            Err(e) => return fail(e),
        }
    }

    // AOT fallback
    let output = std::env::temp_dir().join(format!("forge_run_{}", std::process::id()));
    driver.output = Some(output.clone());

    let result = if is_project {
        driver.compile_project(&path)
    } else {
        driver.compile(&path)
    };

    match result {
        Ok(binary) => {
            let status = std::process::Command::new(&binary)
                .stdin(std::process::Stdio::inherit())
                .stdout(std::process::Stdio::inherit())
                .stderr(std::process::Stdio::inherit())
                .status();
            std::fs::remove_file(&binary).ok();
            match status {
                Ok(s) => s.code().unwrap_or(1) as i64,
                Err(e) => fail(CompileError::BinaryRunFailed {
                    path: binary.display().to_string(),
                    detail: e.to_string(),
                }),
            }
        }
        Err(e) => fail(e),
    }
}

/// Type-check a Forge source file without compiling.
/// Returns 0 on success, non-zero on failure.
#[no_mangle]
pub extern "C" fn forge_compiler_check(
    file: *const c_char,
    error_format: *const c_char,
    max_errors: i64,
) -> i64 {
    let file_str = cstr(file);
    let fmt = cstr(error_format);

    if file_str.is_empty() {
        return fail(CompileError::CliError {
            message: "no source file specified".to_string(),
            help: Some("usage: forge check <file.fg>".to_string()),
        });
    }

    let mut driver = Driver::new();
    driver.error_format = if fmt == "json" { ErrorFormat::Json } else { ErrorFormat::Human };
    driver.max_errors = max_errors as usize;

    match driver.check(&PathBuf::from(file_str)) {
        Ok(()) => 0,
        Err(e) => fail(e),
    }
}

/// Run feature example tests.
/// `target` can be empty (run all) or a feature name.
/// Returns 0 if all pass, 1 if any fail.
#[no_mangle]
pub extern "C" fn forge_compiler_test(
    target: *const c_char,
    format: *const c_char,
    filter: *const c_char,
    fail_fast: i64,
    no_color: i64,
    verbose: i64,
    quiet: i64,
    jobs: i64,
) -> i64 {
    let target_str = cstr(target);
    let format_str = cstr(format);
    let filter_str = cstr(filter);

    let fmt = match format_str.as_str() {
        "json" => crate::test_runner::OutputFormat::Json,
        "stream" => crate::test_runner::OutputFormat::Stream,
        _ => crate::test_runner::OutputFormat::Human,
    };

    let config = crate::test_runner::TestRunConfig {
        format: fmt,
        filter: if filter_str.is_empty() { None } else { Some(filter_str) },
        fail_fast: fail_fast != 0,
        no_color: no_color != 0,
        verbose: verbose != 0,
        quiet: quiet != 0,
        jobs: if jobs > 0 { jobs as usize } else { 0 },
    };

    let target = if target_str.is_empty() { None } else { Some(target_str.as_str()) };
    let passed = crate::test_runner::run_tests(target, &config);
    if passed { 0 } else { 1 }
}

/// List features or show detail for a specific feature.
/// Returns 0 on success.
#[no_mangle]
pub extern "C" fn forge_compiler_features(
    feature: *const c_char,
    graph: i64,
) -> i64 {
    let feature_str = cstr(feature);

    if !feature_str.is_empty() {
        crate::registry::FeatureRegistry::print_detail(&feature_str);
    } else if graph != 0 {
        crate::registry::FeatureRegistry::print_graph();
    } else {
        crate::registry::FeatureRegistry::print_table();
    }
    0
}

/// Explain an error code.
/// Returns 0 on success, 1 if code is unknown.
#[no_mangle]
pub extern "C" fn forge_compiler_explain(code: *const c_char) -> i64 {
    let code_str = cstr(code);
    let registry = crate::errors::ErrorRegistry::builtin();
    match registry.lookup(&code_str) {
        Some(entry) => {
            println!("[{}] {}", entry.code, entry.title);
            println!();
            println!("Level: {:?}", entry.level);
            println!();
            if !entry.message.is_empty() {
                println!("{}", entry.message);
                println!();
            }
            if !entry.help.is_empty() {
                println!("Help: {}", entry.help);
                println!();
            }
            if !entry.doc.is_empty() {
                println!("{}", entry.doc);
            }
            0
        }
        None => fail(CompileError::CliError {
            message: format!("unknown error code '{}'", code_str),
            help: Some("run `forge explain F0001` to see valid codes".to_string()),
        }),
    }
}

/// Explain type derivation at a specific file:line.
/// Returns 0 on success, 1 on failure.
#[no_mangle]
pub extern "C" fn forge_compiler_why(file_line: *const c_char) -> i64 {
    let input = cstr(file_line);
    let parts: Vec<&str> = input.rsplitn(2, ':').collect();
    if parts.len() != 2 {
        return fail(CompileError::CliError {
            message: format!("invalid format '{}' — expected file.fg:LINE", input),
            help: Some("example: forge why main.fg:5".to_string()),
        });
    }
    let line: u32 = match parts[0].parse() {
        Ok(n) => n,
        Err(_) => {
            return fail(CompileError::CliError {
                message: format!("invalid line number '{}'", parts[0]),
                help: Some("line number must be a positive integer".to_string()),
            });
        }
    };
    let file = PathBuf::from(parts[1]);
    let driver = Driver::new();
    match driver.explain_line(&file, line) {
        Ok(()) => 0,
        Err(e) => fail(e),
    }
}

/// Explore the Forge language.
/// `query` is the topic to look up (empty for overview).
/// Flags control output mode.
/// Returns 0.
#[no_mangle]
pub extern "C" fn forge_compiler_lang(
    query: *const c_char,
    all: i64,
    symbols: i64,
    llm: i64,
    short: i64,
    grammar: i64,
    cheatsheet: i64,
    search: *const c_char,
    validate: i64,
) -> i64 {
    let query_str = cstr(query);
    let search_str = cstr(search);

    if validate != 0 {
        crate::lang::validate_lang();
    } else if !search_str.is_empty() {
        crate::lang::show_search(&search_str);
    } else if grammar != 0 {
        crate::lang::show_grammar();
    } else if cheatsheet != 0 {
        crate::lang::show_cheatsheet();
    } else if llm != 0 {
        if query_str == "full" {
            crate::lang::show_llm_full();
        } else {
            crate::lang::show_llm_compact();
        }
    } else if symbols != 0 {
        crate::lang::show_symbols();
    } else if all != 0 {
        crate::lang::show_all();
    } else if !query_str.is_empty() {
        if short != 0 {
            crate::lang::show_short(&query_str);
        } else {
            crate::lang::resolve(&query_str);
        }
    } else {
        crate::lang::show_all();
    }
    0
}

/// Project documentation lookup.
/// Returns 0 on success, 1 if symbol not found.
#[no_mangle]
pub extern "C" fn forge_compiler_docs(
    query: *const c_char,
    symbols: i64,
    short: i64,
    search: *const c_char,
    llm: i64,
    validate: i64,
) -> i64 {
    let query_str = cstr(query);
    let search_str = cstr(search);

    if validate != 0 {
        crate::docs::validate_docs(".");
        return 0;
    }

    let cwd = std::env::current_dir().unwrap_or_else(|_| PathBuf::from("."));
    let docs = crate::docs::extract_project_docs(&cwd);

    if !search_str.is_empty() {
        crate::docs::show_search(&search_str, &docs);
    } else if llm != 0 {
        crate::docs::show_llm(&docs);
    } else if symbols != 0 {
        crate::docs::show_symbols(&docs);
    } else if !query_str.is_empty() {
        if short != 0 {
            if !crate::docs::show_short(&query_str, &docs) {
                eprintln!("\n  No symbol '{}' found in project.\n  Hint: try `forge docs` for an overview.\n", query_str);
                return 1;
            }
        } else if !crate::docs::show_symbol(&query_str, &docs) {
            eprintln!("\n  No symbol '{}' found in project.\n  Hint: try `forge docs` for an overview.\n", query_str);
            return 1;
        }
    } else {
        crate::docs::show_overview(&docs);
    }
    0
}

/// Scaffold a new package.
/// Returns 0 on success, 1 on failure.
#[no_mangle]
pub extern "C" fn forge_compiler_package_new(
    name: *const c_char,
    component: i64,
) -> i64 {
    let name_str = cstr(name);
    match crate::package::scaffold_package(&name_str, component != 0) {
        Ok(()) => 0,
        Err(e) => fail(CompileError::CliError {
            message: e,
            help: Some("check write permissions and that the directory doesn't already exist".to_string()),
        }),
    }
}

/// Diff two JSON diagnostic dumps.
/// Returns 0 on success, 1 on failure.
#[no_mangle]
pub extern "C" fn forge_compiler_errors_diff(
    before: *const c_char,
    after: *const c_char,
) -> i64 {
    let before_path = PathBuf::from(cstr(before));
    let after_path = PathBuf::from(cstr(after));

    let before_json = match std::fs::read_to_string(&before_path) {
        Ok(s) => s,
        Err(e) => return fail(CompileError::FileNotFound {
            path: before_path.display().to_string(),
            detail: e.to_string(),
        }),
    };
    let after_json = match std::fs::read_to_string(&after_path) {
        Ok(s) => s,
        Err(e) => return fail(CompileError::FileNotFound {
            path: after_path.display().to_string(),
            detail: e.to_string(),
        }),
    };
    match crate::errors::diff::diff_json(&before_json, &after_json) {
        Ok(result) => {
            println!("{}", result.render());
            0
        }
        Err(e) => fail(CompileError::CliError {
            message: format!("failed to diff diagnostics: {}", e),
            help: Some("ensure both files contain valid JSON diagnostic output".to_string()),
        }),
    }
}

/// Get compiler version string.
/// Returns a pointer to a C string (caller must not free).
#[no_mangle]
pub extern "C" fn forge_compiler_version() -> *const c_char {
    static VERSION: &[u8] = b"0.1.0\0";
    VERSION.as_ptr() as *const c_char
}

// ── String cleanup ───────────────────────────────────────────────────

/// Free a string returned by an FFI function.
#[no_mangle]
pub extern "C" fn forge_compiler_free_string(ptr: *mut c_char) {
    if !ptr.is_null() {
        unsafe { drop(CString::from_raw(ptr)); }
    }
}
