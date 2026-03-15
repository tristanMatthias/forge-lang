use std::collections::HashMap;

use crate::codegen::codegen::Codegen;
use crate::parser::ast::*;
use crate::typeck::types::Type;

impl<'ctx> Codegen<'ctx> {
    /// Monomorphize and compile a generic function for specific type arguments
    pub(crate) fn monomorphize_fn(&mut self, fn_name: &str, type_args: &[(&str, Type)]) -> Option<String> {
        let generic_fn = self.generic_fns.get(fn_name)?.clone();

        // Build mangled name
        let type_suffix: Vec<String> = type_args.iter().map(|(_, ty)| {
            match ty {
                Type::Int => "int".to_string(),
                Type::Float => "float".to_string(),
                Type::Bool => "bool".to_string(),
                Type::String => "string".to_string(),
                Type::Struct { name: Some(n), .. } => n.clone(),
                Type::List(inner) => format!("List_{}", match inner.as_ref() {
                    Type::Int => "int",
                    Type::Float => "float",
                    Type::String => "string",
                    _ => "unknown",
                }),
                _ => "unknown".to_string(),
            }
        }).collect();
        let mangled = format!("{}_{}", fn_name, type_suffix.join("_"));

        // Check if already monomorphized
        if self.monomorphized.contains(&mangled) {
            return Some(mangled);
        }
        self.monomorphized.insert(mangled.clone());

        // Build type substitution map
        let mut type_map: HashMap<String, Type> = HashMap::new();
        for (name, ty) in type_args {
            type_map.insert(name.to_string(), ty.clone());
        }

        // Substitute type params in the function's parameter types
        let mut resolved_params = Vec::new();
        for p in &generic_fn.params {
            let mut param = p.clone();
            if let Some(ref type_ann) = p.type_ann {
                param.type_ann = Some(self.substitute_type_expr(type_ann, &type_map));
            }
            resolved_params.push(param);
        }

        // Substitute in return type
        let resolved_return = generic_fn.return_type.as_ref().map(|rt| self.substitute_type_expr(rt, &type_map));

        // Save current builder position and scope (since compile_fn changes them)
        let saved_block = self.builder.get_insert_block();

        // Declare and compile the specialized function
        self.declare_function(&mangled, &resolved_params, resolved_return.as_ref());
        self.compile_fn(&mangled, &resolved_params, resolved_return.as_ref(), &generic_fn.body);

        // Restore builder position
        if let Some(block) = saved_block {
            self.builder.position_at_end(block);
        }

        Some(mangled)
    }

    /// Substitute type parameters in a TypeExpr
    pub(crate) fn substitute_type_expr(&self, type_expr: &TypeExpr, type_map: &HashMap<String, Type>) -> TypeExpr {
        match type_expr {
            TypeExpr::Named(name) => {
                if let Some(ty) = type_map.get(name) {
                    self.type_to_type_expr(ty)
                } else {
                    type_expr.clone()
                }
            }
            TypeExpr::Generic { name, args } => {
                let resolved_args: Vec<TypeExpr> = args.iter().map(|a| self.substitute_type_expr(a, type_map)).collect();
                TypeExpr::Generic { name: name.clone(), args: resolved_args }
            }
            TypeExpr::Nullable(inner) => {
                TypeExpr::Nullable(Box::new(self.substitute_type_expr(inner, type_map)))
            }
            TypeExpr::Tuple(elems) => {
                TypeExpr::Tuple(elems.iter().map(|e| self.substitute_type_expr(e, type_map)).collect())
            }
            _ => type_expr.clone(),
        }
    }

    /// Infer type arguments for a generic function call based on the argument types
    pub(crate) fn infer_type_args(&self, fn_name: &str, args: &[CallArg]) -> Option<Vec<(String, Type)>> {
        let generic_fn = self.generic_fns.get(fn_name)?;

        let mut type_map: HashMap<String, Type> = HashMap::new();

        for (i, param) in generic_fn.params.iter().enumerate() {
            if i >= args.len() { continue; }
            let arg_type = self.infer_type(&args[i].value);
            if let Some(ref type_ann) = param.type_ann {
                self.unify_type_expr(type_ann, &arg_type, &mut type_map);
            }
        }

        // Build result in order of type_params
        let result: Vec<(String, Type)> = generic_fn.type_params.iter()
            .map(|tp| {
                let ty = type_map.get(&tp.name).cloned().unwrap_or(Type::Unknown);
                (tp.name.clone(), ty)
            })
            .collect();

        Some(result)
    }

    /// Unify a TypeExpr against an actual Type, populating the type_map
    pub(crate) fn unify_type_expr(&self, type_expr: &TypeExpr, actual: &Type, type_map: &mut HashMap<String, Type>) {
        match type_expr {
            TypeExpr::Named(name) => {
                // If this is a type parameter name (single uppercase letter or in type params)
                if name.len() <= 2 && name.chars().next().map_or(false, |c| c.is_uppercase()) {
                    type_map.entry(name.clone()).or_insert(actual.clone());
                }
            }
            TypeExpr::Generic { name, args } => {
                if name == "List" {
                    if let Type::List(inner) = actual {
                        if let Some(first) = args.first() {
                            self.unify_type_expr(first, inner, type_map);
                        }
                    }
                }
            }
            TypeExpr::Nullable(inner) => {
                if let Type::Nullable(actual_inner) = actual {
                    self.unify_type_expr(inner, actual_inner, type_map);
                } else {
                    self.unify_type_expr(inner, actual, type_map);
                }
            }
            TypeExpr::Tuple(elems) => {
                if let Type::Tuple(actual_elems) = actual {
                    for (i, elem) in elems.iter().enumerate() {
                        if let Some(actual_elem) = actual_elems.get(i) {
                            self.unify_type_expr(elem, actual_elem, type_map);
                        }
                    }
                }
            }
            _ => {}
        }
    }
}
