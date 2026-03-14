/// Static website generator for Forge language and project documentation.
///
/// Generates self-contained HTML sites from the same data backing
/// `forge lang` and `forge docs` CLI commands.

use std::path::Path;

use crate::docs;
use crate::errors::ErrorRegistry;
use crate::lang::long_description;
use crate::registry::{FeatureMetadata, FeatureRegistry, FeatureStatus};

// ── Feature categories ─────────────────────────────────────────────

struct FeatureCategory {
    title: &'static str,
    ids: &'static [&'static str],
}

const FEATURE_CATEGORIES: &[FeatureCategory] = &[
    FeatureCategory {
        title: "Core Language",
        ids: &[
            "variables", "functions", "closures", "if_else", "for_loops",
            "while_loops", "operators", "pattern_matching", "ranges", "enums",
            "structs", "tuples", "collections", "strings", "generics", "traits",
            "imports", "immutability", "type_operators",
        ],
    },
    FeatureCategory {
        title: "Forge Features",
        ids: &[
            "pipe_operator", "null_safety", "error_propagation", "defer",
            "is_keyword", "with_expression", "it_parameter", "table_literal",
            "shorthand_fields", "tagged_templates", "durations", "datetime",
        ],
    },
    FeatureCategory {
        title: "Concurrency",
        ids: &["spawn", "channels", "select_syntax", "shell_shorthand"],
    },
    FeatureCategory {
        title: "Testing",
        ids: &["spec_test"],
    },
    FeatureCategory {
        title: "Component System",
        ids: &[
            "components", "component_config", "component_events",
            "component_syntax", "annotations",
        ],
    },
    FeatureCategory {
        title: "Internals",
        ids: &[
            "string_templates", "json_builtins", "error_messages", "extern_ffi",
            "c_abi_trampolines", "parallel", "process_uptime", "query_helpers",
            "validation",
        ],
    },
];


// ── CSS Stylesheet ──────────────────────────────────────────────────

fn generate_css() -> String {
    r#":root {
    --bg: #ffffff;
    --bg2: #f6f8fa;
    --fg: #1f2328;
    --fg2: #636c76;
    --border: #d0d7de;
    --accent: #0969da;
    --accent2: #1a7f37;
    --code-bg: #f6f8fa;
    --code-fg: #1f2328;
    --kw: #cf222e;
    --op: #953800;
    --str: #0a3069;
    --num: #0550ae;
    --comment: #6e7781;
    --builtin: #8250df;
    --badge-stable: #1a7f37;
    --badge-testing: #9a6700;
    --badge-wip: #9a6700;
    --badge-draft: #636c76;
    --nav-bg: #f6f8fa;
    --nav-border: #d0d7de;
    --search-bg: #ffffff;
}
@media (prefers-color-scheme: dark) {
    :root {
        --bg: #0d1117;
        --bg2: #161b22;
        --fg: #e6edf3;
        --fg2: #8b949e;
        --border: #30363d;
        --accent: #58a6ff;
        --accent2: #3fb950;
        --code-bg: #161b22;
        --code-fg: #e6edf3;
        --kw: #ff7b72;
        --op: #ffa657;
        --str: #a5d6ff;
        --num: #79c0ff;
        --comment: #8b949e;
        --builtin: #d2a8ff;
        --badge-stable: #3fb950;
        --badge-testing: #d29922;
        --badge-wip: #d29922;
        --badge-draft: #8b949e;
        --nav-bg: #161b22;
        --nav-border: #30363d;
        --search-bg: #0d1117;
    }
}
* { margin: 0; padding: 0; box-sizing: border-box; }
body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;
    color: var(--fg);
    background: var(--bg);
    line-height: 1.6;
}
a { color: var(--accent); text-decoration: none; }
a:hover { text-decoration: underline; }

/* Layout */
.layout { display: flex; min-height: 100vh; }
nav {
    width: 260px;
    flex-shrink: 0;
    background: var(--nav-bg);
    border-right: 1px solid var(--nav-border);
    padding: 1.5rem 1rem;
    position: sticky;
    top: 0;
    height: 100vh;
    overflow-y: auto;
}
nav .logo { font-weight: 700; font-size: 1.2rem; margin-bottom: 1.5rem; }
nav .logo a { color: var(--fg); }
nav .section-title {
    font-size: 0.75rem;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    color: var(--fg2);
    margin: 1rem 0 0.4rem;
}
nav ul { list-style: none; }
nav li a {
    display: block;
    padding: 0.2rem 0.5rem;
    border-radius: 4px;
    color: var(--fg);
    font-size: 0.9rem;
}
nav li a:hover { background: var(--border); text-decoration: none; }
nav li a.active { background: var(--accent); color: #fff; }

main {
    flex: 1;
    max-width: 900px;
    padding: 2rem 3rem;
}

/* Search */
.search-box {
    width: 100%;
    padding: 0.4rem 0.6rem;
    border: 1px solid var(--border);
    border-radius: 6px;
    background: var(--search-bg);
    color: var(--fg);
    font-size: 0.9rem;
    margin-bottom: 1rem;
}
.search-box:focus { outline: 2px solid var(--accent); border-color: transparent; }

/* Typography */
h1 { font-size: 1.8rem; margin-bottom: 0.5rem; border-bottom: 1px solid var(--border); padding-bottom: 0.5rem; }
h2 { font-size: 1.3rem; margin: 2rem 0 0.5rem; color: var(--fg); }
h3 { font-size: 1.1rem; margin: 1.5rem 0 0.3rem; }
p { margin: 0.5rem 0; }

/* Badges */
.badge {
    display: inline-block;
    font-size: 0.75rem;
    font-weight: 600;
    padding: 0.15em 0.5em;
    border-radius: 10px;
    color: #fff;
    vertical-align: middle;
}
.badge-stable { background: var(--badge-stable); }
.badge-testing { background: var(--badge-testing); }
.badge-wip { background: var(--badge-wip); }
.badge-draft { background: var(--badge-draft); }

/* Code */
pre.forge-code {
    background: var(--code-bg);
    border: 1px solid var(--border);
    border-radius: 6px;
    padding: 1rem;
    overflow-x: auto;
    font-size: 0.875rem;
    line-height: 1.55;
    margin: 0.75rem 0;
    position: relative;
}
pre.forge-code code {
    font-family: "SFMono-Regular", Consolas, "Liberation Mono", Menlo, monospace;
    color: var(--code-fg);
}
code {
    font-family: "SFMono-Regular", Consolas, "Liberation Mono", Menlo, monospace;
    background: var(--code-bg);
    padding: 0.15em 0.35em;
    border-radius: 4px;
    font-size: 0.875em;
}
.kw { color: var(--kw); font-weight: 600; }
.op { color: var(--op); }
.str { color: var(--str); }
.num { color: var(--num); }
.comment { color: var(--comment); font-style: italic; }
.builtin { color: var(--builtin); }

/* Cards / grid */
.feature-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 1rem;
    margin: 1rem 0;
}
.card {
    border: 1px solid var(--border);
    border-radius: 8px;
    padding: 1rem;
    transition: box-shadow 0.15s;
}
.card:hover { box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
.card h3 { margin: 0 0 0.3rem; font-size: 1rem; }
.card p { font-size: 0.85rem; color: var(--fg2); margin: 0; }
.card a { color: var(--fg); }
.card a:hover { text-decoration: none; }

/* Tags */
.tag {
    display: inline-block;
    font-size: 0.75rem;
    padding: 0.1em 0.4em;
    border: 1px solid var(--border);
    border-radius: 4px;
    margin: 0.1rem;
    color: var(--fg2);
}

/* Tables */
table { border-collapse: collapse; width: 100%; margin: 0.75rem 0; }
th, td { text-align: left; padding: 0.5rem 0.75rem; border-bottom: 1px solid var(--border); }
th { font-weight: 600; font-size: 0.85rem; color: var(--fg2); }

/* Method signature */
.method-sig { font-family: "SFMono-Regular", Consolas, monospace; font-weight: 600; }

/* Responsive */
@media (max-width: 768px) {
    .layout { flex-direction: column; }
    nav { width: 100%; height: auto; position: static; border-right: none; border-bottom: 1px solid var(--nav-border); }
    main { padding: 1rem; }
    .feature-grid { grid-template-columns: 1fr; }
}

/* Search results */
.search-result { display: none; }
.search-result.visible { display: block; }
"#.to_string()
}

// ── HTML helpers ────────────────────────────────────────────────────

fn html_escape(s: &str) -> String {
    s.replace('&', "&amp;")
        .replace('<', "&lt;")
        .replace('>', "&gt;")
        .replace('"', "&quot;")
}

fn html_page(title: &str, body: &str, nav: &str, css_path: &str) -> String {
    format!(
        r#"<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{title} — Forge</title>
<link rel="stylesheet" href="{css_path}">
</head>
<body>
<div class="layout">
<nav>{nav}</nav>
<main>{body}</main>
</div>
</body>
</html>"#,
        title = html_escape(title),
        body = body,
        nav = nav,
        css_path = css_path
    )
}

fn status_badge(status: FeatureStatus) -> String {
    let (class, label) = match status {
        FeatureStatus::Stable => ("badge-stable", "stable"),
        FeatureStatus::Testing => ("badge-testing", "testing"),
        FeatureStatus::Wip => ("badge-wip", "wip"),
        FeatureStatus::Draft => ("badge-draft", "draft"),
    };
    format!(r#"<span class="badge {}">{}</span>"#, class, label)
}

// ── Syntax highlighting ─────────────────────────────────────────────

/// Basic Forge syntax highlighter. Wraps known tokens in span tags.
fn highlight_forge(code: &str) -> String {
    let mut out = String::with_capacity(code.len() * 2);
    let chars: Vec<char> = code.chars().collect();
    let len = chars.len();
    let mut i = 0;

    let keywords = [
        "let", "mut", "fn", "if", "else", "for", "while", "match", "return",
        "spawn", "defer", "select", "in", "is", "with", "enum", "struct",
        "trait", "spec", "given", "then", "use", "const", "true", "false",
        "null", "export", "type", "on",
    ];
    let builtins = ["print", "println", "string", "int", "float"];

    while i < len {
        let ch = chars[i];

        // Line comment
        if ch == '/' && i + 1 < len && chars[i + 1] == '/' {
            out.push_str(r#"<span class="comment">"#);
            while i < len && chars[i] != '\n' {
                push_escaped(&mut out, chars[i]);
                i += 1;
            }
            out.push_str("</span>");
            continue;
        }

        // String literal
        if ch == '"' {
            out.push_str(r#"<span class="str">"#);
            push_escaped(&mut out, ch);
            i += 1;
            while i < len && chars[i] != '"' {
                if chars[i] == '\\' && i + 1 < len {
                    push_escaped(&mut out, chars[i]);
                    i += 1;
                    push_escaped(&mut out, chars[i]);
                    i += 1;
                    continue;
                }
                // Template interpolation ${...}
                if chars[i] == '$' && i + 1 < len && chars[i + 1] == '{' {
                    out.push_str("</span>");
                    out.push_str(r#"<span class="op">"#);
                    out.push_str("${");
                    out.push_str("</span>");
                    i += 2;
                    let mut depth = 1;
                    while i < len && depth > 0 {
                        if chars[i] == '{' { depth += 1; }
                        if chars[i] == '}' { depth -= 1; }
                        if depth > 0 {
                            push_escaped(&mut out, chars[i]);
                        }
                        i += 1;
                    }
                    out.push_str(r#"<span class="op">"#);
                    out.push('}');
                    out.push_str("</span>");
                    out.push_str(r#"<span class="str">"#);
                    continue;
                }
                push_escaped(&mut out, chars[i]);
                i += 1;
            }
            if i < len {
                push_escaped(&mut out, chars[i]);
                i += 1;
            }
            out.push_str("</span>");
            continue;
        }

        // Multi-char operators
        if let Some(op) = match_operator(&chars, i) {
            out.push_str(r#"<span class="op">"#);
            out.push_str(&html_escape(op));
            out.push_str("</span>");
            i += op.len();
            continue;
        }

        // Numbers
        if ch.is_ascii_digit() || (ch == '-' && i + 1 < len && chars[i + 1].is_ascii_digit() && (i == 0 || !chars[i - 1].is_alphanumeric())) {
            out.push_str(r#"<span class="num">"#);
            if ch == '-' {
                out.push('-');
                i += 1;
            }
            while i < len && (chars[i].is_ascii_digit() || chars[i] == '.') {
                out.push(chars[i]);
                i += 1;
            }
            out.push_str("</span>");
            continue;
        }

        // Identifiers / keywords
        if ch.is_ascii_alphabetic() || ch == '_' {
            let start = i;
            while i < len && (chars[i].is_ascii_alphanumeric() || chars[i] == '_') {
                i += 1;
            }
            let word: String = chars[start..i].iter().collect();
            if keywords.contains(&word.as_str()) {
                out.push_str(r#"<span class="kw">"#);
                out.push_str(&word);
                out.push_str("</span>");
            } else if builtins.contains(&word.as_str()) {
                out.push_str(r#"<span class="builtin">"#);
                out.push_str(&word);
                out.push_str("</span>");
            } else {
                out.push_str(&word);
            }
            continue;
        }

        push_escaped(&mut out, ch);
        i += 1;
    }

    out
}

fn push_escaped(out: &mut String, ch: char) {
    match ch {
        '&' => out.push_str("&amp;"),
        '<' => out.push_str("&lt;"),
        '>' => out.push_str("&gt;"),
        '"' => out.push_str("&quot;"),
        _ => out.push(ch),
    }
}

fn match_operator(chars: &[char], i: usize) -> Option<&'static str> {
    let remaining = chars.len() - i;
    if remaining >= 3 {
        let three: String = chars[i..i + 3].iter().collect();
        if three == "..=" { return Some("..="); }
    }
    if remaining >= 2 {
        let two: String = chars[i..i + 2].iter().collect();
        match two.as_str() {
            "->" | "|>" | "<-" | ".." | "=>" | "?." | "??" => return Some(match two.as_str() {
                "->" => "->",
                "|>" => "|>",
                "<-" => "<-",
                ".." => "..",
                "=>" => "=>",
                "?." => "?.",
                "??" => "??",
                _ => unreachable!(),
            }),
            _ => {}
        }
    }
    if remaining >= 1 && chars[i] == '?' {
        // Only highlight standalone ? (not part of ?. or ??)
        if i + 1 >= chars.len() || (chars[i + 1] != '.' && chars[i + 1] != '?') {
            return Some("?");
        }
    }
    None
}

fn code_block(code: &str) -> String {
    format!(
        r#"<pre class="forge-code"><code>{}</code></pre>"#,
        highlight_forge(code)
    )
}

// ── Navigation builder ──────────────────────────────────────────────

/// Build sidebar navigation. `base` is the relative path prefix to root
/// (e.g., "" for root pages, "../" for pages in subdirectories).
fn lang_nav(active: &str, base: &str) -> String {
    let features = FeatureRegistry::all_sorted();
    let mut nav = String::new();

    nav.push_str(&format!(r#"<div class="logo"><a href="{}index.html">Forge</a></div>"#, base));
    nav.push_str(r#"<input type="text" class="search-box" placeholder="Search..." id="nav-search" onkeyup="filterNav(this.value)">"#);

    // Types
    nav.push_str(r#"<div class="section-title">Types</div><ul>"#);
    let types = builtin_types();
    for t in &types {
        let cls = if active == t.name { r#" class="active""# } else { "" };
        nav.push_str(&format!(
            r#"<li class="nav-item" data-name="{}"><a href="{}types/{}.html"{}>{}</a></li>"#,
            t.name, base, t.name, cls, t.name
        ));
    }
    nav.push_str("</ul>");

    // Features grouped by category
    let feature_map: std::collections::HashMap<&str, &&FeatureMetadata> =
        features.iter().map(|f| (f.id, f)).collect();
    let mut shown: std::collections::HashSet<&str> = std::collections::HashSet::new();

    for cat in FEATURE_CATEGORIES {
        nav.push_str(&format!(r#"<div class="section-title">{}</div><ul>"#, cat.title));
        for id in cat.ids {
            if let Some(f) = feature_map.get(id) {
                shown.insert(id);
                let cls = if active == f.id { r#" class="active""# } else { "" };
                nav.push_str(&format!(
                    r#"<li class="nav-item" data-name="{}"><a href="{}features/{}.html"{}>{}</a></li>"#,
                    f.id, base, f.id, cls, f.name
                ));
            }
        }
        nav.push_str("</ul>");
    }

    // Any features not in a category go into "Other"
    let other: Vec<_> = features.iter().filter(|f| !shown.contains(f.id)).collect();
    if !other.is_empty() {
        nav.push_str(r#"<div class="section-title">Other</div><ul>"#);
        for f in &other {
            let cls = if active == f.id { r#" class="active""# } else { "" };
            nav.push_str(&format!(
                r#"<li class="nav-item" data-name="{}"><a href="{}features/{}.html"{}>{}</a></li>"#,
                f.id, base, f.id, cls, f.name
            ));
        }
        nav.push_str("</ul>");
    }

    // Errors
    nav.push_str(r#"<div class="section-title">Reference</div><ul>"#);
    let err_cls = if active == "errors" { r#" class="active""# } else { "" };
    let spec_cls = if active == "spec" { r#" class="active""# } else { "" };
    let cheat_cls = if active == "cheatsheet" { r#" class="active""# } else { "" };
    nav.push_str(&format!(
        r#"<li class="nav-item" data-name="errors"><a href="{}errors/index.html"{}>Error Codes</a></li>"#,
        base, err_cls
    ));
    nav.push_str(&format!(
        r#"<li class="nav-item" data-name="spec"><a href="{}spec.html"{}>Full Spec</a></li>"#,
        base, spec_cls
    ));
    nav.push_str(&format!(
        r#"<li class="nav-item" data-name="cheatsheet"><a href="{}cheatsheet.html"{}>Cheatsheet</a></li>"#,
        base, cheat_cls
    ));
    nav.push_str("</ul>");

    // Filter script
    nav.push_str(r#"<script>
function filterNav(q) {
    q = q.toLowerCase();
    document.querySelectorAll('.nav-item').forEach(function(li) {
        var name = li.getAttribute('data-name');
        li.style.display = (!q || name.indexOf(q) !== -1) ? '' : 'none';
    });
}
</script>"#);

    nav
}

fn docs_nav(active: &str, base: &str, project_docs: &docs::ProjectDocs) -> String {
    let mut nav = String::new();
    nav.push_str(&format!(r#"<div class="logo"><a href="{}index.html">Project Docs</a></div>"#, base));

    if !project_docs.functions.is_empty() {
        nav.push_str(r#"<div class="section-title">Functions</div><ul>"#);
        for f in &project_docs.functions {
            let cls = if active == f.name { r#" class="active""# } else { "" };
            nav.push_str(&format!(
                r#"<li><a href="{}symbols/{}.html"{}>{}</a></li>"#,
                base, html_escape(&f.name), cls, html_escape(&f.name)
            ));
        }
        nav.push_str("</ul>");
    }

    if !project_docs.types.is_empty() {
        nav.push_str(r#"<div class="section-title">Types</div><ul>"#);
        for t in &project_docs.types {
            let cls = if active == t.name { r#" class="active""# } else { "" };
            nav.push_str(&format!(
                r#"<li><a href="{}symbols/{}.html"{}>{}</a></li>"#,
                base, html_escape(&t.name), cls, html_escape(&t.name)
            ));
        }
        nav.push_str("</ul>");
    }

    if !project_docs.enums.is_empty() {
        nav.push_str(r#"<div class="section-title">Enums</div><ul>"#);
        for e in &project_docs.enums {
            let cls = if active == e.name { r#" class="active""# } else { "" };
            nav.push_str(&format!(
                r#"<li><a href="{}symbols/{}.html"{}>{}</a></li>"#,
                base, html_escape(&e.name), cls, html_escape(&e.name)
            ));
        }
        nav.push_str("</ul>");
    }

    nav.push_str(r#"<div class="section-title">Language</div><ul>"#);
    nav.push_str(&format!(r#"<li><a href="{}lang/index.html">Language Reference</a></li>"#, base));
    nav.push_str("</ul>");

    nav
}

// ── Built-in types data (mirrors lang.rs) ───────────────────────────

struct SiteTypeDoc {
    name: &'static str,
    description: &'static str,
    methods: Vec<SiteMethodDoc>,
}

struct SiteMethodDoc {
    name: &'static str,
    signature: &'static str,
    description: &'static str,
    example: &'static str,
}

fn builtin_types() -> Vec<SiteTypeDoc> {
    // Reuse the same data from lang.rs by reconstructing it here.
    // The data is static so this is cheap.
    vec![
        SiteTypeDoc {
            name: "int",
            description: "64-bit signed integer type. Supports arithmetic (+, -, *, /, %), comparison, and bitwise operations.",
            methods: vec![],
        },
        SiteTypeDoc {
            name: "float",
            description: "64-bit floating-point type (IEEE 754 double). Supports arithmetic and comparison operations.",
            methods: vec![],
        },
        SiteTypeDoc {
            name: "string",
            description: "UTF-8 string type. Immutable value type with a rich set of built-in methods.",
            methods: vec![
                SiteMethodDoc { name: "length", signature: "string.length() -> int", description: "Get the number of characters in the string.", example: "\"hello\".length()  // => 5" },
                SiteMethodDoc { name: "split", signature: "string.split(sep: string) -> list<string>", description: "Split the string by a separator, returning a list of parts.", example: "\"a,b,c\".split(\",\")  // => [\"a\", \"b\", \"c\"]" },
                SiteMethodDoc { name: "trim", signature: "string.trim() -> string", description: "Remove leading and trailing whitespace.", example: "\"  hello  \".trim()  // => \"hello\"" },
                SiteMethodDoc { name: "contains", signature: "string.contains(sub: string) -> bool", description: "Check if the string contains a substring.", example: "\"hello world\".contains(\"world\")  // => true" },
                SiteMethodDoc { name: "upper", signature: "string.upper() -> string", description: "Convert all characters to uppercase.", example: "\"hello\".upper()  // => \"HELLO\"" },
                SiteMethodDoc { name: "lower", signature: "string.lower() -> string", description: "Convert all characters to lowercase.", example: "\"HELLO\".lower()  // => \"hello\"" },
                SiteMethodDoc { name: "starts_with", signature: "string.starts_with(prefix: string) -> bool", description: "Check if the string starts with a given prefix.", example: "\"hello\".starts_with(\"hel\")  // => true" },
                SiteMethodDoc { name: "ends_with", signature: "string.ends_with(suffix: string) -> bool", description: "Check if the string ends with a given suffix.", example: "\"hello\".ends_with(\"llo\")  // => true" },
                SiteMethodDoc { name: "replace", signature: "string.replace(old: string, new: string) -> string", description: "Replace all occurrences of a substring with another.", example: "\"hello\".replace(\"l\", \"r\")  // => \"herro\"" },
                SiteMethodDoc { name: "parse_int", signature: "string.parse_int() -> int", description: "Parse the string as an integer.", example: "\"42\".parse_int()  // => 42" },
                SiteMethodDoc { name: "repeat", signature: "string.repeat(n: int) -> string", description: "Repeat the string n times.", example: "\"ab\".repeat(3)  // => \"ababab\"" },
            ],
        },
        SiteTypeDoc {
            name: "bool",
            description: "Boolean type with values `true` and `false`. Supports logical operators (&&, ||, !).",
            methods: vec![],
        },
        SiteTypeDoc {
            name: "list",
            description: "Generic ordered collection. Declared as `list<T>` where T is the element type.",
            methods: vec![
                SiteMethodDoc { name: "length", signature: "list<T>.length -> int", description: "Get the number of elements in the list. Accessed as a property, not a method call.", example: "[1, 2, 3].length  // => 3" },
                SiteMethodDoc { name: "push", signature: "list<T>.push(val: T) -> list<T>", description: "Append an element to the list, returning the new list.", example: "[1, 2].push(3)  // => [1, 2, 3]" },
                SiteMethodDoc { name: "map", signature: "list<T>.map(fn: (T) -> U) -> list<U>", description: "Transform each element using a function, returning a new list.", example: "[1, 2, 3].map((x) -> x * 2)  // => [2, 4, 6]" },
                SiteMethodDoc { name: "filter", signature: "list<T>.filter(fn: (T) -> bool) -> list<T>", description: "Keep only elements for which the function returns true.", example: "[1, 2, 3, 4].filter((x) -> x > 2)  // => [3, 4]" },
                SiteMethodDoc { name: "sorted", signature: "list<T>.sorted() -> list<T>", description: "Return a new list with elements sorted in ascending order.", example: "[3, 1, 2].sorted()  // => [1, 2, 3]" },
                SiteMethodDoc { name: "each", signature: "list<T>.each(fn: (T) -> void)", description: "Iterate over elements for side effects. Returns void.", example: "[1, 2, 3].each((x) -> println(string(x)))" },
                SiteMethodDoc { name: "find", signature: "list<T>.find(fn: (T) -> bool) -> T?", description: "Return the first element matching the predicate, or null.", example: "[1, 2, 3].find((x) -> x > 1)  // => 2" },
                SiteMethodDoc { name: "any", signature: "list<T>.any(fn: (T) -> bool) -> bool", description: "Return true if any element matches the predicate.", example: "[1, 2, 3].any((x) -> x > 2)  // => true" },
                SiteMethodDoc { name: "all", signature: "list<T>.all(fn: (T) -> bool) -> bool", description: "Return true if all elements match the predicate.", example: "[1, 2, 3].all((x) -> x > 0)  // => true" },
                SiteMethodDoc { name: "sum", signature: "list<int>.sum() -> int", description: "Sum all elements in a list of integers.", example: "[1, 2, 3].sum()  // => 6" },
                SiteMethodDoc { name: "join", signature: "list<string>.join(sep: string) -> string", description: "Join all elements into a single string with a separator.", example: "[\"a\", \"b\", \"c\"].join(\", \")  // => \"a, b, c\"" },
                SiteMethodDoc { name: "reduce", signature: "list<T>.reduce(fn: (acc: T, val: T) -> T) -> T", description: "Reduce the list to a single value by applying a function cumulatively.", example: "[1, 2, 3].reduce((acc, x) -> acc + x)  // => 6" },
                SiteMethodDoc { name: "enumerate", signature: "list<T>.enumerate() -> list<{index: int, value: T}>", description: "Return a list of index-value pairs.", example: "[\"a\", \"b\"].enumerate()  // => [{index: 0, value: \"a\"}, ...]" },
                SiteMethodDoc { name: "clone", signature: "list<T>.clone() -> list<T>", description: "Create a shallow copy of the list.", example: "let copy = items.clone()" },
            ],
        },
        SiteTypeDoc {
            name: "map",
            description: "Generic key-value collection. Declared as `map<K, V>`. Keys are strings by default.",
            methods: vec![
                SiteMethodDoc { name: "has", signature: "map<K,V>.has(key: K) -> bool", description: "Check if the map contains a given key.", example: "let m = {a: 1}\nm.has(\"a\")  // => true" },
                SiteMethodDoc { name: "get", signature: "map<K,V>.get(key: K) -> V?", description: "Get the value for a key, or null if not found.", example: "let m = {a: 1}\nm.get(\"a\")  // => 1" },
                SiteMethodDoc { name: "keys", signature: "map<K,V>.keys() -> list<K>", description: "Return a list of all keys in the map.", example: "let m = {a: 1, b: 2}\nm.keys()  // => [\"a\", \"b\"]" },
                SiteMethodDoc { name: "length", signature: "map<K,V>.length -> int", description: "Get the number of entries in the map. Accessed as a property.", example: "{a: 1, b: 2}.length  // => 2" },
            ],
        },
        SiteTypeDoc {
            name: "json",
            description: "JSON namespace for parsing and serialization. Not a value type -- used as `json.parse()` and `json.stringify()`.",
            methods: vec![
                SiteMethodDoc { name: "parse", signature: "json.parse(str: string) -> T", description: "Parse a JSON string into a typed value. The target type is inferred from context.", example: "let user: User = json.parse(data)" },
                SiteMethodDoc { name: "stringify", signature: "json.stringify(val: T) -> string", description: "Serialize a value to a JSON string.", example: "let s = json.stringify({name: \"Alice\"})" },
            ],
        },
    ]
}

// ── Read example files ──────────────────────────────────────────────

fn read_example_files(feature_id: &str) -> Vec<(String, String)> {
    let features_dir = match crate::lang::find_features_dir() {
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
        .filter_map(|entry| {
            let path = entry.path();
            let name = path.file_name()?.to_string_lossy().to_string();
            let source = std::fs::read_to_string(&path).ok()?;
            // Strip /// expect: and /// expect-error: lines
            let code: Vec<&str> = source
                .lines()
                .filter(|l| {
                    let t = l.trim();
                    !t.starts_with("/// expect:") && !t.starts_with("/// expect-error:")
                })
                .collect();
            Some((name, code.join("\n")))
        })
        .collect()
}

// ── Search index ────────────────────────────────────────────────────

fn generate_search_index() -> String {
    let mut entries = Vec::new();
    let features = FeatureRegistry::all_sorted();
    let types = builtin_types();

    for f in &features {
        let desc = if !f.short.is_empty() { f.short } else { f.description };
        entries.push(format!(
            r#"{{"type":"feature","id":"{}","name":"{}","text":"{}","url":"features/{}.html"}}"#,
            json_escape(f.id),
            json_escape(f.name),
            json_escape(desc),
            f.id
        ));
    }

    for t in &types {
        entries.push(format!(
            r#"{{"type":"type","id":"{}","name":"{}","text":"{}","url":"types/{}.html"}}"#,
            t.name, t.name,
            json_escape(t.description),
            t.name
        ));
        for m in &t.methods {
            entries.push(format!(
                r#"{{"type":"method","id":"{}.{}","name":"{}.{}","text":"{}","url":"types/{}.html#{}"}}"#,
                t.name, m.name,
                t.name, m.name,
                json_escape(m.description),
                t.name, m.name
            ));
        }
    }

    let registry = ErrorRegistry::builtin();
    let mut codes: Vec<_> = registry.all_codes().into_iter().collect();
    codes.sort();
    for code in &codes {
        if let Some(entry) = registry.lookup(code) {
            entries.push(format!(
                r#"{{"type":"error","id":"{}","name":"{} — {}","text":"{}","url":"errors/index.html#{}"}}"#,
                code, code,
                json_escape(&entry.title),
                json_escape(&entry.message),
                code
            ));
        }
    }

    format!("[{}]", entries.join(",\n"))
}

fn json_escape(s: &str) -> String {
    s.replace('\\', "\\\\")
        .replace('"', "\\\"")
        .replace('\n', "\\n")
        .replace('\r', "")
        .replace('\t', "\\t")
}

// ── Page generators ─────────────────────────────────────────────────

fn generate_index_page(features: &[&FeatureMetadata], types: &[SiteTypeDoc]) -> String {
    let nav = lang_nav("", "");

    let mut body = String::new();
    body.push_str("<h1>Forge Language Reference</h1>");
    body.push_str("<p>Explore the Forge programming language: types, features, and error codes.</p>");

    // Search
    body.push_str(r#"
<input type="text" class="search-box" id="global-search" placeholder="Search features, types, methods..." onkeyup="globalSearch(this.value)">
<div id="search-results" style="display:none;margin-bottom:1rem;"></div>
"#);

    // Types
    body.push_str("<h2>Types</h2>");
    body.push_str(r#"<div class="feature-grid">"#);
    for t in types {
        let method_note = if t.methods.is_empty() {
            String::new()
        } else {
            format!(" &middot; {} methods", t.methods.len())
        };
        body.push_str(&format!(
            r#"<div class="card"><a href="types/{}.html"><h3>{}</h3></a><p>{}{}</p></div>"#,
            t.name, t.name,
            truncate_html(t.description, 80),
            method_note
        ));
    }
    body.push_str("</div>");

    // Features grouped by category
    let feature_map: std::collections::HashMap<&str, &&FeatureMetadata> =
        features.iter().map(|f| (f.id, f)).collect();
    let mut shown: std::collections::HashSet<&str> = std::collections::HashSet::new();

    for cat in FEATURE_CATEGORIES {
        let cat_features: Vec<_> = cat.ids.iter()
            .filter_map(|id| feature_map.get(id).copied())
            .collect();
        if cat_features.is_empty() {
            continue;
        }
        body.push_str(&format!("<h2>{}</h2>", html_escape(cat.title)));
        body.push_str(r#"<div class="feature-grid">"#);
        for f in &cat_features {
            shown.insert(f.id);
            let desc = if !f.short.is_empty() { f.short } else { f.description };
            body.push_str(&format!(
                r#"<div class="card"><a href="features/{}.html"><h3>{} {}</h3></a><p>{}</p></div>"#,
                f.id, html_escape(f.name), status_badge(f.status),
                truncate_html(desc, 100)
            ));
        }
        body.push_str("</div>");
    }

    // Any features not in a category
    let other: Vec<_> = features.iter().filter(|f| !shown.contains(f.id)).collect();
    if !other.is_empty() {
        body.push_str("<h2>Other</h2>");
        body.push_str(r#"<div class="feature-grid">"#);
        for f in &other {
            let desc = if !f.short.is_empty() { f.short } else { f.description };
            body.push_str(&format!(
                r#"<div class="card"><a href="features/{}.html"><h3>{} {}</h3></a><p>{}</p></div>"#,
                f.id, html_escape(f.name), status_badge(f.status),
                truncate_html(desc, 100)
            ));
        }
        body.push_str("</div>");
    }

    // Quick links
    body.push_str("<h2>Reference</h2>");
    body.push_str(r#"<ul>
<li><a href="errors/index.html">Error Codes</a></li>
<li><a href="spec.html">Full Language Spec</a></li>
<li><a href="cheatsheet.html">Cheatsheet</a></li>
</ul>"#);

    // Search script
    body.push_str(r#"
<script>
var searchIndex = null;
function loadSearchIndex() {
    if (searchIndex) return;
    var xhr = new XMLHttpRequest();
    xhr.open('GET', 'search-index.json', true);
    xhr.onload = function() { if (xhr.status === 200) searchIndex = JSON.parse(xhr.responseText); };
    xhr.send();
}
function globalSearch(q) {
    loadSearchIndex();
    var el = document.getElementById('search-results');
    if (!q || !searchIndex) { el.style.display = 'none'; return; }
    q = q.toLowerCase();
    var matches = searchIndex.filter(function(e) {
        return e.name.toLowerCase().indexOf(q) !== -1 || e.text.toLowerCase().indexOf(q) !== -1;
    }).slice(0, 15);
    if (matches.length === 0) { el.innerHTML = '<p>No results.</p>'; }
    else {
        el.innerHTML = '<ul>' + matches.map(function(e) {
            return '<li><a href="' + e.url + '">' + e.name + '</a> <span class="tag">' + e.type + '</span></li>';
        }).join('') + '</ul>';
    }
    el.style.display = 'block';
}
</script>"#);

    html_page("Language Reference", &body, &nav, "style.css")
}

fn generate_feature_page(meta: &FeatureMetadata) -> String {
    let nav = lang_nav(meta.id, "../");
    let mut body = String::new();

    // Title + badge
    body.push_str(&format!(
        "<h1>{} {}</h1>",
        html_escape(meta.name),
        status_badge(meta.status)
    ));

    // Description
    let desc = if !meta.short.is_empty() { meta.short } else { meta.description };
    body.push_str(&format!("<p>{}</p>", html_escape(desc)));
    if !meta.short.is_empty() && meta.description != meta.short {
        body.push_str(&format!("<p>{}</p>", html_escape(meta.description)));
    }

    // Long description
    let long_desc = long_description(meta.id);
    if !long_desc.is_empty() {
        body.push_str(r#"<div class="long-description">"#);
        for paragraph in long_desc.split("\n\n") {
            let cleaned = paragraph.replace('\n', " ");
            body.push_str(&format!("<p>{}</p>", html_escape(&cleaned)));
        }
        body.push_str("</div>");
    }

    // Syntax
    if !meta.syntax.is_empty() {
        body.push_str("<h2>Syntax</h2>");
        let syntax_code = meta.syntax.join("\n");
        body.push_str(&code_block(&syntax_code));
    }

    // Examples
    let examples = read_example_files(meta.id);
    if !examples.is_empty() {
        body.push_str("<h2>Examples</h2>");
        for (name, source) in &examples {
            body.push_str(&format!("<h3>{}</h3>", html_escape(name)));
            body.push_str(&code_block(source));
        }
    }

    // Tokens + AST
    if !meta.tokens.is_empty() {
        body.push_str("<h2>Tokens</h2><p>");
        for t in meta.tokens {
            body.push_str(&format!(r#"<span class="tag">{}</span> "#, html_escape(t)));
        }
        body.push_str("</p>");
    }

    if !meta.ast_nodes.is_empty() {
        body.push_str("<h2>AST Nodes</h2><p>");
        for n in meta.ast_nodes {
            body.push_str(&format!(r#"<span class="tag">{}</span> "#, html_escape(n)));
        }
        body.push_str("</p>");
    }

    // Symbols
    if !meta.symbols.is_empty() {
        body.push_str("<h2>Symbols</h2><p>");
        for s in meta.symbols {
            body.push_str(&format!(r#"<span class="tag">{}</span> "#, html_escape(s)));
        }
        body.push_str("</p>");
    }

    // Dependencies
    if !meta.depends.is_empty() {
        body.push_str("<h2>Dependencies</h2><ul>");
        for dep in meta.depends {
            body.push_str(&format!(
                r#"<li><a href="{}.html">{}</a></li>"#,
                dep, dep
            ));
        }
        body.push_str("</ul>");
    }

    // Enables
    if !meta.enables.is_empty() {
        body.push_str("<h2>Enables</h2><ul>");
        for en in meta.enables {
            body.push_str(&format!(
                r#"<li><a href="{}.html">{}</a></li>"#,
                en, en
            ));
        }
        body.push_str("</ul>");
    }

    html_page(meta.name, &body, &nav, "../style.css")
}

fn generate_type_page(t: &SiteTypeDoc) -> String {
    let nav = lang_nav(t.name, "../");
    let mut body = String::new();

    body.push_str(&format!(
        r#"<h1>{} <span class="tag">built-in type</span></h1>"#,
        html_escape(t.name)
    ));
    body.push_str(&format!("<p>{}</p>", html_escape(t.description)));

    if t.methods.is_empty() {
        body.push_str("<p>No methods. Used with operators and built-in functions.</p>");
    } else {
        body.push_str("<h2>Methods</h2>");
        body.push_str("<table><thead><tr><th>Method</th><th>Description</th></tr></thead><tbody>");
        for m in &t.methods {
            body.push_str(&format!(
                r#"<tr id="{}"><td><span class="method-sig">{}</span></td><td>{}</td></tr>"#,
                m.name,
                html_escape(m.signature),
                html_escape(m.description)
            ));
        }
        body.push_str("</tbody></table>");

        // Detailed method sections
        for m in &t.methods {
            body.push_str(&format!(
                r#"<h3 id="{}-detail">{}</h3>"#,
                m.name,
                html_escape(m.signature)
            ));
            body.push_str(&format!("<p>{}</p>", html_escape(m.description)));
            body.push_str(&code_block(m.example));
        }
    }

    html_page(t.name, &body, &nav, "../style.css")
}

fn generate_errors_page() -> String {
    let nav = lang_nav("errors", "../");
    let registry = ErrorRegistry::builtin();
    let mut codes: Vec<_> = registry.all_codes().into_iter().map(String::from).collect();
    codes.sort();

    let mut body = String::new();
    body.push_str("<h1>Error Codes</h1>");
    body.push_str("<p>All Forge compiler error and warning codes.</p>");

    body.push_str("<table><thead><tr><th>Code</th><th>Title</th><th>Level</th></tr></thead><tbody>");
    for code in &codes {
        if let Some(entry) = registry.lookup(code) {
            let level_str = format!("{:?}", entry.level);
            body.push_str(&format!(
                "<tr id=\"{}\"><td><a href=\"#{}\">{}</a></td><td>{}</td><td>{}</td></tr>",
                code, code, code,
                html_escape(&entry.title),
                level_str
            ));
        }
    }
    body.push_str("</tbody></table>");

    // Detailed sections
    for code in &codes {
        if let Some(entry) = registry.lookup(code) {
            body.push_str(&format!("<h2 id=\"{}-detail\">{} &mdash; {}</h2>", code, code, html_escape(&entry.title)));
            if !entry.message.is_empty() {
                body.push_str(&format!("<p>{}</p>", html_escape(&entry.message)));
            }
            if !entry.help.is_empty() {
                body.push_str(&format!("<p><strong>Help:</strong> {}</p>", html_escape(&entry.help)));
            }
            if !entry.doc.is_empty() {
                body.push_str(&format!("<p>{}</p>", html_escape(&entry.doc).replace("\\n", "<br>")));
            }
        }
    }

    html_page("Error Codes", &body, &nav, "../style.css")
}

fn generate_spec_page() -> String {
    let nav = lang_nav("spec", "");
    let features = FeatureRegistry::all_sorted();

    let mut body = String::new();
    body.push_str("<h1>Forge Language Spec</h1>");
    body.push_str("<p>Complete language specification with syntax rules and examples.</p>");

    body.push_str("<h2>Type System</h2>");
    body.push_str(&code_block("int, float, string, bool, null, list<T>, map<K,V>, fn<(A)->R>"));
    body.push_str("<p>Truthy: everything except <code>false</code>, <code>null</code>, <code>0</code>, <code>\"\"</code>.</p>");

    for f in &features {
        let desc = if !f.short.is_empty() { f.short } else { f.description };
        body.push_str(&format!(
            "<h2><a href=\"features/{}.html\">{}</a> {}</h2>",
            f.id, html_escape(f.name), status_badge(f.status)
        ));
        body.push_str(&format!("<p>{}</p>", html_escape(desc)));
        if !f.syntax.is_empty() {
            body.push_str(&code_block(&f.syntax.join("\n")));
        }
    }

    html_page("Language Spec", &body, &nav, "style.css")
}

fn generate_cheatsheet_page() -> String {
    let nav = lang_nav("cheatsheet", "");
    let mut body = String::new();

    body.push_str("<h1>Forge Cheatsheet</h1>");

    let sections: &[(&str, &[&str])] = &[
        ("Variables", &[
            "let x = 1",
            "mut y = 2",
            "const PI = 3.14",
            "let name: string = \"hi\"",
        ]),
        ("Functions", &[
            "fn add(a: int, b: int) -> int {",
            "    a + b",
            "}",
            "fn greet(name: string) { }",
        ]),
        ("Closures", &[
            "(x) -> x * 2",
            "(x, y) -> { x + y }",
            "list.map(it > 0)    // it param",
        ]),
        ("Control Flow", &[
            "if cond { } else { }",
            "for x in list { }",
            "while cond { }",
            "match expr { p -> body }",
        ]),
        ("Operators", &[
            "data |> transform |> output",
            "1..10          // exclusive range",
            "1..=10         // inclusive range",
            "x is int       // type check",
        ]),
        ("Collections", &[
            "[1, 2, 3]              // list",
            "{key: \"val\"}           // map",
            "(1, \"two\", true)       // tuple",
            "type Point { x: int }  // struct",
        ]),
        ("Null Safety", &[
            "let x: int? = null",
            "x ?? default_value",
            "x?.method()",
            "result?        // propagate error",
        ]),
        ("Concurrency", &[
            "spawn { work() }",
            "ch <- val         // send",
            "<- ch             // receive",
            "select { x <- ch -> body }",
        ]),
        ("Strings", &[
            "\"hello ${name}\"      // template",
            "$\"echo ${cmd}\"       // shell exec",
            "s.split(\",\")  s.trim()",
            "s.length()  s.upper()",
        ]),
        ("Special", &[
            "defer cleanup()       // runs at end",
            "expr with { f: val }  // struct update",
            "5m  30s  24h  7d      // durations",
            "use @std.fs.{fs}      // imports",
        ]),
    ];

    body.push_str(r#"<div style="display:grid;grid-template-columns:1fr 1fr;gap:1rem;">"#);
    for (title, lines) in sections {
        body.push_str(&format!("<div><h3>{}</h3>", title));
        body.push_str(&code_block(&lines.join("\n")));
        body.push_str("</div>");
    }
    body.push_str("</div>");

    html_page("Cheatsheet", &body, &nav, "style.css")
}

// ── Project doc pages ───────────────────────────────────────────────

fn generate_docs_index(project_docs: &docs::ProjectDocs) -> String {
    let nav = docs_nav("", "", project_docs);
    let mut body = String::new();

    body.push_str("<h1>Project Documentation</h1>");

    let total = project_docs.functions.len() + project_docs.types.len()
        + project_docs.enums.len() + project_docs.constants.len();
    body.push_str(&format!("<p>{} symbols documented.</p>", total));

    if !project_docs.functions.is_empty() {
        body.push_str("<h2>Functions</h2>");
        body.push_str("<table><thead><tr><th>Name</th><th>Signature</th><th>Description</th></tr></thead><tbody>");
        for f in &project_docs.functions {
            let params: Vec<String> = f.params.iter().map(|(n, t)| {
                if t.is_empty() { n.clone() } else { format!("{}: {}", n, t) }
            }).collect();
            let sig = match &f.return_type {
                Some(ret) => format!("fn {}({}) -> {}", f.name, params.join(", "), ret),
                None => format!("fn {}({})", f.name, params.join(", ")),
            };
            let doc_line = f.doc.lines().next().unwrap_or("");
            body.push_str(&format!(
                r#"<tr><td><a href="symbols/{}.html">{}</a></td><td><code>{}</code></td><td>{}</td></tr>"#,
                html_escape(&f.name), html_escape(&f.name),
                html_escape(&sig),
                html_escape(doc_line)
            ));
        }
        body.push_str("</tbody></table>");
    }

    if !project_docs.types.is_empty() {
        body.push_str("<h2>Types</h2>");
        body.push_str("<table><thead><tr><th>Name</th><th>Kind</th><th>Description</th></tr></thead><tbody>");
        for t in &project_docs.types {
            let doc_line = t.doc.lines().next().unwrap_or("");
            body.push_str(&format!(
                r#"<tr><td><a href="symbols/{}.html">{}</a></td><td>{}</td><td>{}</td></tr>"#,
                html_escape(&t.name), html_escape(&t.name),
                html_escape(&t.kind),
                html_escape(doc_line)
            ));
        }
        body.push_str("</tbody></table>");
    }

    if !project_docs.enums.is_empty() {
        body.push_str("<h2>Enums</h2>");
        body.push_str("<table><thead><tr><th>Name</th><th>Variants</th><th>Description</th></tr></thead><tbody>");
        for e in &project_docs.enums {
            let doc_line = e.doc.lines().next().unwrap_or("");
            body.push_str(&format!(
                r#"<tr><td><a href="symbols/{}.html">{}</a></td><td>{}</td><td>{}</td></tr>"#,
                html_escape(&e.name), html_escape(&e.name),
                html_escape(&e.variants.join(", ")),
                html_escape(doc_line)
            ));
        }
        body.push_str("</tbody></table>");
    }

    html_page("Project Documentation", &body, &nav, "style.css")
}

fn generate_symbol_page_fn(f: &docs::FnDoc, project_docs: &docs::ProjectDocs) -> String {
    let nav = docs_nav(&f.name, "../", project_docs);
    let mut body = String::new();

    let params: Vec<String> = f.params.iter().map(|(n, t)| {
        if t.is_empty() { n.clone() } else { format!("{}: {}", n, t) }
    }).collect();
    let sig = match &f.return_type {
        Some(ret) => format!("fn {}({}) -> {}", f.name, params.join(", "), ret),
        None => format!("fn {}({})", f.name, params.join(", ")),
    };

    body.push_str(&format!("<h1>{}</h1>", html_escape(&f.name)));
    if f.exported {
        body.push_str(r#"<span class="badge badge-stable">exported</span> "#);
    }
    body.push_str(&code_block(&sig));

    if !f.doc.is_empty() {
        body.push_str("<h2>Description</h2>");
        for line in f.doc.lines() {
            body.push_str(&format!("<p>{}</p>", html_escape(line)));
        }
    }

    body.push_str(&format!("<p>Defined in <code>{}:{}</code></p>", html_escape(&f.file), f.line));

    html_page(&f.name, &body, &nav, "../style.css")
}

fn generate_symbol_page_type(t: &docs::TypeDocEntry, project_docs: &docs::ProjectDocs) -> String {
    let nav = docs_nav(&t.name, "../", project_docs);
    let mut body = String::new();

    body.push_str(&format!("<h1>{} {}</h1>", html_escape(&t.kind), html_escape(&t.name)));
    if t.exported {
        body.push_str(r#"<span class="badge badge-stable">exported</span> "#);
    }

    if !t.doc.is_empty() {
        for line in t.doc.lines() {
            body.push_str(&format!("<p>{}</p>", html_escape(line)));
        }
    }

    body.push_str(&format!("<p>Defined in <code>{}:{}</code></p>", html_escape(&t.file), t.line));

    html_page(&t.name, &body, &nav, "../style.css")
}

fn generate_symbol_page_enum(e: &docs::EnumDoc, project_docs: &docs::ProjectDocs) -> String {
    let nav = docs_nav(&e.name, "../", project_docs);
    let mut body = String::new();

    body.push_str(&format!("<h1>enum {}</h1>", html_escape(&e.name)));
    if e.exported {
        body.push_str(r#"<span class="badge badge-stable">exported</span> "#);
    }

    if !e.doc.is_empty() {
        for line in e.doc.lines() {
            body.push_str(&format!("<p>{}</p>", html_escape(line)));
        }
    }

    if !e.variants.is_empty() {
        body.push_str("<h2>Variants</h2><ul>");
        for v in &e.variants {
            body.push_str(&format!("<li><code>{}</code></li>", html_escape(v)));
        }
        body.push_str("</ul>");
    }

    body.push_str(&format!("<p>Defined in <code>{}:{}</code></p>", html_escape(&e.file), e.line));

    html_page(&e.name, &body, &nav, "../style.css")
}

// ── Helpers ─────────────────────────────────────────────────────────

fn truncate_html(s: &str, max: usize) -> String {
    let escaped = html_escape(s);
    if escaped.len() > max {
        format!("{}...", &escaped[..max.saturating_sub(3)])
    } else {
        escaped
    }
}

fn ensure_dir(path: &Path) {
    if !path.exists() {
        std::fs::create_dir_all(path).unwrap_or_else(|e| {
            eprintln!("Failed to create directory {}: {}", path.display(), e);
        });
    }
}

// ── Public API ──────────────────────────────────────────────────────

/// Generate a complete static website for the Forge language reference.
pub fn generate_lang_site(output_dir: &str) {
    let out = Path::new(output_dir);
    ensure_dir(out);
    ensure_dir(&out.join("features"));
    ensure_dir(&out.join("types"));
    ensure_dir(&out.join("errors"));

    let features = FeatureRegistry::all_sorted();
    let types = builtin_types();

    // style.css
    std::fs::write(out.join("style.css"), generate_css())
        .expect("Failed to write style.css");

    // search-index.json
    std::fs::write(out.join("search-index.json"), generate_search_index())
        .expect("Failed to write search-index.json");

    // index.html
    let feature_refs: Vec<&FeatureMetadata> = features.iter().copied().collect();
    std::fs::write(
        out.join("index.html"),
        generate_index_page(&feature_refs, &types),
    )
    .expect("Failed to write index.html");

    // Feature pages
    for f in &features {
        std::fs::write(
            out.join("features").join(format!("{}.html", f.id)),
            generate_feature_page(f),
        )
        .expect("Failed to write feature page");
    }

    // Type pages
    for t in &types {
        std::fs::write(
            out.join("types").join(format!("{}.html", t.name)),
            generate_type_page(t),
        )
        .expect("Failed to write type page");
    }

    // Errors page
    std::fs::write(out.join("errors").join("index.html"), generate_errors_page())
        .expect("Failed to write errors page");

    // Spec page
    std::fs::write(out.join("spec.html"), generate_spec_page())
        .expect("Failed to write spec page");

    // Cheatsheet page
    std::fs::write(out.join("cheatsheet.html"), generate_cheatsheet_page())
        .expect("Failed to write cheatsheet page");

    let total_pages = 1 + features.len() + types.len() + 1 + 1 + 1; // index + features + types + errors + spec + cheatsheet
    eprintln!("Generated {} pages in {}/", total_pages, output_dir);
}

/// Generate a complete static website for project documentation.
pub fn generate_docs_site(project_dir: &str, output_dir: &str) {
    let project_path = Path::new(project_dir);
    let out = Path::new(output_dir);
    ensure_dir(out);
    ensure_dir(&out.join("symbols"));

    let project_docs = docs::extract_project_docs(project_path);

    // style.css (same styles)
    std::fs::write(out.join("style.css"), generate_css())
        .expect("Failed to write style.css");

    // index.html
    std::fs::write(out.join("index.html"), generate_docs_index(&project_docs))
        .expect("Failed to write index.html");

    // Symbol pages - functions
    for f in &project_docs.functions {
        std::fs::write(
            out.join("symbols").join(format!("{}.html", f.name)),
            generate_symbol_page_fn(f, &project_docs),
        )
        .expect("Failed to write symbol page");
    }

    // Symbol pages - types
    for t in &project_docs.types {
        std::fs::write(
            out.join("symbols").join(format!("{}.html", t.name)),
            generate_symbol_page_type(t, &project_docs),
        )
        .expect("Failed to write symbol page");
    }

    // Symbol pages - enums
    for e in &project_docs.enums {
        std::fs::write(
            out.join("symbols").join(format!("{}.html", e.name)),
            generate_symbol_page_enum(e, &project_docs),
        )
        .expect("Failed to write symbol page");
    }

    // Generate embedded language reference
    let lang_dir = out.join("lang");
    generate_lang_site(&lang_dir.to_string_lossy());

    let symbol_count = project_docs.functions.len() + project_docs.types.len() + project_docs.enums.len();
    eprintln!("Generated project docs ({} symbols) in {}/", symbol_count, output_dir);
}
