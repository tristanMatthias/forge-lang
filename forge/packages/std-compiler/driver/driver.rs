use crate::codegen::Codegen;
use crate::driver::profile::{BuildProfile, count_functions};
use crate::errors::{CompileError, DiagnosticBag};
use crate::features::components::expand::{ComponentExpander, ExpansionResult};
use crate::parser::ast::TypeExpr;
use crate::lexer::Lexer;
use crate::parser::ast::{ComponentBlockDecl, ComponentTemplateDef, Expr, Program, Statement};
use crate::parser::{ComponentMeta, Parser};
use crate::package::{self, PackageInfo};
use crate::features::modules::types::{ExportedSymbol, ResolvedImport};
use crate::features::modules::resolver::{collect_exports, resolve_mod_tree, resolve_use_statements};
use crate::features::modules::project::ForgeProject;

use inkwell::context::Context;
use inkwell::OptimizationLevel;
use std::collections::HashMap;
use std::path::{Path, PathBuf};
use std::process::Command;
use std::sync::Mutex;
use std::time::Instant;

/// Global mutex for stdout capture — only one thread can redirect fd 1 at a time.
static STDOUT_CAPTURE_LOCK: Mutex<()> = Mutex::new(());

/// Accumulated results from component expansion
struct ComponentExpansionResult {
    pub static_methods: Vec<(String, String, String)>,
    pub component_methods: Vec<crate::features::components::expand::ComponentMethodInfo>,
    pub component_types: Vec<(String, TypeExpr)>,
    pub startup_stmts: Vec<Statement>,
    pub main_end_stmts: Vec<Statement>,
}

pub struct Driver {
    pub emit_ir: bool,
    pub emit_ast: bool,
    pub optimization: OptLevel,
    pub output: Option<PathBuf>,
    pub error_format: ErrorFormat,
    pub max_errors: usize,
    pub profile: bool,
    pub profile_format: String,
    pub autofix: bool,
}

#[derive(Clone, Copy, PartialEq)]
pub enum OptLevel {
    Dev,
    Release,
}

#[derive(Clone, Copy, PartialEq)]
pub enum ErrorFormat {
    Human,
    Json,
}

impl Driver {
    pub fn new() -> Self {
        Self {
            emit_ir: false,
            emit_ast: false,
            optimization: OptLevel::Release,
            output: None,
            error_format: ErrorFormat::Human,
            max_errors: 20,
            profile: false,
            profile_format: "human".to_string(),
            autofix: false,
        }
    }

    /// Shared frontend pipeline: source → lex → parse → expand → typecheck → codegen.
    /// Calls `action` with the Codegen result, loaded packages, and build profile.
    /// This is the single source of truth for the compilation pipeline — used by both
    /// `compile()` (AOT) and `run_jit()` (JIT).
    fn with_compiled_module<T, F>(
        &self,
        source_path: &Path,
        action: F,
    ) -> Result<T, CompileError>
    where
        F: FnOnce(&Codegen<'_>, &[PackageInfo], &mut BuildProfile) -> Result<T, CompileError>,
    {
        let mut bp = BuildProfile::new();

        let source = std::fs::read_to_string(source_path)
            .map_err(|e| CompileError::FileNotFound {
                path: source_path.display().to_string(),
                detail: e.to_string(),
            })?;

        let filename = source_path.to_str().unwrap_or("<unknown>");

        // 1. Lex
        let t = Instant::now();
        let mut lexer = Lexer::new(&source);
        let tokens = lexer.tokenize();

        let mut diag_bag = DiagnosticBag::new();
        for d in lexer.diagnostics() {
            diag_bag.report(d.clone());
        }
        bp.add("lex", t.elapsed());

        self.check_diagnostics(&diag_bag, &source, filename, "lexer")?;

        // 2. Pre-scan tokens for package uses
        let package_uses = prescan_package_uses(&tokens);

        // 3. Load packages → get component_metas, extern_fns
        let t = Instant::now();
        let loaded_packages = self.load_packages_by_uses(&package_uses)?;
        bp.add("packages", t.elapsed());

        // Build component registry from package metas
        let component_registry = build_component_registry(&loaded_packages);

        // 4. Parse with component registry
        let t = Instant::now();
        let mut parser = if component_registry.is_empty() {
            Parser::new(tokens)
        } else {
            Parser::new_with_components(tokens, component_registry.clone())
        };
        let mut program = parser.parse_program();

        for d in parser.diagnostics() {
            diag_bag.report(d.clone());
        }
        bp.add("parse", t.elapsed());

        self.check_diagnostics(&diag_bag, &source, filename, "parser")?;

        // emit_ast is handled in compile() before calling this method

        // 5. Resolve module tree from `mod` declarations (Rust-style)
        let mut seen = std::collections::HashSet::new();
        let local_modules = resolve_mod_tree(&program, source_path, "", &mut seen, &component_registry)?;

        // Resolve which symbols are imported from local modules
        let mut module_exports: HashMap<String, Vec<ExportedSymbol>> = HashMap::new();
        for (module_path, _file_path, _source, mod_program) in &local_modules {
            let exports = collect_exports(mod_program);
            module_exports.insert(module_path.clone(), exports);
        }

        // Bubble sub-module exports up to parent modules.
        // E.g., exports from "commands.build" become available via "commands".
        // This allows `use commands.{build}` to find exports from commands/build.fg.
        let paths: Vec<String> = module_exports.keys().cloned().collect();
        for path in &paths {
            if let Some(dot_pos) = path.rfind('.') {
                let parent = &path[..dot_pos];
                if let Some(child_exports) = module_exports.get(path).cloned() {
                    module_exports.entry(parent.to_string())
                        .or_default()
                        .extend(child_exports);
                }
            }
        }
        let local_imports = resolve_use_statements(&program, &module_exports)
            .map_err(|e| CompileError::CliError { message: e, help: None })?;

        // Inject only explicitly imported functions into the main program.
        // Module functions are NOT globally accessible — they must be imported via `use`.
        for imp in &local_imports {
            if let ExportedSymbol::Function { name, params, return_type, .. } = &imp.symbol {
                // Find the function body in the module tree
                for (_module_name, _file_path, _source, mod_program) in &local_modules {
                    for stmt in &mod_program.statements {
                        let found = match stmt {
                            Statement::FnDecl { name: fn_name, body, span, type_params, .. } if fn_name == name => {
                                Some((type_params.clone(), body.clone(), *span))
                            }
                            Statement::Feature(fe) if fe.feature_id == "functions" && fe.kind == "FnDecl" => {
                                use crate::feature_data;
                                use crate::features::functions::types::FnDeclData;
                                if let Some(data) = feature_data!(fe, FnDeclData) {
                                    if &data.name == name {
                                        Some((data.type_params.clone(), data.body.clone(), fe.span))
                                    } else {
                                        None
                                    }
                                } else {
                                    None
                                }
                            }
                            _ => None,
                        };
                        if let Some((type_params, body, span)) = found {
                            program.statements.insert(0, Statement::FnDecl {
                                name: imp.local_name.clone(),
                                type_params,
                                params: params.clone(),
                                return_type: return_type.clone(),
                                body,
                                exported: false,
                                span,
                            });
                            break;
                        }
                    }
                }
            }
        }

        // 6. Inject explicitly imported component blocks into parent component bodies
        inject_imported_components(&mut program, &local_imports);

        // 7. Inject extern fns and exported fns from packages
        inject_extern_fns(&mut program, &loaded_packages);
        inject_exported_fns(&mut program, &loaded_packages);

        // 8. Expand all ComponentBlock nodes → regular AST + lifecycle stmts
        let t = Instant::now();
        let expansion = expand_components(&mut program, &loaded_packages);
        inject_lifecycle_stmts(&mut program, &expansion.startup_stmts, &expansion.main_end_stmts);
        bp.add("expand", t.elapsed());

        bp.fn_count = count_functions(&program);

        // 8. Type check
        let t = Instant::now();
        let mut checker = crate::typeck::TypeChecker::new();
        // Register component types and instances with known methods for type checking
        {
            use std::collections::HashMap;
            // Group methods by component kind (type-level) and instance name
            let mut kind_methods: HashMap<String, Vec<(String, crate::typeck::types::Type)>> = HashMap::new();
            let mut instance_methods: HashMap<String, Vec<(String, crate::typeck::types::Type)>> = HashMap::new();
            for cm in &expansion.component_methods {
                let ret_ty = cm.return_type.as_ref()
                    .map(|t| checker.resolve_type_expr(t))
                    .unwrap_or(crate::typeck::types::Type::Void);
                instance_methods.entry(cm.instance_name.clone())
                    .or_default()
                    .push((cm.method_name.clone(), ret_ty.clone()));
                let kind = capitalize_first(&cm.component_kind);
                kind_methods.entry(kind)
                    .or_default()
                    .push((cm.method_name.clone(), ret_ty));
            }
            // Register component struct types (e.g., Queue, Cli)
            for (kind, type_expr) in &expansion.component_types {
                let ty = checker.resolve_type_expr(type_expr);
                // Ensure the struct type preserves its name for method resolution
                let ty = match ty {
                    crate::typeck::types::Type::Struct { fields, .. } => {
                        crate::typeck::types::Type::Struct { name: Some(kind.clone()), fields }
                    }
                    other => other,
                };
                checker.env.type_aliases.insert(kind.clone(), ty);
                if let Some(methods) = kind_methods.get(kind) {
                    // Deduplicate methods for the type
                    let mut deduped: Vec<(String, crate::typeck::types::Type)> = Vec::new();
                    for (name, ret) in methods {
                        if !deduped.iter().any(|(n, _)| n == name) {
                            deduped.push((name.clone(), ret.clone()));
                        }
                    }
                    checker.env.type_methods.insert(kind.clone(), deduped);
                }
            }
            // Register instance names with their methods and as typed variables
            // Build instance→kind mapping from component_methods
            let mut instance_kinds: HashMap<String, String> = HashMap::new();
            for cm in &expansion.component_methods {
                instance_kinds.entry(cm.instance_name.clone())
                    .or_insert_with(|| capitalize_first(&cm.component_kind));
            }
            for (instance_name, methods) in &instance_methods {
                checker.env.type_methods.insert(instance_name.clone(), methods.clone());
                checker.env.namespaces.insert(instance_name.clone());
                // Define as typed variable so it can be passed to functions
                if let Some(kind) = instance_kinds.get(instance_name) {
                    let ty = checker.env.resolve_type_name(kind);
                    if !matches!(ty, crate::typeck::types::Type::Error) {
                        checker.env.define(instance_name.clone(), ty, false);
                    }
                }
            }
        }
        // Keep namespace registration for instances without component_methods (fallback)
        for (type_name, _, _) in &expansion.static_methods {
            checker.env.namespaces.insert(type_name.clone());
        }
        // Register imported symbols so the type checker knows about them
        for imp in &local_imports {
            match &imp.symbol {
                ExportedSymbol::Function { params, return_type, .. } => {
                    let param_types: Vec<crate::typeck::types::Type> = params.iter()
                        .map(|p| {
                            p.type_ann.as_ref()
                                .map(|t| checker.resolve_type_expr(t))
                                .unwrap_or(crate::typeck::types::Type::Unknown)
                        })
                        .collect();
                    let ret = return_type.as_ref()
                        .map(|r| checker.resolve_type_expr(r))
                        .unwrap_or(crate::typeck::types::Type::Void);
                    checker.env.define(imp.local_name.clone(),
                        crate::typeck::types::Type::Function { params: param_types, return_type: Box::new(ret) }, false);
                }
                ExportedSymbol::Value { type_ann, value, .. } => {
                    let ty = type_ann.as_ref()
                        .map(|t| checker.resolve_type_expr(t))
                        .unwrap_or_else(|| checker.infer_type(value));
                    checker.env.define(imp.local_name.clone(), ty, false);
                }
                ExportedSymbol::ComponentBlock { .. } => {
                    // Already injected into AST; expansion handles type registration
                }
            }
        }
        register_package_annotations(&mut checker, &loaded_packages);
        checker.check_program(&program);
        for d in &checker.diagnostics {
            diag_bag.report(d.clone());
        }
        bp.add("typeck", t.elapsed());

        self.check_diagnostics(&diag_bag, &source, filename, "type checker")?;

        // 9. Codegen
        let t = Instant::now();
        let context = Context::create();
        let module_name = source_path
            .file_stem()
            .and_then(|s| s.to_str())
            .unwrap_or("module");

        let mut codegen = Codegen::new(&context, module_name);
        codegen.source_file = filename.to_string();

        // Populate static methods registry from packages
        for (type_name, method_name, fn_name) in &expansion.static_methods {
            codegen.static_methods.insert(
                (type_name.clone(), method_name.clone()),
                fn_name.clone(),
            );
        }
        for pkg in &loaded_packages {
            let prefix = format!("forge_{}_", pkg.name);
            for extern_fn in &pkg.extern_fns {
                if let Statement::ExternFn { name, .. } = extern_fn {
                    if let Some(method_name) = name.strip_prefix(&prefix) {
                        codegen.static_methods.insert(
                            (pkg.name.clone(), method_name.to_string()),
                            name.clone(),
                        );
                    }
                }
            }
        }
        for pkg in &loaded_packages {
            for fn_stmt in &pkg.exported_fns {
                if let Statement::FnDecl { name, .. } = fn_stmt {
                    let full_name = format!("{}_{}", pkg.name, name);
                    codegen.static_methods.insert(
                        (pkg.name.clone(), name.clone()),
                        full_name,
                    );
                }
            }
        }

        // Inject import aliases for local imports (maps local_name → mangled_name)
        codegen.inject_imports(&local_imports);

        codegen.compile_program(&program);
        bp.add("codegen", t.elapsed());

        // Hand off to the action (AOT write+link or JIT execute)
        action(&codegen, &loaded_packages, &mut bp)
    }

    /// Compile a single .fg file to a binary (AOT path).
    pub fn compile(&self, source_path: &Path) -> Result<PathBuf, CompileError> {
        // Handle emit_ast early — it needs special treatment
        if self.emit_ast {
            let source = std::fs::read_to_string(source_path)
                .map_err(|e| CompileError::FileNotFound {
                    path: source_path.display().to_string(),
                    detail: e.to_string(),
                })?;
            let mut lexer = Lexer::new(&source);
            let tokens = lexer.tokenize();
            let mut parser = Parser::new(tokens);
            let program = parser.parse_program();
            println!("{:#?}", program);
            return Ok(PathBuf::new());
        }

        self.with_compiled_module(source_path, |codegen, loaded_packages, bp| {
            if self.emit_ir {
                println!("{}", codegen.emit_ir());
                return Ok(PathBuf::new());
            }

            // Determine output path
            let output_path = self.output.clone().unwrap_or_else(|| {
                let stem = source_path
                    .file_stem()
                    .and_then(|s| s.to_str())
                    .unwrap_or("output");
                PathBuf::from(stem)
            });

            // Write object file
            let t = Instant::now();
            let obj_path = output_path.with_extension("o");
            codegen.write_object_file(&obj_path)?;
            bp.add("object", t.elapsed());

            // Compile runtime
            let t = Instant::now();
            let runtime_obj = self.compile_runtime(source_path)?;
            bp.add("runtime", t.elapsed());

            // Collect package native lib paths
            let package_lib_paths: Vec<PathBuf> = loaded_packages
                .iter()
                .filter(|p| p.lib_path.exists())
                .map(|p| p.lib_path.clone())
                .collect();

            // Link
            let t = Instant::now();
            self.link_with_packages(&obj_path, &runtime_obj, &output_path, &package_lib_paths)?;
            bp.add("link", t.elapsed());

            // Cleanup
            std::fs::remove_file(&obj_path).ok();

            // Get binary size
            if let Ok(meta) = std::fs::metadata(&output_path) {
                bp.binary_size = meta.len();
            }

            self.emit_profile(bp);

            Ok(output_path)
        })
    }

    /// JIT-compile and execute a Forge program in-process (no linking, no binary on disk).
    /// Loads package .dylib files with RTLD_GLOBAL so JIT can resolve their symbols.
    /// Falls back to AOT only if a package has no .dylib (only .a).
    pub fn run_jit(&self, source_path: &Path) -> Result<i32, CompileError> {
        self.with_compiled_module(source_path, |codegen, loaded_packages, bp| {
            // Check if any package has a native lib but no dylib — must fall back to AOT
            let needs_aot = loaded_packages.iter().any(|p| {
                p.lib_path.exists() && !p.dylib_path.exists()
            });
            if needs_aot {
                // Avoid double compilation: go directly to AOT
                return self.run_aot(source_path);
            }

            // Load runtime as shared library with RTLD_GLOBAL so JIT can resolve symbols
            let t = Instant::now();
            let runtime_dylib = self.compile_runtime_dylib(source_path)?;

            // Keep all loaded libraries alive until after JIT execution
            let mut _loaded_libs: Vec<libloading::os::unix::Library> = Vec::new();

            let runtime_lib = unsafe {
                libloading::os::unix::Library::open(
                    Some(&runtime_dylib),
                    libloading::os::unix::RTLD_LAZY | libloading::os::unix::RTLD_GLOBAL,
                )
            }.map_err(|e| CompileError::JitFailed {
                detail: format!("failed to load runtime library: {}", e),
            })?;
            _loaded_libs.push(runtime_lib);
            bp.add("runtime", t.elapsed());

            // Load package dylibs with RTLD_GLOBAL
            let t = Instant::now();
            for pkg in loaded_packages {
                if pkg.dylib_path.exists() {
                    let lib = unsafe {
                        libloading::os::unix::Library::open(
                            Some(&pkg.dylib_path),
                            libloading::os::unix::RTLD_LAZY | libloading::os::unix::RTLD_GLOBAL,
                        )
                    }.map_err(|e| CompileError::JitFailed {
                        detail: format!("failed to load package '{}' dylib: {}", pkg.name, e),
                    })?;
                    _loaded_libs.push(lib);
                }
            }
            bp.add("packages_load", t.elapsed());

            // Verify module
            if let Err(msg) = codegen.module.verify() {
                return Err(CompileError::CodegenFailed {
                    stage: "LLVM module verification",
                    detail: msg.to_string(),
                });
            }

            // Create JIT execution engine
            let t = Instant::now();
            let opt = match self.optimization {
                OptLevel::Dev => OptimizationLevel::None,
                OptLevel::Release => OptimizationLevel::Default,
            };
            let ee = codegen.module
                .create_jit_execution_engine(opt)
                .map_err(|e| CompileError::JitFailed {
                    detail: format!("failed to create JIT engine: {}", e.to_string()),
                })?;
            bp.add("jit_init", t.elapsed());

            // Find main()
            let main_fn = ee.get_function_value("main")
                .map_err(|_| CompileError::JitFailed {
                    detail: "no main function found — add `fn main() { ... }` or use top-level statements".to_string(),
                })?;

            self.emit_profile(bp);

            // Execute main() in-process
            let exit_code = unsafe { ee.run_function_as_main(main_fn, &[]) };

            Ok(exit_code)
        })
    }

    /// AOT fallback for run: compile to binary, execute, cleanup.
    fn run_aot(&self, source_path: &Path) -> Result<i32, CompileError> {
        let output = std::env::temp_dir().join(format!("forge_run_{}", std::process::id()));
        // Create a temporary driver with output set
        let mut aot_driver = Driver::new();
        aot_driver.optimization = self.optimization;
        aot_driver.output = Some(output.clone());
        aot_driver.profile = self.profile;
        aot_driver.profile_format = self.profile_format.clone();

        let binary = aot_driver.compile(source_path)?;

        let status = std::process::Command::new(&binary)
            .status()
            .map_err(|e| CompileError::BinaryRunFailed {
                path: binary.display().to_string(),
                detail: e.to_string(),
            })?;

        std::fs::remove_file(&binary).ok();
        Ok(status.code().unwrap_or(1))
    }

    /// JIT-compile and execute, capturing stdout. Returns (exit_code, captured_stdout).
    /// Uses pipe/dup2 to redirect fd 1, protected by a global mutex.
    pub fn run_jit_captured(&self, source_path: &Path) -> Result<(i32, String), CompileError> {
        use std::io::Read as _;
        use std::os::unix::io::FromRawFd;

        extern "C" {
            fn pipe(pipefd: *mut i32) -> i32;
            fn dup(fd: i32) -> i32;
            fn dup2(oldfd: i32, newfd: i32) -> i32;
            fn close(fd: i32) -> i32;
            fn fflush(stream: *mut std::ffi::c_void) -> i32;
        }
        // NULL pointer = fflush all streams
        const STDOUT_FD: i32 = 1;

        let _lock = STDOUT_CAPTURE_LOCK.lock().unwrap();

        // Create pipe
        let mut pipefd: [i32; 2] = [0; 2];
        if unsafe { pipe(pipefd.as_mut_ptr()) } != 0 {
            return Err(CompileError::JitFailed {
                detail: "failed to create pipe for stdout capture".to_string(),
            });
        }
        let (read_fd, write_fd) = (pipefd[0], pipefd[1]);

        // Flush existing stdout buffers (both Rust and C)
        let _ = std::io::Write::flush(&mut std::io::stdout());
        unsafe { fflush(std::ptr::null_mut()); }

        // Save original stdout, redirect to pipe
        let saved_stdout = unsafe { dup(STDOUT_FD) };
        unsafe { dup2(write_fd, STDOUT_FD); }
        unsafe { close(write_fd); }

        // Run JIT
        let result = self.run_jit(source_path);

        // Flush and restore stdout
        let _ = std::io::Write::flush(&mut std::io::stdout());
        unsafe { fflush(std::ptr::null_mut()); }
        unsafe { dup2(saved_stdout, STDOUT_FD); }
        unsafe { close(saved_stdout); }

        // Read captured output from pipe (non-blocking: close write end already done)
        let mut captured = String::new();
        let mut file = unsafe { std::fs::File::from_raw_fd(read_fd) };
        let _ = file.read_to_string(&mut captured);

        match result {
            Ok(exit_code) => Ok((exit_code, captured)),
            Err(e) => Err(e),
        }
    }

    /// Type-check only, capturing diagnostics. Returns Err with rendered error text on failure.
    pub fn check_captured(&self, source_path: &Path) -> Result<(), String> {
        let source = match std::fs::read_to_string(source_path) {
            Ok(s) => s,
            Err(e) => return Err(format!("cannot read file: {}", e)),
        };

        let filename = source_path.to_str().unwrap_or("<unknown>");

        let mut lexer = Lexer::new(&source);
        let tokens = lexer.tokenize();

        let mut diag_bag = DiagnosticBag::new();
        for d in lexer.diagnostics() {
            diag_bag.report(d.clone());
        }

        let mut parser = Parser::new(tokens);
        let program = parser.parse_program();

        for d in parser.diagnostics() {
            diag_bag.report(d.clone());
        }

        let mut checker = crate::typeck::TypeChecker::new();
        checker.check_program(&program);
        for d in &checker.diagnostics {
            diag_bag.report(d.clone());
        }

        if diag_bag.has_errors() {
            let mut buf = Vec::new();
            diag_bag.print_to_limited(&mut buf, &source, filename, self.max_errors);
            let rendered = String::from_utf8_lossy(&buf).to_string();
            return Err(rendered);
        }

        Ok(())
    }

    /// Compile a project directory containing forge.toml
    pub fn compile_project(&self, project_dir: &Path) -> Result<PathBuf, CompileError> {
        let project = ForgeProject::load(project_dir)?;

        // Build a driver with project name as default output,
        // then delegate to the single-file path (handles packages, modules, etc.)
        let driver = Driver {
            output: Some(self.output.clone().unwrap_or_else(|| {
                PathBuf::from(&project.config.project.name)
            })),
            emit_ir: self.emit_ir,
            emit_ast: self.emit_ast,
            optimization: self.optimization,
            error_format: self.error_format,
            max_errors: self.max_errors,
            profile: self.profile,
            profile_format: self.profile_format.clone(),
            autofix: self.autofix,
        };

        driver.compile(&project.entry_file)
    }

    pub fn check(&self, source_path: &Path) -> Result<(), CompileError> {
        let source = std::fs::read_to_string(source_path)
            .map_err(|e| CompileError::FileNotFound {
                path: source_path.display().to_string(),
                detail: e.to_string(),
            })?;

        let filename = source_path.to_str().unwrap_or("<unknown>");

        let mut lexer = Lexer::new(&source);
        let tokens = lexer.tokenize();

        let mut diag_bag = DiagnosticBag::new();
        for d in lexer.diagnostics() {
            diag_bag.report(d.clone());
        }

        self.check_diagnostics(&diag_bag, &source, filename, "lexer")?;

        // Pre-scan tokens for package uses
        let package_uses = prescan_package_uses(&tokens);

        // Load packages
        let loaded_packages = self.load_packages_by_uses(&package_uses)?;

        // Build component registry from package metas
        let component_registry = build_component_registry(&loaded_packages);

        // Parse with component registry
        let mut parser = if component_registry.is_empty() {
            Parser::new(tokens)
        } else {
            Parser::new_with_components(tokens, component_registry)
        };
        let mut program = parser.parse_program();

        for d in parser.diagnostics() {
            diag_bag.report(d.clone());
        }

        self.check_diagnostics(&diag_bag, &source, filename, "parser")?;

        // Inject extern fns and exported fns from packages
        inject_extern_fns(&mut program, &loaded_packages);
        inject_exported_fns(&mut program, &loaded_packages);

        // Expand all ComponentBlock nodes → regular AST + lifecycle stmts
        let expansion = expand_components(&mut program, &loaded_packages);
        inject_lifecycle_stmts(&mut program, &expansion.startup_stmts, &expansion.main_end_stmts);

        // Type check
        let mut checker = crate::typeck::TypeChecker::new();
        // Register component types and instances with known methods for type checking
        {
            use std::collections::HashMap;
            let mut kind_methods: HashMap<String, Vec<(String, crate::typeck::types::Type)>> = HashMap::new();
            let mut instance_methods: HashMap<String, Vec<(String, crate::typeck::types::Type)>> = HashMap::new();
            for cm in &expansion.component_methods {
                let ret_ty = cm.return_type.as_ref()
                    .map(|t| checker.resolve_type_expr(t))
                    .unwrap_or(crate::typeck::types::Type::Void);
                instance_methods.entry(cm.instance_name.clone())
                    .or_default()
                    .push((cm.method_name.clone(), ret_ty.clone()));
                let kind = capitalize_first(&cm.component_kind);
                kind_methods.entry(kind)
                    .or_default()
                    .push((cm.method_name.clone(), ret_ty));
            }
            for (kind, type_expr) in &expansion.component_types {
                let ty = checker.resolve_type_expr(type_expr);
                let ty = match ty {
                    crate::typeck::types::Type::Struct { fields, .. } => {
                        crate::typeck::types::Type::Struct { name: Some(kind.clone()), fields }
                    }
                    other => other,
                };
                checker.env.type_aliases.insert(kind.clone(), ty);
                if let Some(methods) = kind_methods.get(kind) {
                    let mut deduped: Vec<(String, crate::typeck::types::Type)> = Vec::new();
                    for (name, ret) in methods {
                        if !deduped.iter().any(|(n, _)| n == name) {
                            deduped.push((name.clone(), ret.clone()));
                        }
                    }
                    checker.env.type_methods.insert(kind.clone(), deduped);
                }
            }
            let mut instance_kinds: HashMap<String, String> = HashMap::new();
            for cm in &expansion.component_methods {
                instance_kinds.entry(cm.instance_name.clone())
                    .or_insert_with(|| capitalize_first(&cm.component_kind));
            }
            for (instance_name, methods) in &instance_methods {
                checker.env.type_methods.insert(instance_name.clone(), methods.clone());
                checker.env.namespaces.insert(instance_name.clone());
                if let Some(kind) = instance_kinds.get(instance_name) {
                    let ty = checker.env.resolve_type_name(kind);
                    if !matches!(ty, crate::typeck::types::Type::Error) {
                        checker.env.define(instance_name.clone(), ty, false);
                    }
                }
            }
        }
        for (type_name, _, _) in &expansion.static_methods {
            checker.env.namespaces.insert(type_name.clone());
        }
        register_package_annotations(&mut checker, &loaded_packages);
        checker.check_program(&program);
        for d in &checker.diagnostics {
            diag_bag.report(d.clone());
        }

        if diag_bag.has_errors() {
            // If autofix is enabled, try to apply high-confidence fixes
            if self.autofix {
                let diagnostics: Vec<_> = diag_bag.diagnostics.clone();
                let (fixed_source, applied, skipped) =
                    crate::errors::autofix::apply_fixes(&source, &diagnostics, 0.9);

                if applied > 0 {
                    // Write the fixed source back
                    std::fs::write(source_path, &fixed_source)
                        .map_err(|e| CompileError::FileNotFound {
                            path: source_path.display().to_string(),
                            detail: e.to_string(),
                        })?;
                    // Info message — not an error, but still uses consistent formatting
                    eprint!("\x1b[1;32mautofix\x1b[0m: applied {} fix(es), skipped {} low-confidence\n", applied, skipped);

                    // Re-check to verify and show remaining errors
                    return self.check(source_path);
                } else {
                    eprint!("\x1b[1;33mautofix\x1b[0m: no high-confidence fixes available\n");
                }
            }

            self.emit_diagnostics(&diag_bag, &source, filename);
            return Err(CompileError::DiagnosticErrors { stage: "type checker" });
        }

        // Print warnings even when no errors
        if diag_bag.warning_count() > 0 {
            self.emit_diagnostics(&diag_bag, &source, filename);
        }

        println!("No errors found.");
        Ok(())
    }

    pub fn explain_line(&self, source_path: &Path, target_line: u32) -> Result<(), CompileError> {
        let source = std::fs::read_to_string(source_path)
            .map_err(|e| CompileError::FileNotFound {
                path: source_path.display().to_string(),
                detail: e.to_string(),
            })?;

        let mut lexer = Lexer::new(&source);
        let tokens = lexer.tokenize();
        let mut parser = Parser::new(tokens);
        let program = parser.parse_program();

        // Type check to populate the environment
        let mut checker = crate::typeck::TypeChecker::new();
        checker.check_program(&program);

        // Find statements on the target line
        let mut found = false;
        for stmt in &program.statements {
            match stmt {
                Statement::Let { name, type_ann, value, span, .. }
                | Statement::Mut { name, type_ann, value, span, .. }
                | Statement::Const { name, type_ann, value, span, .. } => {
                    if span.line != target_line {
                        continue;
                    }
                    found = true;
                    let inferred = checker.infer_type(value);
                    let declared = type_ann.as_ref().map(|t| checker.resolve_type_expr(t));
                    println!("  {} : {}", name, declared.as_ref().unwrap_or(&inferred));
                    println!("    inferred from value: {}", inferred);
                    self.explain_expr_type(&mut checker, value, 2);
                    println!();
                }
                Statement::FnDecl { name, params, return_type, span, .. } => {
                    if span.line != target_line {
                        continue;
                    }
                    found = true;
                    let ret_ty = return_type.as_ref()
                        .map(|t| checker.resolve_type_expr(t))
                        .unwrap_or(crate::typeck::types::Type::Void);
                    let param_strs: Vec<String> = params.iter().map(|p| {
                        let ty = p.type_ann.as_ref()
                            .map(|t| checker.resolve_type_expr(t))
                            .unwrap_or(crate::typeck::types::Type::Unknown);
                        format!("{}: {}", p.name, ty)
                    }).collect();
                    println!("  fn {}({}) -> {}", name, param_strs.join(", "), ret_ty);
                    println!();
                }
                _ => {}
            }
        }

        // Also check inside function bodies
        for stmt in &program.statements {
            if let Statement::FnDecl { body, .. } = stmt {
                for inner in &body.statements {
                    match inner {
                        Statement::Let { name, type_ann, value, span, .. }
                        | Statement::Mut { name, type_ann, value, span, .. }
                        | Statement::Const { name, type_ann, value, span, .. } => {
                            if span.line != target_line {
                                continue;
                            }
                            found = true;
                            let inferred = checker.infer_type(value);
                            let declared = type_ann.as_ref().map(|t| checker.resolve_type_expr(t));
                            println!("  {} : {}", name, declared.as_ref().unwrap_or(&inferred));
                            println!("    inferred from value: {}", inferred);
                            self.explain_expr_type(&mut checker, value, 2);
                            println!();
                        }
                        _ => {}
                    }
                }
            }
        }

        if !found {
            println!("No bindings found on line {}", target_line);
        }
        Ok(())
    }

    fn explain_expr_type(&self, checker: &mut crate::typeck::TypeChecker, expr: &crate::parser::ast::Expr, depth: usize) {
        let indent = "    ".repeat(depth);
        match expr {
            Expr::Ident(name, _) => {
                if let Some(info) = checker.env.lookup(name) {
                    println!("{}  {} is {} (variable)", indent, name, info.ty);
                    if let Some(span) = &info.def_span {
                        println!("{}  defined at line {}", indent, span.line);
                    }
                } else if let Some(fn_ty) = checker.env.lookup_function(name) {
                    println!("{}  {} is {} (function)", indent, name, fn_ty);
                }
            }
            Expr::Call { callee, .. } => {
                if let Expr::Ident(fn_name, _) = callee.as_ref() {
                    if let Some(fn_ty) = checker.env.lookup_function(fn_name) {
                        if let crate::typeck::types::Type::Function { return_type, .. } = fn_ty {
                            println!("{}  {}() returns {}", indent, fn_name, return_type);
                            if let Some(span) = checker.env.fn_spans.get(fn_name) {
                                println!("{}  declared at line {}", indent, span.line);
                            }
                        }
                    }
                }
            }
            Expr::Binary { op, left, right, .. } => {
                let left_ty = checker.infer_type(left);
                let right_ty = checker.infer_type(right);
                println!("{}  {:?}({}, {})", indent, op, left_ty, right_ty);
            }
            Expr::MemberAccess { object, field, .. } => {
                let obj_ty = checker.infer_type(object);
                println!("{}  {}.{} on type {}", indent, "expr", field, obj_ty);
            }
            _ => {}
        }
    }

    fn emit_diagnostics(&self, diag_bag: &DiagnosticBag, source: &str, filename: &str) {
        if self.error_format == ErrorFormat::Json {
            diag_bag.print_json();
        } else {
            diag_bag.print_all_limited(source, filename, self.max_errors);
            diag_bag.print_summary();
        }
    }

    /// Check the diagnostic bag for errors, emit them if present, and return a CompileError.
    fn check_diagnostics(&self, diag_bag: &DiagnosticBag, source: &str, filename: &str, stage: &'static str) -> Result<(), CompileError> {
        if diag_bag.has_errors() {
            self.emit_diagnostics(diag_bag, source, filename);
            Err(CompileError::DiagnosticErrors { stage })
        } else {
            Ok(())
        }
    }

    /// Emit the build profile if profiling is enabled.
    fn emit_profile(&self, bp: &BuildProfile) {
        if self.profile {
            if self.profile_format == "json" {
                eprintln!("{}", bp.render_json());
            } else {
                eprintln!("{}", bp.render_human());
            }
        }
    }

    /// Return the cc optimization flag for the current opt level.
    fn opt_flag(&self) -> &'static str {
        match self.optimization {
            OptLevel::Release => "-O2",
            OptLevel::Dev => "-O0",
        }
    }

    /// Return a short tag string for the current opt level (for cache filenames).
    fn opt_tag(&self) -> &'static str {
        match self.optimization {
            OptLevel::Release => "O2",
            OptLevel::Dev => "O0",
        }
    }

    /// Return the cache path for a runtime artifact with the given extension (e.g. "o", "hash", "dylib").
    fn runtime_cache_artifact(&self, ext: &str) -> PathBuf {
        self.runtime_cache_dir().join(format!("forge_runtime_{}.{}", self.opt_tag(), ext))
    }

    /// Find runtime.c in known locations relative to source file, project dir, or forge binary.
    fn find_runtime_src(&self, hint_path: &Path) -> Result<PathBuf, CompileError> {
        let mut paths = vec![
            hint_path.parent().unwrap_or(Path::new(".")).join("../stdlib/runtime.c"),
            hint_path.join("stdlib/runtime.c"),
            hint_path.join("../stdlib/runtime.c"),
            PathBuf::from("stdlib/runtime.c"),
            PathBuf::from("../stdlib/runtime.c"),
        ];
        if let Ok(exe) = std::env::current_exe() {
            if let Some(exe_dir) = exe.parent() {
                paths.push(exe_dir.join("../stdlib/runtime.c"));
                paths.push(exe_dir.join("../../stdlib/runtime.c"));
            }
        }
        paths.iter()
            .find(|p| p.exists())
            .cloned()
            .ok_or(CompileError::RuntimeNotFound)
    }

    fn compile_runtime(&self, source_path: &Path) -> Result<PathBuf, CompileError> {
        let runtime_src = self.find_runtime_src(source_path)?;
        self.compile_runtime_file(&runtime_src)
    }

    /// Compile runtime.c to a shared library (.dylib) for JIT execution.
    /// Cached by content hash, same as the .o path.
    fn compile_runtime_dylib(&self, source_path: &Path) -> Result<PathBuf, CompileError> {
        let runtime_src = self.find_runtime_src(source_path)?;
        let opt_flag = self.opt_flag();

        let dylib_path = self.runtime_cache_artifact("dylib");
        let hash_path = self.runtime_cache_dir().join(format!("forge_runtime_{}_dylib.hash", self.opt_tag()));

        // Check cache
        let current_hash = self.runtime_hash(&runtime_src);
        if dylib_path.exists() && hash_path.exists() {
            if let Ok(stored) = std::fs::read_to_string(&hash_path) {
                if stored.trim() == current_hash {
                    return Ok(dylib_path);
                }
            }
        }

        let src_str = runtime_src.to_str().ok_or_else(|| CompileError::RuntimeCompileFailed {
            stderr: format!("runtime path contains invalid UTF-8: {}", runtime_src.display()),
        })?;
        let dylib_str = dylib_path.to_str().ok_or_else(|| CompileError::RuntimeCompileFailed {
            stderr: "dylib cache path contains invalid UTF-8".to_string(),
        })?;

        let output = Command::new("cc")
            .args(["-dynamiclib", "-o", dylib_str, src_str, opt_flag])
            .output()
            .map_err(|e| CompileError::RuntimeCompileFailed { stderr: e.to_string() })?;

        if !output.status.success() {
            let stderr = String::from_utf8_lossy(&output.stderr).to_string();
            return Err(CompileError::RuntimeCompileFailed { stderr });
        }

        let _ = std::fs::write(&hash_path, &current_hash);
        Ok(dylib_path)
    }

    fn compile_runtime_file(&self, runtime_src: &Path) -> Result<PathBuf, CompileError> {
        let opt_flag = self.opt_flag();

        // Cache key: hash of runtime.c content + opt level
        if let Ok(cached) = self.cached_runtime(runtime_src) {
            return Ok(cached);
        }

        let runtime_obj = self.runtime_cache_artifact("o");

        let src_str = runtime_src.to_str().ok_or_else(|| CompileError::RuntimeCompileFailed {
            stderr: format!("runtime path contains invalid UTF-8: {}", runtime_src.display()),
        })?;
        let obj_str = runtime_obj.to_str().ok_or_else(|| CompileError::RuntimeCompileFailed {
            stderr: format!("runtime object path contains invalid UTF-8: {}", runtime_obj.display()),
        })?;

        let output = Command::new("cc")
            .args(["-c", src_str, "-o", obj_str, opt_flag])
            .output()
            .map_err(|e| CompileError::RuntimeCompileFailed { stderr: e.to_string() })?;

        if !output.status.success() {
            let stderr = String::from_utf8_lossy(&output.stderr).to_string();
            return Err(CompileError::RuntimeCompileFailed { stderr });
        }

        // Write hash marker so we can validate the cache next time
        let _ = std::fs::write(self.runtime_cache_artifact("hash"), self.runtime_hash(runtime_src));

        Ok(runtime_obj)
    }

    fn runtime_hash(&self, runtime_src: &Path) -> String {
        use std::collections::hash_map::DefaultHasher;
        use std::hash::{Hash, Hasher};
        let content = std::fs::read(runtime_src).unwrap_or_default();
        let mut hasher = DefaultHasher::new();
        content.hash(&mut hasher);
        format!("{:016x}", hasher.finish())
    }

    fn runtime_cache_dir(&self) -> PathBuf {
        let dir = std::env::temp_dir().join("forge_cache");
        let _ = std::fs::create_dir_all(&dir);
        dir
    }

    fn cached_runtime(&self, runtime_src: &Path) -> Result<PathBuf, ()> {
        let obj_path = self.runtime_cache_artifact("o");
        let hash_path = self.runtime_cache_artifact("hash");

        if !obj_path.exists() || !hash_path.exists() {
            return Err(());
        }

        let stored_hash = std::fs::read_to_string(&hash_path).map_err(|_| ())?;
        let current_hash = self.runtime_hash(runtime_src);

        if stored_hash.trim() == current_hash {
            Ok(obj_path)
        } else {
            Err(())
        }
    }

    fn link_with_packages(
        &self,
        obj: &Path,
        runtime_obj: &Path,
        output: &Path,
        package_lib_paths: &[PathBuf],
    ) -> Result<(), CompileError> {
        let path_str = |p: &Path| -> Result<String, CompileError> {
            p.to_str().map(|s| s.to_string()).ok_or_else(|| CompileError::LinkerFailed {
                stderr: format!("path contains invalid UTF-8: {}", p.display()),
            })
        };

        let mut args = vec![
            path_str(obj)?,
            path_str(runtime_obj)?,
            "-o".to_string(),
            path_str(output)?,
        ];

        // Add package native library paths
        let mut has_native_packages = false;
        for lib_path in package_lib_paths {
            args.push(path_str(lib_path)?);
            has_native_packages = true;
        }

        // On macOS, we need to link system frameworks for the Rust static libs
        if has_native_packages {
            args.push("-framework".to_string());
            args.push("CoreFoundation".to_string());
            args.push("-framework".to_string());
            args.push("Security".to_string());
            args.push("-liconv".to_string());
            args.push("-lSystem".to_string());
            args.push("-lm".to_string());
        }

        let args_str: Vec<&str> = args.iter().map(|s| s.as_str()).collect();
        let output_cmd = Command::new("cc")
            .args(&args_str)
            .output()
            .map_err(|e| CompileError::LinkerFailed { stderr: e.to_string() })?;

        if !output_cmd.status.success() {
            let stderr = String::from_utf8_lossy(&output_cmd.stderr).to_string();
            return Err(CompileError::from_linker_stderr(&stderr));
        }

        Ok(())
    }

    /// Load packages by pre-scanned (namespace, name) pairs.
    /// Returns an error if any package fails to load — never silently ignores failures.
    fn load_packages_by_uses(&self, uses: &[(String, String)]) -> Result<Vec<PackageInfo>, CompileError> {
        let mut packages = Vec::new();
        let packages_base = match self.find_packages_dir() {
            Some(base) => base,
            None => return Ok(packages),
        };

        for (namespace, name) in uses {
            match package::find_package(&packages_base, namespace, name) {
                Some(package_dir) => {
                    let info = package::load_package(&package_dir)
                        .map_err(|e| CompileError::PackageLoadFailed {
                            package: format!("@{}.{}", namespace, name),
                            detail: e,
                        })?;
                    packages.push(info);
                }
                None => {
                    // Package directory doesn't exist — this is an error, not a warning
                    return Err(CompileError::PackageNotFound {
                        namespace: namespace.clone(),
                        name: name.clone(),
                    });
                }
            }
        }

        Ok(packages)
    }

    /// Find the packages directory relative to the forge binary or source tree
    fn find_packages_dir(&self) -> Option<PathBuf> {
        // Check relative to the cargo manifest dir (for development)
        let candidates = vec![
            PathBuf::from("packages"),
            PathBuf::from("../packages"),
        ];

        // Also check relative to the forge binary
        if let Ok(exe) = std::env::current_exe() {
            if let Some(exe_dir) = exe.parent() {
                let mut extra = vec![
                    exe_dir.join("../packages"),
                    exe_dir.join("../../packages"),
                    exe_dir.join("../../../packages"),
                ];
                // For cargo builds, binary is in target/debug/ or target/release/
                extra.push(exe_dir.join("../../packages"));
                for p in extra {
                    if p.exists() {
                        return Some(p);
                    }
                }
            }
        }

        for p in candidates {
            if p.exists() {
                return Some(p);
            }
        }

        None
    }
}

/// Pre-scan tokens for `use @namespace.name` patterns to determine which packages to load
/// before full parsing. This allows the parser to use component registries from packages.
fn prescan_package_uses(tokens: &[crate::lexer::Token]) -> Vec<(String, String)> {
    use crate::lexer::token::TokenKind;
    let mut uses = Vec::new();
    let mut i = 0;
    while i < tokens.len() {
        if matches!(tokens[i].kind, TokenKind::Use) {
            // Look for @ namespace . name pattern
            // The lexer tokenizes @ as At, then namespace as Ident
            let mut j = i + 1;
            // Skip whitespace/newlines
            while j < tokens.len() && matches!(tokens[j].kind, TokenKind::Newline) {
                j += 1;
            }
            // Check for @ token
            if j < tokens.len() && matches!(tokens[j].kind, TokenKind::At) {
                j += 1;
                if j < tokens.len() {
                    if let TokenKind::Ident(ref namespace) = tokens[j].kind {
                        let namespace = namespace.clone();
                        j += 1;
                        // Look for . name
                        if j < tokens.len() && matches!(tokens[j].kind, TokenKind::Dot) {
                            j += 1;
                            if j < tokens.len() {
                                if let TokenKind::Ident(ref package_name) = tokens[j].kind {
                                    uses.push((namespace.clone(), package_name.clone()));
                                }
                            }
                        }
                    }
                }
            }
            // Also handle the case where the parser might see Ident("@std")
            // (shouldn't happen with standard lexer, but just in case)
            else if j < tokens.len() {
                if let TokenKind::Ident(ref name) = tokens[j].kind {
                    if name.starts_with('@') {
                        let namespace = name.trim_start_matches('@').to_string();
                        j += 1;
                        if j < tokens.len() && matches!(tokens[j].kind, TokenKind::Dot) {
                            j += 1;
                            if j < tokens.len() {
                                if let TokenKind::Ident(ref package_name) = tokens[j].kind {
                                    uses.push((namespace, package_name.clone()));
                                }
                            }
                        }
                    }
                }
            }
        }
        i += 1;
    }
    uses
}

/// Build a component registry from loaded packages' component metas
fn build_component_registry(packages: &[PackageInfo]) -> HashMap<String, ComponentMeta> {
    let mut registry = HashMap::new();
    for pkg in packages {
        for meta in &pkg.component_metas {
            registry.insert(meta.name.clone(), meta.clone());
        }
    }
    registry
}

/// Inject explicitly imported component blocks into parent component bodies.
///
/// When a component body contains a config entry whose key matches an imported
/// component block name, the config entry is replaced with the actual component block.
/// E.g., `use commands.{build}` + `cli forge { build }` → injects `build` component.
fn inject_imported_components(
    program: &mut Program,
    imports: &[ResolvedImport],
) {
    // Build map of imported component block names → decls
    let mut imported_components: HashMap<String, ComponentBlockDecl> = HashMap::new();
    for imp in imports {
        if let ExportedSymbol::ComponentBlock { decl, .. } = &imp.symbol {
            imported_components.insert(imp.local_name.clone(), decl.clone());
        }
    }

    if imported_components.is_empty() {
        return;
    }

    // Scan all component blocks for config entries matching imported names
    for stmt in &mut program.statements {
        if let Statement::ComponentBlock(ref mut parent) = stmt {
            inject_components_into_body(&mut parent.body, &imported_components);
        }
    }
}

/// Recursively scan a component body for config entries that match imported component
/// block names, replacing them with the actual component blocks.
fn inject_components_into_body(
    body: &mut crate::parser::ast::ComponentBlockBody,
    imported: &HashMap<String, ComponentBlockDecl>,
) {
    // Find config entries that match imported component names
    let mut matched_names = Vec::new();
    body.config.retain(|cfg| {
        if imported.contains_key(&cfg.key) {
            matched_names.push(cfg.key.clone());
            false // remove from config
        } else {
            true
        }
    });

    // Add matched component blocks to body
    for name in matched_names {
        if let Some(decl) = imported.get(&name) {
            body.blocks.push(Statement::ComponentBlock(decl.clone()));
        }
    }

    // Recurse into nested component blocks
    for block_stmt in &mut body.blocks {
        if let Statement::ComponentBlock(ref mut nested) = block_stmt {
            inject_components_into_body(&mut nested.body, imported);
        }
    }
}

/// Insert extern fn declarations from loaded packages at the front of the program.
fn inject_extern_fns(program: &mut Program, packages: &[PackageInfo]) {
    for pkg in packages {
        for extern_fn in &pkg.extern_fns {
            program.statements.insert(0, extern_fn.clone());
        }
    }
}

/// Insert exported fns from packages, renamed with the package name prefix.
fn inject_exported_fns(program: &mut Program, packages: &[PackageInfo]) {
    for pkg in packages {
        for fn_stmt in &pkg.exported_fns {
            if let Statement::FnDecl { name, type_params, params, return_type, body, span, .. } = fn_stmt {
                let renamed = Statement::FnDecl {
                    name: format!("{}_{}", pkg.name, name),
                    type_params: type_params.clone(),
                    params: params.clone(),
                    return_type: return_type.clone(),
                    body: body.clone(),
                    exported: false,
                    span: *span,
                };
                program.statements.insert(0, renamed);
            }
        }
    }
}

/// Expand all ComponentBlock nodes into regular AST, collecting lifecycle stmts and static methods.
fn expand_components(program: &mut Program, packages: &[PackageInfo]) -> ComponentExpansionResult {
    let mut all_static_methods = Vec::new();
    let mut all_component_methods = Vec::new();
    let mut all_component_types = Vec::new();
    let mut startup_stmts = Vec::new();
    let mut main_end_stmts = Vec::new();
    let mut extra_stmts = Vec::new();
    let mut extra_extern_fns = Vec::new();
    let mut service_infos = Vec::new();

    // Collect all templates for recursive nested component expansion
    let all_templates: Vec<&ComponentTemplateDef> = packages
        .iter()
        .flat_map(|p| p.component_templates.iter())
        .collect();

    let mut expanded_statements = Vec::new();
    for stmt in program.statements.drain(..) {
        if let Statement::ComponentBlock(ref decl) = stmt {
            let result = if let Some(template) = find_template(packages, &decl.component) {
                ComponentExpander::expand_from_template(template, decl, &service_infos, &all_templates)
            } else {
                ExpansionResult::new()
            };

            if let Some(type_decl) = result.type_decl {
                expanded_statements.push(type_decl);
            }
            extra_stmts.extend(result.statements);
            startup_stmts.extend(result.startup_stmts);
            main_end_stmts.extend(result.main_end_stmts);
            all_static_methods.extend(result.static_methods);
            all_component_methods.extend(result.component_methods);
            if let Some(ct) = result.component_type {
                all_component_types.push(ct);
            }
            extra_extern_fns.extend(result.extern_fns);
            if let Some(si) = result.service_info {
                service_infos.push(si);
            }
        } else {
            expanded_statements.push(stmt);
        }
    }
    for ef in extra_extern_fns {
        expanded_statements.insert(0, ef);
    }
    expanded_statements.extend(extra_stmts);
    program.statements = expanded_statements;

    ComponentExpansionResult {
        static_methods: all_static_methods,
        component_methods: all_component_methods,
        component_types: all_component_types,
        startup_stmts,
        main_end_stmts,
    }
}

/// Register package-declared annotations into the type checker.
fn capitalize_first(s: &str) -> String {
    let mut chars = s.chars();
    match chars.next() {
        None => String::new(),
        Some(c) => c.to_uppercase().collect::<String>() + chars.as_str(),
    }
}

fn register_package_annotations(checker: &mut crate::typeck::TypeChecker, packages: &[PackageInfo]) {
    for pkg in packages {
        for meta in &pkg.component_metas {
            for ann_decl in &meta.annotation_decls {
                checker.package_annotations.push((
                    ann_decl.name.clone(),
                    ann_decl.target.clone(),
                    meta.name.clone(),
                ));
            }
        }
    }
}

/// Find a component template definition matching the given component name
fn find_template<'a>(
    packages: &'a [PackageInfo],
    component: &str,
) -> Option<&'a ComponentTemplateDef> {
    packages
        .iter()
        .flat_map(|p| p.component_templates.iter())
        .find(|t| t.component_name == component)
}

/// Inject lifecycle statements (startup and main_end) into the main function
fn inject_lifecycle_stmts(
    program: &mut Program,
    startup_stmts: &[Statement],
    main_end_stmts: &[Statement],
) {
    if startup_stmts.is_empty() && main_end_stmts.is_empty() {
        return;
    }

    // Find the main function and inject statements
    for stmt in program.statements.iter_mut() {
        // Check both old FnDecl and new Feature variant
        let is_main = match stmt {
            Statement::FnDecl { name, .. } => name == "main",
            Statement::Feature(fe) if fe.feature_id == "functions" && fe.kind == "FnDecl" => {
                use crate::feature_data;
                use crate::features::functions::types::FnDeclData;
                feature_data!(fe, FnDeclData).map_or(false, |d| d.name == "main")
            }
            _ => false,
        };
        if is_main {
            // Helper closure to inject lifecycle stmts into a body
            let inject_into_body = |body_stmts: &[Statement]| -> Vec<Statement> {
                let mut new_body = startup_stmts.to_vec();
                new_body.extend(body_stmts.to_vec());
                if let Some(last) = new_body.last() {
                    if matches!(last, Statement::Return { .. } | Statement::Feature(crate::feature::FeatureStmt { feature_id: "functions", kind: "Return", .. })) {
                        let ret = new_body.pop().unwrap();
                        new_body.extend(main_end_stmts.to_vec());
                        new_body.push(ret);
                    } else {
                        new_body.extend(main_end_stmts.to_vec());
                    }
                } else {
                    new_body.extend(main_end_stmts.to_vec());
                }
                new_body
            };

            if let Statement::FnDecl { body, .. } = stmt {
                body.statements = inject_into_body(&body.statements);
                return;
            }
            if let Statement::Feature(fe) = stmt {
                use crate::feature_data;
                use crate::features::functions::types::FnDeclData;
                if let Some(data) = feature_data!(fe, FnDeclData) {
                    let new_stmts = inject_into_body(&data.body.statements);
                    let new_data = FnDeclData {
                        name: data.name.clone(),
                        type_params: data.type_params.clone(),
                        params: data.params.clone(),
                        return_type: data.return_type.clone(),
                        body: crate::parser::ast::Block { statements: new_stmts, span: data.body.span },
                        exported: data.exported,
                    };
                    *stmt = Statement::Feature(crate::feature::FeatureStmt {
                        feature_id: fe.feature_id,
                        kind: fe.kind,
                        data: Box::new(new_data),
                        span: fe.span,
                    });
                    return;
                }
            }
        }
    }

    // No main function found — store lifecycle stmts so codegen can use them.
    // This handles cases like server-only programs (full_stack.fg) where
    // codegen generates main and must also run startup stmts (DB init).
    // We create separate __forge_startup and __forge_main_end functions so
    // codegen can insert route registration between them.
    let sp = crate::lexer::Span::new(0, 0, 0, 0);
    if !startup_stmts.is_empty() {
        program.statements.push(Statement::FnDecl {
            name: "__forge_startup".to_string(),
            type_params: vec![],
            params: vec![],
            return_type: None,
            body: crate::parser::ast::Block { statements: startup_stmts.to_vec(), span: sp },
            exported: false,
            span: sp,
        });
    }
    if !main_end_stmts.is_empty() {
        program.statements.push(Statement::FnDecl {
            name: "__forge_main_end".to_string(),
            type_params: vec![],
            params: vec![],
            return_type: None,
            body: crate::parser::ast::Block { statements: main_end_stmts.to_vec(), span: sp },
            exported: false,
            span: sp,
        });
    }
}
