//! Feature infrastructure for the modular compiler architecture.
//!
//! Every language feature (closures, defer, pattern matching, etc.) implements
//! the `LanguageFeature` trait and self-registers via `inventory`. Core dispatches
//! to features without knowing about them at compile time.

use std::any::Any;
use std::collections::HashMap;

use crate::lexer::Span;
use crate::registry::FeatureMetadata;

// ─── Open AST Types ──────────────────────────────────────────────────────────

/// Trait that all feature AST node data implements.
/// Features define their own data structs and implement this trait
/// (typically via `impl_feature_node!`).
pub trait FeatureNode: std::fmt::Debug {
    fn as_any(&self) -> &dyn Any;
    fn clone_box(&self) -> Box<dyn FeatureNode>;
}

impl Clone for Box<dyn FeatureNode> {
    fn clone(&self) -> Self {
        self.clone_box()
    }
}

/// A feature-owned AST expression node.
///
/// Used as `Expr::Feature(FeatureExpr)` — the extension point that lets
/// features add new expression types without modifying core's `Expr` enum.
#[derive(Debug, Clone)]
pub struct FeatureExpr {
    /// Which feature owns this node (e.g., "closures", "pipe_operator")
    pub feature_id: &'static str,
    /// The kind of node within that feature (e.g., "Closure", "Pipe")
    pub kind: &'static str,
    /// The actual data, downcast by the owning feature
    pub data: Box<dyn FeatureNode>,
    /// Source location
    pub span: Span,
}

/// A feature-owned AST statement node.
///
/// Used as `Statement::Feature(FeatureStmt)` — the extension point that lets
/// features add new statement types without modifying core's `Statement` enum.
#[derive(Debug, Clone)]
pub struct FeatureStmt {
    /// Which feature owns this node (e.g., "defer", "select_syntax")
    pub feature_id: &'static str,
    /// The kind of node within that feature (e.g., "Defer", "Select")
    pub kind: &'static str,
    /// The actual data, downcast by the owning feature
    pub data: Box<dyn FeatureNode>,
    /// Source location
    pub span: Span,
}

/// Helper macro to implement `FeatureNode` for a type.
///
/// Usage:
/// ```rust,ignore
/// #[derive(Debug, Clone)]
/// pub struct ClosureData {
///     pub params: Vec<Param>,
///     pub body: Box<Expr>,
/// }
/// impl_feature_node!(ClosureData);
/// ```
#[macro_export]
macro_rules! impl_feature_node {
    ($ty:ty) => {
        impl $crate::feature::FeatureNode for $ty {
            fn as_any(&self) -> &dyn std::any::Any {
                self
            }
            fn clone_box(&self) -> Box<dyn $crate::feature::FeatureNode> {
                Box::new(self.clone())
            }
        }
    };
}

/// Helper macro for downcasting FeatureExpr/FeatureStmt data to a concrete type.
///
/// Usage:
/// ```rust,ignore
/// let data = feature_data!(fe, ClosureData)?;
/// ```
#[macro_export]
macro_rules! feature_data {
    ($node:expr, $ty:ty) => {
        $node.data.as_any().downcast_ref::<$ty>()
    };
}

// ─── Keyword Registry ────────────────────────────────────────────────────────

/// Lightweight ID for feature-registered keywords.
/// Features declare these as constants; the lexer maps identifier text to KeywordId.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct KeywordId(pub u16);

/// Registry that maps keyword strings to KeywordIds.
/// Built during compiler init from all registered features.
pub struct KeywordRegistry {
    keywords: HashMap<&'static str, KeywordId>,
}

impl KeywordRegistry {
    pub fn new() -> Self {
        Self {
            keywords: HashMap::new(),
        }
    }

    pub fn register(&mut self, keyword: &'static str, id: KeywordId) {
        self.keywords.insert(keyword, id);
    }

    pub fn lookup(&self, text: &str) -> Option<KeywordId> {
        self.keywords.get(text).copied()
    }

    /// Build from all registered language features.
    pub fn from_features() -> Self {
        let mut registry = Self::new();
        for entry in inventory::iter::<LanguageFeatureEntry> {
            for &(keyword, id) in entry.feature.keywords() {
                registry.register(keyword, id);
            }
        }
        registry
    }
}

// ─── Intrinsic Registry ──────────────────────────────────────────────────────

/// Identifies which feature handles a particular method on a type.
#[derive(Debug, Clone)]
pub struct IntrinsicMethod {
    pub feature_id: &'static str,
    pub method_name: &'static str,
}

/// Registry for built-in methods on types (string.length, list.map, etc.)
/// and standalone intrinsic functions (validate, json.parse, etc.).
///
/// Features register their intrinsics during init. Core's codegen dispatches
/// method calls through this registry.
pub struct IntrinsicRegistry {
    /// (type_name, method_name) → feature_id
    methods: HashMap<(&'static str, &'static str), &'static str>,
    /// function_name → feature_id
    functions: HashMap<&'static str, &'static str>,
    /// namespace.method → feature_id (e.g., "json.parse" → "json_builtins")
    static_methods: HashMap<(&'static str, &'static str), &'static str>,
}

impl IntrinsicRegistry {
    pub fn new() -> Self {
        Self {
            methods: HashMap::new(),
            functions: HashMap::new(),
            static_methods: HashMap::new(),
        }
    }

    /// Register a method on a type (e.g., "string", "length" → "string_methods")
    pub fn register_method(
        &mut self,
        type_name: &'static str,
        method_name: &'static str,
        feature_id: &'static str,
    ) {
        self.methods.insert((type_name, method_name), feature_id);
    }

    /// Register a standalone function (e.g., "validate" → "validate")
    pub fn register_function(&mut self, name: &'static str, feature_id: &'static str) {
        self.functions.insert(name, feature_id);
    }

    /// Register a static/namespace method (e.g., "json", "parse" → "json_builtins")
    pub fn register_static_method(
        &mut self,
        namespace: &'static str,
        method: &'static str,
        feature_id: &'static str,
    ) {
        self.static_methods.insert((namespace, method), feature_id);
    }

    /// Look up which feature handles a method on a type
    pub fn get_method(&self, type_name: &str, method_name: &str) -> Option<&'static str> {
        self.methods.get(&(type_name, method_name)).copied()
    }

    /// Look up which feature handles a standalone function
    pub fn get_function(&self, name: &str) -> Option<&'static str> {
        self.functions.get(name).copied()
    }

    /// Look up which feature handles a static method
    pub fn get_static_method(&self, namespace: &str, method: &str) -> Option<&'static str> {
        self.static_methods.get(&(namespace, method)).copied()
    }

    /// Build from all registered language features.
    pub fn from_features() -> Self {
        let mut registry = Self::new();
        for entry in inventory::iter::<LanguageFeatureEntry> {
            entry.feature.register_intrinsics(&mut registry);
        }
        registry
    }
}

// ─── Language Feature Trait ──────────────────────────────────────────────────

/// The core trait that every language feature implements.
///
/// Features self-register via `inventory` and are discovered at link time.
/// Core dispatches to features through this trait for parsing, type-checking,
/// and intrinsic registration. Codegen dispatch uses `impl Codegen<'ctx>`
/// blocks (since Codegen has an LLVM lifetime parameter).
pub trait LanguageFeature: Send + Sync + 'static {
    /// Feature metadata (name, id, status, deps, description)
    fn metadata(&self) -> &FeatureMetadata;

    /// Keywords this feature adds to the language.
    /// The lexer checks these when it encounters an identifier.
    fn keywords(&self) -> &[(&'static str, KeywordId)] {
        &[]
    }

    /// Register built-in methods/functions this feature provides.
    /// Called once during compiler init.
    fn register_intrinsics(&self, _registry: &mut IntrinsicRegistry) {}
}

/// Entry in the global feature registry, collected by `inventory` at link time.
pub struct LanguageFeatureEntry {
    pub feature: Box<dyn LanguageFeature>,
}

inventory::collect!(LanguageFeatureEntry);

/// Get all registered language features
pub fn all_features() -> impl Iterator<Item = &'static LanguageFeatureEntry> {
    inventory::iter::<LanguageFeatureEntry>.into_iter()
}

// ─── Feature Expr/Stmt Dispatch Helpers ──────────────────────────────────────

// Codegen dispatch: features add `impl Codegen<'ctx>` blocks with
// `compile_<feature>_expr` methods. See codegen/expressions.rs for
// the `Expr::Feature` match arm that dispatches by feature_id.
