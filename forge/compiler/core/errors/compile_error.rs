/// Structured compiler errors with classification and actionable guidance.
///
/// ╔══════════════════════════════════════════════════════════════════════╗
/// ║  EVERY error the compiler can produce MUST go through this system. ║
/// ║  No raw strings, no eprintln!, no unwrap(). If you're adding a     ║
/// ║  new error path, add a variant here with a render() arm.           ║
/// ║  See CLAUDE.md § Error System for the full contract.               ║
/// ╚══════════════════════════════════════════════════════════════════════╝

use std::fmt;

// ── Error type ──────────────────────────────────────────────────────
//
// Adding a new error? You MUST:
//   1. Add the variant below
//   2. Add a Display arm
//   3. Add a render() arm with ANSI formatting + actionable help text
//   4. Add an error test in compiler/features/error_messages/examples/
//
// DO NOT use `Other` for new error paths — create a specific variant.
// DO NOT use `eprintln!` anywhere in the compiler — use CompileError::render().

#[derive(Debug)]
pub enum CompileError {
    /// Source file couldn't be read
    FileNotFound { path: String, detail: String },

    /// Lexer/parser/type-check errors (already rendered via DiagnosticBag)
    DiagnosticErrors { stage: &'static str },

    /// Runtime.c couldn't be found
    RuntimeNotFound,

    /// Runtime.c failed to compile
    RuntimeCompileFailed { stderr: String },

    /// Linker: undefined symbols (missing provider or runtime function)
    UndefinedSymbols { symbols: Vec<UndefinedSymbol> },

    /// Linker: object file missing/empty/corrupt
    LinkerFileError { path: String, detail: String },

    /// Linker: generic failure
    LinkerFailed { stderr: String },

    /// Object file couldn't be written
    ObjectWriteFailed { detail: String },

    /// Provider failed to load (bad provider.toml, missing files, parse errors)
    ProviderLoadFailed { provider: String, detail: String },

    /// Provider referenced in `use @ns.name` but not found on disk
    ProviderNotFound { namespace: String, name: String },

    /// LLVM codegen failure (module verification, target machine, etc.)
    CodegenFailed { stage: &'static str, detail: String },

    /// Compiled binary failed to execute
    BinaryRunFailed { path: String, detail: String },

    /// CLI usage error (bad arguments, missing files, invalid format)
    CliError { message: String, help: Option<String> },
}

#[derive(Debug)]
pub struct UndefinedSymbol {
    pub name: String,
    pub provider: Option<&'static str>,
}

// ── Conversion from String ──────────────────────────────────────────
//
// This exists ONLY for backward compatibility with code that still uses
// `Result<_, String>`. Every use should eventually be replaced with a
// specific CompileError variant. When you see this triggered, it means
// someone took a shortcut — fix the callsite instead.

impl From<String> for CompileError {
    fn from(s: String) -> Self {
        CompileError::CliError { message: s, help: None }
    }
}

impl From<&str> for CompileError {
    fn from(s: &str) -> Self {
        CompileError::CliError { message: s.to_string(), help: None }
    }
}

// ── Parsing from raw linker output ──────────────────────────────────

impl CompileError {
    /// Parse a raw linker stderr string into a structured error.
    pub fn from_linker_stderr(stderr: &str) -> Self {
        let clean = strip_ansi(stderr);

        // Check for undefined symbols
        if clean.contains("Undefined symbols") || clean.contains("undefined reference") {
            let symbols = parse_undefined_symbols(&clean);
            if !symbols.is_empty() {
                return CompileError::UndefinedSymbols { symbols };
            }
        }

        // Check for file-not-found / empty / corrupt
        if clean.contains("no such file") || clean.contains("cannot be open")
            || clean.contains("file is empty")
        {
            let path = extract_path_from_linker(&clean).unwrap_or_default();
            let detail = clean.lines()
                .find(|l| l.contains("no such file") || l.contains("cannot be open") || l.contains("file is empty"))
                .unwrap_or("")
                .trim()
                .to_string();
            return CompileError::LinkerFileError { path, detail };
        }

        CompileError::LinkerFailed { stderr: clean }
    }

    pub fn from_runtime_stderr(stderr: &str) -> Self {
        CompileError::RuntimeCompileFailed { stderr: strip_ansi(stderr) }
    }
}

fn parse_undefined_symbols(stderr: &str) -> Vec<UndefinedSymbol> {
    let mut symbols = Vec::new();
    for line in stderr.lines() {
        let trimmed = line.trim();
        // macOS ld: "symbol", referenced from:
        if let Some(rest) = trimmed.strip_prefix('"') {
            if let Some(pos) = rest.find('"') {
                let sym = &rest[..pos];
                // Strip leading underscore (C ABI on macOS)
                let sym = sym.strip_prefix('_').unwrap_or(sym);
                let provider = guess_provider(sym);
                symbols.push(UndefinedSymbol { name: sym.to_string(), provider });
            }
        }
        // Linux ld: undefined reference to `symbol'
        if let Some(rest) = trimmed.strip_prefix("undefined reference to `") {
            if let Some(sym) = rest.strip_suffix('\'') {
                let provider = guess_provider(sym);
                symbols.push(UndefinedSymbol { name: sym.to_string(), provider });
            }
        }
    }
    symbols
}

fn extract_path_from_linker(stderr: &str) -> Option<String> {
    for line in stderr.lines() {
        if let Some(idx) = line.find("path=") {
            let rest = &line[idx + 5..];
            let end = rest.find(|c: char| c.is_whitespace() || c == '\'').unwrap_or(rest.len());
            return Some(rest[..end].to_string());
        }
        if line.contains("no such file or directory:") {
            if let Some(idx) = line.rfind('\'') {
                let before = &line[..idx];
                if let Some(start) = before.rfind('\'') {
                    return Some(before[start + 1..].to_string());
                }
            }
        }
    }
    None
}

fn guess_provider(symbol: &str) -> Option<&'static str> {
    if symbol.starts_with("forge_channel_") { return Some("@std.channel"); }
    if symbol.starts_with("forge_http_") || symbol.starts_with("forge_server_") { return Some("@std.http"); }
    if symbol.starts_with("forge_model_") { return Some("@std.model"); }
    if symbol.starts_with("forge_queue_") { return Some("@std.queue"); }
    if symbol.starts_with("forge_cron_") || symbol.starts_with("forge_schedule_") { return Some("@std.cron"); }
    if symbol.starts_with("forge_fs_") { return Some("@std.fs"); }
    if symbol.starts_with("forge_process_") { return Some("@std.process"); }
    if symbol.starts_with("forge_string_") || symbol.starts_with("forge_list_")
        || symbol.starts_with("forge_json_") || symbol.starts_with("forge_alloc")
        || symbol.starts_with("forge_print")
    {
        return Some("stdlib (runtime.c)");
    }
    None
}

fn strip_ansi(s: &str) -> String {
    let mut result = String::with_capacity(s.len());
    let mut chars = s.chars().peekable();
    while let Some(c) = chars.next() {
        if c == '\x1b' {
            while let Some(&next) = chars.peek() {
                chars.next();
                if next == 'm' { break; }
            }
        } else {
            result.push(c);
        }
    }
    result
}

// ── Display (for eprintln!("error: {}", e)) ────────────────────────

impl fmt::Display for CompileError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            CompileError::FileNotFound { path, detail } => {
                write!(f, "cannot read {}: {}", path, detail)
            }
            CompileError::DiagnosticErrors { stage } => {
                write!(f, "{} errors (see above)", stage)
            }
            CompileError::RuntimeNotFound => {
                write!(f, "cannot find stdlib/runtime.c")
            }
            CompileError::RuntimeCompileFailed { stderr } => {
                write!(f, "failed to compile runtime: {}", first_line(stderr))
            }
            CompileError::UndefinedSymbols { symbols } => {
                write!(f, "linker error: {} undefined symbol{}", symbols.len(),
                    if symbols.len() == 1 { "" } else { "s" })
            }
            CompileError::LinkerFileError { path, .. } => {
                write!(f, "linker error: object file not found: {}", path)
            }
            CompileError::LinkerFailed { stderr } => {
                write!(f, "linker error: {}", first_line(stderr))
            }
            CompileError::ObjectWriteFailed { detail } => {
                write!(f, "failed to write object file: {}", detail)
            }
            CompileError::ProviderLoadFailed { provider, detail } => {
                write!(f, "failed to load provider '{}': {}", provider, detail)
            }
            CompileError::ProviderNotFound { namespace, name } => {
                write!(f, "provider @{}.{} not found", namespace, name)
            }
            CompileError::CodegenFailed { stage, detail } => {
                write!(f, "codegen error ({}): {}", stage, first_line(detail))
            }
            CompileError::BinaryRunFailed { path, detail } => {
                write!(f, "failed to run {}: {}", path, detail)
            }
            CompileError::CliError { message, .. } => {
                write!(f, "{}", message)
            }
        }
    }
}

fn first_line(s: &str) -> &str {
    s.lines().next().unwrap_or(s).trim()
}

// ── Pretty rendering ────────────────────────────────────────────────
//
// render() is the ONLY way errors should reach the user.
// Every variant MUST have:
//   - An error: line (red, bold)
//   - Context or detail (dim)
//   - A help: line with actionable guidance

impl CompileError {
    /// Render this error with full ANSI formatting and actionable guidance.
    /// This is what the user sees. EVERY error path must go through here.
    pub fn render(&self) -> String {
        let mut out = String::new();
        let is_tty = unsafe { isatty_check() };

        match self {
            CompileError::FileNotFound { path, detail } => {
                out.push_str(&err_line(is_tty, &format!("cannot read `{}`", path)));
                out.push_str(&dim_line(is_tty, detail));
            }

            CompileError::DiagnosticErrors { stage } => {
                // Diagnostics already printed by emit_diagnostics
                out.push_str(&dim_line(is_tty, &format!("compilation failed due to {} errors", stage)));
            }

            CompileError::RuntimeNotFound => {
                out.push_str(&err_line(is_tty, "cannot find stdlib/runtime.c"));
                out.push_str(&help_line(is_tty, "make sure you're running from the forge project root, or that the forge binary is installed correctly"));
            }

            CompileError::RuntimeCompileFailed { stderr } => {
                out.push_str(&err_line(is_tty, "failed to compile runtime"));
                for line in stderr.lines().take(5) {
                    let trimmed = line.trim();
                    if !trimmed.is_empty() {
                        out.push_str(&dim_line(is_tty, trimmed));
                    }
                }
                out.push_str(&help_line(is_tty, "check that `cc` (clang/gcc) is installed and that stdlib/runtime.c compiles"));
            }

            CompileError::UndefinedSymbols { symbols } => {
                let count = symbols.len();
                out.push_str(&err_line(is_tty, &format!(
                    "linker error: {} undefined symbol{}",
                    count,
                    if count == 1 { "" } else { "s" },
                )));
                out.push('\n');

                // Group by provider
                let mut by_provider: std::collections::HashMap<Option<&str>, Vec<&str>> =
                    std::collections::HashMap::new();
                for sym in symbols {
                    by_provider.entry(sym.provider).or_default().push(&sym.name);
                }

                for (provider, syms) in &by_provider {
                    if let Some(prov) = provider {
                        let source = if is_tty {
                            format!("\x1b[2m(from {})\x1b[0m", prov)
                        } else {
                            format!("(from {})", prov)
                        };
                        for sym in syms {
                            out.push_str(&format!("    {} {} {}\n",
                                red(is_tty, "→"),
                                sym,
                                source,
                            ));
                        }
                    } else {
                        for sym in syms {
                            out.push_str(&format!("    {} {}\n", red(is_tty, "→"), sym));
                        }
                    }
                }

                // Generate help
                let providers: std::collections::HashSet<&str> = symbols.iter()
                    .filter_map(|s| s.provider)
                    .collect();

                if providers.is_empty() {
                    out.push_str(&help_line(is_tty, "these symbols are not from any known provider — check your extern declarations"));
                } else {
                    let runtime_only = providers.iter().all(|p| p.contains("runtime"));
                    if runtime_only {
                        out.push_str(&help_line(is_tty, "runtime function missing — rebuild stdlib/runtime.c and make sure it defines these symbols"));
                    } else {
                        let imports: Vec<String> = providers.iter()
                            .filter(|p| !p.contains("runtime"))
                            .map(|p| format!("use {}", p))
                            .collect();
                        out.push_str(&help_line(is_tty, &format!(
                            "add `{}` to your source file, or check that the provider's native library is built",
                            imports.join("`, `"),
                        )));
                    }
                }
            }

            CompileError::LinkerFileError { path, detail } => {
                out.push_str(&err_line(is_tty, "linker error: object file not found"));
                if !path.is_empty() {
                    out.push_str(&dim_line(is_tty, &format!("path: {}", path)));
                }
                if !detail.is_empty() {
                    out.push_str(&dim_line(is_tty, detail));
                }
                out.push_str(&help_line(is_tty, "compilation may have failed silently — try `forge build <file>` directly to see the full error"));
            }

            CompileError::LinkerFailed { stderr } => {
                out.push_str(&err_line(is_tty, "linker error"));
                for line in stderr.lines().take(5) {
                    let trimmed = line.trim();
                    if !trimmed.is_empty() {
                        out.push_str(&dim_line(is_tty, trimmed));
                    }
                }
                out.push_str(&help_line(is_tty, "check that `cc` (clang/gcc) is installed and all required libraries are linked"));
            }

            CompileError::ObjectWriteFailed { detail } => {
                out.push_str(&err_line(is_tty, "failed to write object file"));
                out.push_str(&dim_line(is_tty, detail));
                out.push_str(&help_line(is_tty, "check disk space and write permissions"));
            }

            CompileError::ProviderLoadFailed { provider, detail } => {
                out.push_str(&err_line(is_tty, &format!("failed to load provider `{}`", provider)));
                out.push_str(&dim_line(is_tty, detail));
                out.push_str(&help_line(is_tty, "check provider.toml syntax and that src/provider.fg compiles. Run `forge provider new <name>` to see the expected structure"));
            }

            CompileError::ProviderNotFound { namespace, name } => {
                out.push_str(&err_line(is_tty, &format!("provider @{}.{} not found", namespace, name)));
                out.push_str(&dim_line(is_tty, &format!("looked for providers/{}-{}/provider.toml", namespace, name)));
                out.push_str(&help_line(is_tty, "check that the provider exists in the providers/ directory and has a valid provider.toml. Run `forge provider new <name>` to scaffold a new one"));
            }

            CompileError::CodegenFailed { stage, detail } => {
                out.push_str(&err_line(is_tty, &format!("code generation failed ({})", stage)));
                for line in detail.lines().take(5) {
                    let trimmed = line.trim();
                    if !trimmed.is_empty() {
                        out.push_str(&dim_line(is_tty, trimmed));
                    }
                }
                out.push_str(&help_line(is_tty, "this is likely a compiler bug — please report at https://github.com/forge-lang/forge/issues with the source file that triggered it"));
            }

            CompileError::BinaryRunFailed { path, detail } => {
                out.push_str(&err_line(is_tty, &format!("failed to run `{}`", path)));
                out.push_str(&dim_line(is_tty, detail));
                out.push_str(&help_line(is_tty, "check that the compiled binary exists and has execute permissions"));
            }

            CompileError::CliError { message, help } => {
                out.push_str(&err_line(is_tty, message));
                if let Some(h) = help {
                    out.push_str(&help_line(is_tty, h));
                }
            }
        }

        out
    }
}

// ── ANSI helpers ────────────────────────────────────────────────────

fn red(is_tty: bool, s: &str) -> String {
    if is_tty { format!("\x1b[31m{}\x1b[0m", s) } else { s.to_string() }
}

fn err_line(is_tty: bool, msg: &str) -> String {
    if is_tty {
        format!("\x1b[1;31merror\x1b[0m\x1b[1m: {}\x1b[0m\n", msg)
    } else {
        format!("error: {}\n", msg)
    }
}

fn dim_line(is_tty: bool, msg: &str) -> String {
    if is_tty {
        format!("  \x1b[2m{}\x1b[0m\n", msg)
    } else {
        format!("  {}\n", msg)
    }
}

fn help_line(is_tty: bool, msg: &str) -> String {
    if is_tty {
        format!("  \x1b[1;36mhelp\x1b[0m: {}\n", msg)
    } else {
        format!("  help: {}\n", msg)
    }
}

extern "C" { fn isatty(fd: i32) -> i32; }
unsafe fn isatty_check() -> bool { unsafe { isatty(2) != 0 } }
