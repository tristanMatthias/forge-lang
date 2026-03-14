use crate::errors::Severity;
use crate::lexer::Lexer;
use crate::parser::ast::{ComponentTemplateDef, Statement};
use crate::parser::{ComponentKind, ComponentMeta, Parser};
use serde::Deserialize;
use std::collections::HashMap;
use std::path::{Path, PathBuf};

/// Information about a loaded package
#[derive(Debug, Clone)]
pub struct PackageInfo {
    /// Package name (e.g., "model")
    pub name: String,
    /// Package namespace (e.g., "std")
    pub namespace: String,
    /// Native library name (e.g., "forge_model")
    pub native_lib: String,
    /// Extern fn declarations from package.fg
    pub extern_fns: Vec<Statement>,
    /// Exported fn declarations from package.fg (become static methods on the package name)
    pub exported_fns: Vec<Statement>,
    /// Component template definitions from package.fg
    pub component_templates: Vec<ComponentTemplateDef>,
    /// Path to the native static library (.a file)
    pub lib_path: PathBuf,
    /// Path to the native shared library (.dylib/.so file) for JIT loading
    pub dylib_path: PathBuf,
    /// Component metadata from package.toml
    pub component_metas: Vec<ComponentMeta>,
}

#[derive(Debug, Deserialize)]
struct PackageToml {
    package: PackageMeta,
    native: Option<NativeMeta>,
    components: Option<HashMap<String, ComponentToml>>,
}

#[derive(Debug, Deserialize)]
struct PackageMeta {
    name: String,
    namespace: String,
    #[allow(dead_code)]
    version: String,
}

#[derive(Debug, Deserialize)]
struct NativeMeta {
    library: String,
}

#[derive(Debug, Deserialize)]
struct ComponentToml {
    kind: String,
    context: String,
    #[allow(dead_code)]
    syntax: Option<String>,
}

/// Load a package from its directory
pub fn load_package(package_dir: &Path) -> Result<PackageInfo, String> {
    // Read package.toml
    let toml_path = package_dir.join("package.toml");
    let toml_content = std::fs::read_to_string(&toml_path)
        .map_err(|e| format!("cannot read {}: {}", toml_path.display(), e))?;

    let config: PackageToml = toml::from_str(&toml_content)
        .map_err(|e| format!("invalid package.toml at {}: {}", toml_path.display(), e))?;

    let native_lib = config
        .native
        .as_ref()
        .map(|n| n.library.clone())
        .unwrap_or_default();

    // Parse package.fg to extract extern fn declarations and component templates
    let fg_path = package_dir.join("src/package.fg");
    let extern_fns = if fg_path.exists() {
        let source = std::fs::read_to_string(&fg_path)
            .map_err(|e| format!("cannot read {}: {}", fg_path.display(), e))?;
        parse_package_fg(&source)?
    } else {
        (Vec::new(), Vec::new(), Vec::new())
    };

    // Parse component metas from package.toml
    let component_metas = if let Some(components) = &config.components {
        components
            .iter()
            .map(|(name, kw)| {
                // Find syntax patterns from corresponding template
                let syntax_patterns: Vec<crate::parser::SyntaxPatternDef> = extern_fns.2
                    .iter()
                    .filter(|t| t.component_name == *name)
                    .flat_map(|t| t.syntax_fns.iter())
                    .map(|sf| crate::parser::SyntaxPatternDef {
                        pattern: sf.pattern.clone(),
                        fn_name: sf.fn_name.clone(),
                    })
                    .collect();
                // Find annotation declarations from corresponding template
                let annotation_decls: Vec<crate::parser::AnnotationDeclMeta> = extern_fns.2
                    .iter()
                    .filter(|t| t.component_name == *name)
                    .flat_map(|t| t.annotation_decls.iter())
                    .map(|ad| crate::parser::AnnotationDeclMeta {
                        target: ad.target.clone(),
                        name: ad.name.clone(),
                    })
                    .collect();
                ComponentMeta {
                    name: name.clone(),
                    kind: match kw.kind.as_str() {
                        "function" => ComponentKind::Function,
                        _ => ComponentKind::Block,
                    },
                    context: kw.context.clone(),
                    syntax: kw.syntax.clone(),
                    syntax_patterns,
                    annotation_decls,
                }
            })
            .collect()
    } else {
        Vec::new()
    };

    // Determine native library paths
    let release_dir = package_dir.join("target/release");
    let lib_path = release_dir.join(format!("lib{}.a", native_lib));
    let dylib_path = if cfg!(target_os = "macos") {
        release_dir.join(format!("lib{}.dylib", native_lib))
    } else {
        release_dir.join(format!("lib{}.so", native_lib))
    };

    Ok(PackageInfo {
        name: config.package.name,
        namespace: config.package.namespace,
        native_lib,
        extern_fns: extern_fns.0,
        exported_fns: extern_fns.1,
        component_templates: extern_fns.2,
        lib_path,
        dylib_path,
        component_metas,
    })
}

/// Find a package directory for a given namespace and name
/// Searches in the `packages/` directory relative to the project
pub fn find_package(packages_base: &Path, namespace: &str, name: &str) -> Option<PathBuf> {
    // Convention: packages/{namespace}-{name}/
    let dir_name = format!("{}-{}", namespace, name);
    let package_dir = packages_base.join(&dir_name);
    if package_dir.exists() && package_dir.join("package.toml").exists() {
        Some(package_dir)
    } else {
        None
    }
}

/// Parse a package.fg file and extract ExternFn statements, exported FnDecls, and ComponentTemplateDefs.
/// Returns an error if the package.fg has syntax errors — never silently ignores them.
fn parse_package_fg(source: &str) -> Result<(Vec<Statement>, Vec<Statement>, Vec<ComponentTemplateDef>), String> {
    let mut lexer = Lexer::new(source);
    let tokens = lexer.tokenize();

    // Check for lexer errors — never silently ignore syntax problems in package.fg
    let lex_errors: Vec<_> = lexer.diagnostics().iter()
        .filter(|d| d.severity == Severity::Error)
        .collect();
    if !lex_errors.is_empty() {
        let msgs: Vec<String> = lex_errors.iter().map(|d| d.message.clone()).collect();
        return Err(format!("syntax errors in package.fg: {}", msgs.join("; ")));
    }

    let mut parser = Parser::new(tokens);
    let program = parser.parse_program();

    // Check for parser errors — never silently ignore parse problems in package.fg
    let parse_errors: Vec<_> = parser.diagnostics().iter()
        .filter(|d| d.severity == Severity::Error)
        .collect();
    if !parse_errors.is_empty() {
        let msgs: Vec<String> = parse_errors.iter().map(|d| d.message.clone()).collect();
        return Err(format!("parse errors in package.fg: {}", msgs.join("; ")));
    }

    let mut extern_fns = Vec::new();
    let mut exported_fns = Vec::new();
    let mut templates = Vec::new();
    for stmt in program.statements {
        match &stmt {
            Statement::ExternFn { .. } => extern_fns.push(stmt),
            Statement::ComponentTemplateDef(_) => {
                if let Statement::ComponentTemplateDef(def) = stmt {
                    templates.push(def);
                }
            }
            Statement::FnDecl { exported: true, .. } => exported_fns.push(stmt),
            Statement::Feature(fe) if fe.feature_id == "functions" && fe.kind == "FnDecl" => {
                use crate::feature_data;
                use crate::features::functions::types::FnDeclData;
                if let Some(data) = feature_data!(&fe, FnDeclData) {
                    if data.exported {
                        exported_fns.push(stmt);
                    }
                }
            }
            _ => {}
        }
    }
    Ok((extern_fns, exported_fns, templates))
}
