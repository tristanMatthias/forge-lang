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

    /// Linker: undefined symbols (missing package or runtime function)
    UndefinedSymbols { symbols: Vec<UndefinedSymbol> },

    /// Linker: object file missing/empty/corrupt
    LinkerFileError { path: String, detail: String },

    /// Linker: generic failure
    LinkerFailed { stderr: String },

    /// Object file couldn't be written
    ObjectWriteFailed { detail: String },

    /// Package failed to load (bad package.toml, missing files, parse errors)
    PackageLoadFailed { package: String, detail: String },

    /// Package referenced in `use @ns.name` but not found on disk
    PackageNotFound { namespace: String, name: String },

    /// LLVM codegen failure (module verification, target machine, etc.)
    CodegenFailed { stage: &'static str, detail: String },

    /// Compiled binary failed to execute
    BinaryRunFailed { path: String, detail: String },

    /// JIT execution failed (engine creation, symbol lookup, runtime load)
    JitFailed { detail: String },

    /// CLI usage error (bad arguments, missing files, invalid format)
    CliError { message: String, help: Option<String> },

    // ── Package Registry Errors (E0450-E0499) ────────────────────────

    /// Dependency not found in registry or as Git URL
    DependencyNotFound { name: String, detail: String },

    /// Requested version does not exist
    VersionNotFound { package: String, version: String },

    /// No version satisfies the declared range
    VersionRangeUnsatisfiable { package: String, range: String, available: Vec<String> },

    /// Two packages require incompatible versions of the same dependency
    DependencyConflict { dependency: String, requesters: Vec<(String, String)> },

    /// Dependency graph contains a cycle
    CircularDependency { chain: Vec<String> },

    /// Package code uses a capability not declared in package.toml
    UndeclaredCapability { package: String, capability: String, location: String },

    /// Package code exceeds declared capabilities
    CapabilityViolation { package: String, declared: Vec<String>, used: String, location: String },

    /// Patch/minor update introduces new capabilities
    CapabilityEscalation { package: String, old_version: String, new_version: String, old_caps: Vec<String>, new_caps: Vec<String> },

    /// Cached content doesn't match lockfile hash
    ContentHashMismatch { package: String, version: String, expected: String, got: String },

    /// Pre-compiled artifact doesn't match expected hash
    ArtifactHashMismatch { package: String, version: String },

    /// forge.lock doesn't match forge.toml
    LockfileStale { detail: String },

    /// Cannot have multiple versions of the same package
    DuplicateVersion { package: String, versions: Vec<String>, requesters: Vec<String> },

    /// Publish version is below compiler-computed minimum
    VersionBelowMinimum { attempted: String, minimum: String, reason: String },

    /// Cannot publish: tests do not pass
    PublishTestsFailed { detail: String },

    /// Registry authentication failed
    PublishAuthFailed { detail: String },

    /// Package name already registered by another author
    PublishNameTaken { name: String },

    /// Cannot publish a package with path dependencies
    PathDependencyInPublish { package: String, path_deps: Vec<String> },

    /// Cannot clone/fetch Git dependency
    GitDependencyUnavailable { url: String, detail: String },

    /// Specified tag/branch/rev not found in Git repository
    GitRefNotFound { url: String, ref_spec: String },

    /// Git repository does not contain package.toml
    MissingPackageManifest { url: String },
}

#[derive(Debug)]
pub struct UndefinedSymbol {
    pub name: String,
    pub package: Option<String>,
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
                let package = guess_package(sym);
                symbols.push(UndefinedSymbol { name: sym.to_string(), package });
            }
        }
        // Linux ld: undefined reference to `symbol'
        if let Some(rest) = trimmed.strip_prefix("undefined reference to `") {
            if let Some(sym) = rest.strip_suffix('\'') {
                let package = guess_package(sym);
                symbols.push(UndefinedSymbol { name: sym.to_string(), package });
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

/// Guess which package a symbol belongs to using naming conventions.
/// Convention: `forge_{namespace}_*` → `@std.{namespace}`.
/// No hardcoded per-package mappings — any package following the convention is detected.
fn guess_package(symbol: &str) -> Option<String> {
    let rest = symbol.strip_prefix("forge_")?;
    let ns = rest.split('_').next()?;
    if ns.is_empty() { return None; }

    // Core runtime namespaces (not from any package)
    const RUNTIME_NAMESPACES: &[&str] = &[
        "string", "list", "json", "alloc", "print", "fmt", "map",
    ];
    if RUNTIME_NAMESPACES.contains(&ns) {
        return Some("stdlib (runtime.c)".to_string());
    }

    Some(format!("@std.{}", ns))
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
            CompileError::PackageLoadFailed { package, detail } => {
                write!(f, "failed to load package '{}': {}", package, detail)
            }
            CompileError::PackageNotFound { namespace, name } => {
                write!(f, "package @{}.{} not found", namespace, name)
            }
            CompileError::CodegenFailed { stage, detail } => {
                write!(f, "codegen error ({}): {}", stage, first_line(detail))
            }
            CompileError::BinaryRunFailed { path, detail } => {
                write!(f, "failed to run {}: {}", path, detail)
            }
            CompileError::JitFailed { detail } => {
                write!(f, "JIT execution failed: {}", first_line(detail))
            }
            CompileError::CliError { message, .. } => {
                write!(f, "{}", message)
            }

            // ── Package Registry Errors ──────────────────────────────
            CompileError::DependencyNotFound { name, .. } => {
                write!(f, "package '{}' not found", name)
            }
            CompileError::VersionNotFound { package, version } => {
                write!(f, "version {} of '{}' not found", version, package)
            }
            CompileError::VersionRangeUnsatisfiable { package, range, .. } => {
                write!(f, "no version of '{}' satisfies range {}", package, range)
            }
            CompileError::DependencyConflict { dependency, .. } => {
                write!(f, "conflicting requirements for '{}'", dependency)
            }
            CompileError::CircularDependency { chain } => {
                write!(f, "circular dependency: {}", chain.join(" → "))
            }
            CompileError::UndeclaredCapability { package, capability, .. } => {
                write!(f, "package '{}' uses undeclared capability '{}'", package, capability)
            }
            CompileError::CapabilityViolation { package, used, .. } => {
                write!(f, "package '{}' uses capability '{}' not in its declared set", package, used)
            }
            CompileError::CapabilityEscalation { package, new_version, .. } => {
                write!(f, "version {} of '{}' introduces new capabilities", new_version, package)
            }
            CompileError::ContentHashMismatch { package, version, .. } => {
                write!(f, "content hash mismatch for '{}' v{}", package, version)
            }
            CompileError::ArtifactHashMismatch { package, version } => {
                write!(f, "artifact hash mismatch for '{}' v{}", package, version)
            }
            CompileError::LockfileStale { .. } => {
                write!(f, "forge.lock is out of date")
            }
            CompileError::DuplicateVersion { package, .. } => {
                write!(f, "multiple versions of '{}' required", package)
            }
            CompileError::VersionBelowMinimum { attempted, minimum, .. } => {
                write!(f, "version {} is below required minimum {}", attempted, minimum)
            }
            CompileError::PublishTestsFailed { .. } => {
                write!(f, "cannot publish: tests failed")
            }
            CompileError::PublishAuthFailed { .. } => {
                write!(f, "registry authentication failed")
            }
            CompileError::PublishNameTaken { name } => {
                write!(f, "package name '{}' is already taken", name)
            }
            CompileError::PathDependencyInPublish { package, .. } => {
                write!(f, "package '{}' has path dependencies", package)
            }
            CompileError::GitDependencyUnavailable { url, .. } => {
                write!(f, "cannot fetch git dependency '{}'", url)
            }
            CompileError::GitRefNotFound { url, ref_spec } => {
                write!(f, "ref '{}' not found in '{}'", ref_spec, url)
            }
            CompileError::MissingPackageManifest { url } => {
                write!(f, "no package.toml in '{}'", url)
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

                // Group by package
                let mut by_package: std::collections::HashMap<Option<&str>, Vec<&str>> =
                    std::collections::HashMap::new();
                for sym in symbols {
                    by_package.entry(sym.package.as_deref()).or_default().push(&sym.name);
                }

                for (package, syms) in &by_package {
                    if let Some(prov) = package {
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
                let packages: std::collections::HashSet<&str> = symbols.iter()
                    .filter_map(|s| s.package.as_deref())
                    .collect();

                if packages.is_empty() {
                    out.push_str(&help_line(is_tty, "these symbols are not from any known package — check your extern declarations"));
                } else {
                    let runtime_only = packages.iter().all(|p| p.contains("runtime"));
                    if runtime_only {
                        out.push_str(&help_line(is_tty, "runtime function missing — rebuild stdlib/runtime.c and make sure it defines these symbols"));
                    } else {
                        let imports: Vec<String> = packages.iter()
                            .filter(|p| !p.contains("runtime"))
                            .map(|p| format!("use {}", p))
                            .collect();
                        out.push_str(&help_line(is_tty, &format!(
                            "add `{}` to your source file, or check that the package's native library is built",
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
                out.push_str(&help_line(is_tty, "compilation may have failed silently — try `compiler build <file>` directly to see the full error"));
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

            CompileError::PackageLoadFailed { package, detail } => {
                out.push_str(&err_line(is_tty, &format!("failed to load package `{}`", package)));
                out.push_str(&dim_line(is_tty, detail));
                out.push_str(&help_line(is_tty, "check package.toml syntax and that src/package.fg compiles. Run `compiler package new <name>` to see the expected structure"));
            }

            CompileError::PackageNotFound { namespace, name } => {
                out.push_str(&err_line(is_tty, &format!("package @{}.{} not found", namespace, name)));
                out.push_str(&dim_line(is_tty, &format!("looked for packages/{}-{}/package.toml", namespace, name)));
                out.push_str(&help_line(is_tty, "check that the package exists in the packages/ directory and has a valid package.toml. Run `compiler package new <name>` to scaffold a new one"));
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

            CompileError::JitFailed { detail } => {
                out.push_str(&err_line(is_tty, "JIT execution failed"));
                for line in detail.lines().take(5) {
                    let trimmed = line.trim();
                    if !trimmed.is_empty() {
                        out.push_str(&dim_line(is_tty, trimmed));
                    }
                }
                out.push_str(&help_line(is_tty, "try `compiler build` + run the binary directly, or use `--no-jit` to bypass JIT"));
            }

            CompileError::CliError { message, help } => {
                out.push_str(&err_line(is_tty, message));
                if let Some(h) = help {
                    out.push_str(&help_line(is_tty, h));
                }
            }

            // ── Package Registry Errors (E0450-E0499) ───────────────

            CompileError::DependencyNotFound { name, detail } => {
                out.push_str(&err_code_line(is_tty, "E0450", "package not found"));
                out.push_str(&dim_line(is_tty, &format!("package \"{}\" was not found in the registry.", name)));
                if !detail.is_empty() {
                    out.push_str(&dim_line(is_tty, detail));
                }
                out.push_str(&help_line(is_tty, &format!("run `forge search {}` to find available packages", name)));
            }

            CompileError::VersionNotFound { package, version } => {
                out.push_str(&err_code_line(is_tty, "E0451", "version not found"));
                out.push_str(&dim_line(is_tty, &format!("version {} of \"{}\" does not exist in the registry.", version, package)));
                out.push_str(&help_line(is_tty, &format!("run `forge info {}` to see available versions", package)));
            }

            CompileError::VersionRangeUnsatisfiable { package, range, available } => {
                out.push_str(&err_code_line(is_tty, "E0452", "no matching version"));
                out.push_str(&dim_line(is_tty, &format!("no version of \"{}\" satisfies range {}.", package, range)));
                if !available.is_empty() {
                    out.push_str(&dim_line(is_tty, &format!("available versions: {}", available.join(", "))));
                }
                out.push_str(&help_line(is_tty, "widen the version range in forge.toml, or check for typos"));
            }

            CompileError::DependencyConflict { dependency, requesters } => {
                out.push_str(&err_code_line(is_tty, "E0453", "dependency conflict"));
                out.push_str(&dim_line(is_tty, &format!("conflicting version requirements for \"{}\":", dependency)));
                for (requester, version) in requesters {
                    out.push_str(&dim_line(is_tty, &format!("  {} requires {}", requester, version)));
                }
                out.push_str(&help_line(is_tty, "align version ranges across your dependencies, or contact the package authors"));
            }

            CompileError::CircularDependency { chain } => {
                out.push_str(&err_code_line(is_tty, "E0454", "circular dependency"));
                out.push_str(&dim_line(is_tty, &format!("dependency cycle detected: {}", chain.join(" -> "))));
                out.push_str(&help_line(is_tty, "break the cycle by extracting shared types into a separate package"));
            }

            CompileError::UndeclaredCapability { package, capability, location } => {
                out.push_str(&err_code_line(is_tty, "E0460", "undeclared capability"));
                out.push_str(&dim_line(is_tty, &format!("package \"{}\" uses capability \"{}\" which is not declared in its package.toml.", package, capability)));
                if !location.is_empty() {
                    out.push_str(&dim_line(is_tty, &format!("at: {}", location)));
                }
                out.push_str(&help_line(is_tty, &format!("add `capabilities = [\"{}\"]` to the package's package.toml", capability)));
            }

            CompileError::CapabilityViolation { package, declared, used, location } => {
                out.push_str(&err_code_line(is_tty, "E0461", "capability violation"));
                out.push_str(&dim_line(is_tty, &format!("package \"{}\" uses capability \"{}\" but only declares: [{}].", package, used, declared.join(", "))));
                if !location.is_empty() {
                    out.push_str(&dim_line(is_tty, &format!("at: {}", location)));
                }
                out.push_str(&help_line(is_tty, "either add the capability to package.toml or remove the code that requires it"));
            }

            CompileError::CapabilityEscalation { package, old_version, new_version, old_caps, new_caps } => {
                out.push_str(&err_code_line(is_tty, "E0462", "capability escalation"));
                out.push_str(&dim_line(is_tty, &format!("updating \"{}\" from v{} to v{} introduces new capabilities.", package, old_version, new_version)));
                out.push_str(&dim_line(is_tty, &format!("was: [{}]", old_caps.join(", "))));
                out.push_str(&dim_line(is_tty, &format!("now: [{}]", new_caps.join(", "))));
                out.push_str(&help_line(is_tty, "this requires a major version bump, or explicit user approval via `forge update --allow-escalation`"));
            }

            CompileError::ContentHashMismatch { package, version, expected, got } => {
                out.push_str(&err_code_line(is_tty, "E0463", "content hash mismatch"));
                out.push_str(&dim_line(is_tty, &format!("cached content for \"{}\" v{} does not match the lockfile hash.", package, version)));
                out.push_str(&dim_line(is_tty, &format!("expected: {}", expected)));
                out.push_str(&dim_line(is_tty, &format!("     got: {}", got)));
                out.push_str(&help_line(is_tty, "the cache may be corrupted — run `forge clean` and `forge install` to re-download"));
            }

            CompileError::ArtifactHashMismatch { package, version } => {
                out.push_str(&err_code_line(is_tty, "E0464", "artifact hash mismatch"));
                out.push_str(&dim_line(is_tty, &format!("pre-compiled artifact for \"{}\" v{} does not match the expected hash.", package, version)));
                out.push_str(&help_line(is_tty, "run `forge clean` and rebuild — if this persists, the registry artifact may have been tampered with"));
            }

            CompileError::LockfileStale { detail } => {
                out.push_str(&err_code_line(is_tty, "E0465", "lockfile out of date"));
                out.push_str(&dim_line(is_tty, "forge.lock does not match forge.toml."));
                if !detail.is_empty() {
                    out.push_str(&dim_line(is_tty, detail));
                }
                out.push_str(&help_line(is_tty, "run `forge install` to update the lockfile"));
            }

            CompileError::DuplicateVersion { package, versions, requesters } => {
                out.push_str(&err_code_line(is_tty, "E0470", "duplicate versions"));
                out.push_str(&dim_line(is_tty, &format!("multiple versions of \"{}\" are required: {}.", package, versions.join(", "))));
                if !requesters.is_empty() {
                    out.push_str(&dim_line(is_tty, &format!("requested by: {}", requesters.join(", "))));
                }
                out.push_str(&help_line(is_tty, "Forge does not support multiple versions of the same package — align your dependency ranges"));
            }

            CompileError::VersionBelowMinimum { attempted, minimum, reason } => {
                out.push_str(&err_code_line(is_tty, "E0480", "version below minimum"));
                out.push_str(&dim_line(is_tty, &format!("attempted to publish version {} but the minimum is {}.", attempted, minimum)));
                if !reason.is_empty() {
                    out.push_str(&dim_line(is_tty, &format!("reason: {}", reason)));
                }
                out.push_str(&help_line(is_tty, &format!("bump your version to at least {} in package.toml", minimum)));
            }

            CompileError::PublishTestsFailed { detail } => {
                out.push_str(&err_code_line(is_tty, "E0481", "publish blocked: tests failed"));
                out.push_str(&dim_line(is_tty, "all tests must pass before publishing."));
                if !detail.is_empty() {
                    out.push_str(&dim_line(is_tty, detail));
                }
                out.push_str(&help_line(is_tty, "run `forge test` to see failures, fix them, then retry `forge publish`"));
            }

            CompileError::PublishAuthFailed { detail } => {
                out.push_str(&err_code_line(is_tty, "E0482", "authentication failed"));
                out.push_str(&dim_line(is_tty, "the registry rejected your credentials."));
                if !detail.is_empty() {
                    out.push_str(&dim_line(is_tty, detail));
                }
                out.push_str(&help_line(is_tty, "run `forge login` to re-authenticate, then retry `forge publish`"));
            }

            CompileError::PublishNameTaken { name } => {
                out.push_str(&err_code_line(is_tty, "E0483", "package name taken"));
                out.push_str(&dim_line(is_tty, &format!("the name \"{}\" is already registered by another author.", name)));
                out.push_str(&help_line(is_tty, "choose a different package name in package.toml"));
            }

            CompileError::PathDependencyInPublish { package, path_deps } => {
                out.push_str(&err_code_line(is_tty, "E0484", "path dependencies in publish"));
                out.push_str(&dim_line(is_tty, &format!("package \"{}\" cannot be published with path dependencies:", package)));
                for dep in path_deps {
                    out.push_str(&dim_line(is_tty, &format!("  - {}", dep)));
                }
                out.push_str(&help_line(is_tty, "replace path dependencies with registry or git dependencies before publishing"));
            }

            CompileError::GitDependencyUnavailable { url, detail } => {
                out.push_str(&err_code_line(is_tty, "E0490", "git dependency unavailable"));
                out.push_str(&dim_line(is_tty, &format!("cannot clone or fetch \"{}\".", url)));
                if !detail.is_empty() {
                    out.push_str(&dim_line(is_tty, detail));
                }
                out.push_str(&help_line(is_tty, "check the URL, your network connection, and that you have access to the repository"));
            }

            CompileError::GitRefNotFound { url, ref_spec } => {
                out.push_str(&err_code_line(is_tty, "E0491", "git ref not found"));
                out.push_str(&dim_line(is_tty, &format!("ref \"{}\" does not exist in \"{}\".", ref_spec, url)));
                out.push_str(&help_line(is_tty, "check that the tag, branch, or commit hash exists in the remote repository"));
            }

            CompileError::MissingPackageManifest { url } => {
                out.push_str(&err_code_line(is_tty, "E0492", "missing package.toml"));
                out.push_str(&dim_line(is_tty, &format!("the git repository \"{}\" does not contain a package.toml at its root.", url)));
                out.push_str(&help_line(is_tty, "ensure the repository is a valid Forge package with a package.toml in the root directory"));
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

fn err_code_line(is_tty: bool, code: &str, msg: &str) -> String {
    if is_tty {
        format!("\x1b[1;31merror[{}]\x1b[0m\x1b[1m: {}\x1b[0m\n", code, msg)
    } else {
        format!("error[{}]: {}\n", code, msg)
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
