use clap::{Parser, Subcommand};
use std::path::PathBuf;
use std::process;

use forge::driver::{Driver, ErrorFormat, OptLevel};
use forge::errors::CompileError;

#[derive(Parser)]
#[command(name = "compiler", version = "0.1.0", about = "The Forge programming language compiler")]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Compile a Forge source file or project
    Build {
        /// Input source file or project directory
        file: Option<PathBuf>,

        /// Debug build (O0, fast compile)
        #[arg(long)]
        dev: bool,

        /// Release build (O2, optimized)
        #[arg(long)]
        release: bool,

        /// Output LLVM IR instead of binary
        #[arg(long)]
        emit_ir: bool,

        /// Output parsed AST
        #[arg(long)]
        emit_ast: bool,

        /// Error format: "human" or "json"
        #[arg(long, default_value = "human")]
        error_format: String,

        /// Output binary path
        #[arg(short, long)]
        output: Option<PathBuf>,

        /// Maximum number of errors to display
        #[arg(long, default_value = "20")]
        max_errors: usize,

        /// Show build profiling with per-stage timings
        #[arg(long)]
        profile: bool,

        /// Profile output format: "human" or "json"
        #[arg(long, default_value = "human")]
        profile_format: String,
    },

    /// Compile and run a Forge source file or project
    Run {
        /// Input source file or project directory
        file: Option<PathBuf>,

        /// Debug build
        #[arg(long)]
        dev: bool,

        /// Disable JIT execution, use compile+link instead
        #[arg(long)]
        no_jit: bool,

        /// Show build profiling with per-stage timings
        #[arg(long)]
        profile: bool,

        /// Arguments passed to the compiled program
        #[arg(last = true)]
        args: Vec<String>,
    },

    /// Type-check without compiling
    Check {
        /// Input source file
        file: PathBuf,

        /// Error format: "human" or "json"
        #[arg(long, default_value = "human")]
        error_format: String,

        /// Maximum number of errors to display
        #[arg(long, default_value = "20")]
        max_errors: usize,

        /// Automatically apply high-confidence fixes
        #[arg(long)]
        autofix: bool,
    },

    /// Explain an error code (e.g., `compiler explain F0020`)
    Explain {
        /// Error code to explain (e.g., F0020)
        code: String,
    },

    /// Print version info
    Version,

    /// Package management commands
    Package {
        #[command(subcommand)]
        command: PackageCommands,
    },

    /// Explain how types are derived on a specific line
    Why {
        /// File and line (e.g., file.fg:5)
        file_line: String,
    },

    /// Error diagnostic tools
    Errors {
        #[command(subcommand)]
        command: ErrorCommands,
    },

    /// List all language features with status and dependencies
    Features {
        /// Show a specific feature by id
        feature: Option<String>,

        /// Show the dependency graph
        #[arg(long)]
        graph: bool,
    },

    /// Explore the Forge language: features, types, syntax, errors
    Lang {
        /// Feature, type, symbol, or error code to look up
        query: Option<String>,

        /// Show all features, types, and errors
        #[arg(long)]
        all: bool,

        /// Show symbol/token reference
        #[arg(long)]
        symbols: bool,

        /// Compact LLM-friendly language spec (use with query "full" for examples)
        #[arg(long)]
        llm: bool,

        /// Show just the one-liner for a feature
        #[arg(long)]
        short: bool,

        /// Show BNF-style grammar
        #[arg(long)]
        grammar: bool,

        /// Show printable cheatsheet
        #[arg(long)]
        cheatsheet: bool,

        /// Search language docs
        #[arg(long)]
        search: Option<String>,

        /// Validate documentation coverage for the language
        #[arg(long)]
        validate: bool,

        /// Generate a static documentation website
        #[arg(long)]
        site: bool,

        /// Output directory for --site (default: docs/lang-site)
        #[arg(long, default_value = "docs/lang-site")]
        site_dir: String,
    },

    /// Project documentation -- look up your project's functions, types, and enums
    Docs {
        /// Symbol to look up (function, type, enum name)
        query: Option<String>,

        /// Show symbol/type reference
        #[arg(long)]
        symbols: bool,

        /// Show just the one-liner for a symbol
        #[arg(long)]
        short: bool,

        /// Search project docs
        #[arg(long)]
        search: Option<String>,

        /// Compact LLM-friendly project documentation
        #[arg(long)]
        llm: bool,

        /// Validate documentation coverage for the project
        #[arg(long)]
        validate: bool,

        /// Generate a static documentation website
        #[arg(long)]
        site: bool,

        /// Output directory for --site (default: docs/project-site)
        #[arg(long, default_value = "docs/project-site")]
        site_dir: String,
    },

    /// Run feature example tests
    Test {
        /// Feature name or path to test (e.g., "pipe_operator" or "features/pipe_operator/examples/")
        target: Option<String>,

        /// Output format: human, json, stream
        #[arg(long, default_value = "human")]
        format: String,

        /// Only run tests matching this string
        #[arg(long)]
        filter: Option<String>,

        /// Stop on first failure
        #[arg(long)]
        fail_fast: bool,

        /// Disable colored output
        #[arg(long)]
        no_color: bool,

        /// Show passing test expressions too
        #[arg(long)]
        verbose: bool,

        /// Only show failures and summary
        #[arg(long)]
        quiet: bool,

        /// Number of parallel test jobs (default: sequential)
        #[arg(short, long, default_value = "0")]
        jobs: usize,
    },
}

#[derive(Subcommand)]
enum ErrorCommands {
    /// Compare two JSON diagnostic dumps (before/after)
    Diff {
        /// Path to the "before" JSON diagnostics file
        before: PathBuf,
        /// Path to the "after" JSON diagnostics file
        after: PathBuf,
    },
}

#[derive(Subcommand)]
enum PackageCommands {
    /// Scaffold a new package
    New {
        /// Package name (e.g., "my-awesome-package")
        name: String,

        /// Include component template example
        #[arg(long)]
        component: bool,
    },
}

// ══════════════════════════════════════════════════════════════════════
//  ERROR RENDERING CONTRACT
//
//  Every error path in this file MUST go through CompileError::render().
//  DO NOT use eprintln!("error: ...") — it bypasses ANSI formatting,
//  error codes, and actionable help text. If you need a new error kind,
//  add a variant to CompileError in core/errors/compile_error.rs.
// ══════════════════════════════════════════════════════════════════════

/// Render a CompileError to stderr and exit.
fn fail(e: CompileError) -> ! {
    eprint!("{}", e.render());
    process::exit(1);
}

/// Resolve the target: returns (is_project, resolved_path)
fn resolve_target(file: Option<PathBuf>) -> (bool, PathBuf) {
    match file {
        Some(path) => {
            if path.is_dir() {
                (true, path)
            } else if path.extension().and_then(|e| e.to_str()) == Some("fg") {
                (false, path)
            } else {
                // Check if it's a directory path with forge.toml
                if path.join("forge.toml").exists() {
                    (true, path)
                } else {
                    (false, path)
                }
            }
        }
        None => {
            // No file given - check cwd for forge.toml
            let cwd = std::env::current_dir().unwrap_or_else(|_| PathBuf::from("."));
            if cwd.join("forge.toml").exists() {
                (true, cwd)
            } else {
                fail(CompileError::CliError {
                    message: "no source file or project directory specified".to_string(),
                    help: Some("usage: compiler build <file.fg> or compiler run <file.fg>".to_string()),
                });
            }
        }
    }
}

fn main() {
    // Replace the default panic hook to render ICEs through ariadne.
    // Use AtomicBool to only handle the first panic (drops can trigger secondary panics).
    let already_panicked = std::sync::Arc::new(std::sync::atomic::AtomicBool::new(false));
    let already_panicked_hook = already_panicked.clone();
    std::panic::set_hook(Box::new(move |info| {
        if already_panicked_hook.swap(true, std::sync::atomic::Ordering::SeqCst) {
            return; // Ignore secondary panics from drop during unwind
        }
        let raw = if let Some(s) = info.payload().downcast_ref::<&str>() {
            s.to_string()
        } else if let Some(s) = info.payload().downcast_ref::<String>() {
            s.clone()
        } else {
            "unknown cause".to_string()
        };

        // Truncate long internal messages (e.g. debug-printed LLVM values)
        let detail = if raw.len() > 200 {
            format!("{}...", &raw[..197])
        } else {
            raw
        };

        forge::errors::print_ice(&detail);

        // Always capture and display the backtrace, filtered to forge frames
        let bt = std::backtrace::Backtrace::force_capture();
        let bt_str = bt.to_string();
        let frames: Vec<&str> = bt_str
            .lines()
            .filter(|l| l.contains("forge::") || l.contains("forge/compiler"))
            .collect();
        if !frames.is_empty() {
            eprintln!("\n  \x1b[38;5;246mBacktrace (forge frames):\x1b[0m");
            for frame in &frames {
                eprintln!("    \x1b[38;5;246m{}\x1b[0m", frame.trim());
            }
            eprintln!();
        }
    }));

    let result = std::panic::catch_unwind(|| {
        run();
    });

    if result.is_err() {
        process::exit(2);
    }
}

fn cmd_build(
    file: Option<PathBuf>,
    dev: bool,
    emit_ir: bool,
    emit_ast: bool,
    error_format: String,
    output: Option<PathBuf>,
    max_errors: usize,
    profile: bool,
    profile_format: String,
) {
    let mut driver = Driver::new();
    driver.emit_ir = emit_ir;
    driver.emit_ast = emit_ast;
    driver.optimization = if dev { OptLevel::Dev } else { OptLevel::Release };
    driver.error_format = if error_format == "json" {
        ErrorFormat::Json
    } else {
        ErrorFormat::Human
    };
    driver.output = output;
    driver.max_errors = max_errors;
    driver.profile = profile;
    driver.profile_format = profile_format;

    let (is_project, path) = resolve_target(file);

    let result = if is_project {
        driver.compile_project(&path)
    } else {
        driver.compile(&path)
    };

    match result {
        Ok(path) => {
            if !emit_ir && !emit_ast {
                eprintln!("compiled to {}", path.display());
            }
        }
        Err(e) => fail(e),
    }
}

fn cmd_run(file: Option<PathBuf>, dev: bool, no_jit: bool, profile: bool, args: Vec<String>) {
    let mut driver = Driver::new();
    driver.optimization = if dev { OptLevel::Dev } else { OptLevel::Release };
    driver.profile = profile;

    let (is_project, path) = resolve_target(file);

    // JIT path: single files without --no-jit
    if !is_project && !no_jit && args.is_empty() {
        match driver.run_jit(&path) {
            Ok(exit_code) => process::exit(exit_code),
            Err(e) => fail(e),
        }
    }

    // AOT fallback: projects, --no-jit, or programs that need args
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
                .args(&args)
                .status()
                .unwrap_or_else(|e| {
                    fail(CompileError::BinaryRunFailed {
                        path: binary.display().to_string(),
                        detail: e.to_string(),
                    });
                });

            std::fs::remove_file(&binary).ok();
            process::exit(status.code().unwrap_or(1));
        }
        Err(e) => fail(e),
    }
}

fn cmd_check(file: PathBuf, error_format: String, max_errors: usize, autofix: bool) {
    let mut driver = Driver::new();
    driver.error_format = if error_format == "json" {
        ErrorFormat::Json
    } else {
        ErrorFormat::Human
    };
    driver.max_errors = max_errors;
    driver.autofix = autofix;
    if let Err(e) = driver.check(&file) {
        fail(e);
    }
}

fn cmd_explain(code: String) {
    let registry = forge::errors::ErrorRegistry::builtin();
    match registry.lookup(&code) {
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
        }
        None => {
            fail(CompileError::CliError {
                message: format!("unknown error code '{}'", code),
                help: Some("run `compiler explain F0001` to see valid codes, or `compiler errors list` to see all".to_string()),
            });
        }
    }
}

fn cmd_why(file_line: String) {
    // Parse file:line
    let parts: Vec<&str> = file_line.rsplitn(2, ':').collect();
    if parts.len() != 2 {
        fail(CompileError::CliError {
            message: format!("invalid format '{}' — expected file.fg:LINE", file_line),
            help: Some("example: compiler why main.fg:5".to_string()),
        });
    }
    let line: u32 = match parts[0].parse() {
        Ok(n) => n,
        Err(_) => {
            fail(CompileError::CliError {
                message: format!("invalid line number '{}'", parts[0]),
                help: Some("line number must be a positive integer, e.g., compiler why main.fg:5".to_string()),
            });
        }
    };
    let file = PathBuf::from(parts[1]);
    let driver = Driver::new();
    if let Err(e) = driver.explain_line(&file, line) {
        fail(e);
    }
}

fn cmd_features(feature: Option<String>, graph: bool) {
    if let Some(id) = feature {
        forge::registry::FeatureRegistry::print_detail(&id);
    } else if graph {
        forge::registry::FeatureRegistry::print_graph();
    } else {
        forge::registry::FeatureRegistry::print_table();
    }
}

fn cmd_lang(
    query: Option<String>,
    all: bool,
    symbols: bool,
    llm: bool,
    short: bool,
    grammar: bool,
    cheatsheet: bool,
    search: Option<String>,
    validate: bool,
    site: bool,
    site_dir: String,
) {
    if site {
        forge::site::generate_lang_site(&site_dir);
        println!("Site generated at {}/", site_dir);
    } else if validate {
        forge::lang::validate_lang();
    } else if let Some(term) = search {
        forge::lang::show_search(&term);
    } else if grammar {
        forge::lang::show_grammar();
    } else if cheatsheet {
        forge::lang::show_cheatsheet();
    } else if llm {
        if query.as_deref() == Some("full") {
            forge::lang::show_llm_full();
        } else {
            forge::lang::show_llm_compact();
        }
    } else if symbols {
        forge::lang::show_symbols();
    } else if all {
        forge::lang::show_all();
    } else if let Some(q) = query {
        if short {
            forge::lang::show_short(&q);
        } else {
            forge::lang::resolve(&q);
        }
    } else {
        forge::lang::show_all();
    }
}

fn cmd_docs(
    query: Option<String>,
    symbols: bool,
    short: bool,
    search: Option<String>,
    llm: bool,
    validate: bool,
    site: bool,
    site_dir: String,
) {
    if site {
        forge::site::generate_docs_site(".", &site_dir);
        println!("Site generated at {}/", site_dir);
    } else if validate {
        forge::docs::validate_docs(".");
    } else {
        let cwd = std::env::current_dir().unwrap_or_else(|_| PathBuf::from("."));
        let docs = forge::docs::extract_project_docs(&cwd);

        if let Some(term) = search {
            forge::docs::show_search(&term, &docs);
        } else if llm {
            forge::docs::show_llm(&docs);
        } else if symbols {
            forge::docs::show_symbols(&docs);
        } else if let Some(q) = query {
            if short {
                if !forge::docs::show_short(&q, &docs) {
                    eprintln!(
                        "\n  No symbol '{}' found in project.\n  Hint: try `compiler docs` for an overview.\n",
                        q
                    );
                    process::exit(1);
                }
            } else if !forge::docs::show_symbol(&q, &docs) {
                eprintln!(
                    "\n  No symbol '{}' found in project.\n  Hint: try `compiler docs` for an overview.\n",
                    q
                );
                process::exit(1);
            }
        } else {
            forge::docs::show_overview(&docs);
        }
    }
}

fn cmd_test(
    target: Option<String>,
    format: String,
    filter: Option<String>,
    fail_fast: bool,
    no_color: bool,
    verbose: bool,
    quiet: bool,
    jobs: usize,
) {
    let fmt = match format.as_str() {
        "json" => forge::test_runner::OutputFormat::Json,
        "stream" => forge::test_runner::OutputFormat::Stream,
        _ => forge::test_runner::OutputFormat::Human,
    };
    let config = forge::test_runner::TestRunConfig {
        format: fmt,
        filter,
        fail_fast,
        no_color,
        verbose,
        quiet,
        jobs,
    };
    let passed = forge::test_runner::run_tests(target.as_deref(), &config);
    if !passed {
        process::exit(1);
    }
}

fn cmd_package_new(name: String, component: bool) {
    if let Err(e) = scaffold_package(&name, component) {
        fail(CompileError::CliError {
            message: e.clone(),
            help: Some("check write permissions and that the directory doesn't already exist".to_string()),
        });
    }
}

fn cmd_errors_diff(before: PathBuf, after: PathBuf) {
    let before_json = match std::fs::read_to_string(&before) {
        Ok(s) => s,
        Err(e) => fail(CompileError::FileNotFound {
            path: before.display().to_string(),
            detail: e.to_string(),
        }),
    };
    let after_json = match std::fs::read_to_string(&after) {
        Ok(s) => s,
        Err(e) => fail(CompileError::FileNotFound {
            path: after.display().to_string(),
            detail: e.to_string(),
        }),
    };
    match forge::errors::diff::diff_json(&before_json, &after_json) {
        Ok(result) => {
            println!("{}", result.render());
        }
        Err(e) => {
            fail(CompileError::CliError {
                message: format!("failed to diff diagnostics: {}", e),
                help: Some("ensure both files contain valid JSON diagnostic output from `compiler check --error-format json`".to_string()),
            });
        }
    }
}

fn run() {
    let cli = Cli::parse();

    match cli.command {
        Commands::Build { file, dev, emit_ir, emit_ast, error_format, output, max_errors, profile, profile_format, .. } => {
            cmd_build(file, dev, emit_ir, emit_ast, error_format, output, max_errors, profile, profile_format)
        }

        Commands::Run { file, dev, no_jit, profile, args } => cmd_run(file, dev, no_jit, profile, args),

        Commands::Check { file, error_format, max_errors, autofix } => cmd_check(file, error_format, max_errors, autofix),

        Commands::Explain { code } => cmd_explain(code),

        Commands::Why { file_line } => cmd_why(file_line),

        Commands::Version => {
            println!("compiler 0.1.0");
        }

        Commands::Package { command } => match command {
            PackageCommands::New { name, component } => cmd_package_new(name, component),
        },

        Commands::Features { feature, graph } => cmd_features(feature, graph),

        Commands::Lang { query, all, symbols, llm, short, grammar, cheatsheet, search, validate, site, site_dir } => {
            cmd_lang(query, all, symbols, llm, short, grammar, cheatsheet, search, validate, site, site_dir)
        }

        Commands::Docs { query, symbols, short, search, llm, validate, site, site_dir } => {
            cmd_docs(query, symbols, short, search, llm, validate, site, site_dir)
        }

        Commands::Test { target, format, filter, fail_fast, no_color, verbose, quiet, jobs } => {
            cmd_test(target, format, filter, fail_fast, no_color, verbose, quiet, jobs)
        }

        Commands::Errors { command } => match command {
            ErrorCommands::Diff { before, after } => cmd_errors_diff(before, after),
        },
    }
}

fn scaffold_package(name: &str, with_component: bool) -> Result<(), String> {
    let lib_name = format!("forge_{}", name.replace('-', "_"));
    let dir = PathBuf::from(name);

    if dir.exists() {
        return Err(format!("directory '{}' already exists", name));
    }

    std::fs::create_dir_all(dir.join("src"))
        .map_err(|e| format!("failed to create directory: {}", e))?;
    std::fs::create_dir_all(dir.join("native/src"))
        .map_err(|e| format!("failed to create directory: {}", e))?;

    // package.toml
    let mut toml = format!(
        r#"[package]
name = "{name}"
namespace = "community"
version = "0.1.0"
description = "TODO: describe your package"

[native]
library = "{lib_name}"
"#
    );

    if with_component {
        let comp_name = name.replace('-', "_");
        toml.push_str(&format!(
            r#"
[components.{comp_name}]
kind = "block"
context = "top_level"
"#
        ));
    }

    std::fs::write(dir.join("package.toml"), toml)
        .map_err(|e| format!("failed to write package.toml: {}", e))?;

    // src/package.fg
    let package_fg = if with_component {
        let comp_name = name.replace('-', "_");
        format!(
            r#"extern fn {lib_name}_init(name: string) -> int
extern fn {lib_name}_exec(name: string, data: string) -> ptr
extern fn strlen(s: ptr) -> int

component {comp_name}($name, schema) {{
    on startup {{
        {lib_name}_init($name_str)
    }}

    fn $name.exec(data: string) -> string {{
        let _ptr: ptr = {lib_name}_exec($name_str, data)
        let _len: int = strlen(_ptr)
        forge_string_new(_ptr, _len)
    }}
}}
"#
        )
    } else {
        format!(
            r#"extern fn {lib_name}_hello(name: string) -> ptr
extern fn strlen(s: ptr) -> int
"#
        )
    };

    std::fs::write(dir.join("src/package.fg"), package_fg)
        .map_err(|e| format!("failed to write package.fg: {}", e))?;

    // native/Cargo.toml
    let cargo_toml = format!(
        r#"[package]
name = "{lib_name}"
version = "0.1.0"
edition = "2021"

[lib]
name = "{lib_name}"
crate-type = ["staticlib"]
"#
    );

    std::fs::write(dir.join("native/Cargo.toml"), cargo_toml)
        .map_err(|e| format!("failed to write Cargo.toml: {}", e))?;

    // native/src/lib.rs
    let lib_rs = if with_component {
        format!(
            r#"use std::collections::HashMap;
use std::ffi::{{CStr, CString}};
use std::os::raw::c_char;
use std::sync::{{LazyLock, Mutex}};

static INSTANCES: LazyLock<Mutex<HashMap<String, i64>>> =
    LazyLock::new(|| Mutex::new(HashMap::new()));

#[no_mangle]
pub extern "C" fn {lib_name}_init(name: *const c_char) -> i64 {{
    let name = unsafe {{ CStr::from_ptr(name) }}.to_str().unwrap().to_string();
    let mut instances = INSTANCES.lock().unwrap();
    let id = instances.len() as i64 + 1;
    instances.insert(name, id);
    id
}}

#[no_mangle]
pub extern "C" fn {lib_name}_exec(name: *const c_char, data: *const c_char) -> *const c_char {{
    let name = unsafe {{ CStr::from_ptr(name) }}.to_str().unwrap();
    let data = unsafe {{ CStr::from_ptr(data) }}.to_str().unwrap();
    let result = format!("{{}}: {{}}", name, data);
    CString::new(result).unwrap().into_raw()
}}
"#
        )
    } else {
        format!(
            r#"use std::ffi::{{CStr, CString}};
use std::os::raw::c_char;

#[no_mangle]
pub extern "C" fn {lib_name}_hello(name: *const c_char) -> *const c_char {{
    let name = unsafe {{ CStr::from_ptr(name) }}.to_str().unwrap();
    let greeting = format!("hello from {name}, {{}}!", name);
    CString::new(greeting).unwrap().into_raw()
}}
"#
        )
    };

    std::fs::write(dir.join("native/src/lib.rs"), lib_rs)
        .map_err(|e| format!("failed to write lib.rs: {}", e))?;

    // example.fg
    let example = if with_component {
        let kw_name = name.replace('-', "_");
        format!(
            r#"use @community.{kw_name}.{{{kw_name}}}

{kw_name} demo {{}}

fn main() {{
    let result = demo.exec("test data")
    println(result)
}}
"#
        )
    } else {
        format!(
            r#"// TODO: Add use statement once package is installed
// use @community.{}.{{}}

fn main() {{
    println("{} works!")
}}
"#,
            name.replace('-', "_"),
            name
        )
    };

    std::fs::write(dir.join("example.fg"), example)
        .map_err(|e| format!("failed to write example.fg: {}", e))?;

    // README.md
    let readme = format!(
        "# {name}\n\nForge package.\n\n## Build\n\n```bash\ncd native && cargo build --release\n```\n"
    );
    std::fs::write(dir.join("README.md"), readme)
        .map_err(|e| format!("failed to write README.md: {}", e))?;

    println!("Created package '{}'", name);
    println!();
    println!("  {}/", name);
    println!("  ├── package.toml");
    println!("  ├── src/");
    println!("  │   └── package.fg");
    println!("  ├── native/");
    println!("  │   ├── Cargo.toml");
    println!("  │   └── src/");
    println!("  │       └── lib.rs");
    println!("  ├── example.fg");
    println!("  └── README.md");
    println!();
    println!("Next steps:");
    println!("  cd {}/native && cargo build --release", name);

    Ok(())
}
