use crate::errors::Diagnostic;
use crate::feature::FeatureExpr;
use crate::feature_data;
use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;

use super::types::TaggedTemplateData;

impl TypeChecker {
    /// Type-check a tagged template via the Feature dispatch system.
    pub(crate) fn check_tagged_template_feature(&mut self, fe: &FeatureExpr) -> Type {
        if let Some(data) = feature_data!(fe, TaggedTemplateData) {
            let base_type = self.check_tagged_template(&data.tag, &data.parts, &fe.span);
            if let Some(tp) = &data.type_param {
                self.resolve_type_expr(tp)
            } else {
                base_type
            }
        } else {
            Type::Unknown
        }
    }

    /// Type-check a tagged template literal: `tag\`template ${expr}\``
    ///
    /// Checks that the tag function exists, has the right signature (exactly 1 string param),
    /// and validates all interpolated expressions.
    /// Returns the return type of the tag function.
    pub(crate) fn check_tagged_template(
        &mut self,
        tag: &str,
        parts: &[TemplatePart],
        span: &crate::lexer::Span,
    ) -> Type {
        // Check all interpolated expressions and validate they can be stringified
        for part in parts {
            if let TemplatePart::Expr(e) = part {
                let expr_ty = self.check_expr(e);
                match &expr_ty {
                    Type::Int | Type::Float | Type::Bool | Type::String
                    | Type::Unknown | Type::Error => {}
                    Type::Nullable(_) => {
                        let ty_str = format_type(&expr_ty);
                        self.diagnostics.push(
                            Diagnostic::error(
                                "F0012",
                                format!(
                                    "cannot interpolate nullable type '{}' in tagged template — unwrap it first",
                                    ty_str
                                ),
                                e.span(),
                            )
                            .with_help("use ?? to provide a default: ${value ?? \"default\"}")
                        );
                    }
                    Type::Enum { name, .. } => {
                        self.diagnostics.push(
                            Diagnostic::error(
                                "F0012",
                                format!(
                                    "cannot interpolate enum type '{}' in tagged template — match it to a string first",
                                    name
                                ),
                                e.span(),
                            )
                            .with_help(format!(
                                "convert the enum to a string with match:\n  match value {{ {}.Variant -> \"name\" }}",
                                name
                            ))
                        );
                    }
                    other => {
                        let ty_str = format_type(other);
                        self.diagnostics.push(
                            Diagnostic::error(
                                "F0012",
                                format!(
                                    "cannot interpolate type '{}' in tagged template — only string, int, float, and bool can be interpolated",
                                    ty_str
                                ),
                                e.span(),
                            )
                            .with_help("convert the value to a string first: string(value) or json.stringify(value)")
                        );
                    }
                }
            }
        }

        // Look up the tag function
        let fn_type = if let Some(fn_ty) = self.env.lookup_function(tag) {
            Some(fn_ty.clone())
        } else if let Some(info) = self.env.lookup(tag) {
            Some(info.ty.clone())
        } else {
            None
        };

        match fn_type {
            Some(Type::Function { params, return_type }) => {
                // Validate: tag function must accept exactly 1 argument
                if params.len() != 1 {
                    self.diagnostics.push(
                        Diagnostic::error(
                            "F0014",
                            format!(
                                "tagged template function '{}' expects 1 argument (the template JSON), but it takes {}",
                                tag, params.len()
                            ),
                            *span,
                        )
                        .with_help(format!(
                            "a tagged template function must have the signature: fn {}(input: string) -> T",
                            tag
                        ))
                        .with_tip(format!(
                            "tagged templates desugar to {}(\"{{\\\"parts\\\":[...],\\\"values\\\":[...]}}\") — \
                            the function receives a single JSON string with the template parts and interpolated values separated",
                            tag
                        ))
                    );
                    return *return_type;
                }
                // Validate: the parameter must be string (the JSON input)
                if params[0] != Type::String {
                    let param_ty = format_type(&params[0]);
                    self.diagnostics.push(
                        Diagnostic::error(
                            "F0012",
                            format!(
                                "tagged template function '{}' must take a string parameter, but it takes '{}'",
                                tag, param_ty
                            ),
                            *span,
                        )
                        .with_help(format!(
                            "change the parameter type to string: fn {}(input: string) -> {}",
                            tag, format_type(&return_type)
                        ))
                        .with_tip("tagged templates pass a JSON string with the template parts and interpolated values")
                    );
                }
                *return_type
            }
            Some(other_ty) => {
                // Found the name, but it's not a function
                let ty_name = match &other_ty {
                    Type::Int => "int",
                    Type::Float => "float",
                    Type::String => "string",
                    Type::Bool => "bool",
                    Type::Struct { .. } => "struct",
                    Type::List(_) => "list",
                    _ => "non-function",
                };
                self.diagnostics.push(
                    Diagnostic::error(
                        "F0012",
                        format!(
                            "'{}' is {} {}, not a function — it cannot be used as a template tag",
                            tag,
                            if matches!(ty_name, "int" | "struct") { "an" } else { "a" },
                            ty_name,
                        ),
                        *span,
                    )
                    .with_help(format!(
                        "a template tag must be a function with signature: fn {}(input: string) -> T\n  \
                        example:\n    fn {}(input: string) -> string {{\n      // input is JSON: {{\"parts\":[...],\"values\":[...]}}\n      input\n    }}",
                        tag, tag
                    ))
                );
                Type::Error
            }
            None => {
                // Not found anywhere — extern fns from providers are already registered
                // in env.functions by the time we reach here, so this is truly undefined.
                let scope_names = self.env.all_names_in_scope();
                let candidates: Vec<&str> = scope_names.iter().map(|s| s.as_str()).collect();
                let mut diag = Diagnostic::error(
                    "F0020",
                    format!("undefined tag function '{}'", tag),
                    *span,
                );
                if let Some(suggestion) = crate::errors::did_you_mean(tag, &candidates, 2) {
                    diag = diag.with_help(format!("did you mean '{}'?", suggestion));
                } else {
                    diag = diag.with_help(format!(
                        "define a tag function: fn {}(input: string) -> string {{ ... }}",
                        tag
                    ));
                }
                diag = diag.with_tip(format!(
                    "tagged templates desugar to {}(json) where json has the shape:\n  \
                    {{\"parts\":[\"literal\",\"parts\"],\"values\":[\"interpolated\",\"values\"]}}",
                    tag
                ));
                self.diagnostics.push(diag);
                Type::Error
            }
        }
    }
}

fn format_type(ty: &Type) -> String {
    match ty {
        Type::Int => "int".to_string(),
        Type::Float => "float".to_string(),
        Type::String => "string".to_string(),
        Type::Bool => "bool".to_string(),
        Type::Struct { name: Some(n), .. } => n.clone(),
        Type::Struct { fields, .. } => {
            let field_strs: Vec<String> = fields.iter().take(3)
                .map(|(n, t)| format!("{}: {}", n, format_type(t)))
                .collect();
            if fields.len() > 3 {
                format!("{{ {}, ... }}", field_strs.join(", "))
            } else {
                format!("{{ {} }}", field_strs.join(", "))
            }
        }
        Type::List(inner) => format!("list<{}>", format_type(inner)),
        Type::Tuple(elems) => {
            let s: Vec<String> = elems.iter().map(|t| format_type(t)).collect();
            format!("({})", s.join(", "))
        }
        Type::Nullable(inner) => format!("{}?", format_type(inner)),
        Type::Function { params, return_type } => {
            let p: Vec<String> = params.iter().map(|t| format_type(t)).collect();
            format!("fn({}) -> {}", p.join(", "), format_type(return_type))
        }
        Type::Enum { name, .. } => name.clone(),
        Type::Map(k, v) => format!("map<{}, {}>", format_type(k), format_type(v)),
        Type::Result(ok, err) => format!("result<{}, {}>", format_type(ok), format_type(err)),
        Type::Range(inner) => format!("range<{}>", format_type(inner)),
        Type::Void => "void".to_string(),
        Type::Ptr => "ptr".to_string(),
        Type::Error | Type::Unknown => "unknown".to_string(),
        _ => format!("{:?}", ty),
    }
}
