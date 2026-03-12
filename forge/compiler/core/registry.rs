/// Feature registry system for Forge language features.
///
/// Each language feature registers its metadata via the `forge_feature!` macro.
/// The registry collects all features at link time using the `inventory` crate,
/// enabling `forge features` to list all features with their status and dependencies.

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

    /// Print the feature table (used by `forge features`)
    pub fn print_table() {
        let features = Self::all_sorted();
        let test_counts = crate::test_runner::get_all_feature_test_counts();
        let test_map: std::collections::HashMap<&str, (usize, usize)> = test_counts
            .iter()
            .map(|(f, p, t)| (f.as_str(), (*p, *t)))
            .collect();

        let mut stable = 0u32;
        let mut testing = 0u32;
        let mut wip = 0u32;
        let mut draft = 0u32;

        println!("  {:<28} {:<10} {:<10} {}", "Feature", "Status", "Tests", "Deps");
        println!("  {}", "─".repeat(70));

        for f in &features {
            let (passed, total) = test_map.get(f.id).copied().unwrap_or((0, 0));

            let status_icon = if total > 0 && passed == total {
                "\x1b[32m✓\x1b[0m"
            } else if total > 0 {
                "\x1b[33m●\x1b[0m"
            } else {
                match f.status {
                    FeatureStatus::Draft => "\x1b[90m○\x1b[0m",
                    _ => "\x1b[90m-\x1b[0m",
                }
            };

            let tests_str = if total > 0 {
                format!("{}/{}", passed, total)
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
                tests_str,
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

    /// Print the dependency graph (used by `forge features --graph`)
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
                eprintln!("error: unknown feature '{}'", id);
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

        // Show test counts and examples
        let test_counts = crate::test_runner::get_all_feature_test_counts();
        if let Some((_, passed, total)) = test_counts.iter().find(|(fid, _, _)| fid == id) {
            if *total > 0 {
                println!();
                let color = if passed == total { "\x1b[32m" } else { "\x1b[33m" };
                println!("  Tests: {}{}/{} passing\x1b[0m", color, passed, total);
            }
        }

        println!();
        println!("  Source: compiler/features/{}/mod.rs", f.id);

        // List example files
        let examples_dir = std::path::PathBuf::from(format!("compiler/features/{}/examples", f.id));
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
                },
            }
        }
    };
}
