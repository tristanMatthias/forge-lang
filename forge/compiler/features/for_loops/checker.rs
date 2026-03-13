use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

impl TypeChecker {
    pub(crate) fn check_for(&mut self, pattern: &Pattern, iterable: &Expr, body: &Block) {
        let iter_type = self.check_expr(iterable);
        self.env.push_scope();
        if let Pattern::Ident(name, _) = pattern {
            let elem_type = match &iter_type {
                Type::Range(inner) => *inner.clone(),
                Type::List(inner) => *inner.clone(),
                Type::Channel(inner) => *inner.clone(),
                _ => Type::Int,
            };
            self.env.define(name.clone(), elem_type, false);
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
