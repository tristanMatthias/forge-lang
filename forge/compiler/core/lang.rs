/// Forge language reference system.
///
/// Powers `forge lang` CLI commands for exploring language features,
/// symbols, error codes, types, and syntax from the terminal.

use std::path::PathBuf;

use crate::errors::ErrorRegistry;
use crate::registry::{FeatureMetadata, FeatureRegistry};
use crate::test_runner;

// ── Helpers ────────────────────────────────────────────────────────

/// Truncate a string to `max_chars` characters (not bytes), appending "..." if truncated.
fn truncate_str(s: &str, max_chars: usize) -> String {
    let char_count = s.chars().count();
    if char_count > max_chars {
        let truncated: String = s.chars().take(max_chars.saturating_sub(3)).collect();
        format!("{}...", truncated)
    } else {
        s.to_string()
    }
}

// ── Package documentation ───────────────────────────────────────────

struct PackageDoc {
    name: String,
    namespace: String,
    description: String,
    version: String,
    components: Vec<ComponentDoc>,
    extern_fns: Vec<ExternFnDoc>,
}

struct ComponentDoc {
    name: String,
    description: String,
    config_fields: Vec<(String, String, String)>, // (name, type, default)
    syntax_patterns: Vec<String>,
}

struct ExternFnDoc {
    name: String,
    params: Vec<(String, String)>, // (name, type)
    return_type: String,
    doc: String,
}

/// Discover all packages by scanning the packages/ directory.
fn discover_packages() -> Vec<PackageDoc> {
    let packages_dir = find_packages_dir();
    let packages_dir = match packages_dir {
        Some(d) => d,
        None => return vec![],
    };

    let mut packages = Vec::new();
    let mut entries: Vec<_> = std::fs::read_dir(&packages_dir)
        .ok()
        .into_iter()
        .flatten()
        .filter_map(|e| e.ok())
        .filter(|e| e.path().is_dir())
        .collect();
    entries.sort_by_key(|e| e.file_name());

    for entry in entries {
        let dir = entry.path();
        let toml_path = dir.join("package.toml");
        let fg_path = dir.join("src").join("package.fg");

        if !toml_path.exists() {
            continue;
        }

        if let Some(doc) = parse_package(&toml_path, &fg_path) {
            packages.push(doc);
        }
    }

    packages
}

/// Find the packages/ directory relative to the binary or source tree.
fn find_packages_dir() -> Option<PathBuf> {
    // Try relative to the current exe
    if let Ok(exe) = std::env::current_exe() {
        // exe is in target/release/ or target/debug/, packages is at forge/packages/
        let mut dir = exe.parent()?.to_path_buf();
        // Walk up looking for packages/
        for _ in 0..5 {
            let candidate = dir.join("packages");
            if candidate.is_dir() {
                return Some(candidate);
            }
            dir = dir.parent()?.to_path_buf();
        }
    }

    // Try CWD-based paths
    let cwd = std::env::current_dir().ok()?;
    for candidate in &[
        cwd.join("packages"),
        cwd.join("forge").join("packages"),
    ] {
        if candidate.is_dir() {
            return Some(candidate.clone());
        }
    }

    None
}

/// Parse a package from its package.toml and package.fg files.
fn parse_package(toml_path: &PathBuf, fg_path: &PathBuf) -> Option<PackageDoc> {
    let toml_content = std::fs::read_to_string(toml_path).ok()?;

    let name = extract_toml_string(&toml_content, "name")?;
    let namespace = extract_toml_string(&toml_content, "namespace").unwrap_or_default();
    let version = extract_toml_string(&toml_content, "version").unwrap_or_else(|| "0.0.0".to_string());
    let description = extract_toml_string(&toml_content, "description").unwrap_or_default();

    // Extract component names from [components.X] sections
    let component_names: Vec<String> = toml_content
        .lines()
        .filter_map(|line| {
            let trimmed = line.trim();
            if trimmed.starts_with("[components.") && trimmed.ends_with(']') {
                let inner = &trimmed[12..trimmed.len() - 1];
                // Stop at first dot if nested
                let comp_name = inner.split('.').next().unwrap_or(inner);
                Some(comp_name.to_string())
            } else {
                None
            }
        })
        .collect();

    // Parse package.fg for extern fns and component details
    let fg_content = std::fs::read_to_string(fg_path).unwrap_or_default();
    let (extern_fns, components) = parse_package_fg(&fg_content, &component_names);

    Some(PackageDoc {
        name: format!("{}-{}", namespace, name),
        namespace: name,
        description,
        version,
        components,
        extern_fns,
    })
}

/// Extract a string value from TOML content (simple key = "value" parsing).
fn extract_toml_string(content: &str, key: &str) -> Option<String> {
    for line in content.lines() {
        let trimmed = line.trim();
        if let Some(rest) = trimmed.strip_prefix(key) {
            let rest = rest.trim();
            if let Some(rest) = rest.strip_prefix('=') {
                let rest = rest.trim();
                if rest.starts_with('"') && rest.ends_with('"') && rest.len() >= 2 {
                    return Some(rest[1..rest.len() - 1].to_string());
                }
            }
        }
    }
    None
}

/// Parse package.fg to extract extern fns and component details.
fn parse_package_fg(
    content: &str,
    component_names: &[String],
) -> (Vec<ExternFnDoc>, Vec<ComponentDoc>) {
    let lines: Vec<&str> = content.lines().collect();
    let mut extern_fns = Vec::new();
    let mut components = Vec::new();

    let mut i = 0;
    while i < lines.len() {
        // Collect doc comments before declarations
        let mut doc_lines = Vec::new();
        while i < lines.len() && lines[i].trim().starts_with("///") {
            let doc_line = lines[i].trim().strip_prefix("///").unwrap_or("").trim();
            if !doc_line.is_empty() {
                doc_lines.push(doc_line.to_string());
            }
            i += 1;
        }
        if i >= lines.len() {
            break;
        }
        let trimmed = lines[i].trim();

        // Parse extern fn
        if trimmed.starts_with("extern fn ") {
            if let Some(efn) = parse_extern_fn_line(trimmed, &doc_lines) {
                extern_fns.push(efn);
            }
            i += 1;
            continue;
        }

        // Parse component block
        if trimmed.starts_with("component ") {
            if let Some(comp) = parse_component_block(&lines, i, &doc_lines) {
                components.push(comp);
            }
            // Skip to end of component block
            let mut brace_depth = 0;
            let mut found_open = false;
            while i < lines.len() {
                for ch in lines[i].chars() {
                    if ch == '{' {
                        brace_depth += 1;
                        found_open = true;
                    } else if ch == '}' {
                        brace_depth -= 1;
                    }
                }
                i += 1;
                if found_open && brace_depth == 0 {
                    break;
                }
            }
            continue;
        }

        i += 1;
    }

    // If we found no components from parsing but have names from toml, create stubs
    for name in component_names {
        if !components.iter().any(|c| c.name == *name) {
            components.push(ComponentDoc {
                name: name.clone(),
                description: String::new(),
                config_fields: vec![],
                syntax_patterns: vec![],
            });
        }
    }

    (extern_fns, components)
}

/// Parse a single `extern fn` line.
fn parse_extern_fn_line(line: &str, doc_lines: &[String]) -> Option<ExternFnDoc> {
    // extern fn name(params) [-> ret]
    let rest = line.strip_prefix("extern fn ")?;
    let paren_start = rest.find('(')?;
    let name = rest[..paren_start].trim().to_string();

    let paren_end = rest.find(')')?;
    let params_str = &rest[paren_start + 1..paren_end];
    let params: Vec<(String, String)> = if params_str.trim().is_empty() {
        vec![]
    } else {
        params_str
            .split(',')
            .filter_map(|p| {
                let p = p.trim();
                let parts: Vec<&str> = p.splitn(2, ':').collect();
                if parts.len() == 2 {
                    Some((parts[0].trim().to_string(), parts[1].trim().to_string()))
                } else {
                    Some((p.to_string(), String::new()))
                }
            })
            .collect()
    };

    let return_type = if let Some(arrow_pos) = rest[paren_end..].find("->") {
        rest[paren_end + arrow_pos + 2..].trim().to_string()
    } else {
        "void".to_string()
    };

    let doc = doc_lines.join(" ");

    Some(ExternFnDoc {
        name,
        params,
        return_type,
        doc,
    })
}

/// Parse a component block to extract config fields and @syntax patterns.
fn parse_component_block(lines: &[&str], start: usize, doc_lines: &[String]) -> Option<ComponentDoc> {
    let first_line = lines[start].trim();
    // component name(args) {
    let rest = first_line.strip_prefix("component ")?;
    let name_end = rest.find('(')?;
    let name = rest[..name_end].trim().to_string();

    let description = doc_lines.join(" ");
    let mut config_fields = Vec::new();
    let mut syntax_patterns = Vec::new();

    // Walk through the block
    let mut brace_depth = 0;
    let mut found_open = false;
    let mut in_config = false;
    let mut config_brace_depth = 0;
    let mut i = start;

    while i < lines.len() {
        let trimmed = lines[i].trim();

        for ch in lines[i].chars() {
            if ch == '{' {
                brace_depth += 1;
                found_open = true;
            } else if ch == '}' {
                brace_depth -= 1;
            }
        }

        // Detect config block
        if trimmed == "config {" || trimmed.starts_with("config {") {
            in_config = true;
            config_brace_depth = brace_depth;
        }

        // Parse config fields
        if in_config && trimmed.contains(':') && !trimmed.starts_with("config") {
            if let Some(field) = parse_config_field(trimmed) {
                config_fields.push(field);
            }
        }

        // End of config block
        if in_config && brace_depth < config_brace_depth {
            in_config = false;
        }

        // Parse @syntax patterns
        if trimmed.starts_with("@syntax(\"") {
            if let Some(pattern) = extract_syntax_pattern(trimmed) {
                syntax_patterns.push(pattern);
            }
        }

        i += 1;
        if found_open && brace_depth == 0 {
            break;
        }
    }

    Some(ComponentDoc {
        name,
        description,
        config_fields,
        syntax_patterns,
    })
}

/// Parse a config field line like `port: int = 3000`.
fn parse_config_field(line: &str) -> Option<(String, String, String)> {
    let trimmed = line.trim().trim_end_matches(',');
    // name: type = default
    let colon_pos = trimmed.find(':')?;
    let name = trimmed[..colon_pos].trim().to_string();

    let after_colon = trimmed[colon_pos + 1..].trim();
    if let Some(eq_pos) = after_colon.find('=') {
        let typ = after_colon[..eq_pos].trim().to_string();
        let default = after_colon[eq_pos + 1..].trim().to_string();
        Some((name, typ, default))
    } else {
        Some((name, after_colon.to_string(), String::new()))
    }
}

/// Extract the pattern string from `@syntax("pattern")`.
fn extract_syntax_pattern(line: &str) -> Option<String> {
    let start = line.find("@syntax(\"")?;
    let rest = &line[start + 9..];
    let end = rest.find("\")")?;
    Some(rest[..end].to_string())
}

/// Show documentation for a single package.
fn show_package(pkg: &PackageDoc) {
    let header = format!("@{}", pkg.namespace);
    let right = format!(
        "{} v{}",
        pkg.name, pkg.version
    );

    println!();
    println!("  {:<52} {}", bold(&header), dim(&right));
    println!("  {}", dim(&"\u{2500}".repeat(57)));
    println!();

    if !pkg.description.is_empty() {
        println!("  {}", pkg.description);
        println!();
    }

    // Components
    if !pkg.components.is_empty() {
        println!("  {}", bold("Components"));
        for comp in &pkg.components {
            println!();
            println!("    {}", bold(&comp.name));

            if !comp.description.is_empty() {
                println!("      {}", dim(&comp.description));
            }

            if !comp.config_fields.is_empty() {
                let config_str: Vec<String> = comp
                    .config_fields
                    .iter()
                    .map(|(name, typ, default)| {
                        if default.is_empty() {
                            format!("{}: {}", name, typ)
                        } else {
                            format!("{}: {} = {}", name, typ, default)
                        }
                    })
                    .collect();
                println!("      Config: {}", config_str.join(", "));
            }

            if !comp.syntax_patterns.is_empty() {
                for (i, pat) in comp.syntax_patterns.iter().enumerate() {
                    if i == 0 {
                        println!("      Syntax: {}", pat);
                    } else {
                        println!("              {}", pat);
                    }
                }
            }
        }
        println!();
    }

    // Extern functions
    if !pkg.extern_fns.is_empty() {
        println!("  {}", bold("Extern Functions"));
        for efn in &pkg.extern_fns {
            let params_str: Vec<String> = efn
                .params
                .iter()
                .map(|(name, typ)| {
                    if typ.is_empty() {
                        name.clone()
                    } else {
                        format!("{}: {}", name, typ)
                    }
                })
                .collect();
            let sig = format!(
                "{}({}) -> {}",
                efn.name,
                params_str.join(", "),
                efn.return_type
            );

            if efn.doc.is_empty() {
                println!("    {}", sig);
            } else {
                println!("    {:<56} {}", sig, dim(&efn.doc));
            }
        }
        println!();
    }

    println!();
}

/// Show documentation for a specific component within a package.
fn show_package_component(pkg: &PackageDoc, component_name: &str) {
    let comp = match pkg.components.iter().find(|c| c.name == component_name) {
        Some(c) => c,
        None => {
            println!(
                "\n  No component '{}' in @{}. Available: {}\n",
                component_name,
                pkg.namespace,
                pkg
                    .components
                    .iter()
                    .map(|c| c.name.as_str())
                    .collect::<Vec<_>>()
                    .join(", ")
            );
            return;
        }
    };

    let header = format!("@{}.{}", pkg.namespace, comp.name);
    let right = format!("{} v{}", pkg.name, pkg.version);

    println!();
    println!("  {:<52} {}", bold(&header), dim(&right));
    println!("  {}", dim(&"\u{2500}".repeat(57)));
    println!();

    if !comp.description.is_empty() {
        println!("  {}", comp.description);
        println!();
    }

    if !comp.config_fields.is_empty() {
        println!("  {}", bold("Config"));
        for (name, typ, default) in &comp.config_fields {
            if default.is_empty() {
                println!("    {}: {}", name, typ);
            } else {
                println!("    {}: {} = {}", name, typ, default);
            }
        }
        println!();
    }

    if !comp.syntax_patterns.is_empty() {
        println!("  {}", bold("Syntax Patterns"));
        for pat in &comp.syntax_patterns {
            println!("    {}", pat);
        }
        println!();
    }

    println!();
}

/// Show all packages in a compact list.
fn show_all_packages() {
    let packages = discover_packages();

    println!();
    println!("  {}", bold("Packages"));
    println!("  {}", dim(&"\u{2500}".repeat(9)));
    println!();

    if packages.is_empty() {
        println!("    {}", dim("(no packages found)"));
        println!();
        return;
    }

    for p in &packages {
        let ns = format!("@{}", p.namespace);
        let name_ver = format!("{} v{}", p.name, p.version);
        let desc = if p.description.is_empty() {
            let comp_names: Vec<&str> = p.components.iter().map(|c| c.name.as_str()).collect();
            if comp_names.is_empty() {
                "extern functions".to_string()
            } else {
                format!("{} component{}", comp_names.join(", "), if comp_names.len() > 1 { "s" } else { "" })
            }
        } else {
            p.description.clone()
        };

        println!(
            "    {:<12} {:<24} {}",
            cyan(&ns),
            dim(&name_ver),
            desc
        );
    }

    println!();
    println!(
        "  Detail: {}",
        cyan("forge lang @<package>")
    );
    println!();
}

/// Look up a package by namespace (e.g., "http" -> std-http).
fn find_package_by_namespace<'a>(packages: &'a [PackageDoc], ns: &str) -> Option<&'a PackageDoc> {
    packages.iter().find(|p| p.namespace == ns)
}

// ── ANSI helpers ────────────────────────────────────────────────────

fn dim(s: &str) -> String {
    format!("\x1b[2m{}\x1b[0m", s)
}

fn bold(s: &str) -> String {
    format!("\x1b[1m{}\x1b[0m", s)
}

fn green(s: &str) -> String {
    format!("\x1b[32m{}\x1b[0m", s)
}

fn yellow(s: &str) -> String {
    format!("\x1b[33m{}\x1b[0m", s)
}

fn cyan(s: &str) -> String {
    format!("\x1b[36m{}\x1b[0m", s)
}

fn status_colored(meta: &FeatureMetadata) -> String {
    match meta.status {
        crate::registry::FeatureStatus::Stable => green(&meta.status.to_string()),
        crate::registry::FeatureStatus::Testing => yellow(&meta.status.to_string()),
        crate::registry::FeatureStatus::Wip => yellow(&meta.status.to_string()),
        crate::registry::FeatureStatus::Draft => dim(&meta.status.to_string()),
    }
}

// ── Built-in type documentation ─────────────────────────────────────

struct MethodDoc {
    name: &'static str,
    signature: &'static str,
    description: &'static str,
    example: &'static str,
}

struct TypeDoc {
    name: &'static str,
    description: &'static str,
    methods: &'static [MethodDoc],
}

const STRING_METHODS: &[MethodDoc] = &[
    MethodDoc {
        name: "length",
        signature: "string.length() -> int",
        description: "Get the number of characters in the string.",
        example: "\"hello\".length()  // => 5",
    },
    MethodDoc {
        name: "split",
        signature: "string.split(sep: string) -> list<string>",
        description: "Split the string by a separator, returning a list of parts.",
        example: "\"a,b,c\".split(\",\")  // => [\"a\", \"b\", \"c\"]",
    },
    MethodDoc {
        name: "trim",
        signature: "string.trim() -> string",
        description: "Remove leading and trailing whitespace.",
        example: "\"  hello  \".trim()  // => \"hello\"",
    },
    MethodDoc {
        name: "contains",
        signature: "string.contains(sub: string) -> bool",
        description: "Check if the string contains a substring.",
        example: "\"hello world\".contains(\"world\")  // => true",
    },
    MethodDoc {
        name: "upper",
        signature: "string.upper() -> string",
        description: "Convert all characters to uppercase.",
        example: "\"hello\".upper()  // => \"HELLO\"",
    },
    MethodDoc {
        name: "lower",
        signature: "string.lower() -> string",
        description: "Convert all characters to lowercase.",
        example: "\"HELLO\".lower()  // => \"hello\"",
    },
    MethodDoc {
        name: "starts_with",
        signature: "string.starts_with(prefix: string) -> bool",
        description: "Check if the string starts with a given prefix.",
        example: "\"hello\".starts_with(\"hel\")  // => true",
    },
    MethodDoc {
        name: "ends_with",
        signature: "string.ends_with(suffix: string) -> bool",
        description: "Check if the string ends with a given suffix.",
        example: "\"hello\".ends_with(\"llo\")  // => true",
    },
    MethodDoc {
        name: "replace",
        signature: "string.replace(old: string, new: string) -> string",
        description: "Replace all occurrences of a substring with another.",
        example: "\"hello\".replace(\"l\", \"r\")  // => \"herro\"",
    },
    MethodDoc {
        name: "parse_int",
        signature: "string.parse_int() -> int",
        description: "Parse the string as an integer.",
        example: "\"42\".parse_int()  // => 42",
    },
    MethodDoc {
        name: "repeat",
        signature: "string.repeat(n: int) -> string",
        description: "Repeat the string n times.",
        example: "\"ab\".repeat(3)  // => \"ababab\"",
    },
];

const LIST_METHODS: &[MethodDoc] = &[
    MethodDoc {
        name: "length",
        signature: "list<T>.length -> int",
        description: "Get the number of elements in the list. Accessed as a property, not a method call.",
        example: "[1, 2, 3].length  // => 3",
    },
    MethodDoc {
        name: "push",
        signature: "list<T>.push(val: T) -> list<T>",
        description: "Append an element to the list, returning the new list.",
        example: "[1, 2].push(3)  // => [1, 2, 3]",
    },
    MethodDoc {
        name: "map",
        signature: "list<T>.map(fn: (T) -> U) -> list<U>",
        description: "Transform each element using a function, returning a new list.",
        example: "[1, 2, 3].map((x) -> x * 2)  // => [2, 4, 6]",
    },
    MethodDoc {
        name: "filter",
        signature: "list<T>.filter(fn: (T) -> bool) -> list<T>",
        description: "Keep only elements for which the function returns true.",
        example: "[1, 2, 3, 4].filter((x) -> x > 2)  // => [3, 4]",
    },
    MethodDoc {
        name: "sorted",
        signature: "list<T>.sorted() -> list<T>",
        description: "Return a new list with elements sorted in ascending order.",
        example: "[3, 1, 2].sorted()  // => [1, 2, 3]",
    },
    MethodDoc {
        name: "each",
        signature: "list<T>.each(fn: (T) -> void)",
        description: "Iterate over elements for side effects. Returns void.",
        example: "[1, 2, 3].each((x) -> println(string(x)))",
    },
    MethodDoc {
        name: "find",
        signature: "list<T>.find(fn: (T) -> bool) -> T?",
        description: "Return the first element matching the predicate, or null.",
        example: "[1, 2, 3].find((x) -> x > 1)  // => 2",
    },
    MethodDoc {
        name: "any",
        signature: "list<T>.any(fn: (T) -> bool) -> bool",
        description: "Return true if any element matches the predicate.",
        example: "[1, 2, 3].any((x) -> x > 2)  // => true",
    },
    MethodDoc {
        name: "all",
        signature: "list<T>.all(fn: (T) -> bool) -> bool",
        description: "Return true if all elements match the predicate.",
        example: "[1, 2, 3].all((x) -> x > 0)  // => true",
    },
    MethodDoc {
        name: "sum",
        signature: "list<int>.sum() -> int",
        description: "Sum all elements in a list of integers.",
        example: "[1, 2, 3].sum()  // => 6",
    },
    MethodDoc {
        name: "join",
        signature: "list<string>.join(sep: string) -> string",
        description: "Join all elements into a single string with a separator.",
        example: "[\"a\", \"b\", \"c\"].join(\", \")  // => \"a, b, c\"",
    },
    MethodDoc {
        name: "reduce",
        signature: "list<T>.reduce(fn: (acc: T, val: T) -> T) -> T",
        description: "Reduce the list to a single value by applying a function cumulatively.",
        example: "[1, 2, 3].reduce((acc, x) -> acc + x)  // => 6",
    },
    MethodDoc {
        name: "enumerate",
        signature: "list<T>.enumerate() -> list<{index: int, value: T}>",
        description: "Return a list of index-value pairs.",
        example: "[\"a\", \"b\"].enumerate()  // => [{index: 0, value: \"a\"}, ...]",
    },
    MethodDoc {
        name: "clone",
        signature: "list<T>.clone() -> list<T>",
        description: "Create a shallow copy of the list.",
        example: "let copy = items.clone()",
    },
];

const MAP_METHODS: &[MethodDoc] = &[
    MethodDoc {
        name: "has",
        signature: "map<K,V>.has(key: K) -> bool",
        description: "Check if the map contains a given key.",
        example: "let m = {a: 1}\nm.has(\"a\")  // => true",
    },
    MethodDoc {
        name: "get",
        signature: "map<K,V>.get(key: K) -> V?",
        description: "Get the value for a key, or null if not found.",
        example: "let m = {a: 1}\nm.get(\"a\")  // => 1",
    },
    MethodDoc {
        name: "keys",
        signature: "map<K,V>.keys() -> list<K>",
        description: "Return a list of all keys in the map.",
        example: "let m = {a: 1, b: 2}\nm.keys()  // => [\"a\", \"b\"]",
    },
    MethodDoc {
        name: "length",
        signature: "map<K,V>.length -> int",
        description: "Get the number of entries in the map. Accessed as a property.",
        example: "{a: 1, b: 2}.length  // => 2",
    },
];

const JSON_METHODS: &[MethodDoc] = &[
    MethodDoc {
        name: "parse",
        signature: "json.parse(str: string) -> T",
        description: "Parse a JSON string into a typed value. The target type is inferred from context.",
        example: "let user: User = json.parse(data)",
    },
    MethodDoc {
        name: "stringify",
        signature: "json.stringify(val: T) -> string",
        description: "Serialize a value to a JSON string.",
        example: "let s = json.stringify({name: \"Alice\"})",
    },
];

const BUILTIN_TYPES: &[TypeDoc] = &[
    TypeDoc {
        name: "int",
        description: "64-bit signed integer type. Supports arithmetic (+, -, *, /, %), comparison, and bitwise operations.",
        methods: &[],
    },
    TypeDoc {
        name: "float",
        description: "64-bit floating-point type (IEEE 754 double). Supports arithmetic and comparison operations.",
        methods: &[],
    },
    TypeDoc {
        name: "string",
        description: "UTF-8 string type. Immutable value type with a rich set of built-in methods.",
        methods: STRING_METHODS,
    },
    TypeDoc {
        name: "bool",
        description: "Boolean type with values `true` and `false`. Supports logical operators (&&, ||, !).",
        methods: &[],
    },
    TypeDoc {
        name: "list",
        description: "Generic ordered collection. Declared as `list<T>` where T is the element type.",
        methods: LIST_METHODS,
    },
    TypeDoc {
        name: "map",
        description: "Generic key-value collection. Declared as `map<K, V>`. Keys are strings by default.",
        methods: MAP_METHODS,
    },
    TypeDoc {
        name: "json",
        description: "JSON namespace for parsing and serialization. Not a value type \u{2014} used as `json.parse()` and `json.stringify()`.",
        methods: JSON_METHODS,
    },
];

fn find_type(name: &str) -> Option<&'static TypeDoc> {
    BUILTIN_TYPES.iter().find(|t| t.name == name)
}

fn find_method(type_name: &str, method_name: &str) -> Option<(&'static TypeDoc, &'static MethodDoc)> {
    let type_doc = find_type(type_name)?;
    let method_doc = type_doc.methods.iter().find(|m| m.name == method_name)?;
    Some((type_doc, method_doc))
}

fn is_type_name(name: &str) -> bool {
    BUILTIN_TYPES.iter().any(|t| t.name == name)
}

// ── Discovery ───────────────────────────────────────────────────────

/// Find the features directory, using the same strategy as test_runner.
pub fn find_features_dir() -> Option<PathBuf> {
    test_runner::find_features_dir()
}

/// Get example filenames for a feature.
fn get_examples(feature_id: &str) -> Vec<(String, Option<String>)> {
    let features_dir = match find_features_dir() {
        Some(d) => d,
        None => return vec![],
    };

    let examples_dir = features_dir.join(feature_id).join("examples");
    if !examples_dir.is_dir() {
        return vec![];
    }

    let mut entries: Vec<_> = std::fs::read_dir(&examples_dir)
        .ok()
        .into_iter()
        .flatten()
        .filter_map(|e| e.ok())
        .filter(|e| e.path().extension().and_then(|x| x.to_str()) == Some("fg"))
        .collect();
    entries.sort_by_key(|e| e.file_name());

    entries
        .iter()
        .map(|entry| {
            let path = entry.path();
            let name = path
                .file_name()
                .unwrap_or_default()
                .to_string_lossy()
                .to_string();
            let title = std::fs::read_to_string(&path).ok().and_then(|source| {
                source
                    .lines()
                    .find_map(|l| l.trim().strip_prefix("/// # ").map(|t| t.to_string()))
            });
            (name, title)
        })
        .collect()
}

// ── LONG DESCRIPTIONS REMOVED ──
// ── Show a single feature ───────────────────────────────────────────

/// Display a rich feature page.
pub fn show_feature(query: &str) {
    let meta = match FeatureRegistry::get(query) {
        Some(m) => m,
        None => {
            println!(
                "\n  No feature '{}'. Try {} to see everything.\n",
                query,
                cyan("forge lang --all")
            );
            return;
        }
    };

    let description = if !meta.short.is_empty() {
        meta.short
    } else {
        meta.description
    };

    println!();
    println!(
        "  {:<52} {}",
        bold(meta.name),
        status_colored(meta)
    );
    println!("  {}", dim(&"\u{2500}".repeat(57)));
    println!();
    println!("  {}", description);

    // Full description if short was used
    if !meta.short.is_empty() && meta.description != meta.short {
        println!();
        println!("  {}", meta.description);
    }

    // Long description
    let long_desc = meta.long_description;
    if !long_desc.is_empty() {
        println!();
        for paragraph in long_desc.split("\n\n") {
            let wrapped = paragraph.replace('\n', " ");
            println!("  {}", wrapped);
            println!();
        }
    }

    // Syntax
    if !meta.syntax.is_empty() {
        println!();
        println!("  {}", bold("Syntax"));
        for s in meta.syntax {
            println!("    {}", s);
        }
    }

    // Symbols
    if !meta.symbols.is_empty() {
        println!();
        println!("  {}", bold("Symbols"));
        println!("    {}", meta.symbols.join("  "));
    }

    // Tokens
    if !meta.tokens.is_empty() {
        println!();
        println!("  {}", bold("Tokens"));
        println!("    {}", meta.tokens.join("  "));
    }

    // AST Nodes
    if !meta.ast_nodes.is_empty() {
        println!();
        println!("  {}", bold("AST Nodes"));
        println!("    {}", meta.ast_nodes.join(", "));
    }

    // Dependencies
    println!();
    println!("  {}", bold("Dependencies"));
    if meta.depends.is_empty() {
        println!("    {}", dim("(none)"));
    } else {
        for dep in meta.depends {
            println!("    {}", dep);
        }
    }

    // Enables
    println!();
    println!("  {}", bold("Enables"));
    if meta.enables.is_empty() {
        println!("    {}", dim("(none)"));
    } else {
        for en in meta.enables {
            println!("    {}", en);
        }
    }

    // Examples
    let examples = get_examples(meta.id);
    if !examples.is_empty() {
        println!();
        println!("  {}", bold("Examples"));
        for (name, title) in &examples {
            match title {
                Some(t) => println!("    {:<28} {}", name, dim(t)),
                None => println!("    {}", name),
            }
        }
    }

    println!();
}

// ── Show a built-in type ────────────────────────────────────────────

/// Display documentation for a built-in type.
fn show_type(name: &str) {
    let type_doc = match find_type(name) {
        Some(t) => t,
        None => {
            println!(
                "\n  No type '{}'. Try {} to see all types.\n",
                name,
                cyan("forge lang types")
            );
            return;
        }
    };

    println!();
    println!(
        "  {:<52} {}",
        bold(type_doc.name),
        dim("built-in type")
    );
    println!("  {}", dim(&"\u{2500}".repeat(57)));
    println!();
    println!("  {}", type_doc.description);

    if !type_doc.methods.is_empty() {
        println!();
        println!("  {}", bold("Methods"));
        for m in type_doc.methods {
            println!(
                "    {:<40} {}",
                m.signature.split(" -> ").next().unwrap_or(m.signature),
                dim(m.description.lines().next().unwrap_or(""))
            );
        }
    } else {
        println!();
        println!("  {}", dim("No methods. Used with operators and built-in functions."));
    }

    println!();
    println!(
        "  Detail: {}",
        cyan(&format!("forge lang {}.{{method}}", type_doc.name))
    );
    println!();
}

/// Display documentation for a specific method on a built-in type.
fn show_method(type_name: &str, method_name: &str) {
    let (type_doc, method_doc) = match find_method(type_name, method_name) {
        Some(pair) => pair,
        None => {
            // Check if the type exists but the method doesn't
            if find_type(type_name).is_some() {
                println!(
                    "\n  No method '{}' on type '{}'. Try {} to see all methods.\n",
                    method_name,
                    type_name,
                    cyan(&format!("forge lang {}", type_name))
                );
            } else {
                println!(
                    "\n  No type '{}'. Try {} to see all types.\n",
                    type_name,
                    cyan("forge lang types")
                );
            }
            return;
        }
    };

    let header = method_doc.signature;
    let rule_len = header.len().max(20);

    println!();
    println!("  {}", bold(header));
    println!("  {}", dim(&"\u{2500}".repeat(rule_len)));
    println!();
    println!("  {}", method_doc.description);
    println!();
    println!("  {}", bold("Example"));
    for line in method_doc.example.lines() {
        println!("    {}", line);
    }
    println!();
    println!(
        "  Type: {}",
        cyan(&format!("forge lang {}", type_doc.name))
    );
    println!();
}

// ── Show all types ──────────────────────────────────────────────────

fn show_types() {
    println!();
    println!("  {}", bold("Built-in Types"));
    println!("  {}", dim(&"\u{2500}".repeat(14)));
    println!();

    for t in BUILTIN_TYPES {
        let method_count = if t.methods.is_empty() {
            String::new()
        } else {
            format!("{} methods", t.methods.len())
        };
        // Truncate description
        let desc = truncate_str(t.description, 48);
        println!(
            "    {:<12} {:<48} {}",
            t.name,
            dim(&desc),
            dim(&method_count)
        );
    }

    println!();
    println!(
        "  Detail: {}",
        cyan("forge lang <type>")
    );
    println!();
}

// ── Show all features ───────────────────────────────────────────────

/// List all features in a compact format.
pub fn show_all() {
    let features = FeatureRegistry::all_sorted();

    println!();
    println!(
        "  {} {} Forge Language Reference",
        bold("forge lang"),
        dim("\u{2014}")
    );
    println!("  {}", dim(&"\u{2500}".repeat(37)));

    // Types section
    println!();
    println!("  {} ({})", bold("Types"), BUILTIN_TYPES.len());
    println!();
    for t in BUILTIN_TYPES {
        let method_count = if t.methods.is_empty() {
            String::new()
        } else {
            format!("{} methods", t.methods.len())
        };
        let desc = truncate_str(t.description, 44);
        println!(
            "    {:<20} {:<44} {}",
            t.name,
            dim(&desc),
            dim(&method_count)
        );
    }

    // Features section
    println!();
    println!("  {} ({})", bold("Features"), features.len());
    println!();

    for f in &features {
        let desc = if !f.short.is_empty() {
            f.short
        } else {
            f.description
        };
        let desc_truncated = truncate_str(desc, 44);

        println!(
            "    {:<20} {:<44} {}",
            f.id,
            dim(&desc_truncated),
            status_colored(f)
        );
    }

    // Packages section
    let packages = discover_packages();
    if !packages.is_empty() {
        println!();
        println!("  {} ({})", bold("Packages"), packages.len());
        println!();
        for p in &packages {
            let ns = format!("@{}", p.namespace);
            let name_ver = format!("{} v{}", p.name, p.version);
            let desc = if p.description.is_empty() {
                let comp_names: Vec<&str> = p.components.iter().map(|c| c.name.as_str()).collect();
                if comp_names.is_empty() {
                    "extern functions".to_string()
                } else {
                    format!("{} component{}", comp_names.join(", "), if comp_names.len() > 1 { "s" } else { "" })
                }
            } else {
                p.description.clone()
            };
            println!(
                "    {:<12} {:<24} {}",
                ns,
                dim(&name_ver),
                dim(&desc)
            );
        }
    }

    // Error codes section
    println!();
    println!("  {}", bold("Error Codes"));
    println!();
    print_error_code_list();

    // Hints
    println!();
    let mut hints = Vec::new();
    hints.push(format!(
        "Types: {}",
        cyan("forge lang string")
    ));
    let has_symbols = features.iter().any(|f| !f.tokens.is_empty());
    if has_symbols {
        hints.push(format!(
            "Symbols: {}",
            cyan("forge lang symbols")
        ));
    }
    hints.push(format!(
        "Packages: {}",
        cyan("forge lang @http")
    ));
    hints.push(format!(
        "Errors: {}",
        cyan("forge lang F0012")
    ));
    hints.push(format!(
        "Detail: {}",
        cyan("forge lang <feature>")
    ));
    println!("  {}", hints.join("  |  "));
    println!();
}

// ── Show symbols ────────────────────────────────────────────────────

/// List all symbols/tokens from all features.
pub fn show_symbols() {
    let features = FeatureRegistry::all_sorted();

    println!();
    println!("  {}", bold("Symbol Reference"));
    println!("  {}", dim(&"\u{2500}".repeat(16)));
    println!();

    let mut entries: Vec<(&str, &str)> = Vec::new();

    for f in &features {
        for token in f.tokens {
            entries.push((token, f.id));
        }
        for sym in f.symbols {
            // Only add if not already covered by tokens
            if !f.tokens.contains(sym) {
                entries.push((sym, f.id));
            }
        }
    }

    // Sort by symbol
    entries.sort_by_key(|(sym, _)| *sym);
    // Deduplicate
    entries.dedup();

    for (sym, feature_id) in &entries {
        println!("    {:<14} {}", sym, dim(feature_id));
    }

    if entries.is_empty() {
        println!("    {}", dim("(no symbols registered)"));
    }

    println!();
}

// ── Error code lookup ───────────────────────────────────────────────

/// Print the list of error codes with titles from the registry.
fn print_error_code_list() {
    let registry = ErrorRegistry::builtin();
    let mut codes = registry.all_codes().into_iter().map(|c| c.to_string()).collect::<Vec<_>>();
    codes.sort();
    for code in &codes {
        if let Some(entry) = registry.lookup(code) {
            println!("    {}   {}", code, entry.title);
        }
    }
}

/// Display detailed information for a single error code.
fn show_error(code: &str) {
    let registry = ErrorRegistry::builtin();

    if let Some(entry) = registry.lookup(code) {
        let header = format!("{} \u{2014} {}", code, entry.title);
        let rule_len = header.len().max(20);

        println!();
        println!("  {}", bold(&header));
        println!("  {}", dim(&"\u{2500}".repeat(rule_len)));
        println!();
        println!("  {}", entry.message);

        if !entry.help.is_empty() {
            println!();
            println!("  {}", bold("Help"));
            println!("    {}", entry.help);
        }

        if !entry.doc.is_empty() {
            println!();
            for line in entry.doc.lines() {
                println!("  {}", line);
            }
        }

        println!();
        println!(
            "  Full explanation: {}",
            cyan(&format!("forge explain {}", code))
        );
        println!();
    } else {
        println!();
        println!(
            "  Unknown error code '{}'. Run {} to see all error codes.",
            code,
            cyan("forge lang errors")
        );
        println!();
    }
}

fn red(s: &str) -> String {
    format!("\x1b[31m{}\x1b[0m", s)
}

// ── Validation ──────────────────────────────────────────────────────

/// Validate documentation completeness for the Forge language itself.
///
/// Checks every registered feature for syntax patterns, short descriptions,
/// and example files, then reports coverage of built-in types and methods.
pub fn validate_lang() {
    let features = FeatureRegistry::all_sorted();
    let features_dir = find_features_dir();

    println!();
    println!("  {}", bold("Language Documentation Coverage"));
    println!("  {}", dim(&"\u{2500}".repeat(31)));

    // ── Per-feature checks ──────────────────────────────────────────
    println!();
    println!("  {}: {}/{} registered", bold("Features"), features.len(), features.len());

    let mut has_syntax_count = 0usize;
    let mut has_short_count = 0usize;
    let mut has_examples_count = 0usize;
    let mut has_description_count = 0usize;
    let mut has_long_desc_count = 0usize;
    let mut has_grammar_count = 0usize;
    let mut has_category_count = 0usize;
    let mut has_status_count = 0usize;
    let mut fully_documented = 0usize;
    let mut stable_count = 0usize;
    let mut stable_with_examples = 0usize;

    for f in &features {
        let has_syntax = !f.syntax.is_empty();
        let has_short = !f.short.is_empty();
        let example_count = features_dir
            .as_ref()
            .map(|dir| count_examples(dir, f.id))
            .unwrap_or(0);
        let has_examples = example_count > 0;
        let has_description = !f.description.is_empty();
        let has_long_desc = !f.long_description.is_empty();
        let has_grammar = !f.grammar.is_empty();
        let has_category = !f.category.is_empty();

        if has_syntax { has_syntax_count += 1; }
        if has_short { has_short_count += 1; }
        if has_examples { has_examples_count += 1; }
        if has_description { has_description_count += 1; }
        if has_long_desc { has_long_desc_count += 1; }
        if has_grammar { has_grammar_count += 1; }
        if has_category { has_category_count += 1; }
        has_status_count += 1; // status is always set (it's an enum)

        let is_stable = f.status == crate::registry::FeatureStatus::Stable;
        if is_stable {
            stable_count += 1;
            if has_examples { stable_with_examples += 1; }
        }

        let is_fully_doc = has_syntax && has_short && has_examples && has_long_desc && has_grammar && has_category;
        if is_fully_doc { fully_documented += 1; }

        // Determine line icon
        let (icon, _icon_color) = if is_fully_doc {
            ("\u{2713}", true) // check mark, green
        } else if has_syntax || has_short || has_examples {
            ("\u{26a0}", false) // warning, yellow
        } else {
            ("\u{2717}", false) // cross, red
        };

        let syntax_tag = if has_syntax { green("syntax \u{2713}") } else { red("no syntax") };
        let short_tag = if has_short { green("short \u{2713}") } else { red("no short") };
        let long_desc_tag = if has_long_desc { green("long_desc \u{2713}") } else { red("no long_desc") };
        let grammar_tag = if has_grammar { green("grammar \u{2713}") } else { red("no grammar") };
        let examples_tag = if has_examples {
            format!("{} examples", example_count)
        } else {
            red("0 examples").to_string()
        };

        let icon_str = if is_fully_doc {
            green(icon)
        } else if has_syntax || has_short || has_examples {
            yellow(icon)
        } else {
            red(icon)
        };

        println!(
            "    {} {}: {}, {}, {}, {}, {}",
            icon_str, f.id, syntax_tag, short_tag, long_desc_tag, grammar_tag, examples_tag
        );
    }

    // ── Coverage checks ─────────────────────────────────────────────
    let total = features.len();
    println!();
    println!("  {}", bold("Coverage Checks"));

    let checks: Vec<(&str, usize, usize, bool)> = vec![
        ("All features have descriptions", has_description_count, total, has_description_count == total),
        ("All features have long descriptions", has_long_desc_count, total, has_long_desc_count == total),
        ("All features have grammar rules", has_grammar_count, total, has_grammar_count == total),
        ("All features have categories", has_category_count, total, has_category_count == total),
        ("All features have syntax patterns", has_syntax_count, total, has_syntax_count == total),
        ("All features have short descriptions", has_short_count, total, has_short_count == total),
        ("All features have examples", has_examples_count, total, has_examples_count == total),
        ("All features have status set", has_status_count, total, has_status_count == total),
        ("All stable features have examples", stable_with_examples, stable_count, stable_with_examples == stable_count),
    ];

    for (label, num, denom, pass) in &checks {
        let (_icon, colored_icon) = if *pass {
            ("\u{2713}", green("\u{2713}"))
        } else if *num as f64 / (*denom).max(1) as f64 >= 0.5 {
            ("\u{26a0}", yellow("\u{26a0}"))
        } else {
            ("\u{2717}", red("\u{2717}"))
        };
        println!("    [{}] {:<44} {}/{}", colored_icon, label, num, denom);
    }

    // ── Types section ───────────────────────────────────────────────
    let _types_with_methods: Vec<&TypeDoc> = BUILTIN_TYPES
        .iter()
        .filter(|t| !t.methods.is_empty())
        .collect();
    let types_total = BUILTIN_TYPES.len();

    println!();
    println!("  {}: {} documented", bold("Types"), types_total);
    for t in BUILTIN_TYPES {
        if t.methods.is_empty() {
            println!("    {} {}", green("\u{2713}"), t.name);
        } else {
            println!("    {} {}: {} methods", green("\u{2713}"), t.name, t.methods.len());
        }
    }

    // ── Summary ─────────────────────────────────────────────────────
    let feature_pct = if total > 0 {
        (fully_documented as f64 / total as f64 * 100.0) as usize
    } else {
        0
    };
    let type_pct = 100; // all types are statically documented

    let overall = (feature_pct + type_pct) / 2;

    println!();
    println!("  {}", bold("Summary"));
    println!(
        "    {:<14} {}% coverage ({}/{} fully documented)",
        "Features:", feature_pct, fully_documented, total
    );
    println!(
        "    {:<14} {}% coverage ({}/{})",
        "Types:", type_pct, types_total, types_total
    );
    println!("    {:<14} {}%", "Overall:", overall);
    println!();
}

/// Count .fg example files for a feature.
fn count_examples(features_dir: &PathBuf, feature_id: &str) -> usize {
    let examples_dir = features_dir.join(feature_id).join("examples");
    if !examples_dir.is_dir() {
        return 0;
    }
    std::fs::read_dir(&examples_dir)
        .ok()
        .into_iter()
        .flatten()
        .filter_map(|e| e.ok())
        .filter(|e| e.path().extension().and_then(|x| x.to_str()) == Some("fg"))
        .count()
}

// ── Main resolver ───────────────────────────────────────────────────

/// Main entry point. Resolves a query to the appropriate display.
pub fn resolve(query: &str) {
    // 0. Package queries: @namespace or @namespace.component
    if query.starts_with('@') {
        let package_query = &query[1..];
        let packages = discover_packages();

        if let Some(dot_pos) = package_query.find('.') {
            let ns = &package_query[..dot_pos];
            let comp_name = &package_query[dot_pos + 1..];
            if let Some(pkg) = find_package_by_namespace(&packages, ns) {
                show_package_component(pkg, comp_name);
            } else {
                println!(
                    "\n  No package '@{}'. Try {} to see all packages.\n",
                    ns,
                    cyan("forge lang packages")
                );
            }
        } else {
            if let Some(pkg) = find_package_by_namespace(&packages, package_query) {
                show_package(pkg);
            } else {
                println!(
                    "\n  No package '@{}'. Try {} to see all packages.\n",
                    package_query,
                    cyan("forge lang packages")
                );
            }
        }
        return;
    }

    // 1. Type.method lookup (e.g., "string.split")
    if let Some(dot_pos) = query.find('.') {
        let type_name = &query[..dot_pos];
        let method_name = &query[dot_pos + 1..];
        if is_type_name(type_name) && !method_name.is_empty() {
            show_method(type_name, method_name);
            return;
        }
    }

    // 2. Built-in type name match
    if is_type_name(query) {
        show_type(query);
        return;
    }

    // 3. Exact feature ID match
    if FeatureRegistry::get(query).is_some() {
        show_feature(query);
        return;
    }

    // 4. Symbol/token match — find the feature that owns this symbol
    let features = FeatureRegistry::all();
    for f in &features {
        for token in f.tokens {
            if *token == query {
                show_feature(f.id);
                return;
            }
        }
        for sym in f.symbols {
            if *sym == query {
                show_feature(f.id);
                return;
            }
        }
    }

    // 5. Error code (starts with F followed by digits)
    if query.starts_with('F') && query.len() > 1 && query[1..].chars().all(|c| c.is_ascii_digit())
    {
        show_error(query);
        return;
    }

    // 6. Special sub-commands
    if query == "symbols" {
        show_symbols();
        return;
    }

    if query == "types" {
        show_types();
        return;
    }

    if query == "packages" {
        show_all_packages();
        return;
    }

    if query == "errors" {
        println!();
        println!("  {}", bold("Error Codes"));
        println!("  {}", dim(&"\u{2500}".repeat(16)));
        println!();
        print_error_code_list();
        println!();
        println!(
            "  Run {} for a full explanation.",
            cyan("forge explain <code>")
        );
        println!();
        return;
    }

    // No match
    println!(
        "\n  No match for '{}'. Try {} to see everything.\n",
        query,
        cyan("forge lang --all")
    );
}

// ── Short one-liner ─────────────────────────────────────────────────

/// Show just the one-line description for a feature.
pub fn show_short(query: &str) {
    match FeatureRegistry::get(query) {
        Some(meta) => {
            let desc = if !meta.short.is_empty() { meta.short } else { meta.description };
            println!("  {}: {}", meta.id, desc);
        }
        None => {
            println!(
                "\n  No feature '{}'. Try {} to see everything.\n",
                query,
                cyan("forge lang --all")
            );
        }
    }
}

// ── Feature ordering for compact outputs ────────────────────────────

// Category ordering now lives in FeatureRegistry::by_category()

/// Get the description for a feature (short if available, else description).
fn feature_desc(meta: &FeatureMetadata) -> &str {
    if !meta.short.is_empty() {
        meta.short
    } else {
        meta.description
    }
}

// ── LLM Compact ─────────────────────────────────────────────────────

/// Generate compact LLM-friendly language spec (<4K tokens).
pub fn show_llm_compact() {
    println!("# Forge Language Spec (compact)");
    println!("# Types: int, float, string, bool, null, list<T>, map<K,V>, fn<(A)->R>");
    println!("# Truthy: everything except false, null, 0, \"\"");
    println!();

    for (group_name, features) in FeatureRegistry::by_category() {
        let mut group_lines: Vec<String> = Vec::new();
        for meta in &features {
            if !meta.syntax.is_empty() {
                for s in meta.syntax {
                    group_lines.push(s.to_string());
                }
            } else {
                group_lines.push(format!("# {}", feature_desc(meta)));
            }
        }
        if !group_lines.is_empty() {
            println!("## {}", group_name);
            for line in &group_lines {
                println!("{}", line);
            }
            println!();
        }
    }

    // Built-in methods section
    println!("## Built-in Methods");
    print!("string:");
    for m in STRING_METHODS {
        print!(" .{}()", m.name);
    }
    println!();
    print!("list<T>:");
    for m in LIST_METHODS {
        if m.name == "length" {
            print!(" .length");
        } else {
            print!(" .{}()", m.name);
        }
    }
    println!();
    print!("map<K,V>:");
    for m in MAP_METHODS {
        if m.name == "length" {
            print!(" .length");
        } else {
            print!(" .{}()", m.name);
        }
    }
    println!();
    print!("json:");
    for m in JSON_METHODS {
        print!(" .{}()", m.name);
    }
    println!();

    // Packages section
    let packages = discover_packages();
    if !packages.is_empty() {
        println!();
        println!("## Packages");
        for p in &packages {
            let mut parts = Vec::new();

            // Description or component summary
            if !p.description.is_empty() {
                parts.push(p.description.clone());
            }

            // Add component syntax summaries
            for comp in &p.components {
                if !comp.syntax_patterns.is_empty() {
                    let patterns: Vec<String> = comp
                        .syntax_patterns
                        .iter()
                        .take(3)
                        .map(|s| s.clone())
                        .collect();
                    parts.push(format!("{} {{ {} }}", comp.name, patterns.join("; ")));
                }
            }

            // Add key extern fn summaries for packages without components
            if p.components.is_empty() && !p.extern_fns.is_empty() {
                let fn_names: Vec<String> = p
                    .extern_fns
                    .iter()
                    .take(5)
                    .map(|f| {
                        // Strip package prefix for readability
                        let short = f
                            .name
                            .strip_prefix(&format!("forge_{}_", p.namespace))
                            .unwrap_or(&f.name);
                        let params: Vec<&str> = f.params.iter().map(|(n, _)| n.as_str()).collect();
                        format!("{}.{}({})", p.namespace, short, params.join(", "))
                    })
                    .collect();
                parts.push(fn_names.join(", "));
            }

            println!("@{}: {}", p.namespace, parts.join(" -- "));
        }
    }
}

// ── LLM Full ────────────────────────────────────────────────────────

/// Read the first example file for a feature, stripping `/// expect:` lines.
fn read_first_example(feature_id: &str) -> Option<String> {
    let features_dir = find_features_dir()?;
    let examples_dir = features_dir.join(feature_id).join("examples");
    if !examples_dir.is_dir() {
        return None;
    }

    let mut entries: Vec<_> = std::fs::read_dir(&examples_dir)
        .ok()?
        .filter_map(|e| e.ok())
        .filter(|e| e.path().extension().and_then(|x| x.to_str()) == Some("fg"))
        .collect();
    entries.sort_by_key(|e| e.file_name());

    let first = entries.first()?;
    let source = std::fs::read_to_string(first.path()).ok()?;

    let mut code: Vec<&str> = source
        .lines()
        .filter(|l| {
            let trimmed = l.trim();
            !trimmed.starts_with("/// expect:")
                && !trimmed.starts_with("/// expect-error:")
                && !trimmed.starts_with("/// #")
                && !(trimmed.starts_with("///") && !trimmed.starts_with("////"))
        })
        .collect();

    // Trim leading and trailing empty lines
    while code.first().map_or(false, |l| l.trim().is_empty()) {
        code.remove(0);
    }
    while code.last().map_or(false, |l| l.trim().is_empty()) {
        code.pop();
    }

    if code.is_empty() {
        None
    } else {
        Some(code.join("\n"))
    }
}

/// Generate full LLM-friendly spec with one example per feature.
pub fn show_llm_full() {
    println!("# Forge Language Spec (full)");
    println!("# Types: int, float, string, bool, null, list<T>, map<K,V>, fn<(A)->R>");
    println!("# Truthy: everything except false, null, 0, \"\"");
    println!();

    for (group_name, features) in FeatureRegistry::by_category() {
        let mut group_output = String::new();

        for meta in &features {
            group_output.push_str(&format!("# {}\n", feature_desc(meta)));
            if !meta.syntax.is_empty() {
                for s in meta.syntax {
                    group_output.push_str(&format!("{}\n", s));
                }
            }
            if let Some(example) = read_first_example(meta.id) {
                group_output.push_str("```\n");
                group_output.push_str(&example);
                group_output.push_str("\n```\n");
            }
            group_output.push('\n');
        }

        if !group_output.is_empty() {
            println!("## {}", group_name);
            print!("{}", group_output);
        }
    }

    // Built-in methods section
    println!("## Built-in Methods");
    println!("string: .length() .split(sep) .trim() .contains(sub) .upper() .lower() .starts_with(s) .ends_with(s) .replace(old,new) .parse_int() .repeat(n)");
    println!("list<T>: .length .push(val) .map(fn) .filter(fn) .sorted() .each(fn) .find(fn) .any(fn) .all(fn) .sum() .join(sep) .reduce(fn) .enumerate() .clone()");
    println!("map<K,V>: .has(key) .get(key) .keys() .length");
    println!("json: .parse(str) .stringify(val)");

    // Packages section
    let packages = discover_packages();
    if !packages.is_empty() {
        println!();
        println!("## Packages");
        for p in &packages {
            let mut parts = Vec::new();
            if !p.description.is_empty() {
                parts.push(p.description.clone());
            }
            for comp in &p.components {
                if !comp.syntax_patterns.is_empty() {
                    let patterns: Vec<String> = comp
                        .syntax_patterns
                        .iter()
                        .take(3)
                        .map(|s| s.clone())
                        .collect();
                    parts.push(format!("{} {{ {} }}", comp.name, patterns.join("; ")));
                } else if !comp.config_fields.is_empty() {
                    let fields: Vec<String> = comp
                        .config_fields
                        .iter()
                        .map(|(n, t, d)| {
                            if d.is_empty() {
                                format!("{}: {}", n, t)
                            } else {
                                format!("{}: {} = {}", n, t, d)
                            }
                        })
                        .collect();
                    parts.push(format!("{} {{ config: {} }}", comp.name, fields.join(", ")));
                } else {
                    parts.push(comp.name.clone());
                }
            }
            if p.components.is_empty() && !p.extern_fns.is_empty() {
                let fn_names: Vec<String> = p
                    .extern_fns
                    .iter()
                    .take(5)
                    .map(|f| {
                        let short = f
                            .name
                            .strip_prefix(&format!("forge_{}_", p.namespace))
                            .unwrap_or(&f.name);
                        format!("{}.{}()", p.namespace, short)
                    })
                    .collect();
                parts.push(fn_names.join(", "));
            }
            println!("@{}: {}", p.namespace, parts.join(" -- "));
        }
    }
}

// ── Grammar ─────────────────────────────────────────────────────────

/// Output a BNF-style grammar assembled from feature syntax fields.
pub fn show_grammar() {
    println!("Forge Grammar (auto-generated from feature syntax rules)");
    println!("{}", "\u{2550}".repeat(56));
    println!();
    println!("<program>     ::= <statement>*");
    println!("<statement>   ::= <let_stmt> | <mut_stmt> | <fn_decl> | <if_stmt> | <for_stmt>");
    println!("                | <while_stmt> | <match_expr> | <spawn_block> | <defer_stmt>");
    println!("                | <component_block> | <expr_stmt>");
    println!();

    for (group_name, features) in FeatureRegistry::by_category() {
        let mut group_rules: Vec<String> = Vec::new();

        for meta in &features {
            if !meta.syntax.is_empty() {
                for s in meta.syntax {
                    group_rules.push(s.to_string());
                }
            } else if !meta.grammar.is_empty() {
                group_rules.push(meta.grammar.to_string());
            }
        }

        if !group_rules.is_empty() {
            println!(
                "\u{2500}\u{2500} {} {}",
                group_name,
                "\u{2500}".repeat(52usize.saturating_sub(group_name.len() + 4))
            );
            for rule in &group_rules {
                println!("{}", rule);
            }
            println!();
        }
    }
}

// ── Cheatsheet ──────────────────────────────────────────────────────

/// Print a two-column cheatsheet.
pub fn show_cheatsheet() {
    println!();
    println!("  Forge Cheatsheet");
    println!("  {}", "\u{2550}".repeat(16));
    println!();

    let col_width = 38;

    let sections: &[(&str, &[&str], &str, &[&str])] = &[
        (
            "VARIABLES",
            &[
                "let x = 1",
                "mut y = 2",
                "const PI = 3.14",
                "let name: string = \"hi\"",
            ],
            "FUNCTIONS",
            &[
                "fn add(a: int, b: int) -> int {",
                "    a + b",
                "}",
                "fn greet(name: string) { }",
            ],
        ),
        (
            "CLOSURES",
            &[
                "(x) -> x * 2",
                "(x, y) -> { x + y }",
                "list.map(it > 0)    # it param",
            ],
            "CONTROL FLOW",
            &[
                "if cond { } else { }",
                "for x in list { }",
                "while cond { }",
                "match expr { p -> body }",
            ],
        ),
        (
            "OPERATORS",
            &[
                "data |> transform |> output",
                "1..10          # exclusive range",
                "1..=10         # inclusive range",
                "x is int       # type check",
            ],
            "COLLECTIONS",
            &[
                "[1, 2, 3]              # list",
                "{key: \"val\"}           # map",
                "(1, \"two\", true)       # tuple",
                "type Point { x: int }  # struct",
            ],
        ),
        (
            "NULL SAFETY",
            &[
                "let x: int? = null",
                "x ?? default_value",
                "x?.method()",
                "result?        # propagate error",
            ],
            "CONCURRENCY",
            &[
                "spawn { work() }",
                "ch <- val         # send",
                "<- ch             # receive",
                "select { x <- ch -> body }",
            ],
        ),
        (
            "STRINGS",
            &[
                "\"hello ${name}\"      # template",
                "$\"echo ${cmd}\"       # shell exec",
                "s.split(\",\")  s.trim()",
                "s.length()  s.upper()",
            ],
            "SPECIAL",
            &[
                "defer cleanup()       # runs at end",
                "expr with { f: val }  # struct update",
                "5m  30s  24h  7d      # durations",
                "use @std.fs.{fs}      # imports",
            ],
        ),
    ];

    for (left_title, left_lines, right_title, right_lines) in sections {
        let max_rows = left_lines.len().max(right_lines.len());
        println!(
            "  {:<width$} {}",
            left_title,
            right_title,
            width = col_width
        );
        for i in 0..max_rows {
            let left = left_lines.get(i).unwrap_or(&"");
            let right = right_lines.get(i).unwrap_or(&"");
            println!("  {:<width$} {}", left, right, width = col_width);
        }
        println!();
    }

    println!(
        "  {}",
        dim("Detail: forge lang <feature>  |  forge lang --grammar  |  forge lang --llm")
    );
    println!();
}

// ── Search ──────────────────────────────────────────────────────────

/// Search result with relevance score.
struct SearchResult {
    category: &'static str,
    name: String,
    description: String,
    score: u8, // higher = better match
}

/// Fuzzy/substring search across all docs.
pub fn show_search(query: &str) {
    let query_lower = query.to_lowercase();
    let mut results: Vec<SearchResult> = Vec::new();

    // Search features
    let features = FeatureRegistry::all();
    for f in &features {
        let score =
            search_score(&query_lower, f.id, f.name, feature_desc(f), f.tokens, f.symbols);
        if score > 0 {
            results.push(SearchResult {
                category: "Features",
                name: f.id.to_string(),
                description: feature_desc(f).to_string(),
                score,
            });
        }
        // Search syntax lines
        for s in f.syntax {
            if s.to_lowercase().contains(&query_lower) {
                results.push(SearchResult {
                    category: "Syntax",
                    name: f.id.to_string(),
                    description: s.to_string(),
                    score: 2,
                });
            }
        }
    }

    // Search types and methods
    for t in BUILTIN_TYPES {
        if t.name.contains(&query_lower)
            || t.description.to_lowercase().contains(&query_lower)
        {
            results.push(SearchResult {
                category: "Types",
                name: t.name.to_string(),
                description: t.description.to_string(),
                score: if t.name == query_lower { 5 } else { 2 },
            });
        }
        for m in t.methods {
            let method_name = format!("{}.{}", t.name, m.name);
            if m.name.contains(&query_lower)
                || m.description.to_lowercase().contains(&query_lower)
                || m.signature.to_lowercase().contains(&query_lower)
            {
                results.push(SearchResult {
                    category: "Methods",
                    name: method_name,
                    description: m.description.to_string(),
                    score: if m.name == query_lower { 5 } else { 2 },
                });
            }
        }
    }

    // Search error codes
    let registry = ErrorRegistry::builtin();
    let codes = registry.all_codes();
    for code in codes {
        if let Some(entry) = registry.lookup(code) {
            if code.to_lowercase().contains(&query_lower)
                || entry.title.to_lowercase().contains(&query_lower)
                || entry.message.to_lowercase().contains(&query_lower)
            {
                results.push(SearchResult {
                    category: "Errors",
                    name: code.to_string(),
                    description: entry.title.clone(),
                    score: if code.to_lowercase() == query_lower { 5 } else { 2 },
                });
            }
        }
    }

    // Search packages
    let packages = discover_packages();
    for p in &packages {
        let ns_lower = p.namespace.to_lowercase();
        let name_lower = p.name.to_lowercase();
        let desc_lower = p.description.to_lowercase();

        let score = if ns_lower == query_lower || name_lower == query_lower {
            5
        } else if ns_lower.contains(&query_lower)
            || name_lower.contains(&query_lower)
            || desc_lower.contains(&query_lower)
        {
            2
        } else {
            // Check component names
            let comp_match = p.components.iter().any(|c| c.name.to_lowercase().contains(&query_lower));
            if comp_match { 2 } else { 0 }
        };

        if score > 0 {
            let desc = if p.description.is_empty() {
                format!("{} components", p.components.len())
            } else {
                p.description.clone()
            };
            results.push(SearchResult {
                category: "Packages",
                name: format!("@{}", p.namespace),
                description: desc,
                score,
            });
        }
    }

    // Sort by score descending, then by name
    results.sort_by(|a, b| b.score.cmp(&a.score).then(a.name.cmp(&b.name)));

    if results.is_empty() {
        println!();
        println!("  No results for \"{}\".", query);
        println!("  Try: {}", cyan("forge lang --all"));
        println!();
        return;
    }

    println!();
    println!("  Search results for \"{}\"", query);
    println!("  {}", dim(&"\u{2500}".repeat(20 + query.len())));
    println!();

    // Group by category
    let categories = ["Features", "Syntax", "Types", "Methods", "Packages", "Errors"];
    for cat in &categories {
        let cat_results: Vec<&SearchResult> =
            results.iter().filter(|r| r.category == *cat).collect();
        if cat_results.is_empty() {
            continue;
        }
        println!("  {}", bold(cat));
        for r in &cat_results {
            let desc = truncate_str(&r.description, 50);
            println!("    {:<24} {}", r.name, dim(&desc));
        }
        println!();
    }

    println!("  {}", dim("Hint: forge lang <name> for full docs"));
    println!();
}

/// Calculate search relevance score.
fn search_score(
    query: &str,
    id: &str,
    name: &str,
    desc: &str,
    tokens: &[&str],
    symbols: &[&str],
) -> u8 {
    let id_lower = id.to_lowercase();
    let name_lower = name.to_lowercase();
    let desc_lower = desc.to_lowercase();

    // Exact match on id or name
    if id_lower == *query || name_lower == *query {
        return 5;
    }
    // Token/symbol exact match
    for t in tokens.iter().chain(symbols.iter()) {
        if t.to_lowercase() == *query {
            return 4;
        }
    }
    // Starts with
    if id_lower.starts_with(query) || name_lower.starts_with(query) {
        return 3;
    }
    // Contains in id or name
    if id_lower.contains(query) || name_lower.contains(query) {
        return 2;
    }
    // Contains in description
    if desc_lower.contains(query) {
        return 1;
    }
    0
}
