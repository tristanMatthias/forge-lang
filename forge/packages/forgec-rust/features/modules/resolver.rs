use std::collections::{HashMap, HashSet};
use std::path::{Path, PathBuf};

use crate::errors::CompileError;
use crate::parser::ComponentMeta;
use crate::lexer::Lexer;
use crate::parser::ast::{Program, Statement};
use crate::parser::Parser;

use super::types::{ExportedSymbol, ResolvedImport};

/// Collect exported symbols from a parsed module.
pub fn collect_exports(program: &Program) -> Vec<ExportedSymbol> {
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
            Statement::Feature(fe) => {
                use crate::feature_data;
                match fe.feature_id {
                    "functions" => {
                        use crate::features::functions::types::FnDeclData;
                        if let Some(data) = feature_data!(fe, FnDeclData) {
                            if data.exported {
                                exports.push(ExportedSymbol::Function {
                                    name: data.name.clone(),
                                    params: data.params.clone(),
                                    return_type: data.return_type.clone(),
                                });
                            }
                        }
                    }
                    "structs" => {
                        use crate::features::structs::types::TypeDeclData;
                        if let Some(data) = feature_data!(fe, TypeDeclData) {
                            if data.exported {
                                exports.push(ExportedSymbol::TypeDecl {
                                    name: data.name.clone(),
                                    stmt: Statement::Feature(fe.clone()),
                                });
                            }
                        }
                    }
                    "enums" => {
                        use crate::features::enums::types::EnumDeclData;
                        if let Some(data) = feature_data!(fe, EnumDeclData) {
                            if data.exported {
                                exports.push(ExportedSymbol::EnumDecl {
                                    name: data.name.clone(),
                                    stmt: Statement::Feature(fe.clone()),
                                });
                            }
                        }
                    }
                    "variables" => {
                        use crate::features::variables::types::VarDeclData;
                        if let Some(data) = feature_data!(fe, VarDeclData) {
                            if data.exported {
                                exports.push(ExportedSymbol::Value {
                                    name: data.name.clone(),
                                    value: data.value.clone(),
                                    type_ann: data.type_ann.clone(),
                                });
                            }
                        }
                    }
                    _ => {}
                }
            }
            Statement::ComponentBlock(decl) if decl.exported => {
                // Component name is the first Ident arg (e.g., `command build` → "build")
                let name = decl.args.iter().find_map(|a| {
                    if let crate::parser::ast::ComponentArg::Ident(n, _) = a {
                        Some(n.clone())
                    } else {
                        None
                    }
                }).unwrap_or_else(|| decl.component.clone());
                exports.push(ExportedSymbol::ComponentBlock {
                    name,
                    decl: decl.clone(),
                });
            }
            _ => {}
        }
    }

    exports
}

/// Recursively resolve the module tree from `mod` declarations.
///
/// Starting from a parsed program, scans for `mod foo` declarations and resolves
/// each to a source file (like Rust):
///   - `foo.fg` in the same directory as the declaring file
///   - `foo/mod.fg` for directory-style modules
///
/// Recurses into each discovered module to find nested `mod` declarations.
/// Returns a flat list of (module_path, file_path, source, Program) tuples.
pub fn resolve_mod_tree(
    program: &Program,
    source_path: &Path,
    parent_module_path: &str,
    seen: &mut HashSet<PathBuf>,
    component_registry: &HashMap<String, ComponentMeta>,
) -> Result<Vec<(String, PathBuf, String, Program)>, CompileError> {
    let source_dir = source_path.parent().unwrap_or(Path::new("."));
    let mut modules = Vec::new();

    for stmt in &program.statements {
        let mod_name = match stmt {
            Statement::ModDecl { name, .. } => name.clone(),
            _ => continue,
        };

        let module_path = if parent_module_path.is_empty() {
            mod_name.clone()
        } else {
            format!("{}.{}", parent_module_path, mod_name)
        };

        // Find the module file: foo.fg or foo/mod.fg
        let file_path = find_mod_file(source_dir, &mod_name, source_path)?;
        let canonical = file_path.canonicalize().unwrap_or_else(|_| file_path.clone());

        if seen.contains(&canonical) {
            return Err(CompileError::CliError {
                message: format!("circular module dependency: '{}'", module_path),
                help: Some(format!(
                    "{} was already included in the module tree",
                    file_path.display()
                )),
            });
        }
        seen.insert(canonical);

        let (mod_source, mod_program) = parse_module_file(&file_path, component_registry)?;

        // Recurse into the module to find nested mod declarations.
        // For directory modules (foo/mod.fg), nested mods resolve relative to foo/.
        // For file modules (foo.fg), nested mods resolve relative to foo/ (create dir).
        let nested = resolve_mod_tree(&mod_program, &file_path, &module_path, seen, component_registry)?;

        modules.push((module_path, file_path, mod_source, mod_program));
        modules.extend(nested);
    }

    Ok(modules)
}

/// Find a module file given a directory and module name.
/// Looks for `name.fg` or `name/mod.fg` (like Rust).
fn find_mod_file(dir: &Path, name: &str, declaring_file: &Path) -> Result<PathBuf, CompileError> {
    let sibling = dir.join(format!("{}.fg", name));
    let dir_mod = dir.join(name).join("mod.fg");

    let sibling_exists = sibling.exists();
    let dir_mod_exists = dir_mod.exists();

    if sibling_exists && dir_mod_exists {
        return Err(CompileError::CliError {
            message: format!(
                "ambiguous module '{}': both {}.fg and {}/mod.fg exist",
                name, name, name
            ),
            help: Some("remove one of the two files to resolve the ambiguity".to_string()),
        });
    }

    if sibling_exists {
        Ok(sibling)
    } else if dir_mod_exists {
        Ok(dir_mod)
    } else {
        Err(CompileError::CliError {
            message: format!("cannot find module '{}'", name),
            help: Some(format!(
                "to declare `mod {}` in {}, create {}.fg or {}/mod.fg",
                name,
                declaring_file.display(),
                name,
                name,
            )),
        })
    }
}

/// Parse a module source file, returning (source, program).
/// If a component registry is provided, the parser will recognize component blocks.
fn parse_module_file(
    file_path: &Path,
    component_registry: &HashMap<String, ComponentMeta>,
) -> Result<(String, Program), CompileError> {
    let source = std::fs::read_to_string(file_path).map_err(|e| CompileError::FileNotFound {
        path: file_path.display().to_string(),
        detail: e.to_string(),
    })?;

    let mut lexer = Lexer::new(&source);
    let tokens = lexer.tokenize();
    let mut parser = if component_registry.is_empty() {
        Parser::new(tokens)
    } else {
        Parser::new_with_components(tokens, component_registry.clone())
    };
    let program = parser.parse_program();

    let parse_errors: Vec<_> = parser
        .diagnostics()
        .iter()
        .filter(|d| d.severity == crate::errors::Severity::Error)
        .collect();
    if !parse_errors.is_empty() {
        let msgs: Vec<String> = parse_errors.iter().map(|d| d.message.clone()).collect();
        return Err(CompileError::CliError {
            message: format!("errors in {}: {}", file_path.display(), msgs.join("; ")),
            help: None,
        });
    }

    Ok((source, program))
}

/// Resolve `use` statements in a program against the module exports.
pub fn resolve_use_statements(
    program: &Program,
    module_exports: &HashMap<String, Vec<ExportedSymbol>>,
) -> Result<Vec<ResolvedImport>, String> {
    let mut imports = Vec::new();

    for stmt in &program.statements {
        // Extract path and items from Use statement (old or new Feature variant)
        let (path, items) = match stmt {
            Statement::Use { path, items, .. } => (path.clone(), items.clone()),
            Statement::Feature(fe) if fe.feature_id == "imports" && fe.kind == "Use" => {
                use crate::feature_data;
                use crate::features::imports::types::UseData;
                if let Some(data) = feature_data!(fe, UseData) {
                    (data.path.clone(), data.items.clone())
                } else {
                    continue;
                }
            }
            _ => continue,
        };
        // Skip package use statements (e.g., use @std.model)
        if !path.is_empty() && path[0].starts_with('@') {
            continue;
        }

        let module_path = path.join(".");

        let exports = module_exports
            .get(&module_path)
            .ok_or_else(|| format!("unresolved module: {} (did you forget `mod {}`?)", module_path, path[0]))?;

        if items.is_empty() {
            // For the path-only case, module is path[..n-1], item is path[n-1]
            if path.len() >= 2 {
                let mod_path = path[..path.len() - 1].join(".");
                let item_name = path.last().unwrap();

                let mod_exports = module_exports
                    .get(&mod_path)
                    .ok_or_else(|| format!("unresolved module: {} (did you forget `mod {}`?)", mod_path, path[0]))?;

                let sym = mod_exports
                    .iter()
                    .find(|e| match e {
                        ExportedSymbol::Function { name, .. } => name == item_name,
                        ExportedSymbol::Value { name, .. } => name == item_name,
                        ExportedSymbol::ComponentBlock { name, .. } => name == item_name,
                        ExportedSymbol::TypeDecl { name, .. } => name == item_name,
                        ExportedSymbol::EnumDecl { name, .. } => name == item_name,
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
            for item in &items {
                let sym = exports
                    .iter()
                    .find(|e| match e {
                        ExportedSymbol::Function { name, .. } => name == &item.name,
                        ExportedSymbol::Value { name, .. } => name == &item.name,
                        ExportedSymbol::ComponentBlock { name, .. } => name == &item.name,
                        ExportedSymbol::TypeDecl { name, .. } => name == &item.name,
                        ExportedSymbol::EnumDecl { name, .. } => name == &item.name,
                    })
                    .ok_or_else(|| {
                        format!(
                            "symbol `{}` is not exported from module `{}`",
                            item.name, module_path
                        )
                    })?;

                let local_name = item.alias.clone().unwrap_or_else(|| item.name.clone());
                let mangled = format!("{}_{}", module_path.replace('.', "_"), item.name);
                imports.push(ResolvedImport {
                    local_name,
                    mangled_name: mangled,
                    symbol: sym.clone(),
                });
            }
        }
    }

    Ok(imports)
}

/// Result of resolving all module imports for a program and its sub-modules.
pub struct ModuleImportResult {
    /// Imports resolved for the main program.
    pub main_imports: Vec<ResolvedImport>,
}

/// Resolve all module imports: collect exports, bubble them up, resolve imports
/// for the main program and all sub-modules, and inject imported function bodies
/// into sub-module programs so exported components are self-contained.
///
/// This is the single entry point the driver calls for module import resolution.
pub fn resolve_all_imports(
    program: &mut Program,
    local_modules: &mut [(String, PathBuf, String, Program)],
) -> Result<ModuleImportResult, CompileError> {
    // 1. Collect exports from each module
    let mut module_exports: HashMap<String, Vec<ExportedSymbol>> = HashMap::new();
    for (module_path, _file_path, _source, mod_program) in local_modules.iter() {
        let exports = collect_exports(mod_program);
        module_exports.insert(module_path.clone(), exports);
    }

    // 2. Bubble sub-module exports up to parent modules.
    //    E.g., exports from "commands.build" become available via "commands".
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

    // 3. Resolve imports for each sub-module and inject function bodies.
    //    Track per-module imports so we can carry transitive deps when component
    //    blocks from sub-modules are placed into the main program.
    //
    //    Snapshot module statements first for lookup during injection.
    let module_stmts: Vec<Vec<Statement>> = local_modules.iter()
        .map(|(_, _, _, prog)| prog.statements.clone())
        .collect();

    let mut sub_module_imports: HashMap<String, Vec<ResolvedImport>> = HashMap::new();
    for (module_path, _file_path, _source, mod_program) in local_modules.iter_mut() {
        let mod_imports = resolve_use_statements(mod_program, &module_exports).unwrap_or_default();
        inject_imports_into_program(mod_program, &mod_imports, &module_stmts);
        sub_module_imports.insert(module_path.clone(), mod_imports);
    }

    // 4. Resolve the main program's own imports
    let main_imports = resolve_use_statements(program, &module_exports)
        .map_err(|e| CompileError::CliError { message: e, help: None })?;

    // 5. Inject imported functions into the main program
    inject_imports_into_program(program, &main_imports, &module_stmts);

    // 6. Inject transitive dependencies: when the main program imports a component
    //    block from a sub-module, that component's body may reference functions the
    //    sub-module imported. Also inject all exported functions from the source
    //    modules of those imports (to cover intra-module calls like forward→core_bin).
    let mut transitive_imports = Vec::new();
    let mut seen_transitive: HashSet<String> = HashSet::new();
    let mut injected_modules: HashSet<String> = HashSet::new();
    for imp in &main_imports {
        if let ExportedSymbol::ComponentBlock { .. } = &imp.symbol {
            // Find which module this component came from
            for (mod_path, mod_imports) in &sub_module_imports {
                if imp.mangled_name.starts_with(&mod_path.replace('.', "_")) {
                    // Inject all of this sub-module's imports (deduplicated)
                    for mod_imp in mod_imports {
                        if let ExportedSymbol::Function { .. } = &mod_imp.symbol {
                            if seen_transitive.insert(mod_imp.local_name.clone()) {
                                transitive_imports.push(mod_imp.clone());
                            }
                            // Also inject all exports from the source module of each import
                            // to handle intra-module deps (e.g. forward calls core_bin)
                            let source_mod = mod_imp.mangled_name
                                .rsplit_once('_')
                                .map(|(prefix, _)| prefix.replace('_', "."))
                                .unwrap_or_default();
                            if !source_mod.is_empty() {
                                injected_modules.insert(source_mod);
                            }
                        }
                    }
                }
            }
        }
    }
    // For each source module identified, inject ALL its exported functions
    for mod_path in &injected_modules {
        if let Some(exports) = module_exports.get(mod_path) {
            for sym in exports {
                if let ExportedSymbol::Function { name, .. } = sym {
                    // Check if already in transitive_imports to avoid duplicates
                    let already = transitive_imports.iter().any(|i| i.local_name == *name);
                    if !already {
                        transitive_imports.push(ResolvedImport {
                            local_name: name.clone(),
                            mangled_name: format!("{}_{}", mod_path.replace('.', "_"), name),
                            symbol: sym.clone(),
                        });
                    }
                }
            }
        }
    }
    if !transitive_imports.is_empty() {
        inject_imports_into_program(program, &transitive_imports, &module_stmts);
    }

    Ok(ModuleImportResult { main_imports })
}

/// Inject imported function bodies from modules into a program's AST.
fn inject_imports_into_program(
    program: &mut Program,
    imports: &[ResolvedImport],
    module_stmts: &[Vec<Statement>],
) {
    for imp in imports {
        // Inject type/enum declarations directly into the program
        if let ExportedSymbol::TypeDecl { stmt, .. } | ExportedSymbol::EnumDecl { stmt, .. } = &imp.symbol {
            program.statements.insert(0, stmt.clone());
            continue;
        }

        if let ExportedSymbol::Function { name, params, return_type, .. } = &imp.symbol {
            'outer: for stmts in module_stmts {
                for stmt in stmts {
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
                        break 'outer;
                    }
                }
            }
        }
    }
}
