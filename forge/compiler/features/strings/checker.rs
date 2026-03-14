use crate::errors::Diagnostic;
use crate::lexer::Span;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

impl TypeChecker {
    /// Check a method call on a string type and return the result type.
    /// Emits an error diagnostic for undefined string methods.
    pub(crate) fn check_string_method_call(&mut self, method: &str, span: Span) -> Type {
        match method {
            "upper" | "lower" | "trim" | "replace" | "repeat" => Type::String,
            "contains" | "starts_with" | "ends_with" => Type::Bool,
            "parse_int" => Type::Int,
            "split" => Type::List(Box::new(Type::String)),
            "length" => Type::Int,
            _ => {
                let known = ["upper", "lower", "trim", "contains", "split",
                    "starts_with", "ends_with", "replace", "parse_int", "repeat", "length"];
                let mut diag = Diagnostic::error(
                    "F0020",
                    format!("string has no method '{}'", method),
                    span,
                );
                if let Some(suggestion) = crate::errors::did_you_mean(method, &known, 2) {
                    diag = diag.with_help(format!("did you mean '{}'?", suggestion));
                } else {
                    diag = diag.with_help(format!("available string methods: {}", known.join(", ")));
                }
                self.diagnostics.push(diag);
                Type::Error
            }
        }
    }
}
