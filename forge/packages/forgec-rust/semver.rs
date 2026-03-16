/// Compiler-enforced semver — API diffing and minimum version bump calculation.
///
/// Parses two context.fg files (output from `forge context`), diffs their
/// API surfaces, classifies each change as major/minor/patch, and computes
/// the minimum allowed version bump.

use std::collections::HashMap;

// ── API item types ──────────────────────────────────────────────────

/// Represents a parsed API item from a context.fg file.
#[derive(Debug, Clone, PartialEq)]
pub enum ApiItem {
    Function {
        name: String,
        params: Vec<(String, String)>, // (name, type_str)
        return_type: Option<String>,
    },
    Type {
        name: String,
        definition: String, // the full type definition as string
    },
    Enum {
        name: String,
        variants: Vec<String>,
    },
    Trait {
        name: String,
        methods: Vec<String>, // method signatures as strings
    },
    Component {
        kind: String,
        name: Option<String>,
    },
    Constant {
        name: String,
        type_str: Option<String>,
    },
}

impl ApiItem {
    /// Return the identifying name/key for this item.
    pub fn key(&self) -> String {
        match self {
            ApiItem::Function { name, .. } => format!("fn:{}", name),
            ApiItem::Type { name, .. } => format!("type:{}", name),
            ApiItem::Enum { name, .. } => format!("enum:{}", name),
            ApiItem::Trait { name, .. } => format!("trait:{}", name),
            ApiItem::Component { kind, name } => match name {
                Some(n) => format!("component:{}:{}", kind, n),
                None => format!("component:{}", kind),
            },
            ApiItem::Constant { name, .. } => format!("const:{}", name),
        }
    }

    /// Return a human-readable display name.
    pub fn display_name(&self) -> String {
        match self {
            ApiItem::Function { name, .. } => format!("fn {}", name),
            ApiItem::Type { name, .. } => format!("type {}", name),
            ApiItem::Enum { name, .. } => format!("enum {}", name),
            ApiItem::Trait { name, .. } => format!("trait {}", name),
            ApiItem::Component { kind, name } => match name {
                Some(n) => format!("component {} {}", kind, n),
                None => format!("component {}", kind),
            },
            ApiItem::Constant { name, .. } => format!("const {}", name),
        }
    }
}

// ── Change types ────────────────────────────────────────────────────

/// A change between two API versions.
#[derive(Debug)]
pub enum ApiChange {
    Added(ApiItem),
    Removed(ApiItem),
    Changed {
        name: String,
        old: ApiItem,
        new: ApiItem,
    },
}

/// The computed minimum bump level.
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub enum BumpLevel {
    Patch, // no API changes (internal only)
    Minor, // additions only
    Major, // removals or breaking changes
}

impl std::fmt::Display for BumpLevel {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            BumpLevel::Patch => write!(f, "patch"),
            BumpLevel::Minor => write!(f, "minor"),
            BumpLevel::Major => write!(f, "major"),
        }
    }
}

// ── Parsing ─────────────────────────────────────────────────────────

/// Parse a context.fg string into a list of API items.
///
/// The format is the text output from `forge context`. Lines are parsed as:
/// - `export fn name(params) -> ReturnType` → Function
/// - `export type Name = ...` → Type (single-line or multi-line struct)
/// - `export enum Name { ... }` → Enum
/// - `export trait Name { ... }` → Trait
/// - `// component kind name` → Component
/// - `export let name: type` / `export const name: type` → Constant
pub fn parse_context(content: &str) -> Vec<ApiItem> {
    let mut items = Vec::new();
    let lines: Vec<&str> = content.lines().collect();
    let mut i = 0;

    while i < lines.len() {
        let line = lines[i].trim();

        // Functions: export fn name(params) -> RetType
        if line.starts_with("export fn ") {
            if let Some(item) = parse_fn_line(line) {
                items.push(item);
            }
            i += 1;
            continue;
        }

        // Type declarations: export type Name = ...
        if line.starts_with("export type ") {
            let (item, consumed) = parse_type_lines(&lines, i);
            if let Some(item) = item {
                items.push(item);
            }
            i += consumed;
            continue;
        }

        // Enum declarations: export enum Name {
        if line.starts_with("export enum ") {
            let (item, consumed) = parse_enum_lines(&lines, i);
            if let Some(item) = item {
                items.push(item);
            }
            i += consumed;
            continue;
        }

        // Trait declarations: export trait Name {
        if line.starts_with("export trait ") {
            let (item, consumed) = parse_trait_lines(&lines, i);
            if let Some(item) = item {
                items.push(item);
            }
            i += consumed;
            continue;
        }

        // Components: // component kind name
        if line.starts_with("// component ") {
            let rest = &line["// component ".len()..];
            let parts: Vec<&str> = rest.split_whitespace().collect();
            if !parts.is_empty() {
                items.push(ApiItem::Component {
                    kind: parts[0].to_string(),
                    name: parts.get(1).map(|s| s.to_string()),
                });
            }
            i += 1;
            continue;
        }

        // Constants: export let name: type  or  export const name: type
        if line.starts_with("export let ") || line.starts_with("export const ") {
            if let Some(item) = parse_constant_line(line) {
                items.push(item);
            }
            i += 1;
            continue;
        }

        i += 1;
    }

    items
}

/// Parse `export fn name(params) -> RetType`
fn parse_fn_line(line: &str) -> Option<ApiItem> {
    let rest = &line["export fn ".len()..];

    // Find the function name (up to the opening paren)
    let paren_pos = rest.find('(')?;
    let name = rest[..paren_pos].trim().to_string();

    // Find matching closing paren
    let after_name = &rest[paren_pos..];
    let close_paren = find_matching_paren(after_name)?;
    let params_str = &after_name[1..close_paren]; // between ( and )

    // Parse params
    let params = parse_param_list(params_str);

    // Return type (after ->)
    let after_params = &after_name[close_paren + 1..].trim();
    let return_type = if after_params.starts_with("->") {
        Some(after_params[2..].trim().to_string())
    } else {
        None
    };

    Some(ApiItem::Function {
        name,
        params,
        return_type,
    })
}

/// Parse a comma-separated parameter list like `name: type, name2: type2`
fn parse_param_list(s: &str) -> Vec<(String, String)> {
    if s.trim().is_empty() {
        return Vec::new();
    }

    let mut params = Vec::new();
    // Split on commas, but respect nested parens/brackets
    let mut depth = 0;
    let mut current = String::new();

    for ch in s.chars() {
        match ch {
            '(' | '<' | '{' | '[' => {
                depth += 1;
                current.push(ch);
            }
            ')' | '>' | '}' | ']' => {
                depth -= 1;
                current.push(ch);
            }
            ',' if depth == 0 => {
                params.push(parse_single_param(current.trim()));
                current = String::new();
            }
            _ => current.push(ch),
        }
    }

    if !current.trim().is_empty() {
        params.push(parse_single_param(current.trim()));
    }

    params
}

fn parse_single_param(s: &str) -> (String, String) {
    if let Some(colon_pos) = s.find(':') {
        let name = s[..colon_pos].trim().to_string();
        let ty = s[colon_pos + 1..].trim().to_string();
        (name, ty)
    } else {
        (s.trim().to_string(), String::new())
    }
}

/// Find the index of the matching closing paren for an opening paren at index 0.
fn find_matching_paren(s: &str) -> Option<usize> {
    let mut depth = 0;
    for (i, ch) in s.char_indices() {
        match ch {
            '(' => depth += 1,
            ')' => {
                depth -= 1;
                if depth == 0 {
                    return Some(i);
                }
            }
            _ => {}
        }
    }
    None
}

/// Parse a type declaration, which may be multi-line for structs.
/// Returns (item, lines_consumed).
fn parse_type_lines(lines: &[&str], start: usize) -> (Option<ApiItem>, usize) {
    let first = lines[start].trim();
    let rest = &first["export type ".len()..];

    // Find ` = `
    let eq_pos = match rest.find(" = ") {
        Some(p) => p,
        None => return (None, 1),
    };
    let name = rest[..eq_pos].trim().to_string();
    let value_start = &rest[eq_pos + 3..];

    // Check if it's a multi-line struct (ends with {)
    if value_start.trim() == "{" || value_start.trim().ends_with('{') {
        // Collect lines until we find the closing }
        let mut definition = value_start.to_string();
        let mut consumed = 1;
        let mut i = start + 1;
        while i < lines.len() {
            let l = lines[i];
            definition.push('\n');
            definition.push_str(l);
            consumed += 1;
            if l.trim() == "}" {
                break;
            }
            i += 1;
        }
        (
            Some(ApiItem::Type { name, definition }),
            consumed,
        )
    } else {
        (
            Some(ApiItem::Type {
                name,
                definition: value_start.trim().to_string(),
            }),
            1,
        )
    }
}

/// Parse an enum declaration (multi-line).
fn parse_enum_lines(lines: &[&str], start: usize) -> (Option<ApiItem>, usize) {
    let first = lines[start].trim();
    let rest = &first["export enum ".len()..];

    // Name is everything before {
    let brace_pos = match rest.find('{') {
        Some(p) => p,
        None => return (None, 1),
    };
    let name = rest[..brace_pos].trim().to_string();

    let mut variants = Vec::new();
    let mut consumed = 1;
    let mut i = start + 1;

    while i < lines.len() {
        let l = lines[i].trim();
        consumed += 1;
        if l == "}" {
            break;
        }
        if !l.is_empty() {
            variants.push(l.to_string());
        }
        i += 1;
    }

    (Some(ApiItem::Enum { name, variants }), consumed)
}

/// Parse a trait declaration (multi-line).
fn parse_trait_lines(lines: &[&str], start: usize) -> (Option<ApiItem>, usize) {
    let first = lines[start].trim();
    let rest = &first["export trait ".len()..];

    let brace_pos = match rest.find('{') {
        Some(p) => p,
        None => return (None, 1),
    };
    let name = rest[..brace_pos].trim().to_string();

    let mut methods = Vec::new();
    let mut consumed = 1;
    let mut i = start + 1;

    while i < lines.len() {
        let l = lines[i].trim();
        consumed += 1;
        if l == "}" {
            break;
        }
        if !l.is_empty() {
            methods.push(l.to_string());
        }
        i += 1;
    }

    (Some(ApiItem::Trait { name, methods }), consumed)
}

/// Parse `export let name: type` or `export const name: type`.
fn parse_constant_line(line: &str) -> Option<ApiItem> {
    let rest = if line.starts_with("export let ") {
        &line["export let ".len()..]
    } else {
        &line["export const ".len()..]
    };

    if let Some(colon_pos) = rest.find(':') {
        let name = rest[..colon_pos].trim().to_string();
        let type_str = rest[colon_pos + 1..].trim().to_string();
        Some(ApiItem::Constant {
            name,
            type_str: if type_str.is_empty() {
                None
            } else {
                Some(type_str)
            },
        })
    } else {
        Some(ApiItem::Constant {
            name: rest.trim().to_string(),
            type_str: None,
        })
    }
}

// ── Diffing ─────────────────────────────────────────────────────────

/// Diff two API surfaces. Items are matched by key (kind + name).
pub fn diff_api(old: &[ApiItem], new: &[ApiItem]) -> Vec<ApiChange> {
    let mut changes = Vec::new();

    let old_map: HashMap<String, &ApiItem> = old.iter().map(|item| (item.key(), item)).collect();
    let new_map: HashMap<String, &ApiItem> = new.iter().map(|item| (item.key(), item)).collect();

    // Removed: in old but not in new
    for (key, old_item) in &old_map {
        if !new_map.contains_key(key) {
            changes.push(ApiChange::Removed((*old_item).clone()));
        }
    }

    // Added: in new but not in old
    for (key, new_item) in &new_map {
        if !old_map.contains_key(key) {
            changes.push(ApiChange::Added((*new_item).clone()));
        }
    }

    // Changed: in both but different
    for (key, old_item) in &old_map {
        if let Some(new_item) = new_map.get(key) {
            if old_item != new_item {
                changes.push(ApiChange::Changed {
                    name: old_item.display_name(),
                    old: (*old_item).clone(),
                    new: (*new_item).clone(),
                });
            }
        }
    }

    // Sort for deterministic output: removals, then changes, then additions
    changes.sort_by(|a, b| {
        let order = |c: &ApiChange| -> u8 {
            match c {
                ApiChange::Removed(_) => 0,
                ApiChange::Changed { .. } => 1,
                ApiChange::Added(_) => 2,
            }
        };
        order(a).cmp(&order(b))
    });

    changes
}

// ── Classification ──────────────────────────────────────────────────

/// Classify changes and compute minimum bump.
///
/// - Any Removed or Changed → Major
/// - Only Added → Minor
/// - No changes → Patch
pub fn compute_minimum_bump(changes: &[ApiChange]) -> BumpLevel {
    if changes.is_empty() {
        return BumpLevel::Patch;
    }

    let mut level = BumpLevel::Patch;

    for change in changes {
        match change {
            ApiChange::Added(_) => {
                if level < BumpLevel::Minor {
                    level = BumpLevel::Minor;
                }
            }
            ApiChange::Removed(_) | ApiChange::Changed { .. } => {
                level = BumpLevel::Major;
            }
        }
    }

    level
}

// ── Version validation ──────────────────────────────────────────────

/// A simple semver version (major.minor.patch).
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct SemVer {
    pub major: u64,
    pub minor: u64,
    pub patch: u64,
}

impl SemVer {
    /// Parse a version string like "1.2.3" or "v1.2.3".
    pub fn parse(s: &str) -> Option<SemVer> {
        let s = s.strip_prefix('v').unwrap_or(s);
        let parts: Vec<&str> = s.split('.').collect();
        if parts.len() != 3 {
            return None;
        }
        Some(SemVer {
            major: parts[0].parse().ok()?,
            minor: parts[1].parse().ok()?,
            patch: parts[2].parse().ok()?,
        })
    }

    /// Check whether bumping from `old` to `self` satisfies the required `level`.
    pub fn satisfies_bump(&self, old: &SemVer, level: BumpLevel) -> bool {
        match level {
            BumpLevel::Major => self.major > old.major,
            BumpLevel::Minor => {
                self.major > old.major
                    || (self.major == old.major && self.minor > old.minor)
            }
            BumpLevel::Patch => {
                self.major > old.major
                    || (self.major == old.major && self.minor > old.minor)
                    || (self.major == old.major
                        && self.minor == old.minor
                        && self.patch > old.patch)
            }
        }
    }
}

impl std::fmt::Display for SemVer {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}.{}.{}", self.major, self.minor, self.patch)
    }
}

/// Validate that a proposed version bump is sufficient.
/// Returns Ok(()) if valid, Err(reason) if insufficient.
pub fn validate_version_bump(
    old_version: &str,
    new_version: &str,
    minimum_bump: BumpLevel,
) -> Result<(), String> {
    let old = SemVer::parse(old_version)
        .ok_or_else(|| format!("invalid old version: '{}'", old_version))?;
    let new = SemVer::parse(new_version)
        .ok_or_else(|| format!("invalid new version: '{}'", new_version))?;

    if new.satisfies_bump(&old, minimum_bump) {
        Ok(())
    } else {
        Err(format!(
            "version {} -> {} is insufficient; minimum bump is {} (need at least {})",
            old,
            new,
            minimum_bump,
            match minimum_bump {
                BumpLevel::Major => format!("{}.0.0", old.major + 1),
                BumpLevel::Minor => format!("{}.{}.0", old.major, old.minor + 1),
                BumpLevel::Patch => format!("{}.{}.{}", old.major, old.minor, old.patch + 1),
            }
        ))
    }
}

// ── Reporting ───────────────────────────────────────────────────────

/// Format a human-readable diff report.
pub fn format_diff_report(changes: &[ApiChange], bump: &BumpLevel) -> String {
    let mut out = String::new();

    if changes.is_empty() {
        out.push_str("No API changes detected.\n");
        out.push_str("Minimum bump: patch\n");
        return out;
    }

    // Count by category
    let mut added = 0u32;
    let mut removed = 0u32;
    let mut changed = 0u32;

    for c in changes {
        match c {
            ApiChange::Added(_) => added += 1,
            ApiChange::Removed(_) => removed += 1,
            ApiChange::Changed { .. } => changed += 1,
        }
    }

    // Header
    out.push_str(&format!(
        "API diff: {} change{} ({} added, {} removed, {} changed)\n",
        changes.len(),
        if changes.len() == 1 { "" } else { "s" },
        added,
        removed,
        changed,
    ));
    out.push_str(&format!("Minimum bump: {}\n", bump));
    out.push('\n');

    // Removals (breaking)
    let removals: Vec<&ApiChange> = changes
        .iter()
        .filter(|c| matches!(c, ApiChange::Removed(_)))
        .collect();
    if !removals.is_empty() {
        out.push_str("  REMOVED (breaking):\n");
        for c in &removals {
            if let ApiChange::Removed(item) = c {
                out.push_str(&format!("    - {}\n", item.display_name()));
            }
        }
        out.push('\n');
    }

    // Changes (breaking)
    let modifications: Vec<&ApiChange> = changes
        .iter()
        .filter(|c| matches!(c, ApiChange::Changed { .. }))
        .collect();
    if !modifications.is_empty() {
        out.push_str("  CHANGED (breaking):\n");
        for c in &modifications {
            if let ApiChange::Changed { name, old, new } = c {
                out.push_str(&format!("    ~ {}\n", name));
                out.push_str(&format!("      old: {}\n", format_item_summary(old)));
                out.push_str(&format!("      new: {}\n", format_item_summary(new)));
            }
        }
        out.push('\n');
    }

    // Additions (non-breaking)
    let additions: Vec<&ApiChange> = changes
        .iter()
        .filter(|c| matches!(c, ApiChange::Added(_)))
        .collect();
    if !additions.is_empty() {
        out.push_str("  ADDED:\n");
        for c in &additions {
            if let ApiChange::Added(item) = c {
                out.push_str(&format!("    + {}\n", item.display_name()));
            }
        }
        out.push('\n');
    }

    out
}

/// Format a short summary of an item for the diff report.
fn format_item_summary(item: &ApiItem) -> String {
    match item {
        ApiItem::Function {
            name,
            params,
            return_type,
        } => {
            let params_str: Vec<String> =
                params.iter().map(|(n, t)| {
                    if t.is_empty() { n.clone() } else { format!("{}: {}", n, t) }
                }).collect();
            match return_type {
                Some(ret) => format!("fn {}({}) -> {}", name, params_str.join(", "), ret),
                None => format!("fn {}({})", name, params_str.join(", ")),
            }
        }
        ApiItem::Type { name, definition } => format!("type {} = {}", name, definition),
        ApiItem::Enum { name, variants } => {
            format!("enum {} {{ {} }}", name, variants.join(", "))
        }
        ApiItem::Trait { name, methods } => {
            format!("trait {} ({} methods)", name, methods.len())
        }
        ApiItem::Component { kind, name } => match name {
            Some(n) => format!("component {} {}", kind, n),
            None => format!("component {}", kind),
        },
        ApiItem::Constant { name, type_str } => match type_str {
            Some(t) => format!("const {}: {}", name, t),
            None => format!("const {}", name),
        },
    }
}

// ── Tests ───────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_function() {
        let ctx = "export fn greet(name: string) -> string\n";
        let items = parse_context(ctx);
        assert_eq!(items.len(), 1);
        match &items[0] {
            ApiItem::Function {
                name,
                params,
                return_type,
            } => {
                assert_eq!(name, "greet");
                assert_eq!(params, &[("name".to_string(), "string".to_string())]);
                assert_eq!(return_type, &Some("string".to_string()));
            }
            _ => panic!("expected Function"),
        }
    }

    #[test]
    fn test_parse_function_no_return() {
        let ctx = "export fn do_thing(x: int)\n";
        let items = parse_context(ctx);
        assert_eq!(items.len(), 1);
        match &items[0] {
            ApiItem::Function { return_type, .. } => {
                assert_eq!(return_type, &None);
            }
            _ => panic!("expected Function"),
        }
    }

    #[test]
    fn test_parse_type_simple() {
        let ctx = "export type UserId = int\n";
        let items = parse_context(ctx);
        assert_eq!(items.len(), 1);
        match &items[0] {
            ApiItem::Type { name, definition } => {
                assert_eq!(name, "UserId");
                assert_eq!(definition, "int");
            }
            _ => panic!("expected Type"),
        }
    }

    #[test]
    fn test_parse_type_struct() {
        let ctx = "export type User = {\n    name: string\n    age: int\n}\n";
        let items = parse_context(ctx);
        assert_eq!(items.len(), 1);
        match &items[0] {
            ApiItem::Type { name, definition } => {
                assert_eq!(name, "User");
                assert!(definition.contains("name: string"));
            }
            _ => panic!("expected Type"),
        }
    }

    #[test]
    fn test_parse_enum() {
        let ctx = "export enum Status {\n    Active\n    Inactive\n}\n";
        let items = parse_context(ctx);
        assert_eq!(items.len(), 1);
        match &items[0] {
            ApiItem::Enum { name, variants } => {
                assert_eq!(name, "Status");
                assert_eq!(variants.len(), 2);
            }
            _ => panic!("expected Enum"),
        }
    }

    #[test]
    fn test_parse_component() {
        let ctx = "// component model User\n";
        let items = parse_context(ctx);
        assert_eq!(items.len(), 1);
        match &items[0] {
            ApiItem::Component { kind, name } => {
                assert_eq!(kind, "model");
                assert_eq!(name, &Some("User".to_string()));
            }
            _ => panic!("expected Component"),
        }
    }

    #[test]
    fn test_parse_constant() {
        let ctx = "export let MAX_SIZE: int\n";
        let items = parse_context(ctx);
        assert_eq!(items.len(), 1);
        match &items[0] {
            ApiItem::Constant { name, type_str } => {
                assert_eq!(name, "MAX_SIZE");
                assert_eq!(type_str, &Some("int".to_string()));
            }
            _ => panic!("expected Constant"),
        }
    }

    #[test]
    fn test_diff_no_changes() {
        let old = vec![ApiItem::Function {
            name: "greet".to_string(),
            params: vec![("name".to_string(), "string".to_string())],
            return_type: Some("string".to_string()),
        }];
        let new = old.clone();
        let changes = diff_api(&old, &new);
        assert!(changes.is_empty());
        assert_eq!(compute_minimum_bump(&changes), BumpLevel::Patch);
    }

    #[test]
    fn test_diff_addition() {
        let old = vec![];
        let new = vec![ApiItem::Function {
            name: "greet".to_string(),
            params: vec![],
            return_type: None,
        }];
        let changes = diff_api(&old, &new);
        assert_eq!(changes.len(), 1);
        assert!(matches!(&changes[0], ApiChange::Added(_)));
        assert_eq!(compute_minimum_bump(&changes), BumpLevel::Minor);
    }

    #[test]
    fn test_diff_removal() {
        let old = vec![ApiItem::Function {
            name: "greet".to_string(),
            params: vec![],
            return_type: None,
        }];
        let new = vec![];
        let changes = diff_api(&old, &new);
        assert_eq!(changes.len(), 1);
        assert!(matches!(&changes[0], ApiChange::Removed(_)));
        assert_eq!(compute_minimum_bump(&changes), BumpLevel::Major);
    }

    #[test]
    fn test_diff_change() {
        let old = vec![ApiItem::Function {
            name: "greet".to_string(),
            params: vec![("name".to_string(), "string".to_string())],
            return_type: Some("string".to_string()),
        }];
        let new = vec![ApiItem::Function {
            name: "greet".to_string(),
            params: vec![
                ("name".to_string(), "string".to_string()),
                ("greeting".to_string(), "string".to_string()),
            ],
            return_type: Some("string".to_string()),
        }];
        let changes = diff_api(&old, &new);
        assert_eq!(changes.len(), 1);
        assert!(matches!(&changes[0], ApiChange::Changed { .. }));
        assert_eq!(compute_minimum_bump(&changes), BumpLevel::Major);
    }

    #[test]
    fn test_semver_parse() {
        let v = SemVer::parse("1.2.3").unwrap();
        assert_eq!(v.major, 1);
        assert_eq!(v.minor, 2);
        assert_eq!(v.patch, 3);

        let v2 = SemVer::parse("v0.1.0").unwrap();
        assert_eq!(v2.major, 0);

        assert!(SemVer::parse("not-a-version").is_none());
        assert!(SemVer::parse("1.2").is_none());
    }

    #[test]
    fn test_version_bump_validation() {
        // Major bump required, but only minor given
        assert!(validate_version_bump("1.0.0", "1.1.0", BumpLevel::Major).is_err());
        // Major bump required, major given
        assert!(validate_version_bump("1.0.0", "2.0.0", BumpLevel::Major).is_ok());
        // Minor bump required, minor given
        assert!(validate_version_bump("1.0.0", "1.1.0", BumpLevel::Minor).is_ok());
        // Patch bump required, patch given
        assert!(validate_version_bump("1.0.0", "1.0.1", BumpLevel::Patch).is_ok());
    }

    #[test]
    fn test_full_roundtrip() {
        let old_ctx = "\
// Context for: mylib
// Generated: 2026-01-01

// Functions
export fn create_user(name: string, email: string) -> User
export fn delete_user(id: int)

// Types
export type UserId = int
";

        let new_ctx = "\
// Context for: mylib
// Generated: 2026-03-15

// Functions
export fn create_user(name: string, email: string, role: string) -> User
export fn find_user(id: int) -> User

// Types
export type UserId = int
";

        let old = parse_context(old_ctx);
        let new = parse_context(new_ctx);

        assert_eq!(old.len(), 3); // 2 fns + 1 type
        assert_eq!(new.len(), 3); // 2 fns + 1 type

        let changes = diff_api(&old, &new);

        // delete_user removed, create_user changed, find_user added
        assert_eq!(changes.len(), 3);
        assert_eq!(compute_minimum_bump(&changes), BumpLevel::Major);

        let report = format_diff_report(&changes, &BumpLevel::Major);
        assert!(report.contains("REMOVED"));
        assert!(report.contains("CHANGED"));
        assert!(report.contains("ADDED"));
        assert!(report.contains("major"));
    }
}
