use crate::codegen::Codegen;
use crate::driver::project::ForgeProject;
use crate::errors::DiagnosticBag;
use crate::component_expand::{ComponentExpander, ExpansionResult};
use crate::lexer::Lexer;
use crate::parser::ast::{ComponentTemplateDef, Program, Statement};
use crate::parser::{ComponentMeta, Parser};
use crate::provider::{self, ProviderInfo};

use inkwell::context::Context;
use std::collections::HashMap;
use std::path::{Path, PathBuf};
use std::process::Command;

pub struct Driver {
    pub emit_ir: bool,
    pub emit_ast: bool,
    pub optimization: OptLevel,
    pub output: Option<PathBuf>,
    pub error_format: ErrorFormat,
    pub max_errors: usize,
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
        }
    }

    /// Compile a single .fg file
    pub fn compile(&self, source_path: &Path) -> Result<PathBuf, String> {
        let source = std::fs::read_to_string(source_path)
            .map_err(|e| format!("cannot read {}: {}", source_path.display(), e))?;

        let filename = source_path.to_str().unwrap_or("<unknown>");

        // 1. Lex
        let mut lexer = Lexer::new(&source);
        let tokens = lexer.tokenize();

        let mut diag_bag = DiagnosticBag::new();
        for d in lexer.diagnostics() {
            diag_bag.report(d.clone());
        }

        if diag_bag.has_errors() {
            self.emit_diagnostics(&diag_bag, &source, filename);
            return Err("lexer errors".into());
        }

        // 2. Pre-scan tokens for provider uses
        let provider_uses = prescan_provider_uses(&tokens);

        // 3. Load providers → get component_metas, extern_fns
        let loaded_providers = self.load_providers_by_uses(&provider_uses);

        // Build component registry from provider metas
        let component_registry = build_component_registry(&loaded_providers);

        // 4. Parse with component registry
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
            return Err("parser errors".into());
        }

        if self.emit_ast {
            println!("{:#?}", program);
            return Ok(PathBuf::new());
        }

        // 5. Inject extern fns from providers
        for provider in &loaded_providers {
            for extern_fn in &provider.extern_fns {
                program.statements.insert(0, extern_fn.clone());
            }
        }

        // 6. Expand all ComponentBlock nodes → regular AST + lifecycle stmts
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
        // Add extra extern fns at the beginning
        for ef in extra_extern_fns {
            expanded_statements.insert(0, ef);
        }
        // Add extra statements (fn decls from services, etc.)
        expanded_statements.extend(extra_stmts);
        program.statements = expanded_statements;

        // 7. Inject lifecycle stmts into main function
        inject_lifecycle_stmts(&mut program, &startup_stmts, &main_end_stmts);

        // 8. Codegen
        let context = Context::create();
        let module_name = source_path
            .file_stem()
            .and_then(|s| s.to_str())
            .unwrap_or("module");

        let mut codegen = Codegen::new(&context, module_name);

        // Populate static methods registry
        for (type_name, method_name, fn_name) in &all_static_methods {
            codegen.static_methods.insert(
                (type_name.clone(), method_name.clone()),
                fn_name.clone(),
            );
        }
        // Register provider extern fns as static methods by stripping the forge_{name}_ prefix
        // e.g. forge_fs_read → fs.read, forge_fs_write → fs.write
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

        codegen.compile_program(&program);

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
        let obj_path = output_path.with_extension("o");
        codegen.write_object_file(&obj_path)?;

        // Compile runtime
        let runtime_obj = self.compile_runtime(source_path)?;

        // Collect provider native lib paths
        let provider_lib_paths: Vec<PathBuf> = loaded_providers
            .iter()
            .filter(|p| p.lib_path.exists())
            .map(|p| p.lib_path.clone())
            .collect();

        // Link
        self.link_with_providers(&obj_path, &runtime_obj, &output_path, &provider_lib_paths)?;

        // Cleanup
        std::fs::remove_file(&obj_path).ok();

        Ok(output_path)
    }

    /// Compile a project directory containing forge.toml
    pub fn compile_project(&self, project_dir: &Path) -> Result<PathBuf, String> {
        let project = ForgeProject::load(project_dir)?;

        // Phase 1: Parse all files
        let mut parsed_modules: Vec<(String, PathBuf, String, Program)> = Vec::new(); // (module_path, file_path, source, ast)

        // Parse non-entry modules
        for module_info in &project.modules {
            let source = std::fs::read_to_string(&module_info.file_path)
                .map_err(|e| format!("cannot read {}: {}", module_info.file_path.display(), e))?;

            let filename = module_info.file_path.to_str().unwrap_or("<unknown>");
            let (program, diag_bag) = self.parse_source(&source)?;

            if diag_bag.has_errors() {
                diag_bag.print_all(&source, filename);
                return Err(format!("errors in {}", module_info.file_path.display()));
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
            .map_err(|e| format!("cannot read {}: {}", project.entry_file.display(), e))?;

        let (entry_program, entry_diag) = self.parse_source(&entry_source)?;
        if entry_diag.has_errors() {
            entry_diag.print_all(
                &entry_source,
                project.entry_file.to_str().unwrap_or("<unknown>"),
            );
            return Err("errors in entry file".into());
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
    fn parse_source(&self, source: &str) -> Result<(Program, DiagnosticBag), String> {
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

    pub fn check(&self, source_path: &Path) -> Result<(), String> {
        let source = std::fs::read_to_string(source_path)
            .map_err(|e| format!("cannot read {}: {}", source_path.display(), e))?;

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

        // Type check
        let mut checker = crate::typeck::TypeChecker::new();
        checker.check_program(&program);
        for d in &checker.diagnostics {
            diag_bag.report(d.clone());
        }

        if diag_bag.has_errors() {
            self.emit_diagnostics(&diag_bag, &source, filename);
            return Err("type check errors".into());
        }

        // Print warnings even when no errors
        if diag_bag.warning_count() > 0 {
            self.emit_diagnostics(&diag_bag, &source, filename);
        }

        println!("No errors found.");
        Ok(())
    }

    fn emit_diagnostics(&self, diag_bag: &DiagnosticBag, source: &str, filename: &str) {
        if self.error_format == ErrorFormat::Json {
            diag_bag.print_json();
        } else {
            diag_bag.print_all_limited(source, filename, self.max_errors);
            diag_bag.print_summary();
        }
    }

    fn compile_runtime(&self, source_path: &Path) -> Result<PathBuf, String> {
        // Find runtime.c relative to the binary or in known locations
        let runtime_paths = vec![
            source_path.parent().unwrap_or(Path::new(".")).join("../stdlib/runtime.c"),
            PathBuf::from("stdlib/runtime.c"),
            PathBuf::from("../stdlib/runtime.c"),
            // Look relative to the forge binary
            std::env::current_exe()
                .ok()
                .and_then(|p| p.parent().map(|p| p.join("../stdlib/runtime.c")))
                .unwrap_or_default(),
        ];

        let runtime_src = runtime_paths
            .iter()
            .find(|p| p.exists())
            .ok_or("cannot find stdlib/runtime.c")?;

        self.compile_runtime_file(runtime_src)
    }

    fn compile_runtime_for_project(&self, project_dir: &Path) -> Result<PathBuf, String> {
        let mut runtime_paths = vec![
            project_dir.join("stdlib/runtime.c"),
            project_dir.join("../stdlib/runtime.c"),
            PathBuf::from("stdlib/runtime.c"),
            PathBuf::from("../stdlib/runtime.c"),
        ];
        // Search relative to the forge binary
        if let Ok(exe) = std::env::current_exe() {
            if let Some(exe_dir) = exe.parent() {
                runtime_paths.push(exe_dir.join("../stdlib/runtime.c"));
                // For cargo builds, binary is in target/debug/
                runtime_paths.push(exe_dir.join("../../stdlib/runtime.c"));
            }
        }

        let runtime_src = runtime_paths
            .iter()
            .find(|p| p.exists())
            .ok_or("cannot find stdlib/runtime.c")?;

        self.compile_runtime_file(runtime_src)
    }

    fn compile_runtime_file(&self, runtime_src: &Path) -> Result<PathBuf, String> {
        let runtime_obj = std::env::temp_dir().join("forge_runtime.o");

        let output = Command::new("cc")
            .args([
                "-c",
                runtime_src.to_str().unwrap(),
                "-o",
                runtime_obj.to_str().unwrap(),
                "-O2",
            ])
            .output()
            .map_err(|e| format!("failed to compile runtime: {}", e))?;

        if !output.status.success() {
            return Err(format!(
                "failed to compile runtime: {}",
                String::from_utf8_lossy(&output.stderr)
            ));
        }

        Ok(runtime_obj)
    }

    fn link(&self, obj: &Path, runtime_obj: &Path, output: &Path) -> Result<(), String> {
        self.link_with_providers(obj, runtime_obj, output, &[])
    }

    fn link_with_providers(
        &self,
        obj: &Path,
        runtime_obj: &Path,
        output: &Path,
        provider_lib_paths: &[PathBuf],
    ) -> Result<(), String> {
        let mut args = vec![
            obj.to_str().unwrap().to_string(),
            runtime_obj.to_str().unwrap().to_string(),
            "-o".to_string(),
            output.to_str().unwrap().to_string(),
        ];

        // Add provider native library paths
        let mut has_native_providers = false;
        for lib_path in provider_lib_paths {
            args.push(lib_path.to_str().unwrap().to_string());
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
            .map_err(|e| format!("linker failed: {}", e))?;

        if !output_cmd.status.success() {
            return Err(format!(
                "linker failed: {}",
                String::from_utf8_lossy(&output_cmd.stderr)
            ));
        }

        Ok(())
    }

    /// Load providers by pre-scanned (namespace, name) pairs
    fn load_providers_by_uses(&self, uses: &[(String, String)]) -> Vec<ProviderInfo> {
        let mut providers = Vec::new();
        let providers_base = match self.find_providers_dir() {
            Some(base) => base,
            None => return providers,
        };

        for (namespace, name) in uses {
            if let Some(provider_dir) = provider::find_provider(&providers_base, namespace, name) {
                match provider::load_provider(&provider_dir) {
                    Ok(info) => providers.push(info),
                    Err(e) => eprintln!("warning: failed to load provider {}.{}: {}", namespace, name, e),
                }
            }
        }

        providers
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
