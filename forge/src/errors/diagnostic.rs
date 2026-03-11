use crate::lexer::Span;
use std::fmt;

#[derive(Debug, Clone)]
pub struct Diagnostic {
    pub code: &'static str,
    pub severity: Severity,
    pub message: String,
    pub span: Span,
    pub help: Option<String>,
}

#[derive(Debug, Clone, Copy, PartialEq)]
pub enum Severity {
    Error,
    Warning,
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
        }
    }

    pub fn with_help(mut self, help: impl Into<String>) -> Self {
        self.help = Some(help.into());
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

    pub fn print_all(&self, source: &str, filename: &str) {
        use ariadne::{Color, Label, Report, ReportKind, Source};

        for diag in &self.diagnostics {
            let kind = match diag.severity {
                Severity::Error => ReportKind::Error,
                Severity::Warning => ReportKind::Warning,
            };

            let mut builder = Report::build(kind, filename, diag.span.start)
                .with_code(diag.code)
                .with_message(&diag.message)
                .with_label(
                    Label::new((filename, diag.span.start..diag.span.end))
                        .with_message(&diag.message)
                        .with_color(Color::Red),
                );

            if let Some(help) = &diag.help {
                builder = builder.with_help(help);
            }

            builder
                .finish()
                .eprint((filename, Source::from(source)))
                .ok();
        }
    }
}
