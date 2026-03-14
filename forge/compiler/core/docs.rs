/// Project documentation system.
///
/// Extracts `///` doc comments from Forge source files and renders
/// them for `forge docs` CLI commands.

use std::path::{Path, PathBuf};

// ── ANSI helpers ────────────────────────────────────────────────────

fn dim(s: &str) -> String {
    format!("\x1b[2m{}\x1b[0m", s)
}

fn bold(s: &str) -> String {
    format!("\x1b[1m{}\x1b[0m", s)
}

fn cyan(s: &str) -> String {
    format!("\x1b[36m{}\x1b[0m", s)
}

fn yellow(s: &str) -> String {
    format!("\x1b[33m{}\x1b[0m", s)
}

// ── Data types ──────────────────────────────────────────────────────

pub struct ProjectDocs {
    pub functions: Vec<FnDoc>,
    pub types: Vec<TypeDocEntry>,
    pub enums: Vec<EnumDoc>,
    pub constants: Vec<VarDoc>,
}

pub struct FnDoc {
    pub name: String,
    pub params: Vec<(String, String)>,
    pub return_type: Option<String>,
    pub doc: String,
    pub file: String,
    pub line: usize,
    pub exported: bool,
}

pub struct TypeDocEntry {
    pub name: String,
    pub kind: String, // "type" or "struct"
    pub fields: Vec<(String, String)>,
    pub doc: String,
    pub file: String,
    pub line: usize,
    pub exported: bool,
}

pub struct EnumDoc {
    pub name: String,
    pub variants: Vec<String>,
    pub doc: String,
    pub file: String,
    pub line: usize,
    pub exported: bool,
}

pub struct VarDoc {
    pub name: String,
    pub kind: String, // "let", "mut", "const"
    pub type_ann: Option<String>,
    pub doc: String,
    pub file: String,
    pub line: usize,
    pub exported: bool,
}

impl ProjectDocs {
    fn new() -> Self {
        Self {
            functions: Vec::new(),
            types: Vec::new(),
            enums: Vec::new(),
            constants: Vec::new(),
        }
    }

    fn merge(&mut self, other: ProjectDocs) {
        self.functions.extend(other.functions);
        self.types.extend(other.types);
        self.enums.extend(other.enums);
        self.constants.extend(other.constants);
    }

    fn is_empty(&self) -> bool {
        self.functions.is_empty()
            && self.types.is_empty()
            && self.enums.is_empty()
            && self.constants.is_empty()
    }

    fn total_symbols(&self) -> usize {
        self.functions.len() + self.types.len() + self.enums.len() + self.constants.len()
    }

    fn documented_count(&self) -> usize {
        self.functions.iter().filter(|f| !f.doc.is_empty()).count()
            + self.types.iter().filter(|t| !t.doc.is_empty()).count()
            + self.enums.iter().filter(|e| !e.doc.is_empty()).count()
            + self.constants.iter().filter(|c| !c.doc.is_empty()).count()
    }
}

// ── Source-level doc extraction ─────────────────────────────────────

/// Extract documentation from a single source file by scanning lines.
/// This works at the source text level, not the AST level, to avoid
/// adding `doc` fields to every AST node.
pub fn extract_docs(source: &str, file_path: &str) -> ProjectDocs {
    let mut docs = ProjectDocs::new();
    let lines: Vec<&str> = source.lines().collect();
    let mut i = 0;

    while i < lines.len() {
        // Collect consecutive /// lines
        let mut doc_lines: Vec<&str> = Vec::new();
        while i < lines.len() {
            let trimmed = lines[i].trim();
            if trimmed.starts_with("///") {
                // Strip the /// prefix and optional leading space
                let content = trimmed.strip_prefix("///").unwrap_or("");
                let content = content.strip_prefix(' ').unwrap_or(content);
                doc_lines.push(content);
                i += 1;
            } else {
                break;
            }
        }

        if i >= lines.len() {
            break;
        }

        let decl_line = lines[i].trim();
        let doc_text = doc_lines.join("\n").trim().to_string();
        let line_num = i + 1;

        // Skip doc blocks that contain test expectations (/// expect: ... or /// expect-error: ...)
        if doc_lines.iter().any(|l| l.starts_with("expect:") || l.starts_with("expect-error:")) {
            i += 1;
            continue;
        }

        // Check for export prefix
        let (exported, decl) = if decl_line.starts_with("export ") {
            (true, decl_line.strip_prefix("export ").unwrap_or(decl_line).trim())
        } else {
            (false, decl_line)
        };

        // Match declaration patterns
        if decl.starts_with("fn ") {
            if let Some(fn_doc) = parse_fn_signature(decl, &doc_text, file_path, line_num, exported) {
                docs.functions.push(fn_doc);
            }
        } else if decl.starts_with("type ") {
            if let Some(type_doc) = parse_type_decl(decl, &doc_text, file_path, line_num, exported) {
                docs.types.push(type_doc);
            }
        } else if decl.starts_with("enum ") {
            if let Some(enum_doc) = parse_enum_decl(decl, &lines, i, &doc_text, file_path, line_num, exported) {
                docs.enums.push(enum_doc);
            }
        } else if decl.starts_with("let ") || decl.starts_with("mut ") || decl.starts_with("const ") {
            if let Some(var_doc) = parse_var_decl(decl, &doc_text, file_path, line_num, exported) {
                docs.constants.push(var_doc);
            }
        }

        i += 1;
    }

    docs
}

fn parse_fn_signature(line: &str, doc: &str, file: &str, line_num: usize, exported: bool) -> Option<FnDoc> {
    // fn name(params) -> return_type {
    let rest = line.strip_prefix("fn ")?.trim();

    // Extract name (up to first '(' or '<')
    let name_end = rest.find(|c: char| c == '(' || c == '<')?;
    let name = rest[..name_end].trim().to_string();

    // Skip type params if present
    let after_name = &rest[name_end..];
    let params_start = after_name.find('(')?;
    let after_params_start = &after_name[params_start + 1..];

    // Find matching closing paren (handle nested parens)
    let mut depth = 1;
    let mut params_end = 0;
    for (i, ch) in after_params_start.char_indices() {
        match ch {
            '(' => depth += 1,
            ')' => {
                depth -= 1;
                if depth == 0 {
                    params_end = i;
                    break;
                }
            }
            _ => {}
        }
    }

    let params_str = &after_params_start[..params_end];
    let params = parse_param_list(params_str);

    // Extract return type
    let after_close = &after_params_start[params_end + 1..].trim();
    let return_type = if after_close.starts_with("->") {
        let ret = after_close[2..].trim();
        let ret_end = ret.find('{').unwrap_or(ret.len());
        let ret_str = ret[..ret_end].trim();
        if ret_str.is_empty() {
            None
        } else {
            Some(ret_str.to_string())
        }
    } else {
        None
    };

    Some(FnDoc {
        name,
        params,
        return_type,
        doc: doc.to_string(),
        file: file.to_string(),
        line: line_num,
        exported,
    })
}

fn parse_param_list(params_str: &str) -> Vec<(String, String)> {
    if params_str.trim().is_empty() {
        return Vec::new();
    }

    let mut params = Vec::new();
    let mut depth = 0;
    let mut current = String::new();

    for ch in params_str.chars() {
        match ch {
            '<' | '(' => {
                depth += 1;
                current.push(ch);
            }
            '>' | ')' => {
                depth -= 1;
                current.push(ch);
            }
            ',' if depth == 0 => {
                if let Some(param) = parse_single_param(&current) {
                    params.push(param);
                }
                current.clear();
            }
            _ => current.push(ch),
        }
    }

    if !current.trim().is_empty() {
        if let Some(param) = parse_single_param(&current) {
            params.push(param);
        }
    }

    params
}

fn parse_single_param(param: &str) -> Option<(String, String)> {
    let param = param.trim();
    if param.is_empty() {
        return None;
    }

    if let Some(colon_pos) = param.find(':') {
        let name = param[..colon_pos].trim().to_string();
        let type_str = param[colon_pos + 1..].trim().to_string();
        Some((name, type_str))
    } else {
        Some((param.to_string(), String::new()))
    }
}

fn parse_type_decl(line: &str, doc: &str, file: &str, line_num: usize, exported: bool) -> Option<TypeDocEntry> {
    let rest = line.strip_prefix("type ")?.trim();
    let name_end = rest.find(|c: char| c == '=' || c == '<' || c == ' ').unwrap_or(rest.len());
    let name = rest[..name_end].trim().to_string();

    // Try to detect if it's a struct type (has { fields })
    let remaining = &rest[name_end..].trim();
    let kind = if remaining.contains('{') {
        "struct"
    } else {
        "type"
    };

    Some(TypeDocEntry {
        name,
        kind: kind.to_string(),
        fields: Vec::new(), // Could be parsed further if needed
        doc: doc.to_string(),
        file: file.to_string(),
        line: line_num,
        exported,
    })
}

fn parse_enum_decl(line: &str, lines: &[&str], start: usize, doc: &str, file: &str, line_num: usize, exported: bool) -> Option<EnumDoc> {
    let rest = line.strip_prefix("enum ")?.trim();
    let name_end = rest.find(|c: char| c == '{' || c == ' ').unwrap_or(rest.len());
    let name = rest[..name_end].trim().to_string();

    // Collect variant names from subsequent lines
    let mut variants = Vec::new();
    let mut j = start + 1;
    while j < lines.len() {
        let vline = lines[j].trim();
        if vline == "}" || vline.starts_with('}') {
            break;
        }
        if !vline.is_empty() && !vline.starts_with("//") {
            // Extract variant name (before '(' or ',' or whitespace)
            let vname_end = vline.find(|c: char| c == '(' || c == ',' || c == ' ').unwrap_or(vline.len());
            let vname = vline[..vname_end].trim();
            if !vname.is_empty() {
                variants.push(vname.to_string());
            }
        }
        j += 1;
    }

    Some(EnumDoc {
        name,
        variants,
        doc: doc.to_string(),
        file: file.to_string(),
        line: line_num,
        exported,
    })
}

fn parse_var_decl(line: &str, doc: &str, file: &str, line_num: usize, exported: bool) -> Option<VarDoc> {
    let (kind, rest) = if line.starts_with("const ") {
        ("const", line.strip_prefix("const ")?.trim())
    } else if line.starts_with("mut ") {
        ("mut", line.strip_prefix("mut ")?.trim())
    } else if line.starts_with("let ") {
        ("let", line.strip_prefix("let ")?.trim())
    } else {
        return None;
    };

    let name_end = rest.find(|c: char| c == ':' || c == '=' || c == ' ').unwrap_or(rest.len());
    let name = rest[..name_end].trim().to_string();

    let type_ann = if let Some(colon_pos) = rest.find(':') {
        let after_colon = &rest[colon_pos + 1..];
        let type_end = after_colon.find('=').unwrap_or(after_colon.len());
        let t = after_colon[..type_end].trim();
        if t.is_empty() { None } else { Some(t.to_string()) }
    } else {
        None
    };

    Some(VarDoc {
        name,
        kind: kind.to_string(),
        type_ann,
        doc: doc.to_string(),
        file: file.to_string(),
        line: line_num,
        exported,
    })
}

// ── File discovery ──────────────────────────────────────────────────

/// Find all .fg files in a directory recursively.
pub fn find_fg_files(dir: &Path) -> Vec<PathBuf> {
    let mut files = Vec::new();
    if !dir.is_dir() {
        return files;
    }
    find_fg_files_recursive(dir, &mut files);
    files.sort();
    files
}

fn find_fg_files_recursive(dir: &Path, files: &mut Vec<PathBuf>) {
    let entries = match std::fs::read_dir(dir) {
        Ok(e) => e,
        Err(_) => return,
    };

    for entry in entries.flatten() {
        let path = entry.path();
        if path.is_dir() {
            // Skip hidden directories and common non-source dirs
            let name = path.file_name().and_then(|n| n.to_str()).unwrap_or("");
            if name.starts_with('.') || name == "target" || name == "node_modules" {
                continue;
            }
            find_fg_files_recursive(&path, files);
        } else if path.extension().and_then(|e| e.to_str()) == Some("fg") {
            files.push(path);
        }
    }
}

// ── High-level API ──────────────────────────────────────────────────

/// Extract docs from all .fg files in a directory.
pub fn extract_project_docs(dir: &Path) -> ProjectDocs {
    let mut all_docs = ProjectDocs::new();
    let files = find_fg_files(dir);

    for file in &files {
        let source = match std::fs::read_to_string(file) {
            Ok(s) => s,
            Err(_) => continue,
        };
        let rel_path = file
            .strip_prefix(dir)
            .unwrap_or(file)
            .to_string_lossy()
            .to_string();
        let file_docs = extract_docs(&source, &rel_path);
        all_docs.merge(file_docs);
    }

    all_docs
}

// ── Display ─────────────────────────────────────────────────────────

/// Show an overview of all documented symbols in the project.
pub fn show_overview(docs: &ProjectDocs) {
    println!();
    println!(
        "  {} {} Project Documentation",
        bold("forge docs"),
        dim("\u{2014}")
    );
    println!("  {}", dim(&"\u{2500}".repeat(37)));

    if docs.is_empty() {
        println!();
        println!(
            "  {} No Forge source files found in the current directory.",
            dim("!")
        );
        println!("  Add {} doc comments to your functions and types.", cyan("///"));
        println!();
        return;
    }

    // Functions
    if !docs.functions.is_empty() {
        println!();
        println!("  {} ({})", bold("Functions"), docs.functions.len());
        println!();
        for f in &docs.functions {
            let sig = format_fn_signature(f);
            let export_tag = if f.exported { " [export]" } else { "" };
            let doc_preview = first_line_or_empty(&f.doc);
            if doc_preview.is_empty() {
                println!("    {}{}", sig, dim(export_tag));
            } else {
                println!(
                    "    {:<44} {}{}",
                    sig,
                    dim(&truncate(&doc_preview, 30)),
                    dim(export_tag)
                );
            }
        }
    }

    // Types
    if !docs.types.is_empty() {
        println!();
        println!("  {} ({})", bold("Types"), docs.types.len());
        println!();
        for t in &docs.types {
            let export_tag = if t.exported { " [export]" } else { "" };
            let doc_preview = first_line_or_empty(&t.doc);
            if doc_preview.is_empty() {
                println!("    {}{}", t.name, dim(export_tag));
            } else {
                println!(
                    "    {:<44} {}{}",
                    t.name,
                    dim(&truncate(&doc_preview, 30)),
                    dim(export_tag)
                );
            }
        }
    }

    // Enums
    if !docs.enums.is_empty() {
        println!();
        println!("  {} ({})", bold("Enums"), docs.enums.len());
        println!();
        for e in &docs.enums {
            let export_tag = if e.exported { " [export]" } else { "" };
            let variants_str = if e.variants.is_empty() {
                String::new()
            } else {
                format!("{{ {} }}", e.variants.join(", "))
            };
            println!("    {:<20} {}{}", e.name, dim(&variants_str), dim(export_tag));
        }
    }

    // Constants
    if !docs.constants.is_empty() {
        println!();
        println!("  {} ({})", bold("Constants"), docs.constants.len());
        println!();
        for c in &docs.constants {
            let type_str = c.type_ann.as_deref().unwrap_or("");
            let prefix = match c.kind.as_str() {
                "const" => "const",
                "mut" => "mut",
                _ => "let",
            };
            let sig = if type_str.is_empty() {
                format!("{} {}", prefix, c.name)
            } else {
                format!("{} {}: {}", prefix, c.name, type_str)
            };
            println!("    {}", sig);
        }
    }

    // Summary
    let total = docs.total_symbols();
    let documented = docs.documented_count();
    println!();
    if documented < total {
        println!(
            "  {} {}/{} symbols documented",
            yellow("Coverage:"),
            documented,
            total
        );
    } else {
        println!(
            "  {} {}/{} symbols documented",
            bold("Coverage:"),
            documented,
            total
        );
    }

    println!();
    println!(
        "  Detail: {}    Language ref: {}",
        cyan("forge docs <name>"),
        cyan("forge lang")
    );
    println!();
}

/// Show detailed docs for a specific symbol.
pub fn show_symbol(query: &str, docs: &ProjectDocs) -> bool {
    let query_lower = query.to_lowercase();

    // Search functions
    for f in &docs.functions {
        if f.name.to_lowercase() == query_lower {
            show_fn_detail(f);
            return true;
        }
    }

    // Search types
    for t in &docs.types {
        if t.name.to_lowercase() == query_lower {
            show_type_detail(t);
            return true;
        }
    }

    // Search enums
    for e in &docs.enums {
        if e.name.to_lowercase() == query_lower {
            show_enum_detail(e);
            return true;
        }
    }

    // Search constants
    for c in &docs.constants {
        if c.name.to_lowercase() == query_lower {
            show_var_detail(c);
            return true;
        }
    }

    false
}

fn show_fn_detail(f: &FnDoc) {
    let sig = format_fn_signature(f);
    let rule_len = sig.len().max(20);

    println!();
    println!("  {}", bold(&sig));
    println!("  {}", dim(&"\u{2500}".repeat(rule_len)));

    if !f.doc.is_empty() {
        println!();
        for line in f.doc.lines() {
            println!("  {}", line);
        }
    }

    println!();
    println!(
        "  {} {}:{}",
        dim("Defined in"),
        f.file,
        f.line
    );
    if f.exported {
        println!("  {}", dim("Exported"));
    }
    println!();
}

fn show_type_detail(t: &TypeDocEntry) {
    let header = format!("{} {}", t.kind, t.name);
    let rule_len = header.len().max(20);

    println!();
    println!("  {}", bold(&header));
    println!("  {}", dim(&"\u{2500}".repeat(rule_len)));

    if !t.doc.is_empty() {
        println!();
        for line in t.doc.lines() {
            println!("  {}", line);
        }
    }

    println!();
    println!(
        "  {} {}:{}",
        dim("Defined in"),
        t.file,
        t.line
    );
    if t.exported {
        println!("  {}", dim("Exported"));
    }
    println!();
}

fn show_enum_detail(e: &EnumDoc) {
    let header = format!("enum {}", e.name);
    let rule_len = header.len().max(20);

    println!();
    println!("  {}", bold(&header));
    println!("  {}", dim(&"\u{2500}".repeat(rule_len)));

    if !e.doc.is_empty() {
        println!();
        for line in e.doc.lines() {
            println!("  {}", line);
        }
    }

    if !e.variants.is_empty() {
        println!();
        println!("  {}", bold("Variants"));
        for v in &e.variants {
            println!("    {}", v);
        }
    }

    println!();
    println!(
        "  {} {}:{}",
        dim("Defined in"),
        e.file,
        e.line
    );
    if e.exported {
        println!("  {}", dim("Exported"));
    }
    println!();
}

fn show_var_detail(c: &VarDoc) {
    let sig = if let Some(ref t) = c.type_ann {
        format!("{} {}: {}", c.kind, c.name, t)
    } else {
        format!("{} {}", c.kind, c.name)
    };
    let rule_len = sig.len().max(20);

    println!();
    println!("  {}", bold(&sig));
    println!("  {}", dim(&"\u{2500}".repeat(rule_len)));

    if !c.doc.is_empty() {
        println!();
        for line in c.doc.lines() {
            println!("  {}", line);
        }
    }

    println!();
    println!(
        "  {} {}:{}",
        dim("Defined in"),
        c.file,
        c.line
    );
    if c.exported {
        println!("  {}", dim("Exported"));
    }
    println!();
}

// ── Validation ──────────────────────────────────────────────────────

fn green(s: &str) -> String {
    format!("\x1b[32m{}\x1b[0m", s)
}

fn red(s: &str) -> String {
    format!("\x1b[31m{}\x1b[0m", s)
}

/// Validate documentation coverage for a project directory.
///
/// Scans all .fg files, extracts symbols, and reports how many have
/// doc comments vs how many are undocumented.
pub fn validate_docs(dir: &str) {
    let path = std::path::Path::new(dir);
    let files = find_fg_files(path);
    let docs = extract_project_docs(path);

    println!();
    println!("  {}", bold("Project Documentation Coverage"));
    println!("  {}", dim(&"\u{2500}".repeat(30)));

    println!();
    println!("  Files scanned: {}", files.len());
    println!("  Symbols found: {}", docs.total_symbols());

    // ── Functions ───────────────────────────────────────────────────
    if !docs.functions.is_empty() {
        let total = docs.functions.len();
        let documented = docs.functions.iter().filter(|f| !f.doc.is_empty()).count();
        let undoc: Vec<&str> = docs.functions.iter()
            .filter(|f| f.doc.is_empty())
            .map(|f| f.name.as_str())
            .collect();
        let pct = if total > 0 { documented * 100 / total } else { 0 };

        println!();
        println!("  {}: {} total", bold("Functions"), total);
        println!("    {} documented: {} ({}%)", green("\u{2713}"), documented, pct);
        if !undoc.is_empty() {
            println!("    {} undocumented: {}", red("\u{2717}"), undoc.join(", "));
        }
    }

    // ── Types ───────────────────────────────────────────────────────
    if !docs.types.is_empty() {
        let total = docs.types.len();
        let documented = docs.types.iter().filter(|t| !t.doc.is_empty()).count();
        let undoc: Vec<&str> = docs.types.iter()
            .filter(|t| t.doc.is_empty())
            .map(|t| t.name.as_str())
            .collect();
        let pct = if total > 0 { documented * 100 / total } else { 0 };

        println!();
        println!("  {}: {} total", bold("Types"), total);
        println!("    {} documented: {} ({}%)", green("\u{2713}"), documented, pct);
        if !undoc.is_empty() {
            println!("    {} undocumented: {}", red("\u{2717}"), undoc.join(", "));
        }
    }

    // ── Enums ───────────────────────────────────────────────────────
    if !docs.enums.is_empty() {
        let total = docs.enums.len();
        let documented = docs.enums.iter().filter(|e| !e.doc.is_empty()).count();
        let undoc: Vec<&str> = docs.enums.iter()
            .filter(|e| e.doc.is_empty())
            .map(|e| e.name.as_str())
            .collect();
        let pct = if total > 0 { documented * 100 / total } else { 0 };

        println!();
        println!("  {}: {} total", bold("Enums"), total);
        println!("    {} documented: {} ({}%)", green("\u{2713}"), documented, pct);
        if !undoc.is_empty() {
            println!("    {} undocumented: {}", red("\u{2717}"), undoc.join(", "));
        }
    }

    // ── Constants ───────────────────────────────────────────────────
    if !docs.constants.is_empty() {
        let total = docs.constants.len();
        let documented = docs.constants.iter().filter(|c| !c.doc.is_empty()).count();
        let undoc: Vec<&str> = docs.constants.iter()
            .filter(|c| c.doc.is_empty())
            .map(|c| c.name.as_str())
            .collect();
        let pct = if total > 0 { documented * 100 / total } else { 0 };

        println!();
        println!("  {}: {} total", bold("Constants"), total);
        println!("    {} documented: {} ({}%)", green("\u{2713}"), documented, pct);
        if !undoc.is_empty() {
            println!("    {} undocumented: {}", red("\u{2717}"), undoc.join(", "));
        }
    }

    // ── Summary ─────────────────────────────────────────────────────
    let total = docs.total_symbols();
    let documented = docs.documented_count();
    let undocumented = total - documented;
    let pct = if total > 0 { documented * 100 / total } else { 100 };

    println!();
    println!("  {}", bold("Summary"));
    println!(
        "    {:<16} {}/{} symbols ({}%)",
        "Documented:", documented, total, pct
    );
    if undocumented > 0 {
        println!(
            "    {:<16} {} symbols",
            "Undocumented:", undocumented
        );
    }
    println!();
}

// ── Helpers ─────────────────────────────────────────────────────────

fn format_fn_signature(f: &FnDoc) -> String {
    let params: Vec<String> = f
        .params
        .iter()
        .map(|(name, ty)| {
            if ty.is_empty() {
                name.clone()
            } else {
                format!("{}: {}", name, ty)
            }
        })
        .collect();

    let params_str = params.join(", ");

    match &f.return_type {
        Some(ret) => format!("fn {}({}) -> {}", f.name, params_str, ret),
        None => format!("fn {}({})", f.name, params_str),
    }
}

fn first_line_or_empty(doc: &str) -> String {
    doc.lines().next().unwrap_or("").to_string()
}

fn truncate(s: &str, max: usize) -> String {
    if s.len() > max {
        format!("{}...", &s[..max.saturating_sub(3)])
    } else {
        s.to_string()
    }
}
