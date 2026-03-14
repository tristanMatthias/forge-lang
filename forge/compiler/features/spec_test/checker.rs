use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;

impl TypeChecker {
    pub(crate) fn check_spec_block(&mut self, body: &Block) {
        self.env.push_scope();
        self.check_block(body);
        self.env.pop_scope_silent();
    }

    pub(crate) fn check_given_block(&mut self, body: &Block) {
        self.env.push_scope();
        self.check_block(body);
        self.env.pop_scope_silent();
    }

    pub(crate) fn check_then_block(&mut self, body: &Block) {
        self.env.push_scope();
        self.check_block(body);
        self.env.pop_scope_silent();
    }

    pub(crate) fn check_then_should_fail(&mut self, body: &Block) {
        self.env.push_scope();
        self.check_block(body);
        self.env.pop_scope_silent();
    }

    pub(crate) fn check_then_should_fail_with(&mut self, body: &Block) {
        self.env.push_scope();
        self.check_block(body);
        self.env.pop_scope_silent();
    }

    pub(crate) fn check_then_where(&mut self, table: &Expr, body: &Block) {
        self.check_expr(table);
        // Check body in a scope — column bindings would be defined at runtime
        self.env.push_scope();
        // For table literals, register column names as variables
        if let Expr::TableLit { columns, .. } = table {
            for col in columns {
                self.env.define(col.clone(), crate::typeck::types::Type::Unknown, false);
            }
        } else if let Expr::Feature(fe) = table {
            if fe.feature_id == "table_literal" {
                if let Some(data) = crate::feature_data!(fe, crate::features::table_literal::types::TableLitData) {
                    for col in &data.columns {
                        self.env.define(col.clone(), crate::typeck::types::Type::Unknown, false);
                    }
                }
            }
        }
        self.check_block(body);
        self.env.pop_scope_silent();
    }
}
