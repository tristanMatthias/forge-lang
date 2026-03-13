use inkwell::types::BasicMetadataTypeEnum;
use inkwell::values::BasicValueEnum;
use std::collections::HashMap;
use crate::codegen::codegen::Codegen;
use crate::parser::ast::*;
use crate::typeck::types::Type;

impl<'ctx> Codegen<'ctx> {
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
            Expr::If { then_branch, .. } => {
                if let Some(Statement::Expr(last)) = then_branch.statements.last() {
                    self.infer_closure_body_type(last, params)
                } else {
                    Type::Void
                }
            }
            Expr::Binary { op, left, .. } => {
                match op {
                    BinaryOp::Eq | BinaryOp::NotEq | BinaryOp::Lt | BinaryOp::LtEq |
                    BinaryOp::Gt | BinaryOp::GtEq | BinaryOp::And | BinaryOp::Or => Type::Bool,
                    BinaryOp::Add | BinaryOp::Sub | BinaryOp::Mul | BinaryOp::Div | BinaryOp::Mod => {
                        let lt = self.infer_closure_body_type(left, params);
                        if lt == Type::Float { Type::Float }
                        else if lt == Type::String { Type::String }
                        else { Type::Int }
                    }
                    _ => self.infer_closure_body_type(left, params),
                }
            }
            Expr::Call { callee, .. } => {
                if let Expr::Ident(name, _) = callee.as_ref() {
                    match name.as_str() {
                        "string" => Type::String,
                        "int" => Type::Int,
                        "float" => Type::Float,
                        "println" | "print" => Type::Void,
                        _ => self.infer_type(body),
                    }
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
