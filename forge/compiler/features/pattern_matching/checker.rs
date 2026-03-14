use crate::feature::FeatureExpr;
use crate::feature_data;
use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

use super::types::MatchData;

impl TypeChecker {
    /// Type-check a match expression via the Feature dispatch system.
    pub(crate) fn check_match_feature(&mut self, fe: &FeatureExpr) -> Type {
        if let Some(data) = feature_data!(fe, MatchData) {
            self.check_match(&data.subject, &data.arms)
        } else {
            Type::Unknown
        }
    }

    pub(crate) fn check_match(&mut self, subject: &Expr, arms: &[MatchArm]) -> Type {
        self.check_expr(subject);
        let mut result_type = Type::Unknown;
        for arm in arms {
            self.env.push_scope();
            // Bind pattern variables BEFORE checking the guard so they're in scope
            self.bind_pattern(&arm.pattern);
            if let Some(guard) = &arm.guard {
                self.check_expr(guard);
            }
            let arm_type = self.check_expr(&arm.body);
            if result_type == Type::Unknown {
                result_type = arm_type;
            }
            self.env.pop_scope_silent();
        }
        result_type
    }

    pub(crate) fn bind_destructure_pattern(&mut self, pattern: &Pattern, val_type: &Type) {
        match pattern {
            Pattern::Tuple(elems, _) => {
                if let Type::Tuple(types) = val_type {
                    for (i, elem) in elems.iter().enumerate() {
                        if let Pattern::Ident(name, _) = elem {
                            let ty = types.get(i).cloned().unwrap_or(Type::Unknown);
                            self.env.define(name.clone(), ty, false);
                        }
                    }
                } else {
                    for elem in elems {
                        if let Pattern::Ident(name, _) = elem {
                            self.env.define(name.clone(), Type::Unknown, false);
                        }
                    }
                }
            }
            Pattern::Struct { fields, .. } => {
                if let Type::Struct { fields: type_fields, .. } = val_type {
                    for (field_name, pat) in fields {
                        if let Pattern::Ident(name, _) = pat {
                            let ty = type_fields
                                .iter()
                                .find(|(n, _)| n == field_name)
                                .map(|(_, t)| t.clone())
                                .unwrap_or(Type::Unknown);
                            self.env.define(name.clone(), ty, false);
                        }
                    }
                } else {
                    for (_, pat) in fields {
                        if let Pattern::Ident(name, _) = pat {
                            self.env.define(name.clone(), Type::Unknown, false);
                        }
                    }
                }
            }
            Pattern::List { elements, rest, .. } => {
                let elem_type = if let Type::List(inner) = val_type {
                    *inner.clone()
                } else {
                    Type::Unknown
                };
                for elem in elements {
                    if let Pattern::Ident(name, _) = elem {
                        self.env.define(name.clone(), elem_type.clone(), false);
                    }
                }
                if let Some(rest_name) = rest {
                    self.env.define(rest_name.clone(), Type::List(Box::new(elem_type)), false);
                }
            }
            Pattern::Ident(name, _) => {
                self.env.define(name.clone(), val_type.clone(), false);
            }
            _ => {}
        }
    }

    pub(crate) fn bind_pattern(&mut self, pattern: &Pattern) {
        match pattern {
            Pattern::Ident(name, _) => {
                self.env.define(name.clone(), Type::Unknown, false);
            }
            Pattern::Enum { fields, .. } => {
                for field in fields {
                    self.bind_pattern(field);
                }
            }
            Pattern::Tuple(elems, _) => {
                for elem in elems {
                    self.bind_pattern(elem);
                }
            }
            _ => {}
        }
    }
}
