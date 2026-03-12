use std::collections::HashSet;

/// Key that uniquely identifies a diagnostic for diffing purposes
#[derive(Hash, Eq, PartialEq, Debug, Clone)]
struct DiagKey {
    code: String,
    line: u64,
    col: u64,
    message: String,
}

/// Result of diffing two diagnostic JSON files
pub struct DiffResult {
    pub fixed: Vec<String>,
    pub new: Vec<String>,
    pub remaining: Vec<String>,
}

impl DiffResult {
    pub fn render(&self) -> String {
        let mut out = String::new();

        if !self.fixed.is_empty() {
            out.push_str(&format!("  Fixed ({}):\n", self.fixed.len()));
            for msg in &self.fixed {
                out.push_str(&format!("    - {}\n", msg));
            }
        }
        if !self.new.is_empty() {
            out.push_str(&format!("  New ({}):\n", self.new.len()));
            for msg in &self.new {
                out.push_str(&format!("    + {}\n", msg));
            }
        }
        if !self.remaining.is_empty() {
            out.push_str(&format!("  Remaining ({}):\n", self.remaining.len()));
            for msg in &self.remaining {
                out.push_str(&format!("    = {}\n", msg));
            }
        }

        let before_total = self.fixed.len() + self.remaining.len();
        let after_total = self.new.len() + self.remaining.len();
        out.push('\n');
        out.push_str(&format!("  Summary: {} before, {} after\n", before_total, after_total));
        if before_total > 0 {
            let progress = self.fixed.len() as f64 / before_total as f64 * 100.0;
            out.push_str(&format!("  Progress: {:.0}% fixed\n", progress));
        }

        out
    }
}

fn extract_diagnostics(json_str: &str) -> Result<Vec<(DiagKey, String)>, String> {
    let parsed: serde_json::Value =
        serde_json::from_str(json_str).map_err(|e| format!("invalid JSON: {}", e))?;

    let diagnostics = parsed["diagnostics"]
        .as_array()
        .ok_or_else(|| "JSON must have a 'diagnostics' array".to_string())?;

    let mut result = Vec::new();
    for diag in diagnostics {
        let code = diag["code"].as_str().unwrap_or("").to_string();
        let line = diag["span"]["line"].as_u64().unwrap_or(0);
        let col = diag["span"]["col"].as_u64().unwrap_or(0);
        let message = diag["message"].as_str().unwrap_or("").to_string();
        let display = format!("[{}] line {}:{} {}", code, line, col, message);
        result.push((
            DiagKey { code, line, col, message },
            display,
        ));
    }
    Ok(result)
}

pub fn diff_json(before_json: &str, after_json: &str) -> Result<DiffResult, String> {
    let before = extract_diagnostics(before_json)?;
    let after = extract_diagnostics(after_json)?;

    let before_keys: HashSet<DiagKey> = before.iter().map(|(k, _)| k.clone()).collect();
    let after_keys: HashSet<DiagKey> = after.iter().map(|(k, _)| k.clone()).collect();

    let fixed: Vec<String> = before
        .iter()
        .filter(|(k, _)| !after_keys.contains(k))
        .map(|(_, d)| d.clone())
        .collect();

    let new: Vec<String> = after
        .iter()
        .filter(|(k, _)| !before_keys.contains(k))
        .map(|(_, d)| d.clone())
        .collect();

    let remaining: Vec<String> = before
        .iter()
        .filter(|(k, _)| after_keys.contains(k))
        .map(|(_, d)| d.clone())
        .collect();

    Ok(DiffResult { fixed, new, remaining })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_diff_finds_fixed_and_new() {
        let before = r#"{"diagnostics": [
            {"code": "F0020", "severity": "error", "message": "undefined variable 'x'", "span": {"start": 10, "end": 11, "line": 2, "col": 5}},
            {"code": "F0012", "severity": "error", "message": "type mismatch", "span": {"start": 20, "end": 25, "line": 3, "col": 1}}
        ]}"#;
        let after = r#"{"diagnostics": [
            {"code": "F0012", "severity": "error", "message": "type mismatch", "span": {"start": 20, "end": 25, "line": 3, "col": 1}},
            {"code": "F0801", "severity": "warning", "message": "unused variable 'y'", "span": {"start": 30, "end": 31, "line": 4, "col": 5}}
        ]}"#;

        let result = diff_json(before, after).unwrap();
        assert_eq!(result.fixed.len(), 1);
        assert_eq!(result.new.len(), 1);
        assert_eq!(result.remaining.len(), 1);
        assert!(result.fixed[0].contains("F0020"));
        assert!(result.new[0].contains("F0801"));
    }

    #[test]
    fn test_diff_empty_after() {
        let before = r#"{"diagnostics": [
            {"code": "F0020", "severity": "error", "message": "undefined variable 'x'", "span": {"start": 10, "end": 11, "line": 2, "col": 5}}
        ]}"#;
        let after = r#"{"diagnostics": []}"#;

        let result = diff_json(before, after).unwrap();
        assert_eq!(result.fixed.len(), 1);
        assert_eq!(result.new.len(), 0);
        assert_eq!(result.remaining.len(), 0);
    }
}
