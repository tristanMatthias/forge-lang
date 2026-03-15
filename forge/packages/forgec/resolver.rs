/// Dependency resolution engine for Forge projects.
///
/// Reads `[dependencies]` from forge.toml, resolves versions using semver
/// range matching, detects conflicts and cycles, and produces a resolved
/// dependency graph.

use std::collections::{HashMap, HashSet};

use crate::errors::CompileError;

// ── Public types ────────────────────────────────────────────────────

/// A resolved dependency with an exact version.
#[derive(Debug, Clone)]
pub struct ResolvedDep {
    pub name: String,
    pub version: String,
    pub source: DepSource,
    pub dependencies: Vec<String>,
    pub capabilities: Vec<String>,
}

/// Where a dependency comes from.
#[derive(Debug, Clone)]
pub enum DepSource {
    Registry,
    Git { url: String, rev: String },
    Path { path: String },
}

/// The full resolved dependency graph.
#[derive(Debug)]
pub struct ResolvedGraph {
    pub packages: HashMap<String, ResolvedDep>,
    pub root_deps: Vec<String>,
}

/// Available versions for a package (from registry/cache/local).
#[derive(Debug, Clone)]
pub struct PackageVersions {
    pub name: String,
    pub versions: Vec<String>,
    /// Dependencies declared by each version: version -> (dep_name -> range).
    pub version_deps: HashMap<String, HashMap<String, String>>,
}

// ── Semver version parsing ──────────────────────────────────────────

/// A parsed semantic version (major.minor.patch with optional pre-release).
#[derive(Debug, Clone, Eq, PartialEq)]
struct SemVer {
    major: u64,
    minor: u64,
    patch: u64,
    pre: String,
}

impl SemVer {
    fn parse(s: &str) -> Result<Self, String> {
        let s = s.trim();
        // Split off pre-release: 1.2.3-beta.1
        let (version_part, pre) = if let Some(idx) = s.find('-') {
            (&s[..idx], s[idx + 1..].to_string())
        } else {
            (s, String::new())
        };

        let parts: Vec<&str> = version_part.split('.').collect();
        if parts.len() != 3 {
            return Err(format!("invalid semver: '{}' (expected MAJOR.MINOR.PATCH)", s));
        }

        let major = parts[0].parse::<u64>()
            .map_err(|_| format!("invalid major version in '{}'", s))?;
        let minor = parts[1].parse::<u64>()
            .map_err(|_| format!("invalid minor version in '{}'", s))?;
        let patch = parts[2].parse::<u64>()
            .map_err(|_| format!("invalid patch version in '{}'", s))?;

        Ok(SemVer { major, minor, patch, pre })
    }

    fn is_prerelease(&self) -> bool {
        !self.pre.is_empty()
    }
}

impl Ord for SemVer {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        self.major.cmp(&other.major)
            .then(self.minor.cmp(&other.minor))
            .then(self.patch.cmp(&other.patch))
            .then_with(|| {
                // No pre-release > any pre-release
                match (self.pre.is_empty(), other.pre.is_empty()) {
                    (true, true) => std::cmp::Ordering::Equal,
                    (true, false) => std::cmp::Ordering::Greater,
                    (false, true) => std::cmp::Ordering::Less,
                    (false, false) => self.pre.cmp(&other.pre),
                }
            })
    }
}

impl PartialOrd for SemVer {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.cmp(other))
    }
}

impl std::fmt::Display for SemVer {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        if self.pre.is_empty() {
            write!(f, "{}.{}.{}", self.major, self.minor, self.patch)
        } else {
            write!(f, "{}.{}.{}-{}", self.major, self.minor, self.patch, self.pre)
        }
    }
}

// ── Version requirement (range) ─────────────────────────────────────

/// A single comparator: an operator + a version.
#[derive(Debug, Clone)]
enum Comparator {
    /// `=1.0.0` or bare `1.0.0`
    Exact(SemVer),
    /// `^1.0.0` — compatible: >=1.0.0, <2.0.0 (or special rules for 0.x)
    Caret(SemVer),
    /// `~1.0.0` — patch-level: >=1.0.0, <1.1.0
    Tilde(SemVer),
    /// `>=1.0.0`
    Gte(SemVer),
    /// `>1.0.0`
    Gt(SemVer),
    /// `<=1.0.0`
    Lte(SemVer),
    /// `<1.0.0`
    Lt(SemVer),
    /// `*` — any version
    Wildcard,
}

/// A version requirement that may contain multiple comma-separated comparators.
#[derive(Debug, Clone)]
pub struct VersionReq {
    pub raw: String,
    comparators: Vec<Comparator>,
}

impl VersionReq {
    /// Parse a version range string.
    ///
    /// Supported formats:
    /// - `"1.0.0"` — exact match
    /// - `"^1.0.0"` — compatible (caret)
    /// - `"~1.0.0"` — patch-level (tilde)
    /// - `">=1.0.0"` — minimum
    /// - `">1.0.0"` — greater than
    /// - `"<=1.0.0"` — at most
    /// - `"<1.0.0"` — less than
    /// - `">=1.0.0, <3.0.0"` — compound range
    /// - `"*"` — any version
    pub fn parse(s: &str) -> Result<Self, String> {
        let raw = s.trim().to_string();
        if raw.is_empty() {
            return Err("empty version range".to_string());
        }

        let mut comparators = Vec::new();
        for part in raw.split(',') {
            let part = part.trim();
            if part.is_empty() {
                continue;
            }
            comparators.push(parse_comparator(part)?);
        }

        if comparators.is_empty() {
            return Err(format!("no valid comparators in '{}'", s));
        }

        Ok(VersionReq { raw, comparators })
    }

    /// Check whether a concrete version string satisfies this requirement.
    pub fn matches(&self, version: &str) -> bool {
        let ver = match SemVer::parse(version) {
            Ok(v) => v,
            Err(_) => return false,
        };
        self.comparators.iter().all(|c| comparator_matches(c, &ver))
    }
}

fn parse_comparator(s: &str) -> Result<Comparator, String> {
    let s = s.trim();
    if s == "*" {
        return Ok(Comparator::Wildcard);
    }

    if let Some(rest) = s.strip_prefix(">=") {
        return Ok(Comparator::Gte(SemVer::parse(rest.trim())?));
    }
    if let Some(rest) = s.strip_prefix('>') {
        return Ok(Comparator::Gt(SemVer::parse(rest.trim())?));
    }
    if let Some(rest) = s.strip_prefix("<=") {
        return Ok(Comparator::Lte(SemVer::parse(rest.trim())?));
    }
    if let Some(rest) = s.strip_prefix('<') {
        return Ok(Comparator::Lt(SemVer::parse(rest.trim())?));
    }
    if let Some(rest) = s.strip_prefix('~') {
        return Ok(Comparator::Tilde(SemVer::parse(rest.trim())?));
    }
    if let Some(rest) = s.strip_prefix('^') {
        return Ok(Comparator::Caret(SemVer::parse(rest.trim())?));
    }
    if let Some(rest) = s.strip_prefix('=') {
        return Ok(Comparator::Exact(SemVer::parse(rest.trim())?));
    }

    // Bare version: treat as caret (like Cargo does)
    Ok(Comparator::Caret(SemVer::parse(s)?))
}

fn comparator_matches(comp: &Comparator, ver: &SemVer) -> bool {
    match comp {
        Comparator::Wildcard => true,

        Comparator::Exact(req) => ver == req,

        Comparator::Gte(req) => ver >= req,
        Comparator::Gt(req) => ver > req,
        Comparator::Lte(req) => ver <= req,
        Comparator::Lt(req) => ver < req,

        Comparator::Caret(req) => {
            if ver < req {
                return false;
            }
            // Pre-release versions only match if same major.minor.patch
            if ver.is_prerelease() && (ver.major, ver.minor, ver.patch) != (req.major, req.minor, req.patch) {
                return false;
            }
            // ^1.2.3 => >=1.2.3, <2.0.0
            // ^0.2.3 => >=0.2.3, <0.3.0
            // ^0.0.3 => >=0.0.3, <0.0.4
            if req.major != 0 {
                ver.major == req.major
            } else if req.minor != 0 {
                ver.major == 0 && ver.minor == req.minor
            } else {
                ver.major == 0 && ver.minor == 0 && ver.patch == req.patch
            }
        }

        Comparator::Tilde(req) => {
            if ver < req {
                return false;
            }
            // ~1.2.3 => >=1.2.3, <1.3.0
            ver.major == req.major && ver.minor == req.minor
        }
    }
}

// ── Resolution engine ───────────────────────────────────────────────

/// Resolve all dependencies from a set of direct dependency declarations.
///
/// `direct_deps` maps package name to version range string (from forge.toml).
/// `available` is a callback that returns known versions for a package name.
pub fn resolve(
    direct_deps: &HashMap<String, String>,
    available: &dyn Fn(&str) -> Option<PackageVersions>,
) -> Result<ResolvedGraph, CompileError> {
    let mut resolved: HashMap<String, ResolvedDep> = HashMap::new();
    let mut stack: Vec<String> = Vec::new(); // cycle detection
    let root_deps: Vec<String> = direct_deps.keys().cloned().collect();

    for (name, range_str) in direct_deps {
        resolve_one(
            name,
            range_str,
            "<root>",
            available,
            &mut resolved,
            &mut stack,
        )?;
    }

    Ok(ResolvedGraph {
        packages: resolved,
        root_deps,
    })
}

fn resolve_one(
    name: &str,
    range_str: &str,
    requester: &str,
    available: &dyn Fn(&str) -> Option<PackageVersions>,
    resolved: &mut HashMap<String, ResolvedDep>,
    stack: &mut Vec<String>,
) -> Result<(), CompileError> {
    // Cycle detection
    if stack.contains(&name.to_string()) {
        let mut chain: Vec<String> = stack.clone();
        chain.push(name.to_string());
        return Err(CompileError::CircularDependency { chain });
    }

    let req = VersionReq::parse(range_str).map_err(|e| CompileError::VersionRangeUnsatisfiable {
        package: name.to_string(),
        range: range_str.to_string(),
        available: vec![format!("(parse error: {})", e)],
    })?;

    // If already resolved, check compatibility
    if let Some(existing) = resolved.get(name) {
        if req.matches(&existing.version) {
            return Ok(());
        }
        // Conflict: the already-resolved version doesn't satisfy this range
        return Err(CompileError::DependencyConflict {
            dependency: name.to_string(),
            requesters: vec![
                (requester.to_string(), range_str.to_string()),
                ("(previously resolved)".to_string(), existing.version.clone()),
            ],
        });
    }

    // Query available versions
    let pkg_versions = available(name).ok_or_else(|| CompileError::DependencyNotFound {
        name: name.to_string(),
        detail: format!("no versions found for '{}' (required by {})", name, requester),
    })?;

    // Find the newest version that satisfies the range
    let mut candidates: Vec<SemVer> = pkg_versions
        .versions
        .iter()
        .filter(|v| req.matches(v))
        .filter_map(|v| SemVer::parse(v).ok())
        .collect();

    candidates.sort();

    let best = candidates.last().ok_or_else(|| {
        CompileError::VersionRangeUnsatisfiable {
            package: name.to_string(),
            range: range_str.to_string(),
            available: pkg_versions.versions.clone(),
        }
    })?;

    let best_str = best.to_string();

    // Get transitive deps for this version
    let trans_deps = pkg_versions
        .version_deps
        .get(&best_str)
        .cloned()
        .unwrap_or_default();

    let dep_names: Vec<String> = trans_deps.keys().cloned().collect();

    // Insert into resolved *before* recursing so cycles are detected
    resolved.insert(
        name.to_string(),
        ResolvedDep {
            name: name.to_string(),
            version: best_str.clone(),
            source: DepSource::Registry,
            dependencies: dep_names.clone(),
            capabilities: Vec::new(),
        },
    );

    // Resolve transitive dependencies
    stack.push(name.to_string());
    for (dep_name, dep_range) in &trans_deps {
        resolve_one(dep_name, dep_range, name, available, resolved, stack)?;
    }
    stack.pop();

    Ok(())
}

// ── Dependency tree display ─────────────────────────────────────────

/// Format the dependency tree as a printable string.
///
/// ```text
/// my-project v1.0.0
/// +-- @std/http v0.1.0
/// \-- http-client v1.0.0
///     \-- @std/http v0.1.0 (*)
/// ```
pub fn format_dep_tree(graph: &ResolvedGraph, project_name: &str, project_version: &str) -> String {
    let mut out = String::new();
    out.push_str(&format!("{} v{}\n", project_name, project_version));

    let mut sorted_deps = graph.root_deps.clone();
    sorted_deps.sort();

    let count = sorted_deps.len();
    let mut seen = HashSet::new();

    for (i, name) in sorted_deps.iter().enumerate() {
        let is_last = i == count - 1;
        format_dep_node(graph, name, &mut out, "", is_last, &mut seen);
    }

    out
}

fn format_dep_node(
    graph: &ResolvedGraph,
    name: &str,
    out: &mut String,
    prefix: &str,
    is_last: bool,
    seen: &mut HashSet<String>,
) {
    let connector = if is_last { "\\-- " } else { "+-- " };

    if let Some(dep) = graph.packages.get(name) {
        let already_shown = seen.contains(name);
        let dedup_marker = if already_shown { " (*)" } else { "" };

        out.push_str(&format!(
            "{}{}{} v{}{}\n",
            prefix, connector, dep.name, dep.version, dedup_marker
        ));

        if already_shown {
            return;
        }
        seen.insert(name.to_string());

        let child_prefix = if is_last {
            format!("{}    ", prefix)
        } else {
            format!("{}|   ", prefix)
        };

        let mut sorted_children = dep.dependencies.clone();
        sorted_children.sort();
        let child_count = sorted_children.len();

        for (j, child_name) in sorted_children.iter().enumerate() {
            let child_is_last = j == child_count - 1;
            format_dep_node(graph, child_name, out, &child_prefix, child_is_last, seen);
        }
    } else {
        out.push_str(&format!("{}{}{} (unresolved)\n", prefix, connector, name));
    }
}

/// Format a flat list of resolved dependencies.
pub fn format_dep_flat(graph: &ResolvedGraph) -> String {
    let mut out = String::new();
    let mut sorted: Vec<&ResolvedDep> = graph.packages.values().collect();
    sorted.sort_by(|a, b| a.name.cmp(&b.name));

    for dep in sorted {
        let source_tag = match &dep.source {
            DepSource::Registry => String::new(),
            DepSource::Git { url, rev } => format!(" (git: {}@{})", url, &rev[..7.min(rev.len())]),
            DepSource::Path { path } => format!(" (path: {})", path),
        };
        out.push_str(&format!("{} v{}{}\n", dep.name, dep.version, source_tag));
    }

    out
}

// ── Local package scanner ───────────────────────────────────────────

/// Scan the `packages/` directory to build a lookup of available package
/// versions. This serves as the default `available` callback until a real
/// registry is wired up.
///
/// Returns a map from package name to `PackageVersions` by scanning all
/// subdirectories that contain a `package.toml`.
pub fn scan_local_packages(packages_dir: &std::path::Path) -> HashMap<String, PackageVersions> {
    let mut result = HashMap::new();

    let entries = match std::fs::read_dir(packages_dir) {
        Ok(e) => e,
        Err(_) => return result,
    };

    for entry in entries.flatten() {
        let path = entry.path();
        if !path.is_dir() {
            continue;
        }
        let toml_path = path.join("package.toml");
        if !toml_path.exists() {
            continue;
        }

        let toml_content = match std::fs::read_to_string(&toml_path) {
            Ok(c) => c,
            Err(_) => continue,
        };
        let config: toml::Value = match toml::from_str(&toml_content) {
            Ok(c) => c,
            Err(_) => continue,
        };

        let pkg_name = config
            .get("package")
            .and_then(|p| p.get("name"))
            .and_then(|v| v.as_str())
            .unwrap_or("")
            .to_string();
        let namespace = config
            .get("package")
            .and_then(|p| p.get("namespace"))
            .and_then(|v| v.as_str())
            .unwrap_or("")
            .to_string();
        let version = config
            .get("package")
            .and_then(|p| p.get("version"))
            .and_then(|v| v.as_str())
            .unwrap_or("0.0.0")
            .to_string();

        // Read deps from this package's package.toml
        let deps: HashMap<String, String> = config
            .get("dependencies")
            .and_then(|d| d.as_table())
            .map(|t| {
                t.iter()
                    .filter_map(|(k, v)| v.as_str().map(|s| (k.clone(), s.to_string())))
                    .collect()
            })
            .unwrap_or_default();

        let mut version_deps = HashMap::new();
        version_deps.insert(version.clone(), deps);

        // Register under multiple keys so lookups work with different naming styles
        let dir_name = path.file_name().and_then(|n| n.to_str()).unwrap_or("").to_string();
        let qualified = format!("@{}/{}", namespace, pkg_name);

        let pv = PackageVersions {
            name: dir_name.clone(),
            versions: vec![version],
            version_deps,
        };

        // dir name (e.g., "std-http")
        result.insert(dir_name.clone(), pv.clone());
        // qualified name (e.g., "@std/http")
        result.insert(qualified, pv.clone());
        // bare package name (e.g., "http")
        if !pkg_name.is_empty() {
            result.insert(pkg_name, pv);
        }
    }

    result
}

// ── Tests ───────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    // -- VersionReq parsing --

    #[test]
    fn test_exact_match() {
        let req = VersionReq::parse("=1.2.3").unwrap();
        assert!(req.matches("1.2.3"));
        assert!(!req.matches("1.2.4"));
        assert!(!req.matches("1.3.0"));
    }

    #[test]
    fn test_caret_range() {
        let req = VersionReq::parse("^1.2.3").unwrap();
        assert!(req.matches("1.2.3"));
        assert!(req.matches("1.9.0"));
        assert!(!req.matches("2.0.0"));
        assert!(!req.matches("1.2.2"));
    }

    #[test]
    fn test_caret_zero_major() {
        let req = VersionReq::parse("^0.2.3").unwrap();
        assert!(req.matches("0.2.3"));
        assert!(req.matches("0.2.9"));
        assert!(!req.matches("0.3.0"));
        assert!(!req.matches("1.0.0"));
    }

    #[test]
    fn test_caret_zero_minor() {
        let req = VersionReq::parse("^0.0.3").unwrap();
        assert!(req.matches("0.0.3"));
        assert!(!req.matches("0.0.4"));
        assert!(!req.matches("0.1.0"));
    }

    #[test]
    fn test_tilde_range() {
        let req = VersionReq::parse("~1.2.3").unwrap();
        assert!(req.matches("1.2.3"));
        assert!(req.matches("1.2.9"));
        assert!(!req.matches("1.3.0"));
        assert!(!req.matches("1.2.2"));
    }

    #[test]
    fn test_gte() {
        let req = VersionReq::parse(">=1.0.0").unwrap();
        assert!(req.matches("1.0.0"));
        assert!(req.matches("2.5.0"));
        assert!(!req.matches("0.9.9"));
    }

    #[test]
    fn test_compound_range() {
        let req = VersionReq::parse(">=1.0.0, <3.0.0").unwrap();
        assert!(req.matches("1.0.0"));
        assert!(req.matches("2.9.9"));
        assert!(!req.matches("3.0.0"));
        assert!(!req.matches("0.9.0"));
    }

    #[test]
    fn test_bare_version_is_caret() {
        // Bare "1.2.3" should behave like "^1.2.3"
        let req = VersionReq::parse("1.2.3").unwrap();
        assert!(req.matches("1.2.3"));
        assert!(req.matches("1.9.0"));
        assert!(!req.matches("2.0.0"));
    }

    #[test]
    fn test_wildcard() {
        let req = VersionReq::parse("*").unwrap();
        assert!(req.matches("0.0.1"));
        assert!(req.matches("99.99.99"));
    }

    // -- Resolution --

    fn make_available() -> impl Fn(&str) -> Option<PackageVersions> {
        |name: &str| -> Option<PackageVersions> {
            match name {
                "alpha" => Some(PackageVersions {
                    name: "alpha".into(),
                    versions: vec!["1.0.0".into(), "1.1.0".into(), "2.0.0".into()],
                    version_deps: HashMap::new(),
                }),
                "beta" => {
                    let mut vd = HashMap::new();
                    vd.insert(
                        "1.0.0".into(),
                        [("alpha".into(), "^1.0.0".into())].into_iter().collect(),
                    );
                    Some(PackageVersions {
                        name: "beta".into(),
                        versions: vec!["1.0.0".into()],
                        version_deps: vd,
                    })
                }
                _ => None,
            }
        }
    }

    #[test]
    fn test_resolve_direct() {
        let deps: HashMap<String, String> =
            [("alpha".into(), "^1.0.0".into())].into_iter().collect();
        let graph = resolve(&deps, &make_available()).unwrap();
        assert_eq!(graph.packages.len(), 1);
        assert_eq!(graph.packages["alpha"].version, "1.1.0");
    }

    #[test]
    fn test_resolve_transitive() {
        let deps: HashMap<String, String> =
            [("beta".into(), "^1.0.0".into())].into_iter().collect();
        let graph = resolve(&deps, &make_available()).unwrap();
        assert_eq!(graph.packages.len(), 2);
        assert!(graph.packages.contains_key("alpha"));
        assert!(graph.packages.contains_key("beta"));
    }

    #[test]
    fn test_resolve_not_found() {
        let deps: HashMap<String, String> =
            [("nonexistent".into(), "^1.0.0".into())].into_iter().collect();
        let result = resolve(&deps, &make_available());
        assert!(matches!(result, Err(CompileError::DependencyNotFound { .. })));
    }

    #[test]
    fn test_resolve_no_matching_version() {
        let deps: HashMap<String, String> =
            [("alpha".into(), "^5.0.0".into())].into_iter().collect();
        let result = resolve(&deps, &make_available());
        assert!(matches!(result, Err(CompileError::VersionRangeUnsatisfiable { .. })));
    }

    #[test]
    fn test_resolve_conflict() {
        // alpha is already resolved at 1.1.0 (from ^1.0.0), then someone requires =2.0.0
        let available = |name: &str| -> Option<PackageVersions> {
            match name {
                "alpha" => Some(PackageVersions {
                    name: "alpha".into(),
                    versions: vec!["1.1.0".into(), "2.0.0".into()],
                    version_deps: HashMap::new(),
                }),
                "gamma" => {
                    let mut vd = HashMap::new();
                    vd.insert(
                        "1.0.0".into(),
                        [("alpha".into(), "=2.0.0".into())].into_iter().collect(),
                    );
                    Some(PackageVersions {
                        name: "gamma".into(),
                        versions: vec!["1.0.0".into()],
                        version_deps: vd,
                    })
                }
                _ => None,
            }
        };

        let deps: HashMap<String, String> = [
            ("alpha".into(), "^1.0.0".into()),
            ("gamma".into(), "^1.0.0".into()),
        ]
        .into_iter()
        .collect();

        let result = resolve(&deps, &available);
        assert!(matches!(result, Err(CompileError::DependencyConflict { .. })));
    }

    #[test]
    fn test_resolve_cycle() {
        let available = |name: &str| -> Option<PackageVersions> {
            match name {
                "a" => {
                    let mut vd = HashMap::new();
                    vd.insert(
                        "1.0.0".into(),
                        [("b".into(), "^1.0.0".into())].into_iter().collect(),
                    );
                    Some(PackageVersions {
                        name: "a".into(),
                        versions: vec!["1.0.0".into()],
                        version_deps: vd,
                    })
                }
                "b" => {
                    let mut vd = HashMap::new();
                    vd.insert(
                        "1.0.0".into(),
                        [("a".into(), "^1.0.0".into())].into_iter().collect(),
                    );
                    Some(PackageVersions {
                        name: "b".into(),
                        versions: vec!["1.0.0".into()],
                        version_deps: vd,
                    })
                }
                _ => None,
            }
        };

        let deps: HashMap<String, String> =
            [("a".into(), "^1.0.0".into())].into_iter().collect();
        let result = resolve(&deps, &available);
        assert!(matches!(result, Err(CompileError::CircularDependency { .. })));
    }

    // -- Tree display --

    #[test]
    fn test_format_dep_tree() {
        let mut packages = HashMap::new();
        packages.insert("http".into(), ResolvedDep {
            name: "http".into(),
            version: "0.1.0".into(),
            source: DepSource::Registry,
            dependencies: vec![],
            capabilities: vec![],
        });
        packages.insert("graphql".into(), ResolvedDep {
            name: "graphql".into(),
            version: "3.1.0".into(),
            source: DepSource::Registry,
            dependencies: vec!["http".into()],
            capabilities: vec![],
        });

        let graph = ResolvedGraph {
            packages,
            root_deps: vec!["graphql".into(), "http".into()],
        };

        let tree = format_dep_tree(&graph, "my-project", "1.0.0");
        assert!(tree.contains("my-project v1.0.0"));
        assert!(tree.contains("graphql v3.1.0"));
        assert!(tree.contains("http v0.1.0"));
    }
}
