use crate::lexer::Lexer;
use crate::parser::ast::{ComponentTemplateDef, Statement};
use crate::parser::{ComponentKind, ComponentMeta, Parser};
use serde::Deserialize;
use std::collections::HashMap;
use std::path::{Path, PathBuf};

/// Information about a loaded provider
#[derive(Debug, Clone)]
pub struct ProviderInfo {
    /// Provider name (e.g., "model")
    pub name: String,
    /// Provider namespace (e.g., "std")
    pub namespace: String,
    /// Native library name (e.g., "forge_model")
    pub native_lib: String,
    /// Extern fn declarations from provider.fg
    pub extern_fns: Vec<Statement>,
    /// Exported fn declarations from provider.fg (become static methods on the provider name)
    pub exported_fns: Vec<Statement>,
    /// Component template definitions from provider.fg
    pub component_templates: Vec<ComponentTemplateDef>,
    /// Path to the native library (.a file)
    pub lib_path: PathBuf,
    /// Component metadata from provider.toml
    pub component_metas: Vec<ComponentMeta>,
}

#[derive(Debug, Deserialize)]
struct ProviderToml {
    provider: ProviderMeta,
    native: Option<NativeMeta>,
    components: Option<HashMap<String, ComponentToml>>,
}

#[derive(Debug, Deserialize)]
struct ProviderMeta {
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

/// Load a provider from its directory
pub fn load_provider(provider_dir: &Path) -> Result<ProviderInfo, String> {
    // Read provider.toml
    let toml_path = provider_dir.join("provider.toml");
    let toml_content = std::fs::read_to_string(&toml_path)
        .map_err(|e| format!("cannot read {}: {}", toml_path.display(), e))?;

    let config: ProviderToml = toml::from_str(&toml_content)
        .map_err(|e| format!("invalid provider.toml at {}: {}", toml_path.display(), e))?;

    let native_lib = config
        .native
        .as_ref()
        .map(|n| n.library.clone())
        .unwrap_or_default();

    // Parse provider.fg to extract extern fn declarations and component templates
    let fg_path = provider_dir.join("src/provider.fg");
    let extern_fns = if fg_path.exists() {
        let source = std::fs::read_to_string(&fg_path)
            .map_err(|e| format!("cannot read {}: {}", fg_path.display(), e))?;
        parse_provider_fg(&source)
    } else {
        (Vec::new(), Vec::new(), Vec::new())
    };

    // Parse component metas from provider.toml
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
                ComponentMeta {
                    name: name.clone(),
                    kind: match kw.kind.as_str() {
                        "function" => ComponentKind::Function,
                        _ => ComponentKind::Block,
                    },
                    context: kw.context.clone(),
                    syntax: kw.syntax.clone(),
                    syntax_patterns,
                }
            })
            .collect()
    } else {
        Vec::new()
    };

    // Determine native library path
    let lib_path = provider_dir
        .join("target/release")
        .join(format!("lib{}.a", native_lib));

    Ok(ProviderInfo {
        name: config.provider.name,
        namespace: config.provider.namespace,
        native_lib,
        extern_fns: extern_fns.0,
        exported_fns: extern_fns.1,
        component_templates: extern_fns.2,
        lib_path,
        component_metas,
    })
}

/// Find a provider directory for a given namespace and name
/// Searches in the `providers/` directory relative to the project
pub fn find_provider(providers_base: &Path, namespace: &str, name: &str) -> Option<PathBuf> {
    // Convention: providers/{namespace}-{name}/
    let dir_name = format!("{}-{}", namespace, name);
    let provider_dir = providers_base.join(&dir_name);
    if provider_dir.exists() && provider_dir.join("provider.toml").exists() {
        Some(provider_dir)
    } else {
        None
    }
}

/// Parse a provider.fg file and extract ExternFn statements, exported FnDecls, and ComponentTemplateDefs
fn parse_provider_fg(source: &str) -> (Vec<Statement>, Vec<Statement>, Vec<ComponentTemplateDef>) {
    let mut lexer = Lexer::new(source);
    let tokens = lexer.tokenize();
    let mut parser = Parser::new(tokens);
    let program = parser.parse_program();

    let mut extern_fns = Vec::new();
    let templates_placeholder: Vec<Statement> = Vec::new();
    let mut templates = Vec::new();
    for stmt in program.statements {
        match &stmt {
            Statement::ExternFn { .. } => extern_fns.push(stmt),
            Statement::ComponentTemplateDef(_) => {
                if let Statement::ComponentTemplateDef(def) = stmt {
                    templates.push(def);
                }
            }
            _ => {}
        }
    }
    (extern_fns, templates_placeholder, templates)
}
