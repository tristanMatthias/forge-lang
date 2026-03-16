use crate::feature::FeatureStmt;
use crate::feature_stmt;
use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

use super::types::ForData;

impl TypeChecker {
    /// Type-check a for loop via the Feature dispatch system.
    pub(crate) fn check_for_feature(&mut self, fe: &FeatureStmt) {
        feature_stmt!(self, fe, ForData, |data| self.check_for(&data.pattern, &data.iterable, &data.body));
    }

    pub(crate) fn check_for(&mut self, pattern: &Pattern, iterable: &Expr, body: &Block) {
        let iter_type = self.check_expr(iterable);
        self.env.push_scope();
        // Map iteration: for (k, v) in map yields key and value types directly
        if let Type::Map(key_type, val_type) = &iter_type {
            if let Pattern::Tuple(pats, _) = pattern {
                if pats.len() >= 1 {
                    if let Pattern::Ident(name, _) = &pats[0] {
                        if name != "_" {
                            self.env.define(name.clone(), *key_type.clone(), false);
                        }
                    }
                }
                if pats.len() >= 2 {
                    if let Pattern::Ident(name, _) = &pats[1] {
                        if name != "_" {
                            self.env.define(name.clone(), *val_type.clone(), false);
                        }
                    }
                }
            } else if let Pattern::Ident(name, _) = pattern {
                // Single ident iterating over map — give it key type
                self.env.define(name.clone(), *key_type.clone(), false);
            }
            self.check_block(body);
            self.env.pop_scope_silent();
            return;
        }

        let elem_type = match &iter_type {
            Type::Range(inner) => *inner.clone(),
            Type::List(inner) => *inner.clone(),
            Type::Channel(inner) => *inner.clone(),
            _ => Type::Int,
        };
        match pattern {
            Pattern::Ident(name, _) => {
                self.env.define(name.clone(), elem_type, false);
            }
            Pattern::Tuple(pats, _) => {
                // For tuple destructure like (i, val) in list of tuples or enumerate
                if let Type::Tuple(tuple_types) = &elem_type {
                    for (i, pat) in pats.iter().enumerate() {
                        if let Pattern::Ident(name, _) = pat {
                            let field_ty = tuple_types.get(i).cloned().unwrap_or(Type::Int);
                            self.env.define(name.clone(), field_ty, false);
                        }
                    }
                } else {
                    // Fallback: define all sub-patterns as the elem type
                    for pat in pats {
                        if let Pattern::Ident(name, _) = pat {
                            self.env.define(name.clone(), elem_type.clone(), false);
                        }
                    }
                }
            }
            _ => {}
        }
        self.check_block(body);
        self.env.pop_scope_silent();
    }

    pub(crate) fn check_while(&mut self, condition: &Expr, body: &Block) {
        self.check_expr(condition);
        self.env.push_scope();
        self.check_block(body);
        self.env.pop_scope_silent();
    }

    pub(crate) fn check_loop(&mut self, body: &Block) {
        self.env.push_scope();
        self.check_block(body);
        self.env.pop_scope_silent();
    }

    pub(crate) fn check_break(&mut self, value: Option<&Expr>) {
        if let Some(val) = value {
            self.check_expr(val);
        }
    }
}
