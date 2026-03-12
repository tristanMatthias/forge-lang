use inkwell::builder::Builder;
use inkwell::context::Context;
use inkwell::module::Module;
use inkwell::targets::{
    CodeModel, FileType, InitializationConfig, RelocMode, Target, TargetMachine,
};
use inkwell::types::{BasicMetadataTypeEnum, BasicType, BasicTypeEnum, StructType};
use inkwell::values::{
    BasicMetadataValueEnum, BasicValue, BasicValueEnum, FunctionValue, IntValue, PointerValue,
};
use inkwell::AddressSpace;
use inkwell::IntPredicate;
use inkwell::OptimizationLevel;

use crate::driver::driver::{ExportedSymbol, ResolvedImport};
use crate::parser::ast::*;
use crate::typeck::checker::TypeChecker;
use crate::typeck::types::Type;
use std::collections::{HashMap, HashSet};
use std::path::Path;

mod collections;
mod control_flow;
mod errors;
mod expressions;
mod extern_ffi;
mod json;
mod linker;
mod literals;
mod nullability;
mod pattern_match;
mod runtime;
mod scope;
mod statements;
mod strings;
mod traits;
mod types;

/// Information about a service declaration (used by component_expand for mount resolution)
#[derive(Debug, Clone)]
pub struct ServiceInfo {
    pub name: String,
    pub for_model: String,
    pub hooks: Vec<ServiceHook>,
    pub methods: Vec<Statement>,
}

/// Information about a trait declaration
#[derive(Debug, Clone)]
pub(crate) struct TraitInfo {
    pub(crate) methods: Vec<TraitMethod>,
}

/// Information about a single impl block method
#[derive(Debug, Clone)]
pub(crate) struct ImplMethodInfo {
    pub(crate) params: Vec<Param>,
    pub(crate) return_type: Option<TypeExpr>,
    pub(crate) body: Block,
}

/// Information about an impl block
#[derive(Debug, Clone)]
pub(crate) struct ImplInfo {
    pub(crate) trait_name: Option<String>,
    pub(crate) type_name: String,
    pub(crate) methods: HashMap<String, ImplMethodInfo>,
    pub(crate) associated_types: Vec<(String, TypeExpr)>,
}

/// Information about a generic function declaration (not yet monomorphized)
#[derive(Debug, Clone)]
pub(crate) struct GenericFnInfo {
    pub(crate) type_params: Vec<TypeParam>,
    pub(crate) params: Vec<Param>,
    pub(crate) return_type: Option<TypeExpr>,
    pub(crate) body: Block,
}

pub struct Codegen<'ctx> {
    pub context: &'ctx Context,
    pub module: Module<'ctx>,
    pub builder: Builder<'ctx>,
    pub(crate) variables: Vec<HashMap<String, (PointerValue<'ctx>, Type)>>,
    pub(crate) functions: HashMap<String, FunctionValue<'ctx>>,
    pub(crate) type_checker: TypeChecker,
    pub(crate) loop_exit_blocks: Vec<(inkwell::basic_block::BasicBlock<'ctx>, Option<PointerValue<'ctx>>)>,
    pub(crate) current_fn_return_type: Option<Type>,
    pub(crate) imported_globals: HashMap<String, (String, Type)>,
    pub(crate) traits: HashMap<String, TraitInfo>,
    pub(crate) impls: Vec<ImplInfo>,
    pub(crate) generic_fns: HashMap<String, GenericFnInfo>,
    pub(crate) monomorphized: HashSet<String>,
    pub(crate) named_types: HashMap<String, Type>,
    pub(crate) global_mutables: HashMap<String, Type>,
    pub(crate) scope_vars: Vec<Vec<(String, Type)>>,
    pub static_methods: HashMap<(String, String), String>,
    pub fn_return_types: HashMap<String, Type>,
    pub(crate) json_parse_hint: Option<Type>,
    pub(crate) deferred_stmts: Vec<Expr>,
    pub source_file: String,
}

impl<'ctx> Codegen<'ctx> {
    pub fn new(context: &'ctx Context, module_name: &str) -> Self {
        let module = context.create_module(module_name);
        let builder = context.create_builder();

        Self {
            context,
            module,
            builder,
            variables: vec![HashMap::new()],
            functions: HashMap::new(),
            type_checker: TypeChecker::new(),
            loop_exit_blocks: Vec::new(),
            current_fn_return_type: None,
            imported_globals: HashMap::new(),
            traits: HashMap::new(),
            impls: Vec::new(),
            generic_fns: HashMap::new(),
            monomorphized: HashSet::new(),
            named_types: HashMap::new(),
            global_mutables: HashMap::new(),
            scope_vars: Vec::new(),
            static_methods: HashMap::new(),
            fn_return_types: HashMap::new(),
            json_parse_hint: None,
            deferred_stmts: Vec::new(),
            source_file: String::new(),
        }
    }

    pub fn compile_program(&mut self, program: &Program) {
        self.type_checker.check_program(program);
        self.declare_runtime_functions();

        for stmt in &program.statements {
            match stmt {
                Statement::TypeDecl { name, value, .. } => {
                    let ty = self.type_checker.resolve_type_expr(value);
                    let named_ty = match ty {
                        Type::Struct { fields, .. } => Type::Struct {
                            name: Some(name.clone()),
                            fields,
                        },
                        other => other,
                    };
                    self.named_types.insert(name.clone(), named_ty);
                }
                Statement::TraitDecl { name, methods, .. } => {
                    self.traits.insert(name.clone(), TraitInfo {
                        methods: methods.clone(),
                    });
                }
                Statement::ImplBlock { trait_name, type_name, methods, associated_types, .. } => {
                    let mut method_map = HashMap::new();
                    for m in methods {
                        if let Statement::FnDecl { name, params, return_type, body, .. } = m {
                            method_map.insert(name.clone(), ImplMethodInfo {
                                params: params.clone(),
                                return_type: return_type.clone(),
                                body: body.clone(),
                            });
                        }
                    }
                    self.impls.push(ImplInfo {
                        trait_name: trait_name.clone(),
                        type_name: type_name.clone(),
                        methods: method_map,
                        associated_types: associated_types.clone(),
                    });
                }
                Statement::FnDecl { name, type_params, params, return_type, body, .. } => {
                    if !type_params.is_empty() {
                        self.generic_fns.insert(name.clone(), GenericFnInfo {
                            type_params: type_params.clone(),
                            params: params.clone(),
                            return_type: return_type.clone(),
                            body: body.clone(),
                        });
                    }
                }
                Statement::Mut { name, value, type_ann, .. } => {
                    let ty = type_ann
                        .as_ref()
                        .map(|t| self.type_checker.resolve_type_expr(t))
                        .unwrap_or_else(|| self.infer_type(value));
                    let llvm_ty = self.type_to_llvm_basic(&ty);
                    let global = self.module.add_global(llvm_ty, None, name);
                    global.set_initializer(&llvm_ty.const_zero());
                    self.global_mutables.insert(name.clone(), ty);
                }
                Statement::ExternFn { name, params, return_type, .. } => {
                    self.compile_extern_fn(name, params, return_type.as_ref());
                }
                _ => {}
            }
        }

        self.compile_all_impl_methods();

        // Declare helper functions (snprintf, route helpers, etc.)
        self.declare_provider_functions();

        for stmt in &program.statements {
            if let Statement::FnDecl { name, type_params, params, return_type, .. } = stmt {
                if type_params.is_empty() {
                    self.declare_function(name, params, return_type.as_ref());
                }
            }
        }

        for stmt in &program.statements {
            self.compile_statement(stmt);
        }

        if self.module.get_function("main").is_none() {
            let has_startup = self.module.get_function("__forge_startup").is_some();
            let has_main_end = self.module.get_function("__forge_main_end").is_some();
            if has_startup || has_main_end {
                let i32_type = self.context.i32_type();
                let fn_type = i32_type.fn_type(&[], false);
                let function = self.module.add_function("main", fn_type, None);
                self.functions.insert("main".to_string(), function);
                let entry = self.context.append_basic_block(function, "entry");
                self.builder.position_at_end(entry);
                if let Some(startup_fn) = self.module.get_function("__forge_startup") {
                    self.builder.build_call(startup_fn, &[], "").unwrap();
                }
                if let Some(main_end_fn) = self.module.get_function("__forge_main_end") {
                    self.builder.build_call(main_end_fn, &[], "").unwrap();
                }
                self.builder.build_return(Some(&i32_type.const_zero())).unwrap();
            }
        }
    }

    pub fn compile_module_program(&mut self, program: &Program, module_path: &str) {
        if self.module.get_function("forge_println_string").is_none() {
            self.declare_runtime_functions();
        }

        let prefix = module_path.replace('.', "_");
        self.type_checker.check_program(program);

        for stmt in &program.statements {
            if let Statement::FnDecl { name, params, return_type, .. } = stmt {
                let mangled = format!("{}_{}", prefix, name);
                self.declare_function(&mangled, params, return_type.as_ref());
            }
        }

        for stmt in &program.statements {
            match stmt {
                Statement::FnDecl { name, params, return_type, body, .. } => {
                    let mangled = format!("{}_{}", prefix, name);
                    self.compile_fn(&mangled, params, return_type.as_ref(), body);
                }
                Statement::Let { name, value, type_ann, exported: true, .. }
                | Statement::Const { name, value, type_ann, exported: true, .. } => {
                    let mangled = format!("{}_{}", prefix, name);
                    self.compile_exported_global(&mangled, value, type_ann.as_ref());
                }
                _ => {}
            }
        }
    }

    fn compile_exported_global(
        &mut self,
        mangled_name: &str,
        value: &Expr,
        type_ann: Option<&TypeExpr>,
    ) {
        let ty = type_ann
            .map(|t| self.type_checker.resolve_type_expr(t))
            .unwrap_or_else(|| self.infer_type(value));

        match value {
            Expr::IntLit(n, _) => {
                let llvm_ty = self.context.i64_type();
                let global = self.module.add_global(llvm_ty, None, mangled_name);
                global.set_initializer(&llvm_ty.const_int(*n as u64, true));
                global.set_constant(true);
            }
            Expr::FloatLit(n, _) => {
                let llvm_ty = self.context.f64_type();
                let global = self.module.add_global(llvm_ty, None, mangled_name);
                global.set_initializer(&llvm_ty.const_float(*n));
                global.set_constant(true);
            }
            Expr::BoolLit(b, _) => {
                let llvm_ty = self.context.i8_type();
                let global = self.module.add_global(llvm_ty, None, mangled_name);
                global.set_initializer(&llvm_ty.const_int(if *b { 1 } else { 0 }, false));
                global.set_constant(true);
            }
            Expr::StringLit(s, _) => {
                let string_type = self.string_type();
                let global = self.module.add_global(string_type, None, mangled_name);
                global.set_initializer(&string_type.const_zero());

                let init_name = format!("{}_init", mangled_name);
                let fn_type = self.context.void_type().fn_type(&[], false);
                let init_fn = self.module.add_function(&init_name, fn_type, None);
                let entry = self.context.append_basic_block(init_fn, "entry");
                self.builder.position_at_end(entry);

                let str_val = self.build_string_literal(s);
                self.builder
                    .build_store(global.as_pointer_value(), str_val)
                    .unwrap();
                self.builder.build_return(None).unwrap();
            }
            _ => {
                let llvm_ty = self.type_to_llvm_basic(&ty);
                let global = self.module.add_global(llvm_ty, None, mangled_name);
                global.set_initializer(&llvm_ty.const_zero());
            }
        }
    }

    pub fn inject_imports(&mut self, imports: &[ResolvedImport]) {
        for import in imports {
            match &import.symbol {
                ExportedSymbol::Function { .. } => {
                    if let Some(func) = self.module.get_function(&import.mangled_name) {
                        self.functions.insert(import.local_name.clone(), func);
                    }
                }
                ExportedSymbol::Value { value, .. } => {
                    self.imported_globals.insert(
                        import.local_name.clone(),
                        (import.mangled_name.clone(), self.infer_type_from_expr(value)),
                    );
                }
            }
        }
    }

    pub fn emit_ir(&self) -> String {
        self.module.print_to_string().to_string()
    }
}
