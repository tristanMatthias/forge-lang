/// Package naming and namespace validation for the Forge package registry.
///
/// Enforces naming rules for package names, organization names, and scoped
/// package references (e.g., `@std/http`, `@acme/auth`, `graphql`).

/// Validate a package name against Forge naming rules.
/// Returns Ok(()) if valid, Err with descriptive message if not.
pub fn validate_package_name(name: &str) -> Result<(), String> {
    if name.is_empty() {
        return Err("package name cannot be empty".to_string());
    }
    if name.len() > 64 {
        return Err(format!(
            "package name too long ({} chars, max 64)",
            name.len()
        ));
    }
    if !name.starts_with(|c: char| c.is_ascii_lowercase()) {
        return Err("package name must start with a lowercase letter".to_string());
    }
    if !name
        .chars()
        .all(|c| c.is_ascii_lowercase() || c.is_ascii_digit() || c == '-' || c == '_')
    {
        return Err(
            "package name may only contain lowercase letters, digits, hyphens, and underscores"
                .to_string(),
        );
    }
    if name.ends_with('-') || name.ends_with('_') {
        return Err("package name must not end with a hyphen or underscore".to_string());
    }
    if name.contains("--") || name.contains("__") {
        return Err("package name must not contain consecutive hyphens or underscores".to_string());
    }
    if is_reserved_name(name) {
        return Err(format!("'{}' is a reserved package name", name));
    }
    Ok(())
}

/// Validate an organization name.
pub fn validate_org_name(name: &str) -> Result<(), String> {
    if name.is_empty() {
        return Err("organization name cannot be empty".to_string());
    }
    if name.len() > 32 {
        return Err(format!(
            "organization name too long ({} chars, max 32)",
            name.len()
        ));
    }
    if !name.starts_with(|c: char| c.is_ascii_lowercase()) {
        return Err("organization name must start with a lowercase letter".to_string());
    }
    if !name
        .chars()
        .all(|c| c.is_ascii_lowercase() || c.is_ascii_digit() || c == '-' || c == '_')
    {
        return Err(
            "organization name may only contain lowercase letters, digits, hyphens, and underscores"
                .to_string(),
        );
    }
    if name == "std" {
        return Err("'std' is reserved for the standard library".to_string());
    }
    Ok(())
}

/// Validate a full package reference (e.g., "@std/http", "@acme/auth", "graphql").
pub fn validate_package_ref(reference: &str) -> Result<PackageRef, String> {
    if reference.starts_with('@') {
        // Scoped: @namespace/name
        let rest = &reference[1..];
        let parts: Vec<&str> = rest.splitn(2, '/').collect();
        if parts.len() != 2 {
            return Err(format!(
                "invalid scoped package reference '{}': expected @namespace/name",
                reference
            ));
        }
        let namespace = parts[0];
        let name = parts[1];
        // For scoped refs, allow "std" as the namespace (it's the standard library scope)
        if namespace != "std" {
            validate_org_name(namespace)?;
        }
        validate_package_name(name)?;
        Ok(PackageRef::Scoped {
            namespace: namespace.to_string(),
            name: name.to_string(),
        })
    } else {
        validate_package_name(reference)?;
        Ok(PackageRef::Community {
            name: reference.to_string(),
        })
    }
}

/// A parsed package reference — either scoped (@namespace/name) or community (plain name).
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum PackageRef {
    Scoped { namespace: String, name: String },
    Community { name: String },
}

impl PackageRef {
    /// Full display name (e.g., "@std/http" or "graphql").
    pub fn display_name(&self) -> String {
        match self {
            PackageRef::Scoped { namespace, name } => format!("@{}/{}", namespace, name),
            PackageRef::Community { name } => name.clone(),
        }
    }

    /// Namespace portion ("std", "acme", or "community" for unscoped).
    pub fn namespace(&self) -> &str {
        match self {
            PackageRef::Scoped { namespace, .. } => namespace,
            PackageRef::Community { .. } => "community",
        }
    }

    /// Package name without namespace.
    pub fn name(&self) -> &str {
        match self {
            PackageRef::Scoped { name, .. } => name,
            PackageRef::Community { name } => name,
        }
    }
}

impl std::fmt::Display for PackageRef {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.display_name())
    }
}

/// Check if a name is reserved (Forge builtins, common confusing names).
fn is_reserved_name(name: &str) -> bool {
    matches!(
        name,
        "forge"
            | "std"
            | "core"
            | "self"
            | "super"
            | "crate"
            | "test"
            | "main"
            | "lib"
            | "bin"
            | "build"
            | "true"
            | "false"
            | "null"
            | "nil"
            | "none"
            | "if"
            | "else"
            | "for"
            | "while"
            | "fn"
            | "let"
            | "mut"
            | "return"
            | "import"
            | "export"
            | "type"
            | "enum"
            | "struct"
            | "trait"
            | "impl"
            | "match"
            | "use"
            | "mod"
            | "pub"
    )
}

/// Basic typosquatting detection: check if a name is too similar to popular packages.
///
/// Returns `Some(warning)` if the name looks suspiciously similar to one of the
/// `existing_popular` package names.
pub fn check_typosquat(name: &str, existing_popular: &[&str]) -> Option<String> {
    for &popular in existing_popular {
        if name == popular {
            continue;
        }
        let dist = levenshtein_distance(name, popular);
        if dist <= 1 && name.len() > 3 {
            return Some(format!(
                "name '{}' is very similar to popular package '{}' (edit distance: {})",
                name, popular, dist
            ));
        }
        // Check for common substitutions: - vs _, doubled letters
        let normalized_name = name.replace('-', "").replace('_', "");
        let normalized_popular = popular.replace('-', "").replace('_', "");
        if normalized_name == normalized_popular && name != popular {
            return Some(format!(
                "name '{}' is confusingly similar to '{}' (same after removing separators)",
                name, popular
            ));
        }
    }
    None
}

/// Simple Levenshtein distance implementation.
fn levenshtein_distance(a: &str, b: &str) -> usize {
    let a_len = a.len();
    let b_len = b.len();

    if a_len == 0 {
        return b_len;
    }
    if b_len == 0 {
        return a_len;
    }

    // Use a single-row approach for space efficiency.
    let mut prev_row: Vec<usize> = (0..=b_len).collect();
    let mut curr_row = vec![0; b_len + 1];

    for (i, a_char) in a.chars().enumerate() {
        curr_row[0] = i + 1;
        for (j, b_char) in b.chars().enumerate() {
            let cost = if a_char == b_char { 0 } else { 1 };
            curr_row[j + 1] = (prev_row[j + 1] + 1)
                .min(curr_row[j] + 1)
                .min(prev_row[j] + cost);
        }
        std::mem::swap(&mut prev_row, &mut curr_row);
    }

    prev_row[b_len]
}

#[cfg(test)]
mod tests {
    use super::*;

    // ── validate_package_name ───────────────────────────────────────

    #[test]
    fn valid_package_names() {
        assert!(validate_package_name("http").is_ok());
        assert!(validate_package_name("my-package").is_ok());
        assert!(validate_package_name("my_package").is_ok());
        assert!(validate_package_name("a123").is_ok());
        assert!(validate_package_name("x").is_ok());
        assert!(validate_package_name("json-parser2").is_ok());
    }

    #[test]
    fn empty_package_name() {
        let err = validate_package_name("").unwrap_err();
        assert!(err.contains("cannot be empty"));
    }

    #[test]
    fn too_long_package_name() {
        let long = "a".repeat(65);
        let err = validate_package_name(&long).unwrap_err();
        assert!(err.contains("too long"));
        assert!(err.contains("65"));
        // Exactly 64 should be fine
        let exact = "a".repeat(64);
        assert!(validate_package_name(&exact).is_ok());
    }

    #[test]
    fn must_start_with_lowercase() {
        assert!(validate_package_name("Uppercase").is_err());
        assert!(validate_package_name("1starts-with-digit").is_err());
        assert!(validate_package_name("-starts-with-hyphen").is_err());
        assert!(validate_package_name("_starts-with-underscore").is_err());
    }

    #[test]
    fn no_special_chars() {
        assert!(validate_package_name("my.package").is_err());
        assert!(validate_package_name("my@package").is_err());
        assert!(validate_package_name("my package").is_err());
        assert!(validate_package_name("my/package").is_err());
        assert!(validate_package_name("myPackage").is_err()); // uppercase
    }

    #[test]
    fn reserved_names_rejected() {
        assert!(validate_package_name("forge").is_err());
        assert!(validate_package_name("std").is_err());
        assert!(validate_package_name("core").is_err());
        assert!(validate_package_name("fn").is_err());
        assert!(validate_package_name("let").is_err());
        assert!(validate_package_name("use").is_err());
        assert!(validate_package_name("true").is_err());
        assert!(validate_package_name("false").is_err());
        assert!(validate_package_name("null").is_err());
    }

    #[test]
    fn no_trailing_separator() {
        assert!(validate_package_name("foo-").is_err());
        assert!(validate_package_name("foo_").is_err());
    }

    #[test]
    fn no_consecutive_separators() {
        assert!(validate_package_name("foo--bar").is_err());
        assert!(validate_package_name("foo__bar").is_err());
    }

    // ── validate_org_name ───────────────────────────────────────────

    #[test]
    fn valid_org_names() {
        assert!(validate_org_name("acme").is_ok());
        assert!(validate_org_name("my-org").is_ok());
        assert!(validate_org_name("org123").is_ok());
    }

    #[test]
    fn empty_org_name() {
        assert!(validate_org_name("").unwrap_err().contains("cannot be empty"));
    }

    #[test]
    fn too_long_org_name() {
        let long = "a".repeat(33);
        assert!(validate_org_name(&long).unwrap_err().contains("too long"));
        assert!(validate_org_name(&"a".repeat(32)).is_ok());
    }

    #[test]
    fn org_must_start_with_lowercase() {
        assert!(validate_org_name("Acme").is_err());
        assert!(validate_org_name("1org").is_err());
    }

    #[test]
    fn std_reserved_for_org() {
        assert!(validate_org_name("std")
            .unwrap_err()
            .contains("reserved for the standard library"));
    }

    // ── validate_package_ref ────────────────────────────────────────

    #[test]
    fn scoped_std_ref() {
        let r = validate_package_ref("@std/http").unwrap();
        assert_eq!(
            r,
            PackageRef::Scoped {
                namespace: "std".to_string(),
                name: "http".to_string()
            }
        );
        assert_eq!(r.display_name(), "@std/http");
        assert_eq!(r.namespace(), "std");
        assert_eq!(r.name(), "http");
    }

    #[test]
    fn scoped_org_ref() {
        let r = validate_package_ref("@acme/auth").unwrap();
        assert_eq!(
            r,
            PackageRef::Scoped {
                namespace: "acme".to_string(),
                name: "auth".to_string()
            }
        );
        assert_eq!(r.display_name(), "@acme/auth");
    }

    #[test]
    fn community_ref() {
        let r = validate_package_ref("graphql").unwrap();
        assert_eq!(
            r,
            PackageRef::Community {
                name: "graphql".to_string()
            }
        );
        assert_eq!(r.display_name(), "graphql");
        assert_eq!(r.namespace(), "community");
        assert_eq!(r.name(), "graphql");
    }

    #[test]
    fn scoped_missing_name() {
        assert!(validate_package_ref("@acme").is_err());
    }

    #[test]
    fn scoped_invalid_namespace() {
        assert!(validate_package_ref("@ACME/http").is_err());
    }

    #[test]
    fn scoped_invalid_name() {
        assert!(validate_package_ref("@acme/HTTP").is_err());
    }

    #[test]
    fn display_trait() {
        let scoped = PackageRef::Scoped {
            namespace: "std".to_string(),
            name: "http".to_string(),
        };
        assert_eq!(format!("{}", scoped), "@std/http");

        let community = PackageRef::Community {
            name: "graphql".to_string(),
        };
        assert_eq!(format!("{}", community), "graphql");
    }

    // ── typosquatting detection ─────────────────────────────────────

    #[test]
    fn typosquat_edit_distance_1() {
        let popular = &["http", "model", "queue"];
        assert!(check_typosquat("httq", popular).is_some());
        // "modle" is distance 2 from "model" (transposition), so won't flag with threshold 1
        assert!(check_typosquat("modle", popular).is_none());
    }

    #[test]
    fn typosquat_separator_confusion() {
        let popular = &["json-parser", "my-package"];
        assert!(check_typosquat("json_parser", popular).is_some());
        assert!(check_typosquat("jsonparser", popular).is_some());
        assert!(check_typosquat("my_package", popular).is_some());
    }

    #[test]
    fn typosquat_no_false_positive_on_exact() {
        let popular = &["http"];
        assert!(check_typosquat("http", popular).is_none());
    }

    #[test]
    fn typosquat_no_flag_for_short_names() {
        // Names with 3 or fewer chars are not flagged for edit distance
        let popular = &["foo"];
        assert!(check_typosquat("fob", popular).is_none());
    }

    #[test]
    fn typosquat_no_flag_for_dissimilar() {
        let popular = &["http"];
        assert!(check_typosquat("database", popular).is_none());
    }

    // ── levenshtein_distance ────────────────────────────────────────

    #[test]
    fn levenshtein_identical() {
        assert_eq!(levenshtein_distance("abc", "abc"), 0);
    }

    #[test]
    fn levenshtein_empty() {
        assert_eq!(levenshtein_distance("", "abc"), 3);
        assert_eq!(levenshtein_distance("abc", ""), 3);
        assert_eq!(levenshtein_distance("", ""), 0);
    }

    #[test]
    fn levenshtein_single_edit() {
        assert_eq!(levenshtein_distance("kitten", "sitten"), 1); // substitution
        assert_eq!(levenshtein_distance("http", "httq"), 1); // substitution
        assert_eq!(levenshtein_distance("model", "modle"), 2); // transposition counts as 2 in basic lev
    }

    #[test]
    fn levenshtein_known_values() {
        assert_eq!(levenshtein_distance("kitten", "sitting"), 3);
        assert_eq!(levenshtein_distance("saturday", "sunday"), 3);
    }
}
