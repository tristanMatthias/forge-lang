use crate::codegen::codegen::Codegen;
use crate::feature::FeatureStmt;
use crate::feature_data;
use crate::parser::ast::Expr;
use crate::typeck::types::Type;

use super::types::{LetDestructureData, VarDeclData};

impl<'ctx> Codegen<'ctx> {
    /// Compile a variable declaration (let/mut/const) via the Feature dispatch system.
    pub(crate) fn compile_variables_feature(&mut self, fe: &FeatureStmt) {
        match fe.kind {
            "Let" => {
                if let Some(data) = feature_data!(fe, VarDeclData) {
                    self.compile_let_var(data);
                }
            }
            "Mut" => {
                if let Some(data) = feature_data!(fe, VarDeclData) {
                    self.compile_mut_var(data);
                }
            }
            "Const" => {
                if let Some(data) = feature_data!(fe, VarDeclData) {
                    self.compile_const_var(data);
                }
            }
            "LetDestructure" => {
                if let Some(data) = feature_data!(fe, LetDestructureData) {
                    self.compile_let_destructure(&data.pattern, &data.value);
                }
            }
            _ => {}
        }
    }

    fn compile_let_var(&mut self, data: &VarDeclData) {
        // Set type hints from type annotation
        if let Some(ta) = &data.type_ann {
            let resolved = self.type_checker.resolve_type_expr(ta);
            self.json_parse_hint = Some(resolved.clone());
            if matches!(&resolved, Type::Struct { .. }) {
                self.struct_target_type = Some(resolved);
            }
        }
        // Handle `{}` parsed as empty block when type annotation says map
        let ann_type = data.type_ann.as_ref().map(|t| self.type_checker.resolve_type_expr(t));
        let val = if matches!(&ann_type, Some(Type::Map(_, _))) && matches!(&data.value, Expr::Block(b) if b.statements.is_empty()) {
            self.compile_map_lit(&[])
        } else if matches!(&ann_type, Some(Type::Ptr)) && matches!(&data.value, Expr::NullLit(_)) {
            // let n: ptr = null → null pointer
            Some(self.context.ptr_type(inkwell::AddressSpace::default()).const_null().into())
        } else {
            // When type annotation is ptr, suppress auto-wrapping ptr→ForgeString
            // so the raw C pointer is preserved (needed for forge_model_free_string etc.)
            if matches!(&ann_type, Some(Type::Ptr)) {
                self.suppress_string_wrap = true;
            }
            let val = self.compile_expr(&data.value);
            self.suppress_string_wrap = false;
            val
        };
        self.json_parse_hint = None;
        self.struct_target_type = None;
        if let Some(val) = val {
            let ty = data.type_ann
                .as_ref()
                .map(|t| self.type_checker.resolve_type_expr(t))
                .unwrap_or_else(|| {
                    if matches!(data.value, Expr::Block(_)) {
                        if let Some(ref bt) = self.last_block_result_type {
                            return bt.clone();
                        }
                    }
                    self.infer_type(&data.value)
                });
            let ty = if ty == Type::Unknown || ty == Type::Int {
                if val.is_struct_value() {
                    let string_type = self.string_type();
                    if val.into_struct_value().get_type() == string_type {
                        Type::String
                    } else {
                        ty
                    }
                } else if val.is_float_value() {
                    Type::Float
                } else {
                    ty
                }
            } else {
                ty
            };
            // If type annotation says ptr but value is ForgeString, extract the ptr
            let val = if ty == Type::Ptr && val.is_struct_value() {
                let string_type = self.string_type();
                if val.into_struct_value().get_type() == string_type {
                    self.builder.build_extract_value(
                        val.into_struct_value(), 0, "str_to_ptr"
                    ).unwrap()
                } else {
                    val
                }
            } else {
                val
            };
            // If target type is DynTrait, wrap in fat pointer
            let val = if let Type::DynTrait(ref trait_name) = ty {
                let concrete_type = self.infer_type(&data.value);
                self.build_trait_fat_pointer(val, &concrete_type, trait_name)
                    .unwrap_or(val)
            } else {
                val
            };
            // If declared type is nullable but value is non-nullable, wrap in nullable struct
            let val = self.maybe_wrap_nullable(val, &ty);
            let alloca = self.create_entry_block_alloca(&ty, &data.name);
            self.builder.build_store(alloca, val).unwrap();
            self.define_var(data.name.clone(), alloca, ty);
        }
    }

    fn compile_mut_var(&mut self, data: &VarDeclData) {
        // Skip global mutables - they are created in compile_program first pass
        if self.global_mutables.contains_key(&data.name) {
            // Global mutable: compile initializer and store it to the global
            if self.builder.get_insert_block().and_then(|b| b.get_parent()).is_some() {
                let global_ty = self.global_mutables.get(&data.name).cloned();
                let val = if matches!(&global_ty, Some(Type::Map(_, _))) && matches!(&data.value, Expr::Block(b) if b.statements.is_empty()) {
                    self.compile_map_lit(&[])
                } else {
                    self.compile_expr(&data.value)
                };
                if let Some(val) = val {
                    if let Some(global) = self.module.get_global(&data.name) {
                        self.builder.build_store(global.as_pointer_value(), val).unwrap();
                    }
                }
            }
            return;
        }
        // Handle `{}` parsed as empty block when type annotation says map
        let ann_type = data.type_ann.as_ref().map(|t| self.type_checker.resolve_type_expr(t));
        let val = if matches!(&ann_type, Some(Type::Map(_, _))) && matches!(&data.value, Expr::Block(b) if b.statements.is_empty()) {
            self.compile_map_lit(&[])
        } else {
            self.compile_expr(&data.value)
        };
        if let Some(val) = val {
            let ty = data.type_ann
                .as_ref()
                .map(|t| self.type_checker.resolve_type_expr(t))
                .unwrap_or_else(|| self.infer_type(&data.value));
            // If declared type is nullable but value is non-nullable, wrap in nullable struct
            let val = self.maybe_wrap_nullable(val, &ty);
            let alloca = self.create_entry_block_alloca(&ty, &data.name);
            self.builder.build_store(alloca, val).unwrap();
            self.define_var(data.name.clone(), alloca, ty);
        }
    }

    fn compile_const_var(&mut self, data: &VarDeclData) {
        let val = self.compile_expr(&data.value);
        if let Some(val) = val {
            let ty = data.type_ann
                .as_ref()
                .map(|t| self.type_checker.resolve_type_expr(t))
                .unwrap_or_else(|| self.infer_type(&data.value));
            // If declared type is nullable but value is non-nullable, wrap in nullable struct
            let val = self.maybe_wrap_nullable(val, &ty);
            let alloca = self.create_entry_block_alloca(&ty, &data.name);
            self.builder.build_store(alloca, val).unwrap();
            self.define_var(data.name.clone(), alloca, ty);
        }
    }

    /// Handle variable feature stmts in compile_program's first pass.
    pub(crate) fn compile_program_variables_feature(&mut self, fe: &FeatureStmt) {
        match fe.kind {
            "Mut" => {
                if let Some(data) = feature_data!(fe, VarDeclData) {
                    let ty = data.type_ann
                        .as_ref()
                        .map(|t| self.type_checker.resolve_type_expr(t))
                        .unwrap_or_else(|| self.infer_type(&data.value));
                    let llvm_ty = self.type_to_llvm_basic(&ty);
                    let global = self.module.add_global(llvm_ty, None, &data.name);
                    global.set_initializer(&llvm_ty.const_zero());
                    self.global_mutables.insert(data.name.clone(), ty);
                }
            }
            _ => {}
        }
    }
}
