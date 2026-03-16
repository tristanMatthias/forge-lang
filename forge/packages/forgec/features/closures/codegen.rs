use inkwell::types::BasicMetadataTypeEnum;
use inkwell::values::BasicValueEnum;
use std::collections::{HashMap, HashSet};
use crate::codegen::codegen::Codegen;
use crate::feature::FeatureExpr;
use crate::{feature_codegen, feature_data};
use crate::parser::ast::*;
use crate::typeck::types::Type;

use super::types::ClosureData;

/// Collect all free variable names referenced in an expression (identifiers that
/// aren't bound by the expression itself).
fn collect_free_vars(expr: &Expr, free: &mut HashSet<String>) {
    match expr {
        Expr::Ident(name, _) => { free.insert(name.clone()); }
        Expr::Binary { left, right, .. } => {
            collect_free_vars(left, free);
            collect_free_vars(right, free);
        }
        Expr::Unary { operand, .. } => collect_free_vars(operand, free),
        Expr::Call { callee, args, .. } => {
            collect_free_vars(callee, free);
            for arg in args { collect_free_vars(&arg.value, free); }
        }
        Expr::MemberAccess { object, .. } => collect_free_vars(object, free),
        Expr::Index { object, index, .. } => {
            collect_free_vars(object, free);
            collect_free_vars(index, free);
        }
        Expr::Block(block) => {
            for stmt in &block.statements {
                collect_free_vars_stmt(stmt, free);
            }
        }
        Expr::TemplateLit { parts, .. } => {
            for part in parts {
                if let TemplatePart::Expr(e) = part { collect_free_vars(e, free); }
            }
        }
        Expr::Feature(fe) => {
            // Recurse into feature data expressions
            if let Some(data) = feature_data!(fe, ClosureData) {
                collect_free_vars(&data.body, free);
            }
            if let Some(data) = feature_data!(fe, crate::features::if_else::types::IfData) {
                collect_free_vars(&data.condition, free);
                for stmt in &data.then_branch.statements { collect_free_vars_stmt(stmt, free); }
                if let Some(eb) = &data.else_branch {
                    for stmt in &eb.statements { collect_free_vars_stmt(stmt, free); }
                }
            }
            if let Some(data) = feature_data!(fe, crate::features::pattern_matching::types::MatchData) {
                collect_free_vars(&data.subject, free);
                for arm in &data.arms {
                    collect_free_vars(&arm.body, free);
                    if let Some(g) = &arm.guard { collect_free_vars(g, free); }
                }
            }
            if let Some(data) = feature_data!(fe, crate::features::structs::types::StructLitData) {
                for (_, e) in &data.fields { collect_free_vars(e, free); }
            }
            if let Some(data) = feature_data!(fe, crate::features::collections::types::ListLitData) {
                for e in &data.elements { collect_free_vars(e, free); }
            }
            if let Some(data) = feature_data!(fe, crate::features::tuples::types::TupleLitData) {
                for e in &data.elements { collect_free_vars(e, free); }
            }
        }
        _ => {}
    }
}

fn collect_free_vars_stmt(stmt: &Statement, free: &mut HashSet<String>) {
    match stmt {
        Statement::Expr(e) => collect_free_vars(e, free),
        Statement::Return { value, .. } => {
            if let Some(v) = value { collect_free_vars(v, free); }
        }
        _ => {}
    }
}

impl<'ctx> Codegen<'ctx> {
    pub(crate) fn compile_closure_inline(
        &mut self,
        closure_arg: &crate::parser::ast::CallArg,
        elem_val: BasicValueEnum<'ctx>,
        elem_type: &crate::typeck::types::Type,
    ) -> Option<BasicValueEnum<'ctx>> {
        let (params, body) = Self::extract_closure_parts(&closure_arg.value)?;
        self.push_scope();
        let param_name = &params[0].name;
        let alloca = self.create_entry_block_alloca(elem_type, param_name);
        self.builder.build_store(alloca, elem_val).unwrap();
        self.define_var(param_name.clone(), alloca, elem_type.clone());
        let result = self.compile_expr(body);
        self.pop_scope();
        result
    }

    /// Compile a 2-arg closure inline (for reduce)
    pub(crate) fn compile_closure_inline_2(
        &mut self,
        closure_arg: &crate::parser::ast::CallArg,
        acc_val: BasicValueEnum<'ctx>,
        acc_type: &crate::typeck::types::Type,
        elem_val: BasicValueEnum<'ctx>,
        elem_type: &crate::typeck::types::Type,
    ) -> Option<BasicValueEnum<'ctx>> {
        let (params, body) = Self::extract_closure_parts(&closure_arg.value)?;
        self.push_scope();
        if params.len() >= 2 {
            let acc_name = &params[0].name;
            let elem_name = &params[1].name;
            let alloca1 = self.create_entry_block_alloca(acc_type, acc_name);
            self.builder.build_store(alloca1, acc_val).unwrap();
            self.define_var(acc_name.clone(), alloca1, acc_type.clone());
            let alloca2 = self.create_entry_block_alloca(elem_type, elem_name);
            self.builder.build_store(alloca2, elem_val).unwrap();
            self.define_var(elem_name.clone(), alloca2, elem_type.clone());
        }
        let result = self.compile_expr(body);
        self.pop_scope();
        result
    }

    /// Extract closure params and body from a Feature("closures") expression.
    fn extract_closure_parts(expr: &crate::parser::ast::Expr) -> Option<(&[crate::parser::ast::Param], &crate::parser::ast::Expr)> {
        match expr {
            crate::parser::ast::Expr::Feature(fe) if fe.feature_id == "closures" => {
                let data = fe.data.as_any().downcast_ref::<crate::features::closures::types::ClosureData>()?;
                Some((data.params.as_slice(), data.body.as_ref()))
            }
            _ => None,
        }
    }

    /// Compile a closure via Feature dispatch.
    pub(crate) fn compile_closure_feature(
        &mut self,
        fe: &FeatureExpr,
    ) -> Option<BasicValueEnum<'ctx>> {
        feature_codegen!(self, fe, ClosureData, |data| self.compile_closure(&data.params, &data.body))
    }

    /// Compile a closure expression into an anonymous function, returning a function pointer.
    pub(crate) fn compile_closure(
        &mut self,
        params: &[Param],
        body: &Expr,
    ) -> Option<BasicValueEnum<'ctx>> {
        // For simple closures, create an anonymous function
        let closure_name = format!("__closure_{}", self.functions.len());

        let param_types: Vec<Type> = params
            .iter()
            .map(|p| {
                p.type_ann
                    .as_ref()
                    .map(|t| self.type_checker.resolve_type_expr(t))
                    .unwrap_or(Type::Int) // default to int for untyped closures
            })
            .collect();

        // Collect free variables referenced in the body (excluding params and builtins)
        let param_names: HashSet<String> = params.iter().map(|p| p.name.clone()).collect();
        let builtin_names = crate::registry::BuiltinFnRegistry::all_names();
        let mut builtins: HashSet<&str> = builtin_names.into_iter().collect();
        for ns in inventory::iter::<crate::registry::BuiltinNamespace>.into_iter() {
            builtins.insert(ns.name);
        }
        let mut free_vars = HashSet::new();
        collect_free_vars(body, &mut free_vars);
        // Remove params and builtins
        free_vars.retain(|name| !param_names.contains(name) && !builtins.contains(name.as_str()));

        // While still in the parent function, load captured variable values and record their types
        let mut captured: Vec<(String, BasicValueEnum<'ctx>, Type)> = Vec::new();
        for var_name in &free_vars {
            if let Some((ptr, ty)) = self.lookup_var(var_name) {
                let llvm_ty = self.type_to_llvm_basic(&ty);
                let val = self.builder.build_load(llvm_ty, ptr, &format!("cap_{}", var_name)).unwrap();
                captured.push((var_name.clone(), val, ty));
            }
        }

        // Store captured values in globals so the closure function can access them
        // (closures are separate LLVM functions, can't directly use parent allocas)
        for (name, val, ty) in &captured {
            let global_name = format!("__capture_{}_{}", closure_name, name);
            let llvm_ty = self.type_to_llvm_basic(ty);
            if self.module.get_global(&global_name).is_none() {
                let global = self.module.add_global(llvm_ty, None, &global_name);
                global.set_initializer(&llvm_ty.const_zero());
            }
            let global = self.module.get_global(&global_name).unwrap();
            self.builder.build_store(global.as_pointer_value(), *val).unwrap();
        }

        let llvm_param_types: Vec<BasicMetadataTypeEnum<'ctx>> = param_types
            .iter()
            .map(|t| self.type_to_llvm_metadata(t))
            .collect();

        // Infer the return type by analyzing the body with closure params in context.
        // Build a map of param names → types so we can resolve idents in the body.
        let param_name_types: std::collections::HashMap<String, Type> = params
            .iter()
            .zip(param_types.iter())
            .map(|(p, t)| (p.name.clone(), t.clone()))
            .collect();
        let ret_type_resolved = self.infer_closure_body_type(body, &param_name_types);
        let fn_type = if ret_type_resolved == Type::Void {
            self.context.void_type().fn_type(&llvm_param_types, false)
        } else {
            let ret_llvm = self.type_to_llvm_basic(&ret_type_resolved);
            match ret_llvm {
                inkwell::types::BasicTypeEnum::IntType(t) => t.fn_type(&llvm_param_types, false),
                inkwell::types::BasicTypeEnum::FloatType(t) => t.fn_type(&llvm_param_types, false),
                inkwell::types::BasicTypeEnum::StructType(t) => t.fn_type(&llvm_param_types, false),
                inkwell::types::BasicTypeEnum::PointerType(t) => t.fn_type(&llvm_param_types, false),
                inkwell::types::BasicTypeEnum::ArrayType(t) => t.fn_type(&llvm_param_types, false),
                inkwell::types::BasicTypeEnum::VectorType(t) => t.fn_type(&llvm_param_types, false),
            }
        };
        let function = self.module.add_function(&closure_name, fn_type, None);
        self.functions.insert(closure_name.clone(), function);

        // Save current state
        let saved_block = self.builder.get_insert_block();

        let entry = self.context.append_basic_block(function, "entry");
        self.builder.position_at_end(entry);

        self.push_scope();

        // Load captured variables from globals into local allocas in the closure function
        for (name, _val, ty) in &captured {
            let global_name = format!("__capture_{}_{}", closure_name, name);
            let llvm_ty = self.type_to_llvm_basic(ty);
            let global = self.module.get_global(&global_name).unwrap();
            let loaded = self.builder.build_load(llvm_ty, global.as_pointer_value(), &format!("load_{}", name)).unwrap();
            let alloca = self.create_entry_block_alloca(ty, name);
            self.builder.build_store(alloca, loaded).unwrap();
            self.define_var(name.clone(), alloca, ty.clone());
        }

        for (i, param) in params.iter().enumerate() {
            let param_val = function.get_nth_param(i as u32).unwrap();
            let ty = param_types[i].clone();
            let alloca = self.create_entry_block_alloca(&ty, &param.name);
            self.builder.build_store(alloca, param_val).unwrap();
            self.define_var(param.name.clone(), alloca, ty);
        }

        let ret_val = self.compile_expr(body);
        if let Some(val) = ret_val {
            self.builder.build_return(Some(&val)).unwrap();
        } else {
            self.builder.build_return(Some(&self.context.i64_type().const_zero())).unwrap();
        }
        self.pop_scope();

        // Restore position
        if let Some(block) = saved_block {
            self.builder.position_at_end(block);
        }

        Some(function.as_global_value().as_pointer_value().into())
    }

    /// Infer the return type of a closure body, given a map of param names → types.
    /// This resolves idents that refer to closure params without needing them in codegen scope.
    pub(crate) fn infer_closure_body_type(
        &self,
        body: &Expr,
        params: &HashMap<String, Type>,
    ) -> Type {
        match body {
            Expr::Ident(name, _) => {
                if let Some(ty) = params.get(name) {
                    ty.clone()
                } else {
                    self.infer_type(body)
                }
            }
            Expr::Block(block) => {
                if let Some(Statement::Expr(last)) = block.statements.last() {
                    self.infer_closure_body_type(last, params)
                } else {
                    Type::Void
                }
            }
            Expr::Feature(fe) if fe.feature_id == "if_else" => {
                if let Some(data) = crate::feature_data!(fe, crate::features::if_else::types::IfData) {
                    if let Some(Statement::Expr(last)) = data.then_branch.statements.last() {
                        self.infer_closure_body_type(last, params)
                    } else {
                        Type::Void
                    }
                } else {
                    Type::Void
                }
            }
            Expr::Binary { op, left, .. } => {
                match op {
                    BinaryOp::Eq | BinaryOp::NotEq | BinaryOp::Lt | BinaryOp::LtEq |
                    BinaryOp::Gt | BinaryOp::GtEq | BinaryOp::And | BinaryOp::Or => Type::Bool,
                    BinaryOp::Add | BinaryOp::Sub | BinaryOp::Mul | BinaryOp::Div | BinaryOp::Mod |
                    BinaryOp::BitAnd | BinaryOp::BitOr | BinaryOp::BitXor | BinaryOp::Shl | BinaryOp::Shr => {
                        let lt = self.infer_closure_body_type(left, params);
                        if lt == Type::Float { Type::Float }
                        else if lt == Type::String { Type::String }
                        else { Type::Int }
                    }
                }
            }
            Expr::Call { callee, .. } => {
                if let Expr::Ident(name, _) = callee.as_ref() {
                    if let Some(def) = crate::registry::BuiltinFnRegistry::get(name) {
                        let ret = def.return_type.to_type();
                        if ret != crate::typeck::types::Type::Unknown {
                            return ret;
                        }
                    }
                    self.infer_type(body)
                } else {
                    self.infer_type(body)
                }
            }
            // For anything else, fall back to infer_type (which may return Unknown → Int)
            _ => {
                let ty = self.infer_type(body);
                if ty == Type::Unknown { Type::Int } else { ty }
            }
        }
    }
}
