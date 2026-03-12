use crate::lexer::Span;
use serde::Serialize;
use std::fmt;

#[derive(Debug, Clone, Serialize)]
pub struct Diagnostic {
    pub code: &'static str,
    pub severity: Severity,
    pub message: String,
    pub span: Span,
    pub help: Option<String>,
    pub labels: Vec<DiagnosticLabel>,
    pub suggestions: Vec<Suggestion>,
    pub tip: Option<String>,
    pub docs_url: Option<String>,
}

#[derive(Debug, Clone, Copy, PartialEq, Serialize)]
#[serde(rename_all = "lowercase")]
pub enum Severity {
    Error,
    Warning,
    Info,
    Hint,
}

#[derive(Debug, Clone, Serialize)]
pub struct DiagnosticLabel {
    pub span: Span,
    pub message: String,
    pub kind: LabelKind,
}

#[derive(Debug, Clone, Copy, PartialEq, Serialize)]
#[serde(rename_all = "lowercase")]
pub enum LabelKind {
    Primary,
    Secondary,
}

#[derive(Debug, Clone, Serialize)]
pub struct Suggestion {
    pub message: String,
    pub edits: Vec<Edit>,
    pub confidence: f64,
}

#[derive(Debug, Clone, Serialize)]
pub struct Edit {
    pub span: Span,
    pub replacement: String,
}

impl fmt::Display for Diagnostic {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}[{}]: {}", self.severity, self.code, self.message)
    }
}

impl fmt::Display for Severity {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Severity::Error => write!(f, "error"),
            Severity::Warning => write!(f, "warning"),
            Severity::Info => write!(f, "info"),
            Severity::Hint => write!(f, "hint"),
        }
    }
}

impl Diagnostic {
    pub fn error(code: &'static str, message: impl Into<String>, span: Span) -> Self {
        Self {
            code,
            severity: Severity::Error,
            message: message.into(),
            span,
            help: None,
            labels: Vec::new(),
            suggestions: Vec::new(),
            tip: None,
            docs_url: None,
        }
    }

    pub fn warning(code: &'static str, message: impl Into<String>, span: Span) -> Self {
        Self {
            code,
            severity: Severity::Warning,
            message: message.into(),
            span,
            help: None,
            labels: Vec::new(),
            suggestions: Vec::new(),
            tip: None,
            docs_url: None,
        }
    }

    pub fn with_help(mut self, help: impl Into<String>) -> Self {
        self.help = Some(help.into());
        self
    }

    pub fn with_label(mut self, span: Span, message: impl Into<String>, kind: LabelKind) -> Self {
        self.labels.push(DiagnosticLabel {
            span,
            message: message.into(),
            kind,
        });
        self
    }

    pub fn with_tip(mut self, tip: impl Into<String>) -> Self {
        self.tip = Some(tip.into());
        self
    }

    pub fn with_suggestion(
        mut self,
        message: impl Into<String>,
        edits: Vec<Edit>,
        confidence: f64,
    ) -> Self {
        self.suggestions.push(Suggestion {
            message: message.into(),
            edits,
            confidence,
        });
        self
    }

    pub fn with_docs_url(mut self, url: impl Into<String>) -> Self {
        self.docs_url = Some(url.into());
        self
    }
}

#[derive(Debug, Default)]
pub struct DiagnosticBag {
    pub diagnostics: Vec<Diagnostic>,
}

impl DiagnosticBag {
    pub fn new() -> Self {
        Self::default()
    }

    pub fn report(&mut self, diag: Diagnostic) {
        self.diagnostics.push(diag);
    }

    pub fn has_errors(&self) -> bool {
        self.diagnostics
            .iter()
            .any(|d| d.severity == Severity::Error)
    }

    pub fn error_count(&self) -> usize {
        self.diagnostics
            .iter()
            .filter(|d| d.severity == Severity::Error)
            .count()
    }

    pub fn warning_count(&self) -> usize {
        self.diagnostics
            .iter()
            .filter(|d| d.severity == Severity::Warning)
            .count()
    }

    pub fn print_all(&self, source: &str, filename: &str) {
        self.print_all_limited(source, filename, usize::MAX);
    }

    pub fn print_all_limited(&self, source: &str, filename: &str, max_errors: usize) {
        self.print_to_limited(&mut std::io::stderr(), source, filename, max_errors);
    }

    pub fn print_summary(&self) {
        self.print_summary_to(&mut std::io::stderr());
    }

    pub fn print_summary_to(&self, writer: &mut dyn std::io::Write) {
        let errors = self.error_count();
        let warnings = self.warning_count();
        if errors > 0 || warnings > 0 {
            let mut parts = Vec::new();
            if errors > 0 {
                parts.push(format!(
                    "{} error{}",
                    errors,
                    if errors == 1 { "" } else { "s" }
                ));
            }
            if warnings > 0 {
                parts.push(format!(
                    "{} warning{}",
                    warnings,
                    if warnings == 1 { "" } else { "s" }
                ));
            }
            writeln!(writer, "Found {}.", parts.join(" and ")).ok();
        }
    }

    pub fn to_json(&self) -> String {
        #[derive(Serialize)]
        struct JsonOutput<'a> {
            diagnostics: &'a Vec<Diagnostic>,
        }
        serde_json::to_string_pretty(&JsonOutput {
            diagnostics: &self.diagnostics,
        })
        .unwrap_or_else(|_| r#"{"diagnostics":[]}"#.to_string())
    }

    pub fn print_json(&self) {
        eprintln!("{}", self.to_json());
    }

    pub fn print_to(&self, writer: &mut dyn std::io::Write, source: &str, filename: &str) {
        self.print_to_limited(writer, source, filename, usize::MAX);
    }

    pub fn print_to_limited(&self, writer: &mut dyn std::io::Write, source: &str, filename: &str, max_errors: usize) {
        use ariadne::{Color, Label, Report, ReportKind, Source};

        let mut error_count = 0;
        for diag in &self.diagnostics {
            if diag.severity == Severity::Error {
                error_count += 1;
                if error_count > max_errors {
                    writeln!(writer, "... and {} more errors (use --max-errors to see more)", self.error_count() - max_errors).ok();
                    break;
                }
            }
            let kind = match diag.severity {
                Severity::Error => ReportKind::Error,
                Severity::Warning => ReportKind::Warning,
                Severity::Info | Severity::Hint => ReportKind::Advice,
            };

            let mut builder = Report::build(kind, filename, diag.span.start)
                .with_code(diag.code)
                .with_message(&diag.message);

            if !diag.labels.is_empty() {
                // Use explicit labels
                for label in &diag.labels {
                    let color = match label.kind {
                        LabelKind::Primary => Color::Red,
                        LabelKind::Secondary => Color::Blue,
                    };
                    builder = builder.with_label(
                        Label::new((filename, label.span.start..label.span.end))
                            .with_message(&label.message)
                            .with_color(color),
                    );
                }
            } else {
                // Fallback: use the diagnostic's own span and message (backward compat)
                builder = builder.with_label(
                    Label::new((filename, diag.span.start..diag.span.end))
                        .with_message(&diag.message)
                        .with_color(Color::Red),
                );
            }

            if let Some(help) = &diag.help {
                builder = builder.with_help(help);
            }

            if let Some(tip) = &diag.tip {
                builder = builder.with_note(tip);
            }

            builder
                .finish()
                .write((filename, Source::from(source)), &mut *writer)
                .ok();
        }
    }
}

/// Render an internal compiler error (F9999) using ariadne, matching the style of all other errors.
pub fn print_ice(detail: &str) {
    use ariadne::{Color, Label, Report, ReportKind, Source};

    Report::<(&str, std::ops::Range<usize>)>::build(ReportKind::Error, "<compiler>", 0)
        .with_code("F9999")
        .with_message("internal compiler error")
        .with_label(
            Label::new(("<compiler>", 0..1))
                .with_message(detail)
                .with_color(Color::Red),
        )
        .with_help(
            "This is a bug in the Forge compiler, not in your code.\n  \
             Please report at https://github.com/forge-lang/forge/issues\n  \
             Run with RUST_BACKTRACE=1 for a stack trace.",
        )
        .finish()
        .write(("<compiler>", Source::from(" ")), std::io::stderr())
        .ok();
}

#[cfg(test)]
mod tests {
    use super::*;

    fn test_span() -> Span {
        Span::new(0, 5, 1, 1)
    }

    #[test]
    fn test_error_constructor() {
        let d = Diagnostic::error("F0001", "test error", test_span());
        assert_eq!(d.code, "F0001");
        assert_eq!(d.severity, Severity::Error);
        assert_eq!(d.message, "test error");
        assert!(d.labels.is_empty());
        assert!(d.suggestions.is_empty());
        assert!(d.tip.is_none());
        assert!(d.docs_url.is_none());
    }

    #[test]
    fn test_warning_constructor() {
        let d = Diagnostic::warning("F0801", "unused var", test_span());
        assert_eq!(d.severity, Severity::Warning);
    }

    #[test]
    fn test_with_help() {
        let d = Diagnostic::error("F0001", "err", test_span()).with_help("try this");
        assert_eq!(d.help.unwrap(), "try this");
    }

    #[test]
    fn test_with_label() {
        let d = Diagnostic::error("F0001", "err", test_span())
            .with_label(test_span(), "primary", LabelKind::Primary)
            .with_label(Span::new(10, 15, 2, 1), "secondary", LabelKind::Secondary);
        assert_eq!(d.labels.len(), 2);
        assert_eq!(d.labels[0].kind, LabelKind::Primary);
        assert_eq!(d.labels[1].kind, LabelKind::Secondary);
    }

    #[test]
    fn test_with_tip() {
        let d = Diagnostic::error("F0001", "err", test_span()).with_tip("note this");
        assert_eq!(d.tip.unwrap(), "note this");
    }

    #[test]
    fn test_with_suggestion() {
        let d = Diagnostic::error("F0001", "err", test_span()).with_suggestion(
            "try replacing",
            vec![Edit {
                span: test_span(),
                replacement: "fixed".to_string(),
            }],
            0.9,
        );
        assert_eq!(d.suggestions.len(), 1);
        assert_eq!(d.suggestions[0].confidence, 0.9);
    }

    #[test]
    fn test_backward_compat_existing_api() {
        // Existing code creates Diagnostic::error().with_help() — must still work
        let d = Diagnostic::error("E0001", "old error", test_span()).with_help("old help");
        assert_eq!(d.code, "E0001");
        assert_eq!(d.help.unwrap(), "old help");
        assert!(d.labels.is_empty());
    }

    #[test]
    fn test_display() {
        let d = Diagnostic::error("F0001", "test", test_span());
        assert_eq!(format!("{}", d), "error[F0001]: test");
    }

    #[test]
    fn test_severity_display() {
        assert_eq!(format!("{}", Severity::Error), "error");
        assert_eq!(format!("{}", Severity::Warning), "warning");
        assert_eq!(format!("{}", Severity::Info), "info");
        assert_eq!(format!("{}", Severity::Hint), "hint");
    }

    #[test]
    fn test_error_count() {
        let mut bag = DiagnosticBag::new();
        bag.report(Diagnostic::error("F0001", "err1", test_span()));
        bag.report(Diagnostic::warning("F0801", "warn1", test_span()));
        bag.report(Diagnostic::error("F0002", "err2", test_span()));
        assert_eq!(bag.error_count(), 2);
        assert_eq!(bag.warning_count(), 1);
    }

    #[test]
    fn test_print_to_with_multi_labels() {
        let source = "let x = 42\nlet y = x + z\n";
        let d = Diagnostic::error("F0020", "undefined variable 'z'", Span::new(24, 25, 2, 13))
            .with_label(Span::new(24, 25, 2, 13), "not found in scope", LabelKind::Primary)
            .with_label(Span::new(12, 23, 2, 1), "in this expression", LabelKind::Secondary);

        let mut bag = DiagnosticBag::new();
        bag.report(d);

        let mut output = Vec::new();
        bag.print_to(&mut output, source, "test.fg");
        let text = String::from_utf8(output).unwrap();

        assert!(text.contains("F0020"));
        assert!(text.contains("not found in scope"));
        assert!(text.contains("in this expression"));
    }

    #[test]
    fn test_print_to_with_tip() {
        let source = "let x = 42\n";
        let d = Diagnostic::warning("F0801", "unused variable 'x'", Span::new(4, 5, 1, 5))
            .with_tip("prefix with _ to suppress");

        let mut bag = DiagnosticBag::new();
        bag.report(d);

        let mut output = Vec::new();
        bag.print_to(&mut output, source, "test.fg");
        let text = String::from_utf8(output).unwrap();

        assert!(text.contains("F0801"));
        assert!(text.contains("prefix with _ to suppress"));
    }

    #[test]
    fn test_print_to_fallback_single_label() {
        // When no explicit labels are set, it should fall back to span+message
        let source = "hello world\n";
        let d = Diagnostic::error("F0001", "unexpected token", Span::new(0, 5, 1, 1));

        let mut bag = DiagnosticBag::new();
        bag.report(d);

        let mut output = Vec::new();
        bag.print_to(&mut output, source, "test.fg");
        let text = String::from_utf8(output).unwrap();

        assert!(text.contains("F0001"));
        assert!(text.contains("unexpected token"));
    }

    #[test]
    fn test_to_json() {
        let mut bag = DiagnosticBag::new();
        bag.report(
            Diagnostic::error("F0020", "undefined variable 'x'", Span::new(10, 11, 2, 5))
                .with_help("did you mean 'y'?"),
        );
        bag.report(Diagnostic::warning(
            "F0801",
            "unused variable 'z'",
            Span::new(0, 1, 1, 1),
        ));

        let json_str = bag.to_json();
        let parsed: serde_json::Value = serde_json::from_str(&json_str).unwrap();

        let diagnostics = parsed["diagnostics"].as_array().unwrap();
        assert_eq!(diagnostics.len(), 2);
        assert_eq!(diagnostics[0]["code"], "F0020");
        assert_eq!(diagnostics[0]["severity"], "error");
        assert_eq!(diagnostics[0]["message"], "undefined variable 'x'");
        assert_eq!(diagnostics[0]["help"], "did you mean 'y'?");
        assert_eq!(diagnostics[0]["span"]["start"], 10);
        assert_eq!(diagnostics[0]["span"]["end"], 11);
        assert_eq!(diagnostics[1]["code"], "F0801");
        assert_eq!(diagnostics[1]["severity"], "warning");
    }

    #[test]
    fn test_to_json_with_labels_and_suggestions() {
        let mut bag = DiagnosticBag::new();
        bag.report(
            Diagnostic::error("F0012", "type mismatch", Span::new(5, 10, 1, 6))
                .with_label(Span::new(5, 10, 1, 6), "expected string", LabelKind::Primary)
                .with_suggestion(
                    "wrap with string()",
                    vec![Edit {
                        span: Span::new(5, 10, 1, 6),
                        replacement: "string(8080)".to_string(),
                    }],
                    0.95,
                ),
        );

        let json_str = bag.to_json();
        let parsed: serde_json::Value = serde_json::from_str(&json_str).unwrap();

        let diag = &parsed["diagnostics"][0];
        assert_eq!(diag["labels"][0]["kind"], "primary");
        assert_eq!(diag["suggestions"][0]["confidence"], 0.95);
        assert_eq!(diag["suggestions"][0]["edits"][0]["replacement"], "string(8080)");
    }
}
