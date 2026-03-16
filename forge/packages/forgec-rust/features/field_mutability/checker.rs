use crate::errors::Diagnostic;
use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

impl TypeChecker {
    /// Check if a field assignment is allowed based on per-field mutability.
    /// Called from the Assign handler when target is a MemberAccess.
    /// Returns true if the assignment should be blocked (field is immutable).
    pub(crate) fn check_field_mutability(&mut self, target: &Expr, span: crate::lexer::Span) -> bool {
        // Extract the field name and object from the member access
        if let Expr::MemberAccess { object, field: member, .. } = target {
            let obj_type = self.check_expr(object);

            // Get the type name — we need it to look up field mutability
            let type_name = match &obj_type {
                Type::Struct { name: Some(name), .. } => Some(name.clone()),
                _ => {
                    // Try to resolve through named types
                    if let Expr::Ident(var_name, _) = object.as_ref() {
                        if let Some(info) = self.env.lookup(var_name) {
                            match &info.ty {
                                Type::Struct { name: Some(n), .. } => Some(n.clone()),
                                _ => None,
                            }
                        } else {
                            None
                        }
                    } else {
                        None
                    }
                }
            };

            if let Some(type_name) = type_name {
                // Check if this field is declared as mutable
                let field_is_mutable = self.mutable_fields.contains(&(type_name.clone(), member.clone()));

                // If the type HAS any mutable fields registered, then we enforce mutability
                // (if no fields are registered, it's an old-style type without mut annotations — skip enforcement)
                let type_has_mutability_info = self.mutable_fields.iter().any(|(tn, _)| tn == &type_name);

                if type_has_mutability_info && !field_is_mutable {
                    self.diagnostics.push(
                        Diagnostic::error(
                            "F0031",
                            format!("cannot mutate immutable field '{}'", member),
                            span,
                        )
                        .with_help(format!(
                            "{}.{} is immutable after construction. Declare it as `mut {}: ...` if it should be mutable",
                            type_name, member, member
                        ))
                    );
                    return true;
                }
            }
        }
        false
    }
}
