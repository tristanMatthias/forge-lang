/// Feature registry system for Forge language features.
///
/// Each language feature registers its metadata via the `forge_feature!` macro.
/// The registry collects all features at link time using the `inventory` crate,
/// enabling `compiler features` to list all features with their status and dependencies.

/// Status of a language feature
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum FeatureStatus {
    /// Design only, no implementation
    Draft,
    /// Partially implemented
    Wip,
    /// Mostly working, under test
    Testing,
    /// Fully implemented and tested
    Stable,
}

impl std::fmt::Display for FeatureStatus {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            FeatureStatus::Draft => write!(f, "draft"),
            FeatureStatus::Wip => write!(f, "wip"),
            FeatureStatus::Testing => write!(f, "testing"),
            FeatureStatus::Stable => write!(f, "stable"),
        }
    }
}

/// Priority tier for category ordering in documentation output
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub enum CategoryPriority {
    /// Core language fundamentals that every user needs first (types, printing, comments)
    Core = 0,
    /// Primary language features (variables, functions, control flow, pattern matching)
    Primary = 1,
    /// Advanced features (concurrency, components, metaprogramming)
    Advanced = 2,
    /// Default — features that don't specify a priority
    Default = 3,
}

/// Metadata describing a language feature
#[derive(Debug, Clone)]
pub struct FeatureMetadata {
    pub name: &'static str,
    pub id: &'static str,
    pub status: FeatureStatus,
    pub depends: &'static [&'static str],
    pub enables: &'static [&'static str],
    pub tokens: &'static [&'static str],
    pub ast_nodes: &'static [&'static str],
    pub description: &'static str,
    pub syntax: &'static [&'static str],
    pub short: &'static str,
    pub symbols: &'static [&'static str],
    pub long_description: &'static str,
    pub grammar: &'static str,
    pub category: &'static str,
    /// Sort priority for the category (Core < Primary < Advanced < Default)
    pub category_order: CategoryPriority,
}

/// Entry in the global feature registry, collected by `inventory` at link time
pub struct FeatureEntry {
    pub metadata: FeatureMetadata,
}

inventory::collect!(FeatureEntry);

/// Feature registry providing access to all registered features
pub struct FeatureRegistry;

impl FeatureRegistry {
    /// Get all registered features
    pub fn all() -> Vec<&'static FeatureMetadata> {
        inventory::iter::<FeatureEntry>
            .into_iter()
            .map(|e| &e.metadata)
            .collect()
    }

    /// Get all features sorted by name
    pub fn all_sorted() -> Vec<&'static FeatureMetadata> {
        let mut features = Self::all();
        features.sort_by_key(|f| f.name);
        features
    }

    /// Find a feature by its id
    pub fn get(id: &str) -> Option<&'static FeatureMetadata> {
        Self::all().into_iter().find(|f| f.id == id)
    }

    /// Group features by their `category` field, sorted by minimum `category_order`.
    pub fn by_category() -> Vec<(&'static str, Vec<&'static FeatureMetadata>)> {
        let all = Self::all();
        let mut groups: std::collections::HashMap<&str, Vec<&FeatureMetadata>> =
            std::collections::HashMap::new();
        for f in &all {
            if !f.category.is_empty() {
                groups.entry(f.category).or_default().push(f);
            }
        }
        for v in groups.values_mut() {
            v.sort_by_key(|f| f.id);
        }
        let mut result: Vec<_> = groups.into_iter().collect();
        // Sort by minimum category_order in each group, then alphabetically by name
        result.sort_by(|(name_a, features_a), (name_b, features_b)| {
            let min_a = features_a.iter().map(|f| f.category_order).min().unwrap_or(CategoryPriority::Default);
            let min_b = features_b.iter().map(|f| f.category_order).min().unwrap_or(CategoryPriority::Default);
            min_a.cmp(&min_b).then_with(|| name_a.cmp(name_b))
        });
        result
    }

    /// Get features filtered by status
    pub fn by_status(status: FeatureStatus) -> Vec<&'static FeatureMetadata> {
        Self::all()
            .into_iter()
            .filter(|f| f.status == status)
            .collect()
    }

    /// Build a dependency graph as adjacency list (id -> Vec<depends_on_id>)
    pub fn dependency_graph() -> std::collections::HashMap<&'static str, Vec<&'static str>> {
        let mut graph = std::collections::HashMap::new();
        for f in Self::all() {
            graph.insert(f.id, f.depends.to_vec());
        }
        graph
    }

    /// Print the feature table (used by `compiler features`)
    pub fn print_table() {
        let features = Self::all_sorted();
        let example_counts = crate::test_runner::get_all_module_example_counts();
        let example_map: std::collections::HashMap<&str, usize> = example_counts
            .iter()
            .map(|(f, count)| (f.as_str(), *count))
            .collect();

        let mut stable = 0u32;
        let mut testing = 0u32;
        let mut wip = 0u32;
        let mut draft = 0u32;

        println!("  {:<28} {:<10} {:<10} {}", "Feature", "Status", "Examples", "Deps");
        println!("  {}", "─".repeat(70));

        for f in &features {
            let count = example_map.get(f.id).copied().unwrap_or(0);

            let status_icon = match f.status {
                FeatureStatus::Stable => "\x1b[32m✓\x1b[0m",
                FeatureStatus::Testing => "\x1b[33m●\x1b[0m",
                FeatureStatus::Wip => "\x1b[33m●\x1b[0m",
                FeatureStatus::Draft => "\x1b[90m○\x1b[0m",
            };

            let examples_str = if count > 0 {
                format!("{}", count)
            } else {
                "-".to_string()
            };

            let deps = if f.depends.is_empty() {
                "-".to_string()
            } else {
                f.depends.join(", ")
            };

            println!(
                "  {:<28} {:<10} {:>5} {}  {}",
                f.id,
                f.status,
                examples_str,
                status_icon,
                deps
            );

            match f.status {
                FeatureStatus::Stable => stable += 1,
                FeatureStatus::Testing => testing += 1,
                FeatureStatus::Wip => wip += 1,
                FeatureStatus::Draft => draft += 1,
            }
        }

        let total = features.len();
        println!();
        println!(
            "  {} features | {} stable | {} testing | {} wip | {} draft",
            total, stable, testing, wip, draft
        );
    }

    /// Print the dependency graph (used by `compiler features --graph`)
    pub fn print_graph() {
        let features = Self::all_sorted();
        let enables_map: std::collections::HashMap<&str, Vec<&str>> = {
            let mut map = std::collections::HashMap::new();
            for f in &features {
                for dep in f.depends {
                    map.entry(*dep).or_insert_with(Vec::new).push(f.id);
                }
            }
            map
        };

        // Find root features (no dependencies)
        let roots: Vec<&&FeatureMetadata> = features
            .iter()
            .filter(|f| f.depends.is_empty())
            .collect();

        // Features with dependencies
        let with_deps: Vec<&&FeatureMetadata> = features
            .iter()
            .filter(|f| !f.depends.is_empty())
            .collect();

        // Print tree from roots that have dependents
        let has_dependents: Vec<&&FeatureMetadata> = roots
            .iter()
            .filter(|f| enables_map.contains_key(f.id))
            .copied()
            .collect();

        for root in &has_dependents {
            Self::print_tree_node(root.id, &enables_map, 0);
        }

        // Print standalone features
        let standalone: Vec<&&FeatureMetadata> = roots
            .iter()
            .filter(|f| !enables_map.contains_key(f.id))
            .copied()
            .collect();

        if !standalone.is_empty() {
            println!();
            println!("  (standalone)");
            for f in &standalone {
                println!("  ├── {}", f.id);
            }
        }

        // Print features whose dependencies aren't all registered
        if !with_deps.is_empty() {
            let all_ids: std::collections::HashSet<&str> =
                features.iter().map(|f| f.id).collect();
            let orphans: Vec<&&FeatureMetadata> = with_deps
                .iter()
                .filter(|f| f.depends.iter().any(|d| !all_ids.contains(d)))
                .copied()
                .collect();
            if !orphans.is_empty() {
                println!();
                println!("  (external deps)");
                for f in &orphans {
                    println!("  ├── {} → [{}]", f.id, f.depends.join(", "));
                }
            }
        }
    }

    fn print_tree_node(
        id: &str,
        enables_map: &std::collections::HashMap<&str, Vec<&str>>,
        depth: usize,
    ) {
        let indent = if depth == 0 {
            "  ".to_string()
        } else {
            format!("  {}├── ", "│   ".repeat(depth - 1))
        };

        if let Some(children) = enables_map.get(id) {
            println!("{}{}", indent, id);
            for child in children {
                Self::print_tree_node(child, enables_map, depth + 1);
            }
        } else {
            println!("{}{}", indent, id);
        }
    }

    /// Print detailed info for a single feature
    pub fn print_detail(id: &str) {
        let f = match Self::get(id) {
            Some(f) => f,
            None => {
                let err = crate::errors::CompileError::CliError {
                    message: format!("unknown feature '{}'", id),
                    help: Some("run `compiler features` to see all available features".to_string()),
                };
                eprint!("{}", err.render());
                return;
            }
        };

        println!("  {} ({})", f.name, f.status);
        println!("  {}", "─".repeat(40));
        println!("  {}", f.description);
        println!();

        if !f.tokens.is_empty() {
            println!("  Tokens:  {}", f.tokens.join("  "));
        }
        if !f.ast_nodes.is_empty() {
            println!("  AST:     {}", f.ast_nodes.join(", "));
        }
        if !f.depends.is_empty() {
            println!("  Depends: {}", f.depends.join(", "));
        }
        if !f.enables.is_empty() {
            println!("  Enables: {}", f.enables.join(", "));
        }

        // Show test counts for this feature only
        if let Some(features_dir) = crate::test_runner::find_modules_dir() {
            let (passed, total) = crate::test_runner::count_module_tests(&features_dir, id);
            if total > 0 {
                println!();
                let color = if passed == total { "\x1b[32m" } else { "\x1b[33m" };
                println!("  Tests: {}{}/{} passing\x1b[0m", color, passed, total);
            }
        }

        println!();
        println!("  Source: packages/forgec/features/{}/mod.rs", f.id);

        // List example files
        let examples_dir = std::path::PathBuf::from(format!("packages/forgec/features/{}/examples", f.id));
        if examples_dir.is_dir() {
            if let Ok(entries) = std::fs::read_dir(&examples_dir) {
                let mut files: Vec<_> = entries
                    .filter_map(|e| e.ok())
                    .filter(|e| {
                        e.path().extension().and_then(|x| x.to_str()) == Some("fg")
                    })
                    .collect();
                files.sort_by_key(|e| e.file_name());

                if !files.is_empty() {
                    println!();
                    println!("  Examples:");
                    for entry in &files {
                        let path = entry.path();
                        let name = path.file_name().unwrap_or_default().to_string_lossy();
                        // Extract title from first /// # comment
                        if let Ok(source) = std::fs::read_to_string(&path) {
                            let title = source
                                .lines()
                                .find_map(|l| l.trim().strip_prefix("/// # "))
                                .unwrap_or("");
                            if title.is_empty() {
                                println!("    {}", name);
                            } else {
                                println!("    {:<24} -- {}", name, title);
                            }
                        } else {
                            println!("    {}", name);
                        }
                    }
                }
            }
        }
    }
}

/// Macro for declaring a language feature with metadata.
///
/// Usage:
/// ```rust,ignore
/// forge_feature! {
///     name: "Pipe Operator",
///     id: "pipe_operator",
///     status: Stable,
///     depends: [],
///     enables: [],
///     tokens: ["|>"],
///     ast_nodes: ["Pipe"],
///     description: "Pipe operator for function chaining",
/// }
/// ```
#[macro_export]
macro_rules! forge_feature {
    // Full form with category_order
    (
        name: $name:expr,
        id: $id:expr,
        status: $status:ident,
        depends: [$($dep:expr),* $(,)?],
        enables: [$($en:expr),* $(,)?],
        tokens: [$($tok:expr),* $(,)?],
        ast_nodes: [$($node:expr),* $(,)?],
        description: $desc:expr,
        syntax: [$($syn:expr),* $(,)?],
        short: $short:expr,
        symbols: [$($sym:expr),* $(,)?],
        long_description: $long_desc:expr,
        grammar: $grammar:expr,
        category: $category:expr,
        category_order: $order:ident $(,)?
    ) => {
        inventory::submit! {
            $crate::registry::FeatureEntry {
                metadata: $crate::registry::FeatureMetadata {
                    name: $name,
                    id: $id,
                    status: $crate::registry::FeatureStatus::$status,
                    depends: &[$($dep),*],
                    enables: &[$($en),*],
                    tokens: &[$($tok),*],
                    ast_nodes: &[$($node),*],
                    description: $desc,
                    syntax: &[$($syn),*],
                    short: $short,
                    symbols: &[$($sym),*],
                    long_description: $long_desc,
                    grammar: $grammar,
                    category: $category,
                    category_order: $crate::registry::CategoryPriority::$order,
                },
            }
        }
    };
    // Full form with all fields
    (
        name: $name:expr,
        id: $id:expr,
        status: $status:ident,
        depends: [$($dep:expr),* $(,)?],
        enables: [$($en:expr),* $(,)?],
        tokens: [$($tok:expr),* $(,)?],
        ast_nodes: [$($node:expr),* $(,)?],
        description: $desc:expr,
        syntax: [$($syn:expr),* $(,)?],
        short: $short:expr,
        symbols: [$($sym:expr),* $(,)?],
        long_description: $long_desc:expr,
        grammar: $grammar:expr,
        category: $category:expr $(,)?
    ) => {
        inventory::submit! {
            $crate::registry::FeatureEntry {
                metadata: $crate::registry::FeatureMetadata {
                    name: $name,
                    id: $id,
                    status: $crate::registry::FeatureStatus::$status,
                    depends: &[$($dep),*],
                    enables: &[$($en),*],
                    tokens: &[$($tok),*],
                    ast_nodes: &[$($node),*],
                    description: $desc,
                    syntax: &[$($syn),*],
                    short: $short,
                    symbols: &[$($sym),*],
                    long_description: $long_desc,
                    grammar: $grammar,
                    category: $category,
                    category_order: $crate::registry::CategoryPriority::Default,
                },
            }
        }
    };
    // Form with grammar but no category
    (
        name: $name:expr,
        id: $id:expr,
        status: $status:ident,
        depends: [$($dep:expr),* $(,)?],
        enables: [$($en:expr),* $(,)?],
        tokens: [$($tok:expr),* $(,)?],
        ast_nodes: [$($node:expr),* $(,)?],
        description: $desc:expr,
        syntax: [$($syn:expr),* $(,)?],
        short: $short:expr,
        symbols: [$($sym:expr),* $(,)?],
        long_description: $long_desc:expr,
        grammar: $grammar:expr $(,)?
    ) => {
        inventory::submit! {
            $crate::registry::FeatureEntry {
                metadata: $crate::registry::FeatureMetadata {
                    name: $name,
                    id: $id,
                    status: $crate::registry::FeatureStatus::$status,
                    depends: &[$($dep),*],
                    enables: &[$($en),*],
                    tokens: &[$($tok),*],
                    ast_nodes: &[$($node),*],
                    description: $desc,
                    syntax: &[$($syn),*],
                    short: $short,
                    symbols: &[$($sym),*],
                    long_description: $long_desc,
                    grammar: $grammar,
                    category: "",
                    category_order: $crate::registry::CategoryPriority::Default,
                },
            }
        }
    };
    // Form with long_description + category + category_order (no grammar)
    (
        name: $name:expr,
        id: $id:expr,
        status: $status:ident,
        depends: [$($dep:expr),* $(,)?],
        enables: [$($en:expr),* $(,)?],
        tokens: [$($tok:expr),* $(,)?],
        ast_nodes: [$($node:expr),* $(,)?],
        description: $desc:expr,
        syntax: [$($syn:expr),* $(,)?],
        short: $short:expr,
        symbols: [$($sym:expr),* $(,)?],
        long_description: $long_desc:expr,
        category: $category:expr,
        category_order: $order:ident $(,)?
    ) => {
        inventory::submit! {
            $crate::registry::FeatureEntry {
                metadata: $crate::registry::FeatureMetadata {
                    name: $name,
                    id: $id,
                    status: $crate::registry::FeatureStatus::$status,
                    depends: &[$($dep),*],
                    enables: &[$($en),*],
                    tokens: &[$($tok),*],
                    ast_nodes: &[$($node),*],
                    description: $desc,
                    syntax: &[$($syn),*],
                    short: $short,
                    symbols: &[$($sym),*],
                    long_description: $long_desc,
                    grammar: "",
                    category: $category,
                    category_order: $crate::registry::CategoryPriority::$order,
                },
            }
        }
    };
    // Form with long_description + category (no grammar)
    (
        name: $name:expr,
        id: $id:expr,
        status: $status:ident,
        depends: [$($dep:expr),* $(,)?],
        enables: [$($en:expr),* $(,)?],
        tokens: [$($tok:expr),* $(,)?],
        ast_nodes: [$($node:expr),* $(,)?],
        description: $desc:expr,
        syntax: [$($syn:expr),* $(,)?],
        short: $short:expr,
        symbols: [$($sym:expr),* $(,)?],
        long_description: $long_desc:expr,
        category: $category:expr $(,)?
    ) => {
        inventory::submit! {
            $crate::registry::FeatureEntry {
                metadata: $crate::registry::FeatureMetadata {
                    name: $name,
                    id: $id,
                    status: $crate::registry::FeatureStatus::$status,
                    depends: &[$($dep),*],
                    enables: &[$($en),*],
                    tokens: &[$($tok),*],
                    ast_nodes: &[$($node),*],
                    description: $desc,
                    syntax: &[$($syn),*],
                    short: $short,
                    symbols: &[$($sym),*],
                    long_description: $long_desc,
                    grammar: "",
                    category: $category,
                    category_order: $crate::registry::CategoryPriority::Default,
                },
            }
        }
    };
    // Extended form with long_description only (no grammar, no category)
    (
        name: $name:expr,
        id: $id:expr,
        status: $status:ident,
        depends: [$($dep:expr),* $(,)?],
        enables: [$($en:expr),* $(,)?],
        tokens: [$($tok:expr),* $(,)?],
        ast_nodes: [$($node:expr),* $(,)?],
        description: $desc:expr,
        syntax: [$($syn:expr),* $(,)?],
        short: $short:expr,
        symbols: [$($sym:expr),* $(,)?],
        long_description: $long_desc:expr $(,)?
    ) => {
        inventory::submit! {
            $crate::registry::FeatureEntry {
                metadata: $crate::registry::FeatureMetadata {
                    name: $name,
                    id: $id,
                    status: $crate::registry::FeatureStatus::$status,
                    depends: &[$($dep),*],
                    enables: &[$($en),*],
                    tokens: &[$($tok),*],
                    ast_nodes: &[$($node),*],
                    description: $desc,
                    syntax: &[$($syn),*],
                    short: $short,
                    symbols: &[$($sym),*],
                    long_description: $long_desc,
                    grammar: "",
                    category: "",
                    category_order: $crate::registry::CategoryPriority::Default,
                },
            }
        }
    };
    // Extended form without long_description (defaults to empty)
    (
        name: $name:expr,
        id: $id:expr,
        status: $status:ident,
        depends: [$($dep:expr),* $(,)?],
        enables: [$($en:expr),* $(,)?],
        tokens: [$($tok:expr),* $(,)?],
        ast_nodes: [$($node:expr),* $(,)?],
        description: $desc:expr,
        syntax: [$($syn:expr),* $(,)?],
        short: $short:expr,
        symbols: [$($sym:expr),* $(,)?] $(,)?
    ) => {
        inventory::submit! {
            $crate::registry::FeatureEntry {
                metadata: $crate::registry::FeatureMetadata {
                    name: $name,
                    id: $id,
                    status: $crate::registry::FeatureStatus::$status,
                    depends: &[$($dep),*],
                    enables: &[$($en),*],
                    tokens: &[$($tok),*],
                    ast_nodes: &[$($node),*],
                    description: $desc,
                    syntax: &[$($syn),*],
                    short: $short,
                    symbols: &[$($sym),*],
                    long_description: "",
                    grammar: "",
                    category: "",
                    category_order: $crate::registry::CategoryPriority::Default,
                },
            }
        }
    };
    // Base form without syntax/short/symbols (defaults to empty)
    (
        name: $name:expr,
        id: $id:expr,
        status: $status:ident,
        depends: [$($dep:expr),* $(,)?],
        enables: [$($en:expr),* $(,)?],
        tokens: [$($tok:expr),* $(,)?],
        ast_nodes: [$($node:expr),* $(,)?],
        description: $desc:expr $(,)?
    ) => {
        inventory::submit! {
            $crate::registry::FeatureEntry {
                metadata: $crate::registry::FeatureMetadata {
                    name: $name,
                    id: $id,
                    status: $crate::registry::FeatureStatus::$status,
                    depends: &[$($dep),*],
                    enables: &[$($en),*],
                    tokens: &[$($tok),*],
                    ast_nodes: &[$($node),*],
                    description: $desc,
                    syntax: &[],
                    short: "",
                    symbols: &[],
                    long_description: "",
                    grammar: "",
                    category: "",
                    category_order: $crate::registry::CategoryPriority::Default,
                },
            }
        }
    };
}

// ---------------------------------------------------------------------------
// Built-in function registry
// ---------------------------------------------------------------------------

/// Type descriptor for built-in function parameters and return types
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum BuiltinType {
    Int,
    Float,
    Bool,
    String,
    Void,
    Ptr,
    Unknown,
    /// For complex return types that features handle manually
    Custom(&'static str),
}

impl BuiltinType {
    pub fn to_type(&self) -> crate::typeck::types::Type {
        use crate::typeck::types::Type;
        match self {
            BuiltinType::Int => Type::Int,
            BuiltinType::Float => Type::Float,
            BuiltinType::Bool => Type::Bool,
            BuiltinType::String => Type::String,
            BuiltinType::Void => Type::Void,
            BuiltinType::Ptr => Type::Ptr,
            BuiltinType::Unknown => Type::Unknown,
            BuiltinType::Custom(_) => Type::Unknown, // Caller handles
        }
    }
}

/// Describes a built-in function contributed by a feature
pub struct BuiltinFnDef {
    pub name: &'static str,
    pub feature_id: &'static str,
    pub params: &'static [BuiltinType],
    pub return_type: BuiltinType,
    pub variadic: bool,
    pub codegen_fn: &'static str,
}

inventory::collect!(BuiltinFnDef);

/// Describes a namespace contributed by a feature (e.g., "json", "string", "ptr", "channel")
pub struct BuiltinNamespace {
    pub name: &'static str,
    pub feature_id: &'static str,
}

inventory::collect!(BuiltinNamespace);

/// Describes a static method on a namespace (e.g., json.parse, channel.tick)
pub struct BuiltinNamespaceMethod {
    pub namespace: &'static str,
    pub method: &'static str,
    pub feature_id: &'static str,
    pub return_type: BuiltinType,
}

inventory::collect!(BuiltinNamespaceMethod);

/// Registry providing access to all built-in functions declared by features
pub struct BuiltinFnRegistry;

impl BuiltinFnRegistry {
    fn all() -> impl Iterator<Item = &'static BuiltinFnDef> {
        inventory::iter::<BuiltinFnDef>.into_iter()
    }

    pub fn all_names() -> Vec<&'static str> {
        Self::all().map(|d| d.name).collect()
    }

    pub fn is_variadic(name: &str) -> bool {
        Self::all().any(|d| d.name == name && d.variadic)
    }

    pub fn get(name: &str) -> Option<&'static BuiltinFnDef> {
        Self::all().find(|d| d.name == name)
    }

    /// Check if a namespace.method is a registered builtin
    pub fn get_namespace_method(namespace: &str, method: &str) -> Option<&'static BuiltinNamespaceMethod> {
        inventory::iter::<BuiltinNamespaceMethod>.into_iter()
            .find(|m| m.namespace == namespace && m.method == method)
    }

    /// Check if a name is a registered namespace
    pub fn is_namespace(name: &str) -> bool {
        inventory::iter::<BuiltinNamespace>.into_iter()
            .any(|ns| ns.name == name)
    }

    /// Insert all built-in fn types into TypeEnv.functions.
    /// Features with Custom return types must handle their own registration.
    pub fn register_all(env: &mut crate::typeck::env::TypeEnv) {
        for def in Self::all() {
            // Skip Custom return types — those features register manually
            if matches!(def.return_type, BuiltinType::Custom(_)) {
                continue;
            }
            let params: Vec<crate::typeck::types::Type> =
                def.params.iter().map(|t| t.to_type()).collect();
            let return_type = def.return_type.to_type();
            env.functions.insert(
                def.name.to_string(),
                crate::typeck::types::Type::Function {
                    params,
                    return_type: Box::new(return_type),
                },
            );
        }
        // Register namespaces
        for ns in inventory::iter::<BuiltinNamespace>.into_iter() {
            env.namespaces.insert(ns.name.to_string());
        }
    }
}

/// Macro for declaring a built-in function contributed by a feature.
///
/// Usage:
/// ```rust,ignore
/// builtin_fn! {
///     name: "print",
///     feature: "printing",
///     params: [String],
///     ret: Void,
///     variadic: false,
/// }
/// ```
#[macro_export]
macro_rules! builtin_fn {
    (name: $name:expr, feature: $feature:expr, params: [$($p:ident),* $(,)?], ret: $ret:ident, variadic: $var:expr) => {
        inventory::submit! {
            $crate::registry::BuiltinFnDef {
                name: $name,
                feature_id: $feature,
                params: &[$($crate::registry::BuiltinType::$p),*],
                return_type: $crate::registry::BuiltinType::$ret,
                variadic: $var,
                codegen_fn: $name,
            }
        }
    };
    // Custom return type variant
    (name: $name:expr, feature: $feature:expr, params: [$($p:ident),* $(,)?], ret: Custom($custom:expr), variadic: $var:expr) => {
        inventory::submit! {
            $crate::registry::BuiltinFnDef {
                name: $name,
                feature_id: $feature,
                params: &[$($crate::registry::BuiltinType::$p),*],
                return_type: $crate::registry::BuiltinType::Custom($custom),
                variadic: $var,
                codegen_fn: $name,
            }
        }
    };
}

/// Macro for declaring a namespace contributed by a feature.
///
/// Usage:
/// ```rust,ignore
/// builtin_namespace! {
///     name: "json",
///     feature: "collections",
/// }
/// ```
#[macro_export]
macro_rules! builtin_namespace {
    (name: $name:expr, feature: $feature:expr) => {
        inventory::submit! {
            $crate::registry::BuiltinNamespace {
                name: $name,
                feature_id: $feature,
            }
        }
    };
}

/// Macro for declaring a static method on a namespace contributed by a feature.
///
/// Usage:
/// ```rust,ignore
/// builtin_namespace_method! { namespace: "json", method: "parse", feature: "json_builtins", ret: Custom("json_parse") }
/// builtin_namespace_method! { namespace: "json", method: "stringify", feature: "json_builtins", ret: String }
/// ```
#[macro_export]
macro_rules! builtin_namespace_method {
    (namespace: $ns:expr, method: $method:expr, feature: $feature:expr, ret: $ret:ident) => {
        inventory::submit! {
            $crate::registry::BuiltinNamespaceMethod {
                namespace: $ns,
                method: $method,
                feature_id: $feature,
                return_type: $crate::registry::BuiltinType::$ret,
            }
        }
    };
    (namespace: $ns:expr, method: $method:expr, feature: $feature:expr, ret: Custom($custom:expr)) => {
        inventory::submit! {
            $crate::registry::BuiltinNamespaceMethod {
                namespace: $ns,
                method: $method,
                feature_id: $feature,
                return_type: $crate::registry::BuiltinType::Custom($custom),
            }
        }
    };
}

// ---------------------------------------------------------------------------
// Runtime function declaration registry
// ---------------------------------------------------------------------------

/// LLVM type descriptor for runtime function parameters
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum RuntimeType {
    I64,
    F64,
    I8,
    Ptr,
    ForgeString,
}

/// Return type descriptor for runtime functions
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum RuntimeRetType {
    Void,
    I64,
    F64,
    I8,
    I32,
    Ptr,
    ForgeString,
}

/// Describes a C runtime function declared by a feature module.
/// These are LLVM function declarations (not definitions) — the actual
/// implementations live in runtime.c.
pub struct RuntimeFnDecl {
    pub name: &'static str,
    pub feature_id: &'static str,
    pub params: &'static [RuntimeType],
    pub ret: RuntimeRetType,
    /// If true, only declare if not already declared (for shared fns like strlen)
    pub conditional: bool,
}

inventory::collect!(RuntimeFnDecl);

/// Registry for runtime function declarations
pub struct RuntimeFnRegistry;

impl RuntimeFnRegistry {
    pub fn all() -> impl Iterator<Item = &'static RuntimeFnDecl> {
        inventory::iter::<RuntimeFnDecl>.into_iter()
    }
}

/// Macro for declaring a C runtime function contributed by a feature.
///
/// Usage:
/// ```rust,ignore
/// runtime_fn! { name: "forge_println_string", feature: "printing", params: [ForgeString], ret: Void }
/// runtime_fn! { name: "strlen", feature: "strings", params: [Ptr], ret: I64, conditional: true }
/// ```
#[macro_export]
macro_rules! runtime_fn {
    (name: $name:expr, feature: $feature:expr, params: [$($p:ident),* $(,)?], ret: $ret:ident) => {
        inventory::submit! {
            $crate::registry::RuntimeFnDecl {
                name: $name,
                feature_id: $feature,
                params: &[$($crate::registry::RuntimeType::$p),*],
                ret: $crate::registry::RuntimeRetType::$ret,
                conditional: false,
            }
        }
    };
    (name: $name:expr, feature: $feature:expr, params: [$($p:ident),* $(,)?], ret: $ret:ident, conditional: $cond:expr) => {
        inventory::submit! {
            $crate::registry::RuntimeFnDecl {
                name: $name,
                feature_id: $feature,
                params: &[$($crate::registry::RuntimeType::$p),*],
                ret: $crate::registry::RuntimeRetType::$ret,
                conditional: $cond,
            }
        }
    };
}
