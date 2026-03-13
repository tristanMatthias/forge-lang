use clap::{Parser, Subcommand};
use std::path::PathBuf;
use std::process;

use forge::driver::{Driver, ErrorFormat, OptLevel};
use forge::errors::CompileError;

#[derive(Parser)]
#[command(name = "forge", version = "0.1.0", about = "The Forge programming language compiler")]
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

    /// Explain an error code (e.g., `forge explain F0020`)
    Explain {
        /// Error code to explain (e.g., F0020)
        code: String,
    },

    /// Print version info
    Version,

    /// Provider management commands
    Provider {
        #[command(subcommand)]
        command: ProviderCommands,
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
enum ProviderCommands {
    /// Scaffold a new provider
    New {
        /// Provider name (e.g., "my-awesome-provider")
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
                    help: Some("usage: forge build <file.fg> or forge run <file.fg>".to_string()),
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
    }));

    let result = std::panic::catch_unwind(|| {
        run();
    });

    if result.is_err() {
        process::exit(2);
    }
}

fn run() {
    let cli = Cli::parse();

    match cli.command {
        Commands::Build {
            file,
            dev,
            emit_ir,
            emit_ast,
            error_format,
            output,
            max_errors,
            profile,
            profile_format,
            ..
        } => {
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

        Commands::Run { file, dev, args } => {
            let mut driver = Driver::new();
            driver.optimization = if dev { OptLevel::Dev } else { OptLevel::Release };

            // Compile to temp path (unique per process for parallel test runs)
            let output = std::env::temp_dir().join(format!("forge_run_{}", std::process::id()));
            driver.output = Some(output.clone());

            let (is_project, path) = resolve_target(file);

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

                    // Cleanup
                    std::fs::remove_file(&binary).ok();

                    process::exit(status.code().unwrap_or(1));
                }
                Err(e) => fail(e),
            }
        }

        Commands::Check { file, error_format, max_errors, autofix } => {
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

        Commands::Explain { code } => {
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
                        help: Some("run `forge explain F0001` to see valid codes, or `forge errors list` to see all".to_string()),
                    });
                }
            }
        }

        Commands::Why { file_line } => {
            // Parse file:line
            let parts: Vec<&str> = file_line.rsplitn(2, ':').collect();
            if parts.len() != 2 {
                fail(CompileError::CliError {
                    message: format!("invalid format '{}' — expected file.fg:LINE", file_line),
                    help: Some("example: forge why main.fg:5".to_string()),
                });
            }
            let line: u32 = match parts[0].parse() {
                Ok(n) => n,
                Err(_) => {
                    fail(CompileError::CliError {
                        message: format!("invalid line number '{}'", parts[0]),
                        help: Some("line number must be a positive integer, e.g., forge why main.fg:5".to_string()),
                    });
                }
            };
            let file = PathBuf::from(parts[1]);
            let driver = Driver::new();
            if let Err(e) = driver.explain_line(&file, line) {
                fail(e);
            }
        }

        Commands::Version => {
            println!("forge 0.1.0");
        }

        Commands::Provider { command } => match command {
            ProviderCommands::New { name, component } => {
                if let Err(e) = scaffold_provider(&name, component) {
                    fail(CompileError::CliError {
                        message: e.clone(),
                        help: Some("check write permissions and that the directory doesn't already exist".to_string()),
                    });
                }
            }
        },

        Commands::Features { feature, graph } => {
            if let Some(id) = feature {
                forge::registry::FeatureRegistry::print_detail(&id);
            } else if graph {
                forge::registry::FeatureRegistry::print_graph();
            } else {
                forge::registry::FeatureRegistry::print_table();
            }
        }

        Commands::Test { target, format, filter, fail_fast, no_color, verbose, quiet } => {
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
            };
            let passed = forge::test_runner::run_tests(target.as_deref(), &config);
            if !passed {
                process::exit(1);
            }
        }

        Commands::Errors { command } => match command {
            ErrorCommands::Diff { before, after } => {
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
                            help: Some("ensure both files contain valid JSON diagnostic output from `forge check --error-format json`".to_string()),
                        });
                    }
                }
            }
        },
    }
}

fn scaffold_provider(name: &str, with_component: bool) -> Result<(), String> {
    let lib_name = format!("forge_{}", name.replace('-', "_"));
    let dir = PathBuf::from(name);

    if dir.exists() {
        return Err(format!("directory '{}' already exists", name));
    }

    std::fs::create_dir_all(dir.join("src"))
        .map_err(|e| format!("failed to create directory: {}", e))?;
    std::fs::create_dir_all(dir.join("native/src"))
        .map_err(|e| format!("failed to create directory: {}", e))?;

    // provider.toml
    let mut toml = format!(
        r#"[provider]
name = "{name}"
namespace = "community"
version = "0.1.0"
description = "TODO: describe your provider"

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

    std::fs::write(dir.join("provider.toml"), toml)
        .map_err(|e| format!("failed to write provider.toml: {}", e))?;

    // src/provider.fg
    let provider_fg = if with_component {
        let comp_name = name.replace('-', "_");
        format!(
            r#"extern fn {lib_name}_init(name: string) -> int
extern fn {lib_name}_exec(name: string, data: string) -> ptr
extern fn strlen(s: ptr) -> int

component {comp_name}(__tpl_name, schema) {{
    on startup {{
        {lib_name}_init(__tpl_name_str)
    }}

    fn __tpl_name.exec(data: string) -> string {{
        let __ptr: ptr = {lib_name}_exec(__tpl_name_str, data)
        let __len: int = strlen(__ptr)
        forge_string_new(__ptr, __len)
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

    std::fs::write(dir.join("src/provider.fg"), provider_fg)
        .map_err(|e| format!("failed to write provider.fg: {}", e))?;

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
            r#"// TODO: Add use statement once provider is installed
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
        "# {name}\n\nForge provider.\n\n## Build\n\n```bash\ncd native && cargo build --release\n```\n"
    );
    std::fs::write(dir.join("README.md"), readme)
        .map_err(|e| format!("failed to write README.md: {}", e))?;

    println!("Created provider '{}'", name);
    println!();
    println!("  {}/", name);
    println!("  ├── provider.toml");
    println!("  ├── src/");
    println!("  │   └── provider.fg");
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
