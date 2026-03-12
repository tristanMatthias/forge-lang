use crate::errors::diagnostic::{Diagnostic, Suggestion};

/// Apply high-confidence fixes from diagnostics to the source text.
/// Returns (fixed_source, applied_count, skipped_count).
pub fn apply_fixes(source: &str, diagnostics: &[Diagnostic], min_confidence: f64) -> (String, usize, usize) {
    // Collect all edits from all suggestions that meet the confidence threshold
    let mut all_edits: Vec<(usize, usize, String, f64)> = Vec::new(); // (start, end, replacement, confidence)

    for diag in diagnostics {
        for suggestion in &diag.suggestions {
            if suggestion.confidence >= min_confidence {
                for edit in &suggestion.edits {
                    all_edits.push((
                        edit.span.start,
                        edit.span.end,
                        edit.replacement.clone(),
                        suggestion.confidence,
                    ));
                }
            }
        }
    }

    let total_suggestions: usize = diagnostics.iter().map(|d| d.suggestions.len()).sum();
    let skipped = total_suggestions - all_edits.len();

    if all_edits.is_empty() {
        return (source.to_string(), 0, skipped);
    }

    // Sort edits in reverse order by start position to apply from end to beginning
    // This way earlier edits don't shift the positions of later ones
    all_edits.sort_by(|a, b| b.0.cmp(&a.0));

    // Remove overlapping edits (keep higher confidence ones)
    let mut filtered_edits: Vec<(usize, usize, String)> = Vec::new();
    for (start, end, replacement, _conf) in &all_edits {
        let overlaps = filtered_edits.iter().any(|(fs, fe, _)| {
            // Check if [start, end) overlaps [fs, fe)
            start < fe && end > fs
        });
        if !overlaps {
            filtered_edits.push((*start, *end, replacement.clone()));
        }
    }

    // Apply edits from end to beginning
    let mut result = source.to_string();
    let applied = filtered_edits.len();
    for (start, end, replacement) in &filtered_edits {
        if *start <= result.len() && *end <= result.len() && start <= end {
            result.replace_range(*start..*end, replacement);
        }
    }

    (result, applied, skipped)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::errors::diagnostic::{Edit, Severity};
    use crate::lexer::Span;

    #[test]
    fn test_apply_fixes_single_edit() {
        let source = "let port: string = 8080\n";
        let diag = Diagnostic::error("F0012", "type mismatch", Span::new(10, 16, 1, 11))
            .with_suggestion(
                "change type to int",
                vec![Edit {
                    span: Span::new(10, 16, 1, 11),
                    replacement: "int".to_string(),
                }],
                0.95,
            );

        let (fixed, applied, skipped) = apply_fixes(source, &[diag], 0.9);
        assert_eq!(applied, 1);
        assert_eq!(skipped, 0);
        assert!(fixed.contains("let port: int = 8080"));
    }

    #[test]
    fn test_apply_fixes_skips_low_confidence() {
        let source = "let x = cont\n";
        let diag = Diagnostic::error("F0020", "undefined variable", Span::new(8, 12, 1, 9))
            .with_suggestion(
                "did you mean 'count'?",
                vec![Edit {
                    span: Span::new(8, 12, 1, 9),
                    replacement: "count".to_string(),
                }],
                0.7,
            );

        let (fixed, applied, skipped) = apply_fixes(source, &[diag], 0.9);
        assert_eq!(applied, 0);
        assert_eq!(skipped, 1);
        assert_eq!(fixed, source);
    }
}
