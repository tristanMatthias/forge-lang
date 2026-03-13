use crate::codegen::Codegen;
use crate::driver::profile::{BuildProfile, count_functions};
use crate::driver::project::ForgeProject;
use crate::errors::{CompileError, DiagnosticBag};
use crate::component_expand::{ComponentExpander, ExpansionResult};
use crate::lexer::Lexer;
use crate::parser::ast::{ComponentTemplateDef, Expr, Program, Statement};
use crate::parser::{ComponentMeta, Parser};
use crate::provider::{self, ProviderInfo};

use inkwell::context::Context;
use inkwell::OptimizationLevel;
use std::collections::HashMap;
use std::path::{Path, PathBuf};
use std::process::Command;
use std::sync::Mutex;
use std::time::Instant;

/// Global mutex for stdout capture — only one thread can redirect fd 1 at a time.
static STDOUT_CAPTURE_LOCK: Mutex<()> = Mutex::new(());

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

/// Describes an exported symbol from a module
#[derive(Debug, Clone)]
pub enum ExportedSymbol {
    Function {
        name: String,
        params: Vec<crate::parser::ast::Param>,
        return_type: Option<crate::parser::ast::TypeExpr>,
    },
    Value {
        name: String,
        value: crate::parser::ast::Expr,
        type_ann: Option<crate::parser::ast::TypeExpr>,
    },
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
    /// Calls `action` with the Codegen result, loaded providers, and build profile.
    /// This is the single source of truth for the compilation pipeline — used by both
    /// `compile()` (AOT) and `run_jit()` (JIT).
    fn with_compiled_module<T, F>(
        &self,
        source_path: &Path,
        action: F,
    ) -> Result<T, CompileError>
    where
        F: FnOnce(&Codegen<'_>, &[ProviderInfo], &mut BuildProfile) -> Result<T, CompileError>,
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

        if diag_bag.has_errors() {
            self.emit_diagnostics(&diag_bag, &source, filename);
            return Err(CompileError::DiagnosticErrors { stage: "lexer" });
        }

        // 2. Pre-scan tokens for provider uses
        let provider_uses = prescan_provider_uses(&tokens);

        // 3. Load providers → get component_metas, extern_fns
        let t = Instant::now();
        let loaded_providers = self.load_providers_by_uses(&provider_uses)?;
        bp.add("providers", t.elapsed());

        // Build component registry from provider metas
        let component_registry = build_component_registry(&loaded_providers);

        // 4. Parse with component registry
        let t = Instant::now();
        let mut parser = if component_registry.is_empty() {
            Parser::new(tokens)
        } else {
            Parser::new_with_components(tokens, component_registry)
        };
        let mut program = parser.parse_program();

        for d in parser.diagnostics() {
            diag_bag.report(d.clone());
        }
        bp.add("parse", t.elapsed());

        if diag_bag.has_errors() {
            self.emit_diagnostics(&diag_bag, &source, filename);
            return Err(CompileError::DiagnosticErrors { stage: "parser" });
        }

        // emit_ast is handled in compile() before calling this method

        // 5. Inject extern fns from providers
        for provider in &loaded_providers {
            for extern_fn in &provider.extern_fns {
                program.statements.insert(0, extern_fn.clone());
            }
        }

        // 5b. Inject exported fns from providers (renamed with provider name prefix)
        for provider in &loaded_providers {
            for fn_stmt in &provider.exported_fns {
                if let Statement::FnDecl { name, type_params, params, return_type, body, span, .. } = fn_stmt {
                    let renamed = Statement::FnDecl {
                        name: format!("{}_{}", provider.name, name),
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

        // 6. Expand all ComponentBlock nodes → regular AST + lifecycle stmts
        let t = Instant::now();
        let mut all_static_methods = Vec::new();
        let mut startup_stmts = Vec::new();
        let mut main_end_stmts = Vec::new();
        let mut extra_stmts = Vec::new();
        let mut extra_extern_fns = Vec::new();
        let mut service_infos = Vec::new();

        let mut expanded_statements = Vec::new();
        for stmt in program.statements.drain(..) {
            if let Statement::ComponentBlock(ref decl) = stmt {
                let result = if let Some(template) = find_template(&loaded_providers, &decl.component) {
                    ComponentExpander::expand_from_template(template, decl, &service_infos)
                } else {
                    ExpansionResult::new()
                };

                if let Some(type_decl) = result.type_decl {
                    expanded_statements.push(type_decl);
                }
                for s in result.statements {
                    extra_stmts.push(s);
                }
                for s in result.startup_stmts {
                    startup_stmts.push(s);
                }
                for s in result.main_end_stmts {
                    main_end_stmts.push(s);
                }
                for sm in result.static_methods {
                    all_static_methods.push(sm);
                }
                for ef in result.extern_fns {
                    extra_extern_fns.push(ef);
                }
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

        // 7. Inject lifecycle stmts into main function
        inject_lifecycle_stmts(&mut program, &startup_stmts, &main_end_stmts);
        bp.add("expand", t.elapsed());

        bp.fn_count = count_functions(&program);

        // 7b. Type check
        let t = Instant::now();
        let mut checker = crate::typeck::TypeChecker::new();
        for (type_name, _, _) in &all_static_methods {
            checker.env.namespaces.insert(type_name.clone());
        }
        checker.check_program(&program);
        for d in &checker.diagnostics {
            diag_bag.report(d.clone());
        }
        bp.add("typeck", t.elapsed());

        if diag_bag.has_errors() {
            self.emit_diagnostics(&diag_bag, &source, filename);
            return Err(CompileError::DiagnosticErrors { stage: "type checker" });
        }

        // 8. Codegen
        let t = Instant::now();
        let context = Context::create();
        let module_name = source_path
            .file_stem()
            .and_then(|s| s.to_str())
            .unwrap_or("module");

        let mut codegen = Codegen::new(&context, module_name);
        codegen.source_file = filename.to_string();

        // Populate static methods registry from providers
        for (type_name, method_name, fn_name) in &all_static_methods {
            codegen.static_methods.insert(
                (type_name.clone(), method_name.clone()),
                fn_name.clone(),
            );
        }
        for provider in &loaded_providers {
            let prefix = format!("forge_{}_", provider.name);
            for extern_fn in &provider.extern_fns {
                if let Statement::ExternFn { name, .. } = extern_fn {
                    if let Some(method_name) = name.strip_prefix(&prefix) {
                        codegen.static_methods.insert(
                            (provider.name.clone(), method_name.to_string()),
                            name.clone(),
                        );
                    }
                }
            }
        }
        for provider in &loaded_providers {
            for fn_stmt in &provider.exported_fns {
                if let Statement::FnDecl { name, .. } = fn_stmt {
                    let full_name = format!("{}_{}", provider.name, name);
                    codegen.static_methods.insert(
                        (provider.name.clone(), name.clone()),
                        full_name,
                    );
                }
            }
        }

        codegen.compile_program(&program);
        bp.add("codegen", t.elapsed());

        // Hand off to the action (AOT write+link or JIT execute)
        action(&codegen, &loaded_providers, &mut bp)
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

        self.with_compiled_module(source_path, |codegen, loaded_providers, bp| {
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

            // Collect provider native lib paths
            let provider_lib_paths: Vec<PathBuf> = loaded_providers
                .iter()
                .filter(|p| p.lib_path.exists())
                .map(|p| p.lib_path.clone())
                .collect();

            // Link
            let t = Instant::now();
            self.link_with_providers(&obj_path, &runtime_obj, &output_path, &provider_lib_paths)?;
            bp.add("link", t.elapsed());

            // Cleanup
            std::fs::remove_file(&obj_path).ok();

            // Get binary size
            if let Ok(meta) = std::fs::metadata(&output_path) {
                bp.binary_size = meta.len();
            }

            if self.profile {
                if self.profile_format == "json" {
                    eprintln!("{}", bp.render_json());
                } else {
                    eprintln!("{}", bp.render_human());
                }
            }

            Ok(output_path)
        })
    }

    /// JIT-compile and execute a Forge program in-process (no linking, no binary on disk).
    /// Loads provider .dylib files with RTLD_GLOBAL so JIT can resolve their symbols.
    /// Falls back to AOT only if a provider has no .dylib (only .a).
    pub fn run_jit(&self, source_path: &Path) -> Result<i32, CompileError> {
        self.with_compiled_module(source_path, |codegen, loaded_providers, bp| {
            // Check if any provider has a native lib but no dylib — must fall back to AOT
            let needs_aot = loaded_providers.iter().any(|p| {
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

            // Load provider dylibs with RTLD_GLOBAL
            let t = Instant::now();
            for provider in loaded_providers {
                if provider.dylib_path.exists() {
                    let lib = unsafe {
                        libloading::os::unix::Library::open(
                            Some(&provider.dylib_path),
                            libloading::os::unix::RTLD_LAZY | libloading::os::unix::RTLD_GLOBAL,
                        )
                    }.map_err(|e| CompileError::JitFailed {
                        detail: format!("failed to load provider '{}' dylib: {}", provider.name, e),
                    })?;
                    _loaded_libs.push(lib);
                }
            }
            bp.add("providers_load", t.elapsed());

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

            if self.profile {
                if self.profile_format == "json" {
                    eprintln!("{}", bp.render_json());
                } else {
                    eprintln!("{}", bp.render_human());
                }
            }

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

        // Phase 1: Parse all files
        let mut parsed_modules: Vec<(String, PathBuf, String, Program)> = Vec::new(); // (module_path, file_path, source, ast)

        // Parse non-entry modules
        for module_info in &project.modules {
            let source = std::fs::read_to_string(&module_info.file_path)
                .map_err(|e| CompileError::FileNotFound {
                    path: module_info.file_path.display().to_string(),
                    detail: e.to_string(),
                })?;

            let filename = module_info.file_path.to_str().unwrap_or("<unknown>");
            let (program, diag_bag) = self.parse_source(&source)?;

            if diag_bag.has_errors() {
                diag_bag.print_all(&source, filename);
                return Err(CompileError::DiagnosticErrors { stage: "parser" });
            }

            parsed_modules.push((
                module_info.module_path.clone(),
                module_info.file_path.clone(),
                source,
                program,
            ));
        }

        // Parse entry file
        let entry_source = std::fs::read_to_string(&project.entry_file)
            .map_err(|e| CompileError::FileNotFound {
                path: project.entry_file.display().to_string(),
                detail: e.to_string(),
            })?;

        let (entry_program, entry_diag) = self.parse_source(&entry_source)?;
        if entry_diag.has_errors() {
            entry_diag.print_all(
                &entry_source,
                project.entry_file.to_str().unwrap_or("<unknown>"),
            );
            return Err(CompileError::DiagnosticErrors { stage: "parser" });
        }

        // Phase 2: Collect exported symbols from each module
        let mut module_exports: HashMap<String, Vec<ExportedSymbol>> = HashMap::new();

        for (module_path, _file_path, _source, program) in &parsed_modules {
            let exports = collect_exports(program);
            module_exports.insert(module_path.clone(), exports);
        }

        // Phase 3: Resolve use statements in the entry file
        // Collect which symbols the entry file needs from which modules
        let imports = resolve_use_statements(&entry_program, &module_exports)?;

        // Phase 4: Codegen - compile everything into a single LLVM module
        let context = Context::create();
        let module_name = &project.config.project.name;

        let mut codegen = Codegen::new(&context, module_name);

        // First: compile all library modules (their exported functions will be defined)
        for (module_path, _file_path, _source, program) in &parsed_modules {
            // Prefix non-entry module function names with module path to avoid conflicts
            // Actually, since we compile into one LLVM module, we can use the original names
            // as long as they don't conflict. For simplicity, we'll mangle names.
            // But the test expects `add` and `multiply` to be callable by those names
            // from the entry module. So we need to handle this carefully.

            // Approach: compile module functions with their original names.
            // The entry file's use statement maps them, so they can call by the imported name.
            // Since all modules go into one LLVM module, the names just need to not conflict.

            // For now, prefix module functions with _module_path_ to avoid clashes,
            // except we'll also create aliases for imported names.
            codegen.compile_module_program(program, module_path);
        }

        // Now compile the entry program.
        // Before that, inject declarations for imported symbols so codegen can find them.
        codegen.inject_imports(&imports);
        codegen.compile_program(&entry_program);

        if self.emit_ir {
            println!("{}", codegen.emit_ir());
            return Ok(PathBuf::new());
        }

        // Determine output path
        let output_path = self.output.clone().unwrap_or_else(|| {
            PathBuf::from(&project.config.project.name)
        });

        // Write object file
        let obj_path = output_path.with_extension("o");
        codegen.write_object_file(&obj_path)?;

        // Compile runtime - use project root as reference for finding stdlib
        let runtime_obj = self.compile_runtime_for_project(&project.root_dir)?;

        // Link
        self.link(&obj_path, &runtime_obj, &output_path)?;

        // Cleanup
        std::fs::remove_file(&obj_path).ok();

        Ok(output_path)
    }

    /// Parse source into AST, returning diagnostics
    fn parse_source(&self, source: &str) -> Result<(Program, DiagnosticBag), CompileError> {
        let mut lexer = Lexer::new(source);
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

        Ok((program, diag_bag))
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

        if diag_bag.has_errors() {
            self.emit_diagnostics(&diag_bag, &source, filename);
            return Err(CompileError::DiagnosticErrors { stage: "lexer" });
        }

        // Pre-scan tokens for provider uses
        let provider_uses = prescan_provider_uses(&tokens);

        // Load providers
        let loaded_providers = self.load_providers_by_uses(&provider_uses)?;

        // Build component registry from provider metas
        let component_registry = build_component_registry(&loaded_providers);

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

        if diag_bag.has_errors() {
            self.emit_diagnostics(&diag_bag, &source, filename);
            return Err(CompileError::DiagnosticErrors { stage: "parser" });
        }

        // Inject extern fns from providers
        for provider in &loaded_providers {
            for extern_fn in &provider.extern_fns {
                program.statements.insert(0, extern_fn.clone());
            }
        }

        // Inject exported fns from providers (renamed with provider name prefix)
        for provider in &loaded_providers {
            for fn_stmt in &provider.exported_fns {
                if let Statement::FnDecl { name, type_params, params, return_type, body, span, .. } = fn_stmt {
                    let renamed = Statement::FnDecl {
                        name: format!("{}_{}", provider.name, name),
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

        // Expand all ComponentBlock nodes → regular AST + lifecycle stmts
        let mut all_static_methods = Vec::new();
        let mut startup_stmts = Vec::new();
        let mut main_end_stmts = Vec::new();
        let mut extra_stmts = Vec::new();
        let mut extra_extern_fns = Vec::new();
        let mut service_infos = Vec::new();

        let mut expanded_statements = Vec::new();
        for stmt in program.statements.drain(..) {
            if let Statement::ComponentBlock(ref decl) = stmt {
                let result = if let Some(template) = find_template(&loaded_providers, &decl.component) {
                    ComponentExpander::expand_from_template(template, decl, &service_infos)
                } else {
                    ExpansionResult::new()
                };

                if let Some(type_decl) = result.type_decl {
                    expanded_statements.push(type_decl);
                }
                for s in result.statements {
                    extra_stmts.push(s);
                }
                for s in result.startup_stmts {
                    startup_stmts.push(s);
                }
                for s in result.main_end_stmts {
                    main_end_stmts.push(s);
                }
                for sm in result.static_methods {
                    all_static_methods.push(sm);
                }
                for ef in result.extern_fns {
                    extra_extern_fns.push(ef);
                }
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

        // Inject lifecycle stmts into main function
        inject_lifecycle_stmts(&mut program, &startup_stmts, &main_end_stmts);

        // Type check
        let mut checker = crate::typeck::TypeChecker::new();
        for (type_name, _, _) in &all_static_methods {
            checker.env.namespaces.insert(type_name.clone());
        }
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

    fn compile_runtime_for_project(&self, project_dir: &Path) -> Result<PathBuf, CompileError> {
        let runtime_src = self.find_runtime_src(project_dir)?;
        self.compile_runtime_file(&runtime_src)
    }

    /// Compile runtime.c to a shared library (.dylib) for JIT execution.
    /// Cached by content hash, same as the .o path.
    fn compile_runtime_dylib(&self, source_path: &Path) -> Result<PathBuf, CompileError> {
        let runtime_src = self.find_runtime_src(source_path)?;
        let opt_flag = match self.optimization {
            OptLevel::Release => "-O2",
            OptLevel::Dev => "-O0",
        };

        let opt_tag = if opt_flag == "-O2" { "O2" } else { "O0" };
        let dylib_path = self.runtime_cache_dir().join(format!("forge_runtime_{}.dylib", opt_tag));
        let hash_path = self.runtime_cache_dir().join(format!("forge_runtime_{}_dylib.hash", opt_tag));

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
        let opt_flag = match self.optimization {
            OptLevel::Release => "-O2",
            OptLevel::Dev => "-O0",
        };

        // Cache key: hash of runtime.c content + opt level
        if let Ok(cached) = self.cached_runtime(runtime_src, opt_flag) {
            return Ok(cached);
        }

        let runtime_obj = self.runtime_cache_path(runtime_src, opt_flag);

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
        let _ = std::fs::write(self.runtime_hash_path(runtime_src, opt_flag), self.runtime_hash(runtime_src));

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

    fn runtime_cache_path(&self, _runtime_src: &Path, opt_flag: &str) -> PathBuf {
        let opt_tag = if opt_flag == "-O2" { "O2" } else { "O0" };
        self.runtime_cache_dir().join(format!("forge_runtime_{}.o", opt_tag))
    }

    fn runtime_hash_path(&self, runtime_src: &Path, opt_flag: &str) -> PathBuf {
        let opt_tag = if opt_flag == "-O2" { "O2" } else { "O0" };
        self.runtime_cache_dir().join(format!("forge_runtime_{}.hash", opt_tag))
    }

    fn cached_runtime(&self, runtime_src: &Path, opt_flag: &str) -> Result<PathBuf, ()> {
        let obj_path = self.runtime_cache_path(runtime_src, opt_flag);
        let hash_path = self.runtime_hash_path(runtime_src, opt_flag);

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

    fn link(&self, obj: &Path, runtime_obj: &Path, output: &Path) -> Result<(), CompileError> {
        self.link_with_providers(obj, runtime_obj, output, &[])
    }

    fn link_with_providers(
        &self,
        obj: &Path,
        runtime_obj: &Path,
        output: &Path,
        provider_lib_paths: &[PathBuf],
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

        // Add provider native library paths
        let mut has_native_providers = false;
        for lib_path in provider_lib_paths {
            args.push(path_str(lib_path)?);
            has_native_providers = true;
        }

        // On macOS, we need to link system frameworks for the Rust static libs
        if has_native_providers {
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

    /// Load providers by pre-scanned (namespace, name) pairs.
    /// Returns an error if any provider fails to load — never silently ignores failures.
    fn load_providers_by_uses(&self, uses: &[(String, String)]) -> Result<Vec<ProviderInfo>, CompileError> {
        let mut providers = Vec::new();
        let providers_base = match self.find_providers_dir() {
            Some(base) => base,
            None => return Ok(providers),
        };

        for (namespace, name) in uses {
            match provider::find_provider(&providers_base, namespace, name) {
                Some(provider_dir) => {
                    let info = provider::load_provider(&provider_dir)
                        .map_err(|e| CompileError::ProviderLoadFailed {
                            provider: format!("@{}.{}", namespace, name),
                            detail: e,
                        })?;
                    providers.push(info);
                }
                None => {
                    // Provider directory doesn't exist — this is an error, not a warning
                    return Err(CompileError::ProviderNotFound {
                        namespace: namespace.clone(),
                        name: name.clone(),
                    });
                }
            }
        }

        Ok(providers)
    }

    /// Find the providers directory relative to the forge binary or source tree
    fn find_providers_dir(&self) -> Option<PathBuf> {
        // Check relative to the cargo manifest dir (for development)
        let candidates = vec![
            PathBuf::from("providers"),
            PathBuf::from("../providers"),
        ];

        // Also check relative to the forge binary
        if let Ok(exe) = std::env::current_exe() {
            if let Some(exe_dir) = exe.parent() {
                let mut extra = vec![
                    exe_dir.join("../providers"),
                    exe_dir.join("../../providers"),
                    exe_dir.join("../../../providers"),
                ];
                // For cargo builds, binary is in target/debug/ or target/release/
                extra.push(exe_dir.join("../../providers"));
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

/// Collect exported symbols from a parsed module
fn collect_exports(program: &Program) -> Vec<ExportedSymbol> {
    let mut exports = Vec::new();

    for stmt in &program.statements {
        match stmt {
            Statement::FnDecl {
                name,
                params,
                return_type,
                exported: true,
                ..
            } => {
                exports.push(ExportedSymbol::Function {
                    name: name.clone(),
                    params: params.clone(),
                    return_type: return_type.clone(),
                });
            }
            Statement::Let {
                name,
                value,
                type_ann,
                exported: true,
                ..
            }
            | Statement::Const {
                name,
                value,
                type_ann,
                exported: true,
                ..
            } => {
                exports.push(ExportedSymbol::Value {
                    name: name.clone(),
                    value: value.clone(),
                    type_ann: type_ann.clone(),
                });
            }
            _ => {}
        }
    }

    exports
}

/// Information about an import that needs to be injected into codegen
#[derive(Debug, Clone)]
pub struct ResolvedImport {
    /// The local name to use in the importing module
    pub local_name: String,
    /// The mangled name in the LLVM module (module_path + "." + export_name)
    pub mangled_name: String,
    /// The exported symbol info
    pub symbol: ExportedSymbol,
}

/// Resolve `use` statements in a program against the module exports
fn resolve_use_statements(
    program: &Program,
    module_exports: &HashMap<String, Vec<ExportedSymbol>>,
) -> Result<Vec<ResolvedImport>, String> {
    let mut imports = Vec::new();

    for stmt in &program.statements {
        if let Statement::Use { path, items, .. } = stmt {
            // Skip provider use statements (e.g., use @std.model)
            if !path.is_empty() && path[0].starts_with('@') {
                continue;
            }

            let module_path = path.join(".");

            let exports = module_exports
                .get(&module_path)
                .ok_or_else(|| format!("unresolved module: {}", module_path))?;

            if items.is_empty() {
                // `use math.add` - the last path segment is the item name
                // This case: path = ["math", "add"], items = []
                // Module path would be "math.add" but that's wrong.
                // Actually looking at the parser: `use math.add` gives path=["math", "add"], items=[]
                // We need to handle this: the module is the path minus the last segment,
                // and the item is the last segment.
                // But `use math.{add, multiply}` gives path=["math"], items=[add, multiply]

                // For the path-only case, module is path[..n-1], item is path[n-1]
                if path.len() >= 2 {
                    let mod_path = path[..path.len() - 1].join(".");
                    let item_name = path.last().unwrap();

                    let mod_exports = module_exports
                        .get(&mod_path)
                        .ok_or_else(|| format!("unresolved module: {}", mod_path))?;

                    let sym = mod_exports
                        .iter()
                        .find(|e| match e {
                            ExportedSymbol::Function { name, .. } => name == item_name,
                            ExportedSymbol::Value { name, .. } => name == item_name,
                        })
                        .ok_or_else(|| {
                            format!(
                                "symbol `{}` is not exported from module `{}`",
                                item_name, mod_path
                            )
                        })?;

                    let mangled = format!("{}_{}", mod_path.replace('.', "_"), item_name);
                    imports.push(ResolvedImport {
                        local_name: item_name.clone(),
                        mangled_name: mangled,
                        symbol: sym.clone(),
                    });
                }
            } else {
                // `use math.{add, multiply}` - path is the module, items are what to import
                for item in items {
                    let sym = exports
                        .iter()
                        .find(|e| match e {
                            ExportedSymbol::Function { name, .. } => name == &item.name,
                            ExportedSymbol::Value { name, .. } => name == &item.name,
                        })
                        .ok_or_else(|| {
                            format!(
                                "symbol `{}` is not exported from module `{}`",
                                item.name, module_path
                            )
                        })?;

                    let local_name = item.alias.clone().unwrap_or_else(|| item.name.clone());
                    let mangled = format!(
                        "{}_{}",
                        module_path.replace('.', "_"),
                        item.name
                    );
                    imports.push(ResolvedImport {
                        local_name,
                        mangled_name: mangled,
                        symbol: sym.clone(),
                    });
                }
            }
        }
    }

    Ok(imports)
}

/// Pre-scan tokens for `use @namespace.name` patterns to determine which providers to load
/// before full parsing. This allows the parser to use component registries from providers.
fn prescan_provider_uses(tokens: &[crate::lexer::Token]) -> Vec<(String, String)> {
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
                                if let TokenKind::Ident(ref provider_name) = tokens[j].kind {
                                    uses.push((namespace.clone(), provider_name.clone()));
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
                                if let TokenKind::Ident(ref provider_name) = tokens[j].kind {
                                    uses.push((namespace, provider_name.clone()));
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

/// Build a component registry from loaded providers' component metas
fn build_component_registry(providers: &[ProviderInfo]) -> HashMap<String, ComponentMeta> {
    let mut registry = HashMap::new();
    for provider in providers {
        for meta in &provider.component_metas {
            registry.insert(meta.name.clone(), meta.clone());
        }
    }
    registry
}

/// Find a component template definition matching the given component name
fn find_template<'a>(
    providers: &'a [ProviderInfo],
    component: &str,
) -> Option<&'a ComponentTemplateDef> {
    providers
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
        if let Statement::FnDecl { name, body, .. } = stmt {
            if name == "main" {
                // Insert startup stmts at the beginning of main body
                let mut new_body = startup_stmts.to_vec();
                new_body.extend(body.statements.clone());
                // Insert main_end stmts before the last statement if it's a return,
                // otherwise at the end
                if let Some(last) = new_body.last() {
                    if matches!(last, Statement::Return { .. }) {
                        let ret = new_body.pop().unwrap();
                        new_body.extend(main_end_stmts.to_vec());
                        new_body.push(ret);
                    } else {
                        new_body.extend(main_end_stmts.to_vec());
                    }
                } else {
                    new_body.extend(main_end_stmts.to_vec());
                }
                body.statements = new_body;
                return;
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
