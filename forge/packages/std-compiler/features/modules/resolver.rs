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
