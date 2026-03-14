use crate::errors::diagnostic::{Diagnostic, LabelKind};
use crate::feature::FeatureExpr;
use crate::feature_data;
use crate::parser::ast::Expr;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

use super::types::TableLitData;

impl TypeChecker {
    /// Type-check a table literal via Feature dispatch.
    pub(crate) fn check_table_lit_feature(&mut self, fe: &FeatureExpr) -> Type {
        if let Some(data) = feature_data!(fe, TableLitData) {
            self.check_table_literal(&data.columns, &data.rows)
        } else {
            Type::Unknown
        }
    }

    /// Type-check a table literal. Infers column types from the first row,
    /// then validates that all subsequent rows match.
    pub(crate) fn check_table_literal(
        &mut self,
        columns: &[String],
        rows: &[Vec<Expr>],
    ) -> Type {
        if rows.is_empty() {
            // Empty table — can't infer types, return List<Unknown struct>
            let fields: Vec<(String, Type)> = columns
                .iter()
                .map(|name| (name.clone(), Type::Unknown))
                .collect();
            return Type::List(Box::new(Type::Struct {
                name: None,
                fields,
            }));
        }

        // Infer column types from first row
        let first_row = &rows[0];
        let col_types: Vec<(String, Type)> = columns
            .iter()
            .zip(first_row.iter())
            .map(|(name, expr)| (name.clone(), self.check_expr(expr)))
            .collect();

        // Validate subsequent rows
        for (row_idx, row) in rows.iter().skip(1).enumerate() {
            for (col_idx, expr) in row.iter().enumerate() {
                let val_type = self.check_expr(expr);
                let expected = &col_types[col_idx].1;
                let col_name = &columns[col_idx];

                if !self.table_types_compatible(expected, &val_type) {
                    let diag = Diagnostic::error(
                        "F0030",
                        format!(
                            "type mismatch in table column '{}'",
                            col_name,
                        ),
                        expr.span(),
                    )
                    .with_label(
                        expr.span(),
                        format!("expected {}, found {}", self.type_name(expected), self.type_name(&val_type)),
                        LabelKind::Primary,
                    )
                    .with_label(
                        first_row[col_idx].span(),
                        format!("column type inferred as {} from this value", self.type_name(expected)),
                        LabelKind::Secondary,
                    )
                    .with_help(format!(
                        "all values in column '{}' must have the same type (row 1 set it to {})",
                        col_name,
                        self.type_name(expected),
                    ));
                    self.diagnostics.push(diag);
                }
            }
        }

        let struct_type = Type::Struct {
            name: None,
            fields: col_types,
        };
        Type::List(Box::new(struct_type))
    }

    /// Check if two types are compatible (for table column validation).
    /// Extends the core types_compatible with Int/Float numeric coercion.
    fn table_types_compatible(&self, expected: &Type, actual: &Type) -> bool {
        if expected == actual {
            return true;
        }
        // Unknown is compatible with anything
        if matches!(expected, Type::Unknown) || matches!(actual, Type::Unknown) {
            return true;
        }
        // Int and Float are compatible in numeric columns
        if matches!((expected, actual), (Type::Int, Type::Float) | (Type::Float, Type::Int)) {
            return true;
        }
        false
    }

    /// Human-readable type name for error messages.
    fn type_name(&self, ty: &Type) -> String {
        match ty {
            Type::Int => "int".to_string(),
            Type::Float => "float".to_string(),
            Type::String => "string".to_string(),
            Type::Bool => "bool".to_string(),
            Type::Void => "void".to_string(),
            Type::Unknown => "unknown".to_string(),
            Type::Nullable(inner) => format!("{}?", self.type_name(inner)),
            Type::List(inner) => format!("List<{}>", self.type_name(inner)),
            Type::Struct { name: Some(n), .. } => n.clone(),
            Type::Struct { name: None, fields } => {
                let fs: Vec<String> = fields.iter().map(|(n, t)| format!("{}: {}", n, self.type_name(t))).collect();
                format!("{{{}}}", fs.join(", "))
            }
            _ => format!("{:?}", ty),
        }
    }
}
