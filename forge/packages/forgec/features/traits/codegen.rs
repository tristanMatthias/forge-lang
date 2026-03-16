use std::collections::HashMap;

use inkwell::AddressSpace;
use inkwell::values::{BasicMetadataValueEnum, BasicValueEnum};
use inkwell::types::BasicMetadataTypeEnum;

use crate::codegen::codegen::{Codegen, ImplInfo, ImplMethodInfo, TraitInfo};
use crate::feature::FeatureStmt;
use crate::feature_data;
use crate::parser::ast::*;
use crate::typeck::types::Type;

use super::types::{ImplBlockData, TraitDeclData};

impl<'ctx> Codegen<'ctx> {
    /// Compile all impl block methods, including default methods from traits.
    /// Two-pass approach: first declare all functions, then compile all bodies.
    /// This ensures that method calls within impl bodies can resolve any sibling
    /// method (e.g., self.base_score() inside an overridden total_score()).
    pub(crate) fn compile_all_impl_methods(&mut self) {
        let impls = self.impls.clone();

        // Collect all methods to compile: (mangled_name, resolved_params, return_type, body)
        let mut methods_to_compile: Vec<(String, Vec<Param>, Option<TypeExpr>, Block)> = Vec::new();

        for impl_info in &impls {
            let type_name = &impl_info.type_name;
            let self_type = self.resolve_named_type(type_name);

            // Pass 1a: Declare explicit impl methods
            for (method_name, method_info) in &impl_info.methods {
                let mangled = format!("{}_{}", type_name, method_name);

                let mut resolved_params = Vec::new();
                for p in &method_info.params {
                    if p.name == "self" {
                        resolved_params.push(Param {
                            name: "self".to_string(),
                            type_ann: Some(self.type_to_type_expr(&self_type)),
                            default: None,
                            span: p.span,
                            mutable: p.mutable,
                        });
                    } else {
                        let mut param = p.clone();
                        if let Some(ref type_ann) = p.type_ann {
                            param.type_ann = Some(self.resolve_impl_type_expr(type_ann, type_name, &impl_info.associated_types));
                        }
                        resolved_params.push(param);
                    }
                }

                self.declare_function(&mangled, &resolved_params, method_info.return_type.as_ref());
                methods_to_compile.push((mangled, resolved_params, method_info.return_type.clone(), method_info.body.clone()));
            }

            // Pass 1b: Declare default methods from the trait if not overridden
            if let Some(ref trait_name) = impl_info.trait_name {
                if let Some(trait_info) = self.traits.get(trait_name).cloned() {
                    for trait_method in &trait_info.methods {
                        if !impl_info.methods.contains_key(&trait_method.name) {
                            if let Some(ref default_body) = trait_method.default_body {
                                let mangled = format!("{}_{}", type_name, trait_method.name);
                                let mut resolved_params = Vec::new();
                                for p in &trait_method.params {
                                    if p.name == "self" {
                                        resolved_params.push(Param {
                                            name: "self".to_string(),
                                            type_ann: Some(self.type_to_type_expr(&self_type)),
                                            default: None,
                                            span: p.span,
                                            mutable: p.mutable,
                                        });
                                    } else {
                                        resolved_params.push(p.clone());
                                    }
                                }
                                self.declare_function(&mangled, &resolved_params, trait_method.return_type.as_ref());
                                methods_to_compile.push((mangled, resolved_params, trait_method.return_type.clone(), default_body.clone()));
                            }
                        }
                    }
                }
            }
        }

        // Pass 2: Compile all method bodies (all functions are now declared)
        for (mangled, resolved_params, return_type, body) in &methods_to_compile {
            self.compile_fn(mangled, resolved_params, return_type.as_ref(), body);
        }
    }

    /// Generate vtables for all (trait, type) impl pairs.
    /// Each vtable is a global constant struct of function pointers.
    pub(crate) fn generate_vtables(&mut self) {
        let impls = self.impls.clone();
        let traits = self.traits.clone();

        for impl_info in &impls {
            if let Some(ref trait_name) = impl_info.trait_name {
                if let Some(trait_info) = traits.get(trait_name) {
                    let type_name = &impl_info.type_name;
                    let vtable_name = format!("__vtable_{}_for_{}", trait_name, type_name);

                    // Collect function pointers in trait method order
                    let mut fn_ptrs = Vec::new();
                    for tm in &trait_info.methods {
                        let mangled = format!("{}_{}", type_name, tm.name);
                        if let Some(func) = self.functions.get(&mangled) {
                            fn_ptrs.push(func.as_global_value().as_pointer_value());
                        }
                    }

                    if fn_ptrs.len() == trait_info.methods.len() {
                        let ptr_type = self.context.ptr_type(inkwell::AddressSpace::default());
                        let vtable_type = self.context.struct_type(
                            &vec![ptr_type.into(); fn_ptrs.len()],
                            false,
                        );
                        let vtable_global = self.module.add_global(vtable_type, None, &vtable_name);

                        let mut vtable_init = vtable_type.get_undef();
                        for (i, fp) in fn_ptrs.iter().enumerate() {
                            vtable_init = self.builder.build_insert_value(vtable_init, *fp, i as u32, "vt")
                                .unwrap().into_struct_value();
                        }
                        vtable_global.set_initializer(&vtable_init);
                        vtable_global.set_constant(true);
                    }
                }
            }
        }
    }

    /// Create a fat pointer {data_ptr, vtable_ptr} for a trait object assignment.
    /// Called when assigning a concrete type to a trait-typed variable.
    pub(crate) fn build_trait_fat_pointer(
        &mut self,
        concrete_val: BasicValueEnum<'ctx>,
        concrete_type: &Type,
        trait_name: &str,
    ) -> Option<BasicValueEnum<'ctx>> {
        let type_name = self.get_type_name(concrete_type)?;
        let vtable_name = format!("__vtable_{}_for_{}", trait_name, type_name);
        let vtable_global = self.module.get_global(&vtable_name)?;

        let ptr_type = self.context.ptr_type(inkwell::AddressSpace::default());

        // Allocate heap space for the concrete value and store it
        let concrete_llvm_type = self.type_to_llvm_basic(concrete_type);
        let slots = self.type_i64_slots(concrete_type) as u64;
        let size = self.context.i64_type().const_int(slots * 8, false);
        let data_ptr = self.builder.build_call(
            self.module.get_function("malloc").unwrap_or_else(|| {
                let malloc_type = ptr_type.fn_type(&[self.context.i64_type().into()], false);
                self.module.add_function("malloc", malloc_type, None)
            }),
            &[size.into()],
            "trait_data",
        ).unwrap().try_as_basic_value().left()?.into_pointer_value();

        self.builder.build_store(data_ptr, concrete_val).unwrap();

        // Build the fat pointer struct { data_ptr, vtable_ptr }
        let fat_ptr_type = self.context.struct_type(&[ptr_type.into(), ptr_type.into()], false);
        let mut fat_ptr = fat_ptr_type.get_undef();
        fat_ptr = self.builder.build_insert_value(fat_ptr, data_ptr, 0, "fp_data")
            .unwrap().into_struct_value();
        fat_ptr = self.builder.build_insert_value(fat_ptr, vtable_global.as_pointer_value(), 1, "fp_vtable")
            .unwrap().into_struct_value();

        Some(fat_ptr.into())
    }

    /// Dispatch a method call on a trait object (fat pointer).
    /// Extracts the vtable, finds the method function pointer, and calls it.
    pub(crate) fn dispatch_dyn_trait_method(
        &mut self,
        fat_ptr: BasicValueEnum<'ctx>,
        trait_name: &str,
        method: &str,
        args: &[CallArg],
    ) -> Option<BasicValueEnum<'ctx>> {
        let traits = self.traits.clone();
        let trait_info = traits.get(trait_name)?;

        // Find method index in the trait
        let method_idx = trait_info.methods.iter().position(|m| m.name == method)?;

        let struct_val = fat_ptr.into_struct_value();

        // Extract data_ptr and vtable_ptr
        let data_ptr = self.builder.build_extract_value(struct_val, 0, "data_ptr")
            .unwrap().into_pointer_value();
        let vtable_ptr = self.builder.build_extract_value(struct_val, 1, "vtable_ptr")
            .unwrap().into_pointer_value();

        // Load the function pointer from the vtable
        let ptr_type = self.context.ptr_type(inkwell::AddressSpace::default());
        let vtable_elem_ptr = unsafe {
            self.builder.build_gep(ptr_type, vtable_ptr, &[self.context.i64_type().const_int(method_idx as u64, false)], "vt_elem")
                .unwrap()
        };
        let fn_ptr = self.builder.build_load(ptr_type, vtable_elem_ptr, "fn_ptr")
            .unwrap().into_pointer_value();

        // Build call args: data_ptr (as self), then user args
        let mut call_args: Vec<BasicMetadataValueEnum> = vec![data_ptr.into()];
        for arg in args {
            if let Some(val) = self.compile_expr(&arg.value) {
                call_args.push(val.into());
            }
        }

        // Determine return type for the function signature
        let ret_method = &trait_info.methods[method_idx];
        let ret_type = ret_method.return_type.as_ref()
            .map(|t| self.type_checker.resolve_type_expr(t))
            .unwrap_or(Type::Void);

        // Find a sample concrete function to get its type signature
        let impls = self.impls.clone();
        let sample_fn = impls.iter()
            .filter(|i| i.trait_name.as_deref() == Some(trait_name))
            .find_map(|i| {
                let mangled = format!("{}_{}", i.type_name, method);
                self.functions.get(&mangled).copied()
            });

        let sample = sample_fn?;

        // Load the concrete self value from data_ptr using the sample function's self type
        let self_type = sample.get_first_param()?.get_type();
        let loaded_self = self.builder.build_load(self_type, data_ptr, "loaded_self").unwrap();

        let mut call_args: Vec<BasicMetadataValueEnum> = vec![loaded_self.into()];
        for arg in args {
            if let Some(val) = self.compile_expr(&arg.value) {
                call_args.push(val.into());
            }
        }

        // Use the sample function's type for the indirect call
        let fn_type = sample.get_type();

        let result = self.builder.build_indirect_call(fn_type, fn_ptr, &call_args, "dyn_call")
            .unwrap();
        result.try_as_basic_value().left()
    }

    /// Convert a Type back to a TypeExpr for use in param declarations
    pub(crate) fn type_to_type_expr(&self, ty: &Type) -> TypeExpr {
        match ty {
            Type::Int => TypeExpr::Named("int".to_string()),
            Type::Float => TypeExpr::Named("float".to_string()),
            Type::Bool => TypeExpr::Named("bool".to_string()),
            Type::String => TypeExpr::Named("string".to_string()),
            Type::Void => TypeExpr::Named("void".to_string()),
            Type::Struct { name: Some(n), .. } => {
                // Use the named type so resolution preserves the name
                TypeExpr::Named(n.clone())
            }
            Type::Struct { name: None, fields } => {
                TypeExpr::Struct {
                    fields: fields.iter().map(|(fname, fty)| StructFieldDef { name: fname.clone(), type_expr: self.type_to_type_expr(fty), annotations: Vec::new(), mutable: false }).collect(),
                }
            }
            Type::List(inner) => TypeExpr::Generic {
                name: "List".to_string(),
                args: vec![self.type_to_type_expr(inner)],
            },
            Type::Nullable(inner) => TypeExpr::Nullable(Box::new(self.type_to_type_expr(inner))),
            Type::Tuple(elems) => TypeExpr::Tuple(elems.iter().map(|e| self.type_to_type_expr(e)).collect()),
            _ => TypeExpr::Named("int".to_string()), // fallback
        }
    }

    /// Resolve a type expression in the context of an impl block
    pub(crate) fn resolve_impl_type_expr(&self, type_expr: &TypeExpr, type_name: &str, associated_types: &[(String, TypeExpr)]) -> TypeExpr {
        match type_expr {
            TypeExpr::Named(name) => {
                if name == type_name {
                    // Self-referencing type - resolve to the actual struct
                    if let Some(ty) = self.named_types.get(name) {
                        self.type_to_type_expr(ty)
                    } else {
                        type_expr.clone()
                    }
                } else {
                    // Check associated types
                    for (assoc_name, assoc_type) in associated_types {
                        if name == assoc_name {
                            return assoc_type.clone();
                        }
                    }
                    type_expr.clone()
                }
            }
            _ => type_expr.clone(),
        }
    }

    /// Resolve a type name to its full Type
    pub(crate) fn resolve_named_type(&self, name: &str) -> Type {
        if let Some(ty) = self.named_types.get(name) {
            ty.clone()
        } else if let Some(ty) = self.type_checker.env.type_aliases.get(name) {
            match ty {
                Type::Struct { fields, name: None } => Type::Struct {
                    name: Some(name.to_string()),
                    fields: fields.clone(),
                },
                other => other.clone(),
            }
        } else {
            match name {
                "int" => Type::Int,
                "float" => Type::Float,
                "bool" => Type::Bool,
                "string" => Type::String,
                _ => Type::Unknown,
            }
        }
    }

    /// Look up an impl method for a given type and method name
    pub(crate) fn find_impl_method(&self, type_name: &str, method_name: &str) -> Option<String> {
        let mangled = format!("{}_{}", type_name, method_name);
        if self.functions.contains_key(&mangled) {
            return Some(mangled);
        }
        // Also check impls registry
        for impl_info in &self.impls {
            if impl_info.type_name == type_name && impl_info.methods.contains_key(method_name) {
                return Some(mangled);
            }
            // Check default methods from trait
            if impl_info.type_name == type_name {
                if let Some(ref trait_name) = impl_info.trait_name {
                    if let Some(trait_info) = self.traits.get(trait_name) {
                        for tm in &trait_info.methods {
                            if tm.name == method_name && tm.default_body.is_some() {
                                return Some(mangled);
                            }
                        }
                    }
                }
            }
        }
        None
    }

    /// Find operator trait impl for a type: given type_name and op (Add, Sub, etc), return mangled method name
    pub(crate) fn find_operator_impl(&self, type_name: &str, trait_name: &str, method_name: &str) -> Option<String> {
        for impl_info in &self.impls {
            if impl_info.type_name == type_name {
                if let Some(ref tn) = impl_info.trait_name {
                    if tn == trait_name {
                        let mangled = format!("{}_{}", type_name, method_name);
                        return Some(mangled);
                    }
                }
            }
        }
        None
    }

    /// Get the type name from a Type
    pub(crate) fn get_type_name(&self, ty: &Type) -> Option<String> {
        match ty {
            Type::Struct { name: Some(n), .. } => Some(n.clone()),
            Type::Int => Some("int".to_string()),
            Type::Float => Some("float".to_string()),
            Type::Bool => Some("bool".to_string()),
            Type::String => Some("string".to_string()),
            _ => None,
        }
    }

    /// Compile trait/impl feature stmts (no-op — handled by compile_program).
    pub(crate) fn compile_traits_feature(&mut self, _fe: &FeatureStmt) {
        // Trait/impl blocks are handled in compile_program's first pass
    }

    /// Handle trait feature stmts in compile_program's first pass.
    pub(crate) fn compile_program_traits_feature(&mut self, fe: &FeatureStmt) {
        match fe.kind {
            "TraitDecl" => {
                if let Some(data) = feature_data!(fe, TraitDeclData) {
                    self.traits.insert(data.name.clone(), TraitInfo {
                        methods: data.methods.clone(),
                    });
                }
            }
            "ImplBlock" => {
                if let Some(data) = feature_data!(fe, ImplBlockData) {
                    let mut method_map = HashMap::new();
                    for m in &data.methods {
                        if let Statement::FnDecl { name, params, return_type, body, .. } = m {
                            method_map.insert(name.clone(), ImplMethodInfo {
                                params: params.clone(),
                                return_type: return_type.clone(),
                                body: body.clone(),
                            });
                        }
                    }
                    self.impls.push(ImplInfo {
                        trait_name: data.trait_name.clone(),
                        type_name: data.type_name.clone(),
                        methods: method_map,
                        associated_types: data.associated_types.clone(),
                    });
                }
            }
            _ => {}
        }
    }
}
