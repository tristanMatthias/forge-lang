use crate::errors::Diagnostic;
use crate::feature::FeatureExpr;
use crate::feature_check;
use crate::lexer::Span;
use crate::parser::ast::Expr;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

use super::types::{ListLitData, MapLitData};

impl TypeChecker {
    /// Type-check a list literal expression via the Feature dispatch system.
    pub(crate) fn check_list_lit_feature(&mut self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, ListLitData, |data| self.check_list_lit(&data.elements))
    }

    /// Type-check a list literal.
    pub(crate) fn check_list_lit(&mut self, elements: &[Expr]) -> Type {
        let elem_type = if let Some(first) = elements.first() {
            self.check_expr(first)
        } else {
            Type::Unknown
        };
        for elem in elements.iter().skip(1) {
            self.check_expr(elem);
        }
        Type::List(Box::new(elem_type))
    }

    /// Type-check a map literal expression via the Feature dispatch system.
    pub(crate) fn check_map_lit_feature(&mut self, fe: &FeatureExpr) -> Type {
        feature_check!(self, fe, MapLitData, |data| self.check_map_lit(&data.entries))
    }

    /// Type-check a map literal.
    pub(crate) fn check_map_lit(&mut self, entries: &[(Expr, Expr)]) -> Type {
        let (key_type, val_type) = if let Some((k, v)) = entries.first() {
            (self.check_expr(k), self.check_expr(v))
        } else {
            (Type::Unknown, Type::Unknown)
        };
        Type::Map(Box::new(key_type), Box::new(val_type))
    }

    /// Check a method call on a list type and return the result type.
    pub(crate) fn check_list_method_call(&mut self, inner: &Type, method: &str, span: Span) -> Type {
        match method {
            "push" | "each" | "sorted" | "reverse" | "flat" | "dedup"
            | "take" | "skip" | "chunks" | "windows" => {
                match method {
                    "push" | "each" => Type::Void,
                    "sorted" | "reverse" | "flat" | "dedup"
                    | "take" | "skip" => Type::List(Box::new(inner.clone())),
                    "chunks" | "windows" => Type::List(Box::new(Type::List(Box::new(inner.clone())))),
                    _ => Type::Unknown,
                }
            }
            "filter" | "map" => Type::List(Box::new(inner.clone())),
            "find" | "find_map" => Type::Nullable(Box::new(inner.clone())),
            "reduce" => inner.clone(),
            "sum" => Type::Int,
            "join" => Type::String,
            "contains" | "any" | "all" => Type::Bool,
            "enumerate" => Type::List(Box::new(Type::Tuple(vec![Type::Int, inner.clone()]))),
            "length" | "clone" => {
                match method {
                    "length" => Type::Int,
                    "clone" => Type::List(Box::new(inner.clone())),
                    _ => Type::Unknown,
                }
            }
            _ => {
                let known = ["push", "filter", "map", "find", "reduce", "sum",
                    "join", "each", "sorted", "contains", "any", "all",
                    "enumerate", "length", "clone", "reverse", "flat",
                    "dedup", "take", "skip", "chunks", "windows", "find_map"];
                let mut diag = Diagnostic::error(
                    "F0020",
                    format!("list has no method '{}'", method),
                    span,
                );
                if let Some(suggestion) = crate::errors::did_you_mean(method, &known, 2) {
                    diag = diag.with_help(format!("did you mean '{}'?", suggestion));
                } else {
                    diag = diag.with_help(format!("available list methods: {}", known.join(", ")));
                }
                self.diagnostics.push(diag);
                Type::Error
            }
        }
    }

    /// Check a method call on a map type and return the result type.
    pub(crate) fn check_map_method_call(&mut self, key_type: &Type, val_type: &Type, method: &str, span: Span) -> Type {
        match method {
            "get" => Type::Nullable(Box::new(val_type.clone())),
            "keys" => Type::List(Box::new(key_type.clone())),
            "values" => Type::List(Box::new(val_type.clone())),
            "contains_key" | "has" => Type::Bool,
            "entries" => Type::List(Box::new(Type::Tuple(vec![key_type.clone(), val_type.clone()]))),
            _ => {
                let known = ["get", "keys", "values", "contains_key", "has", "entries"];
                let mut diag = Diagnostic::error(
                    "F0020",
                    format!("map has no method '{}'", method),
                    span,
                );
                if let Some(suggestion) = crate::errors::did_you_mean(method, &known, 2) {
                    diag = diag.with_help(format!("did you mean '{}'?", suggestion));
                } else {
                    diag = diag.with_help(format!("available map methods: {}", known.join(", ")));
                }
                self.diagnostics.push(diag);
                Type::Error
            }
        }
    }
}
