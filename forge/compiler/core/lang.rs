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

// ── Provider documentation ──────────────────────────────────────────

struct ProviderDoc {
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

/// Discover all providers by scanning the providers/ directory.
fn discover_providers() -> Vec<ProviderDoc> {
    let providers_dir = find_providers_dir();
    let providers_dir = match providers_dir {
        Some(d) => d,
        None => return vec![],
    };

    let mut providers = Vec::new();
    let mut entries: Vec<_> = std::fs::read_dir(&providers_dir)
        .ok()
        .into_iter()
        .flatten()
        .filter_map(|e| e.ok())
        .filter(|e| e.path().is_dir())
        .collect();
    entries.sort_by_key(|e| e.file_name());

    for entry in entries {
        let dir = entry.path();
        let toml_path = dir.join("provider.toml");
        let fg_path = dir.join("src").join("provider.fg");

        if !toml_path.exists() {
            continue;
        }

        if let Some(doc) = parse_provider(&toml_path, &fg_path) {
            providers.push(doc);
        }
    }

    providers
}

/// Find the providers/ directory relative to the binary or source tree.
fn find_providers_dir() -> Option<PathBuf> {
    // Try relative to the current exe
    if let Ok(exe) = std::env::current_exe() {
        // exe is in target/release/ or target/debug/, providers is at forge/providers/
        let mut dir = exe.parent()?.to_path_buf();
        // Walk up looking for providers/
        for _ in 0..5 {
            let candidate = dir.join("providers");
            if candidate.is_dir() {
                return Some(candidate);
            }
            dir = dir.parent()?.to_path_buf();
        }
    }

    // Try CWD-based paths
    let cwd = std::env::current_dir().ok()?;
    for candidate in &[
        cwd.join("providers"),
        cwd.join("forge").join("providers"),
    ] {
        if candidate.is_dir() {
            return Some(candidate.clone());
        }
    }

    None
}

/// Parse a provider from its provider.toml and provider.fg files.
fn parse_provider(toml_path: &PathBuf, fg_path: &PathBuf) -> Option<ProviderDoc> {
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

    // Parse provider.fg for extern fns and component details
    let fg_content = std::fs::read_to_string(fg_path).unwrap_or_default();
    let (extern_fns, components) = parse_provider_fg(&fg_content, &component_names);

    Some(ProviderDoc {
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

/// Parse provider.fg to extract extern fns and component details.
fn parse_provider_fg(
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

/// Show documentation for a single provider.
fn show_provider(provider: &ProviderDoc) {
    let header = format!("@{}", provider.namespace);
    let right = format!(
        "{} v{}",
        provider.name, provider.version
    );

    println!();
    println!("  {:<52} {}", bold(&header), dim(&right));
    println!("  {}", dim(&"\u{2500}".repeat(57)));
    println!();

    if !provider.description.is_empty() {
        println!("  {}", provider.description);
        println!();
    }

    // Components
    if !provider.components.is_empty() {
        println!("  {}", bold("Components"));
        for comp in &provider.components {
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
    if !provider.extern_fns.is_empty() {
        println!("  {}", bold("Extern Functions"));
        for efn in &provider.extern_fns {
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

/// Show documentation for a specific component within a provider.
fn show_provider_component(provider: &ProviderDoc, component_name: &str) {
    let comp = match provider.components.iter().find(|c| c.name == component_name) {
        Some(c) => c,
        None => {
            println!(
                "\n  No component '{}' in @{}. Available: {}\n",
                component_name,
                provider.namespace,
                provider
                    .components
                    .iter()
                    .map(|c| c.name.as_str())
                    .collect::<Vec<_>>()
                    .join(", ")
            );
            return;
        }
    };

    let header = format!("@{}.{}", provider.namespace, comp.name);
    let right = format!("{} v{}", provider.name, provider.version);

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

/// Show all providers in a compact list.
fn show_all_providers() {
    let providers = discover_providers();

    println!();
    println!("  {}", bold("Providers"));
    println!("  {}", dim(&"\u{2500}".repeat(9)));
    println!();

    if providers.is_empty() {
        println!("    {}", dim("(no providers found)"));
        println!();
        return;
    }

    for p in &providers {
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
        cyan("forge lang @<provider>")
    );
    println!();
}

/// Look up a provider by namespace (e.g., "http" -> std-http).
fn find_provider_by_namespace<'a>(providers: &'a [ProviderDoc], ns: &str) -> Option<&'a ProviderDoc> {
    providers.iter().find(|p| p.namespace == ns)
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

// ── Long descriptions ───────────────────────────────────────────────

/// Return a rich multi-paragraph description for a feature, or empty string if none.
pub fn long_description(id: &str) -> &'static str {
    match id {
        "variables" => "\
Variables in Forge are declared with `let` for immutable bindings, `mut` for mutable ones, \
and `const` for compile-time constants. Immutability is the default, which means `let x = 10` \
creates a binding that can never be reassigned. This design choice catches an entire class of \
bugs at compile time and makes code easier to reason about, since you always know a `let` \
binding holds the value it was initialized with.

Type inference means you rarely need to annotate types. The compiler figures out that \
`let name = \"Alice\"` is a `string` and `let count = 42` is an `int`. When you do want \
to be explicit, annotations go after the name: `let ratio: float = 3.14`. Mutable variables \
use `mut`: `mut counter = 0` followed by `counter = counter + 1`.

Constants declared with `const` must have values known at compile time. Unlike `let` bindings, \
constants are inlined everywhere they are used, so they carry zero runtime cost. Use constants \
for magic numbers, configuration values, and anything that should never change across the \
lifetime of the program.

If you are coming from JavaScript or Python, the key difference is that Forge variables are \
immutable by default. If you are coming from Rust, the model is similar but without lifetime \
annotations. If you are coming from Go, think of `let` as a stricter `:=` that forbids reassignment.",

        "functions" => "\
Functions are declared with `fn`, followed by the function name, parameters in parentheses, \
and an optional return type. The body is a block expression, and the last expression in the \
block is the implicit return value. For example: `fn double(x: int) -> int { x * 2 }`.

Parameter types are required, but return types can usually be inferred. If a function returns \
nothing, the return type is `void`. Functions are first-class values: you can pass them as \
arguments, store them in variables, and return them from other functions.

Forge functions support early return with the `return` keyword, but idiomatic Forge prefers \
implicit returns via the last expression. This keeps functions concise and encourages a \
functional style. Functions can call themselves recursively, and the compiler handles tail \
calls efficiently where possible.

Unlike languages that distinguish between functions and methods at the syntax level, Forge \
treats all callables uniformly. Methods on types are just functions that receive the type as \
their first argument, accessed through dot notation.",

        "closures" => "\
Closures are anonymous functions created with the arrow syntax: `(x) -> x * 2`. They capture \
variables from their surrounding scope and can be passed as arguments, stored in variables, or \
returned from functions. Closures are the primary way to pass behavior in Forge, used heavily \
with collection methods like `map`, `filter`, and `each`.

The syntax is deliberately minimal. A single-parameter closure needs no parentheses around the \
parameter list: `x -> x + 1`. Multi-parameter closures use parentheses: `(a, b) -> a + b`. \
For closures with a single parameter, Forge also supports the `it` implicit parameter, so \
`list.map(it * 2)` is equivalent to `list.map((x) -> x * 2)`.

Closures infer their parameter and return types from context. When you write \
`numbers.map((n) -> n.to_string())`, the compiler knows `n` is an `int` because `numbers` is \
a `list<int>`, and knows the closure returns `string` because `to_string()` does.

Compared to other languages, Forge closures are closest to Kotlin's lambdas or Swift's \
closures. The `->` syntax was chosen over `=>` (JavaScript) to avoid ambiguity with comparison \
operators and to visually distinguish closures from match arms.",

        "if_else" => "\
In Forge, `if`/`else` are expressions, not statements. This means they produce a value and can \
be used anywhere an expression is expected. For example: `let status = if score > 90 { \"A\" } \
else { \"B\" }`. The last expression in each branch becomes the value of the entire `if` expression.

Conditions do not require parentheses. Write `if x > 0 { ... }` rather than `if (x > 0) { ... }`. \
The `else if` chain works as expected for multiple conditions: \
`if x > 0 { \"positive\" } else if x < 0 { \"negative\" } else { \"zero\" }`.

Because `if` is an expression, there is no need for a ternary operator. The expression form is \
both more readable and more flexible than C-style ternaries. When used as a statement (ignoring \
the return value), `if` works exactly as you would expect from any other language.

Type checking ensures that both branches of an `if`/`else` return the same type when the result \
is used as a value. If you write `let x = if cond { 1 } else { \"two\" }`, the compiler will \
report a type mismatch.",

        "for_loops" => "\
For loops in Forge use the `for...in` syntax to iterate over ranges, lists, maps, and channels. \
The simplest form is `for i in 0..10 { ... }` which iterates from 0 to 9. Use `0..=10` for an \
inclusive range that includes 10.

When iterating over lists, the loop variable takes on each element: `for item in my_list { ... }`. \
For maps, you can destructure the key-value pair: `for (key, value) in my_map { ... }`. This \
uniform syntax means you learn one loop construct and use it everywhere.

For loops can also iterate over channels, which makes them a natural fit for concurrent programming \
patterns. When used with a channel, `for msg in ch { ... }` will receive and process messages until \
the channel is closed. This is the idiomatic way to consume a stream of values from a concurrent task.

Unlike C-style for loops, Forge's `for...in` cannot produce off-by-one errors because you never \
manually manage an index variable. If you need the index alongside the value, use the `enumerate` \
method on the collection.",

        "while_loops" => "\
While loops repeat a block as long as a condition remains true. The syntax is straightforward: \
`while condition { body }`. This is the right choice when the number of iterations is not known \
in advance and depends on some runtime condition.

A common pattern is `while true { ... }` for infinite loops that terminate via `break`. This is \
useful for event loops, REPL implementations, and retry logic. The `break` keyword exits the \
loop immediately, and `continue` skips to the next iteration.

While loops are generally less common in idiomatic Forge than `for...in` loops, since most \
iteration involves collections or ranges. Prefer `for` when you know what you are iterating over, \
and reserve `while` for conditions that depend on external state or complex termination logic.",

        "operators" => "\
Forge provides the standard set of arithmetic operators (`+`, `-`, `*`, `/`, `%`), comparison \
operators (`==`, `!=`, `<`, `>`, `<=`, `>=`), and logical operators (`and`, `or`, `not`). \
Arithmetic operators work on `int` and `float` types, with automatic promotion when mixing them.

String concatenation uses `+`, so `\"hello\" + \" world\"` produces `\"hello world\"`. Comparison \
operators work on numbers and strings (lexicographic comparison). Logical operators use words \
rather than symbols (`and` instead of `&&`, `or` instead of `||`) for readability.

The `%` modulo operator returns the remainder of integer division. Division between two integers \
performs integer division; use a float operand if you need decimal results. All operators have \
the precedence you would expect from mathematics: multiplication and division bind tighter than \
addition and subtraction, and comparison operators bind tighter than logical operators.

Forge deliberately omits bitwise operators from the core language, since they are rarely needed \
in application-level code. This keeps the operator set small and the precedence rules simple.",

        "pattern_matching" => "\
Pattern matching with `match` is one of the most powerful features in Forge. A match expression \
takes a value and compares it against a series of patterns, executing the arm that matches first. \
Unlike chains of `if`/`else if`, match is exhaustive: the compiler verifies that every possible \
case is covered, preventing subtle bugs.

Patterns can match literal values (`1`, `\"hello\"`), bind variables (`x`), destructure data \
structures, and use guards for additional conditions. For example: \
`match status { \"ok\" -> handle_ok(), \"error\" -> handle_err(), _ -> handle_unknown() }`. \
The underscore `_` is the wildcard pattern that matches anything.

Guards add conditions to patterns with `if`: `match score { n if n > 90 -> \"A\", n if n > 80 -> \"B\", _ -> \"C\" }`. \
This combines the clarity of pattern matching with the flexibility of arbitrary boolean conditions. \
Guards are checked after the pattern matches, so you can use bound variables in the guard expression.

Match works especially well with enums, where each variant becomes a pattern. The compiler ensures \
every variant is handled, so adding a new variant to an enum immediately highlights every match \
expression that needs updating. This is the same exhaustiveness guarantee that makes Rust's and \
Haskell's pattern matching so reliable.",

        "ranges" => "\
Ranges represent a sequence of consecutive values, written with the `..` operator. An exclusive \
range `0..5` includes 0, 1, 2, 3, 4. An inclusive range `0..=5` also includes 5. Ranges are most \
commonly used in `for` loops: `for i in 0..n { ... }`.

Ranges are first-class values that can be stored in variables and passed to functions. They support \
the `contains` method for membership testing: `(1..10).contains(5)` returns true. This makes ranges \
useful for validation and bounds checking beyond just iteration.

The exclusive range `..` is the default because it aligns with zero-based indexing. When you write \
`for i in 0..list.length() { ... }`, there is no off-by-one risk. Use the inclusive form `..=` \
when you specifically need the endpoint, such as `for day in 1..=31 { ... }`.",

        "enums" => "\
Enums in Forge are algebraic data types that define a type with a fixed set of named variants. \
Each variant can optionally carry data of any type. This makes enums far more powerful than the \
simple integer enumerations found in C or Java. For example: \
`enum Shape { Circle(float), Rectangle(float, float), Point }`.

Enums are constructed by naming the variant: `let s = Shape.Circle(5.0)`. Pattern matching with \
`match` is the primary way to work with enums, and the compiler ensures every variant is handled. \
This exhaustiveness checking catches entire categories of bugs at compile time.

Enums are ideal for modeling state machines, command sets, message types, error categories, and \
any domain where a value is exactly one of several possibilities. The Result and Option types that \
power Forge's error handling and null safety are themselves enums under the hood.

If you are familiar with Rust enums, Swift enums with associated values, or Haskell data types, \
Forge enums work the same way. If you are coming from TypeScript, think of them as discriminated \
unions with compiler-enforced exhaustiveness.",

        "structs" => "\
Structs define structural types with named fields. They are the primary way to group related data \
in Forge. Declaration syntax is: `type Point { x: int, y: int }`. Instances are created with \
literal syntax: `let p = Point { x: 10, y: 20 }`. Fields are accessed with dot notation: `p.x`.

Forge structs are immutable by default. To create a modified copy, use the `with` expression: \
`let q = p with { x: 30 }`. This creates a new struct with the specified fields changed and all \
others copied from the original. This approach encourages immutable data flow and makes it clear \
exactly which fields differ between two values.

Structs support shorthand field initialization when the variable name matches the field name: \
`let x = 10; let y = 20; Point { x, y }`. This reduces boilerplate when constructing structs \
from local variables with matching names.

Unlike classes in object-oriented languages, Forge structs carry no methods or inheritance. \
Behavior is attached through trait implementations, keeping data and behavior cleanly separated. \
This design scales better for large codebases and avoids the deep inheritance hierarchies that \
plague OOP systems.",

        "tuples" => "\
Tuples are fixed-size heterogeneous collections that group values of potentially different types. \
A tuple is written as `(value1, value2, ...)` and its type is `(Type1, Type2, ...)`. For example, \
`let pair = (\"Alice\", 30)` creates a tuple of type `(string, int)`.

Elements are accessed by position using dot notation with an index: `pair.0` returns `\"Alice\"` \
and `pair.1` returns `30`. Tuples are most useful for returning multiple values from functions \
without defining a named struct: `fn divide(a: int, b: int) -> (int, int) { (a / b, a % b) }`.

Tuples can be destructured in `let` bindings: `let (quotient, remainder) = divide(10, 3)`. This \
makes working with multi-return functions feel natural. Pattern matching also supports tuple \
patterns for more complex destructuring scenarios.

Compared to other languages, Forge tuples are closest to Python or Rust tuples. Use tuples for \
quick grouping of a few values. When you find yourself using tuples with more than three or four \
elements, consider switching to a named struct for clarity.",

        "collections" => "\
Forge provides two built-in collection types: `list<T>` and `map<K, V>`. Lists are ordered, \
indexed sequences created with square brackets: `let nums = [1, 2, 3]`. Maps are key-value \
stores created with curly braces: `let ages = { \"Alice\": 30, \"Bob\": 25 }`.

Lists support a rich set of methods: `push`, `pop`, `map`, `filter`, `reduce`, `each`, \
`length`, `contains`, `sorted`, `join`, and more. Chaining these methods with closures is the \
idiomatic way to transform data: `numbers.filter((n) -> n > 0).map((n) -> n * 2)`. Lists are \
generic, so `list<int>`, `list<string>`, and `list<list<int>>` are all valid types.

Maps support `get`, `set`, `keys`, `values`, `contains`, and `length`. Map access uses bracket \
notation: `ages[\"Alice\"]`. When a key might not exist, use the null-safe access `ages[\"Charlie\"]?` \
combined with `??` to provide a default.

Both collections are mutable when declared with `mut`. Immutable collections cannot have elements \
added or removed, making them safe to share across function boundaries without defensive copying.",

        "strings" => "\
Strings in Forge are UTF-8 encoded, immutable sequences of characters. String literals use double \
quotes: `\"hello world\"`. Template literals with `${}` interpolation provide the primary way to \
build strings dynamically: `\"Hello, ${name}! You are ${age} years old.\"`.

Strings support a comprehensive set of methods: `length()`, `contains(sub)`, `starts_with(prefix)`, \
`ends_with(suffix)`, `to_upper()`, `to_lower()`, `trim()`, `split(separator)`, `replace(old, new)`, \
`substring(start, end)`, and more. These methods return new strings rather than mutating in place, \
consistent with Forge's immutability-first design.

String comparison uses `==` for value equality, not reference equality. Strings can be concatenated \
with `+`, though template literals are preferred for building complex strings since they are more \
readable and less error-prone than chained concatenation.

Multi-line strings are supported naturally. Forge does not have a separate character type; single \
characters are simply strings of length one.",

        "generics" => "\
Generics let you write functions and types that work with any type, while still maintaining full \
type safety. A generic function is declared with type parameters in angle brackets: \
`fn identity<T>(x: T) -> T { x }`. The type parameter `T` is replaced with a concrete type at \
each call site.

Generic types work the same way: `type Wrapper<T> { value: T }` creates a type that can wrap any \
other type. You can instantiate it as `Wrapper<int> { value: 42 }` or `Wrapper<string> { value: \"hi\" }`.

Type parameters can be constrained with trait bounds to require certain capabilities. This ensures \
that generic code can only be called with types that support the operations it needs, catching type \
errors at compile time rather than runtime.

Forge's generics are similar to those in Rust, TypeScript, and Java. They use monomorphization \
at compile time, meaning generic code has zero runtime overhead: the compiler generates specialized \
versions for each concrete type used.",

        "traits" => "\
Traits define shared interfaces that types can implement. A trait declares a set of method \
signatures that implementing types must provide: `trait Printable { fn to_display() -> string }`. \
Types implement traits with `impl` blocks: `impl Printable for Point { fn to_display() -> string { ... } }`.

Traits enable polymorphism without inheritance. A function that accepts `impl Printable` can work \
with any type that implements the trait, regardless of the type's other characteristics. This is \
more flexible than class-based inheritance because a type can implement any number of traits.

Trait bounds on generic type parameters constrain what operations are available: \
`fn print_all<T: Printable>(items: list<T>)` ensures every item can be displayed. This catches \
errors at compile time and provides clear documentation about what a function requires.

If you are coming from Go, Forge traits are similar to interfaces. From Rust, they work the same \
way. From Java or C#, think of them as interfaces with no default methods. From TypeScript, they \
are like structural interfaces but explicitly declared.",

        "imports" => "\
The `use` statement brings names from other modules and providers into scope. External providers \
are imported with the `@` prefix: `use @std.http` makes the HTTP provider's functions and \
components available. Local module imports follow the same pattern without the prefix.

Provider imports are the primary mechanism for extending Forge's capabilities. Each provider \
contributes types, functions, and component templates. The `use` statement triggers provider \
loading at compile time, making all provider exports available for the rest of the file.

Multiple imports can be grouped, and the compiler resolves dependencies between providers \
automatically. Circular dependencies between user modules are detected and reported as errors.",

        "immutability" => "\
Forge is immutable by default. Variables declared with `let` cannot be reassigned after \
initialization. This is not a convention or a lint rule; it is enforced by the compiler. \
Attempting to assign to a `let` binding produces error F0013 with a clear message explaining \
the immutability constraint.

Mutable bindings require the explicit `mut` keyword: `mut counter = 0`. This makes every \
mutation point visible in the code. When reading a function, you can immediately see which \
values might change by scanning for `mut` declarations. This is especially valuable in larger \
codebases where understanding data flow is critical.

Constants declared with `const` are even stricter: their values must be known at compile time, \
and they are inlined at every usage site. Use `const` for configuration values, mathematical \
constants, and fixed strings.

The immutable-by-default philosophy extends beyond variables to data structures. Structs created \
with `let` have immutable fields. The `with` expression creates modified copies rather than \
mutating in place. This approach eliminates shared mutable state, the root cause of countless \
bugs in imperative programs.",

        "type_operators" => "\
Type operators are compile-time transformations that derive new types from existing ones. \
Forge provides `without`, `only`, `partial`, and `with` for manipulating struct types. \
For example, `type CreateUser = User without { id }` creates a type with all User fields \
except `id`.

The `only` operator selects a subset of fields: `type UserName = User only { name, email }`. \
The `partial` operator makes all fields optional: `type UserUpdate = User partial`. \
The `with` operator adds or overrides fields: `type AdminUser = User with { role: string }`.

These operators are essential for API design, where you often need variations of a base type \
for different operations (create, update, response). Instead of manually maintaining parallel \
type definitions that drift out of sync, type operators derive the variations and keep them \
consistent automatically.

Type operators compose: `type CreateUser = User without { id } with { password: string }` \
removes the `id` field and adds a `password` field in a single declaration. This is similar \
to TypeScript's `Omit`, `Pick`, and `Partial` utility types but with cleaner syntax.",

        "pipe_operator" => "\
The pipe operator `|>` passes the result of the left expression as the first argument to the \
right function. It transforms nested function calls into a readable left-to-right chain. Instead \
of `to_upper(trim(read_file(\"input.txt\")))`, you write: \
`read_file(\"input.txt\") |> trim() |> to_upper()`.

Pipes also work with method calls. `data |> process(config)` is equivalent to `process(data, config)`, \
and `text |> .trim()` calls the method on the piped value. This makes long transformation \
pipelines read like a recipe: each step takes the previous result and transforms it further.

Multi-line pipes are supported for complex chains. The `|>` operator can appear at the start of \
a continuation line, so you can format pipelines vertically for readability.

The pipe operator is inspired by Elixir and F#, where it is fundamental to the language's style. \
In Forge, it pairs especially well with closures and collection methods, enabling a fluent, \
functional programming style without sacrificing type safety.",

        "null_safety" => "\
Forge eliminates null pointer exceptions through its type system. A type like `string` can never \
be null. To represent the absence of a value, you use a nullable type: `string?`. The compiler \
tracks nullability through every operation and refuses to compile code that could dereference a \
null value without checking first.

The optional chaining operator `?.` safely accesses fields and methods on nullable values. \
`user?.name` returns the name if `user` is not null, or null otherwise. This chains beautifully: \
`user?.address?.city` navigates a nullable chain without any of the defensive `if` checks that \
litter null-unsafe code.

The null coalescing operator `??` provides a default value when something is null: \
`user?.name ?? \"anonymous\"` returns the name if available, or `\"anonymous\"` if not. Combined \
with `?.`, this handles the vast majority of null-handling scenarios in a single expression.

The `?` suffix on function return types indicates the function might return null: \
`fn find_user(id: int) -> User?`. Callers must handle the null case, either with `?.`, `??`, \
or an explicit null check. This makes null a deliberate, visible choice rather than a hidden \
landmine.",

        "error_propagation" => "\
Error propagation in Forge uses the `?` operator to bubble errors up the call stack. When a \
function returns a Result type, appending `?` to the call either unwraps the success value or \
immediately returns the error to the caller. This eliminates the verbose `if err != nil` checks \
found in Go and the sprawling try/catch blocks of Java.

The `?` operator can only be used inside functions that themselves return a Result type. The \
compiler enforces this rule, so you always know whether a function can fail by looking at its \
return type. There are no hidden error paths.

For functions that need to handle errors rather than propagate them, the `catch` pattern provides \
structured error handling. This gives you the control of try/catch when you need it, while the \
`?` operator handles the common case of simply passing errors upward.

This design is directly inspired by Rust's `?` operator and Result type. It provides the same \
safety guarantees — every error must be explicitly handled or propagated — while keeping the \
syntax lightweight. Compared to exceptions, it makes error paths visible in type signatures and \
prevents the \"exception from nowhere\" problem.",

        "defer" => "\
The `defer` statement schedules an expression to execute when the enclosing scope exits, \
regardless of whether the exit is normal or due to an error. This is the primary mechanism \
for resource cleanup in Forge: `let f = open(path); defer close(f)`. No matter how the \
function returns, the file will be closed.

Deferred expressions execute in LIFO (last-in, first-out) order. If you defer A then defer B, \
B executes first, then A. This matches the natural pattern of resource acquisition: resources \
acquired later should be released first.

Defer eliminates the need for finally blocks, destructors, or RAII patterns for resource management. \
It keeps the cleanup code next to the acquisition code, rather than at the bottom of a try/finally \
block potentially hundreds of lines away. This locality makes it easy to verify that every resource \
is properly cleaned up.

The concept comes from Go, where `defer` is used extensively. Forge's implementation works the \
same way, executing deferred expressions before every return point in the function, including \
early returns and error propagation with `?`.",

        "is_keyword" => "\
The `is` keyword tests whether a value matches a pattern or belongs to a type. It returns a \
boolean and is used in conditions: `if value is int { ... }` or `if shape is Circle { ... }`. \
This is the lightweight alternative to a full `match` expression when you only care about one case.

With enums, `is` checks for a specific variant: `if result is Ok { ... }`. Combined with \
`if let`-style binding, it can extract the associated data: `if result is Ok(value) { ... }`. \
This handles the common pattern of checking-and-extracting in a single, readable expression.

The `is` keyword also works with nullable types: `if x is null { ... }` checks for null, and \
`if x is string { ... }` checks that a nullable value is present and of the expected type. \
This integrates naturally with Forge's null safety system.

Compared to `instanceof` in Java or `typeof` in JavaScript, `is` is a pattern matching \
operation, not just a type check. It can match literal values, types, enum variants, and \
complex patterns, making it strictly more powerful.",

        "with_expression" => "\
The `with` expression creates a modified copy of an immutable struct. Given \
`let p = Point { x: 1, y: 2 }`, writing `let q = p with { x: 10 }` creates a new Point where \
`x` is 10 and `y` is copied from `p`. The original `p` is unchanged.

This is the idiomatic way to \"update\" immutable data in Forge. Rather than mutating fields in \
place, you express transformations as new values derived from old ones. This makes data flow \
explicit and eliminates bugs caused by unexpected mutation of shared references.

The `with` expression copies all fields from the original, then applies the overrides. Only the \
fields you specify are different; everything else is preserved. This is concise even for structs \
with many fields, since you only mention what changes.

This feature is equivalent to the spread/rest operator for objects in JavaScript \
(`{ ...obj, field: newValue }`), Kotlin's `copy()` method on data classes, or Rust's struct \
update syntax (`Point { x: 10, ..p }`). Forge's `with` keyword reads naturally in English, \
making the intent immediately clear.",

        "it_parameter" => "\
The `it` keyword is an implicit parameter available inside single-argument closures. Instead of \
writing `list.map((x) -> x * 2)`, you can write `list.map(it * 2)`. The `it` variable \
automatically refers to the single argument passed to the closure.

This syntactic sugar reduces noise in common patterns. Collection operations like `map`, `filter`, \
`each`, and `reduce` frequently take simple closures where naming the parameter adds no clarity. \
`numbers.filter(it > 0)` is clearer than `numbers.filter((n) -> n > 0)` because the intent is \
immediately obvious.

The `it` parameter is only available in single-argument closure contexts. If a closure takes \
multiple arguments, you must name them explicitly. This restriction prevents ambiguity and \
ensures `it` always has a clear, unambiguous meaning.

Kotlin popularized this pattern, and it works the same way in Forge. Groovy also uses `it` as \
an implicit closure parameter. The feature is purely syntactic sugar; every use of `it` has an \
equivalent explicit closure form.",

        "table_literal" => "\
Table literals provide a concise syntax for defining tabular data using pipe-delimited columns. \
Instead of a list of structs or a list of lists, you write the data as a visual table directly \
in your source code, with `|` separating columns and each row on its own line.

This syntax is especially useful for test data, configuration tables, and any scenario where \
data is naturally two-dimensional. The visual alignment of columns makes the data easy to read \
and verify at a glance, unlike nested data structures that obscure the tabular nature of the data.

Table literals produce a typed list of records. The first row defines the column names and types, \
and subsequent rows provide the values. The compiler verifies that every row has the correct \
number of columns and that values match the declared types.

This feature is unique to Forge. While languages like Haskell have QuasiQuoters and Ruby has \
heredocs for embedding structured data, Forge's table literals are first-class syntax with full \
type checking and compile-time validation.",

        "shorthand_fields" => "\
Shorthand field syntax allows you to write `{ name }` instead of `{ name: name }` when \
constructing a struct and the variable name matches the field name. This eliminates the \
redundancy that often occurs when building structs from local variables.

For example, if you have `let name = \"Alice\"` and `let age = 30`, you can write \
`Person { name, age }` instead of `Person { name: name, age: age }`. The compiler expands \
each shorthand field to use the variable of the same name as the value.

Shorthand fields can be mixed with regular fields: `Person { name, age: calculate_age(birth_year) }`. \
Only fields where the variable name matches get the shorthand; fields with computed values use \
the full `field: expression` syntax as usual.

This feature is borrowed from JavaScript/TypeScript ES6 object shorthand and Rust's field init \
shorthand. It is a small convenience that significantly reduces visual clutter in code that \
constructs many structs.",

        "tagged_templates" => "\
Tagged templates let you process template literals through a function before they are assembled \
into a string. A tagged template is a function call followed by a template literal: \
`sql\"SELECT * FROM ${table} WHERE id = ${id}\"`. The tag function receives the string parts \
and interpolated values separately, enabling safe, structured processing.

The primary use case is safe SQL query construction, where interpolated values must be \
parameterized to prevent injection attacks. The `sql` tag can build a parameterized query \
with `$1`, `$2` placeholders and a separate values array. HTML escaping, URL encoding, and \
regex construction are other natural applications.

Tag functions receive an array of string fragments and an array of interpolated values, \
giving them full control over how the pieces are assembled. This is strictly more powerful \
than simple string interpolation, since the tag can validate, transform, or reject the \
interpolated values.

Tagged templates originate in JavaScript (ES2015) and work similarly in Forge. The key \
difference is that Forge's version is fully typed: the compiler knows the return type of \
the tag function and type-checks the interpolated expressions.",

        "durations" => "\
Duration literals express time spans directly in code using intuitive suffixes: `7d` for seven \
days, `24h` for twenty-four hours, `5m` for five minutes, and `10s` for ten seconds. These \
compile to millisecond values, providing a type-safe and readable alternative to raw numbers.

Durations are commonly used with timers, timeouts, scheduling, and any API that accepts a time \
interval. Writing `timeout = 30s` is immediately clear, whereas `timeout = 30000` requires the \
reader to mentally convert milliseconds. Duration literals prevent unit confusion bugs entirely.

The supported suffixes are `d` (days), `h` (hours), `m` (minutes), and `s` (seconds). Each is \
converted to milliseconds at compile time, so `1h` equals `3600000`. Duration values can be \
used anywhere an integer is expected, since they are simply integers representing milliseconds.

Duration suffixes are inspired by Kotlin's duration API and Go's time.Duration, but as literal \
syntax they provide even less friction. No imports or method calls are needed; the suffix is \
part of the number literal itself.",

        "datetime" => "\
Forge provides built-in datetime functions for working with timestamps: `datetime_now()` returns \
the current time as epoch milliseconds, `datetime_format(epoch, pattern)` converts an epoch \
timestamp to a formatted string, and `datetime_parse(str, pattern)` parses a date string back \
to epoch milliseconds.

Using epoch milliseconds as the internal representation keeps datetime values as plain integers, \
which means they can be compared with standard operators, stored in any collection, and \
serialized without special handling. The format and parse functions handle the conversion to \
and from human-readable strings.

Format patterns use standard date format specifiers. Common patterns include `\"YYYY-MM-DD\"` \
for dates and `\"YYYY-MM-DD HH:mm:ss\"` for timestamps. The pattern syntax is familiar to \
anyone who has used date formatting in JavaScript, Python, or Java.

Duration literals pair naturally with datetime functions. `datetime_now() + 7d` gives you a \
timestamp one week in the future. `datetime_now() - 24h` gives you yesterday. This makes \
date arithmetic readable and type-safe.",

        "spawn" => "\
The `spawn` keyword launches a concurrent task that executes independently from the spawning \
code. `spawn { expensive_computation() }` starts the computation and immediately continues \
with the next line. Tasks run concurrently, and their results can be communicated back through \
channels.

Spawn is the primary concurrency primitive in Forge. Rather than managing threads directly, you \
spawn lightweight tasks and communicate between them using channels. This follows the CSP \
(Communicating Sequential Processes) model, where shared state is replaced by message passing.

Spawned tasks share no mutable state with the spawning code. Any data needed by the task is \
captured at spawn time. This eliminates data races by construction, since there is no shared \
mutable memory to race on.

The model is similar to Go's goroutines and Erlang's processes. Tasks are lightweight enough to \
spawn thousands without performance concerns. Combined with channels and select, spawn provides \
a complete concurrent programming toolkit.",

        "channels" => "\
Channels are typed conduits for communication between concurrent tasks. Create a channel with \
`channel.new()`, send values with `ch <- value`, and receive with `<- ch`. Channels are the \
safe, structured way to pass data between spawned tasks without shared mutable state.

Channels are generic: `channel.new<int>()` creates a channel that carries integers. The type \
system ensures you never accidentally send a string through an int channel. Both the send and \
receive operations are type-checked at compile time.

Channels can be iterated with `for msg in ch { ... }`, which receives messages in a loop until \
the channel is closed with `channel.close(ch)`. This pattern is the idiomatic way to process a \
stream of values from a producer task. Timed channels created with `channel.tick(ms)` send a \
value at regular intervals, useful for periodic tasks.

Forge channels follow the same model as Go channels. They are unbuffered by default, meaning a \
send blocks until a receiver is ready. This synchronization property makes channel-based programs \
easier to reason about than lock-based alternatives.",

        "select_syntax" => "\
The `select` expression multiplexes receives from multiple channels, executing the arm for \
whichever channel has data ready first. This is essential for concurrent programs that need to \
respond to events from multiple sources without dedicating a task to each.

Syntax: `select { msg <- ch1 -> handle(msg), data <- ch2 -> process(data) }`. Each arm binds \
the received value and executes its body. If multiple channels are ready simultaneously, one is \
chosen at random to prevent starvation. Select blocks until at least one channel is ready.

Select arms support guards with `if condition`, enabling conditional receives. A guard is checked \
before attempting the receive, so `data <- ch if enabled -> handle(data)` only receives from `ch` \
when `enabled` is true. This provides fine-grained control over which channels are active.

The select statement is modeled after Go's select and mirrors its semantics. Combined with spawn \
and channels, it completes Forge's CSP concurrency model, enabling patterns like fan-in, fan-out, \
timeouts, and graceful shutdown.",

        "shell_shorthand" => "\
Shell shorthands let you execute system commands directly from Forge code. The dollar-string \
syntax `$\"echo hello ${name}\"` runs the command and returns its stdout as a string. The \
backtick form `$\\`echo ${name}\\`` works identically. Both support template interpolation for \
dynamic command construction.

This feature bridges the gap between system scripting and application programming. Tasks that \
would normally require shelling out through a process API can be expressed as a single \
expression. The interpolated values are included in the command string, so `$\"ls ${dir}\"` \
lists the contents of whatever directory `dir` refers to.

Shell shorthands return the command's standard output as a trimmed string. If the command fails \
(non-zero exit code), an error is returned. This integrates with Forge's error propagation, so \
`$\"git status\"?` propagates the error if git is not available.

This is inspired by shell scripting languages and Perl's backtick operator. Unlike raw shell \
execution in most languages, Forge's version participates in the type system (the result is \
always a string) and supports template interpolation with compile-time type checking of the \
embedded expressions.",

        "spec_test" => "\
Forge includes a built-in BDD-style testing framework with `spec`, `given`, `then`, and `expect` \
blocks. Tests are written as structured specifications that read like documentation: \
`spec \"math\" { given \"addition\" { then \"1 + 1 = 2\" { expect(1 + 1 == 2) } } }`.

The `spec` block names the feature being tested. Inside it, `given` blocks describe preconditions \
or scenarios. `then` blocks describe expected behaviors. `expect(condition)` asserts that a \
condition is true. This three-level structure organizes tests into a readable hierarchy.

Test output shows the full path of each assertion: `math > addition > 1 + 1 = 2: PASS`. Failed \
tests show the expected and actual values with source location. The structured output makes it \
easy to identify exactly which scenario failed and why.

This approach is inspired by RSpec (Ruby), Jest's describe/it (JavaScript), and Kotest (Kotlin). \
The benefit over flat test functions is that related tests are grouped by topic, and the test \
names form readable sentences that serve as living documentation.",

        "components" => "\
Components are Forge's template-driven extension system. A component defines a reusable, \
domain-specific abstraction backed by a provider. For example, a `model` component creates a \
data model with CRUD operations, a `server` component sets up an HTTP server, and a `queue` \
component provides message queue functionality.

Components are defined entirely through provider template files (`provider.fg`). The compiler \
has zero knowledge of any specific component; it simply expands templates by substituting \
placeholders. This means new component types can be added without modifying the compiler.

Using a component is as simple as writing a block: `model User { name: string, email: string }`. \
The compiler finds the matching template from the loaded providers, expands it with the user's \
schema and configuration, and produces plain Forge code that calls extern functions from the \
provider's native library.

This architecture separates concerns cleanly: providers implement behavior in native code, \
templates describe how to expose that behavior to Forge users, and the compiler handles the \
mechanical work of template expansion. Adding a new domain (database, message queue, GPU compute) \
requires only a new provider, never a compiler change.",

        "component_config" => "\
Component config blocks let templates declare typed configuration fields with defaults. In a \
provider's template definition, `config { port: int = 3000, cors: bool = false }` declares \
two config fields. Users override these when creating a component: `server :8080 { ... }` or \
`server { config { port: 8080 } }`.

Config resolution merges user-provided values with the template's defaults. Fields not specified \
by the user get the default value from the template. The compiler validates that provided config \
values match the declared types, catching configuration errors at compile time.

This system ensures that every component has a well-defined, documented configuration surface. \
Users can see what options are available and what their defaults are. Template authors can add \
new config fields with defaults without breaking existing code.

Config blocks replace the ad-hoc configuration approaches found in most frameworks (environment \
variables, magic strings, untyped JSON). Everything is checked at compile time, and the schema \
is defined in one place alongside the component template.",

        "component_events" => "\
Component events declare hookable extension points in templates. A template can declare \
`event before_create(record)` to let users run custom logic before a record is created. Users \
hook into events with `on before_create(data) { validate(data) }` inside the component block.

Events follow a declaration-and-hook pattern. The template declares what events exist and what \
arguments they carry. User code attaches handlers to events it cares about. Events without \
handlers get no-op stubs, so unhandled events have zero runtime cost.

This provides a clean alternative to the middleware stacks and callback chains found in frameworks \
like Express or Django. Each event has a typed signature, so the compiler verifies that hook \
handlers accept the correct argument types.

The event system enables components to be customizable without inheritance or complex plugin \
architectures. A model component might offer `before_create`, `after_create`, `before_delete` \
events, letting users add validation, logging, or side effects without modifying the component \
template.",

        "component_syntax" => "\
The `@syntax` decorator lets component templates define custom syntactic patterns. For example, \
`@syntax(\"{method} {path} -> {handler}\")` on a function in a server template enables users \
to write `GET /users -> list_users` inside the component block. The compiler matches user code \
against registered patterns and desugars matches into function calls.

Syntax patterns consist of literal segments and `{placeholder}` captures. Literals must match \
exactly, and placeholders capture the corresponding user input. The pattern engine handles \
identifier, string, and brace-balanced expression captures, making it flexible enough for \
diverse DSLs.

This mechanism is how Forge supports domain-specific syntax without hardcoding any domain into \
the compiler. The server's route syntax, the model's field declarations, and the queue's message \
patterns are all defined through `@syntax` in their respective provider templates.

Compared to macros in Rust or Lisp, `@syntax` patterns are more constrained but also more \
predictable. They match a fixed pattern shape rather than arbitrary token trees, which keeps \
error messages clear and prevents the readability problems that plague macro-heavy codebases.",

        "annotations" => "\
Annotations attach metadata to declarations using the `@name` or `@name(args)` syntax. They \
appear before functions, types, fields, and other declarations. For example, `@deprecated fn old() { }` \
marks a function as deprecated, and `@syntax(\"pattern\")` configures a component syntax pattern.

Annotations are the primary extensibility mechanism for Forge's compiler and provider system. \
Rather than adding keywords for every new concept, Forge uses annotations to layer behavior \
onto existing syntax. This keeps the core language small while allowing rich, domain-specific features.

The compiler processes annotations during different compilation phases. Some annotations affect \
parsing (`@syntax`), some affect type checking (`@deprecated`), and some affect code generation. \
Provider templates can define custom annotations that control template expansion behavior.

This design is similar to Java annotations, Python decorators, and C# attributes. The key \
difference is that Forge annotations integrate with the template system, so providers can define \
new annotations without compiler changes.",

        "string_templates" => "\
String template literals use `${}` syntax to embed expressions inside strings: \
`\"Hello, ${name}!\"`. The expression inside the braces is evaluated, converted to a string, \
and inserted into the result. Any valid Forge expression can appear inside `${}`, including \
function calls, arithmetic, and method chains.

Template literals are the preferred way to construct dynamic strings in Forge. They are more \
readable than string concatenation and less error-prone than format functions with positional \
arguments. The embedded expressions are type-checked at compile time.

Nested templates are supported: `\"outer ${\"inner ${value}\"}\"`. Template interpolation works \
with all types that have a string representation, including numbers, booleans, and any type with \
a `to_string()` method.

This feature works identically to JavaScript template literals and Kotlin string templates. It \
is the foundation for tagged templates, which process the string parts and interpolated values \
through a custom function.",

        "json_builtins" => "\
Forge provides built-in JSON functions: `json.parse(str)` converts a JSON string into a Forge \
value, and `json.stringify(value)` converts a Forge value into a JSON string. These functions \
handle the full JSON specification including nested objects, arrays, numbers, strings, booleans, \
and null.

`json.parse()` returns a dynamic value that can be accessed with field notation and indexing. \
The parsed structure maps JSON objects to Forge maps, JSON arrays to lists, and JSON primitives \
to their Forge equivalents (int, float, string, bool, null).

`json.stringify()` serializes any Forge value to its JSON representation. Structs become JSON \
objects with field names as keys. Lists become JSON arrays. This round-trips cleanly with \
`json.parse()`, so `json.parse(json.stringify(value))` preserves the structure.

These built-in functions avoid the need for an external JSON library in the vast majority of use \
cases. They are implemented as intrinsics for maximum performance, with the serialization and \
deserialization happening in optimized native code.",

        "error_messages" => "\
Forge's error system produces structured, actionable error messages with unique error codes. \
Every error includes a code (like F0012 for type mismatch), a clear description of what went \
wrong, the source location with highlighted code, and a help message suggesting how to fix it.

Error codes are stable identifiers that can be looked up with `forge explain F0012`. Each code \
has a detailed explanation with examples of common causes and fixes. This makes errors searchable \
and referenceable in documentation and team communication.

The error system covers not just syntax and type errors but also common mistakes from other \
languages. Writing a semicolon, using `=>` instead of `->`, or using `var`/`let` from JavaScript \
all produce targeted error messages that explain the Forge equivalent.

Every error path in the compiler goes through the structured error rendering system. There are no \
raw error strings or panics that produce unhelpful messages. This is enforced by design: the \
`CompileError` type has a fixed set of variants, each with a dedicated rendering function that \
includes help text.",

        "extern_ffi" => "\
The foreign function interface allows Forge code to call C ABI functions from native libraries. \
Extern functions are declared in provider template files with their C signatures, and the \
compiler generates the appropriate calling convention code.

Provider `.a` static libraries implement the native side, and the Forge linker combines them \
with the compiled Forge code. This is how providers like `std-http`, `std-model`, and `std-fs` \
implement their functionality: Forge templates declare the interface, native code implements it.

Type coercion between Forge types and C types is handled automatically. Forge strings are \
converted to C pointers when passed to extern functions, and pointer returns are wrapped back \
into Forge strings. This happens transparently at call sites.

The FFI is designed for provider authors, not end users. Application code uses providers through \
their Forge-level APIs (components, functions, static methods). The FFI layer is the plumbing \
that makes providers possible.",

        "c_abi_trampolines" => "\
ABI trampolines automatically convert between Forge's internal type representations and the C \
calling convention used by extern functions. When a Forge string (a struct with pointer and \
length) needs to be passed to a C function expecting a null-terminated pointer, the trampoline \
handles the conversion.

This automatic coercion means provider authors write straightforward C functions with standard \
types, and Forge handles the impedance mismatch at the boundary. No manual marshaling code is \
needed on either side.

Trampolines are generated at compile time for each extern function call. The compiler inspects \
the declared parameter and return types, inserts conversion code where needed, and ensures that \
memory is handled correctly across the boundary.

This system is invisible to both Forge users and provider authors. It exists purely as compiler \
infrastructure to make the FFI seamless. The generated code is optimized to minimize overhead, \
typically adding only a few instructions per call.",

        "parallel" => "\
Parallel execution primitives in Forge enable concurrent processing of independent tasks. The \
parallel infrastructure works with the spawn and channel systems to distribute work across \
available cores.

Parallel operations are built on top of Forge's lightweight task system. Multiple spawned tasks \
can execute truly in parallel, and channels provide the synchronization points where results \
are collected. This model scales naturally with available hardware.

The parallel system handles the underlying thread management, work distribution, and result \
collection. User code simply spawns tasks and communicates through channels, without needing to \
manage threads, locks, or condition variables directly.",

        "process_uptime" => "\
Process uptime tracking provides the `process_uptime()` function, which returns the number of \
milliseconds since the current Forge process started. This is useful for performance monitoring, \
logging elapsed time, and implementing timeouts.

The uptime is measured from process start, not from when the function is first called. This \
gives consistent, comparable timestamps throughout the program's execution. Combined with \
duration literals, you can write expressive timing checks: `if process_uptime() > 30s { ... }`.

The implementation uses the operating system's monotonic clock, so the value always increases \
and is not affected by system clock adjustments. This makes it reliable for measuring intervals \
even if the system time is changed during execution.",

        "query_helpers" => "\
Query helpers provide a fluent builder API for constructing structured queries. Rather than \
concatenating strings to build queries (which is error-prone and vulnerable to injection), \
the query builder lets you compose queries programmatically with methods like `where`, `order_by`, \
`limit`, and `offset`.

The query builder supports comparison operators and chaining: \
`query.where(\"age\", \">\", 18).order_by(\"name\").limit(10)` constructs a structured query \
that can be safely executed against a data source. All values are parameterized, preventing \
injection attacks.

Query helpers are used internally by component templates (especially model components) to \
generate the queries that back CRUD operations. They can also be used directly in application \
code for custom query patterns that go beyond the standard CRUD operations.

Validation errors from the query builder are structured, providing field-level error details \
rather than a single error string. This makes it easy to map validation failures to specific \
user inputs in UI applications.",

        "validation" => "\
Runtime validation in Forge provides structured checking of values against constraints. \
Validators can verify types, ranges, string patterns, and custom predicates. Validation errors \
are returned as structured data with field names and error descriptions, making them easy to \
present to users.

Validation integrates with the component system. Model components can declare named validators \
that run before create and update operations. The validation results are structured as \
field-level errors, compatible with form validation in frontend applications.

The validation system produces `ValidationError` values with `field` and `message` properties. \
Multiple validation errors can be collected and returned together, rather than failing on the \
first error. This gives users all the information they need to fix their input in one pass.

Unlike assertion-based validation that throws exceptions, Forge's validation returns errors as \
values. This fits with Forge's philosophy of making error paths explicit and visible in the \
type system.",

        _ => ""
    }
}

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
    let long_desc = long_description(meta.id);
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

    // Providers section
    let providers = discover_providers();
    if !providers.is_empty() {
        println!();
        println!("  {} ({})", bold("Providers"), providers.len());
        println!();
        for p in &providers {
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
        "Providers: {}",
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

        if has_syntax { has_syntax_count += 1; }
        if has_short { has_short_count += 1; }
        if has_examples { has_examples_count += 1; }
        if has_description { has_description_count += 1; }
        has_status_count += 1; // status is always set (it's an enum)

        let is_stable = f.status == crate::registry::FeatureStatus::Stable;
        if is_stable {
            stable_count += 1;
            if has_examples { stable_with_examples += 1; }
        }

        let is_fully_doc = has_syntax && has_short && has_examples;
        if is_fully_doc { fully_documented += 1; }

        // Determine line icon
        let (icon, icon_color) = if is_fully_doc {
            ("\u{2713}", true) // check mark, green
        } else if has_syntax || has_short || has_examples {
            ("\u{26a0}", false) // warning, yellow
        } else {
            ("\u{2717}", false) // cross, red
        };

        let syntax_tag = if has_syntax { green("syntax \u{2713}") } else { red("no syntax") };
        let short_tag = if has_short { green("short \u{2713}") } else { red("no short") };
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
            "    {} {}: {}, {}, {}",
            icon_str, f.id, syntax_tag, short_tag, examples_tag
        );
    }

    // ── Coverage checks ─────────────────────────────────────────────
    let total = features.len();
    println!();
    println!("  {}", bold("Coverage Checks"));

    let checks: Vec<(&str, usize, usize, bool)> = vec![
        ("All features have descriptions", has_description_count, total, has_description_count == total),
        ("All features have syntax patterns", has_syntax_count, total, has_syntax_count == total),
        ("All features have short descriptions", has_short_count, total, has_short_count == total),
        ("All features have examples", has_examples_count, total, has_examples_count == total),
        ("All features have status set", has_status_count, total, has_status_count == total),
        ("All stable features have examples", stable_with_examples, stable_count, stable_with_examples == stable_count),
    ];

    for (label, num, denom, pass) in &checks {
        let (icon, colored_icon) = if *pass {
            ("\u{2713}", green("\u{2713}"))
        } else if *num as f64 / (*denom).max(1) as f64 >= 0.5 {
            ("\u{26a0}", yellow("\u{26a0}"))
        } else {
            ("\u{2717}", red("\u{2717}"))
        };
        println!("    [{}] {:<44} {}/{}", colored_icon, label, num, denom);
    }

    // ── Types section ───────────────────────────────────────────────
    let types_with_methods: Vec<&TypeDoc> = BUILTIN_TYPES
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
    // 0. Provider queries: @namespace or @namespace.component
    if query.starts_with('@') {
        let provider_query = &query[1..];
        let providers = discover_providers();

        if let Some(dot_pos) = provider_query.find('.') {
            let ns = &provider_query[..dot_pos];
            let comp_name = &provider_query[dot_pos + 1..];
            if let Some(provider) = find_provider_by_namespace(&providers, ns) {
                show_provider_component(provider, comp_name);
            } else {
                println!(
                    "\n  No provider '@{}'. Try {} to see all providers.\n",
                    ns,
                    cyan("forge lang providers")
                );
            }
        } else {
            if let Some(provider) = find_provider_by_namespace(&providers, provider_query) {
                show_provider(provider);
            } else {
                println!(
                    "\n  No provider '@{}'. Try {} to see all providers.\n",
                    provider_query,
                    cyan("forge lang providers")
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

    if query == "providers" {
        show_all_providers();
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

/// Logical grouping order for features in compact outputs.
const FEATURE_GROUP_ORDER: &[(&str, &[&str])] = &[
    ("Variables", &["variables", "immutability"]),
    ("Functions", &["functions"]),
    ("Closures", &["closures", "it_parameter"]),
    ("Control Flow", &["if_else", "for_loops", "while_loops"]),
    ("Pattern Matching", &["pattern_matching", "is_keyword"]),
    ("Operators", &["operators", "pipe_operator", "ranges", "type_operators"]),
    ("Strings", &["strings", "string_templates", "tagged_templates"]),
    ("Collections", &["collections", "structs", "tuples", "enums", "shorthand_fields"]),
    ("Null Safety", &["null_safety", "error_propagation"]),
    ("Concurrency", &["spawn", "channels", "select_syntax", "parallel"]),
    ("Special", &["defer", "shell_shorthand", "table_literal", "with_expression",
                   "spec_test", "durations", "datetime", "annotations",
                   "imports", "json", "json_builtins", "query_helpers",
                   "process_uptime", "validation", "error_messages"]),
    ("Components", &["components", "component_syntax", "component_events",
                      "component_config", "extern_ffi", "c_abi_trampolines",
                      "generics", "traits"]),
];

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

    let all_features = FeatureRegistry::all();
    let feature_map: std::collections::HashMap<&str, &FeatureMetadata> =
        all_features.iter().map(|f| (f.id, *f)).collect();

    for (group_name, ids) in FEATURE_GROUP_ORDER {
        let mut group_lines: Vec<String> = Vec::new();
        for id in *ids {
            if let Some(meta) = feature_map.get(id) {
                if !meta.syntax.is_empty() {
                    for s in meta.syntax {
                        group_lines.push(s.to_string());
                    }
                } else {
                    group_lines.push(format!("# {}", feature_desc(meta)));
                }
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

    // Providers section
    let providers = discover_providers();
    if !providers.is_empty() {
        println!();
        println!("## Providers");
        for p in &providers {
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

            // Add key extern fn summaries for providers without components
            if p.components.is_empty() && !p.extern_fns.is_empty() {
                let fn_names: Vec<String> = p
                    .extern_fns
                    .iter()
                    .take(5)
                    .map(|f| {
                        // Strip provider prefix for readability
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

    let all_features = FeatureRegistry::all();
    let feature_map: std::collections::HashMap<&str, &FeatureMetadata> =
        all_features.iter().map(|f| (f.id, *f)).collect();

    for (group_name, ids) in FEATURE_GROUP_ORDER {
        let mut has_content = false;
        let mut group_output = String::new();

        for id in *ids {
            if let Some(meta) = feature_map.get(id) {
                has_content = true;
                group_output.push_str(&format!("# {}\n", feature_desc(meta)));
                if !meta.syntax.is_empty() {
                    for s in meta.syntax {
                        group_output.push_str(&format!("{}\n", s));
                    }
                }
                if let Some(example) = read_first_example(id) {
                    group_output.push_str("```\n");
                    group_output.push_str(&example);
                    group_output.push_str("\n```\n");
                }
                group_output.push('\n');
            }
        }

        if has_content {
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

    // Providers section
    let providers = discover_providers();
    if !providers.is_empty() {
        println!();
        println!("## Providers");
        for p in &providers {
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

    let all_features = FeatureRegistry::all();
    let feature_map: std::collections::HashMap<&str, &FeatureMetadata> =
        all_features.iter().map(|f| (f.id, *f)).collect();

    for (group_name, ids) in FEATURE_GROUP_ORDER {
        let mut group_rules: Vec<String> = Vec::new();

        for id in *ids {
            if let Some(meta) = feature_map.get(id) {
                if !meta.syntax.is_empty() {
                    for s in meta.syntax {
                        group_rules.push(s.to_string());
                    }
                } else {
                    let rule = generate_grammar_rule(meta);
                    if !rule.is_empty() {
                        group_rules.push(rule);
                    }
                }
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

/// Generate a basic BNF-style grammar rule from feature metadata.
fn generate_grammar_rule(meta: &FeatureMetadata) -> String {
    match meta.id {
        "variables" => concat!(
            "<let_stmt>    ::= \"let\" <ident> [\":\" <type>] \"=\" <expr>\n",
            "<const_stmt>  ::= \"const\" <ident> \"=\" <expr>"
        ).to_string(),
        "immutability" => {
            "<mut_stmt>    ::= \"mut\" <ident> [\":\" <type>] \"=\" <expr>".to_string()
        }
        "functions" => {
            "<fn_decl>     ::= \"fn\" <ident> \"(\" <params> \")\" [\"->\" <type>] <block>"
                .to_string()
        }
        "closures" => concat!(
            "<closure>     ::= \"(\" <params> \")\" \"->\" <expr>\n",
            "                | \"(\" <params> \")\" \"->\" <block>"
        ).to_string(),
        "it_parameter" => {
            "<it_closure>  ::= <expr>       # implicit `it` parameter".to_string()
        }
        "if_else" => {
            "<if_stmt>     ::= \"if\" <expr> <block> [\"else\" (<if_stmt> | <block>)]".to_string()
        }
        "for_loops" => "<for_stmt>    ::= \"for\" <ident> \"in\" <expr> <block>".to_string(),
        "while_loops" => "<while_stmt>  ::= \"while\" <expr> <block>".to_string(),
        "pattern_matching" => {
            "<match_expr>  ::= \"match\" <expr> \"{\" (<pattern> \"->\" <expr>)* \"}\"".to_string()
        }
        "is_keyword" => "<is_expr>     ::= <expr> \"is\" <pattern>".to_string(),
        "pipe_operator" => "<pipe_expr>   ::= <expr> \"|>\" <expr>".to_string(),
        "ranges" => {
            "<range_expr>  ::= <expr> \"..\" <expr> | <expr> \"..=\" <expr>".to_string()
        }
        "null_safety" => concat!(
            "<nullable>    ::= <type> \"?\"\n",
            "<coalesce>    ::= <expr> \"??\" <expr>\n",
            "<safe_access> ::= <expr> \"?.\" <ident>"
        ).to_string(),
        "error_propagation" => "<propagate>   ::= <expr> \"?\"".to_string(),
        "spawn" => "<spawn_block> ::= \"spawn\" <block>".to_string(),
        "channels" => concat!(
            "<chan_send>   ::= <expr> \"<-\" <expr>\n",
            "<chan_recv>   ::= \"<-\" <expr>"
        ).to_string(),
        "select_syntax" => {
            "<select_stmt> ::= \"select\" \"{\" (<ident> \"<-\" <expr> \"->\" <block>)* \"}\""
                .to_string()
        }
        "defer" => "<defer_stmt>  ::= \"defer\" <expr>".to_string(),
        "shell_shorthand" => {
            "<shell_expr>  ::= \"$\\\"\" <template> \"\\\"\" | \"$`\" <template> \"`\"".to_string()
        }
        "with_expression" => {
            "<with_expr>   ::= <expr> \"with\" \"{\" <field_updates> \"}\"".to_string()
        }
        "string_templates" => {
            "<template>    ::= \"\\\"...${\" <expr> \"}...\\\"\"".to_string()
        }
        "imports" => {
            "<import_stmt> ::= \"use\" \"@\" <namespace> \".\" <name> \"{\" <symbols> \"}\""
                .to_string()
        }
        "structs" => {
            "<struct_decl> ::= \"type\" <ident> \"{\" (<ident> \":\" <type>)* \"}\"".to_string()
        }
        "enums" => {
            "<enum_decl>   ::= \"enum\" <ident> \"{\" (<ident> [\"(\" <types> \")\"])* \"}\""
                .to_string()
        }
        "components" => {
            "<component>   ::= \"component\" <ident> \"(\" <args> \")\" <block>".to_string()
        }
        _ => String::new(),
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

    // Search providers
    let providers = discover_providers();
    for p in &providers {
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
                category: "Providers",
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
    let categories = ["Features", "Syntax", "Types", "Methods", "Providers", "Errors"];
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
