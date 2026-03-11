use crate::lexer::Lexer;
use crate::parser::ast::Statement;
use crate::parser::Parser;
use serde::Deserialize;
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
    /// Path to the native library (.a file)
    pub lib_path: PathBuf,
}

#[derive(Debug, Deserialize)]
struct ProviderToml {
    provider: ProviderMeta,
    native: Option<NativeMeta>,
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

    // Parse provider.fg to extract extern fn declarations
    let fg_path = provider_dir.join("src/provider.fg");
    let extern_fns = if fg_path.exists() {
        let source = std::fs::read_to_string(&fg_path)
            .map_err(|e| format!("cannot read {}: {}", fg_path.display(), e))?;
        parse_extern_fns(&source)
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
        extern_fns,
        lib_path,
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

/// Parse a provider.fg file and extract only ExternFn statements
fn parse_extern_fns(source: &str) -> Vec<Statement> {
    let mut lexer = Lexer::new(source);
    let tokens = lexer.tokenize();
    let mut parser = Parser::new(tokens);
    let program = parser.parse_program();

    program
        .statements
        .into_iter()
        .filter(|s| matches!(s, Statement::ExternFn { .. }))
        .collect()
}
