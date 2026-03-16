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

        /// Machine-readable language spec for LLMs and code generators
        #[arg(long)]
        llm: bool,

        /// Include code examples (use with --llm for full spec with examples)
        #[arg(long)]
        examples: bool,

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

    /// Generate machine-readable API surface (context.fg)
    Context {
        /// Input file or project directory
        file: Option<PathBuf>,
        /// Output file (default: stdout)
        #[arg(short, long)]
        output: Option<PathBuf>,
    },

    /// Check API compatibility between two context files
    SemverCheck {
        /// Old version context file
        old: PathBuf,
        /// New version context file
        new: PathBuf,
        /// Old version string (for bump validation, e.g., "1.0.0")
        #[arg(long)]
        old_version: Option<String>,
        /// Proposed new version (validates against minimum bump)
        #[arg(long)]
        version: Option<String>,
    },

    /// Show dependency tree for the current project
    Deps {
        #[command(subcommand)]
        action: Option<DepsAction>,

        /// Show flat list instead of tree
        #[arg(long)]
        flat: bool,
    },

    /// Show package metadata
    Info {
        /// Package name to look up
        package: String,

        /// Also show exported API surface (reads context.fg if present)
        #[arg(long)]
        context: bool,
    },

    /// Authenticate with the package registry
    Auth {
        #[command(subcommand)]
        action: AuthAction,
    },

    /// Add a dependency to the project
    Add {
        /// Package specifiers (e.g., "graphql", "http@^1.0", "@std/json")
        packages: Vec<String>,

        /// Dev dependency
        #[arg(long)]
        dev: bool,
    },

    /// Remove a dependency from the project
    Remove {
        /// Package names to remove
        packages: Vec<String>,
    },

    /// Update dependencies
    Update {
        /// Specific packages to update (all if omitted)
        packages: Vec<String>,
    },

    /// Publish the package to the registry
    Publish {
        /// Perform a dry run without actually publishing
        #[arg(long)]
        dry_run: bool,

        /// Registry URL
        #[arg(long)]
        registry: Option<String>,

        /// Auth token (overrides stored credentials)
        #[arg(long)]
        token: Option<String>,
    },

    /// Audit dependencies for security and integrity
    Audit {
        /// Fix issues automatically where possible
        #[arg(long)]
        fix: bool,
    },

    /// Yank a published version (marks as not recommended)
    Yank {
        /// Package specifier: name@version (e.g., graphql@3.1.0)
        package_version: String,
        /// Reason for yanking
        #[arg(long)]
        reason: Option<String>,
        /// Registry URL
        #[arg(long)]
        registry: Option<String>,
    },

    /// Manage the local package cache
    Cache {
        #[command(subcommand)]
        action: CacheAction,
    },

    /// Allow a capability for a package
    Allow {
        /// Package name
        package: String,

        /// Capability to allow (network, filesystem, native, ffi, compile_time_codegen)
        capability: String,
    },

    /// Show quality report for a package
    Quality {
        /// Path to project directory (default: current directory)
        path: Option<PathBuf>,
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
enum AuthAction {
    /// Log in to the registry
    Login {
        /// Use an existing token instead of browser login
        #[arg(long)]
        token: Option<String>,
    },
    /// Log out from the registry
    Logout,
    /// Show current authenticated user
    Whoami,
    /// Manage auth tokens
    Token {
        #[command(subcommand)]
        action: TokenAction,
    },
}

#[derive(Subcommand)]
enum TokenAction {
    /// Create a new scoped publish token
    Create {
        /// Token scope (package name or org)
        #[arg(long)]
        scope: Option<String>,
    },
    /// List active tokens
    List,
    /// Revoke a token by ID
    Revoke {
        /// Token ID to revoke
        id: String,
    },
}

#[derive(Subcommand)]
enum DepsAction {
    /// Show why a package is in your project (dependency chain)
    Explain {
        /// Package name to explain
        package: String,
    },
    /// Show all capabilities across the dependency tree
    Capabilities,
    /// Show the dependency tree (same as default)
    Tree,
    /// Show outdated dependencies
    Outdated,
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

#[derive(Subcommand)]
enum CacheAction {
    /// Show cache size breakdown by tier
    Status,
    /// Evict source archives and context files (keep compilation artifacts)
    Gc {
        /// Evict everything not used by current project (including git repos)
        #[arg(long)]
        aggressive: bool,
    },
    /// Wipe the entire cache (requires confirmation)
    Clear,
    /// Download all deps for current project (offline work)
    Prefetch,
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
    // If the argument contains ':' and the part after ':' looks like a line number,
    // treat as file:line for type inference. Otherwise treat as a package name.
    let parts: Vec<&str> = file_line.rsplitn(2, ':').collect();
    let looks_like_file_line = parts.len() == 2 && parts[0].parse::<u32>().is_ok();

    if !looks_like_file_line && !file_line.contains('/') && !file_line.ends_with(".fg") {
        // Treat as package name — delegate to deps explain
        cmd_deps_explain(file_line);
        return;
    }

    if parts.len() != 2 {
        fail(CompileError::CliError {
            message: format!("invalid format '{}' — expected file.fg:LINE or a package name", file_line),
            help: Some("examples: compiler why main.fg:5  OR  compiler why graphql".to_string()),
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
    examples: bool,
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
        // --llm --examples  OR  --llm full  (backwards compat)
        if examples || query.as_deref() == Some("full") {
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

fn cmd_semver_check(old: PathBuf, new: PathBuf, old_version: Option<String>, version: Option<String>) {
    let old_content = match std::fs::read_to_string(&old) {
        Ok(s) => s,
        Err(e) => fail(CompileError::FileNotFound {
            path: old.display().to_string(),
            detail: e.to_string(),
        }),
    };
    let new_content = match std::fs::read_to_string(&new) {
        Ok(s) => s,
        Err(e) => fail(CompileError::FileNotFound {
            path: new.display().to_string(),
            detail: e.to_string(),
        }),
    };

    let old_items = forge::semver::parse_context(&old_content);
    let new_items = forge::semver::parse_context(&new_content);
    let changes = forge::semver::diff_api(&old_items, &new_items);
    let bump = forge::semver::compute_minimum_bump(&changes);
    let report = forge::semver::format_diff_report(&changes, &bump);

    print!("{}", report);

    // If --version is provided, validate the proposed bump
    if let Some(proposed) = version {
        let old_ver = old_version.unwrap_or_else(|| {
            fail(CompileError::CliError {
                message: "--version requires --old-version to validate the bump".to_string(),
                help: Some("usage: forgec semver-check old.fg new.fg --old-version 1.0.0 --version 1.1.0".to_string()),
            });
        });

        match forge::semver::validate_version_bump(&old_ver, &proposed, bump) {
            Ok(()) => {
                eprintln!("version {} -> {} satisfies minimum {} bump", old_ver, proposed, bump);
            }
            Err(reason) => {
                fail(CompileError::VersionBelowMinimum {
                    attempted: proposed,
                    minimum: match bump {
                        forge::semver::BumpLevel::Major => "major".to_string(),
                        forge::semver::BumpLevel::Minor => "minor".to_string(),
                        forge::semver::BumpLevel::Patch => "patch".to_string(),
                    },
                    reason,
                });
            }
        }
    }
}

fn cmd_context(file: Option<PathBuf>, output: Option<PathBuf>) {
    let (is_project, path) = resolve_target(file);

    // For projects, find the main source file
    let source_path = if is_project {
        let main_fg = path.join("main.fg");
        if main_fg.exists() {
            main_fg
        } else {
            // Look for src/main.fg
            let src_main = path.join("src").join("main.fg");
            if src_main.exists() {
                src_main
            } else {
                fail(CompileError::CliError {
                    message: "could not find main.fg in project directory".to_string(),
                    help: Some("create a main.fg or src/main.fg file".to_string()),
                });
            }
        }
    } else {
        path.clone()
    };

    let driver = Driver::new();
    let program = match driver.parse_and_check(&source_path) {
        Ok(p) => p,
        Err(e) => fail(e),
    };

    // Derive a package name from the file or directory
    let package_name = if is_project {
        path.file_name()
            .and_then(|n| n.to_str())
            .map(|s| s.to_string())
    } else {
        source_path
            .file_stem()
            .and_then(|n| n.to_str())
            .map(|s| s.to_string())
    };

    let context_str = forge::context::generate_context(&program, package_name.as_deref());

    match output {
        Some(out_path) => {
            if let Err(e) = std::fs::write(&out_path, &context_str) {
                fail(CompileError::CliError {
                    message: format!("failed to write context file: {}", e),
                    help: Some(format!("check write permissions for {}", out_path.display())),
                });
            }
            eprintln!("context written to {}", out_path.display());
        }
        None => {
            print!("{}", context_str);
        }
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
            println!("forgec 0.1.0");
        }

        Commands::Package { command } => match command {
            PackageCommands::New { name, component } => cmd_package_new(name, component),
        },

        Commands::SemverCheck { old, new, old_version, version } => cmd_semver_check(old, new, old_version, version),

        Commands::Context { file, output } => cmd_context(file, output),

        Commands::Features { feature, graph } => cmd_features(feature, graph),

        Commands::Lang { query, all, symbols, llm, examples, short, grammar, cheatsheet, search, validate, site, site_dir } => {
            cmd_lang(query, all, symbols, llm, examples, short, grammar, cheatsheet, search, validate, site, site_dir)
        }

        Commands::Docs { query, symbols, short, search, llm, validate, site, site_dir } => {
            cmd_docs(query, symbols, short, search, llm, validate, site, site_dir)
        }

        Commands::Test { target, format, filter, fail_fast, no_color, verbose, quiet, jobs } => {
            cmd_test(target, format, filter, fail_fast, no_color, verbose, quiet, jobs)
        }

        Commands::Deps { action, flat } => match action {
            None | Some(DepsAction::Tree) => cmd_deps(flat),
            Some(DepsAction::Explain { package }) => cmd_deps_explain(package),
            Some(DepsAction::Capabilities) => cmd_deps_capabilities(),
            Some(DepsAction::Outdated) => cmd_deps_outdated(),
        },

        Commands::Info { package, context } => cmd_info(package, context),

        Commands::Add { packages, dev } => cmd_add(packages, dev),
        Commands::Remove { packages } => cmd_remove(packages),
        Commands::Update { packages } => cmd_update(packages),
        Commands::Publish { dry_run, registry, token } => cmd_publish(dry_run, registry, token),
        Commands::Audit { fix } => cmd_audit(fix),
        Commands::Yank { package_version, reason, registry } => cmd_yank(package_version, reason, registry),
        Commands::Allow { package, capability } => cmd_allow(package, capability),
        Commands::Quality { path } => cmd_quality(path),

        Commands::Cache { action } => match action {
            CacheAction::Status => cmd_cache_status(),
            CacheAction::Gc { aggressive } => cmd_cache_gc(aggressive),
            CacheAction::Clear => cmd_cache_clear(),
            CacheAction::Prefetch => cmd_cache_prefetch(),
        },

        Commands::Auth { action } => match action {
            AuthAction::Login { token } => cmd_auth_login(token),
            AuthAction::Logout => cmd_auth_logout(),
            AuthAction::Whoami => cmd_auth_whoami(),
            AuthAction::Token { action: ta } => match ta {
                TokenAction::Create { scope } => cmd_auth_token_create(scope),
                TokenAction::List => cmd_auth_token_list(),
                TokenAction::Revoke { id } => cmd_auth_token_revoke(id),
            },
        },

        Commands::Errors { command } => match command {
            ErrorCommands::Diff { before, after } => cmd_errors_diff(before, after),
        },
    }
}

fn cmd_deps(flat: bool) {
    use forge::resolver;
    use forge::features::modules::project::ForgeProject;

    let cwd = std::env::current_dir().unwrap_or_else(|_| PathBuf::from("."));

    let project = match ForgeProject::load(&cwd) {
        Ok(p) => p,
        Err(e) => {
            fail(CompileError::CliError {
                message: format!("cannot load project: {}", e),
                help: Some("run this command from a directory containing forge.toml".to_string()),
            });
        }
    };

    let toml_path = cwd.join("forge.toml");
    let toml_content = match std::fs::read_to_string(&toml_path) {
        Ok(c) => c,
        Err(e) => {
            fail(CompileError::FileNotFound {
                path: toml_path.display().to_string(),
                detail: e.to_string(),
            });
        }
    };
    let toml_val: toml::Value = match toml::from_str(&toml_content) {
        Ok(v) => v,
        Err(e) => {
            fail(CompileError::CliError {
                message: format!("invalid forge.toml: {}", e),
                help: None,
            });
        }
    };

    let direct_deps: std::collections::HashMap<String, String> = toml_val
        .get("dependencies")
        .and_then(|d| d.as_table())
        .map(|t| {
            t.iter()
                .filter_map(|(k, v)| v.as_str().map(|s| (k.clone(), s.to_string())))
                .collect()
        })
        .unwrap_or_default();

    if direct_deps.is_empty() {
        println!("{} v{}", project.config.project.name, project.config.project.version);
        println!("  (no dependencies)");
        return;
    }

    let packages_dir = cwd.join("packages");
    let local_pkgs = resolver::scan_local_packages(&packages_dir);
    let available = |name: &str| -> Option<resolver::PackageVersions> {
        local_pkgs.get(name).cloned()
    };

    match resolver::resolve(&direct_deps, &available) {
        Ok(graph) => {
            if flat {
                print!("{}", resolver::format_dep_flat(&graph));
            } else {
                print!(
                    "{}",
                    resolver::format_dep_tree(
                        &graph,
                        &project.config.project.name,
                        &project.config.project.version,
                    )
                );
            }

            // Warn if any resolved dependency is yanked
            let mut yanked_found = false;
            for dep in graph.packages.values() {
                if forge::publish::is_yanked(&dep.name, &dep.version) {
                    if !yanked_found {
                        eprintln!();
                        eprintln!("warning: the following dependencies are yanked:");
                        yanked_found = true;
                    }
                    eprintln!("  {}@{} — yanked, consider upgrading or replacing", dep.name, dep.version);
                }
            }
        }
        Err(e) => fail(e),
    }
}

// ── Auth commands ─────────────────────────────────────────────────

fn credentials_path() -> PathBuf {
    let home = std::env::var("HOME").unwrap_or_else(|_| "/tmp".to_string());
    PathBuf::from(home).join(".forge").join("auth").join("credentials.toml")
}

fn cmd_auth_login(token: Option<String>) {
    let cred_path = credentials_path();
    if let Some(parent) = cred_path.parent() {
        std::fs::create_dir_all(parent).ok();
    }
    let tok = match token {
        Some(t) => t,
        None => {
            fail(CompileError::CliError {
                message: "interactive login not yet implemented".to_string(),
                help: Some("use --token <TOKEN> to authenticate with an API token".to_string()),
            });
        }
    };
    let content = format!("[auth]\ntoken = \"{}\"\n", tok);
    match std::fs::write(&cred_path, &content) {
        Ok(_) => eprintln!("logged in. credentials saved to {}", cred_path.display()),
        Err(e) => fail(CompileError::CliError {
            message: format!("failed to save credentials: {}", e),
            help: None,
        }),
    }
}

fn cmd_auth_logout() {
    let cred_path = credentials_path();
    if cred_path.exists() {
        std::fs::remove_file(&cred_path).ok();
        eprintln!("logged out.");
    } else {
        eprintln!("not logged in.");
    }
}

fn cmd_auth_whoami() {
    let cred_path = credentials_path();
    match std::fs::read_to_string(&cred_path) {
        Ok(content) => {
            if content.contains("token") {
                println!("authenticated (token stored at {})", cred_path.display());
            } else {
                println!("not logged in.");
            }
        }
        Err(_) => println!("not logged in."),
    }
}

fn cmd_auth_token_create(scope: Option<String>) {
    eprintln!("token creation requires registry connection (not yet implemented)");
    if let Some(s) = scope {
        eprintln!("  requested scope: {}", s);
    }
}

fn cmd_auth_token_list() {
    eprintln!("token listing requires registry connection (not yet implemented)");
}

fn cmd_auth_token_revoke(id: String) {
    eprintln!("token revocation requires registry connection (not yet implemented)");
    eprintln!("  token id: {}", id);
}

// ── Package management commands ───────────────────────────────────

fn cmd_add(packages: Vec<String>, _dev: bool) {
    let cwd = std::env::current_dir().unwrap_or_else(|_| PathBuf::from("."));
    for spec_str in &packages {
        let spec = match forge::pkg_commands::parse_package_spec(spec_str, None) {
            Ok(s) => s,
            Err(e) => fail(CompileError::CliError {
                message: format!("invalid package specifier '{}': {}", spec_str, e),
                help: Some("formats: graphql, graphql@^1.0, @std/http".to_string()),
            }),
        };
        if let Err(e) = forge::pkg_commands::add_dependency(&cwd, &spec.name, Some(spec.version.as_str())) {
            fail(CompileError::CliError {
                message: format!("failed to add {}: {}", spec.name, e),
                help: None,
            });
        }
        eprintln!("added {}@{}", spec.name, spec.version);
    }
}

fn cmd_remove(packages: Vec<String>) {
    let cwd = std::env::current_dir().unwrap_or_else(|_| PathBuf::from("."));
    for name in &packages {
        if let Err(e) = forge::pkg_commands::remove_dependency(&cwd, name) {
            fail(CompileError::CliError {
                message: format!("failed to remove {}: {}", name, e),
                help: None,
            });
        }
        eprintln!("removed {}", name);
    }
}

fn cmd_update(packages: Vec<String>) {
    let cwd = std::env::current_dir().unwrap_or_else(|_| PathBuf::from("."));
    if packages.is_empty() {
        // Update all
        eprintln!("updating all dependencies...");
    }
    for name in &packages {
        if let Err(e) = forge::pkg_commands::update_dependency(&cwd, Some(name.as_str()), None) {
            fail(CompileError::CliError {
                message: format!("failed to update {}: {}", name, e),
                help: None,
            });
        }
        eprintln!("updated {}", name);
    }
}

fn cmd_publish(dry_run: bool, registry: Option<String>, token: Option<String>) {
    let cwd = std::env::current_dir().unwrap_or_else(|_| PathBuf::from("."));
    let mut config = forge::publish::PublishConfig::default();
    config.dry_run = dry_run;
    if let Some(url) = registry {
        config.registry_url = url;
    }
    config.token = token.or_else(|| {
        // Try stored credentials
        let cred_path = credentials_path();
        std::fs::read_to_string(&cred_path).ok().and_then(|c| {
            c.lines()
                .find(|l| l.starts_with("token"))
                .and_then(|l| l.split('=').nth(1))
                .map(|s| s.trim().trim_matches('"').to_string())
        })
    });

    match forge::publish::publish(&cwd, &config) {
        Ok(result) => {
            if dry_run {
                eprintln!("dry run: would publish {}@{} (hash: {})", result.package_name, result.version, result.content_hash);
            } else {
                eprintln!("published {}@{} to {}", result.package_name, result.version, result.registry_url);
            }
        }
        Err(e) => fail(CompileError::CliError {
            message: format!("publish failed: {}", e),
            help: Some("check your credentials with `forgec auth whoami`".to_string()),
        }),
    }
}

fn cmd_audit(_fix: bool) {
    let cwd = std::env::current_dir().unwrap_or_else(|_| PathBuf::from("."));
    match forge::audit::audit_project(&cwd) {
        Ok(report) => {
            print!("{}", forge::audit::format_report(&report));
            if !report.vulnerabilities.is_empty() || !report.hash_mismatches.is_empty() {
                process::exit(1);
            }
        }
        Err(e) => fail(CompileError::CliError {
            message: format!("audit failed: {}", e),
            help: None,
        }),
    }
}

fn cmd_yank(package_version: String, reason: Option<String>, registry: Option<String>) {
    // Parse "graphql@3.1.0" into name + version
    let (name, version) = match package_version.split_once('@') {
        Some((n, v)) => (n.to_string(), v.to_string()),
        None => {
            fail(CompileError::CliError {
                message: format!("invalid package specifier '{}' — expected name@version", package_version),
                help: Some("example: forge yank graphql@3.1.0".to_string()),
            });
        }
    };

    let registry_url = registry.as_deref().unwrap_or("https://registry.forgelang.org");
    if let Err(e) = forge::publish::yank_local(&name, &version, reason.as_deref(), registry_url) {
        fail(CompileError::CliError {
            message: format!("yank failed: {}", e),
            help: None,
        });
    }
    eprintln!("{}@{} marked as yanked.", name, version);
}

fn cmd_allow(package: String, capability: String) {
    let cwd = std::env::current_dir().unwrap_or_else(|_| PathBuf::from("."));
    if let Err(e) = forge::audit::allow_capability(&cwd, &package, &capability) {
        fail(CompileError::CliError {
            message: format!("failed to allow capability: {}", e),
            help: None,
        });
    }
    eprintln!("allowed {} for package {}", capability, package);
}

fn cmd_quality(path: Option<PathBuf>) {
    let project_dir = path.unwrap_or_else(|| {
        std::env::current_dir().unwrap_or_else(|_| PathBuf::from("."))
    });
    let meta = forge::quality::extract_meta(&project_dir);
    // Try to get package name/version from forge.toml
    let toml_path = project_dir.join("forge.toml");
    let (pkg_name, pkg_version) = if let Ok(content) = std::fs::read_to_string(&toml_path) {
        let val: toml::Value = toml::from_str(&content).unwrap_or(toml::Value::Table(Default::default()));
        let name = val.get("project").and_then(|p| p.get("name")).and_then(|n| n.as_str()).unwrap_or("unknown").to_string();
        let version = val.get("project").and_then(|p| p.get("version")).and_then(|v| v.as_str()).unwrap_or("0.0.0").to_string();
        (name, version)
    } else {
        ("unknown".to_string(), "0.0.0".to_string())
    };
    let report = forge::quality::compute_quality(&pkg_name, &pkg_version, &meta);
    print!("{}", forge::quality::format_report(&report));
}

fn scaffold_package(name: &str, with_component: bool) -> Result<(), String> {
    forge::package::scaffold_package(name, with_component)
}

// ── Deps subcommands ───────────────────────────────────────────────

/// Load the resolved dependency graph for the current project.
fn load_dep_graph() -> (String, String, forge::resolver::ResolvedGraph) {
    use forge::resolver;
    use forge::features::modules::project::ForgeProject;

    let cwd = std::env::current_dir().unwrap_or_else(|_| PathBuf::from("."));

    let project = match ForgeProject::load(&cwd) {
        Ok(p) => p,
        Err(e) => fail(CompileError::CliError {
            message: format!("cannot load project: {}", e),
            help: Some("run this command from a directory containing forge.toml".to_string()),
        }),
    };

    let toml_path = cwd.join("forge.toml");
    let toml_content = match std::fs::read_to_string(&toml_path) {
        Ok(c) => c,
        Err(e) => fail(CompileError::FileNotFound {
            path: toml_path.display().to_string(),
            detail: e.to_string(),
        }),
    };
    let toml_val: toml::Value = match toml::from_str(&toml_content) {
        Ok(v) => v,
        Err(e) => fail(CompileError::CliError {
            message: format!("invalid forge.toml: {}", e),
            help: None,
        }),
    };

    let direct_deps: std::collections::HashMap<String, String> = toml_val
        .get("dependencies")
        .and_then(|d| d.as_table())
        .map(|t| {
            t.iter()
                .filter_map(|(k, v)| v.as_str().map(|s| (k.clone(), s.to_string())))
                .collect()
        })
        .unwrap_or_default();

    let packages_dir = cwd.join("packages");
    let local_pkgs = resolver::scan_local_packages(&packages_dir);
    let available = |name: &str| -> Option<resolver::PackageVersions> {
        local_pkgs.get(name).cloned()
    };

    let graph = match resolver::resolve(&direct_deps, &available) {
        Ok(g) => g,
        Err(e) => fail(e),
    };

    (
        project.config.project.name.clone(),
        project.config.project.version.clone(),
        graph,
    )
}

fn cmd_deps_explain(package: String) {
    use std::collections::VecDeque;

    let (project_name, project_version, graph) = load_dep_graph();

    if !graph.packages.contains_key(&package) {
        fail(CompileError::CliError {
            message: format!("package '{}' not found in dependency tree", package),
            help: Some("run `forge deps` to see all resolved dependencies".to_string()),
        });
    }

    let root_label = format!("{} v{}", project_name, project_version);

    // BFS: find shortest path from root deps to the target package
    let mut queue: VecDeque<Vec<String>> = VecDeque::new();
    for root_dep in &graph.root_deps {
        queue.push_back(vec![root_dep.clone()]);
    }

    let mut shortest_path: Option<Vec<String>> = None;
    'bfs: while let Some(path) = queue.pop_front() {
        let current = path.last().unwrap().clone();
        if current == package {
            shortest_path = Some(path);
            break 'bfs;
        }
        if let Some(dep) = graph.packages.get(&current) {
            for child in &dep.dependencies {
                if !path.contains(child) {
                    let mut new_path = path.clone();
                    new_path.push(child.clone());
                    queue.push_back(new_path);
                }
            }
        }
    }

    let path = shortest_path.unwrap_or_else(|| vec![package.clone()]);
    let dep_info = graph.packages.get(&package).unwrap();

    eprintln!();
    eprintln!("  {} v{} is in your project because:", dep_info.name, dep_info.version);
    eprintln!();

    let mut chain_parts = vec![root_label];
    for name in &path {
        if let Some(d) = graph.packages.get(name) {
            chain_parts.push(format!("{} v{}", d.name, d.version));
        } else {
            chain_parts.push(name.clone());
        }
    }
    eprintln!("  {}", chain_parts.join(" \u{2192} "));

    if !dep_info.capabilities.is_empty() {
        let ancestor_caps: Vec<String> = path[..path.len().saturating_sub(1)]
            .iter()
            .flat_map(|n| graph.packages.get(n).map(|d| d.capabilities.clone()).unwrap_or_default())
            .collect();
        let already_approved: Vec<&String> = dep_info.capabilities.iter()
            .filter(|c| ancestor_caps.contains(c))
            .collect();

        eprint!("\n  capabilities: [{}]", dep_info.capabilities.join(", "));
        if !already_approved.is_empty() && path.len() >= 2 {
            eprint!(" (already approved via {})", path[path.len() - 2]);
        }
        eprintln!();
    }

    eprintln!();
}

fn cmd_deps_capabilities() {
    use std::collections::BTreeMap;

    let (project_name, project_version, graph) = load_dep_graph();

    eprintln!();
    eprintln!("  {} v{} \u{2014} capability summary", project_name, project_version);
    eprintln!();

    let all_caps = ["compile_time_codegen", "ffi", "filesystem", "native", "network"];
    let mut cap_map: BTreeMap<String, Vec<String>> = BTreeMap::new();
    for cap in &all_caps {
        cap_map.insert(cap.to_string(), Vec::new());
    }

    let mut sorted_deps: Vec<_> = graph.packages.values().collect();
    sorted_deps.sort_by(|a, b| a.name.cmp(&b.name));

    for dep in sorted_deps {
        for cap in &dep.capabilities {
            cap_map.entry(cap.clone())
                .or_default()
                .push(format!("{} v{}", dep.name, dep.version));
        }
    }

    for (cap, pkgs) in &cap_map {
        if pkgs.is_empty() {
            eprintln!("  {:<20} (none)", cap);
        } else {
            eprintln!("  {:<20} {}", cap, pkgs.join(", "));
        }
    }

    eprintln!();
}

fn cmd_deps_outdated() {
    let cwd = std::env::current_dir().unwrap_or_else(|_| PathBuf::from("."));
    match forge::pkg_commands::list_outdated(&cwd) {
        Ok(_) => {}
        Err(e) => fail(CompileError::CliError {
            message: format!("failed to check outdated deps: {}", e),
            help: None,
        }),
    }
}

fn cmd_info(package: String, show_context: bool) {
    let cwd = std::env::current_dir().unwrap_or_else(|_| PathBuf::from("."));
    let packages_dir = cwd.join("packages");

    match find_package_dir(&packages_dir, &package) {
        Some(dir) => print_package_info(&package, &dir, show_context),
        None => fail(CompileError::CliError {
            message: format!("package '{}' not found in packages/ directory", package),
            help: Some("use `forge deps` to list resolved project dependencies".to_string()),
        }),
    }
}

/// Search `packages_dir` for a subdirectory whose package.toml name or directory
/// name matches `package_name`. Returns the first matching path.
fn find_package_dir(packages_dir: &std::path::Path, package_name: &str) -> Option<std::path::PathBuf> {
    let entries = std::fs::read_dir(packages_dir).ok()?;
    for entry in entries.flatten() {
        let path = entry.path();
        if !path.is_dir() {
            continue;
        }
        let dir_name = path.file_name().and_then(|n| n.to_str()).unwrap_or("").to_string();
        if dir_name == package_name {
            return Some(path);
        }
        let toml_path = path.join("package.toml");
        if let Ok(content) = std::fs::read_to_string(&toml_path) {
            if let Ok(val) = content.parse::<toml::Value>() {
                let declared_name = val.get("package")
                    .and_then(|p| p.get("name"))
                    .and_then(|v| v.as_str())
                    .unwrap_or("");
                let namespace = val.get("package")
                    .and_then(|p| p.get("namespace"))
                    .and_then(|v| v.as_str())
                    .unwrap_or("");
                let qualified = if namespace.is_empty() {
                    declared_name.to_string()
                } else {
                    format!("@{}/{}", namespace, declared_name)
                };
                if declared_name == package_name || qualified == package_name {
                    return Some(path);
                }
            }
        }
    }
    None
}

fn print_package_info(package_name: &str, pkg_dir: &std::path::Path, show_context: bool) {
    let toml_path = pkg_dir.join("package.toml");
    let toml_content = std::fs::read_to_string(&toml_path).unwrap_or_default();
    let val: toml::Value = toml_content.parse::<toml::Value>()
        .unwrap_or(toml::Value::Table(Default::default()));
    let pkg = val.get("package");

    let name = pkg.and_then(|p| p.get("name")).and_then(|v| v.as_str()).unwrap_or(package_name);
    let version = pkg.and_then(|p| p.get("version")).and_then(|v| v.as_str()).unwrap_or("0.0.0");
    let description = pkg.and_then(|p| p.get("description")).and_then(|v| v.as_str()).unwrap_or("");
    let license = pkg.and_then(|p| p.get("license")).and_then(|v| v.as_str()).unwrap_or("");
    let repository = pkg.and_then(|p| p.get("repository")).and_then(|v| v.as_str()).unwrap_or("");

    let authors: Vec<String> = pkg
        .and_then(|p| p.get("authors"))
        .and_then(|v| v.as_array())
        .map(|arr| arr.iter().filter_map(|a| a.as_str().map(|s| s.to_string())).collect())
        .unwrap_or_default();

    let deps: Vec<String> = val.get("dependencies")
        .and_then(|d| d.as_table())
        .map(|t| {
            let mut sorted: Vec<_> = t.iter().collect();
            sorted.sort_by_key(|(k, _)| k.clone());
            sorted.iter().filter_map(|(k, v)| v.as_str().map(|ver| format!("{} {}", k, ver))).collect()
        })
        .unwrap_or_default();

    let caps: Vec<String> = val.get("capabilities")
        .and_then(|c| c.as_table())
        .map(|t| {
            let mut enabled: Vec<_> = t.iter()
                .filter(|(_, v)| v.as_bool() == Some(true))
                .map(|(k, _)| k.clone())
                .collect();
            enabled.sort();
            enabled
        })
        .unwrap_or_default();

    let meta = forge::quality::extract_meta(pkg_dir);
    let report = forge::quality::compute_quality(name, version, &meta);

    eprintln!();
    eprintln!("  \x1b[1m{} v{}\x1b[0m", name, version);
    if !description.is_empty() {
        eprintln!("  \x1b[38;5;246m\"{}\"\x1b[0m", description);
    }
    eprintln!();

    if !caps.is_empty() {
        eprintln!("  capabilities:  [{}]", caps.join(", "));
    } else {
        eprintln!("  capabilities:  [none]");
    }
    if !deps.is_empty() {
        eprintln!("  dependencies:  {}", deps.join(", "));
    }
    if !license.is_empty() {
        eprintln!("  license:       {}", license);
    }
    if !authors.is_empty() {
        eprintln!("  authors:       {}", authors.join(", "));
    }
    if !repository.is_empty() {
        eprintln!("  repository:    {}", repository);
    }

    eprintln!();
    let score = report.overall_score;
    let filled = score as usize;
    let empty = 10usize.saturating_sub(filled);
    let color = if score >= 7.0 { "32" } else if score >= 4.0 { "33" } else { "31" };
    eprintln!(
        "  quality: \x1b[{}m{}\x1b[90m{}\x1b[0m {:.1}/10",
        color,
        "\u{2588}".repeat(filled),
        "\u{2591}".repeat(empty),
        score
    );

    let check = "\u{2713}";
    let cross = "\u{2717}";
    let tests_ok = meta.test_count > 0;
    let docs_ok = meta.has_readme || meta.has_description;
    let maintained = meta.has_changelog || meta.has_repository;
    let stable_api = score >= 7.0;

    let mut badges = Vec::new();
    if tests_ok { badges.push(format!("\x1b[32m{} tests\x1b[0m", check)); }
    else { badges.push(format!("\x1b[31m{} tests\x1b[0m", cross)); }
    if docs_ok { badges.push(format!("\x1b[32m{} documented\x1b[0m", check)); }
    else { badges.push(format!("\x1b[31m{} documented\x1b[0m", cross)); }
    if maintained { badges.push(format!("\x1b[32m{} maintained\x1b[0m", check)); }
    else { badges.push(format!("\x1b[31m{} maintained\x1b[0m", cross)); }
    if stable_api { badges.push(format!("\x1b[32m{} stable API\x1b[0m", check)); }
    else { badges.push(format!("\x1b[33m~ stable API\x1b[0m")); }

    eprintln!("  {}", badges.join("  "));

    if show_context {
        let context_path = pkg_dir.join("context.fg");
        if context_path.exists() {
            if let Ok(ctx) = std::fs::read_to_string(&context_path) {
                eprintln!();
                eprintln!("  \x1b[1mexported API surface (context.fg):\x1b[0m");
                for line in ctx.lines() {
                    eprintln!("    {}", line);
                }
            }
        } else {
            eprintln!();
            eprintln!("  \x1b[38;5;246m(no context.fg found \u{2014} run `forge context` to generate)\x1b[0m");
        }
    }

    eprintln!();
}

// ── Cache commands ─────────────────────────────────────────────────

fn cmd_cache_status() {
    forge::cache::ensure_cache_dirs();
    print!("{}", forge::cache::cache_status());
}

fn cmd_cache_gc(aggressive: bool) {
    let cwd = std::env::current_dir().ok();
    let project_dir = cwd.as_deref();
    match forge::cache::cache_gc(aggressive, project_dir) {
        Ok(output) => print!("{}", output),
        Err(e) => fail(CompileError::CliError {
            message: format!("cache gc failed: {}", e),
            help: None,
        }),
    }
}

fn cmd_cache_clear() {
    // Confirmation prompt
    eprint!("  This will delete all cached artifacts. Continue? [y/N] ");
    let mut input = String::new();
    if std::io::stdin().read_line(&mut input).is_err() {
        fail(CompileError::CliError {
            message: "failed to read confirmation input".to_string(),
            help: None,
        });
    }
    let trimmed = input.trim().to_lowercase();
    if trimmed != "y" && trimmed != "yes" {
        eprintln!("  aborted.");
        return;
    }
    match forge::cache::cache_clear() {
        Ok(output) => print!("{}", output),
        Err(e) => fail(CompileError::CliError {
            message: format!("cache clear failed: {}", e),
            help: None,
        }),
    }
}

fn cmd_cache_prefetch() {
    let cwd = std::env::current_dir().unwrap_or_else(|_| PathBuf::from("."));
    match forge::cache::cache_prefetch(&cwd) {
        Ok(output) => print!("{}", output),
        Err(e) => fail(CompileError::CliError {
            message: format!("prefetch failed: {}", e),
            help: Some("run this command from a directory containing forge.lock".to_string()),
        }),
    }
}

